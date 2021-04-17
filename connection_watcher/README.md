# Connection Watcher

_WORK IN PROGRESS_

Script that scans for particular connections and saves them in Event Log.

## Setup

* Download the `ps1` file and put it somewhere.
* Add it to Event Scheduler with parameter 'watch'.

## Query

Query Windows Event Log with the following command:
```
Get-EventLog -LogName Application -Source 'Network Monitor' | Out-File -FilePath .\Downloads\connections.log
```
