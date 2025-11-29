
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
