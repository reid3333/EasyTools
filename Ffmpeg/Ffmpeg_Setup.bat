@echo off
chcp 65001 > NUL
set CURL_CMD=C:\Windows\System32\curl.exe -kL
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass

if not exist "%~dp0env\" ( mkdir "%~dp0env" )
if exist "%~dp0env\ffmpeg-master-latest-win64-gpl\" ( goto :EASY_FFMPEG_DIR_FOUND )

set EASY_FFMPEG_URL=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip
echo %CURL_CMD% -o "%~dp0env\ffmpeg.zip" %EASY_FFMPEG_URL%
%CURL_CMD% -o "%~dp0env\ffmpeg.zip" %EASY_FFMPEG_URL%
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )

echo %PS_CMD% Expand-Archive -Path "%~dp0env\ffmpeg.zip" -DestinationPath "%~dp0env" -Force
%PS_CMD% Expand-Archive -Path "%~dp0env\ffmpeg.zip" -DestinationPath "%~dp0env" -Force
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )

echo del "%~dp0env\ffmpeg.zip"
del "%~dp0env\ffmpeg.zip"
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )

:EASY_FFMPEG_DIR_FOUND

if "%~1"=="" ( exit /b 0 )
if exist "%~1\ffplay.exe" ( exit /b 0 )

echo xcopy /QY "%~dp0env\ffmpeg-master-latest-win64-gpl\bin\*.exe" "%~1\"
xcopy /QY "%~dp0env\ffmpeg-master-latest-win64-gpl\bin\*.exe" "%~1\"
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )
