SET search_path TO streaming, public;

-- 1) Canais Patrocinados (Simulando filtro por Empresa nro=1)
EXPLAIN ANALYZE 
SELECT
    e.nro,
    e.nome,
    c.id,
    c.nome,
    c.nro_plataforma,
    p.valor
FROM streaming.Patrocinio p
JOIN streaming.Empresa e ON e.nro = p.nro_empresa
JOIN streaming.Canal c ON c.id = p.id_canal
WHERE p.nro_empresa = 1 -- Simulação de filtro p_nro_empresa
ORDER BY e.nome, c.nome;


-- 2) Membros por Usuário (Simulando filtro por Usuário id=1)
EXPLAIN ANALYZE
SELECT
    u.id,
    u.nick,
    COUNT(DISTINCT i.id_canal) AS qtd_canais,
    COALESCE(SUM(nc.valor), 0::NUMERIC) AS total_mensal
FROM streaming.Inscricao i
JOIN streaming.Usuario u ON u.id = i.id_membro
JOIN streaming.NivelCanal nc
    ON nc.id_canal = i.id_canal
    AND nc.nivel = i.nivel
WHERE u.id = 1 -- Simulação de filtro p_usuario_id
GROUP BY u.id, u.nick
ORDER BY u.nick;


-- 3) Doações por Canal (Simulando filtro por Canal id=1)
EXPLAIN ANALYZE
SELECT
    c.id,
    c.nome,
    c.nro_plataforma,
    SUM(d.valor) AS total_doacoes
FROM streaming.Doacao d
JOIN streaming.Video v ON v.id = d.video_id AND v.id_canal = d.id_canal
JOIN streaming.Canal c ON c.id = v.id_canal
WHERE d.status_doacao IN ('recebido', 'lido')
  AND c.id = 1 -- Simulação de filtro p_id_canal
GROUP BY c.id, c.nome, c.nro_plataforma
ORDER BY total_doacoes DESC;


-- 4) Doações Lidas por Vídeo (Simulando filtro por Vídeo id=1)
EXPLAIN ANALYZE
SELECT
    v.id,
    v.titulo,
    v.dataH,
    COALESCE(SUM(d.valor), 0::NUMERIC) AS total_doacoes_lidas
FROM streaming.Video v
LEFT JOIN streaming.Doacao d
    ON d.video_id = v.id
    AND d.id_canal = v.id_canal
    AND d.status_doacao = 'lido'
WHERE v.id = 1 -- Simulação de filtro p_video_id
GROUP BY v.id, v.titulo, v.dataH
ORDER BY total_doacoes_lidas DESC;


-- 5) Top 10 Canais Patrocinados
EXPLAIN ANALYZE
SELECT
    c.id,
    c.nome,
    c.nro_plataforma,
    SUM(p.valor) AS total_patrocinio
FROM streaming.Patrocinio p
JOIN streaming.Canal c ON c.id = p.id_canal
GROUP BY c.id, c.nome, c.nro_plataforma
ORDER BY total_patrocinio DESC
LIMIT 10; -- Simulação de p_k = 10


-- 6) Top 10 Canais por Aportes de Membros
EXPLAIN ANALYZE
SELECT
    c.id,
    c.nome,
    c.nro_plataforma,
    COALESCE(SUM(nc.valor), 0::NUMERIC) AS total_membros
FROM streaming.Inscricao i
JOIN streaming.Canal c ON c.id = i.id_canal
JOIN streaming.NivelCanal nc
    ON nc.id_canal = i.id_canal
    AND nc.nivel = i.nivel
GROUP BY c.id, c.nome, c.nro_plataforma
ORDER BY total_membros DESC
LIMIT 10; -- Simulação de p_k = 10


-- 7) Top 10 Canais por Doações
EXPLAIN ANALYZE
SELECT
    c.id,
    c.nome,
    c.nro_plataforma,
    SUM(d.valor) AS total_doacoes
FROM streaming.Doacao d
JOIN streaming.Video v ON v.id = d.video_id AND v.id_canal = d.id_canal
JOIN streaming.Canal c ON c.id = v.id_canal
WHERE d.status_doacao IN ('recebido', 'lido')
GROUP BY c.id, c.nome, c.nro_plataforma
ORDER BY total_doacoes DESC
LIMIT 10; -- Simulação de p_k = 10


