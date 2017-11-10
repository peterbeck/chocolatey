# Virtio Drivers for Windows VMs running on KVM
# 2011-2017 foo.li systeme + software
    
# export installed redhat certificate to a file with win7
# $CertToExport = dir cert:\LocalMachine -Recurse | where {$_.ThumbPrint -eq "66ED6843B0F6DC9B636C6814E53A26983EF32B4E"}
# $CertToExportInBytesForCERFile = $CertToExport.export("Cert")
# [system.IO.file]::WriteAllBytes("C:\Temp\RedHat.cer", $CertToExportInBytesForCERFile)

$packageName	= 'kvm-virtio-drivers'
$version        = '0.1.141'
$url		= 'https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso'
$url64          = $url
$virtioPath	= "$env:SystemDrive" + "\Virtio_" + $version
$scriptPath     = $(Split-Path $MyInvocation.MyCommand.Path)
$dpinst         = Join-Path $scriptPath 'dpinstX86.exe'
$dpinst64       = Join-Path $scriptPath 'dpinstX64.exe'
$dpinstxml      = Join-Path $scriptPath 'dpinst.xml'
$cleanupdrv     = Join-Path $scriptPath 'cleanfolder.ps1'
$checksum	= '43AEFA812C37342CFEFC48EC0DD7F1E56A930FCD'
$checksumType	= 'sha1'
$checksum64	= $checksum
$checksumType64 = $checksumType

$cert = ls cert: -Recurse | ? { $_.Thumbprint -eq '66ED6843B0F6DC9B636C6814E53A26983EF32B4E' }
if (!$cert) {
  Write-Debug 'adding RedHat certificate to TrustedPublishers'
  $toolsPath = Split-Path $MyInvocation.MyCommand.Definition
  Start-ChocolateyProcessAsAdmin "certutil -addstore 'TrustedPublisher' '$toolsPath\RedHat.cer'"
}

if ([System.Environment]::Is64BitProcess) {
#if ($env:PROCESSOR_ARCHICTECTURE -eq 'AMD64') { #does not work when run in choco ?!
  $dpinstsrc = $dpinst64
  $dpinstbin = "${virtioPath}\${dpinst64}"
  $dpinstaller = "${virtioPath}\dpinstX64.exe"
  $arch = 'amd64'
} else {
  $dpinstsrc = $dpinst
  $dpinstbin = "${virtioPath}\${dpinst}"
  $dpinstaller = "${virtioPath}\dpinstX86.exe"
  $arch = 'x86'
}

try {
  if (!(Test-Path $virtioPath)) {
    New-Item $virtioPath -ItemType Directory
  }
  Write-Host 'unzipping files to ' $virtioPath
  Write-Host "[INFO]: use the package 'qemu-guest-agent' to install the QEMU Guest Agent."
  Install-ChocolateyZipPackage -PackageName $packageName -Url $url -UnzipLocation $virtioPath `
      -checksum $checksum -checksumType $checksumType -checksum64 -$checksum64 -checksumType64 $checksumType64
  Copy-Item -Path $dpinstsrc -Destination $virtioPath #-ErrorAction SilentlyContinue
  Copy-Item -Path $dpinstxml -Destination $virtioPath #-ErrorAction SilentlyContinue

  #Remove unneeded architectures and os first to avoid installing wrong drivers and safe space
  $lvl1 = (Get-ChildItem -Path $virtioPath -Exclude qemupciserial | ?{ $_.PSIsContainer } | % { $_.FullName })

  $OS = (Get-WmiObject -class Win32_OperatingSystem).Caption

  switch -wildcard -casesensitive ($OS) {
    "*Windows 7*" { Write-Host "Windows 7 detected";$d="w7";break}
    "*Windows 10*" { Write-Host "Windows 10 detected";$d="w10";break }
    "*Server 2003*" { Write-Host "Server 2003 detected";$d="2k3";break }
    "*Server 2008 R2*" { Write-Host "Server 2008 R2 detected";$d="2k8R2";break }
    "*Server* 2008*" { Write-Host "Server 2008 detected";$d="2k8";break } #copyright logo, really ?! fucking windows world
    "*Server 2012 R2*" { Write-Host "Server 2012 R2 detected";$d="2k12R2";break }
    "*Server 2012*" { Write-Host "Server 2012 detected";$d="2k12";break }
    "*Server 2016*" { Write-Host "Server 2016 detected";$d="2k16";break }
    default {"unknown/unsupported os"; exit 1 }
  }

  #os detection/removal currently tested with: win7x64,win10x64,2008,2008R2,2012R2,2016
  $wrongos = (Get-ChildItem -Path $lvl1 -Recurse -Exclude $d| ?{ $_.PSIsContainer -and $_.FullName -notlike "*$d*" })
  if (!($wrongos -eq $null)) { #do not run a second time when there is nothing to do
    Write-Host "removing unneeded Operating Systems.."
    foreach ($dir in $wrongos) {
      Remove-Item $dir.FullName -Recurse -Force -ea SilentlyContinue
    }
  }

  $wrongarch = (Get-ChildItem -Path $lvl1 -Recurse | ?{ $_.PSIsContainer -and $_.FullName -notlike "*$arch*" -and $_.FullName -notlike "*$d" })
  if (!($wrongarch -eq $null)) { #do not run a second time when there is nothing to do
    Write-Host "removing unneeded architecture..."
    foreach ($archdir in $wrongarch) {
      foreach ($ad in $archdir) {
	if ($ad -notlike "*$arch*") {
	  Remove-Item $ad.FullName -Recurse -Force -ea SilentlyContinue
	}
      }
    }
  }

  #we do not need virtual floppy images, save some space ;-)
  Remove-Item -Path "${virtioPath}\virtio-win-${version}_amd64.vfd" -Force -ErrorAction SilentlyContinue
  Remove-Item -Path "${virtioPath}\virtio-win-${version}_x86.vfd" -Force -ErrorAction SilentlyContinue

  Write-Host 'trying to install drivers from' $virtioPath '.This may take a while...'
  $cleanupdrv
  Write-Host 'even the package setup finishes successfully,'
  Write-Host 'the driver wizard will still run for quiet some time.'
  #Start-ChocolateyProcessAsAdmin -Statements "/q /se /sw /sa /path $virtioPath" -ExeToRun $dpinstaller
  & $dpinstaller /S /SA /SE /SW /PATH $virtioPath
  Write-Host '[INFO]: The Logfile for the driver installations is %windir%\DPINST.LOG' 
  Write-Host '[INFO]: removing previous virtio-driver versions'
  Remove-Item "${env:SystemDrive}\Virtio_0.1.126" -Force -Recurse -ErrorAction SilentlyContinue
} catch {
  throw $_.Exception
}
