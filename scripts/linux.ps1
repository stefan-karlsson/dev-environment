function Install-OnLinux {
    param(
        [Parameter (Mandatory = $true)] [PSCustomObject]$Context
    )

    throw [System.NotImplementedException]::("Environment installer is not implemented for Linux, please write the installer script.")
}

