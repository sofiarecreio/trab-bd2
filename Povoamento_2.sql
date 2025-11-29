-- ============================================================
--  SCRIPT UNIFICADO: INSERÇÕES ADICIONAIS (complementares)
--  Conteúdo: Conversao, Empresa, Pais, EmpresaPais, Plataforma,
--           Usuario(51-70), PlataformaUsuario, StreamerPais,
--           Canal, NivelCanal, Video (501-550),
--           Participa, Comentario (500 extras), Doacao, CartaoCredito,
--           PayPal, MecanismoPlat, Bitcoin
-- ============================================================

-- =========================
-- 1) Conversao (novas moedas)
-- =========================
INSERT INTO Conversao (id, moeda, nome, fator_conver) VALUES
(4, 'JPY', 'Iene Japonês', 138.20),
(5, 'GBP', 'Libra Esterlina', 0.79),
(6, 'AUD', 'Dólar Australiano', 1.51),
(7, 'CAD', 'Dólar Canadense', 1.36),
(8, 'CHF', 'Franco Suíço', 0.91)
ON CONFLICT (id) DO NOTHING;

-- =========================
-- 2) Empresa (106-115)
-- =========================
INSERT INTO Empresa (nro, nome, nome_fantasia) VALUES
(106, 'TechNova Global S.A.', 'TechNova'),
(107, 'MediaWorld Networks Ltd.', 'MWN'),
(108, 'Stream Unlimited Corp.', 'StreamU'),
(109, 'Digital Planet S.A.', 'DigiPlanet'),
(110, 'RedWave Entertainment Ltd.', 'RedWave'),
(111, 'FutureVision Labs S.A.', 'FVLabs'),
(112, 'PrimeCast Media Corp.', 'PrimeCast'),
(113, 'Soluções de Dados Orion Ltda.', 'OrionData'),
(114, 'Intellisys Inteligência Digital S.A.', 'IntelliSys'),
(115, 'GlobeCloud Innovations Inc.', 'GlobeCloud')
ON CONFLICT (nro) DO NOTHING;

-- =========================
-- 3) Pais (amostras adicionais)
--    Observação: id_moeda refere-se à tabela Conversao (1=USD,2=EUR,3=BRL,4=JPY,5=GBP,6=AUD,7=CAD,8=CHF)
-- =========================
INSERT INTO Pais (ddi, nome, id_moeda) VALUES
(81, 'Japão', 4),        -- JPY
(49, 'Alemanha', 2),     -- EUR
(34, 'Espanha', 2),      -- EUR
(61, 'Austrália', 6),    -- AUD
(39, 'Itália', 2),       -- EUR
(41, 'Suíça', 8)         -- CHF
ON CONFLICT (ddi) DO NOTHING;

-- =========================
-- 4) EmpresaPais (ampliação)
-- =========================
INSERT INTO EmpresaPais (nro_empresa, ddi_pais, id_nacional) VALUES
(106, 1, 6001),
(106, 49, 6002),
(107, 81, 6003),
(107, 33, 6004),
(108, 55, 6005),
(109, 34, 6006),
(110, 49, 6007),
(111, 1, 6008),
(112, 61, 6009),
(113, 39, 6010)
ON CONFLICT DO NOTHING;

-- =========================
-- 5) Plataforma (4-8)
-- =========================
INSERT INTO Plataforma (nro, nome, qtd_users, empresa_fund, empresa_respo, data_fund) VALUES
(4, 'UltraPlay', 0, 106, 107, '2021-02-10'),
(5, 'VisionCast', 0, 108, 108, '2018-12-01'),
(6, 'StreamWorld', 0, 109, 110, '2020-09-17'),
(7, 'ClipHub', 0, 111, 112, '2022-04-22'),
(8, 'WaveMedia', 0, 113, 115, '2019-11-03')
ON CONFLICT (nro) DO NOTHING;

-- =========================
-- 6) Usuario (IDs 51-70) - conforme bloco que você confirmou
-- =========================
INSERT INTO Usuario (id, nick, email, data_nasc, telefone, end_postal, pais_residencia) VALUES
(51, 'User51', 'user51@email.com', '1994-06-10', '+49 151-051', 'Address 51', 49),
(52, 'User52', 'user52@email.com', '1990-12-01', '+39 340-052', 'Address 52', 39),
(53, 'User53', 'user53@email.com', '1995-02-22', '+81 80-053', 'Address 53', 81),
(54, 'User54', 'user54@email.com', '1991-09-13', '+61 04-054', 'Address 54', 61),
(55, 'User55', 'user55@email.com', '1993-03-08', '+34 611-055', 'Address 55', 34),
(56, 'User56', 'user56@email.com', '1989-05-30', '+41 079-056', 'Address 56', 41),
(57, 'User57', 'user57@email.com', '1997-07-17', '+49 152-057', 'Address 57', 49),
(58, 'User58', 'user58@email.com', '1992-11-29', '+34 622-058', 'Address 58', 34),
(59, 'User59', 'user59@email.com', '1998-10-04', '+61 04-059', 'Address 59', 61),
(60, 'User60', 'user60@email.com', '1994-01-26', '+81 70-060', 'Address 60', 81),

(61, 'User61', 'user61@email.com', '1996-02-18', '+39 347-061', 'Address 61', 39),
(62, 'User62', 'user62@email.com', '1999-08-23', '+41 078-062', 'Address 62', 41),
(63, 'User63', 'user63@email.com', '1993-09-02', '+49 162-063', 'Address 63', 49),
(64, 'User64', 'user64@email.com', '1988-12-11', '+61 04-064', 'Address 64', 61),
(65, 'User65', 'user65@email.com', '1991-04-14', '+34 633-065', 'Address 65', 34),
(66, 'User66', 'user66@email.com', '1990-03-03', '+39 349-066', 'Address 66', 39),
(67, 'User67', 'user67@email.com', '1997-06-21', '+41 079-067', 'Address 67', 41),
(68, 'User68', 'user68@email.com', '1992-10-19', '+81 80-068', 'Address 68', 81),
(69, 'User69', 'user69@email.com', '1998-11-28', '+61 04-069', 'Address 69', 61),
(70, 'User70', 'user70@email.com', '1995-08-07', '+34 644-070', 'Address 70', 34)
ON CONFLICT (id) DO NOTHING;

-- =========================
-- 7) PlataformaUsuario (atribuir os novos usuários às novas plataformas)
--    - Números nro_usuario são artificiais (não colidem com os existentes)
-- =========================
INSERT INTO PlataformaUsuario (nro_plataforma, usuario_id, nro_usuario) VALUES
(4, 51, 4001),
(4, 52, 4002),
(4, 53, 4003),
(5, 54, 5001),
(5, 55, 5002),
(5, 56, 5003),
(6, 57, 6001),
(6, 58, 6002),
(6, 59, 6003),
(7, 60, 7001),
(7, 61, 7002),
(7, 62, 7003),
(8, 63, 8001),
(8, 64, 8002),
(8, 65, 8003),
(4, 66, 4004),
(5, 67, 5004),
(6, 68, 6004),
(7, 69, 7004),
(8, 70, 8004)
ON CONFLICT DO NOTHING;

-- =========================
-- 8) StreamerPais (adicionais representativos)
-- =========================
INSERT INTO StreamerPais (streamer_id, ddi_pais, nro_passaporte) VALUES
(3, 49, 888111222),
(4, 39, 991122334),
(5, 81, 554433221)
ON CONFLICT DO NOTHING;

-- =========================
-- 9) Canal (novos canais para plataformas 4-6)
-- =========================
INSERT INTO Canal (id, nome, tipo, data_fund, descricao, qtd_visualizacoes, id_streamer, nro_plataforma) VALUES
(500, 'TechGlobal', 'publico', '2022-01-01', 'Tech reviews globais', 18000, 51, 4),
(501, 'CozinhaMundo', 'publico', '2021-11-10', 'Receitas do mundo', 24000, 52, 4),
(502, 'AsiaGamer', 'publico', '2020-04-20', 'Jogos asiáticos', 32000, 53, 5),
(503, 'EuroNews', 'misto', '2019-03-01', 'Notícias e análises europeias', 15000, 54, 6)
ON CONFLICT (id) DO NOTHING;

-- =========================
-- 10) NivelCanal (para novos canais)
-- =========================
INSERT INTO NivelCanal (id_canal, nro_plataforma, nivel, valor, gif) VALUES
(500, 4, 'FREE',     0.00, 'free.gif'),
(500, 4, 'BASIC',   10.00, 'basic.gif'),
(500, 4, 'PREMIUM', 25.00, 'premium.gif'),

(501, 4, 'FREE',     0.00, 'free.gif'),
(501, 4, 'BASIC',   12.00, 'basic_p4.gif'),
(501, 4, 'PREMIUM', 28.00, 'premium_p4.gif'),

(502, 5, 'FREE',     0.00, 'free.gif'),
(502, 5, 'BASIC',    8.00, 'basic_p5.gif'),
(502, 5, 'PREMIUM', 22.00, 'premium_p5.gif')
ON CONFLICT DO NOTHING;

-- =========================
-- 11) Video (50 novos: IDs 501..550)
--     - usa generate_series para criar 50 vídeos extras
-- =========================
INSERT INTO Video (id, id_canal, nro_plataforma, dataH, titulo, tema, duracao, visu_simul, visu_total)
SELECT
    500 + gs.i AS id,
    CASE WHEN (gs.i % 3) = 0 THEN 500 WHEN (gs.i % 3) = 1 THEN 502 ELSE 503 END AS id_canal,
    CASE WHEN (gs.i % 3) = 1 THEN 5 ELSE 4 END AS nro_plataforma,
    (TIMESTAMP '2023-01-01 10:00:00' + interval '1 hour' * gs.i) AS dataH,
    'Extra Video ' || (500 + gs.i) AS titulo,
    'Tema Extra ' || (gs.i % 5) AS tema,
    (10.0 + (gs.i % 7)) AS duracao,
    (gs.i % 120) AS visu_simul,
    (2000 + gs.i * 3) AS visu_total
