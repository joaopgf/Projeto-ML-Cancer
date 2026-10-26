@echo off
REM Prepara o ambiente do projeto: venv, pacotes Python e extensoes do VS Code

echo [1/3] Criando ambiente virtual...
python -m venv .venv
call .venv\Scripts\activate

echo [2/3] Instalando pacotes Python...
python -m pip install --upgrade pip
pip install -r requirements.txt

echo [3/3] Instalando extensoes do VS Code...
call code --install-extension ms-python.python
call code --install-extension ms-python.vscode-pylance
call code --install-extension ms-python.debugpy
call code --install-extension ms-toolsai.jupyter
call code --install-extension mechatroner.rainbow-csv
call code --install-extension usernamehw.errorlens
call code --install-extension cweijan.vscode-office
call code --install-extension ms-ceintl.vscode-language-pack-pt-br

echo.
echo Pronto! Abra o projeto com: code .
pause
