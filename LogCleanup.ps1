# Log File Cleanup Script
# Deletes the oldest log file when 30 or more log files exist in the specified folder
# Version: 1.2
# Author: Windows Log Management Script
# Compatible with: Windows 7+ / PowerShell 3.0+

param(
    [Parameter(Mandatory=$false)]
    [string]$LogFolder = "C:\Logs",
    
    [Parameter(Mandatory=$false)]
    [int]$MaxFiles = 30,
    
    [Parameter(Mandatory=$false)]
    [string]$LogExtension = "*.log"
)

# Function to write to event log for monitoring
function Write-EventLogEntry {
    param(
        [string]$Message,
        [string]$EntryType = "Information"
    )
    
    try {
        # Create event source if it doesn't exist
        if (-not [System.Diagnostics.EventLog]::SourceExists("LogCleanup")) {
            [System.Diagnostics.EventLog]::CreateEventSource("LogCleanup", "Application")
        }
        
        Write-EventLog -LogName "Application" -Source "LogCleanup" -EventId 1001 -EntryType $EntryType -Message $Message
    }
    catch {
        # If event log writing fails, continue silently
    }
}

try {
    # Check if the log folder exists
    if (-not (Test-Path -Path $LogFolder)) {
        $ErrorMessage = "Log folder does not exist: $LogFolder"
        Write-EventLogEntry -Message $ErrorMessage -EntryType "Error"
        Write-Error $ErrorMessage
        exit 1
    }

    # Get all log files in the folder, sorted by creation time (oldest first)
    $LogFiles = Get-ChildItem -Path $LogFolder -Filter $LogExtension -File | Sort-Object CreationTime

    $FileCount = $LogFiles.Count
    Write-EventLogEntry -Message "Found $FileCount log files in $LogFolder"

    # Check if we have 30 or more files
    if ($FileCount -ge $MaxFiles) {
        # Calculate how many files to delete (keep it at exactly MaxFiles-1)
        $FilesToDelete = $FileCount - $MaxFiles + 1
        
        # Get the oldest files to delete
        $FilesToRemove = $LogFiles | Select-Object -First $FilesToDelete
        
        foreach ($File in $FilesToRemove) {
            try {
                Remove-Item -Path $File.FullName -Force
                Write-EventLogEntry -Message "Deleted old log file: $($File.Name) (Created: $($File.CreationTime))"
                Write-Output "Deleted: $($File.Name)"
            }
            catch {
                $ErrorMessage = "Failed to delete file: $($File.Name). Error: $($_.Exception.Message)"
                Write-EventLogEntry -Message $ErrorMessage -EntryType "Error"
                Write-Error $ErrorMessage
            }
        }
        
        $RemainingFiles = (Get-ChildItem -Path $LogFolder -Filter $LogExtension -File).Count
        Write-EventLogEntry -Message "Cleanup completed. Remaining files: $RemainingFiles"
    }
    else {
        Write-EventLogEntry -Message "No cleanup needed. File count ($FileCount) is below threshold ($MaxFiles)"
    }
}
catch {
    $ErrorMessage = "Script execution failed: $($_.Exception.Message)"
    Write-EventLogEntry -Message $ErrorMessage -EntryType "Error"
    Write-Error $ErrorMessage
    exit 1
}

Write-Output "Log cleanup script completed successfully."
