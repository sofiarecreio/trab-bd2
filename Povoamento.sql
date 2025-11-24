-- ====================================================
-- SCRIPT CORRIGIDO E LIMPO
-- Correções aplicadas:
-- 1) Removidas duplicações de INSERT em Inscricao.
-- 2) Corrigido PlataformaUsuario (5002 -> 3023).
-- 3) Mantida apenas uma inserção para Participa (a que faz JOIN com Video).
-- 4) Case do Comentario completado.
-- 5) Mantive NivelCanal para canais 10,20,30,40,50 (assumindo que não há tabela separada de "Canal").
-- ====================================================

-- 1) Conversao
INSERT INTO Conversao (id, moeda, nome, fator_conver) VALUES
(1, 'USD', 'Dólar Americano', 1.0000),
(2, 'EUR', 'Euro', 0.9234),
(3, 'BRL', 'Real Brasileiro', 5.0500);

-- 2) Empresa
INSERT INTO Empresa (nro, nome, nome_fantasia) VALUES
(101, 'Empresa Fundadora A S.A.', 'TechCorp'),
(102, 'Empresa Responsável B Ltda.', 'StreamBoss'),
(103, 'Global Investimentos S.A.', 'GInvest'),
(104, 'E-Commerce Gigante Inc.', 'BuyAll'),
(105, 'Estúdios de Produção XYZ', 'XYZ Studios');

-- 3) Pais
INSERT INTO Pais (ddi, nome, id_moeda) VALUES
(1, 'Estados Unidos', 1),
(33, 'França', 2),
(55, 'Brasil', 3),
(44, 'Reino Unido', 1);

-- 4) EmpresaPais
INSERT INTO EmpresaPais (nro_empresa, ddi_pais, id_nacional) VALUES
(101, 1, 1001), (101, 33, 1002), (101, 55, 1003),
(102, 1, 2001), (102, 44, 2002),
(103, 1, 3001), (103, 55, 3002),
(104, 33, 4001),
(105, 55, 5001), (105, 44, 5002);

-- 5) Plataforma
INSERT INTO Plataforma (nro, nome, qtd_users, empresa_fund, empresa_respo, data_fund) VALUES
(1, 'MegaStream', 0, 101, 102, '2020-01-15'),
(2, 'LiveConnect', 0, 102, 101, '2019-05-20'),
(3, 'GlobalView', 0, 103, 103, '2022-11-01');

