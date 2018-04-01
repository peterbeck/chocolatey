# Kopano DeskApp
# 2017-2018 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'kopano-deskapp-nightly'
$packageSearch  = 'Kopano DeskApp'
$installerType  = 'msi'
$silentArgs     = '/qb'
$version        = '1.7.6'
$url            = 'https://download.kopano.io/community/deskapp:/Windows/kopano-deskapp-' + $version + '-x86.msi'
$url64          = 'https://download.kopano.io/community/deskapp:/Windows/kopano-deskapp-' + $version + '-x64.msi'
$checksum       = '849B095DA63F9357D99A6F4C5B746004B4C0699E'
$checksumType   = 'sha1'
$checksum64     = '0D3652D7C07686319FD2CB373CDE774C94A9321D'
$checksumType64 = $checksumType

try {   
    $app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
            -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }

    if ($app -and ([version]$app.DisplayVersion -ge [version]$version)) {
        Write-Output $(
        'Kopano DeskApp ' + $version + ' or greater is already installed. ' +
        'No need to download and install again. Otherwise uninstall first.'
        )
    } else {
        Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
                    -checksum $checksum -checksumType $checksumType `
                    -checksum64 $checksum64 -checksumType64 $checksumType64
    }           
} catch {
    throw $_.Exception
}
