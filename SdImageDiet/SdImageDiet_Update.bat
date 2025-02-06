@echo off
chcp 65001 > NUL
set GITHUB_CLONE_OR_PULL_HASH=%~dp0..\Git\GitHub_CloneOrPull_Hash.bat
set PYTHON_ACTIVATE=%~dp0..\Python\Python_Activate.bat

pushd %~dp0

call %GITHUB_CLONE_OR_PULL_HASH% nekotodance SdImageDiet main
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

popd rem %~dp0
pushd %~dp0SdImageDiet

call %PYTHON_ACTIVATE%
if %ERRORLEVEL% neq 0 ( popd & exit /b 1 )

echo python -m pip install -qq --upgrade pip
python -m pip install -qq --upgrade pip
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo pip install -qq PyQt5==5.15.11 Image==1.5.33 piexif==1.1.3 pillow-avif-plugin==1.4.6
pip install -qq PyQt5==5.15.11 Image==1.5.33 piexif==1.1.3 pillow-avif-plugin==1.4.6
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %~dp0SdImageDiet