-- 6) Usuario (50 usuários)
INSERT INTO Usuario (id, nick, email, data_nasc, telefone, end_postal, pais_residencia) VALUES
(1, 'StreamerX', 'streamerx@email.com', '1990-03-01', '+1 555-1000', '123 Stream Way', 1),
(2, 'GamerGirl', 'gamergirl@email.com', '1995-07-10', '+33 6 1000-1001', '45 Rue de Gaming', 33),
(3, 'Comentador01', 'comentador01@email.com', '1988-11-20', '+55 21 98000-0001', 'Rua A, 100', 55),
(4, 'Comentador02', 'comentador02@email.com', '2000-01-01', '+1 555-2000', '404 Error Blvd', 1),
(5, 'Comentador03', 'comentador03@email.com', '1992-05-15', '+44 7700 900003', 'Flat 3, London', 44),
(6, 'StreamerY', 'streamery@email.com', '1993-02-28', '+55 21 98000-0006', 'Rua B, 200', 55),
(7, 'MembraVIP', 'membravip@email.com', '1985-04-04', '+33 6 1000-1007', '78 Av. Paris', 33),
(8, 'StreamerZ', 'streamerz@email.com', '1998-08-08', '+1 555-8000', '808 Tech Park', 1),
(9, 'User9', 'user9@email.com', '1995-01-01', '+1 555-5009', 'Address 9', 33),
(10, 'User10', 'user10@email.com', '1996-01-01', '+1 555-5010', 'Address 10', 55),
(11, 'User11', 'user11@email.com', '1997-01-01', '+1 555-5011', 'Address 11', 44),
(12, 'User12', 'user12@email.com', '1998-01-01', '+1 555-5012', 'Address 12', 1),
(13, 'User13', 'user13@email.com', '1999-01-01', '+1 555-5013', 'Address 13', 33),
(14, 'User14', 'user14@email.com', '2000-01-01', '+1 555-5014', 'Address 14', 55),
(15, 'User15', 'user15@email.com', '2001-01-01', '+1 555-5015', 'Address 15', 44),
(16, 'User16', 'user16@email.com', '2002-01-01', '+1 555-5016', 'Address 16', 1),
(17, 'User17', 'user17@email.com', '1993-02-01', '+1 555-5017', 'Address 17', 33),
(18, 'User18', 'user18@email.com', '1994-02-01', '+1 555-5018', 'Address 18', 55),
(19, 'User19', 'user19@email.com', '1995-02-01', '+1 555-5019', 'Address 19', 44),
(20, 'User20', 'user20@email.com', '1996-02-01', '+1 555-5020', 'Address 20', 1),
(21, 'User21', 'user21@email.com', '1997-02-01', '+1 555-5021', 'Address 21', 33),
(22, 'User22', 'user22@email.com', '1998-02-01', '+1 555-5022', 'Address 22', 55),
(23, 'User23', 'user23@email.com', '1999-02-01', '+1 555-5023', 'Address 23', 44),
(24, 'User24', 'user24@email.com', '2000-02-01', '+1 555-5024', 'Address 24', 1),
(25, 'User25', 'user25@email.com', '2001-02-01', '+1 555-5025', 'Address 25', 33),
(26, 'User26', 'user26@email.com', '2002-02-01', '+1 555-5026', 'Address 26', 55),
(27, 'User27', 'user27@email.com', '1993-03-01', '+1 555-5027', 'Address 27', 44),
(28, 'User28', 'user28@email.com', '1994-03-01', '+1 555-5028', 'Address 28', 1),
(29, 'User29', 'user29@email.com', '1995-03-01', '+1 555-5029', 'Address 29', 33),
(30, 'User30', 'user30@email.com', '1996-03-01', '+1 555-5030', 'Address 30', 55),
(31, 'User31', 'user31@email.com', '1997-03-01', '+1 555-5031', 'Address 31', 44),
(32, 'User32', 'user32@email.com', '1998-03-01', '+1 555-5032', 'Address 32', 1),
(33, 'User33', 'user33@email.com', '1999-03-01', '+1 555-5033', 'Address 33', 33),
(34, 'User34', 'user34@email.com', '2000-03-01', '+1 555-5034', 'Address 34', 55),
(35, 'User35', 'user35@email.com', '2001-03-01', '+1 555-5035', 'Address 35', 44),
(36, 'User36', 'user36@email.com', '2002-03-01', '+1 555-5036', 'Address 36', 1),
(37, 'User37', 'user37@email.com', '1993-04-01', '+1 555-5037', 'Address 37', 33),
(38, 'User38', 'user38@email.com', '1994-04-01', '+1 555-5038', 'Address 38', 55),
(39, 'User39', 'user39@email.com', '1995-04-01', '+1 555-5039', 'Address 39', 44),
(40, 'User40', 'user40@email.com', '1996-04-01', '+1 555-5040', 'Address 40', 1),
(41, 'User41', 'user41@email.com', '1997-04-01', '+1 555-5041', 'Address 41', 33),
(42, 'User42', 'user42@email.com', '1998-04-01', '+1 555-5042', 'Address 42', 55),
(43, 'User43', 'user43@email.com', '1999-04-01', '+1 555-5043', 'Address 43', 44),
(44, 'User44', 'user44@email.com', '2000-04-01', '+1 555-5044', 'Address 44', 1),
(45, 'User45', 'user45@email.com', '2001-04-01', '+1 555-5045', 'Address 45', 33),
(46, 'User46', 'user46@email.com', '2002-04-01', '+1 555-5046', 'Address 46', 55),
(47, 'User47', 'user47@email.com', '1993-05-01', '+1 555-5047', 'Address 47', 44),
(48, 'User48', 'user48@email.com', '1994-05-01', '+1 555-5048', 'Address 48', 1),
(49, 'User49', 'user49@email.com', '1995-05-01', '+1 555-5049', 'Address 49', 33),
(50, 'User50', 'user50@email.com', '1996-05-01', '+1 555-5050', 'Address 50', 55);

-- 7) PlataformaUsuario: corrigi entry inconsistente (5002 -> 3023)
INSERT INTO PlataformaUsuario (nro_plataforma, usuario_id, nro_usuario) VALUES
(1, 1, 1001),
(1, 2, 1002),
(1, 3, 1003),
(1, 4, 1004),
(1, 5, 1005),
(1, 6, 1006),
(1, 7, 1007),
(1, 8, 1008),
(1, 9, 1009),
(1, 10, 1010),
(1, 11, 1011),
(1, 12, 1012),
(1, 13, 1013),
(1, 14, 1014),
(1, 15, 1015),
(1, 16, 1016),
(1, 17, 1017),
(1, 18, 1018),
(1, 19, 1019),
(1, 20, 1020),
(1, 21, 1021),
(1, 22, 1022),
(1, 23, 1023),
(1, 24, 1024),
(1, 25, 1025),
(1, 26, 1026),
(1, 27, 1027),
(1, 28, 1028),
(1, 29, 1029),
(1, 30, 1030),
(1, 31, 1031),
(1, 32, 1032),
(1, 33, 1033),
(1, 34, 1034),
(1, 35, 1035),
(1, 36, 1036),
(1, 37, 1037),
(1, 38, 1038),
(1, 39, 1039),
(1, 40, 1040),
(1, 41, 1041),
(1, 42, 1042),
(1, 43, 1043),
(1, 44, 1044),
(1, 45, 1045),
(1, 46, 1046),
(1, 47, 1047),
(1, 48, 1048),
(1, 49, 1049),
(1, 50, 1050),

(2, 1, 2001),
(2, 2, 2002),
(2, 3, 2003),
(2, 4, 2004),
(2, 5, 2005),
(2, 6, 2006),
(2, 7, 2007),
(2, 8, 2008),
(2, 9, 2009),
(2, 10, 2010),
(2, 11, 2011),
(2, 12, 2012),
(2, 13, 2013),
(2, 14, 2014),
(2, 15, 2015),
(2, 16, 2016),
(2, 17, 2017),
(2, 18, 2018),
(2, 19, 2019),
(2, 20, 2020),
(2, 21, 2021),
(2, 22, 2022),
(2, 23, 2023),
(2, 24, 2024),
(2, 25, 2025),
(2, 26, 2026),
(2, 27, 2027),
(2, 28, 2028),
(2, 29, 2029),
(2, 30, 2030),
(2, 31, 2031),
(2, 32, 2032),
(2, 33, 2033),
(2, 34, 2034),
(2, 35, 2035),
(2, 36, 2036),
(2, 37, 2037),
(2, 38, 2038),
(2, 39, 2039),
(2, 40, 2040),
(2, 41, 2041),
(2, 42, 2042),
(2, 43, 2043),
(2, 44, 2044),
(2, 45, 2045),
(2, 46, 2046),
(2, 47, 2047),
(2, 48, 2048),
(2, 49, 2049),
(2, 50, 2050),

