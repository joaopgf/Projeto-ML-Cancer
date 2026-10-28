# Projeto-ML-Cancer

Projeto de Machine Learning do Bootcamp de IA da TCS.

O projeto pode rodar de duas formas:

- **[VS Code no PC](#rodando-no-vs-code-sem-docker)** com um ambiente virtual `.venv` (padrão atual dos notebooks).
- **[Docker](#rodando-com-docker)**: um container com Python, PyTorch (CUDA para GPU) e todas as bibliotecas do projeto, acessado pelo **JupyterLab** no navegador.

## Rodando no VS Code (sem Docker)

1. Clone o repositório pelo VS Code: `Ctrl+Shift+P` → **Git: Clone** → cole a URL.
2. Abra o terminal do VS Code com ``Ctrl+` `` e rode:

   ```
   .\setup.bat
   ```

   O script cria o ambiente virtual `.venv`, instala as bibliotecas do `requirements.txt` (incluindo o PyTorch com CUDA) e as extensões do VS Code, ativa o salvamento automático e, no fim, recarrega a janela do VS Code sozinho. O download é grande (só o PyTorch tem cerca de 2,5 GB).
3. Se a janela não recarregar sozinha, recarregue para ativar as extensões: `Ctrl+Shift+P` → **Developer: Reload Window**.
4. Abra um notebook, clique em **Select Kernel** no canto superior direito e escolha o `.venv`.

### Caminhos nos notebooks

Os notebooks vêm configurados para o VS Code, com caminhos relativos (`../data/...` e `../graficos`). Para usar no Docker, troque o comentário nas duas células:

```python
# Docker
# DATA_DIR = Path("/app/data/Lung_Cancer")
# VS Code (PC)
DATA_DIR = Path("../data/Lung_Cancer")
```

O mesmo vale para o `output_dir`, na célula de hiperparâmetros.

> Os caminhos relativos funcionam porque o notebook roda a partir da própria pasta (`rna_cinza/` ou `rna_cor/`). Mantenha os notebooks dentro dessas pastas.

### Se aparecer "a execução de scripts foi desabilitada neste sistema"

O Windows está bloqueando a ativação do `.venv` no PowerShell. Rode no terminal:

```
Set-ExecutionPolicy -Scope Process Bypass
```

Isso vale só para aquele terminal e não precisa de administrador. Outra opção é trocar o terminal para **Command Prompt** na setinha ao lado do **+** do terminal.

## Rodando com Docker

Lembre de trocar os caminhos dos notebooks para os do Docker (veja [Caminhos nos notebooks](#caminhos-nos-notebooks)).

## Pré-requisitos

- **Windows:** Docker Desktop com WSL2 e driver da NVIDIA atualizado.
- **Linux:** Docker e [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

> O container precisa de uma placa NVIDIA. Sem ela, o `docker compose up` falha.

## Como usar

Os PCs do SENAI são resetados ao desligar, então esse passo a passo precisa ser feito **toda vez** que ligar o PC.

### 1. Abrir o Docker Desktop

Abra o Docker Desktop e espere ele terminar de iniciar.

### 2. Clonar o repositório pelo VS Code

1. Abra o VS Code.
2. Aperte `Ctrl+Shift+P`, digite **Git: Clone** e cole a URL do repositório.
3. Escolha a pasta onde salvar e clique em **Abrir** quando aparecer a pergunta.

### 3. Colocar o dataset na pasta `data/`

Veja a seção [Datasets](#datasets).

### 4. Subir o container

Abra o terminal do VS Code com ``Ctrl+` `` (ou menu **Terminal → Novo Terminal**) e rode:

```
docker compose up --build
```

Na primeira vez demora, porque baixa e instala todos os pacotes (a imagem fica com vários GB). Se a imagem já existir no PC, `docker compose up` (sem `--build`) sobe mais rápido.

### 5. Abrir o JupyterLab

Quando aparecer `Jupyter Server ... is running at` no terminal, abra no navegador:

```
http://localhost:8888
```

### 6. Conferir se a GPU está funcionando

Em um notebook, rode:

```python
import torch
print(torch.cuda.is_available())  # deve mostrar True
```

Se aparecer `False`, verifique se o driver da NVIDIA está atualizado.

### Para parar

Aperte `Ctrl+C` no terminal ou rode `docker compose down`.

## Como funciona

- A pasta do projeto é compartilhada com o container (ela aparece como `/app` lá dentro). Tudo que for salvo no JupyterLab vai direto para a pasta do projeto no PC, e o que mudar no PC aparece na hora no JupyterLab.
- O Jupyter roda **sem senha** e só pode ser acessado pelo próprio PC (`127.0.0.1`).
- Salve sempre dentro da pasta do projeto. Arquivos salvos em outras pastas do container (como `/tmp`) somem quando o container é recriado.

### Rodando arquivos `.py`

No JupyterLab, abra **File → New → Terminal** e rode:

```
python nome_do_arquivo.py
```

Ou, pelo terminal do VS Code, com o container ligado:

```
docker compose exec jupyter python nome_do_arquivo.py
```

### Adicionando pacotes

Não use `pip install` dentro do container: o pacote some quando o container é recriado e os colegas não recebem. Em vez disso:

1. Adicione o pacote ao `requirements.txt`.
2. Rode `docker compose up --build`.
3. Faça commit do `requirements.txt` para todos receberem.

## Datasets

Coloque os datasets na pasta `data/`. No código, use caminhos relativos:

```python
import pandas as pd

df = pd.read_csv("data/nome-do-arquivo.csv")      # notebook na raiz do projeto
df = pd.read_csv("../data/nome-do-arquivo.csv")   # notebook em uma subpasta
```

A pasta `data/` é ignorada pelo Git, então os arquivos **não vão para o GitHub** e cada um precisa baixar o dataset no próprio PC. Também são ignorados em qualquer pasta os arquivos `.csv`, `.xlsx`, `.parquet`, `.zip`, `.npy`, `.pkl` e outros formatos de dados (veja o `.gitignore`).

Para conferir se um arquivo está sendo ignorado:

```
git check-ignore -v data/nome-do-arquivo.csv
```

> Modelos treinados (`.pt`, `.pth`) também são ignorados. Como os PCs resetam, salvem os que quiserem manter em um pendrive ou no Drive.

## Git

O Git é usado **pelo PC** (terminal do VS Code ou aba de Controle do Código-Fonte), não dentro do container. Como a pasta é compartilhada, o que for salvo no JupyterLab já aparece no `git status`.

```
git pull                        # antes de começar: baixar o que os colegas enviaram
git add .
git commit -m "mensagem curta"
git push                        # antes de desligar o PC!
```

Cuidados:

- **Salve o notebook no JupyterLab** (`Ctrl+S`) antes de dar commit.
- **Depois de um `git pull`, recarregue o notebook** aberto no JupyterLab, senão ao salvar você sobrescreve o que veio do pull.
- **Evitem duas pessoas editando o mesmo `.ipynb`**: conflitos em notebooks são difíceis de resolver.
- **Faça push antes de desligar**: o PC reseta e o que não foi enviado para o GitHub se perde.

Se o Git pedir nome e e-mail:

```
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
```

## Extensões do VS Code (opcional)

Ao abrir a pasta do projeto, o VS Code sugere instalar as extensões recomendadas. Elas ajudam a editar o código no VS Code, mas não são necessárias para usar o JupyterLab.

| Extensão | Para quê |
|---|---|
| Python, Pylance, Python Debugger | Autocompletar e verificar erros em arquivos `.py` |
| Jupyter | Abrir notebooks no VS Code usando o Jupyter do container (**Select Kernel → Existing Jupyter Server** → `http://localhost:8888`) |
| Rainbow CSV | Colorir as colunas dos arquivos `.csv` |
| Error Lens | Mostrar os erros na própria linha do código |
| Office Viewer | Visualizar arquivos Excel, Word e PDF dentro do VS Code |
| Pacote de idioma pt-BR | VS Code em português |
