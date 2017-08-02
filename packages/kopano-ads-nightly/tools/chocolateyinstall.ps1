# Kopano ADS (mmc extension)
# 2017 foo.li systeme + software

$packageName    = 'kopano-ads-nightly'
$packageSearch  = 'Kopano ADS'
$installerType  = 'msi'
$silentArgs     = '/qb'
$version        = '1.0.71'
$intversion	= '1.0-71'
$url            = 'https://download.kopano.io/community/adextension:/KopanoADS-' + $intversion + '-noarch.msi'
$url64          = $url
$checksum       = '306C64A745CC796F38A28DC8E367EB28E90B5CC0'
$checksumType   = 'sha1'
$checksum64     = $checksum
$checksumType64 = $checksumType


try {
  $app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
				  'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
    -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }

  if ($app -and ([version]$app.DisplayVersion -ge [version]$version)) {
    Write-Output $(
	'Kopano ADS ' + $version + ' or greater is already installed. ' +
	'No need to download and install again. Otherwise uninstall first.'
	)
  } else {
    if (Get-Process 'mmc' -ea SilentlyContinue) { Stop-Process -processname 'mmc' -Force -ea SilentlyContinue }
    Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
      -checksum $checksum -checksumType $checksumType `
      -checksum64 $checksum64 -checksumType64 $checksumType64
  }           
} catch {
  throw $_.Exception
}
