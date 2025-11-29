-- 1) Conversao
INSERT INTO Conversao (id, moeda, nome, fator_conver) VALUES
(1, 'USD', 'Dólar Americano', 1.0000),
(2, 'EUR', 'Euro', 0.9234),
(3, 'BRL', 'Real Brasileiro', 5.0500)
ON CONFLICT DO NOTHING;

-- 2) Empresa
INSERT INTO Empresa (nro, nome, nome_fantasia) VALUES
(101, 'Empresa Fundadora A S.A.', 'TechCorp'),
(102, 'Empresa Responsável B Ltda.', 'StreamBoss'),
(103, 'Global Investimentos S.A.', 'GInvest'),
(104, 'E-Commerce Gigante Inc.', 'BuyAll'),
(105, 'Estúdios de Produção XYZ', 'XYZ Studios')
ON CONFLICT DO NOTHING;

-- 3) Pais
INSERT INTO Pais (ddi, nome, id_moeda) VALUES
(1, 'Estados Unidos', 1),
(33, 'França', 2),
(55, 'Brasil', 3),
(44, 'Reino Unido', 1)
ON CONFLICT DO NOTHING;

-- 4) EmpresaPais
INSERT INTO EmpresaPais (nro_empresa, ddi_pais, id_nacional) VALUES
(101, 1, 1001), (101, 33, 1002), (101, 55, 1003),
(102, 1, 2001), (102, 44, 2002),
(103, 1, 3001), (103, 55, 3002),
(104, 33, 4001),
(105, 55, 5001), (105, 44, 5002)
ON CONFLICT DO NOTHING;

-- 5) Plataforma
INSERT INTO Plataforma (nro, nome, qtd_users, empresa_fund, empresa_respo, data_fund) VALUES
(1, 'MegaStream', 0, 101, 102, '2020-01-15'),
(2, 'LiveConnect', 0, 102, 101, '2019-05-20'),
(3, 'GlobalView', 0, 103, 103, '2022-11-01')
ON CONFLICT DO NOTHING;

-- 6) Usuario
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
(50, 'User50', 'user50@email.com', '1996-05-01', '+1 555-5050', 'Address 50', 55),
(501, 'DoacaoBTC_User01', 'btc.user01@email.com', '1995-10-10', '+1 555-5501', 'Crypto St, 1', 1),
(502, 'DoacaoBTC_User02', 'btc.user02@email.com', '1996-11-11', '+44 7700 900502', 'Wallet Rd, 2', 44),
(503, 'DoacaoBTC_User03', 'btc.user03@email.com', '1997-12-12', '+55 21 98000-0503', 'Rua Satoshi, 3', 55),
(504, 'DoacaoBTC_User04', 'btc.user04@email.com', '1998-01-01', '+33 6 1000-1504', 'Blockchain Av, 4', 33),
(505, 'DoacaoBTC_User05', 'btc.user05@email.com', '1999-02-02', '+1 555-5505', 'Coin Base, 5', 1),
(601, 'DoacaoPP_User01', 'pp.user01@email.com', '1994-03-03', '+55 21 98000-0601', 'Pay R, 6', 55),
(602, 'DoacaoPP_User02', 'pp.user02@email.com', '1993-04-04', '+44 7700 900602', 'Pal Dr, 7', 44),
(603, 'DoacaoPP_User03', 'pp.user03@email.com', '1992-05-05', '+1 555-5603', 'E-Money Blvd, 8', 1),
(604, 'DoacaoPP_User04', 'pp.user04@email.com', '1991-06-06', '+33 6 1000-1604', 'Transact Rue, 9', 33),
(605, 'DoacaoPP_User05', 'pp.user05@email.com', '1990-07-07', '+55 21 98000-0605', 'Rua Digital, 10', 55),
(606, 'DoacaoPP_User06', 'pp.user06@email.com', '1989-08-08', '+1 555-5606', 'Fast Pay St, 11', 1),
(607, 'DoacaoPP_User07', 'pp.user07@email.com', '1988-09-09', '+33 6 1000-1607', 'Av. Safe, 12', 33),
(701, 'DoacaoCC_User01', 'cc.user01@email.com', '1987-10-10', '+44 7700 900701', 'Visa Ln, 13', 44),
(702, 'DoacaoCC_User02', 'cc.user02@email.com', '1986-11-11', '+55 21 98000-0702', 'Master R, 14', 55),
(703, 'DoacaoCC_User03', 'cc.user03@email.com', '1985-12-12', '+1 555-5703', 'Amex Dr, 15', 1),
(704, 'DoacaoCC_User04', 'cc.user04@email.com', '1984-01-01', '+33 6 1000-1704', 'Card Pl, 16', 33),
(705, 'DoacaoCC_User05', 'cc.user05@email.com', '1983-02-02', '+44 7700 900705', 'Bank St, 17', 44),
(706, 'DoacaoCC_User06', 'cc.user06@email.com', '1982-03-03', '+55 21 98000-0706', 'Rua Financeira, 18', 55),
(707, 'DoacaoCC_User07', 'cc.user07@email.com', '1981-04-04', '+1 555-5707', 'Transaction Rd, 19', 1),
(708, 'DoacaoCC_User08', 'cc.user08@email.com', '1980-05-05', '+33 6 1000-1708', 'Av. Pagamento, 20', 33),
(709, 'DoacaoCC_User09', 'cc.user09@email.com', '1979-06-06', '+44 7700 900709', 'Credit Ave, 21', 44),
(710, 'DoacaoCC_User10', 'cc.user10@email.com', '1978-07-07', '+55 21 98000-0710', 'Rua dos Cartões, 22', 55),
(801, 'DoacaoPLT_User01', 'plt.user01@email.com', '1977-08-08', '+1 555-5801', 'Platform Ln, 23', 1),
(802, 'DoacaoPLT_User02', 'plt.user02@email.com', '1976-09-09', '+33 6 1000-1802', 'Super Chat Dr, 24', 33),
(803, 'DoacaoPLT_User03', 'plt.user03@email.com', '1975-10-10', '+44 7700 900803', 'Exclusive St, 25', 44)
ON CONFLICT DO NOTHING;

