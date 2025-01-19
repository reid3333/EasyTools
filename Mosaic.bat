@echo off
chcp 65001 > NUL

set MOSAIC=mosaic_20240601

if not exist %~dp0Mosaic\%MOSAIC%\venv\ (
	echo call %~dp0Mosaic\Mosaic_Update.bat
	call %~dp0Mosaic\Mosaic_Update.bat
)
if not exist %~dp0Mosaic\%MOSAIC%\venv\ (
	echo %~dp0Mosaic\%MOSAIC%\venv\ not found
	pause & exit /b 1
)

pushd %~dp0Mosaic\%MOSAIC%\

call %~dp0Python\Python_ActivateTkinter.bat
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

echo python mosaic.py %*
python mosaic.py %*
@REM ファイル未選択時にエラー扱いになるので無効にする
@REM if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0Mosaic\\%MOSAIC%\
