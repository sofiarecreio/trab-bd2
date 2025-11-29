# 🎮 Streaming Analytics Database

Sistema de Banco de Dados Relacional projetado para catalogar e analisar o ecossistema de **Streamers**, **Plataformas**, **Monetização** e **Engajamento de Audiência**.

---

## 📋 Sobre o Projeto

Este repositório contém a modelagem **Conceitual, Lógica e Física**, além da implementação completa de uma base de dados normalizada para gerenciar informações de transmissões ao vivo.

O sistema foi construído para responder perguntas complexas relacionadas a:

- Alcance de audiência
- Faturamento híbrido (Doações, Membros e Patrocínios)
- Métricas de engajamento em vídeos

O ambiente foi otimizado para cenários de alta leitura utilizando:

- Índices estratégicos  
- Views Materializadas  
- Triggers  
- Stored Procedures  
- Controle de consistência e integridade  

---

## 📂 Estrutura do Repositório

A arquitetura segue um fluxo modular baseado em scripts SQL sequenciais:
├── estrutura_banco/ # DDL: Criação de tabelas, PKs, FKs e normalização
├── triggers/ # PL/pgSQL: Regras de negócio e consistência
├── transactions/ # DML: Data Seeding (100+ tuplas por tabela)
├── indices/ # Índices de performance (B-Tree)
├── views/ # Views virtuais e materializadas
└── consultas/ # Stored Procedures para as questões de negócio


---

## 🛠️ Regras de Negócio — Visão Geral

O sistema foi projetado sobre três pilares principais:

### 🌐 1. Ecossistema Global & Atores
- Gestão de Plataformas, Streamers e Usuários  
- Geolocalização nativa  
- Conversão Cambial (padronização para USD)  

### 🎥 2. Conteúdo & Engajamento
- Controle de Canais (públicos/privados)  
- Suporte a Vídeos Colaborativos  
- Métricas de engajamento em tempo real (views e comentários)

### 💰 3. Monetização Híbrida  
Três fontes de receita integradas:

#### **Patrocínios (B2B)**
- Contratos ativos vinculados a canais  

#### **Membros (Recorrente)**
- Níveis de assinatura com benefícios  

#### **Doações (Transacional)**
- Gateways: Bitcoin, PayPal, Cartão e Plataforma  
- Associadas a interações com o conteúdo  

---

## 🚀 Funcionalidades Implementadas

### 🔧 Otimização (Índices & Views)

- Índices **B-Tree** em colunas de alta cardinalidade  
- Views para relatórios de alcance e faturamento  
- Materialized Views para alta performance em analytics  

---

## 📟 Stored Procedures (consultas/)

Funções parametrizadas que respondem às principais perguntas de negócio:

| Função | Descrição |
|--------|-----------|
| 🏢 Patrocínios | Valores pagos por empresa e canais patrocinados |
| 👤 Gastos de Usuários | Total mensal gasto por usuário |
| 💸 Histórico de Doações | Total recebido por canal |
| 💬 Engajamento Monetizado | Doações originadas por comentários |
| 🏆 Top K Patrocínio | Ranking B2B |
| ⭐ Top K Membros | Ranking de assinaturas |
| 💲 Top K Doações | Ranking por volume de doações |
| 📈 Faturamento Total | Ranking consolidado das três receitas |

---

## ⚙️ Como Executar

Para instanciar o banco de dados completo, execute os diretórios na seguinte ordem:

1. **Criação do Schema:** `estrutura_banco/`  
2. **Regras de Consistência:** `triggers/`  
3. **Otimização:** `views/` e `indices/`   
4. **Carga de Dados:** `transactions/`  
5. **Testes:** `consultas/`  




## ▶️ Exemplo de Execução (Stored Procedure)

```sql
-- Listar Top 3 canais com maior faturamento geral
SELECT * FROM fn_top_k_faturamento_total(3);
```

## 📧 Contato
- **Autores**: Danilo Pinto Nascimento, Isabel  Wesley Ribeiro Felix da Silva, .
- **Disciplina**: Projetos de Bancos de Dados - UFF (2025/2).
