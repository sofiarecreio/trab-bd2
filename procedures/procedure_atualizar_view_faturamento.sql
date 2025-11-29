CREATE OR REPLACE PROCEDURE streaming.sp_atualizar_sistema()
LANGUAGE plpgsql AS $$
DECLARE
    v_ultima TIMESTAMP;
BEGIN
    -- (Opcional) Se tiver tabela de controle, verifique aqui.
    -- Se não tiver, assume-se que o agendador externo (cron) chama a cada 30min.

    -- O comando MÁGICO que permite fazer isso a cada 30min sem medo:
    REFRESH MATERIALIZED VIEW CONCURRENTLY streaming.mv_faturamento_geral;
    
    RAISE NOTICE 'Rankings atualizados. Próxima atualização em 30 min.';
END;
$$;