function Install-OnMacOs {
    param(
        [Parameter (Mandatory = $true)] [PSCustomObject]$Context
    )

    throw [System.NotImplementedException]::("Environment installer is not implemented for Mac OS, please write the installer script.")
}

