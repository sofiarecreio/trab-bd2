-- =====================================================================
-- 1. CRIAÇÃO DOS 5 ÍNDICES ESTRATÉGICOS
-- =====================================================================

-- ÍNDICE 1: Otimização da Busca de Membros (Consulta 2)
-- Motivo: A PK de 'Inscricao' começa com 'id_canal'. Buscar por usuário (id_membro)
-- sem este índice exigiria ler a tabela inteira (Full Scan).
CREATE INDEX idx_inscricao_membro 
ON streaming.Inscricao(id_membro);

-- ÍNDICE 2: Agregação de Patrocínios por Canal (Suporte à MV)
-- Motivo: A PK de 'Patrocinio' começa com 'nro_empresa'. Para somar o patrocínio
-- por canal (para os Rankings), o banco precisaria varrer tudo. Este índice inverte a busca.
CREATE INDEX idx_patrocinio_canal 
ON streaming.Patrocinio(id_canal);

-- ÍNDICE 3: Agregação de Doações por Canal (Suporte à MV e Consulta 3)
-- Motivo: A tabela Doacao é massiva. Este índice parcial cria um "sub-conjunto" leve
-- apenas com doações válidas, agrupadas por canal.
CREATE INDEX idx_doacao_canal_valida 
ON streaming.Doacao(id_canal) 
WHERE status_doacao IN ('recebido', 'lido');

