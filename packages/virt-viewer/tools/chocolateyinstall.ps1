# KVM Virt Viewer for Windows
# 2011-2017 foo.li systeme + software

$packageName	= 'virt-viewer'
$version        = '6.0'
$fullversion	= '6.0.256'
$installerType	= 'msi'
$silentArgs	= '/qn /l*v ' + $env:Temp + '\virtviewer-setup.log'
$packageSearch  = 'VirtViewer*'
$validExitCodes	= @(0,3010)
$url		= 'https://virt-manager.org/download/sources/virt-viewer/virt-viewer-x86-' + $version + '.msi'
$url64		= 'https://virt-manager.org/download/sources/virt-viewer/virt-viewer-x64-' + $version + '.msi'
$checksum	= 'AE9F552D03DE132C0CA7A090B037291B726C62A9'
$checksumType	= 'sha1'
$checksum64	= '862DCB8ABAF76347EC2B529BA37B9F8EEB1DD620'
$checksumType64 = $checksumType

try {
  $app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                  'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
				  'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' ) `
	    -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }
  if ($app -and ([version]$app.DisplayVersion -ge [version]$fullversion)) {
    Write-Host $(
      "Virt Viewer " + [version]$app.DisplayVersion + " is already installed.`r`n`a"
    )
  } else {
    Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
      -checksum $checksum `
      -checksumType $checksumType `
      -checksum64 $checksum64 `
      -checksumType64 $checksumType64 `
      -validExitCodes $validExitCodes
  }
} catch {
  throw $_.Exception
}