INSERT INTO PlataformaUsuario (nro_plataforma, usuario_id, nro_usuario) VALUES
(1, 501, 1501), (2, 501, 2501), (3, 501, 3501), (1, 502, 1502), (2, 502, 2502), (3, 502, 3502), (1, 503, 1503), (2, 503, 2503), (3, 503, 3503), (1, 504, 1504), (2, 504, 2504), (3, 504, 3504), (1, 505, 1505), (2, 505, 2505), (3, 505, 3505),
(1, 601, 1601), (2, 601, 2601), (3, 601, 3601), (1, 602, 1602), (2, 602, 2602), (3, 602, 3602), (1, 603, 1603), (2, 603, 2603), (3, 603, 3603), (1, 604, 1604), (2, 604, 2604), (3, 604, 3604), (1, 605, 1605), (2, 605, 2605), (3, 605, 3605), (1, 606, 1606), (2, 606, 2606), (3, 606, 3606), (1, 607, 1607), (2, 607, 2607), (3, 607, 3607),
(1, 701, 1701), (2, 701, 2701), (3, 701, 3701), (1, 702, 1702), (2, 702, 2702), (3, 702, 3702), (1, 703, 1703), (2, 703, 2703), (3, 703, 3703), (1, 704, 1704), (2, 704, 2704), (3, 704, 3704), (1, 705, 1705), (2, 705, 2705), (3, 705, 3705), (1, 706, 1706), (2, 706, 2706), (3, 706, 3706), (1, 707, 1707), (2, 707, 2707), (3, 707, 3707), (1, 708, 1708), (2, 708, 2708), (3, 708, 3708), (1, 709, 1709), (2, 709, 2709), (3, 709, 3709), (1, 710, 1710), (2, 710, 2710), (3, 710, 3710),
(1, 801, 1801), (2, 801, 2801), (3, 801, 3801), (1, 802, 1802), (2, 802, 2802), (3, 802, 3802), (1, 803, 1803), (2, 803, 2803), (3, 803, 3803),
(1, 1, 1001), (1, 2, 1002), (1, 3, 1003), (1, 4, 1004), (1, 5, 1005), (1, 6, 1006), (1, 7, 1007), (1, 8, 1008), (1, 9, 1009), (1, 10, 1010), (1, 11, 1011), (1, 12, 1012), (1, 13, 1013), (1, 14, 1014), (1, 15, 1015), (1, 16, 1016), (1, 17, 1017), (1, 18, 1018), (1, 19, 1019), (1, 20, 1020), (1, 21, 1021), (1, 22, 1022), (1, 23, 1023), (1, 24, 1024), (1, 25, 1025), (1, 26, 1026), (1, 27, 1027), (1, 28, 1028), (1, 29, 1029), (1, 30, 1030), (1, 31, 1031), (1, 32, 1032), (1, 33, 1033), (1, 34, 1034), (1, 35, 1035), (1, 36, 1036), (1, 37, 1037), (1, 38, 1038), (1, 39, 1039), (1, 40, 1040), (1, 41, 1041), (1, 42, 1042), (1, 43, 1043), (1, 44, 1044), (1, 45, 1045), (1, 46, 1046), (1, 47, 1047), (1, 48, 1048), (1, 49, 1049), (1, 50, 1050),
(2, 1, 2001), (2, 2, 2002), (2, 3, 2003), (2, 4, 2004), (2, 5, 2005), (2, 6, 2006), (2, 7, 2007), (2, 8, 2008), (2, 9, 2009), (2, 10, 2010), (2, 11, 2011), (2, 12, 2012), (2, 13, 2013), (2, 14, 2014), (2, 15, 2015), (2, 16, 2016), (2, 17, 2017), (2, 18, 2018), (2, 19, 2019), (2, 20, 2020), (2, 21, 2021), (2, 22, 2022), (2, 23, 2023), (2, 24, 2024), (2, 25, 2025), (2, 26, 2026), (2, 27, 2027), (2, 28, 2028), (2, 29, 2029), (2, 30, 2030), (2, 31, 2031), (2, 32, 2032), (2, 33, 2033), (2, 34, 2034), (2, 35, 2035), (2, 36, 2036), (2, 37, 2037), (2, 38, 2038), (2, 39, 2039), (2, 40, 2040), (2, 41, 2041), (2, 42, 2042), (2, 43, 2043), (2, 44, 2044), (2, 45, 2045), (2, 46, 2046), (2, 47, 2047), (2, 48, 2048), (2, 49, 2049), (2, 50, 2050),
(3, 1, 3001), (3, 2, 3002), (3, 3, 3003), (3, 4, 3004), (3, 5, 3005), (3, 6, 3006), (3, 7, 3007), (3, 8, 3008), (3, 9, 3009), (3, 10, 3010), (3, 11, 3011), (3, 12, 3012), (3, 13, 3013), (3, 14, 3014), (3, 15, 3015), (3, 16, 3016), (3, 17, 3017), (3, 18, 3018), (3, 19, 3019), (3, 20, 3020), (3, 21, 3021), (3, 22, 3022), (3, 23, 3023), (3, 24, 3024), (3, 25, 3025), (3, 26, 3026), (3, 27, 3027), (3, 28, 3028), (3, 29, 3029), (3, 30, 3030), (3, 31, 3031), (3, 32, 3032), (3, 33, 3033), (3, 34, 3034), (3, 35, 3035), (3, 36, 3036), (3, 37, 3037), (3, 38, 3038), (3, 39, 3039), (3, 40, 3040), (3, 41, 3041), (3, 42, 3042), (3, 43, 3043), (3, 44, 3044), (3, 45, 3045), (3, 46, 3046), (3, 47, 3047), (3, 48, 3048), (3, 49, 3049), (3, 50, 3050)
ON CONFLICT DO NOTHING;

INSERT INTO StreamerPais (streamer_id, ddi_pais, nro_passaporte) VALUES
(1, 1, 452937810),
(2, 33, 93247012)
ON CONFLICT DO NOTHING;

INSERT INTO Canal (id, nome, tipo, data_fund, descricao, qtd_visualizacoes, id_streamer, nro_plataforma) VALUES
(10, 'CanalTechBR', 'publico', '2020-01-10', 'Canal focado em gameplay', 12000, 10, 1),
(20, 'MundoDaMusica', 'publico', '2019-05-02', 'Covers e produção musical', 54000, 11, 1),
(30, 'AulasDoRafa', 'publico', '2021-03-15', 'Aulas rápidas e tutoriais', 8000, 12, 1),
(40, 'CorteDiario', 'privado', '2022-06-20', 'Cortes de vídeos virais', 32000, 20, 2),
(50, 'CulinariaFacil', 'misto', '2018-11-11', 'Receitas rápidas e fáceis', 51000, 21, 2),
(60, 'ViagemMundo', 'privado', '2020-09-09', 'Vlogs de viagens internacionais', 26000, 22, 2),
(70, 'FitnessPro', 'publico', '2021-01-01', 'Treinos e dicas de saúde', 47000, 30, 3),
(80, 'CinemaReview', 'publico', '2017-07-07', 'Reviews de filmes e séries', 15000, 31, 3),
(302, 'PodcastAoVivo', 'publico', '2023-02-14', 'Podcasts semanais ao vivo', 9000, 32, 3),
(400, 'HumorSemFiltro', 'privado', '2020-10-10', 'Vídeos curtos de humor', 88000, 11, 1)
ON CONFLICT DO NOTHING;

