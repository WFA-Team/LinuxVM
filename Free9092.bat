@echo off
setlocal

:: Find the process ID (PID) using port 9092
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :9092') do set "PID=%%a"

:: Check if a PID was found
if defined PID (
    echo Process using port 9092 found. PID: %PID%
    taskkill /F /PID %PID%
    if errorlevel 1 (
        echo Failed to kill process with PID %PID%.
    ) else (
        echo Process with PID %PID% killed successfully.
    )
) else (
    echo No process found using port 9092.
)

endlocal