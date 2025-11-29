-- 1) Identificar quais são os canais patrocinados e os valores de patrocínio pagos por empresa. Dar a opção de filtrar os resultados por empresa como um parâmetro opcional na forma de uma stored procedure.

CREATE OR REPLACE FUNCTION f_canais_patrocinados(
    p_nro_empresa INTEGER DEFAULT NULL
)
RETURNS TABLE (
    nro_empresa     INTEGER,
    nome_empresa    VARCHAR,
    id_canal        INTEGER,
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER,
    valor           NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.nro,
        e.nome,
        c.id,
        c.nome,
        p.nro_plataforma,
        p.valor
    FROM Patrocinio p
    JOIN Empresa   e ON e.nro = p.nro_empresa
    JOIN Canal     c ON c.id = p.id_canalSET search_path TO streaming, public;

-- 1) Identificar quais são os canais patrocinados e os valores de patrocínio pagos por empresa.
-- O DDL não tem mais nro_plataforma na PK de Patrocinio, mas o Canal retornado precisa desse campo.
CREATE OR REPLACE FUNCTION f_canais_patrocinados(
    p_nro_empresa INTEGER DEFAULT NULL
)
RETURNS TABLE (
    nro_empresa     INTEGER, -- Tipo nativo da Empresa
    nome_empresa    VARCHAR,
    id_canal        BIGINT, -- Tipo BIGINT do Canal
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER, -- Tipo nativo do Canal
    valor           NUMERIC -- Tipo nativo do Patrocinio
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        e.nro,
        e.nome,
        c.id,
        c.nome,
        c.nro_plataforma,
        p.valor
    FROM Patrocinio p
    JOIN Empresa   e ON e.nro = p.nro_empresa
    JOIN Canal     c ON c.id = p.id_canal
    WHERE p_nro_empresa IS NULL
       OR p.nro_empresa = p_nro_empresa
    ORDER BY e.nome, c.nome;
END;
$$ LANGUAGE plpgsql;

-- 2) Descobrir de quantos canais cada usuário é membro e a soma do valor desembolsado por usuário por mês.
-- Alterações: Inscricao e NivelCanal usam a chave (id_canal, nivel).
CREATE OR REPLACE FUNCTION f_membros_por_usuario(
    p_usuario_id INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_usuario    INTEGER,
    nick          VARCHAR,
    qtd_canais    BIGINT,  -- COUNT retorna BIGINT por padrão
    total_mensal  NUMERIC 
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id,
        u.nick,
        COUNT(DISTINCT i.id_canal), -- Conta a PK do Canal
        COALESCE(SUM(nc.valor), 0::NUMERIC)  -- Garante 0 (Numeric) em vez de NULL
    FROM Inscricao i
    JOIN Usuario  u  ON u.id = i.id_membro
    JOIN NivelCanal nc
         ON nc.id_canal       = i.id_canal
        AND nc.nivel          = i.nivel -- Junção corrigida (sem nro_plataforma)
    WHERE p_usuario_id IS NULL
       OR u.id = p_usuario_id
    GROUP BY u.id, u.nick
    ORDER BY u.nick;
END;
$$ LANGUAGE plpgsql;

-- 3) Listar e ordenar os canais que já receberam doações e a soma dos valores recebidos em doação.
-- Ajuste na junção de Video, pois a PK é (id, id_canal). Plataforma do Canal vem da tabela Canal.
CREATE OR REPLACE FUNCTION f_doacoes_por_canal(
    p_id_canal BIGINT DEFAULT NULL
)
RETURNS TABLE (
    id_canal        BIGINT,
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER,
    total_doacoes   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        c.nro_plataforma,
        SUM(d.valor) AS total_doacoes
    FROM Doacao d
    JOIN Video v
         ON v.id = d.video_id AND v.id_canal = d.id_canal -- Junção por PK de Video
    JOIN Canal c
         ON c.id = v.id_canal
    WHERE d.status_doacao IN ('recebido', 'lido')
      AND (p_id_canal IS NULL OR c.id = p_id_canal)
    GROUP BY c.id, c.nome, c.nro_plataforma
    ORDER BY total_doacoes DESC;
END;
$$ LANGUAGE plpgsql;

-- 4) Listar a soma das doações geradas pelos comentários que foram lidos por vídeo.
-- Ajuste na junção, usando a PK de Video (id, id_canal) para ligar a doação ao vídeo.
CREATE OR REPLACE FUNCTION f_doacoes_lidas_por_video(
    p_video_id INTEGER DEFAULT NULL
)
RETURNS TABLE (
    video_id              INTEGER,
    titulo                VARCHAR,
    dataH                 TIMESTAMP,
    total_doacoes_lidas   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        v.id,
        v.titulo,
        v.dataH,
        COALESCE(SUM(d.valor), 0::NUMERIC) AS total_doacoes_lidas
    FROM Video v
    LEFT JOIN Doacao d
           ON d.video_id   = v.id
          AND d.id_canal   = v.id_canal -- Garantindo a correta ligação doação/vídeo
          AND d.status_doacao  = 'lido'
    WHERE p_video_id IS NULL
       OR v.id = p_video_id
    GROUP BY v.id, v.titulo, v.dataH
    ORDER BY total_doacoes_lidas DESC;
END;
$$ LANGUAGE plpgsql;

-- 5) Listar e ordenar os k canais que mais recebem patrocínio e os valores recebidos.
CREATE OR REPLACE FUNCTION f_topk_canais_patrocinio(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal         BIGINT,
    nome_canal       VARCHAR,
    nro_plataforma   INTEGER,
    total_patrocinio NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        c.nro_plataforma,
        SUM(p.valor) AS total_patrocinio
    FROM Patrocinio p
    JOIN Canal c ON c.id = p.id_canal
    GROUP BY c.id, c.nome, c.nro_plataforma
    ORDER BY total_patrocinio DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;

-- 6) Listar e ordenar os k canais que mais recebem aportes de membros e os valores recebidos.
-- Junção com NivelCanal corrigida (usa id_canal e nivel).
CREATE OR REPLACE FUNCTION f_topk_canais_membros(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal        BIGINT,
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER,
    total_membros   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        c.nro_plataforma,
        COALESCE(SUM(nc.valor), 0::NUMERIC) AS total_membros
    FROM Inscricao i
    JOIN Canal c ON c.id = i.id_canal
    JOIN NivelCanal nc
         ON nc.id_canal  = i.id_canal
        AND nc.nivel     = i.nivel -- Junção correta (sem nro_plataforma)
    GROUP BY c.id, c.nome, c.nro_plataforma
    ORDER BY total_membros DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;

-- 7) Listar e ordenar os k canais que mais receberam doações considerando todos os vídeos.
-- Ajuste na junção de Video, Plataforma do Canal vem da tabela Canal.
CREATE OR REPLACE FUNCTION f_topk_canais_doacoes(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal        BIGINT,
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER,
    total_doacoes   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        c.nro_plataforma,
        SUM(d.valor) AS total_doacoes
    FROM Doacao d
    JOIN Video v ON v.id = d.video_id AND v.id_canal = d.id_canal -- Junção por PK de Video
    JOIN Canal c ON c.id = v.id_canal
    WHERE d.status_doacao IN ('recebido', 'lido')
    GROUP BY c.id, c.nome, c.nro_plataforma
    ORDER BY total_doacoes DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;

-- 8) Listar os k canais que mais faturam considerando as três fontes de receita: patrocínio, membros inscritos e doações.
-- CTEs ajustadas para usar apenas id_canal e junção NivelCanal corrigida.
CREATE OR REPLACE FUNCTION f_topk_canais_faturamento_total(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal          BIGINT,
    nome_canal        VARCHAR,
    nro_plataforma    INTEGER,
    total_patrocinio  NUMERIC,
    total_membros     NUMERIC,
    total_doacoes     NUMERIC,
    total_faturamento NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    WITH pat AS (
        -- Patrocínio: Agregado por id_canal (removido nro_plataforma da agregação)
        SELECT
            id_canal,
            SUM(valor) AS total_patrocinio
        FROM Patrocinio
        GROUP BY id_canal
    ),
    mem AS (
        -- Membros: Junção corrigida e agregada por id_canal
        SELECT
            i.id_canal,
            SUM(nc.valor) AS total_membros
        FROM Inscricao i
        JOIN NivelCanal nc ON nc.id_canal = i.id_canal AND nc.nivel = i.nivel
        GROUP BY i.id_canal
    ),
    doac AS (
        -- Doações: Junção correta por PK do Video e agregada por id_canal
        SELECT
            v.id_canal,
            SUM(d.valor) AS total_doacoes
        FROM Doacao d
        JOIN Video v ON v.id = d.video_id AND v.id_canal = d.id_canal
        WHERE d.status_doacao IN ('recebido', 'lido')
        GROUP BY v.id_canal
    )
    SELECT
        c.id,
        c.nome,
        c.nro_plataforma,
        COALESCE(pat.total_patrocinio, 0::NUMERIC) AS total_patrocinio,
        COALESCE(mem.total_membros,   0::NUMERIC) AS total_membros,
        COALESCE(doac.total_doacoes,  0::NUMERIC) AS total_doacoes,
        COALESCE(pat.total_patrocinio, 0::NUMERIC)
      + COALESCE(mem.total_membros,   0::NUMERIC)
      + COALESCE(doac.total_doacoes,  0::NUMERIC) AS total_faturamento
    FROM Canal c
    LEFT JOIN pat  ON pat.id_canal  = c.id
    LEFT JOIN mem  ON mem.id_canal  = c.id
    LEFT JOIN doac ON doac.id_canal = c.id
    ORDER BY total_faturamento DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;

                    AND c.nro_plataforma = p.nro_plataforma
    WHERE p_nro_empresa IS NULL
       OR p.nro_empresa = p_nro_empresa
    ORDER BY e.nome, c.nome;
END;
$$ LANGUAGE plpgsql;

-- 2) Descobrir de quantos canais cada usuário é membro e a soma do valor desembolsado por usuário por mês. Dar a opção de filtrar os resultados por usuário como um parâmetro opcional na forma de uma stored procedure.