(3, 1, 3001),
(3, 2, 3002),
(3, 3, 3003),
(3, 4, 3004),
(3, 5, 3005),
(3, 6, 3006),
(3, 7, 3007),
(3, 8, 3008),
(3, 9, 3009),
(3, 10, 3010),
(3, 11, 3011),
(3, 12, 3012),
(3, 13, 3013),
(3, 14, 3014),
(3, 15, 3015),
(3, 16, 3016),
(3, 17, 3017),
(3, 18, 3018),
(3, 19, 3019),
(3, 20, 3020),
(3, 21, 3021),
(3, 22, 3022),
(3, 23, 3023), -- <-- CORREÇÃO: antes estava 5002 (inconsistente)
(3, 24, 3024),
(3, 25, 3025),
(3, 26, 3026),
(3, 27, 3027),
(3, 28, 3028),
(3, 29, 3029),
(3, 30, 3030),
(3, 31, 3031),
(3, 32, 3032),
(3, 33, 3033),
(3, 34, 3034),
(3, 35, 3035),
(3, 36, 3036),
(3, 37, 3037),
(3, 38, 3038),
(3, 39, 3039),
(3, 40, 3040),
(3, 41, 3041),
(3, 42, 3042),
(3, 43, 3043),
(3, 44, 3044),
(3, 45, 3045),
(3, 46, 3046),
(3, 47, 3047),
(3, 48, 3048),
(3, 49, 3049),
(3, 50, 3050);

-- 8) StreamerPais
INSERT INTO StreamerPais (streamer_id, ddi_pais, nro_passaporte) VALUES
(1, 1, 452937810),
(2, 33, 93247012);

INSERT INTO Canal (id, nome, tipo, data_fund, descricao, qtd_visualizacoes, id_streamer, nro_plataforma) VALUES
-- Plataforma 1 (streamers: 10, 11, 12)
(10, 'CanalTechBR',          'publico',       '2020-01-10', 'Canal focado em gameplay',                    12000, 10, 1),
(20, 'MundoDaMusica',        'publico',      '2019-05-02', 'Covers e produção musical',                   54000, 11, 1),
(30, 'AulasDoRafa',          'publico', '2021-03-15', 'Aulas rápidas e tutoriais',                   8000, 12, 1),
(20, 'MundoDaMusica Live','publico', '2021-08-10', 'Covers e lives musicais', 5000, 11, 2),

-- Plataforma 2 (streamers: 20, 21, 22)
(40, 'CorteDiario',          'privado','2022-06-20','Cortes de vídeos virais',                   32000, 20, 2),
(50, 'CulinariaFacil',       'misto',    '2018-11-11','Receitas rápidas e fáceis',                  51000, 21, 2),
(60, 'ViagemMundo',          'privado',         '2020-09-09','Vlogs de viagens internacionais',             26000, 22, 2),

-- Plataforma 3 (streamers: 30, 31, 32)
(70, 'FitnessPro',           'publico',       '2021-01-01', 'Treinos e dicas de saúde',                   47000, 30, 3),
(80, 'CinemaReview',         'publico',     '2017-07-07', 'Reviews de filmes e séries',                 15000, 31, 3),
(302, 'PodcastAoVivo',        'publico',     '2023-02-14', 'Podcasts semanais ao vivo',                  9000,  32, 3),

-- Extra (misturando plataformas)
(400, 'HumorSemFiltro',       'privado',     '2020-10-10', 'Vídeos curtos de humor',                     88000, 11, 1);

INSERT INTO NivelCanal (id_canal, nro_plataforma, nivel, valor, gif) VALUES
-- Canal 10, Plataforma 1
(10, 1, 'FREE',     0.00, 'free.gif'),
(10, 1, 'BASIC',   10.00, 'basic.gif'),
(10, 1, 'PREMIUM', 25.00, 'premium.gif'),
(10, 1, 'DIAMOND', 60.00, 'diamond.gif'),
(10, 1, 'PLATINUM',100.00,'platinum.gif'),

-- Canal 20, Plataforma 1
(20, 1, 'FREE',     0.00, 'free.gif'),
(20, 1, 'BASIC',   10.00, 'basic.gif'),
(20, 1, 'PREMIUM', 25.00, 'premium.gif'),
(20, 1, 'DIAMOND', 60.00, 'diamond.gif'),
(20, 1, 'PLATINUM',100.00,'platinum.gif'),

