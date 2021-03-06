# Script looks up NVIDIA Audio driver setup class and disables power management

$device_setup_classes= 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\'

$driver_name_key = '^DriverDesc$'
$driver_name_value = '^NVIDIA High Definition Audio$'

Get-ChildItem -path Registry::$device_setup_classes -recurse  -ErrorAction SilentlyContinue |
    ForEach-Object {
        $item = $_
        ($item.GetValueNames() -match $driver_name_key ) |
            ForEach-Object {
                if ( $Item.GetValue($_) -match $driver_name_value ) {
                    # Print before:
                    Get-Item -path Registry::$Item\PowerSettings

                    # Overrides:
                    Set-Itemproperty -path Registry::$Item\PowerSettings -Name 'ConservationIdleTime' -Value ([byte[]](0xff,0xff,0xff,0xff))
                    Set-Itemproperty -path Registry::$Item\PowerSettings -Name 'IdlePowerState' -Value ([byte[]](0x00,0x00,0x00,0x00))
                    Set-Itemproperty -path Registry::$Item\PowerSettings -Name 'PerformanceIdleTime' -Value ([byte[]](0xff,0xff,0xff,0xff))

                    # Defaults:
                    # Set-Itemproperty -path Registry::$Item\PowerSettings -Name 'ConservationIdleTime' -Value ([byte[]](0x04,0x00,0x00,0x00))
                    # Set-Itemproperty -path Registry::$Item\PowerSettings -Name 'IdlePowerState' -Value ([byte[]](0x03,0x00,0x00,0x00))
                    # Set-Itemproperty -path Registry::$Item\PowerSettings -Name 'PerformanceIdleTime' -Value ([byte[]](0x04,0x00,0x00,0x00))

                    # Print after:
                    Get-Item -path Registry::$Item\PowerSettings
                }
            }
    }
