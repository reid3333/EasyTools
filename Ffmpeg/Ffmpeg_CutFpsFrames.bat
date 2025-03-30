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

@REM 16FPS 81フレームの切り取り 81 / 16 = 5.0625秒
@REM fmpeg_CutFpsFrames.bat 16 81 5.0625 %*

set "FILTER=%~1"
if "%FILTER%"=="" (
	echo "動画のフィルタが指定されていません。"
	pause & exit /b 1
)
shift

set "FRAMES=%~1"
if "%FRAMES%"=="" (
	echo "動画のフレーム数が指定されていません。"
	pause & exit /b 1
)
shift

set "AUDIO_DURATION=%~1"
if "%AUDIO_DURATION%"=="" (
	echo "音声の長さが指定されていません。"
	pause & exit /b 1
)
shift

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

set %FPS%

set "START_TIME_PATH=%START_TIME::=_%"
for %%f in ("%INPUT_FILE%") do (
	set "OUTPUT_BASE_PATH=%%~dpnf"
)
set "OUTPUT_WEBP_FILE=%OUTPUT_BASE_PATH%-%START_TIME_PATH%.webp"
set "OUTPUT_WAV_FILE=%OUTPUT_BASE_PATH%-%START_TIME_PATH%.wav"

echo.
echo %EASY_FFMPEG% -y -i "%INPUT_FILE%" -vf "%FILTER%" -ss %START_TIME% -frames:v %FRAMES% -vcodec libwebp -lossless 1 -loop 0 -an "%OUTPUT_WEBP_FILE%"
echo.
%EASY_FFMPEG% -y -i "%INPUT_FILE%" -vf "%FILTER%" -ss %START_TIME% -frames:v %FRAMES% -vcodec libwebp -lossless 1 -loop 0 -an "%OUTPUT_WEBP_FILE%"
if %ERRORLEVEL% neq 0 (
	echo "動画の切り取りに失敗しました。"
	pause & exit /b 1
)

%EASY_FFMPEG% -i "%INPUT_FILE%" -hide_banner 2>&1 | find "Audio:" > nul
if %ERRORLEVEL% neq 0 ( goto :EASY_NO_AUDIO )

echo.
echo %EASY_FFMPEG% -y -i "%INPUT_FILE%" -ss %START_TIME% -t %AUDIO_DURATION% -vn -acodec pcm_s16le "%OUTPUT_WAV_FILE%"
echo.
%EASY_FFMPEG% -y -i "%INPUT_FILE%" -ss %START_TIME% -t %AUDIO_DURATION% -vn -acodec pcm_s16le "%OUTPUT_WAV_FILE%"

if %ERRORLEVEL% neq 0 (
	echo "音声の切り取りに失敗しました。"
	pause & exit /b 1
)

:EASY_NO_AUDIO
