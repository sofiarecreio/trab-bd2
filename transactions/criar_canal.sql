BEGIN;

-- 1) Verificar se o streamer está cadastrado na plataforma antes de criar o canal
SELECT 1
FROM streaming.PlataformaUsuario pu
WHERE pu.nro_plataforma = :p_nro_plataforma
  AND pu.usuario_id = :p_id_streamer
FOR UPDATE;  -- Bloqueia para garantir que o streamer já existe na plataforma

-- 2) Criar o canal para o streamer
INSERT INTO streaming.Canal (
  id, nome, tipo, data_fund, descricao,
  id_streamer, nro_plataforma
) VALUES (
  :p_id_canal,               -- ID do canal (gerado automaticamente ou passado)
  :p_nome_canal,             -- Nome do canal
  :p_tipo_canal,             -- Tipo de canal (privado, público, misto)
  :p_data_fund,              -- Data de fundação do canal
  :p_descricao,              -- Descrição do canal
  :p_id_streamer,            -- ID do streamer (usuário)
  :p_nro_plataforma          -- Número da plataforma
);

-- 3) Criar os 5 níveis de membro para o canal
INSERT INTO streaming.NivelCanal (
  id_canal, nivel, valor, gif
) VALUES
  (:p_id_canal, 'FREE',    :p_valor_free,    :p_gif_free),
  (:p_id_canal, 'BASIC',   :p_valor_basic,   :p_gif_basic),
  (:p_id_canal, 'PREMIUM', :p_valor_premium, :p_gif_premium),
  (:p_id_canal, 'DIAMOND', :p_valor_diamond, :p_gif_diamond),
  (:p_id_canal, 'PLATINUM',:p_valor_platinum,:p_gif_platinum);

COMMIT;
