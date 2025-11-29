-- VIEW MATERIALIZADA 1: Faturamento Geral Consolidado (Rankings Q5, Q6, Q7, Q8)
-- Motivo: Substitui os cálculos pesados de JOIN e SUM em 3 tabelas grandes.
-- Resolve o problema de performance das chaves compostas na hora da leitura.
CREATE MATERIALIZED VIEW streaming.mv_faturamento_geral AS
WITH pat AS (
    SELECT id_canal, SUM(valor) as total_patrocinio
    FROM streaming.Patrocinio 
    GROUP BY id_canal -- Usa Índice 2
),
mem AS (
    SELECT i.id_canal, SUM(nc.valor) as total_membros
    FROM streaming.Inscricao i
    JOIN streaming.NivelCanal nc ON nc.id_canal = i.id_canal AND nc.nivel = i.nivel
    GROUP BY i.id_canal
),
doac AS (
    SELECT id_canal, SUM(valor) as total_doacoes
    FROM streaming.Doacao 
    WHERE status_doacao IN ('recebido', 'lido') -- Usa Índice 3
    GROUP BY id_canal
)
SELECT 
    c.id as id_canal,
    c.nome as nome_canal,
    c.nro_plataforma,
    COALESCE(pat.total_patrocinio, 0) as f_patrocinio,
    COALESCE(mem.total_membros, 0) as f_membros,
    COALESCE(doac.total_doacoes, 0) as f_doacoes,
    (COALESCE(pat.total_patrocinio, 0) + COALESCE(mem.total_membros, 0) + COALESCE(doac.total_doacoes, 0)) as f_total
FROM streaming.Canal c
LEFT JOIN pat ON pat.id_canal = c.id
LEFT JOIN mem ON mem.id_canal = c.id
LEFT JOIN doac ON doac.id_canal = c.id;

-- *** ÍNDICE 5: ÚNICO NA MV (O Pulo do Gato) ***
-- Motivo: Permite REFRESH CONCURRENTLY. Sem ele, atualizar o ranking trava o site.
CREATE UNIQUE INDEX idx_mv_faturamento_unique 
ON streaming.mv_faturamento_geral(id_canal);

-- VIEW VIRTUAL 2: Doações por Vídeo (Consulta 4)
-- Motivo: Leve o suficiente para ser virtual graças ao Índice 4.
CREATE OR REPLACE VIEW streaming.v_doacoes_video_lidas AS
SELECT 
    v.id as video_id,
    v.titulo,
    v.dataH,
    COALESCE(SUM(d.valor), 0) as total_lido
FROM streaming.Video v
LEFT JOIN streaming.Doacao d ON d.video_id = v.id 
    AND d.id_canal = v.id_canal -- Join composto
    AND d.status_doacao = 'lido' -- Usa Índice 4
GROUP BY v.id, v.titulo, v.dataH, v.id_canal;

-- VIEW VIRTUAL 3: Relatório de Patrocínios (Consulta 1)
-- Motivo: Abstrai a complexidade do JOIN para o desenvolvedor.
CREATE OR REPLACE VIEW streaming.v_rel_patrocinios AS
SELECT 
    e.nro as nro_empresa, 
    e.nome as nome_empresa, 
    c.nome as nome_canal, 
    p.valor
FROM streaming.Empresa e
JOIN streaming.Patrocinio p ON p.nro_empresa = e.nro
JOIN streaming.Canal c ON c.id = p.id_canal;

-- VIEW VIRTUAL 4: Relatório de Membros (Consulta 2)
-- Motivo: Abstrai a complexidade dos níveis e canais.
CREATE OR REPLACE VIEW streaming.v_rel_membros AS
SELECT 
    u.id as id_usuario, 
    u.nick, 
    i.id_canal, 
    nc.valor
FROM streaming.Usuario u
LEFT JOIN streaming.Inscricao i ON i.id_membro = u.id -- Usa Índice 1
LEFT JOIN streaming.NivelCanal nc ON nc.id_canal = i.id_canal AND nc.nivel = i.nivel;

-- VIEW VIRTUAL 5: Ranking Formatado (Consulta 8)
-- Motivo: Formata a saída da MV para exibição final (Top K).
CREATE OR REPLACE VIEW streaming.v_ranking_formatado AS
SELECT 
    RANK() OVER (ORDER BY f_total DESC) as posicao,
    nome_canal,
    f_patrocinio,
    f_membros,
    f_doacoes,
    f_total
FROM streaming.mv_faturamento_geral;