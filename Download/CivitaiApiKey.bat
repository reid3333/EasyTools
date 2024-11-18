@echo off
chcp 65001 > NUL

echo "Civitai のアカウントを作成して、APIキーを取得して、設定してください。"
echo "アカウント設定の一番下の方で取得できます。https://civitai.com/user/account Ctrl+クリックで開く"
echo "参考: https://github.com/zixaphir/Stable-Diffusion-Webui-Civitai-Helper/wiki/Civitai-API-Key"
echo.
echo "現在の CIVITAI_API_KEY: %CIVITAI_API_KEY%"
set /p INPUT_KEY="CIVITAI_API_KEY を入力してください（空欄ならキーを削除）: "

setlocal enabledelayedexpansion
if "%INPUT_KEY%"=="" (
	setx CIVITAI_API_KEY ""
	if !ERRORLEVEL! neq 0 ( endlocal & pause & exit /b 1 )
	exit /b 0
)
if not "%INPUT_KEY%"=="" (
	setx CIVITAI_API_KEY "%INPUT_KEY%"
	if !ERRORLEVEL! neq 0 ( endlocal & pause & exit /b 1 )
)
endlocal