-- 8) Top 10 Faturamento Total
EXPLAIN ANALYZE
WITH pat AS (
    SELECT
        id_canal,
        SUM(valor) AS total_patrocinio
    FROM streaming.Patrocinio
    GROUP BY id_canal
),
mem AS (
    SELECT
        i.id_canal,
        SUM(nc.valor) AS total_membros
    FROM streaming.Inscricao i
    JOIN streaming.NivelCanal nc ON nc.id_canal = i.id_canal AND nc.nivel = i.nivel
    GROUP BY i.id_canal
),
doac AS (
    SELECT
        v.id_canal,
        SUM(d.valor) AS total_doacoes
    FROM streaming.Doacao d
    JOIN streaming.Video v ON v.id = d.video_id AND v.id_canal = d.id_canal
    WHERE d.status_doacao IN ('recebido', 'lido')
    GROUP BY v.id_canal
)
SELECT
    c.id,
    c.nome,
    c.nro_plataforma,
    COALESCE(pat.total_patrocinio, 0::NUMERIC) AS total_patrocinio,
    COALESCE(mem.total_membros, 0::NUMERIC) AS total_membros,
    COALESCE(doac.total_doacoes, 0::NUMERIC) AS total_doacoes,
    COALESCE(pat.total_patrocinio, 0::NUMERIC)
    + COALESCE(mem.total_membros, 0::NUMERIC)
    + COALESCE(doac.total_doacoes, 0::NUMERIC) AS total_faturamento
FROM streaming.Canal c
LEFT JOIN pat ON pat.id_canal = c.id
LEFT JOIN mem ON mem.id_canal = c.id
LEFT JOIN doac ON doac.id_canal = c.id
ORDER BY total_faturamento DESC
LIMIT 10; -- Simulação de p_k = 10


----------------------------------------------------------------------------------------------------    CONSULTAS OTIMIZADAS ----------------------------------------------------------------------------

--consulta 1
-- ORIGINAL: Patrocinio → Empresa → Canal
-- OTIMIZADO: Empresa (filtrada) → Patrocinio → Canal
SELECT
    e.nro as nro_empresa,
    e.nome as nome_empresa,
    c.id as id_canal,
    c.nome as nome_canal,
    c.nro_plataforma,
    p.valor
FROM streaming.Empresa e
JOIN streaming.Patrocinio p ON p.nro_empresa = e.nro
JOIN streaming.Canal c ON c.id = p.id_canal
WHERE e.nro = COALESCE(?, e.nro)  -- Parâmetro opcional
ORDER BY e.nome, c.nome;

-- consultas 2
-- ORIGINAL: Inscricao → Usuario → NivelCanal  
-- OTIMIZADO: Usuario (filtrado) → Inscricao → NivelCanal
SELECT
    u.id as id_usuario,
    u.nick,
    COUNT(DISTINCT i.id_canal) as qtd_canais,
    COALESCE(SUM(nc.valor), 0) as total_mensal
FROM streaming.Usuario u
LEFT JOIN streaming.Inscricao i ON i.id_membro = u.id
LEFT JOIN streaming.NivelCanal nc ON nc.id_canal = i.id_canal AND nc.nivel = i.nivel
WHERE u.id = COALESCE(?, u.id)  -- Parâmetro opcional
GROUP BY u.id, u.nick
ORDER BY u.nick;

--consulta 3
-- ORIGINAL: Doacao → Video → Canal
-- OTIMIZADO: Canal (filtrado) → Subquery Doações
SELECT
    c.id as id_canal,
    c.nome as nome_canal,
    c.nro_plataforma,
    COALESCE(doacoes.total_doacoes, 0) as total_doacoes
FROM streaming.Canal c
LEFT JOIN (
    SELECT 
        id_canal,
        SUM(valor) as total_doacoes
    FROM streaming.Doacao 
    WHERE status_doacao IN ('recebido', 'lido')
    GROUP BY id_canal
) doacoes ON doacoes.id_canal = c.id
WHERE c.id = COALESCE(?, c.id)  -- Parâmetro opcional
ORDER BY total_doacoes DESC;