INSERT INTO NivelCanal (id_canal, nro_plataforma, nivel, valor, gif) VALUES
(10, 1, 'FREE', 0.00, 'free.gif'), (10, 1, 'BASIC', 10.00, 'basic.gif'), (10, 1, 'PREMIUM', 25.00, 'premium.gif'), (10, 1, 'DIAMOND', 60.00, 'diamond.gif'), (10, 1, 'PLATINUM',100.00,'platinum.gif'),
(20, 1, 'FREE', 0.00, 'free.gif'), (20, 1, 'BASIC', 10.00, 'basic.gif'), (20, 1, 'PREMIUM', 25.00, 'premium.gif'), (20, 1, 'DIAMOND', 60.00, 'diamond.gif'), (20, 1, 'PLATINUM',100.00,'platinum.gif'),
(30, 1, 'FREE', 0.00, 'free.gif'), (30, 1, 'BASIC', 10.00, 'basic.gif'), (30, 1, 'PREMIUM', 25.00, 'premium.gif'), (30, 1, 'DIAMOND', 60.00, 'diamond.gif'), (30, 1, 'PLATINUM',100.00,'platinum.gif'),
(40, 2, 'FREE', 0.00, 'free.gif'), (40, 2, 'BASIC', 15.00, 'basic_40.gif'), (40, 2, 'PREMIUM', 30.00, 'premium_40.gif'), (40, 2, 'DIAMOND', 70.00, 'diamond_40.gif'),
(50, 2, 'FREE', 0.00, 'free.gif'), (50, 2, 'BASIC', 8.00, 'basic_50.gif'), (50, 2, 'PREMIUM', 20.00, 'premium_50.gif')
ON CONFLICT DO NOTHING;

INSERT INTO Inscricao (id_canal, nro_plataforma, id_membro, nivel) VALUES
(10, 1, 3, 'BASIC'),
(10, 1, 4, 'PREMIUM'),
(10, 1, 5, 'DIAMOND'),
(20, 1, 3, 'BASIC'),
(20, 1, 7, 'PREMIUM'),
(30, 1, 7, 'BASIC')
ON CONFLICT DO NOTHING;

INSERT INTO Video (id, id_canal, nro_plataforma, dataH, titulo, tema, duracao, visu_simul, visu_total)
SELECT * FROM (
    SELECT
        gs.i AS id,
    CASE 
     WHEN (gs.i % 5) = 0 THEN 10 
     WHEN (gs.i % 5) = 1 THEN 40 
      WHEN (gs.i % 5) = 2 THEN 30
      WHEN (gs.i % 5) = 3 THEN 50 
        ELSE 20 
    END AS id_canal,
    CASE 
         WHEN (gs.i % 5) = 1 THEN 2 
         WHEN (gs.i % 5) = 3 THEN 2 
        ELSE 1 
    END AS nro_plataforma,

 (TIMESTAMP '2023-01-01 10:00:00' + interval '1 hour' * gs.i) AS dataH,
 'Video ' || gs.i || ' do Canal ' || (CASE WHEN (gs.i % 5) = 0 THEN 10 WHEN (gs.i % 5) = 1 THEN 40 WHEN (gs.i % 5) = 2 THEN 30 WHEN (gs.i % 5) = 3 THEN 50 ELSE 20 END) AS titulo,
 'Tema ' || (gs.i % 10) AS tema,
 (10.0 + (gs.i % 10) * 0.5) AS duracao,
  (gs.i % 100) AS visu_simul,
  (1000 + gs.i * 5) AS visu_total
    FROM
  generate_series(1, 500) AS gs(i)
) AS subquery
ON CONFLICT DO NOTHING;


