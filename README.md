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

🛠️ Regras de Negócio (Resumo)
O modelo foi construído sobre três pilares principais para garantir integridade e escalabilidade:

🌐 Ecossistema Global & Atores: Gestão unificada de Plataformas, Streamers e Usuários, com suporte nativo a Geolocalização e Conversão Cambial para padronização financeira (USD).

🎥 Conteúdo & Engajamento: Controle detalhado de Canais (Públicos/Privados), Vídeos Colaborativos e métricas de interação em tempo real (visualizações e comentários).

💰 Monetização Híbrida: Sistema financeiro robusto que integra três fontes de receita distintas:

Patrocínios (B2B): Gestão de contratos ativos com empresas.

Membros (Recorrente): Níveis de assinatura com benefícios exclusivos.

Doações (Transacional): Suporte a múltiplos gateways (Bitcoin, PayPal, Cartão e Plataforma) atrelados a interações do usuário.

🚀 Funcionalidades Implementadas
Otimização (Pastas indices e views)
Índices: Criação de índices B-Tree focados em colunas de alta cardinalidade para acelerar joins financeiros.

Views: Abstração de queries complexas para relatórios de alcance e faturamento consolidado (Materialized Views).

Stored Procedures (Pasta consultas)
O sistema responde às seguintes perguntas de negócio via funções parametrizadas:

🏢 Relatório de Patrocínios: Valores pagos por empresa e canais patrocinados.

👤 Gastos de Usuários: Adesão de membros e total gasto mensalmente por usuário.

💸 Histórico de Doações: Totalização de valores recebidos por canal.

💬 Engajamento Monetizado: Doações geradas especificamente por comentários lidos.

🏆 Top K Patrocínio: Ranking de canais por receita B2B.

⭐ Top K Membros: Ranking de canais por receita de assinaturas.

💲 Top K Doações: Ranking de canais por volume de doações.

📈 Faturamento Total: O "Big Number" — ranking consolidado das três fontes de receita.

⚙️ Como Executar
Para instanciar o banco de dados completo, execute os scripts na ordem abaixo utilizando seu cliente SQL preferido (pgAdmin, DBeaver ou PSQL):

Criação do Schema: estrutura_banco/

Lógica de Consistência: triggers/

Carga de Dados: transactions/

Otimização: indices/ e views/

Testes: consultas/

Exemplo de chamada de procedure:

-- Listar Top 3 canais com maior faturamento geral
SELECT * FROM fn_top_k_faturamento_total(3);