CREATE OR REPLACE FUNCTION f_membros_por_usuario(
    p_usuario_id INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_usuario    INTEGER,
    nick          VARCHAR,
    qtd_canais    INTEGER,
    total_mensal  NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id,
        u.nick,
        COUNT(DISTINCT (i.id_canal, i.nro_plataforma)) AS qtd_canais,
        COALESCE(SUM(nc.valor), 0)                     AS total_mensal
    FROM Inscricao i
    JOIN Usuario  u  ON u.id = i.id_membro
    JOIN NivelCanal nc
         ON nc.id_canal       = i.id_canal
        AND nc.nro_plataforma = i.nro_plataforma
        AND nc.nivel          = i.nivel
    WHERE p_usuario_id IS NULL
       OR u.id = p_usuario_id
    GROUP BY u.id, u.nick
    ORDER BY u.nick;
END;
$$ LANGUAGE plpgsql;

-- 3) Listar e ordenar os canais que já receberam doações e a soma dos valores recebidos em doação. Dar a opção de filtrar os resultados por canal como um parâmetro opcional na forma de uma stored procedure.

CREATE OR REPLACE FUNCTION f_doacoes_por_canal(
    p_id_canal INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_canal        INTEGER,
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER,
    total_doacoes   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        v.nro_plataforma,
        SUM(d.valor) AS total_doacoes
    FROM Doacao d
    JOIN Comentario co
         ON co.video_id   = d.video_id
        AND co.id_usuario = d.id_usuario
        AND co.seq        = d.seq_comentario
    JOIN Video v
         ON v.id = d.video_id
    JOIN Canal c
         ON c.id             = v.id_canal
        AND c.nro_plataforma = v.nro_plataforma
    WHERE d.status_doacao IN ('recebido', 'lido')
      AND (p_id_canal IS NULL OR c.id = p_id_canal)
    GROUP BY c.id, c.nome, v.nro_plataforma
    ORDER BY total_doacoes DESC;
END;
$$ LANGUAGE plpgsql;

-- 4) Listar a soma das doações geradas pelos comentários que foram lidos por vídeo. Dar a opção de filtrar os resultados por vídeo como um parâmetro opcional na forma de uma stored procedure.