-- Canal 30, Plataforma 1
(30, 1, 'FREE',     0.00, 'free.gif'),
(30, 1, 'BASIC',   10.00, 'basic.gif'),
(30, 1, 'PREMIUM', 25.00, 'premium.gif'),
(30, 1, 'DIAMOND', 60.00, 'diamond.gif'),
(30, 1, 'PLATINUM',100.00,'platinum.gif'),

(20, 2, 'FREE',  0.00, 'free.gif'),
(20, 2, 'BASIC',  12.00, 'basic_p2.gif'), -- Exemplo com preço diferente
(20, 2, 'PREMIUM', 27.00, 'premium_p2.gif'),

-- Canal 40, Plataforma 2 (Usado no generate_series)
(40, 2, 'FREE', 0.00, 'free.gif'),
(40, 2, 'BASIC', 15.00, 'basic_40.gif'),
(40, 2, 'PREMIUM', 30.00, 'premium_40.gif'),
(40, 2, 'DIAMOND', 70.00, 'diamond_40.gif'),

-- Canal 50, Plataforma 1 (Usado no generate_series)
(50, 1, 'FREE', 0.00, 'free.gif'),
(50, 1, 'BASIC', 8.00, 'basic_50.gif'),
(50, 1, 'PREMIUM', 20.00, 'premium_50.gif')
ON CONFLICT DO NOTHING;

-- 10) Inscricao: entradas específicas + generate_series (APENAS UMA VEZ)
-- Inserções manuais iniciais (exemplos específicos)
INSERT INTO Inscricao (id_canal, nro_plataforma, id_membro, nivel) VALUES
(10, 1, 3, 'BASIC'),
(10, 1, 4, 'PREMIUM'),
(10, 1, 5, 'DIAMOND'),
(20, 2, 3, 'BASIC'),
(20, 2, 7, 'PREMIUM'),
(30, 1, 7, 'BASIC');

-- Inserindo o restante de forma distribuída (119 tuplas)
INSERT INTO Inscricao (id_canal, nro_plataforma, id_membro, nivel)
SELECT
    CASE WHEN (gs.i % 5) = 0 THEN 10 WHEN (gs.i % 5) = 1 THEN 20 WHEN (gs.i % 5) = 2 THEN 30 WHEN (gs.i % 5) = 3 THEN 40 ELSE 50 END,
    CASE WHEN (gs.i % 5) = 1 THEN 2 ELSE 1 END,
    (gs.i % 47) + 4,
    CASE (gs.i % 3)
        WHEN 0 THEN 'BASIC'
        WHEN 1 THEN 'PREMIUM'
        ELSE 'DIAMOND'
    END
FROM
    generate_series(1, 119) AS gs(i)
ON CONFLICT DO NOTHING;


-- 11) Video (500 tuplas)
INSERT INTO Video (id, id_canal, nro_plataforma, dataH, titulo, tema, duracao, visu_simul, visu_total)
SELECT
    gs.i AS id,
    CASE WHEN (gs.i % 5) = 0 THEN 10 WHEN (gs.i % 5) = 1 THEN 20 WHEN (gs.i % 5) = 2 THEN 30 WHEN (gs.i % 5) = 3 THEN 40 ELSE 50 END AS id_canal,
    CASE WHEN (gs.i % 5) = 1 THEN 2 ELSE 1 END AS nro_plataforma,
    (TIMESTAMP '2023-01-01 10:00:00' + interval '1 hour' * gs.i) AS dataH,
    'Video ' || gs.i || ' do Canal ' || (CASE WHEN (gs.i % 5) = 0 THEN 10 WHEN (gs.i % 5) = 1 THEN 20 WHEN (gs.i % 5) = 2 THEN 30 WHEN (gs.i % 5) = 3 THEN 40 ELSE 50 END) AS titulo,
    'Tema ' || (gs.i % 10) AS tema,
    (10.0 + (gs.i % 10) * 0.5) AS duracao,
    (gs.i % 100) AS visu_simul,
    (1000 + gs.i * 5) AS visu_total
FROM
    generate_series(1, 500) AS gs(i);

