# Watches for certains connections and stores them to System log for future
# processing.

param (
    # execution mode
    [string] $mode = 'parse',

    # Remote address to ignore (default: local)
    [String[]] $ignore_remote_address = @('127.0.0.1','0.0.0.0', '::')
)


$log_source = 'Network Monitor'
$log_name = "Application"

# Call of Duty
$call_of_duty += 'Battle.net', 'ModernWarfare'

# Duty calls
$duty_calls += "wfica32", "CDViewer", "HdxRtcEngine", "MediaEngineService", "UpdaterService", "concentr", "redirector", "Receiver", "wfcrun32", "SelfServicePlugin", "SelfService", "CtxWebBrowser", "AuthManSvr", "CtxWebBrowser"

$select_pocesses = @()
$select_pocesses += $call_of_duty
$select_pocesses += $duty_calls

$connection_map = @{}

switch ($mode) {

  "watch" {
    if (![System.Diagnostics.EventLog]::SourceExists($log_source)){
      New-Eventlog -LogName $log_name -Source $log_source
    }
    [System.Diagnostics.EventLog]::SourceExists($log_source)

    get-nettcpconnection | ForEach-Object {

      $remote_address = $_.RemoteAddress

      if( !$ignore_remote_address.Contains($remote_address)){

        $process_name = (Get-Process -Id $_.OwningProcess).ProcessName
        if( $select_pocesses.Contains($process_name)){
          if ( ! $connection_map.Contains($process_name) ) {
            $connection_map.Add($process_name, (New-Object Collections.Generic.List[string]))
          }
          Write-EventLog -LogName $log_name -Source $log_source -EventID 9900 -EntryType Information -Message "Connection: $process_name -> $remote_address"
          $connection_map.$process_name.Add($remote_address)
        }
      }
    }
  }
  "parse" {
    Get-EventLog -LogName $log_name -Source $log_source
    # Write-Output $connection_map
  }
}
