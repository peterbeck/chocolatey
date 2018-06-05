# OpenBoard Whiteboard
# 2018 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'openboard'
$packageSearch  = 'OpenBoard'
$installerType  = 'exe'
$silentArgs     = '/SILENT'
$version        = '1.4.0'
$url            = 'https://github.com/OpenBoard-org/OpenBoard/releases/download/v' + $version + '/OpenBoard_Installer_' + $version + '.exe'
$url64          = $url
$checksum       = '600AAF87AF046C503F81F664E8504D12B3DB2E0B'
$checksumType   = 'sha1'
$checksum64   	= $checksum
$checksumType64 = $checksumType

Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
    -checksum $checksum -checksumType $checksumType `
    -checksum64 $checksum64 -checksumType64 $checksumType64
