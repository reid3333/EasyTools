@echo off
chcp 65001 > NUL
pushd %~dp0
set EASY_TOOLS=%~dp0..
set GITHUB_CLONE_OR_PULL=%EASY_TOOLS%\Git\GitHub_CloneOrPull.bat

@REM https://github.com/zanllp/sd-webui-infinite-image-browsing
call "%GITHUB_CLONE_OR_PULL%" zanllp sd-webui-infinite-image-browsing main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

popd rem %~dp0
pushd %~dp0sd-webui-infinite-image-browsing

call %EASY_TOOLS%\Python\Python_Activate.bat
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

echo python -m pip install -qq --upgrade pip
python -m pip install -qq --upgrade pip
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo pip install -r requirements.txt
pip install -r requirements.txt
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0sd-webui-infinite-image-browsing
