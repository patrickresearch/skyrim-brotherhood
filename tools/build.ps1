<#
.SYNOPSIS
    Kompiliert die Night's Harvest Scripts mit Pyro gegen die Dev-Kopie des Spiels.

.DESCRIPTION
    Pyro findet den Spielordner sonst ueber die Registry (= Live-Spiel). Dieses Skript
    uebergibt immer die Dev-Kopie und bricht ab, wenn der Pfad auf das Live-Spiel zeigt.
    Ausgabe: Data\Scripts\*.pex (nicht versioniert).

.EXAMPLE
    powershell -File tools\build.ps1
    powershell -File tools\build.ps1 -Clean      # alle Scripts neu kompilieren
#>
[CmdletBinding()]
param(
    [string]$DevGame = 'C:\Dev\brotherhood-devenv\SkyrimSE-Dev',
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$pyro = Join-Path $repo '.tools\pyro\pyro.exe'
$ppj  = Join-Path $repo 'NightsHarvest.ppj'
$liveGame = 'C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition'

$full = [IO.Path]::GetFullPath($DevGame).TrimEnd('\')
if ($full -ieq $liveGame.TrimEnd('\') -or $full -like "$liveGame\*") {
    throw "Abbruch: -DevGame zeigt auf das Live-Spiel ($full). Der Build laeuft nur gegen die Dev-Kopie."
}
foreach ($p in @($pyro, $ppj, (Join-Path $full 'Papyrus Compiler\PapyrusCompiler.exe'), (Join-Path $full 'Data\Source\Scripts\TESV_Papyrus_Flags.flg'))) {
    if (-not (Test-Path -LiteralPath $p)) { throw "Fehlt: $p" }
}

$pyroArgs = @('-g', 'sse', '--game-path', $full, $ppj)
if ($Clean) { $pyroArgs = @('--no-incremental-build') + $pyroArgs }

Push-Location $repo
try {
    $out = & $pyro @pyroArgs 2>&1 | Tee-Object -Variable pyroOut
    $code = $LASTEXITCODE
} finally {
    Pop-Location
}
if ($code -ne 0) { Write-Error "Pyro-Build fehlgeschlagen (Exitcode $code)"; exit $code }
# Pyro exits with 0 even when a script does not compile (26.09.2026), so the log decides.
if (($pyroOut | Out-String) -match 'COMPILATION FAILED|\s[1-9]\d* failed') {
    Write-Error 'Pyro-Build fehlgeschlagen: mindestens ein Script kompiliert nicht (siehe Ausgabe oben).'
    exit 1
}
$pex = Get-ChildItem (Join-Path $repo 'Data\Scripts') -Filter *.pex -ErrorAction SilentlyContinue
Write-Host ("Build ok: {0} .pex in Data\Scripts" -f @($pex).Count)
