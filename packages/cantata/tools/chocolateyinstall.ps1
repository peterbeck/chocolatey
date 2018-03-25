# Cantata
# 2018 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'cantata'
$packageSearch  = 'Cantata'
$installerType  = 'exe'
$silentArgs     = '/S'
$version        = '2.2.0'
$url            = 'https://github.com/CDrummond/cantata/releases/download/v' + $version + '/Cantata-' + $version + '-Setup.exe'
$url64          = $url
$checksum       = 'C639415127FE649FBB86062EAFCA4889F9EE34E5'
$checksumType   = 'sha1'
$checksum64     = $checksum
$checksumType64 = $checksumType

Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
	-checksum $checksum -checksumType $checksumType `
	-checksum64 $checksum64 -checksumType64 $checksumType64