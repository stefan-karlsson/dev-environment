function Install-OnWindows {
    param(
        [Parameter (Mandatory = $true)] [PSCustomObject]$Context
    )
    
    Install-Chocolatey
    Install-BoxStarter

    if (Get-MajorVersionOfPowerShell -ge $Context.Config.Prerequisite.PowerShell) {
        Write-Warning "Minumum required PowerShell version to run this script is $($Context.Config.Prerequisite.PowerShell)"
        choco install powershell-core -y -r --execution-timeout $Config.Timeout --log-file $Config.LogFile
    }

    Install-Applications($Context)
    Configure-Windows($Context)
}

function Install-Chocolatey {
    Write-Host "Installing Chocolatey"

    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-BoxStarter {
    choco install boxstarter -y -r --execution-timeout $Config.Timeout --log-file $Config.LogFile
}

<#
.SYNOPSIS
Installs all the applications existing in Profile
#>
function Install-Applications {

    param(
        [Parameter (Mandatory = $true)] [PSCustomObject]$Context
    )

    foreach ($Application in $Context.Profile.Applications) {    
        # TODO: Join all package names and run the command once.
        choco install $Application.PackageName --confirm --accept-license --limit-output --execution-timeout $Context.Config.Timeout --log-file $Context.Config.LogFile
        
        # if ($Application.PackageName -eq "nvm") {
        #     Initialize-NvmPath
        # }

        # if ($Application.Commands) {
        #     Invoke-Commands($Application.Commands);
        # }
    }
}

function Invoke-Commands {

    param(
        [Parameter (Mandatory = $true)] [string[]]$Commands
    )

    foreach ($Command in $Commands) {
        Write-Host "Invoking command $Command" 
    
        Invoke-Expression $Command
    }
}

# Requires WSL2
# TODO: Fix for nvm, node and npm
# function Initialize-NvmPath {
#     $ENV:NVM_DIR = "$HOME/.nvm"
#     $bashPathWithNvm = Invoke-Expression 'source $NVM_DIR/nvm.sh && echo $PATH'
#     $env:PATH = $bashPathWithNvm
# }

# function nvm {
#     $quotedArgs = ($args | ForEach-Object { "'$_'" }) -join ' '
#     $command = 'source $NVM_DIR/nvm.sh && nvm {0}' -f $quotedArgs
#     Invoke-Expression $command
# }

function Configure-Windows {

    # Turns off the GameBar Tips of Windows 10 that are shown when a game - or what Windows 10 thinks is a game - is launched.
    # Disable-GameBarTips

    # # Disables UAC. Note that Windows 8 and 8.1 can not launch Windows Store applications with UAC disabled.
    # Disable-UAC
    
    # # Disables the Bing Internet Search when searching from the search field in the Taskbar or Start Menu.
    # Disable-BingSearch

    # # Turns on the Windows Update option to include updates for other Microsoft products installed on the system.
    # Enable-MicrosoftUpdate

    # # Finds, downloads and installs all Windows Updates. By default, only critical updates will be searched. 
    # Install-WindowsUpdate

    # Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder -EnableShowRibbon
}