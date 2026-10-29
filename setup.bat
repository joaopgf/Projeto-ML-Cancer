@echo off
REM Prepara o ambiente do projeto: venv, pacotes Python, extensoes e configuracoes do VS Code

REM Garante que os comandos rodam na pasta do projeto
cd /d "%~dp0"

echo [1/4] Criando ambiente virtual...
python -m venv .venv
call .venv\Scripts\activate

echo [2/4] Instalando pacotes Python...
python.exe -m pip install --upgrade pip
pip install -r requirements.txt

echo [3/4] Instalando extensoes do VS Code...
call code --install-extension ms-python.python
call code --install-extension ms-python.vscode-pylance
call code --install-extension ms-python.debugpy
call code --install-extension ms-toolsai.jupyter
call code --install-extension mechatroner.rainbow-csv
call code --install-extension usernamehw.errorlens
call code --install-extension cweijan.vscode-office
call code --install-extension ms-ceintl.vscode-language-pack-pt-br

echo [4/4] Ativando o salvamento automatico do VS Code...
REM Adiciona "files.autoSave" em .vscode\settings.json, mantendo as outras configuracoes
powershell -NoProfile -ExecutionPolicy Bypass -Command "$f = '.vscode\settings.json'; New-Item -ItemType Directory -Force .vscode | Out-Null; try { if (Test-Path $f) { $s = Get-Content $f -Raw | ConvertFrom-Json } else { $s = $null }; if ($null -eq $s) { $s = New-Object PSObject }; $s | Add-Member -NotePropertyName 'files.autoSave' -NotePropertyValue 'afterDelay' -Force; [IO.File]::WriteAllText((Join-Path (Get-Location) $f), ($s | ConvertTo-Json)); Write-Host 'Salvamento automatico ativado.' } catch { Write-Host 'Nao foi possivel alterar .vscode\settings.json. Ative manualmente: Arquivo > Salvamento Automatico.' }"

echo.
echo Pronto!

REM Recarrega a janela do VS Code (Ctrl+Shift+P > Reload Window) para ativar as extensoes.
REM So funciona quando o script roda no terminal do VS Code.
if /i "%TERM_PROGRAM%"=="vscode" (
    echo Recarregando a janela do VS Code...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$w = New-Object -ComObject WScript.Shell; if ($w.AppActivate('Visual Studio Code')) { Start-Sleep -Milliseconds 500; $w.SendKeys('^+p'); Start-Sleep -Milliseconds 1000; $w.SendKeys('Reload Window'); Start-Sleep -Milliseconds 1000; $w.SendKeys('{ENTER}') } else { Write-Host 'Janela do VS Code nao encontrada. Recarregue manualmente: Ctrl+Shift+P > Reload Window' }"
) else (
    echo Abra o projeto no VS Code e recarregue a janela: Ctrl+Shift+P ^> Reload Window
    pause
)
