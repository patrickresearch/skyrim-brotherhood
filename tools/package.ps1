<#
.SYNOPSIS
    Baut das FOMOD-Archiv dist\NightsHarvest-<Version>.7z (Struktur: docs/ARCHITECTURE.md, fomod-template.md).

.DESCRIPTION
    1. Scripts kompilieren (tools\build.ps1)
    2. Scripts (und Interface\Translations, falls vorhanden) mit bsarch in NightsHarvest.bsa packen
    3. 00 Core\ mit ESP, BSA, optional SEQ; fomod\ mit info.xml und ModuleConfig.xml
    4. Alles mit 7-Zip nach dist\ packen
    Nach dist\ und in das Staging wird nur unter dem Repo geschrieben.

.EXAMPLE
    powershell -File tools\package.ps1
    powershell -File tools\package.ps1 -EspPath C:\temp\NightsHarvest.esp   # z. B. Pipeline-Test mit Dummy-ESP
#>
[CmdletBinding()]
param(
    [string]$EspPath,
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$bsarch = Join-Path $repo '.tools\pyro\tools\bsarch.exe'
$sevenZip = 'C:\Program Files\7-Zip\7z.exe'
$data = Join-Path $repo 'Data'
if (-not $EspPath) { $EspPath = Join-Path $data 'NightsHarvest.esp' }

foreach ($p in @($bsarch, $sevenZip, (Join-Path $repo 'fomod\info.xml'), (Join-Path $repo 'fomod\ModuleConfig.xml'))) {
    if (-not (Test-Path -LiteralPath $p)) { throw "Fehlt: $p" }
}
if (-not (Test-Path -LiteralPath $EspPath)) { throw "Kein ESP gefunden: $EspPath. Erst im Creation Kit speichern und tools\sync_dev.ps1 -Direction FromDev ausfuehren." }

[xml]$info = Get-Content (Join-Path $repo 'fomod\info.xml') -Raw
$version = $info.fomod.Version
if (-not $version) { throw 'fomod\info.xml enthaelt keine <Version>.' }

if (-not $SkipBuild) { & (Join-Path $PSScriptRoot 'build.ps1'); if ($LASTEXITCODE) { exit $LASTEXITCODE } }

$dist = Join-Path $repo 'dist'
$stage = Join-Path $dist 'stage'
$core = Join-Path $stage '00 Core'
$bsaSrc = Join-Path $stage '_bsa'
if (Test-Path $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
New-Item -ItemType Directory -Force $core, (Join-Path $bsaSrc 'Scripts'), (Join-Path $stage 'fomod') | Out-Null

$pex = Get-ChildItem (Join-Path $data 'Scripts') -Filter '*.pex'
if (-not $pex) { throw 'Keine .pex in Data\Scripts. Build fehlgeschlagen?' }
Copy-Item $pex.FullName (Join-Path $bsaSrc 'Scripts')
$transFiles = Get-ChildItem (Join-Path $data 'Interface\Translations') -Filter '*.txt' -ErrorAction SilentlyContinue
if ($transFiles) {
    $transDst = Join-Path $bsaSrc 'Interface\Translations'
    New-Item -ItemType Directory -Force $transDst | Out-Null
    Copy-Item $transFiles.FullName $transDst
}

& $bsarch pack $bsaSrc (Join-Path $core 'NightsHarvest.bsa') -sse -z -mt | Out-Null
if ($LASTEXITCODE -or -not (Test-Path (Join-Path $core 'NightsHarvest.bsa'))) { throw 'bsarch konnte das BSA nicht erstellen.' }

Copy-Item -LiteralPath $EspPath -Destination (Join-Path $core 'NightsHarvest.esp')
$seq = Join-Path $data 'SEQ\NightsHarvest.seq'
if (Test-Path $seq) { New-Item -ItemType Directory -Force (Join-Path $core 'SEQ') | Out-Null; Copy-Item $seq (Join-Path $core 'SEQ') }
Copy-Item (Join-Path $repo 'fomod\*') -Destination (Join-Path $stage 'fomod') -Recurse -Exclude '.gitkeep'
Remove-Item -LiteralPath $bsaSrc -Recurse -Force

$archive = Join-Path $dist "NightsHarvest-$version.7z"
if (Test-Path $archive) { Remove-Item -LiteralPath $archive -Force }
Push-Location $stage
try { & $sevenZip a -t7z -mx=5 $archive 'fomod' '00 Core' | Out-Null } finally { Pop-Location }
if ($LASTEXITCODE) { throw '7-Zip ist fehlgeschlagen.' }

Write-Host "Archiv: $archive"
& $sevenZip l $archive | Select-String -Pattern '^\d{4}-\d\d-\d\d|files' | ForEach-Object { $_.Line }
