@echo off
chcp 65001 > NUL
set CURL_CMD=C:\Windows\System32\curl.exe -kL
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass
set EASY_GIT_DIR=%~dp0
set EASY_GIT_DIR=%EASY_GIT_DIR:~0,-1%

@REM ---- ここから Install.bat と同期 ----
where /Q git
if %ERRORLEVEL% equ 0 ( goto :EASY_GIT_FOUND )
cd > NUL

set PORTABLE_GIT_BIN=%EASY_GIT_DIR%\env\PortableGit\bin
set PORTABLE_GIT_VERSION=2.47.0

if not exist %PORTABLE_GIT_BIN%\ (
	setlocal enabledelayedexpansion
	if not exist "%EASY_GIT_DIR%\env\" ( mkdir "%EASY_GIT_DIR%\env" )
	echo https://github.com/git-for-windows/git/

	echo %CURL_CMD% -o %EASY_GIT_DIR%\env\PortableGit.7z.exe https://github.com/git-for-windows/git/releases/download/v%PORTABLE_GIT_VERSION%.windows.1/PortableGit-%PORTABLE_GIT_VERSION%-64-bit.7z.exe
	%CURL_CMD% -o %EASY_GIT_DIR%\env\PortableGit.7z.exe https://github.com/git-for-windows/git/releases/download/v%PORTABLE_GIT_VERSION%.windows.1/PortableGit-%PORTABLE_GIT_VERSION%-64-bit.7z.exe
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )

	start "" %PS_CMD% -Command "Start-Sleep -Seconds 2; $title='Portable Git for Windows 64-bit'; $window=Get-Process | Where-Object { $_.MainWindowTitle -eq $title } | Select-Object -First 1; if ($window -ne $null) { [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic'); [Microsoft.VisualBasic.Interaction]::AppActivate($window.Id); Start-Sleep -Seconds 1; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{ENTER}') }"

	echo "操作せずに、そのまま Portable Git for Windows をインストールしてください。"
	%EASY_GIT_DIR%\env\PortableGit.7z.exe
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )

	echo del %EASY_GIT_DIR%\env\PortableGit.7z.exe
	del %EASY_GIT_DIR%\env\PortableGit.7z.exe
	if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )
	endlocal
)

set "PATH=%PORTABLE_GIT_BIN%;%PATH%"

where /Q git
if %ERRORLEVEL% equ 0 ( goto :EASY_GIT_FOUND )
echo "[Error] Git をインストールできませんでした。手動で Git for Windows をインストールしてください。"
pause & exit /b 1

:EASY_GIT_FOUND
@REM ---- ここまで Install.bat と同期 --------
