CREATE OR REPLACE PROCEDURE streaming.sp_registrar_doacao_multimeios(
    -- 1. Dados da Doação (Pai)
    p_video_id INTEGER,
    p_id_canal BIGINT,
    p_id_usuario INTEGER,
    p_seq_comentario INTEGER,
    p_seq_pg INTEGER,
    p_valor DECIMAL,
    p_metodo_pagamento VARCHAR, -- 'CC', 'BTC', 'PAYPAL', 'PLAT'

    -- 2. Dados Cartão de Crédito (Opcional)
    p_cc_nro VARCHAR DEFAULT NULL,
    p_cc_bandeira VARCHAR DEFAULT NULL,
    p_cc_datah TIMESTAMP DEFAULT NULL,

    -- 3. Dados Bitcoin (Opcional)
    p_btc_txid VARCHAR DEFAULT NULL,

    -- 4. Dados PayPal (Opcional)
    p_paypal_id VARCHAR DEFAULT NULL,

    -- 5. Dados Mecanismo Plataforma (Opcional)
    p_plat_seq VARCHAR DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    -- [INÍCIO DA TRANSAÇÃO IMPLÍCITA]
    -- O banco inicia o monitoramento aqui.

    -- =================================================================
    -- PASSO 1: LOCK (Garantia de Isolamento)
    -- =================================================================
    -- Bloqueamos a linha do comentário. Ninguém pode deletar esse comentário
    -- enquanto esta transação não terminar.
    PERFORM 1
    FROM streaming.Comentario c
    WHERE c.video_id = p_video_id
      AND c.id_canal = p_id_canal
      AND c.id_usuario = p_id_usuario
      AND c.seq = p_seq_comentario
    FOR UPDATE; -- <--- O BLOQUEIO ACONTECE AQUI

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Comentário não encontrado. Transação abortada.';
    END IF;

    -- =================================================================
    -- PASSO 2: INSERIR PAI (Doacao)
    -- =================================================================
    INSERT INTO streaming.Doacao (
        video_id, id_canal, id_usuario, seq_comentario, seq_pg,
        valor, status_doacao
    ) VALUES (
        p_video_id, p_id_canal, p_id_usuario, p_seq_comentario, p_seq_pg,
        p_valor, 'recebido'
    );

    -- =================================================================
    -- PASSO 3: INSERIR FILHO (Detalhe Pagamento)
    -- =================================================================
    -- Aqui garantimos que não existe Doação sem método de pagamento.
    
    -- CASO A: Cartão de Crédito
    IF p_metodo_pagamento = 'CC' THEN
        IF p_cc_nro IS NULL OR p_cc_bandeira IS NULL THEN
            RAISE EXCEPTION 'Dados de Cartão incompletos. Rollback acionado.';
        END IF;

        INSERT INTO streaming.CartaoCredito (
            video_id, id_canal, id_usuario, seq_comentario, seq_pg,
            nro, bandeira, dataH
        ) VALUES (
            p_video_id, p_id_canal, p_id_usuario, p_seq_comentario, p_seq_pg,
            p_cc_nro, p_cc_bandeira, COALESCE(p_cc_datah, NOW())
        );

    -- CASO B: Bitcoin
    ELSIF p_metodo_pagamento = 'BTC' THEN
        IF p_btc_txid IS NULL THEN
            RAISE EXCEPTION 'TxID obrigatório. Rollback acionado.';
        END IF;

        INSERT INTO streaming.Bitcoin (
            video_id, id_canal, id_usuario, seq_comentario, seq_pg,
            TxID
        ) VALUES (
            p_video_id, p_id_canal, p_id_usuario, p_seq_comentario, p_seq_pg,
            p_btc_txid
        );

    -- CASO C: PayPal
    ELSIF p_metodo_pagamento = 'PAYPAL' THEN
        IF p_paypal_id IS NULL THEN
            RAISE EXCEPTION 'ID PayPal obrigatório. Rollback acionado.';
        END IF;

        INSERT INTO streaming.PayPal (
            video_id, id_canal, id_usuario, seq_comentario, seq_pg,
            IdPayPal
        ) VALUES (
            p_video_id, p_id_canal, p_id_usuario, p_seq_comentario, p_seq_pg,
            p_paypal_id
        );

    -- CASO D: Mecanismo Próprio
    ELSIF p_metodo_pagamento = 'PLAT' THEN
        IF p_plat_seq IS NULL THEN
            RAISE EXCEPTION 'Sequencial obrigatório. Rollback acionado.';
        END IF;

        INSERT INTO streaming.MecanismoPlat (
            video_id, id_canal, id_usuario, seq_comentario, seq_pg,
            seq_plataforma
        ) VALUES (
            p_video_id, p_id_canal, p_id_usuario, p_seq_comentario, p_seq_pg,
            p_plat_seq
        );

    ELSE
        RAISE EXCEPTION 'Método inválido: %. Transação abortada.', p_metodo_pagamento;
    END IF;

    -- [FIM DA TRANSAÇÃO]
    -- Se chegou aqui sem erros, os dados estão prontos para o Commit.
    -- O Commit real é feito por quem chamou a procedure (seu Python ou cliente SQL).
END;
$$;