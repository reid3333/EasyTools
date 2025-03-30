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

echo "動画の再生スピードを 0.5～2.0 の範囲で指定してください。"
set /p "PLAY_SPEED=再生スピード: "
if "%PLAY_SPEED%"=="" (
	echo "再生スピードが指定されていません。"
	pause & exit /b 1
)

for %%f in ("%INPUT_FILE%") do (
	set "OUTPUT_BASE_PATH=%%~dpnf"
)
set "OUTPUT_FILE=%OUTPUT_BASE_PATH%-x%PLAY_SPEED%.mp4"

echo.
echo %EASY_FFMPEG% -y -i "%INPUT_FILE%" -af "atempo=%PLAY_SPEED%" -bsf:v setts=ts=TS/%PLAY_SPEED% -c:v copy "%OUTPUT_FILE%"
echo.
%EASY_FFMPEG% -y -i "%INPUT_FILE%" -af "atempo=%PLAY_SPEED%" -bsf:v setts=ts=TS/%PLAY_SPEED% -c:v copy "%OUTPUT_FILE%"
if %ERRORLEVEL% neq 0 (
	echo "動画の再生スピードの設定に失敗しました。"
	pause & exit /b 1
)
