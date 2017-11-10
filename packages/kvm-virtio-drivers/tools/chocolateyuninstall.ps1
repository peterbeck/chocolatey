# Spice Guest Tools Removal
# 2017 foo.li systeme + software

$packageName	= 'kvm-virito-drivers'
$version        = '0.1.126'
$virtioPath	= "$env:SystemDrive" + "\Virtio_" + $version

try {
  if (Test-Path $virtioPath) {
    Write-Host 'removing directory ' $virtioPath
    Remove-Item $virtioPath -Recurse -Force 
  } else {
    Write-Host 'could not detect ' $virtioPath ' files.'
  }
  Write-Host '[NOTE]: this does not remove any installed drivers, just the sourcefiles.'
} catch {
  throw $_.Exception
}
