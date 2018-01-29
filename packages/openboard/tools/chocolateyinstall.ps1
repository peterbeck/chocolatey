# OpenBoard Whiteboard
# 2018 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'openboard'
$packageSearch  = 'OpenBoard'
$installerType  = 'exe'
$silentArgs     = '/SILENT'
$version        = '1.3.6'
$url            = 'https://github.com/OpenBoard-org/OpenBoard/releases/download/v' + $version + '/OpenBoard_Installer_' + $version + '.exe'
$url64          = $url
$checksum       = '02A3E147D680563ED48BA54E2DE7917C42368A3B'
$checksumType   = 'sha1'
$checksum64   	= $checksum
$checksumType64 = $checksumType

try {   
	#version not in uninstaller entry, no check at the moment...
    #$app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    #                                'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
    #        -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }
	#
    #if ($app -and ([version]$app.DisplayVersion -ge [version]$version)) {
    #    Write-Output $(
    #    'OpenBoard ' + $version + ' or greater is already installed. ' +
    #    'No need to download and install again. Otherwise uninstall first.'
    #    )
    #} else {
        Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
                    -checksum $checksum -checksumType $checksumType `
                    -checksum64 $checksum64 -checksumType64 $checksumType64
    #}           
} catch {
    throw $_.Exception
}
