@echo off
chcp 65001 > NUL
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass

call %~dp0Python_Activate.bat
if %ERRORLEVEL% neq 0 ( exit /b 1 )

cd > NUL
python -c "import tkinter; root = tkinter.Tk()" > NUL 2>&1
if %ERRORLEVEL% equ 0 ( exit /b 0 )

echo %PS_CMD% Expand-Archive -Path "%~dp0python_tkinter-%EASY_PYTHON_VERSION%.zip" -DestinationPath %VIRTUAL_ENV_DIR% -Force
%PS_CMD% Expand-Archive -Path "%~dp0python_tkinter-%EASY_PYTHON_VERSION%.zip" -DestinationPath %VIRTUAL_ENV_DIR% -Force
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )

cd > NUL
python -c "import tkinter; root = tkinter.Tk()" > NUL 2>&1
if %ERRORLEVEL% neq 0 (
	echo "[ERROR] Python に tkinter がインストールされていません。"
	echo "[ERROR] Python does not have tkinter installed."
	pause & exit /b 1
)
