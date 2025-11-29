BEGIN;

-- 1) Verificar se o comentário existe antes de registrar a doação
-- (Isso garante que a doação não será associada a um comentário inexistente)
SELECT 1
FROM streaming.Comentario c
WHERE c.video_id = :p_video_id
  AND c.id_canal = :p_id_canal
  AND c.nro_plataforma = :p_nro_plataforma
  AND c.id_usuario = :p_id_usuario
  AND c.seq = :p_seq_comentario
FOR UPDATE;  -- Bloqueia a linha do comentário para evitar condições de corrida

-- 2) Registrar a doação
INSERT INTO streaming.Doacao (
  video_id, id_canal, nro_plataforma,
  id_usuario, seq_comentario, seq_pg,
  valor, status_doacao
) VALUES (
  :p_video_id,
  :p_id_canal,
  :p_nro_plataforma,
  :p_id_usuario,
  :p_seq_comentario,
  :p_seq_pg,
  :p_valor,
  :p_status_doacao -- 'recusado', 'recebido', 'lido'
);

-- 3) Registrar o pagamento via Cartão de Crédito (por exemplo)
INSERT INTO streaming.CartaoCredito (
  video_id, id_canal, nro_plataforma,
  id_usuario, seq_comentario, seq_pg,
  dataH, nro, bandeira
) VALUES (
  :p_video_id,
  :p_id_canal,
  :p_nro_plataforma,
  :p_id_usuario,
  :p_seq_comentario,
  :p_seq_pg,
  :p_dataH_pg,          -- data/hora da transação
  :p_nro_cartao,        -- número do cartão
  :p_bandeira           -- bandeira do cartão (Visa, MasterCard, etc.)
);

-- 4) (Opcional) Registrar outros métodos de pagamento (Bitcoin, PayPal, MecanismoPlat)
-- Crie as inserções necessárias para os outros métodos de pagamento (se houver).

COMMIT;
