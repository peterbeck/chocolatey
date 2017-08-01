# Kopano Outlook Extension
# 2017 foo.li systeme + software
# https://www.gnu.org/licenses/gpl.txt

$packageName    = 'kopano-ol-extension-nightly'
$packageSearch  = 'Kopano OL Extension'
$installerType  = 'msi'
$silentArgs     = '/qb'
$version        = '1.5.217'
$intvers        = '1.5-217'
$url            = 'https://download.kopano.io/community/olextension:/KopanoOLExtension-' + $intvers + '-32bit.msi'
$url64          = 'https://download.kopano.io/community/olextension:/KopanoOLExtension-' + $intvers + '-64bit.msi'
$checksum       = '66F7CD2075EC5993CABB4B903E8A9E73EE450B08'
$checksumType   = 'sha1'
$checksum64     = 'CF4587BEF7DC3F6E5B779467F61494C67AEF032F'
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
        #check for outlook
        #https://www.reddit.com/r/PowerShell/comments/47lhdt/simple_script_to_check_if_outlook_is_installed/
        #if (Get-ItemProperty HKLM:\SOFTWARE\Classes\Outlook.Application -ErrorAction SilentlyContinue) {
        #    Write-Output "Outlook found"
        #} else {
        #    Write-Output "Outlook could not be found"
        #    throw $_.Exception
        #}
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