WITH Participacoes AS (
     SELECT
         (gs.i % 500) + 1 AS video_id, 
         (gs.i % 7) + 1 AS id_streamer 
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

INSERT INTO Comentario (video_id, id_canal, id_usuario, seq, texto, dataH, coment_on, nro_plataforma) VALUES
(101, 40, 501, 1, 'Excelente conteúdo! Doei via Bitcoin. (Video 101)', '2025-11-20 10:00:00', TRUE, 2), 
(102, 30, 502, 2, 'Muito bom! Doei para ajudar o canal. (Video 102)', '2025-11-20 10:05:00', TRUE, 1), 
(103, 50, 503, 3, 'Obrigado pela informação. Doação enviada! (Video 103)', '2025-11-20 10:10:00', TRUE, 2), 
(104, 20, 504, 4, 'Valeu pelo vídeo! (Video 104)', '2025-11-20 10:15:00', TRUE, 1), 
(105, 10, 505, 5, 'Doação de Bitcoin feita com sucesso. (Video 105)', '2025-11-20 10:20:00', TRUE, 1), 
(201, 40, 601, 1, 'Top! Usei PayPal para apoiar. (Video 201)', '2025-11-21 11:00:00', TRUE, 2), 
(202, 30, 602, 2, 'Melhor canal. Minha contribuição! (Video 202)', '2025-11-21 11:05:00', TRUE, 1), 
(203, 50, 603, 1, 'Conteúdo essencial. Doação via PayPal. (Video 203)', '2025-11-21 11:10:00', TRUE, 2), 
(204, 20, 604, 2, 'Apoio 100%! Já doei. (Video 204)', '2025-11-21 11:15:00', TRUE, 1), 
(205, 10, 605, 1, 'Show de bola, merece o apoio. (Video 205)', '2025-11-21 11:20:00', TRUE, 1), 
(206, 40, 606, 1, 'Adoro seus vídeos, fiz uma doação. (Video 206)', '2025-11-21 11:25:00', TRUE, 2), 
(207, 30, 607, 1, 'Vale cada centavo, doação enviada. (Video 207)', '2025-11-21 11:30:00', TRUE, 1), 
(301, 40, 701, 1, 'Acabei de doar com meu cartão! (Video 301)', '2025-11-22 12:00:00', TRUE, 2), 
(302, 30, 702, 2, 'Suporte com CC, vídeo ótimo. (Video 302)', '2025-11-22 12:05:00', TRUE, 1), 
(303, 50, 703, 1, 'Comentário + doação via cartão. (Video 303)', '2025-11-22 12:10:00', TRUE, 2), 
(304, 20, 704, 2, 'Essa doação é para o próximo setup! (Video 304)', '2025-11-22 12:15:00', TRUE, 1), 
(305, 10, 705, 1, 'Doação rápida por CC. (Video 305)', '2025-11-22 12:20:00', TRUE, 1), 
(306, 40, 706, 1, 'Aqui está meu apoio. (Video 306)', '2025-11-22 12:25:00', TRUE, 2), 
(307, 30, 707, 1, 'Cartão na mão, doação na conta! (Video 307)', '2025-11-22 12:30:00', TRUE, 1), 
(308, 50, 708, 1, 'Vídeo nota 10, doei com CC. (Video 308)', '2025-11-22 12:35:00', TRUE, 2), 
(309, 20, 709, 1, 'Sucesso! Doei um valor alto para este canal. (Video 309)', '2025-11-22 12:40:00', TRUE, 1), 
(310, 10, 710, 1, 'Pequena doação para um grande canal. (Video 310)', '2025-11-22 12:45:00', TRUE, 1), 
(401, 40, 801, 1, 'Usei o super chat/mecanismo da plataforma! (Video 401)', '2025-11-23 13:00:00', TRUE, 2), 
(402, 30, 802, 1, 'Apoiando via mecanismo da plataforma. (Video 402)', '2025-11-23 13:05:00', TRUE, 1), 
(403, 50, 803, 1, 'Doação instantânea pela plataforma. (Video 403)', '2025-11-23 13:10:00', TRUE, 2)
ON CONFLICT DO NOTHING;


DO $$ 
DECLARE
    i INT := 26;
    max_count INT := 5000;
     v_id_canal INT;
     v_video_id INT;
    v_id_usuario INT;
     v_nro_plataforma INT;
     v_texto VARCHAR;
     v_seq INT;
     v_mod_5 INT;
     v_dataH TIMESTAMP;
BEGIN 
    WHILE i <= max_count LOOP
 
     v_video_id := 1 + (i % 500);
     v_mod_5 := v_video_id % 5; 
         CASE v_mod_5 
            WHEN 0 THEN v_id_canal := 10; v_nro_plataforma := 1;
             WHEN 1 THEN v_id_canal := 40; v_nro_plataforma := 2;
             WHEN 2 THEN v_id_canal := 30; v_nro_plataforma := 1;
             WHEN 3 THEN v_id_canal := 50; v_nro_plataforma := 2;
             ELSE v_id_canal := 20; v_nro_plataforma := 1; -- v_mod_5 = 4
         END CASE;
         v_id_usuario := 1 + (i % 50); 
         v_seq := 1 + (i % 491); 
        v_texto := 'Comentário genérico nro ' || i || '. Vídeo: ' || v_video_id || '. Usuário: ' || v_id_usuario || '.';
        v_dataH := NOW() - (random() * interval '30 days');
    INSERT INTO Comentario (video_id, id_canal, id_usuario, seq, texto, dataH, coment_on, nro_plataforma) VALUES
        (v_video_id, v_id_canal, v_id_usuario, v_seq, v_texto, v_dataH, FALSE, v_nro_plataforma)
        ON CONFLICT DO NOTHING;

        i := i + 1;
     END LOOP;
END $$;


INSERT INTO Doacao (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, valor, status_doacao) VALUES
(101, 40, 2, 501, 1, 1, 150.00, 'recebido'), (102, 30, 1, 502, 2, 1, 25.50, 'recebido'), (103, 50, 2, 503, 3, 1, 500.00, 'recebido'), (104, 20, 1, 504, 4, 1, 10.00, 'recebido'), (105, 10, 1, 505, 5, 1, 85.75, 'recebido')
ON CONFLICT DO NOTHING;

INSERT INTO Bitcoin (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, TxID) VALUES
(101, 40, 2, 501, 1, 1, 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2'), 
(102, 30, 1, 502, 2, 1, 'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f3'),
(103, 50, 2, 503, 3, 1, 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f4'),
(104, 20, 1, 504, 4, 1, 'd4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f5'),
(105, 10, 1, 505, 5, 1, 'e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f6')
ON CONFLICT DO NOTHING;


INSERT INTO Doacao (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, valor, status_doacao) VALUES
(201, 40, 2, 601, 1, 1, 55.00, 'recebido'), (202, 30, 1, 602, 2, 1, 120.50, 'recebido'), (203, 50, 2, 603, 1, 1, 30.75, 'recebido'), (204, 20, 1, 604, 2, 1, 75.00, 'recebido'), (205, 10, 1, 605, 1, 1, 200.00, 'recebido'), (206, 40, 2, 606, 1, 1, 15.25, 'recebido'), (207, 30, 1, 607, 1, 1, 45.00, 'recebido')
ON CONFLICT DO NOTHING;

INSERT INTO PayPal (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, IdPayPal) VALUES
(201, 40, 2, 601, 1, 1, 'PP-A1B2C3D4E5F6G7H8I9J0K1L2M3N4O5P6'), (202, 30, 1, 602, 2, 1, 'PP-B2C3D4E5F6G7H8I9J0K1L2M3N4O5P7'), (203, 50, 2, 603, 1, 1, 'PP-C3D4E5F6G7H8I9J0K1L2M3N4O5P8'), (204, 20, 1, 604, 2, 1, 'PP-D4E5F6G7H8I9J0K1L2M3N4O5P9'), (205, 10, 1, 605, 1, 1, 'PP-E5F6G7H8I9J0K1L2M3N4O5P0'), (206, 40, 2, 606, 1, 1, 'PP-F6G7H8I9J0K1L2M3N4O5P1'), (207, 30, 1, 607, 1, 1, 'PP-G7H8I9J0K1L2M3N4O5P2')
ON CONFLICT DO NOTHING;


INSERT INTO Doacao (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, valor, status_doacao) VALUES
(301, 40, 2, 701, 1, 1, 40.00, 'recebido'), (302, 30, 1, 702, 2, 1, 65.50, 'recebido'), (303, 50, 2, 703, 1, 1, 10.00, 'recebido'), (304, 20, 1, 704, 2, 1, 150.00, 'recebido'), (305, 10, 1, 705, 1, 1, 22.25, 'recebido'), (306, 40, 2, 706, 1, 1, 90.00, 'recebido'), (307, 30, 1, 707, 1, 1, 110.00, 'recebido'), (308, 50, 2, 708, 1, 1, 5.50, 'recebido'), (309, 20, 1, 709, 1, 1, 300.00, 'recebido'), (310, 10, 1, 710, 1, 1, 7.99, 'recebido')
ON CONFLICT DO NOTHING;

INSERT INTO CartaoCredito (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, dataH, nro, bandeira) VALUES
(301, 40, 2, 701, 1, 1, '2025-11-24 12:00:00', '4111********1111', 'Visa'), (302, 30, 1, 702, 2, 1, '2025-11-24 12:05:00', '5222********2222', 'MasterCard'), (303, 50, 2, 703, 1, 1, '2025-11-24 12:10:00', '4333********3333', 'Visa'), (304, 20, 1, 704, 2, 1, '2025-11-24 12:15:00', '3744********4444', 'Amex'), (305, 10, 1, 705, 1, 1, '2025-11-24 12:20:00', '5555********5555', 'MasterCard'), (306, 40, 2, 706, 1, 1, '2025-11-24 12:25:00', '6011********6666', 'Discover'), (307, 30, 1, 707, 1, 1, '2025-11-24 12:30:00', '4777********7777', 'Visa'), (308, 50, 2, 708, 1, 1, '2025-11-24 12:35:00', '5888********8888', 'MasterCard'), (309, 20, 1, 709, 1, 1, '2025-11-24 12:40:00', '3799********9999', 'Amex'), (310, 10, 1, 710, 1, 1, '2025-11-24 12:45:00', '4000********0000', 'Visa')
ON CONFLICT DO NOTHING;



INSERT INTO Doacao (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, valor, status_doacao) VALUES
(401, 40, 2, 801, 1, 1, 5.00, 'recebido'), (402, 30, 1, 802, 1, 1, 25.00, 'recebido'), (403, 50, 2, 803, 1, 1, 10.99, 'recebido')
ON CONFLICT DO NOTHING;

INSERT INTO MecanismoPlat (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg, seq_plataforma) VALUES
(401, 40, 2, 801, 1, 1, 'PLAT_TRANS_90001'),
(402, 30, 1, 802, 1, 1, 'PLAT_TRANS_90002'),
(403, 50, 2, 803, 1, 1, 'PLAT_TRANS_90003')
ON CONFLICT DO NOTHING;

INSERT INTO Patrocinio (nro_empresa, id_canal, nro_plataforma, valor) VALUES
)
(101, 10, 1, 5000.00), 
(101, 40, 2, 8000.00),

(102, 20, 1, 3000.00),
(102, 50, 2, 4500.00),


(103, 10, 1, 10000.00),
(103, 40, 2, 2500.00), 


(104, 20, 1, 7000.00), 
(104, 50, 2, 1500.00) 
ON CONFLICT DO NOTHING;
