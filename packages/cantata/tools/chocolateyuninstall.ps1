# Cantata uninstaller
# chocolatey auto uninstaller does not uninstall...

$packageName	= 'cantata'
$silentArgs 	= '/S'

if (Test-Path "$env:ProgramFiles\Cantata\uninstall.exe") {
    & "$env:ProgramFiles\Cantata\uninstall.exe" $silentArgs
} elseif (Test-Path "${env:ProgramFiles(x86)}\Cantata\uninstall.exe") {
    & "${env:ProgramFiles(x86)}\Cantata\uninstall.exe" $silentArgs
} else {
	Write-Host 'Cantata is already uninstalled.'
}