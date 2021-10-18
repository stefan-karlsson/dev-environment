Import-Module -Name ./scripts/utils.ps1
Import-Module -Name ./scripts/windows.ps1
Import-Module -Name ./scripts/mac-os.ps1
Import-Module -Name ./scripts/linux.ps1

$ErrorActionPreference = "Stop"

function Invoke-Script {
    param(
        [Parameter (Mandatory = $true)] [string]$ProfileName,
        [Parameter (Mandatory = $false)] [bool]$Force
    )
    
    # Allow PowerShell to execute
    Set-ExecutionPolicy Bypass -Scope Process -Force; 

    # Assert the script execution is done using administrator privileges.
    Assert-Administrator

    # Create default Context
    $Context = [PSCustomObject]@{
        Config = Get-Config
        Force  = $Force
    }

    # Add 'Profile' to the Context
    $ActiveProfile = Get-Profile($ProfileName)
    $Context | Add-Member -MemberType NoteProperty -Name 'Profile' -Value $ActiveProfile

    Invoke-Profile($Context)
}

function Invoke-Profile {
    param(
        [Parameter (Mandatory = $true)] [PSCustomObject]$Context
    )

    Write-Host "Setting up development environment for profile: $($Context.Profile.Name)"
    
    if ($IsLinux) {
        Install-OnLinux($Context)
    }
    if ($IsMacOS) {
        Install-OnMacOs(Context)
    }
    if ($IsWindows) {
        Install-OnWindows($Context)
    }
}

Invoke-Script("windows-profile")


