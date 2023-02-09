# 📄 Documentação

## Objetivo geral
Criar um ambiente do Apache Airflow containerizado, de fácil controle do ambiente e adição e remoção de DAGs.

</br>

## Solução
Criado um ambiente com base no python e bash, conteinerizado via Docker, sendo utilizado uma imagem oficial do Apache Airflow `airflow:2.5.0-python3.10`.

</br>
</br>

# 🗂️ Estrutura do projeto
```
.
├── dags
│   └── origem-dados
│       └── script-with-dag.py
├── docker
│   ├── healthcheck.bash
│   └── startup.bash
├── Dockerfile
├── Makefile
└── README.md

```

</br>

## Airflow
Diretório responsável por armazenar os scripts que contém as DAGs. Cada script estará sob o diretório, onde o nome será inspirado na fonte de dados(domínio, nome empresa, etc).

## Docker
Diretório responsável por armazenar os scripts que tratarão alguns requisitos básicos para que o ambiente possa funcionar perfeitamente, alguns itens são:

- Limpreza de possíveis arquivos antigos relacionados ao ambiente do Apache Airflow;
- Ativação do banco de dados do Apache Airflow, armazenamento dos metadados;
- Criação de um usuário com Role Admin para o acesso ao Airflow;
- Inicialização do Scheduler e Webserver do Airflow;
- Validação de disponibilidade da porta http://localhost:8080/ , esta que será utilizada para a UI do Airflow;

</br>
</br>

# ⛏️ Preparando o ambiente localmente
## Requisitos
- SO: Linux
- Docker `sudo apt install docker.io`
- Make `sudo apt install make`
- Conexção de internet

*Ambiente construido no PopOS 22.04(baseado no Ubuntu)

</br>

## ⚠️ Importante saber
Todos os comandos necessários para controle do ambiente estão no arquivo <kbd>Makefile</kbd>.

</br>

## 🏁 Inicializando
*Os comandos abaixo precisam ser inseridos no terminal da pasta raiz do projeto.
1. Construir o ambiente `make run`
2. Acessar UI do Apache Airflow http://localhost:8080/
3. Realizar o login, insira em Username `admin` e em Password `admin`

</br>

## 🪚 Executando
Seguindo o modelo de estrutura do projeto, quando adicionar um arquivo <kbd>.py</kbd> contendo uma DAG, automaticamente ela aparecerá na UI do Airflow em alguns segundos, isso ocorre pelo fato da existência de um Bind Mount que mantém esse armazenamento persistente e síncrono.

</br>

## 🔎 Extras
1. Parando o ambiente(container) `make stop`
2. Retomar ambiente `make start`
3. Limpar ambiente(excluir imagens e container) `make finish`

</br>
</br>
