# Kopano DeskApp
# 2017 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'kopano-deskapp-nightly'
$packageSearch  = 'Kopano DeskApp'
$installerType  = 'msi'
$silentArgs     = '/qb'
$version        = '1.4.4'
$url            = 'https://download.kopano.io/community/deskapp:/Windows/kopano-deskapp-' + $version + '-x86.msi'
$url64          = 'https://download.kopano.io/community/deskapp:/Windows/kopano-deskapp-' + $version + '-x64.msi'
$checksum       = '6C65507470C2113A0E8B925DECE2046696AFD797'
$checksumType   = 'sha1'
$checksum64     = 'B7356125768C2AC699913EEF5A4919684F6AA912'
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
