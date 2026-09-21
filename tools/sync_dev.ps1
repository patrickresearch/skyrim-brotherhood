<#
.SYNOPSIS
    Gleicht das Repo mit der Dev-Kopie des Spiels ab (nur kopieren, nie loeschen).

.DESCRIPTION
    ToDev   : kompilierte Scripts (.pex), eigene Quellen (NHV_*.psc) und optional das ESP in die Dev-Kopie.
    FromDev : das vom Creation Kit gespeicherte ESP (plus SEQ und FaceGen) zurueck ins Repo.
              Quelle ist die neuere Datei aus <Dev>\Data oder MO2\overwrite (das CK schreibt ueber MO2
              neue Dateien nach overwrite).
    Es schreibt nur in Repo und Dev-Kopie. Das ESP wird nie ueberschrieben, wenn das Ziel neuer ist
    (Ein-Schreiber-Regel), ausser mit -Force.

.EXAMPLE
    powershell -File tools\sync_dev.ps1 -Direction ToDev
    powershell -File tools\sync_dev.ps1 -Direction ToDev -IncludeEsp
    powershell -File tools\sync_dev.ps1 -Direction FromDev
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateSet('ToDev', 'FromDev')][string]$Direction,
    [string]$DevRoot = 'C:\Dev\brotherhood-devenv',
    [switch]$IncludeEsp,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$dev = Join-Path $DevRoot 'SkyrimSE-Dev'
$overwrite = Join-Path $DevRoot 'MO2\overwrite'
$liveGame = 'C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition'

$full = [IO.Path]::GetFullPath($dev).TrimEnd('\')
if ($full -ieq $liveGame -or $full -like "$liveGame\*") { throw "Abbruch: Dev-Kopie zeigt auf das Live-Spiel ($full)." }
if (-not (Test-Path (Join-Path $dev 'SkyrimSE.exe'))) { throw "Dev-Kopie nicht gefunden: $dev" }

$repoData = Join-Path $repo 'Data'
$devData = Join-Path $dev 'Data'
$esp = 'NightsHarvest.esp'

function Copy-Safe([string]$From, [string]$To, [switch]$Protect) {
    if ($Protect -and (Test-Path -LiteralPath $To) -and -not $Force) {
        if ((Get-Item -LiteralPath $To).LastWriteTimeUtc -gt (Get-Item -LiteralPath $From).LastWriteTimeUtc) {
            Write-Warning "Uebersprungen, Ziel ist neuer (Ein-Schreiber-Regel, -Force zum Ueberschreiben): $To"
            return
        }
    }
    New-Item -ItemType Directory -Force (Split-Path -Parent $To) | Out-Null
    Copy-Item -LiteralPath $From -Destination $To -Force
    Write-Host ("kopiert: {0}" -f $To)
}

if ($Direction -eq 'ToDev') {
    foreach ($f in Get-ChildItem (Join-Path $repoData 'Scripts') -Filter '*.pex' -ErrorAction SilentlyContinue) {
        Copy-Safe $f.FullName (Join-Path $devData "Scripts\$($f.Name)")
    }
    foreach ($f in Get-ChildItem (Join-Path $repoData 'Source\Scripts') -Filter 'NHV_*.psc' -ErrorAction SilentlyContinue) {
        Copy-Safe $f.FullName (Join-Path $devData "Source\Scripts\$($f.Name)")
    }
    if ($IncludeEsp) {
        $src = Join-Path $repoData $esp
        if (-not (Test-Path $src)) { throw "Kein $esp im Repo (Data\)." }
        Copy-Safe $src (Join-Path $devData $esp) -Protect
    }
    return
}

# FromDev: neueste Fassung aus Dev-Data oder MO2\overwrite
$candidates = @((Join-Path $devData $esp), (Join-Path $overwrite $esp)) | Where-Object { Test-Path -LiteralPath $_ } |
    ForEach-Object { Get-Item -LiteralPath $_ } | Sort-Object LastWriteTimeUtc -Descending
if (-not $candidates) { throw "Kein $esp in $devData oder $overwrite gefunden. Wurde im CK gespeichert?" }
$best = $candidates[0]
Write-Host ("Quelle: {0} ({1:yyyy-MM-dd HH:mm:ss})" -f $best.FullName, $best.LastWriteTime)
Copy-Safe $best.FullName (Join-Path $repoData $esp) -Protect

$extra = @('SEQ\NightsHarvest.seq',
           'Meshes\Actors\Character\FaceGenData\FaceGeom\NightsHarvest.esp',
           'Textures\Actors\Character\FaceGenData\FaceTint\NightsHarvest.esp')
foreach ($rel in $extra) {
    foreach ($base in @($devData, (Join-Path $overwrite ''))) {
        $p = Join-Path $base $rel
        if (Test-Path -LiteralPath $p) {
            if ((Get-Item -LiteralPath $p).PSIsContainer) {
                foreach ($f in Get-ChildItem -LiteralPath $p -File -Recurse) {
                    Copy-Safe $f.FullName (Join-Path $repoData ($f.FullName.Substring($base.Length).TrimStart('\')))
                }
            } else {
                Copy-Safe $p (Join-Path $repoData $rel)
            }
        }
    }
}
