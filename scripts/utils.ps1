
<#
.SYNOPSIS
Assert that the session is executed using administrator role
#>
function Assert-Administrator {
    $principalId = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($principalId)

    if (!$principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) { 
        throw "Script needs to be executed using a administrator role."; 
    }      
}

<#
.SYNOPSIS
Get major PowerShell version installed
#>
function Get-MajorVersionOfPowerShell {
    return $PSVersionTable.PSVersion.Major
}

<#
.SYNOPSIS
Gets a single profile
#>
function Get-Profile {
    param(
        [Parameter (Mandatory = $true)] [string]$ProfileName
    )

    $profilePath = Resolve-Path -Path **/$ProfileName.json -Relative

    return Get-Content $profilePath -Encoding UTF8 -Raw | ConvertFrom-Json
}

<#
.SYNOPSIS
Gets the configuration for this script
#>
function Get-Config {
    return Get-Content config.json -Encoding UTF8 -Raw | ConvertFrom-Json
}