<#
.SYNOPSIS
    Baut das FOMOD-Archiv dist\NightsHarvest-<Version>.7z (Struktur: docs/ARCHITECTURE.md, fomod-template.md).

.DESCRIPTION
    1. Scripts kompilieren (tools\build.ps1)
    2. Stille Sprachdateien erzeugen (tools\silent_voice.py) und mit den Scripts (und Interface\Translations,
       falls vorhanden) mit bsarch unkomprimiert in NightsHarvest.bsa packen
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
# Silent voice files (E10): without them dialogue lines flash by and scene lines never play.
& python (Join-Path $PSScriptRoot 'silent_voice.py'); if ($LASTEXITCODE) { throw 'silent_voice.py ist fehlgeschlagen.' }

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

$voiceSrc = Join-Path $data 'Sound\Voice\NightsHarvest.esp'
if (Test-Path $voiceSrc) {
    $voiceDst = Join-Path $bsaSrc 'Sound\Voice\NightsHarvest.esp'
    New-Item -ItemType Directory -Force $voiceDst | Out-Null
    Copy-Item (Join-Path $voiceSrc '*') $voiceDst -Recurse -Exclude 'silent_voice.manifest'
}

# FaceGen of our own NPCs (face mesh + tint). Without it they get the dark-face bug outside the dev copy,
# where the CK wrote the files loose. Only FormIDs that still exist as NPC records in plugin-text are packed.
$npcIds = Get-ChildItem (Join-Path $repo 'plugin-text\Npcs') -Filter '*.yaml' -ErrorAction SilentlyContinue |
    ForEach-Object { if ($_.Name -match ' - ([0-9A-F]{6})_NightsHarvest\.esp\.yaml$') { '00' + $Matches[1] } }
foreach ($fg in @(@{ Rel = 'Meshes\Actors\Character\FaceGenData\FaceGeom\NightsHarvest.esp'; Ext = '.nif' },
                  @{ Rel = 'Textures\Actors\Character\FaceGenData\FaceTint\NightsHarvest.esp'; Ext = '.dds' })) {
    $src = Join-Path $data $fg.Rel
    $files = Get-ChildItem $src -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -ieq $fg.Ext -and $npcIds -contains $_.BaseName.ToUpper() }
    foreach ($id in $npcIds) {
        if (-not ($files | Where-Object { $_.BaseName.ToUpper() -eq $id })) { Write-Warning "FaceGen fehlt: $($fg.Rel)\$id$($fg.Ext) (im CK: Ctrl+F4 auf dem NPC, dann sync_dev -Direction FromDev)" }
    }
    if ($files) {
        $dst = Join-Path $bsaSrc $fg.Rel
        New-Item -ItemType Directory -Force $dst | Out-Null
        Copy-Item $files.FullName $dst
    }
}

# No -z: voice files do not play from a compressed BSA (the vanilla voice archives are uncompressed too).
& $bsarch pack $bsaSrc (Join-Path $core 'NightsHarvest.bsa') -sse -mt | Out-Null
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
