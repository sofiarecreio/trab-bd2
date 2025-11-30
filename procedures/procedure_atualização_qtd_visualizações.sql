CREATE OR REPLACE PROCEDURE streaming.sp_registrar_visualizacao(
    p_video_id INTEGER, 
    p_id_canal BIGINT, 
    p_novas_simultaneas INTEGER, 
    p_incremento_total INTEGER
)
LANGUAGE plpgsql AS $$
DECLARE
    v_video_atualizado INTEGER;
    v_canal_atualizado INTEGER;
BEGIN
    -- 1. Tenta atualizar o VÍDEO
    UPDATE streaming.Video
    SET 
        visu_simul = p_novas_simultaneas,
        visu_total = visu_total + p_incremento_total
    WHERE id = p_video_id 
      AND id_canal = p_id_canal; -- Garante que o vídeo pertence ao canal

    -- Verifica quantas linhas foram afetadas
    GET DIAGNOSTICS v_video_atualizado = ROW_COUNT;

    -- 2. Tenta atualizar o CANAL
    UPDATE streaming.Canal
    SET qtd_visualizacoes = qtd_visualizacoes + p_incremento_total
    WHERE id = p_id_canal;

    -- Verifica quantas linhas foram afetadas
    GET DIAGNOSTICS v_canal_atualizado = ROW_COUNT;

    -- =========================================================
    -- LÓGICA DE TRANSAÇÃO (ATOMICIDADE)
    -- =========================================================
    
    -- Se o vídeo não existe, não faz sentido contar no canal (inconsistência)
    IF v_video_atualizado = 0 THEN
        RAISE EXCEPTION 'erro no video', p_video_id, p_id_canal;
    END IF;

    -- Se o canal não existe (mas o vídeo existia?), temos um erro grave de integridade
    IF v_canal_atualizado = 0 THEN
        RAISE EXCEPTION 'erro no canal', p_id_canal;
    END IF;

    -- Se chegou até aqui sem erros, o COMMIT acontece automaticamente ao final da chamada.

EXCEPTION
    WHEN OTHERS THEN
        -- O PostgreSQL faz o ROLLBACK automático de TUDO o que foi feito neste bloco
        -- ao capturar uma exceção não tratada ou relançada.
        RAISE NOTICE 'Erro na transação: %. Desfazendo alterações...', SQLERRM;
        RAISE; -- Relança o erro para quem chamou saber que falhou
END;
$$;