FROM generate_series(1,50) AS gs(i);

-- =========================
-- 12) Participa (10 participações extras para vídeos 501..510)
-- =========================
INSERT INTO Participa (video_id, id_streamer, id_canal, nro_plataforma)
SELECT v.id, ((v.id % 10) + 51) AS id_streamer, v.id_canal, v.nro_plataforma
FROM Video v
WHERE v.id BETWEEN 501 AND 510
ON CONFLICT DO NOTHING;

-- =========================
-- 13) Comentario (500 comentários extras sobre vídeos 501..550)
--     - seq varia 1..10, id_usuario entre 51..70
-- =========================
INSERT INTO Comentario (video_id, id_canal, id_usuario, seq, texto, dataH, coment_on, nro_plataforma)
SELECT
    ((gs.i % 50) + 501) AS video_id,
    CASE 
        WHEN (((gs.i % 50) + 1) % 5) = 0 THEN 500
        WHEN (((gs.i % 50) + 1) % 5) = 1 THEN 502
        WHEN (((gs.i % 50) + 1) % 5) = 2 THEN 503
        WHEN (((gs.i % 50) + 1) % 5) = 3 THEN 501
        ELSE 500
    END AS id_canal,
    ((gs.i % 20) + 51) AS id_usuario, -- Usuários ID 51 a 70
    (gs.i % 10) + 1 AS seq,
    'Comentário extra ' || gs.i || ' no vídeo ' || ((gs.i % 50) + 501) AS texto,
    (TIMESTAMP '2023-06-01 10:00:00' + interval '1 minute' * gs.i) AS dataH,
    TRUE AS coment_on,
    CASE WHEN (((gs.i % 50) + 1) % 5) = 1 THEN 5 ELSE 4 END AS nro_plataforma
FROM generate_series(1,500) AS gs(i);

-- =========================
-- 14) Doacao (50 doações extra)
--     - Seleção: comentários dos vídeos 501..550 onde seq % 5 = 0
-- =========================
WITH novos_coment AS (
    SELECT
        c.video_id,
        c.id_canal,
        c.nro_plataforma,
        c.id_usuario,
        c.seq
    FROM Comentario c
    WHERE c.video_id BETWEEN 501 AND 550
      AND (c.seq % 5) = 0
    ORDER BY c.video_id, c.seq
    LIMIT 50
)
INSERT INTO Doacao (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, valor, status_doacao)
SELECT
    video_id,
    id_canal,
    nro_plataforma,
    id_usuario,
    seq,
    1,
    (10.0 + (seq % 20) * 0.5),
    CASE seq % 3 WHEN 0 THEN 'recebido' WHEN 1 THEN 'lido' ELSE 'recusado' END
FROM novos_coment
ON CONFLICT DO NOTHING;

-- =========================
-- 15) CartaoCredito (25 primeiras doações entre as novas)
-- =========================
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario
           ) AS rn
    FROM Doacao
    WHERE video_id BETWEEN 501 AND 550
)
INSERT INTO CartaoCredito (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, dataH, nro, bandeira)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    NOW(),
    '400099887766' || (1000 + rn),
    CASE rn % 2 WHEN 0 THEN 'Visa' ELSE 'MasterCard' END
FROM d
WHERE rn BETWEEN 1 AND 25
ON CONFLICT DO NOTHING;

-- =========================
-- 16) PayPal (doações 26 a 35)
-- =========================
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario
           ) AS rn
    FROM Doacao
    WHERE video_id BETWEEN 501 AND 550
)
INSERT INTO PayPal (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, IdPayPal)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    'PPNEW-' || (20000 + rn)
FROM d
WHERE rn BETWEEN 26 AND 35
ON CONFLICT DO NOTHING;

-- =========================
-- 17) MecanismoPlat (doações 36 a 45)
-- =========================
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario
           ) AS rn
    FROM Doacao
    WHERE video_id BETWEEN 501 AND 550
)
INSERT INTO MecanismoPlat (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, seq_plataforma)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    'SEQPLT-NEW-' || (30000 + rn)
FROM d
WHERE rn BETWEEN 36 AND 45
ON CONFLICT DO NOTHING;

-- =========================
-- 18) Bitcoin (doações 46 a 50)
-- =========================
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario
           ) AS rn
    FROM Doacao
    WHERE video_id BETWEEN 501 AND 550
)
INSERT INTO Bitcoin (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, TxID)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    'TXNEW-' || (40000 + rn)
FROM d
WHERE rn BETWEEN 46 AND 50
ON CONFLICT DO NOTHING;

-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
