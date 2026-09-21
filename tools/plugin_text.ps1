<#
.SYNOPSIS
    Wandelt NightsHarvest.esp und den Spriggit-Text in plugin-text\ ineinander um (E17).

.DESCRIPTION
    ToPlugin : plugin-text\ (YAML) -> Data\NightsHarvest.esp, danach kanonisch neu nach plugin-text\ geschrieben
               (Mutagen laesst Standardwerte weg, so bleibt der Text stabil und diff-bar).
    ToText   : Data\NightsHarvest.esp -> plugin-text\ (nach einer CK-Session, nach sync_dev.ps1 -Direction FromDev).

    Ein-Schreiber-Regel: ToPlugin verweigert das Ueberschreiben, wenn das ESP neuer ist als der neueste
    Text (dann steckt vermutlich eine CK-Aenderung drin, die noch nicht exportiert wurde). Erst ToText
    ausfuehren, oder mit -Force bewusst ueberschreiben.
    Schreibt nur im Repo (Data\, plugin-text\) und im Temp-Ordner.

.EXAMPLE
    powershell -File tools\plugin_text.ps1 -Direction ToPlugin
    powershell -File tools\plugin_text.ps1 -Direction ToText
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateSet('ToPlugin', 'ToText')][string]$Direction,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$sprig = Join-Path $repo '.tools\Spriggit\Spriggit.CLI.exe'
$text = Join-Path $repo 'plugin-text'
$esp = Join-Path $repo 'Data\NightsHarvest.esp'
$pkgVersion = '0.41.0'
if (-not (Test-Path -LiteralPath $sprig)) { throw "Spriggit fehlt: $sprig" }

function Invoke-Spriggit([string[]]$SpriggitArgs) {
    $out = & $sprig @SpriggitArgs 2>&1
    if ($LASTEXITCODE -ne 0) { $out | Select-Object -Last 15 | ForEach-Object { Write-Host $_ }; throw "Spriggit fehlgeschlagen (Exitcode $LASTEXITCODE)" }
}

function Export-Text {
    # Erst in einen Temp-Ordner, dann den Inhalt von plugin-text\ ersetzen (keine verwaisten Dateien).
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ("nhv_text_" + [guid]::NewGuid().ToString('N'))
    try {
        Invoke-Spriggit @('convert-from-plugin', '--InputPath', $esp, '--OutputPath', $tmp,
                          '--GameRelease', 'SkyrimSE', '--PackageName', 'Spriggit.Yaml', '--PackageVersion', $pkgVersion)
        Get-ChildItem -LiteralPath $text -Force | Where-Object { $_.Name -ne '.gitkeep' } | Remove-Item -Recurse -Force
        Copy-Item -Path (Join-Path $tmp '*') -Destination $text -Recurse -Force
    } finally {
        if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force }
    }
    $n = @(Get-ChildItem $text -Recurse -File | Where-Object { $_.Name -ne '.gitkeep' }).Count
    Write-Host "plugin-text\ geschrieben ($n Dateien)."
}

if ($Direction -eq 'ToText') {
    if (-not (Test-Path -LiteralPath $esp)) { throw "Kein ESP: $esp" }
    Export-Text
    return
}

# ToPlugin
$newestText = Get-ChildItem $text -Recurse -File | Where-Object { $_.Name -ne '.gitkeep' } | Sort-Object LastWriteTimeUtc -Descending | Select-Object -First 1
if (-not $newestText) { throw "plugin-text\ ist leer." }
if ((Test-Path -LiteralPath $esp) -and -not $Force) {
    if ((Get-Item -LiteralPath $esp).LastWriteTimeUtc -gt $newestText.LastWriteTimeUtc) {
        throw "Abbruch (Ein-Schreiber-Regel): Data\NightsHarvest.esp ist neuer als der Text. Vermutlich eine CK-Aenderung. Erst 'ToText' ausfuehren oder -Force."
    }
}
$tmpEsp = Join-Path ([IO.Path]::GetTempPath()) ("NightsHarvest_" + [guid]::NewGuid().ToString('N') + '.esp')
try {
    Invoke-Spriggit @('convert-to-plugin', '--InputPath', $text, '--OutputPath', $tmpEsp)
    if (-not (Test-Path -LiteralPath $tmpEsp)) { throw 'Spriggit hat kein ESP erzeugt.' }
    New-Item -ItemType Directory -Force (Split-Path -Parent $esp) | Out-Null
    Copy-Item -LiteralPath $tmpEsp -Destination $esp -Force
} finally {
    if (Test-Path -LiteralPath $tmpEsp) { Remove-Item -LiteralPath $tmpEsp -Force }
}
Write-Host ("ESP geschrieben: {0} ({1} Bytes)" -f $esp, (Get-Item -LiteralPath $esp).Length)
Export-Text
