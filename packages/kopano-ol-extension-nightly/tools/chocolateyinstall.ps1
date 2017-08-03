# Kopano Outlook Extension
# 2017 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'kopano-ol-extension-nightly'
$packageSearch  = 'Kopano OL Extension'
$installerType  = 'msi'
$silentArgs     = '/qb'
$version        = '1.5.218'
$intvers        = '1.5-218'
$url            = 'https://download.kopano.io/community/olextension:/KopanoOLExtension-' + $intvers + '-32bit.msi'
$url64          = 'https://download.kopano.io/community/olextension:/KopanoOLExtension-' + $intvers + '-64bit.msi'
$checksum       = 'B5F74283C016F3CB907D8A603D4D980F4F05E2B1'
$checksumType   = 'sha1'
$checksum64     = 'AB4DDC7BD795D1E544807AB1D313D55D6988E787'
$checksumType64 = $checksumType

try {   
    $app = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
            -ErrorAction:SilentlyContinue | Where-Object { $_.DisplayName -like $packageSearch }

    if ($app -and ([version]$app.DisplayVersion -ge [version]$version)) {
        Write-Host -ForegroundColor DarkYellow $(
        "Kopano OL Extension " + $version + " or greater is already installed. `n" +
        "No need to download and install again. Otherwise uninstall first."
        )
    } else {
        if (get-wmiobject Win32_Product |where {$_.Name -like "*Outlook*" -and $_.Version -ge "15"}) {
            Write-Output "Outlook 2013 (or higher) seems to be present"
            Install-ChocolateyPackage $packageName $installerType $silentArgs $url $url64 `
                        -checksum $checksum -checksumType $checksumType `
                        -checksum64 $checksum64 -checksumType64 $checksumType64
        } else {
            Write-Output "unsupported (or no) Outlook Version detected"
            throw $_.Exception
        }
    }
} catch {
    throw $_.Exception
}
