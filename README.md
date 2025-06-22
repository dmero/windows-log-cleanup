# Windows Log File Cleanup Scripts

Automated scripts to manage log file retention in Windows environments using Task Scheduler.

## Overview

These scripts automatically delete the oldest log files when the number of files in a specified folder reaches a configurable threshold (default: 30 files). Perfect for applications that generate continuous log files without built-in rotation.

## Files Included

- `LogCleanup.ps1` - Main PowerShell script
- `LogCleanup.bat` - Batch wrapper for Task Scheduler compatibility
- `README.md` - This documentation

## Features

- 🗂️ Configurable log folder path
- 📊 Configurable file count threshold
- 🔍 Configurable file extensions/patterns
- 📝 Windows Event Log integration for monitoring
- ⚠️ Comprehensive error handling
- 🛡️ Safety checks and validation
- 🔄 Compatible with Windows Task Scheduler

## Quick Start

### 1. Download and Setup
```bash
# Clone or download the scripts
git clone [your-repo-url]
cd log-cleanup-scripts

# Create scripts directory
mkdir C:\Scripts
copy LogCleanup.ps1 C:\Scripts\
copy LogCleanup.bat C:\Scripts\
```

### 2. Task Scheduler Setup (Recommended Method)

1. Open Task Scheduler as Administrator
2. Create a new task with these settings:

**General Tab:**
- Name: "Log Cleanup Script"
- Check "Run with highest privileges"
- Check "Run whether user is logged on or not"

**Triggers Tab:**
- Create trigger (e.g., Daily at 2:00 AM)

**Actions Tab:**
- Action: "Start a program"
- Program: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
- Arguments: `-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Scripts\LogCleanup.ps1" -LogFolder "C:\Your\Log\Folder\Path"`

**Settings Tab:**
- Check "Allow task to be run on demand"
- Check "Run task as soon as possible after a scheduled start is missed"

## Usage Examples

### Basic Usage
```powershell
# Use default settings (30 files, *.log extension)
.\LogCleanup.ps1 -LogFolder "C:\MyApp\Logs"
```

### Advanced Usage
```powershell
# Custom settings
.\LogCleanup.ps1 -LogFolder "C:\MyApp\Logs" -MaxFiles 25 -LogExtension "*.txt"
```

### Batch File Usage
```batch
# Edit LogCleanup.bat to set your log folder path, then run:
C:\Scripts\LogCleanup.bat
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `LogFolder` | String | `C:\Logs` | Path to the folder containing log files |
| `MaxFiles` | Integer | `30` | Maximum number of files to keep |
| `LogExtension` | String | `*.log` | File pattern to match (e.g., `*.log`, `*.txt`, `app-*.log`) |

## Monitoring

The script logs all activities to Windows Event Log:

1. Open Event Viewer
2. Navigate to: Windows Logs → Application
3. Filter by Source: "LogCleanup"

### Event Types
- **Information**: Normal operations, file deletions
- **Error**: Permission issues, missing folders, deletion failures

## Troubleshooting

### Common Issues

**Error Code 2147942401 (Access Denied)**
- Run Task Scheduler as Administrator
- Check "Run with highest privileges" in task settings
- Ensure the account has permissions to the log folder

**Script Not Running**
- Verify all file paths exist
- Test script manually in PowerShell first
- Check Task Scheduler history for detailed error messages

**No Files Being Deleted**
- Verify the file count actually exceeds the threshold
- Check the file extension pattern matches your files
- Ensure files aren't locked by running applications

### Manual Testing
```powershell
# Test the script manually
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
C:\Scripts\LogCleanup.ps1 -LogFolder "C:\Test\Logs" -MaxFiles 5
```

## Security Considerations

- Script requires read/write access to the log folder
- Uses Windows Event Log (requires appropriate permissions)
- Runs with elevated privileges when scheduled
- No network connectivity required
- All operations are local to the machine

## Customization

### Modify File Selection Criteria
Edit the script to change how files are selected:

```powershell
# Current: Sort by creation time
$LogFiles = Get-ChildItem -Path $LogFolder -Filter $LogExtension -File | Sort-Object CreationTime

# Alternative: Sort by last write time
$LogFiles = Get-ChildItem -Path $LogFolder -Filter $LogExtension -File | Sort-Object LastWriteTime

# Alternative: Sort by file size (largest first)
$LogFiles = Get-ChildItem -Path $LogFolder -Filter $LogExtension -File | Sort-Object Length -Descending
```

### Add Email Notifications
Integrate with PowerShell email cmdlets to send notifications when cleanup occurs.

### Multiple Folder Support
Modify the script to handle multiple log folders by accepting an array of paths.

## Requirements

- Windows 7/Server 2008 R2 or later
- PowerShell 3.0 or later
- Appropriate file system permissions
- Task Scheduler service running

## License

MIT License - Feel free to modify and distribute as needed.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Version History

- **v1.0** - Initial release with basic cleanup functionality
- **v1.1** - Added Event Log integration and error handling
- **v1.2** - Added batch wrapper for improved Task Scheduler compatibility

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review Windows Event Logs for error details
3. Test the script manually before scheduling
4. Open an issue in this repository with details
