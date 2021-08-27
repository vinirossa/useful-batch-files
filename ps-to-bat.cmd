@echo Off

for /F "tokens=* USEBACKQ" %%F in (`powershell.exe echo ^([Environment]::GetFolderPath^('Desktop'^)^)`) do (
    set desktop=%%F
)
echo %desktop%

pause