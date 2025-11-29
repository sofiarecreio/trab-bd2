CREATE MATERIALIZED VIEW streaming.vw_qtd_visualizacoes_canal AS
SELECT
    c.id AS canal_id,
    c.nro_plataforma,
    SUM(v.visu_total) AS qtd_visualizacoes
FROM streaming.Canal c
JOIN streaming.Video v
    ON v.id_canal = c.id
    AND v.nro_plataforma = c.nro_plataforma
GROUP BY c.id, c.nro_plataforma;

CREATE OR REPLACE PROCEDURE refresh_qtd_visualizacoes_canal()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Atualiza (refresh) a view materializada para garantir que os dados estejam atualizados
    REFRESH MATERIALIZED VIEW streaming.vw_qtd_visualizacoes_canal;

    -- (Opcional) Você pode adicionar lógica de verificação ou logging aqui
END;
$$;

CREATE OR REPLACE FUNCTION trg_refresh_qtd_visualizacoes_canal()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualiza (refresh) a view materializada sempre que um vídeo for alterado
    PERFORM refresh_qtd_visualizacoes_canal();
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Criando a trigger na tabela Video para atualizar a view quando houver inserção, atualização ou remoção
CREATE TRIGGER trg_video_refresh_qtd_visualizacoes_canal
AFTER INSERT OR UPDATE OR DELETE ON streaming.Video
FOR EACH STATEMENT
EXECUTE FUNCTION trg_refresh_qtd_visualizacoes_canal();
