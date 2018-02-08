#Joplin uninstaller

if (Test-Path "$env:ProgramFiles\Joplin\Uninstall Joplin.exe") {
	& "$env:ProgramFiles\Joplin\Uninstall Joplin.exe" /S
} else {
	Write-Host 'could not detect Joplin'
}