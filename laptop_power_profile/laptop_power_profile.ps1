
<#
    Power profile and suspend hooks
#>

param (
    # execution mode
    [string] $mode = 'full',

    # dock network adapter name
    [string] $DockNetAdapterName = "OneDock",
    
    # host in local network
    [string] $TestlHostName = "uranus.np.dotnot.pl",
    
    # standby timeout after host is not detected (minutes)
    [int] $OfflineStandbyTimeout = 15,
    
    # standby timeout after host is detected (minutes)
    [int] $OnlineStandbyTimeout = 0,

    # Restart services after resume
    [String[]] $RestartServices = "Synergy"
)

switch ($mode) {

  "full" {

    $DockNetAdapter = Get-NetAdapter -Name $DockNetAdapterName
    

    if ($DockNetAdapter.Status -eq "Up") {
        # laptop is docked
      
        if ((Test-NetConnection -ComputerName $TestlHostName).PingSucceeded -eq "True") {
            # host reachable
            powercfg -change -standby-timeout-ac $OnlineStandbyTimeout
        } else {
            # host unreachable
            powercfg -change -standby-timeout-ac $OfflineStandbyTimeout
        }
    } else {
        # laptop is not docked (but could be on power)
        powercfg -change -standby-timeout-ac $OnlineStandbyTimeout
    }
  }

  "resume" {
    # set default standby timeout after resume
    powercfg -change -standby-timeout-ac $OnlineStandbyTimeout
  }

  "resume-privileged" {
    foreach ($service in $RestartServices) {
        Restart-Service -Name $service
    }
  }

}

