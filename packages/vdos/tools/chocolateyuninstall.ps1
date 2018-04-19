# vDOS Removal
# 2011-2018 foo.li systeme + software

$packageName	= 'vdos'
$version        = '2017.08.01'
$vdosPath		= "$env:SystemDrive" + "\vDos"

try {
  if (Test-Path $vdosPath) {
    Write-Host 'removing directory ' $vdosPath
    Remove-Item $vdosPath -Recurse -Force 
  } else {
    Write-Host 'could not detect ' $vdosPath ' files.'
  }
} catch {
  throw $_.Exception
}