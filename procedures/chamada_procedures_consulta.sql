-- =====================================================================
-- 1. RELATÓRIO DE PATROCÍNIOS (Consulta 1)
-- =====================================================================

-- Opção A: Listar TUDO (passando NULL ou vazio)
SELECT * FROM streaming.sp_relatorio_patrocinios(NULL);

-- Opção B: Filtrar por uma Empresa específica (ex: Empresa ID 10)
-- O banco usará os índices para filtrar antes de fazer o join completo
SELECT * FROM streaming.sp_relatorio_patrocinios(10);


-- =====================================================================
-- 2. RELATÓRIO DE MEMBROS (Consulta 2)
-- =====================================================================

-- Opção A: Listar todos os usuários e seus gastos
SELECT * FROM streaming.sp_relatorio_usuarios(NULL);

-- Opção B: Filtrar por um Usuário específico (ex: Usuário ID 5)
-- O 'idx_inscricao_membro' fará essa busca ser instantânea
SELECT * FROM streaming.sp_relatorio_usuarios(5);


-- =====================================================================
-- 3. DOAÇÕES POR CANAL (Consulta 3)
-- Fonte: View Materializada (Dados Históricos/Consolidados)
-- =====================================================================

-- Opção A: Ranking de doações de todos os canais
SELECT * FROM streaming.sp_doacoes_por_canal(NULL);

-- Opção B: Ver total de doações de um canal específico (ex: Canal ID 100)
SELECT * FROM streaming.sp_doacoes_por_canal(100);


-- =====================================================================
-- 4. DOAÇÕES LIDAS POR VÍDEO (Consulta 4)
-- Fonte: View Virtual com Índice Parcial (Dados Tempo Real)
-- =====================================================================

-- Opção A: Listar totais lidos de todos os vídeos
SELECT * FROM streaming.sp_doacoes_video_lidas(NULL);

-- Opção B: Ver total lido de um vídeo específico (ex: Vídeo ID 55)
-- O 'idx_doacao_video_lido' torna isso muito rápido
SELECT * FROM streaming.sp_doacoes_video_lidas(55);


-- =====================================================================
-- 5. RANKINGS GLOBAIS TOP K (Consultas 5, 6, 7 e 8)
-- Fonte: View Materializada
-- Parâmetros: (Tipo, Limite)
-- Tipos: 1=Patrocinio, 2=Membros, 3=Doacao, 4=Total
-- =====================================================================

-- Consulta 5: Top 5 Canais que mais recebem Patrocínio
SELECT * FROM streaming.sp_ranking_canais(1, 5);

-- Consulta 6: Top 5 Canais com maior receita de Membros
SELECT * FROM streaming.sp_ranking_canais(2, 5);

-- Consulta 7: Top 5 Canais com maior volume de Doações
SELECT * FROM streaming.sp_ranking_canais(3, 5);

-- Consulta 8: Top 10 Canais com maior Faturamento Total (Soma das 3 fontes)
SELECT * FROM streaming.sp_ranking_canais(4, 10);


-- =====================================================================
-- EXTRA: MANUTENÇÃO (Importante!)
-- =====================================================================
-- Se as consultas 3, 5, 6, 7 ou 8 retornarem vazio, é porque a View Materializada
-- ainda não foi populada. Rode este comando para atualizar os dados:

CALL streaming.sp_atualizar_sistema();