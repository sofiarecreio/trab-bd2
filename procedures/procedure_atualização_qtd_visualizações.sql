CREATE OR REPLACE PROCEDURE streaming.sp_registrar_visualizacao(
    p_video_id INTEGER, 
    p_id_canal BIGINT, 
    p_novas_simultaneas INTEGER, 
    p_incremento_total INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    
    UPDATE streaming.Video
    SET 
        visu_simul = p_novas_simultaneas,
        visu_total = visu_total + p_incremento_total
    WHERE id = p_video_id 
      AND id_canal = p_id_canal; 

    -- 2. Atualiza o CANAL (Consistência derivada)
    UPDATE streaming.Canal
    SET qtd_visualizacoes = qtd_visualizacoes + p_incremento_total
    WHERE id = p_id_canal;
END;
$$;