CREATE OR REPLACE FUNCTION f_doacoes_lidas_por_video(
    p_video_id INTEGER DEFAULT NULL
)
RETURNS TABLE (
    video_id              INTEGER,
    titulo                VARCHAR,
    dataH                 TIMESTAMP,
    total_doacoes_lidas   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        v.id,
        v.titulo,
        v.dataH,
        COALESCE(SUM(d.valor), 0) AS total_doacoes_lidas
    FROM Video v
    LEFT JOIN Comentario co
           ON co.video_id = v.id
    LEFT JOIN Doacao d
           ON d.video_id       = co.video_id
          AND d.id_usuario     = co.id_usuario
          AND d.seq_comentario = co.seq
          AND d.status_doacao  = 'lido'
    WHERE p_video_id IS NULL
       OR v.id = p_video_id
    GROUP BY v.id, v.titulo, v.dataH
    ORDER BY total_doacoes_lidas DESC;
END;
$$ LANGUAGE plpgsql;

-- 5) Listar e ordenar os k canais que mais recebem patrocínio e os valores recebidos.

CREATE OR REPLACE FUNCTION f_topk_canais_patrocinio(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal         INTEGER,
    nome_canal       VARCHAR,
    nro_plataforma   INTEGER,
    total_patrocinio NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        p.nro_plataforma,
        SUM(p.valor) AS total_patrocinio
    FROM Patrocinio p
    JOIN Canal c
         ON c.id             = p.id_canal
        AND c.nro_plataforma = p.nro_plataforma
    GROUP BY c.id, c.nome, p.nro_plataforma
    ORDER BY total_patrocinio DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;

-- 6) Listar e ordenar os k canais que mais recebem aportes de membros e os valores recebidos.

