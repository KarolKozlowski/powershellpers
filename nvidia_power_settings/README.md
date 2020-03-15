# NVIDIA Power settings

Script looks up NVIDIA Audio driver setup class and disables power management.
This is to solve the issue with missing audio devices when resuming from suspend/standby.

## Setup

* Download the `ps1` file and put it in _c:\Windows\System32\GroupPolicy\Machine\Scripts\Shutdown\ _.
* Next open Local Group Policy Editor (`gpedit.msc`)
* Navigate to **Computer Configuration\Windows Settings\Scripts (Startup/Shutdown)**.
* Double click **Shutdown**
* Change tab to **PowerShell scripts**
* Click **Add** and select the `nvidia_power_settings.ps1`
* Restart the PC

Defaults:
```
    Hive: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0017


    Name                           Property
    ----                           --------
    PowerSettings                  ConservationIdleTime : {4, 0, 0, 0}
                                   IdlePowerState       : {3, 0, 0, 0}
                                   PerformanceIdleTime  : {4, 0, 0, 0}
```

Overrides:
```
    Hive: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0017


    Name                           Property
    ----                           --------
    PowerSettings                  ConservationIdleTime : {0, 0, 0, 0}
                                   IdlePowerState       : {0, 0, 0, 0}
                                   PerformanceIdleTime  : {0, 0, 0, 0}
```

