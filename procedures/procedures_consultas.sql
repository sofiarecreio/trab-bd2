-- =====================================================================
-- CONSULTA 1: Canais Patrocinados e Valores
-- Fonte: View Virtual 'v_rel_patrocinios'
-- Otimização: Filtro opcional processado pelo banco de forma eficiente.
-- =====================================================================
CREATE OR REPLACE FUNCTION streaming.sp_relatorio_patrocinios(p_nro_empresa INTEGER DEFAULT NULL)
RETURNS TABLE (
    empresa_nome VARCHAR, 
    canal_nome VARCHAR, 
    valor_pago DECIMAL
) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.nome_empresa, 
        v.nome_canal, 
        v.valor
    FROM streaming.v_rel_patrocinios v
    WHERE (p_nro_empresa IS NULL OR v.nro_empresa = p_nro_empresa)
    ORDER BY v.nome_empresa, v.valor DESC;
END;
$$;

-- =====================================================================
-- CONSULTA 2: Membros por Usuário e Gasto Mensal
-- Fonte: View Virtual 'v_rel_membros'
-- Otimização: Usa o Índice 1 (idx_inscricao_membro) para evitar Full Scan.
-- =====================================================================
CREATE OR REPLACE FUNCTION streaming.sp_relatorio_usuarios(p_id_usuario INTEGER DEFAULT NULL)
RETURNS TABLE (
    nick_usuario VARCHAR, 
    qtd_canais BIGINT, 
    total_gasto_mensal DECIMAL
) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.nick, 
        COUNT(DISTINCT v.id_canal), 
        COALESCE(SUM(v.valor), 0)
    FROM streaming.v_rel_membros v
    WHERE (p_id_usuario IS NULL OR v.id_usuario = p_id_usuario)
    GROUP BY v.id_usuario, v.nick
    ORDER BY v.nick;
END;
$$;

-- =====================================================================
-- CONSULTA 3: Doações Recebidas por Canal
-- Fonte: View Materializada 'mv_faturamento_geral'
-- Otimização: Leitura instantânea (O(1)) de dados pré-calculados.
-- =====================================================================
CREATE OR REPLACE FUNCTION streaming.sp_doacoes_por_canal(p_id_canal BIGINT DEFAULT NULL)
RETURNS TABLE (
    canal_nome VARCHAR, 
    total_recebido DECIMAL
) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        mv.nome_canal, 
        mv.f_doacoes
    FROM streaming.mv_faturamento_geral mv
    WHERE mv.f_doacoes > 0
    AND (p_id_canal IS NULL OR mv.id_canal = p_id_canal)
    ORDER BY mv.f_doacoes DESC;
END;
$$;

-- =====================================================================
-- CONSULTA 4: Doações Lidas por Vídeo
-- Fonte: View Virtual 'v_doacoes_video_lidas'
-- Otimização: Usa o Índice 4 (Parcial) para filtrar apenas doações 'lido'.
-- =====================================================================
CREATE OR REPLACE FUNCTION streaming.sp_doacoes_video_lidas(p_video_id INTEGER DEFAULT NULL)
RETURNS TABLE (
    titulo_video VARCHAR, 
    data_postagem TIMESTAMP,
    total_lido DECIMAL
) 
LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.titulo, 
        v.dataH, 
        v.total_lido
    FROM streaming.v_doacoes_video_lidas v
    WHERE (p_video_id IS NULL OR v.video_id = p_video_id)
    ORDER BY v.total_lido DESC;
END;
$$;

-- =====================================================================
-- CONSULTAS 5, 6, 7 e 8: Rankings (Top K)
-- Fonte: View Materializada 'mv_faturamento_geral'
-- Otimização: Uma única procedure atende 4 requisitos de ranking usando a MV.
-- Parâmetros: p_tipo (1=Patrocinio, 2=Membros, 3=Doacao, 4=Total), p_limit (K)
-- =====================================================================
CREATE OR REPLACE FUNCTION streaming.sp_ranking_canais(p_tipo INTEGER, p_limit INTEGER)
RETURNS TABLE (
    posicao BIGINT, 
    canal VARCHAR,  
    valor_total DECIMAL
) 
LANGUAGE plpgsql AS $$
BEGIN
    IF p_tipo = 1 THEN -- Ranking Patrocínio
        RETURN QUERY SELECT RANK() OVER (ORDER BY f_patrocinio DESC), nome_canal, f_patrocinio 
        FROM streaming.mv_faturamento_geral ORDER BY f_patrocinio DESC LIMIT p_limit;
        
    ELSIF p_tipo = 2 THEN -- Ranking Membros
        RETURN QUERY SELECT RANK() OVER (ORDER BY f_membros DESC), nome_canal, f_membros 
        FROM streaming.mv_faturamento_geral ORDER BY f_membros DESC LIMIT p_limit;
        
    ELSIF p_tipo = 3 THEN -- Ranking Doações
        RETURN QUERY SELECT RANK() OVER (ORDER BY f_doacoes DESC), nome_canal, f_doacoes 
        FROM streaming.mv_faturamento_geral ORDER BY f_doacoes DESC LIMIT p_limit;
        
    ELSE -- Ranking Faturamento Total
        RETURN QUERY SELECT RANK() OVER (ORDER BY f_total DESC), nome_canal, f_total 
        FROM streaming.mv_faturamento_geral ORDER BY f_total DESC LIMIT p_limit;
    END IF;
END;
$$;