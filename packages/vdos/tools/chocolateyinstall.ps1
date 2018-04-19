# vDOS for Windows
# 2011-2018 foo.li systeme + software

# download site has ssl issues, setup is included in package...

# package installs to 'default' location: c:\vDOS 

$packageName	= 'vdos'
$version        = '2017.08.01'
$installerType	= 'exe'
$scriptPath     =  $(Split-Path $MyInvocation.MyCommand.Path)
$setupFullPath  = Join-Path $scriptPath 'vDosSetup.exe'
$silentArgs     = '/VERYSILENT /NORESTART /SP-'

try {
    Install-ChocolateyPackage $packageName $installerType $silentArgs $setupFullPath
    Remove-Item $setupFullPath -ErrorAction SilentlyContinue
} catch {
    throw $_.Exception
}