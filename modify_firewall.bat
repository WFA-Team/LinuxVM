@echo off
setlocal

echo Configuring Windows Defender Firewall...

:: Enable ICMP Ping (File and Printer Sharing)
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

:: Check if rule exists using PowerShell directly
for /f "usebackq delims=" %%A in (`powershell -ExecutionPolicy Bypass -Command "if (Get-NetFirewallRule -DisplayName 'VM Comm Rule' -ErrorAction SilentlyContinue) {'True'} else {'False'}"`) do set "rule_exists=%%A"

if "%rule_exists%"=="True" (
    echo Rule "VM Comm Rule" already exists.
) else (
    echo Rule does not exist. Creating...
    netsh advfirewall firewall add rule name="VM Comm Rule" ^
        dir=in action=allow protocol=icmpv4 ^
        localip=192.168.56.0/24

    echo Waiting for rule to register...

    :: Retry check with improved logic
    set "retry_count=0"
    set "rule_created=False"

    :retry_check
    echo Attempt %retry_count%: Checking rule status...

    for /f "usebackq delims=" %%A in (`powershell -ExecutionPolicy Bypass -Command "if (Get-NetFirewallRule -DisplayName 'VM Comm Rule' -ErrorAction SilentlyContinue) {'True'} else {'False'}"`) do set "rule_created=%%A"

    if "%rule_created%"=="True" (
        echo Rule created successfully.
    ) else (
        set /a retry_count+=1
        if !retry_count! LEQ 10 (
            echo Rule not found yet. Retrying in 2 seconds...
            timeout /t 2 /nobreak >nul
            goto retry_check
        ) else (
            echo WARNING: Rule may not have been created properly after 10 retries. Verify manually.
        )
    )
)

echo Firewall configuration complete.

endlocal