# MinhaNotinha

Repositório para o Projeto Integrador VI. Aplicativo mobile desenvolvido em Flutter chamado MinhaNotinha.

## Descrição

Aplicativo mobile desenvolvido em Flutter, focado em facilitar compras de mercado. O app usa a câmera do celular, fotos ou leitura de PDF para ler notas fiscais, identificar produtos e registrar preços e quantidades. Essas informações são armazenadas para visualização dos preços e itens, facilitando a comparação e a escolha dos melhores preços.

## Como usar

**1:**

Faça download ou clone esse repo usando este link:

```
https://github.com/RenatoWlk/ProjetoIntegradorVI
```

**2:**

Vá na raiz do projeto e execute este comando no console para capturar as dependências: 

```
flutter pub get 
```

## Features:

* Login
* Home
* Provider (Gerenciamento de estados)
* Banco de Dados
* Encriptação
* Validação
* Scanner ou Câmera
* Upload de Foto ou PDF
* Processamento de Notas Fiscais
* Extração de Itens com OCR
* Histórico de Compras
* Itens Mais Comprados
* Gráficos de Preços ao Longo do Tempo
* Modo Claro e Escuro

### Estrutura de Pastas
Estrutura principal de pastas.

```
ProjetoIntegradorVI/
|- github
|- android
|- assets
|- fonts
|- ios
|- lib
|- web
```

Pasta que usamos para fazer o projeto.

```
lib/
|- models/
|- providers/
|- routes/
|- screens/
|- services/
|- utils/
|- widgets/
|- main.dart
```

Explicação de cada pasta da aplicação.

```
1- models - Contém os modelos de dados da aplicação, como usuário, nota fiscal e itens. 
2- providers - Gerencia o estado da aplicação, conectando dados reativos com a interface.  
3- routes - Define todas as rotas do aplicativo.  
4- screens - Contém as telas da aplicação.  
5- services - Implementa serviços como banco de dados, encriptação, processamento de nota fiscal.  
6- utils - Inclui funções utilitárias e auxiliares, e também diálogos e listas de dados.  
7- widgets - Armazena widgets reutilizáveis, como botões e o Drawer.  
8- main.dart - Ponto de entrada da aplicação, configura tema, rotas e inicializações gerais.  
```

## Créditos

* [Renato Wilker de Paula Silva](https://github.com/RenatoWlk)
* [Pedro Barboza Valente](https://github.com/PedroBarboz4)
* [Vinicius Ferreira Paiola](https://github.com/vifp)
* [Gabriel Trindade](https://github.com/trindadegabriel)
* [Enzo Fischer](https://github.com/efsantoss)
