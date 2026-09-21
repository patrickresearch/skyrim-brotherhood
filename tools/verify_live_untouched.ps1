<#
.SYNOPSIS
    Vergleicht die gesicherten Live-Dateien mit dem Backup und meldet neue Eintraege im Live-Ordner. Nur lesend.

.DESCRIPTION
    Nutzt MANIFEST.sha256 aus dem Backup-Ordner (Standard: das neueste ohne "-saves" im Namen).
    Prueft ini\, load-order-live\ und game-root-config\ gegen Documents\My Games,
    %LOCALAPPDATA%\Skyrim Special Edition und den Live-Spielordner. Zaehlt ausserdem
    Saves und Dateien im Live-Data-Ordner.
    Erwartung nach Testlaeufen ueber MO2: 0 veraenderte Dateien. Ein Ordner "__MO_Saves" oder
    neue Logs im echten Documents-Ordner werden gemeldet, weil sie zeigen, wo die Trennung leckt.

    Hinweis: Wurde inzwischen das Live-Spiel gespielt, weichen INIs und plugins.txt legitim ab.
#>
[CmdletBinding()]
param(
    [string]$BackupRoot = 'C:\Dev\brotherhood-devenv\backups',
    [string]$Backup
)

$ErrorActionPreference = 'Stop'
if (-not $Backup) {
    $Backup = (Get-ChildItem $BackupRoot -Directory | Where-Object { $_.Name -notlike '*-saves' } | Sort-Object Name -Descending | Select-Object -First 1).FullName
}
if (-not $Backup -or -not (Test-Path (Join-Path $Backup 'MANIFEST.sha256'))) { throw "Kein Backup mit MANIFEST.sha256 gefunden." }

$docs = Join-Path $env:USERPROFILE 'Documents\My Games\Skyrim Special Edition'
$map = [ordered]@{
    'ini\'              = "$docs\"
    'load-order-live\'  = (Join-Path $env:LOCALAPPDATA 'Skyrim Special Edition') + '\'
    'game-root-config\' = 'C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition\'
}

$same = 0; $changed = @(); $missing = @()
foreach ($line in Get-Content (Join-Path $Backup 'MANIFEST.sha256')) {
    $hash, $rel = $line -split '  ', 2
    foreach ($k in $map.Keys) {
        if (-not $rel.StartsWith($k)) { continue }
        $live = Join-Path $map[$k] $rel.Substring($k.Length)
        if (-not (Test-Path -LiteralPath $live)) { $missing += $rel; continue }
        if ((Get-FileHash -LiteralPath $live -Algorithm SHA256).Hash -eq $hash) { $same++ } else { $changed += $rel }
    }
}

Write-Host "Backup: $Backup"
Write-Host "Live-Dateien identisch: $same | veraendert: $($changed.Count) | fehlend: $($missing.Count)"
$changed | ForEach-Object { Write-Host "  veraendert: $_" }
$missing | ForEach-Object { Write-Host "  fehlt:      $_" }

$known = @('Saves', 'SKSE', 'Skyrim.ini', 'Skyrim.ini.baked', 'Skyrim.ini.base', 'SkyrimCustom.ini', 'SkyrimCustom.ini.baked',
           'SkyrimCustom.ini.base', 'SkyrimPrefs.ini', 'SkyrimPrefs.ini.bak-4k', 'SkyrimPrefs.ini.bak-dsr-3840',
           'SkyrimPrefs.ini.baked', 'SkyrimPrefs.ini.base')
$new = Get-ChildItem $docs -Force | Where-Object { $known -notcontains $_.Name }
if ($new) { Write-Host 'Neue Eintraege in Documents\My Games (Leck der Trennung?):'; $new | ForEach-Object { Write-Host "  $($_.Name)" } }
else { Write-Host 'Keine neuen Eintraege in Documents\My Games.' }

$saves = @(Get-ChildItem (Join-Path $docs 'Saves') -File -Recurse -Force).Count
Write-Host "Live-Saves: $saves (Backup vom 22.09.: 2683, mehr ist normal, wenn das Live-Spiel gespielt wurde)"
Write-Host ("Dateien im Live-Data-Ordner: {0} (Backup-Stand: 362)" -f @(Get-ChildItem 'C:\Program Files (x86)\Steam\steamapps\common\Skyrim Special Edition\Data' -File).Count)