--consulta 4
-- ORIGINAL: Video → LEFT JOIN Doacao (massivo)
-- OTIMIZADO: Video → Subquery Doações Lidas
SELECT
    v.id as video_id,
    v.titulo,
    v.dataH,
    COALESCE(d.total_lido, 0) as total_doacoes_lidas
FROM streaming.Video v
LEFT JOIN (
    SELECT 
        video_id, 
        id_canal,
        SUM(valor) as total_lido
    FROM streaming.Doacao 
    WHERE status_doacao = 'lido'
    GROUP BY video_id, id_canal
) d ON d.video_id = v.id AND d.id_canal = v.id_canal
WHERE v.id = COALESCE(?, v.id)  -- Parâmetro opcional
ORDER BY total_doacoes_lidas DESC;

--consulta 5
-- ORIGINAL: Patrocinio → Canal
-- OTIMIZADO: Já está bom, apenas ajuste
SELECT
    c.id as id_canal,
    c.nome as nome_canal,
    c.nro_plataforma,
    SUM(p.valor) as total_patrocinio
FROM streaming.Canal c
JOIN streaming.Patrocinio p ON p.id_canal = c.id
GROUP BY c.id, c.nome, c.nro_plataforma
ORDER BY total_patrocinio DESC
LIMIT ?;  -- Parâmetro K


--consulta 6
-- ORIGINAL: Inscricao → Canal → NivelCanal
-- OTIMIZADO: Canal → Inscricao → NivelCanal
SELECT
    c.id as id_canal,
    c.nome as nome_canal,
    c.nro_plataforma,
    COALESCE(SUM(nc.valor), 0) as total_membros
FROM streaming.Canal c
LEFT JOIN streaming.Inscricao i ON i.id_canal = c.id
LEFT JOIN streaming.NivelCanal nc ON nc.id_canal = i.id_canal AND nc.nivel = i.nivel
GROUP BY c.id, c.nome, c.nro_plataforma
ORDER BY total_membros DESC
LIMIT ?;  -- Parâmetro K

--consulta 7

-- ORIGINAL: Doacao → Video → Canal
-- OTIMIZADO: Subquery Doações → Canal
SELECT
    c.id as id_canal,
    c.nome as nome_canal,
    c.nro_plataforma,
    COALESCE(doacoes.total_doacoes, 0) as total_doacoes
FROM streaming.Canal c
LEFT JOIN (
    SELECT 
        id_canal,
        SUM(valor) as total_doacoes
    FROM streaming.Doacao 
    WHERE status_doacao IN ('recebido', 'lido')
    GROUP BY id_canal
) doacoes ON doacoes.id_canal = c.id
ORDER BY total_doacoes DESC
LIMIT ?;  -- Parâmetro K

--consulta 8

-- ORIGINAL: CTEs com JOINs desnecessários
-- OTIMIZADO: CTEs sem JOINs redundantes
WITH pat AS (
    SELECT id_canal, SUM(valor) as total_patrocinio
    FROM streaming.Patrocinio
    GROUP BY id_canal
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
    WHERE status_doacao IN ('recebido', 'lido')
    GROUP BY id_canal
)
SELECT
    c.id as id_canal,
    c.nome as nome_canal,
    c.nro_plataforma,
    COALESCE(pat.total_patrocinio, 0) as total_patrocinio,
    COALESCE(mem.total_membros, 0) as total_membros,
    COALESCE(doac.total_doacoes, 0) as total_doacoes,
    COALESCE(pat.total_patrocinio, 0) + 
    COALESCE(mem.total_membros, 0) + 
    COALESCE(doac.total_doacoes, 0) as total_faturamento
FROM streaming.Canal c
LEFT JOIN pat ON pat.id_canal = c.id
LEFT JOIN mem ON mem.id_canal = c.id
LEFT JOIN doac ON doac.id_canal = c.id
ORDER BY total_faturamento DESC
LIMIT ?;  -- Parâmetro K


----------------------------------------------------------------------------------------------------    CONSULTAS OTIMIZADAS ----------------------------------------------------------------------------
