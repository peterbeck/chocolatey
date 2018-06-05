# Cantata
# 2018 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'cantata'
$packageSearch  = 'Cantata'
$installerType  = 'exe'
$silentArgs     = '/S'
$version        = '2.3.0'
$url            = 'https://github.com/CDrummond/cantata/releases/download/v' + $version + '/Cantata-' + $version + '-Setup.exe'
$url64          = $url
$checksum       = 'DA4E78315D03C06CDAF6A1FE1C8482DA41E357DC'
$checksumType   = 'sha1'
$checksum64     = $checksum
$checksumType64 = $checksumType

Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
	-checksum $checksum -checksumType $checksumType `
	-checksum64 $checksum64 -checksumType64 $checksumType64