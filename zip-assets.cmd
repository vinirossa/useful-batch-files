@echo off
set PATH=%PATH%;"C:\Program Files\7-Zip"

REM Detect users desktop
for /F "tokens=* USEBACKQ" %%F in (`powershell.exe echo ^([Environment]::GetFolderPath^('Desktop'^)^)`) do (
    set UserDesktop=%%F
)

REM Go to Assets folder
cd C:\Users\vinic\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets

REM Rename all files to *.png
ren * *.png

REM Zip the images to the desktop
7z a -r %UserDesktop%\Assets *

REM Asks if the user wants to delete files from Assets
:choice
set /P c=Do you want to delete all files from Assets [Y/N]?
if /I "%c%" EQU "Y" goto :deletefiles
if /I "%c%" EQU "N" goto :done
goto :choice

REM Delete all files
:deletefiles
del /S /F /Q *

:done
echo Done...
exit
