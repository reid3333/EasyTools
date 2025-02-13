@echo off
chcp 65001 > NUL
set ARIA=%~dp0..\Download\Aria.bat
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass

set LLAMA_CPP_DEFAULT_VERSION=b4689

pushd %~dp0
if not exist LlamaCpp_Version.txt (
	echo %LLAMA_CPP_DEFAULT_VERSION%>LlamaCpp_Version.txt
)
set /p LLAMA_CPP_VERSION=<LlamaCpp_Version.txt
set LLAMA_CPP_ZIP=llama-%LLAMA_CPP_VERSION%-bin-win-cuda-cu12.4-x64.zip
set CUDA_RT_ZIP=cudart-llama-bin-win-cu12.4-x64.zip

if exist LlamaCpp\ ( goto :LLAMA_CPP_DIR_EXISTS )

echo.
echo https://github.com/ggerganov/llama.cpp Version: %LLAMA_CPP_VERSION%

echo call %ARIA% .\ %LLAMA_CPP_ZIP% https://github.com/ggerganov/llama.cpp/releases/download/%LLAMA_CPP_VERSION%/%LLAMA_CPP_ZIP%
call %ARIA% .\ %LLAMA_CPP_ZIP% https://github.com/ggerganov/llama.cpp/releases/download/%LLAMA_CPP_VERSION%/%LLAMA_CPP_ZIP%
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

echo %PS_CMD% "try { Expand-Archive -Path %LLAMA_CPP_ZIP% -DestinationPath LlamaCpp -Force } catch { exit 1 }"
%PS_CMD% "try { Expand-Archive -Path %LLAMA_CPP_ZIP% -DestinationPath LlamaCpp -Force } catch { exit 1 }"
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

del /Q %LLAMA_CPP_ZIP%
:LLAMA_CPP_DIR_EXISTS

if exist LlamaCpp\cudart64_12.dll ( goto :CUDA_RT_EXISTS )

echo call %ARIA% .\ %CUDA_RT_ZIP% https://github.com/ggerganov/llama.cpp/releases/download/%LLAMA_CPP_VERSION%/%CUDA_RT_ZIP%
call %ARIA% .\ %CUDA_RT_ZIP% https://github.com/ggerganov/llama.cpp/releases/download/%LLAMA_CPP_VERSION%/%CUDA_RT_ZIP%
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

echo %PS_CMD% "try { Expand-Archive -Path %CUDA_RT_ZIP% -DestinationPath LlamaCpp -Force } catch { exit 1 }"
%PS_CMD% "try { Expand-Archive -Path %CUDA_RT_ZIP% -DestinationPath LlamaCpp -Force } catch { exit 1 }"
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

del /Q %CUDA_RT_ZIP%
:CUDA_RT_EXISTS

popd rem %~dp0
