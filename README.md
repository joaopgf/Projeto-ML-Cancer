# Projeto-ML-Cancer

Projeto de Machine Learning do Bootcamp de IA da TCS.

## Como preparar o ambiente

Os PCs do SENAI são resetados ao desligar, então esse passo a passo precisa ser feito **toda vez** que ligar o PC.

### 1. Clonar o repositório pelo VS Code

1. Abra o VS Code.
2. Aperte `Ctrl+Shift+P`, digite **Git: Clone** e cole a URL do repositório.
3. Escolha a pasta onde salvar e clique em **Abrir** quando aparecer a pergunta.

### 2. Rodar o script de instalação

1. Abra o terminal do VS Code com ``Ctrl+` `` (ou menu **Terminal → Novo Terminal**).
2. Digite:

   ```
   .\setup.bat
   ```

O script faz automaticamente:

- cria o ambiente virtual `.venv`;
- instala os pacotes do `requirements.txt` (incluindo o PyTorch com CUDA para GPU);
- instala as extensões do VS Code usadas no projeto.

> O download é grande (só o PyTorch tem cerca de 2,5 GB), então pode demorar alguns minutos.

### 3. Configurar o VS Code

1. Recarregue a janela para ativar as extensões: `Ctrl+Shift+P` → **Developer: Reload Window**.
2. Selecione o Python do ambiente virtual: `Ctrl+Shift+P` → **Python: Select Interpreter** → escolha a opção com `.venv`.
3. Nos notebooks (`.ipynb`), clique em **Select Kernel** no canto superior direito e escolha o `.venv`.

### 4. Conferir se a GPU está funcionando

Rode em um notebook ou arquivo Python:

```python
import torch
print(torch.cuda.is_available())  # deve mostrar True
```

Se aparecer `False`, verifique se o PC tem placa NVIDIA e se o driver está atualizado.

## Rodando com Docker (JupyterLab)

Alternativa ao `setup.bat`: o Docker monta o ambiente sozinho e sobe um JupyterLab com acesso à GPU. Funciona em Windows e Linux.

### Pré-requisitos

- **Windows:** Docker Desktop aberto, com WSL2, e driver da NVIDIA atualizado.
- **Linux:** Docker e [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

### Como usar

No terminal do VS Code, na pasta do projeto:

```
docker compose up --build
```

Na primeira vez demora, porque baixa e instala todos os pacotes (a imagem fica com vários GB). Quando aparecer `Jupyter Server ... is running at`, abra no navegador:

```
http://localhost:8888
```

Para parar, aperte `Ctrl+C` no terminal ou rode `docker compose down`.

### Como funciona

- A pasta do projeto é compartilhada com o container: notebooks criados no Jupyter aparecem no repositório, e os datasets em `data/` ficam disponíveis no container sem entrar na imagem.
- O Jupyter roda **sem senha** e só pode ser acessado pelo próprio PC (`127.0.0.1`).
- Se mudar o `requirements.txt`, rode de novo com `--build` para atualizar a imagem.

## Datasets

Coloque os datasets na pasta `data/`. Ela é ignorada pelo Git, então os arquivos **não vão para o GitHub** e cada um precisa baixar o dataset no próprio PC.

Também são ignorados em qualquer pasta os arquivos `.csv`, `.xlsx`, `.parquet`, `.zip`, `.npy`, `.pkl` e outros formatos de dados (veja o `.gitignore`).

Para conferir se um arquivo está sendo ignorado:

```
git check-ignore -v data/nome-do-arquivo.csv
```

## Problemas comuns

**"`.\setup.bat` não é reconhecido como comando"**
Confira se o terminal está na pasta do projeto e se você digitou o `.\` antes do nome.

**"A execução de scripts foi desabilitada neste sistema"**
O Windows está bloqueando a ativação do `.venv` no PowerShell. Rode no terminal:

```
Set-ExecutionPolicy -Scope Process Bypass
```

Isso vale só para aquele terminal e não precisa de administrador. Outra opção é trocar o terminal para **Command Prompt** na setinha ao lado do **+** do terminal.

**As extensões não foram instaladas**
O comando `code` pode não estar disponível no terminal. Nesse caso, ao abrir a pasta do projeto, o VS Code mostra o aviso **"Deseja instalar as extensões recomendadas?"**: basta clicar em **Instalar**.

## Extensões do VS Code

| Extensão | Para quê |
|---|---|
| Python, Pylance, Python Debugger | Rodar, autocompletar e depurar arquivos `.py` |
| Jupyter | Rodar notebooks `.ipynb` |
| Rainbow CSV | Colorir as colunas dos arquivos `.csv` |
| Error Lens | Mostrar os erros na própria linha do código |
| Office Viewer | Visualizar arquivos Excel, Word e PDF dentro do VS Code |
| Pacote de idioma pt-BR | VS Code em português |
