# Gerenciador de Vagas

O "Gerenciador de Vagas" é um aplicativo Flutter desenvolvido para gerenciar vagas de estacionamento, permitindo aos usuários visualizar vagas disponíveis, registrar entradas e saídas de veículos, e acompanhar um histórico dessas movimentações. O projeto segue uma arquitetura robusta, utilizando o padrão Bloc juntamente com a Clean Architecture para garantir uma boa separação de responsabilidades e uma maior facilidade na manutenção do código.

## Características

- **Arquitetura Bloc com Clean Architecture:** Divisão clara entre as camadas de domínio, infraestrutura e dados.
- **Testes Unitários e de Widgets:** Possui testes unitários dos usecases e dos blocs assim como testes dos principais widgets do projeto totalizando 39 testes ao todo.
- **Persistência de dados:** Utilização do Sqflite para o armazenamento local de dados usando SQL.
- **Gerenciamento de vagas:** Visualização de vagas livres e preenchidas diretamente na tela inicial.
- **Registro de entradas:** Possibilidade de adicionar uma entrada para uma vaga específica, com suporte a placas no padrão Mercosul ou antigo.
- **Liberação de vagas:** Funcionalidade para registrar a saída de veículos através de um diálogo de confirmação.
- **Histórico de movimentações:** Tela dedicada para visualização do histórico de entradas e saídas, organizado por data em ordem decrescente.
- **Suporte a temas:** Disponibilidade de temas claro e escuro.
- **Compatibilidade:** Suporte para as plataformas iOS e Android.
- **Temas Dark e Light:** Suporte a alteração de temas entre Dark e Light na Tela Inicial com o padrão sendo o Light.
- **Vídeo de funcionamento do App:** [https://youtu.be/O2xQfk3KUg0](https://www.youtube.com/watch?v=0qwsT3hVYxY)

## Versão do Flutter

Este projeto foi desenvolvido utilizando o Flutter na versão 3.24.5

## Telas

O aplicativo é composto por três telas principais:

1. **Tela Inicial:** Mostra a listagem de todas as vagas, indicando quais estão livres e quais estão ocupadas com possibilidade de registrar uma saída das vagas preenchidas através de um dialog.
2. **Tela de Adicionar Entrada:** Permite ao usuário registrar a entrada de um veículo em uma vaga específica.
3. **Tela de Histórico:** Exibe o histórico de movimentações de vagas, com as entradas e saídas registradas.

## Como Executar

Para executar o projeto, siga os passos abaixo:

1. Clone o repositório:
   ```
   git clone https://github.com/LucasMdosAnjos/gerenciador_vagas
   ```
2. Entre no diretório do projeto:
   ```
   cd gerenciador_vagas
   ```
3. Execute o comando para instalar as dependências:
   ```
   flutter pub get
   ```
4. Inicie o aplicativo em um dispositivo ou emulador:
   ```
   flutter run
   ```

## Contribuições

Contribuições são sempre bem-vindas! Para contribuir, por favor, abra um pull request com suas alterações.