CREATE OR REPLACE FUNCTION f_topk_canais_membros(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal        INTEGER,
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER,
    total_membros   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        i.nro_plataforma,
        COALESCE(SUM(nc.valor), 0) AS total_membros
    FROM Inscricao i
    JOIN Canal c
         ON c.id             = i.id_canal
        AND c.nro_plataforma = i.nro_plataforma
    JOIN NivelCanal nc
         ON nc.id_canal       = i.id_canal
        AND nc.nro_plataforma = i.nro_plataforma
        AND nc.nivel          = i.nivel
    GROUP BY c.id, c.nome, i.nro_plataforma
    ORDER BY total_membros DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;

-- 7) Listar e ordenar os k canais que mais receberam doações considerando todos os vídeos.

CREATE OR REPLACE FUNCTION f_topk_canais_doacoes(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal        INTEGER,
    nome_canal      VARCHAR,
    nro_plataforma  INTEGER,
    total_doacoes   NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        v.nro_plataforma,
        SUM(d.valor) AS total_doacoes
    FROM Doacao d
    JOIN Comentario co
         ON co.video_id   = d.video_id
        AND co.id_usuario = d.id_usuario
        AND co.seq        = d.seq_comentario
    JOIN Video v
         ON v.id = d.video_id
    JOIN Canal c
         ON c.id             = v.id_canal
        AND c.nro_plataforma = v.nro_plataforma
    WHERE d.status_doacao IN ('recebido', 'lido')
    GROUP BY c.id, c.nome, v.nro_plataforma
    ORDER BY total_doacoes DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;

-- 8) Listar os k canais que mais faturam considerando as três fontes de receita: patrocínio, membros inscritos e doações.

CREATE OR REPLACE FUNCTION f_topk_canais_faturamento_total(
    p_k INTEGER
)
RETURNS TABLE (
    id_canal          INTEGER,
    nome_canal        VARCHAR,
    nro_plataforma    INTEGER,
    total_patrocinio  NUMERIC,
    total_membros     NUMERIC,
    total_doacoes     NUMERIC,
    total_faturamento NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    WITH pat AS (
        SELECT
            p.id_canal,
            p.nro_plataforma,
            SUM(p.valor) AS total_patrocinio
        FROM Patrocinio p
        GROUP BY p.id_canal, p.nro_plataforma
    ),
    mem AS (
        SELECT
            i.id_canal,
            i.nro_plataforma,
            SUM(nc.valor) AS total_membros
        FROM Inscricao i
        JOIN NivelCanal nc
             ON nc.id_canal       = i.id_canal
            AND nc.nro_plataforma = i.nro_plataforma
            AND nc.nivel          = i.nivel
        GROUP BY i.id_canal, i.nro_plataforma
    ),
    doac AS (
        SELECT
            v.id_canal,
            v.nro_plataforma,
            SUM(d.valor) AS total_doacoes
        FROM Doacao d
        JOIN Comentario co
             ON co.video_id   = d.video_id
            AND co.id_usuario = d.id_usuario
            AND co.seq        = d.seq_comentario
        JOIN Video v
             ON v.id = d.video_id
        WHERE d.status_doacao IN ('recebido', 'lido')
        GROUP BY v.id_canal, v.nro_plataforma
    )
    SELECT
        c.id,
        c.nome,
        c.nro_plataforma,
        COALESCE(pat.total_patrocinio, 0) AS total_patrocinio,
        COALESCE(mem.total_membros,   0) AS total_membros,
        COALESCE(doac.total_doacoes,  0) AS total_doacoes,
        COALESCE(pat.total_patrocinio, 0)
      + COALESCE(mem.total_membros,   0)
      + COALESCE(doac.total_doacoes,  0) AS total_faturamento
    FROM Canal c
    LEFT JOIN pat  ON pat.id_canal       = c.id
                  AND pat.nro_plataforma = c.nro_plataforma
    LEFT JOIN mem  ON mem.id_canal       = c.id
                  AND mem.nro_plataforma = c.nro_plataforma
    LEFT JOIN doac ON doac.id_canal      = c.id
                  AND doac.nro_plataforma = c.nro_plataforma
    ORDER BY total_faturamento DESC
    LIMIT p_k;
END;
$$ LANGUAGE plpgsql;
