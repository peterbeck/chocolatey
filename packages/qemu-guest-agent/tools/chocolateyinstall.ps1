# QEMU Guest Agent
# 2016-2017 foo.li systeme + software
    
$packageName	= 'qemu-guest-agent'
$version        = '7.4.5'
$installerType	= 'msi'
$url		= 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-qemu-ga/qemu-ga-win-' + $version + '-1/qemu-ga-x86.msi'
$url64          = 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-qemu-ga/qemu-ga-win-' + $version + '-1/qemu-ga-x64.msi'
$silentArgs	= '/qb'
$packageSearch	= 'QEMU guest agent*'
$checksum       = 'A5BDE210C45BC81600ABAE438D31B6BB6DF93F3C'
$checksumType	= 'sha1'
$checksum64	= '09D19C994EFA3FA41C4FE8EF249226CEB7EA0BAE'
$checksumType64 = $checksumType
$validExitCodes	= @(0,3010)

$compmanu = Get-WmiObject Win32_ComputerSystem | select manufacturer
if ($compmanu.manufacturer -like '*Bochs*') { Write-Host 'QEMU/KVM detected' }
elseif ($compmanu.manufacturer -like '*QEMU*'){ Write-Host 'QEMU/KVM detected' } 
else { 
  Write-Host 'could not detect QEMU/KVM virtual machine. Stopping deployment'
  throw 'no KVM/QEMU VM detected'
}

try {
  $app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
				  'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
    -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }

  if ($app -and ([version]$app.DisplayVersion -ge [version]$version)) {
    Write-Host 'QEMU Guest Agent' $version 'or higher is already installed. Doing nothing.' 
  } else {
    Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
      -checksum $checksum -checksumType $checksumType `
      -checksum64 $checksum64 -checksumType64 $checksumType64 `
      -validExitCodes $validExitCodes
  }
} catch {
  throw $_.Exception
}
