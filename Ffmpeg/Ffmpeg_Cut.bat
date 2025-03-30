@echo off
chcp 65001 > NUL
set "EASY_FFMPEG=%~dp0env\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe"
set EASY_FFMPEG_CRF=19
set EASY_FFMPEG_BAUDIO=192k

if not exist "%EASY_FFMPEG%" ( call "%~dp0Ffmpeg_Setup.bat" )
if not exist "%EASY_FFMPEG%" (
	echo "ffmpeg.exe のインストールに失敗しています。"
	echo Not found: %EASY_FFMPEG% & pause & exit /b 1
)

set "INPUT_FILE=%~1"
if not "%INPUT_FILE%"=="" ( goto :INPUT_FILE_FOUND )

echo "動画ファイルをドラッグ＆ドロップしてください。"
set /p "INPUT_FILE=動画ファイル: "
if not exist "%INPUT_FILE%" (
	echo "動画ファイルが存在しません。: %INPUT_FILE%"
	pause & exit /b 1
)

:INPUT_FILE_FOUND

echo "動画の切り取り開始位置を、秒数か mm:ss 形式で指定してください。"
set /p "START_TIME=開始位置: "
if "%START_TIME%"=="" (
	echo "開始位置が指定されていません。"
	pause & exit /b 1
)

echo "切り取る動画の長さを、秒数か mm:ss 形式で指定してください。"
set /p "DURATION=長さ: "
if "%DURATION%"=="" (
	echo "長さが指定されていません。"
	pause & exit /b 1
)

set "START_TIME_PATH=%START_TIME::=_%"
set "DURATION_PATH=%DURATION::=_%"
for %%f in ("%INPUT_FILE%") do (
	set "OUTPUT_BASE_PATH=%%~dpnf"
)
set "OUTPUT_FILE=%OUTPUT_BASE_PATH%-%START_TIME_PATH%-%DURATION_PATH%.mp4"

echo.
echo %EASY_FFMPEG% -y -i "%INPUT_FILE%" -ss %START_TIME% -t %DURATION% -c:v libx264 -crf %EASY_FFMPEG_CRF% -c:a aac -b:a %EASY_FFMPEG_BAUDIO% "%OUTPUT_FILE%"
echo.
%EASY_FFMPEG% -y -i "%INPUT_FILE%" -ss %START_TIME% -t %DURATION% -c:v libx264 -crf %EASY_FFMPEG_CRF% -c:a aac -b:a %EASY_FFMPEG_BAUDIO% "%OUTPUT_FILE%"
if %ERRORLEVEL% neq 0 (
	echo "動画の切り取りに失敗しました。"
	pause & exit /b 1
)
