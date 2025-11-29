🎮 Streaming Analytics Database

Sistema de Banco de Dados Relacional projetado para catalogar e analisar o ecossistema de Streamers, Plataformas, Monetização e Engajamento de Audiência.

📋 Sobre o Projeto

Este projeto consiste na modelagem completa (Conceitual, Lógica e Física) e implementação de uma base de dados normalizada para gerenciar informações de transmissões ao vivo. O sistema foi projetado para responder a questões complexas de negócio sobre alcance de público, faturamento híbrido (doações, membros e patrocínios) e interações em vídeos.

O banco de dados foi otimizado para cenários de alta leitura, utilizando Views Materializadas e Índices estratégicos, além de garantir a consistência dos dados através de Triggers e Stored Procedures.

📂 Estrutura do Repositório

O projeto segue uma arquitetura modular baseada em scripts SQL sequenciais:

.
├── estrutura_banco/   # DDL: Scripts de criação de tabelas, constraints (PK/FK) e normalização.
├── triggers/          # PL/pgSQL: Triggers para manutenção de consistência e regras de negócio.
├── transactions/      # DML: Scripts de povoamento (Data Seeding) com 100+ tuplas por tabela.
├── indices/           # Performance: Definição de 5 índices estratégicos com justificativas.
├── views/             # Analytics: 5 Visões (Virtuais e Materializadas) para relatórios.
└── consultas/         # Stored Procedures: Functions parametrizadas para as 8 questões de negócio.


🚀 Funcionalidades Implementadas

Otimização (Pastas indices e views)

Índices: Criação de índices B-Tree para colunas de alta cardinalidade e chaves estrangeiras utilizadas em joins frequentes de relatórios financeiros.

Views: Abstração de queries complexas para relatórios de alcance e faturamento consolidado.

Stored Procedures (Pasta consultas)

O sistema responde às seguintes perguntas de negócio via funções parametrizadas:

1. Relatório de Patrocínios: Identifica quais são os canais patrocinados e os valores pagos por empresa.

Filtro Opcional: Por Empresa.

2. Gastos de Usuários: Descobre de quantos canais cada usuário é membro e a soma do valor desembolsado por mês.

Filtro Opcional: Por Usuário.

3. Histórico de Doações: Lista os canais que já receberam doações e a soma dos valores recebidos.

Filtro Opcional: Por Canal.

4. Engajamento Monetizado: Lista a soma das doações geradas pelos comentários que foram lidos pelo streamer.

Filtro Opcional: Por Vídeo.

5. Top K Patrocínio: Lista e ordena os k canais que mais recebem patrocínio e os valores recebidos.

6. Top K Membros: Lista e ordena os k canais que mais recebem aportes de membros e os valores recebidos.

7. Top K Doações: Lista e ordena os k canais que mais receberam doações considerando todos os vídeos.

8. Faturamento Total: Lista os k canais que mais faturam considerando as três fontes de receita somadas: patrocínio, membros inscritos e doações.

⚙️ Como Executar

Para instanciar o banco de dados completo, execute os scripts na ordem abaixo utilizando seu cliente SQL preferido (pgAdmin, DBeaver ou PSQL):

Criação do Schema:
Execute os arquivos em estrutura_banco/ para criar as tabelas e relacionamentos.

Lógica de Consistência:
Execute os arquivos em triggers/ para ativar as validações automáticas.

Carga de Dados:
Execute os arquivos em transactions/ para popular o banco com dados de teste.

Otimização:
Execute os arquivos em indices/ e views/.

Testes:
Utilize os scripts em consultas/ para chamar as procedures e verificar os resultados.

Exemplo de chamada de procedure:

-- Listar Top 3 canais com maior faturamento geral
SELECT * FROM fn_top_k_faturamento_total(3);
