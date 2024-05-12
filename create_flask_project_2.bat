@echo off
setlocal

rem Define temporary PowerShell script
set "tempScript=%temp%\filepicker.ps1"

rem Create temporary PowerShell script
echo Add-Type -AssemblyName System.Windows.Forms > "%tempScript%"
echo $FileDialog = New-Object System.Windows.Forms.OpenFileDialog >> "%tempScript%"
echo $FileDialog.Filter = "All Files (*.*)|*.*" >> "%tempScript%"
echo $result = $FileDialog.ShowDialog() >> "%tempScript%"
echo if ($result -eq 'OK') { >> "%tempScript%"
echo     Write-Output $FileDialog.FileName >> "%tempScript%"
echo } else { >> "%tempScript%"
echo     Write-Output "No file selected" >> "%tempScript%"
echo } >> "%tempScript%"

rem Run temporary PowerShell script to get selected file
for /f "delims=" %%a in ('powershell -ExecutionPolicy Bypass -File "%tempScript%"') do set "selectedFile=%%a"

rem Clean up temporary PowerShell script
del "%tempScript%"

rem Check if the user selected a file
if "%selectedFile%"=="No file selected" (
    echo No file selected.
    exit /b
)

rem Extract file extension
for /f "tokens=*" %%A in ("%selectedFile%") do (
    set "fileExtension=%%~xA"
)

rem Determine destination folder based on file extension
if "%fileExtension%"==".html" (
    set "destination_folder=C:\Users\User\Desktop\xxx\templates"
) else if "%fileExtension%"==".css" (
    set "destination_folder=C:\Users\User\Desktop\xxx\static"
) else if "%fileExtension%"==".js" (
    set "destination_folder=C:\Users\User\Desktop\xxx\static"
) else if "%fileExtension%"==".py" (
    set "destination_folder=C:\Users\User\Desktop\xxx"
) else (
    echo File type not supported.
    exit /b
)

rem Check if destination folder exists, create if not
if not exist "%destination_folder%" (
    mkdir "%destination_folder%"
)

rem Copy selected file to destination folder
copy "%selectedFile%" "%destination_folder%"
echo File copied successfully.

endlocal
exit /b
