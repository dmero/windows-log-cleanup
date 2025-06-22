@echo off
REM Log Cleanup Batch Wrapper
REM Version: 1.2
REM Save this as: C:\Scripts\LogCleanup.bat
REM 
REM This batch file provides a reliable wrapper for Task Scheduler
REM to execute the PowerShell log cleanup script

REM Change the path below to your actual log folder
set LOG_FOLDER=C:\Your\Log\Folder\Path

REM Run the PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Scripts\LogCleanup.ps1" -LogFolder "%LOG_FOLDER%"

REM Exit with the same code as PowerShell
exit /b %ERRORLEVEL%