-- 12) Participa (50 tuplas) - usa JOIN com Video para garantir consistência de fk id_canal/nro_plataforma
WITH Participacoes AS (
    SELECT
        (gs.i % 500) + 1 AS video_id,      -- ID do vídeo (1 a 500)
        (gs.i % 7) + 1 AS id_streamer      -- ID do streamer (1 a 7)
    FROM
        generate_series(1, 50) AS gs(i)
)
INSERT INTO Participa (video_id, id_streamer, id_canal, nro_plataforma)
SELECT
    P.video_id,
    P.id_streamer,
    V.id_canal,
    V.nro_plataforma
FROM
    Participacoes P
JOIN
    Video V ON P.video_id = V.id
ON CONFLICT DO NOTHING;

-- 13) Comentario (5.000 tuplas) - CASE completado de forma consistente com mapeamento de canal
INSERT INTO Comentario (video_id, id_canal, id_usuario, seq, texto, dataH, coment_on, nro_plataforma)
SELECT
    (gs.i % 500) + 1 AS video_id,
    CASE 
        WHEN (((gs.i % 500) + 1) % 5) = 0 THEN 10
        WHEN (((gs.i % 500) + 1) % 5) = 1 THEN 20
        WHEN (((gs.i % 500) + 1) % 5) = 2 THEN 30
        WHEN (((gs.i % 500) + 1) % 5) = 3 THEN 40
        ELSE 50
    END AS id_canal,
    (gs.i % 48) + 3 AS id_usuario, -- Usuários ID 3 a 50
    (gs.i % 10) + 1 AS seq,
    'Comentário número ' || gs.i || ' no vídeo ' || ((gs.i % 500) + 1),
    (TIMESTAMP '2023-01-01 10:00:00' + interval '1 minute' * gs.i) AS dataH,
    TRUE AS coment_on,
    CASE WHEN (((gs.i % 500) + 1) % 5) = 1 THEN 2 ELSE 1 END AS nro_plataforma
FROM
    generate_series(1, 5000) AS gs(i)
ON CONFLICT DO NOTHING;

-- 14) Doacao (a partir de Comentario)
INSERT INTO Doacao (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, valor, status_doacao)
SELECT
    c.video_id,
    c.id_canal,
    c.nro_plataforma,
    c.id_usuario,
    c.seq,
    1,
    (10.0 + (c.seq % 20) * 0.5),
    CASE c.seq % 3 WHEN 0 THEN 'recebido' WHEN 1 THEN 'lido' ELSE 'recusado' END
FROM Comentario c
WHERE c.seq % 5 = 0;

-- 15) CartaoCredito (25 primeiros)
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg
           ) AS rn
    FROM Doacao
)
INSERT INTO CartaoCredito (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, dataH, nro, bandeira)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    '2023-01-01 12:00:00',
    '400012345678' || (1000 + rn),
    CASE rn % 2 WHEN 0 THEN 'Visa' ELSE 'MasterCard' END
FROM d
WHERE rn BETWEEN 1 AND 25;

-- 16) PayPal (26 a 35)
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg
           ) AS rn
    FROM Doacao
)
INSERT INTO PayPal (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, IdPayPal)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    'PPID-' || (10000 + rn)
FROM d
WHERE rn BETWEEN 26 AND 35;

-- 17) MecanismoPlat (36 a 45)
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg
           ) AS rn
    FROM Doacao
)
INSERT INTO MecanismoPlat (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, seq_plataforma)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    'SEQPLT-' || (20000 + rn)
FROM d
WHERE rn BETWEEN 36 AND 45;

-- 18) Bitcoin (46 a 50)
WITH d AS (
    SELECT *,
           ROW_NUMBER() OVER (
               ORDER BY video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg
           ) AS rn
    FROM Doacao
)
INSERT INTO Bitcoin (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, TxID)
SELECT
    video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg,
    'TXID-' || (30000 + rn)
FROM d
WHERE rn BETWEEN 46 AND 50;
