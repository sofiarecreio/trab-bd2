-- Configurações iniciais
SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA IF NOT EXISTS streaming;

-- Tipos ENUM
CREATE TYPE streaming.tipo_canal_enum AS ENUM ('privado', 'publico', 'misto');
CREATE TYPE streaming.nivel_canal_enum AS ENUM ('FREE', 'BASIC', 'PREMIUM', 'DIAMOND', 'PLATINUM');
CREATE TYPE streaming.doacao_enum AS ENUM ('recusado', 'recebido', 'lido');

-- =====================================================================
-- 1. ESTRUTURA BASE
-- =====================================================================

CREATE TABLE streaming.Empresa (
    nro            INTEGER       NOT NULL,
    nome           VARCHAR(80)   NOT NULL,
    nome_fantasia  VARCHAR(80)   NOT NULL,
    
    PRIMARY KEY (nro)
);

CREATE TABLE streaming.Conversao (
    id             INTEGER       NOT NULL,
    moeda          VARCHAR(3)    NOT NULL,
    nome           VARCHAR(20)   NOT NULL,
    fator_conver   NUMERIC       NOT NULL,
    
    PRIMARY KEY (id),
    UNIQUE (moeda),
    CHECK (fator_conver > 0)
);

CREATE TABLE streaming.Pais (
    id_pais        INTEGER       NOT NULL,
    ddi            INTEGER       NOT NULL,
    nome           VARCHAR(50)   NOT NULL,
    id_moeda       INTEGER       NOT NULL,
    
    PRIMARY KEY (id_pais),
    UNIQUE (ddi),
    FOREIGN KEY (id_moeda) REFERENCES streaming.Conversao (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.Usuario (
    id              INTEGER       NOT NULL,
    nick            VARCHAR(30)   NOT NULL,
    email           VARCHAR(120)  NOT NULL,
    data_nasc       DATE          NOT NULL,
    telefone        VARCHAR(30)   NOT NULL,
    end_postal      VARCHAR(200)  NOT NULL,
    pais_residencia INTEGER       NOT NULL,
    
    PRIMARY KEY (id),
    UNIQUE (nick),
    UNIQUE (email),
    FOREIGN KEY (pais_residencia) REFERENCES streaming.Pais(id_pais) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.Plataforma (
    nro            INTEGER       NOT NULL,
    nome           VARCHAR(50)   NOT NULL,
    qtd_users      INTEGER       DEFAULT 0,
    empresa_fund   INTEGER       NOT NULL,
    empresa_respo  INTEGER       NOT NULL,
    data_fund      DATE          NOT NULL,
    
    PRIMARY KEY (nro),
    UNIQUE (nome),
    CHECK (qtd_users >= 0),
    FOREIGN KEY (empresa_fund)  REFERENCES streaming.Empresa (nro) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (empresa_respo) REFERENCES streaming.Empresa (nro) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================================
-- 2. RELACIONAMENTOS (Usuário/Empresa)
-- =====================================================================

CREATE TABLE streaming.PlataformaUsuario (
    nro_plataforma  INTEGER NOT NULL,
    usuario_id      INTEGER NOT NULL,
    nro_usuario     INTEGER NOT NULL,
    
    PRIMARY KEY (nro_plataforma, usuario_id),
    UNIQUE (nro_plataforma, nro_usuario),
    FOREIGN KEY (nro_plataforma) REFERENCES streaming.Plataforma(nro) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (usuario_id)     REFERENCES streaming.Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.StreamerPais (
    streamer_id     INTEGER NOT NULL,
    id_pais         INTEGER NOT NULL,
    nro_passaporte  INTEGER NOT NULL,
    
    PRIMARY KEY (streamer_id, id_pais),
    UNIQUE (id_pais, nro_passaporte),
    FOREIGN KEY (streamer_id) REFERENCES streaming.Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_pais)     REFERENCES streaming.Pais(id_pais) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.EmpresaPais (
    nro_empresa  INTEGER NOT NULL,
    id_pais      INTEGER NOT NULL,
    id_nacional  INTEGER NOT NULL,
    
    PRIMARY KEY (nro_empresa, id_pais),
    UNIQUE (id_pais, id_nacional),
    FOREIGN KEY (nro_empresa) REFERENCES streaming.Empresa(nro) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_pais)     REFERENCES streaming.Pais(id_pais) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================================
-- 3. CANAL E MONETIZAÇÃO
-- =====================================================================

CREATE TABLE streaming.Canal (
    id                 BIGINT                    NOT NULL,
    nome               VARCHAR(50)               NOT NULL,
    tipo               streaming.tipo_canal_enum NOT NULL,
    data_fund          DATE                      NOT NULL,
    descricao          VARCHAR(200),
    qtd_visualizacoes  INTEGER                   DEFAULT 0,
    id_streamer        INTEGER                   NOT NULL,
    nro_plataforma     INTEGER                   NOT NULL,
    
    PRIMARY KEY (id),
    UNIQUE (nome, nro_plataforma),
    CHECK (qtd_visualizacoes >= 0),
    FOREIGN KEY (nro_plataforma) REFERENCES streaming.Plataforma(nro) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_streamer)    REFERENCES streaming.Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nro_plataforma, id_streamer) 
        REFERENCES streaming.PlataformaUsuario(nro_plataforma, usuario_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.Patrocinio (
    nro_empresa     INTEGER       NOT NULL,
    id_canal        BIGINT        NOT NULL,
    valor           DECIMAL(12,2) NOT NULL,
    
    PRIMARY KEY (nro_empresa, id_canal),
    CHECK (valor > 0),
    FOREIGN KEY (nro_empresa) REFERENCES streaming.Empresa(nro),
    FOREIGN KEY (id_canal) REFERENCES streaming.Canal(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.NivelCanal (
    id_canal  BIGINT                     NOT NULL,
    nivel     streaming.nivel_canal_enum NOT NULL,
    valor     DECIMAL(12,2)              NOT NULL,
    gif       VARCHAR(200)               NOT NULL,
    
    PRIMARY KEY (id_canal, nivel),
    CHECK (valor >= 0),
    FOREIGN KEY (id_canal) REFERENCES streaming.Canal(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.Inscricao (
    id_canal        BIGINT                     NOT NULL,
    nro_plataforma  INTEGER                    NOT NULL,
    id_membro       INTEGER                    NOT NULL,
    nivel           streaming.nivel_canal_enum NOT NULL,
    
    PRIMARY KEY (id_canal, nro_plataforma, id_membro),
    FOREIGN KEY (id_membro) REFERENCES streaming.Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_canal, nivel) REFERENCES streaming.NivelCanal(id_canal, nivel) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nro_plataforma, id_membro) REFERENCES streaming.PlataformaUsuario(nro_plataforma, usuario_id)
);

-- =====================================================================
-- 4. CONTEÚDO (Vídeo, Participações, Comentários)
-- =====================================================================

CREATE TABLE streaming.Video (
    id              INTEGER          NOT NULL,
    id_canal        BIGINT           NOT NULL,
    dataH           TIMESTAMP        NOT NULL,
    titulo          VARCHAR(100)     NOT NULL,
    tema            VARCHAR(50)      NOT NULL,
    duracao         DOUBLE PRECISION NOT NULL,
    visu_simul      INTEGER,
    visu_total      INTEGER          NOT NULL,

    PRIMARY KEY (id, id_canal),
    UNIQUE (dataH, titulo),
    CHECK (duracao > 0),
    CHECK (visu_simul IS NULL OR visu_simul >= 0),
    CHECK (visu_total >= 0),
    
    FOREIGN KEY (id_canal) REFERENCES streaming.Canal(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.Participa (
    video_id        INTEGER NOT NULL,
    id_canal        BIGINT  NOT NULL,
    id_streamer     INTEGER NOT NULL,
    
    PRIMARY KEY (video_id, id_canal, id_streamer),
    FOREIGN KEY (video_id, id_canal) 
        REFERENCES streaming.Video(id, id_canal) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_streamer) REFERENCES streaming.Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.Comentario (
    video_id        INTEGER       NOT NULL,
    id_canal        BIGINT        NOT NULL,
    id_usuario      INTEGER       NOT NULL,
    seq             INTEGER       NOT NULL,
    texto           VARCHAR(500)  NOT NULL,
    dataH           TIMESTAMP     NOT NULL,
    coment_on       BOOLEAN       NOT NULL,
    
    PRIMARY KEY (video_id, id_usuario, seq, id_canal),
    FOREIGN KEY (video_id, id_canal) 
        REFERENCES streaming.Video(id, id_canal) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES streaming.Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================================
-- 5. DOAÇÕES E PAGAMENTOS
-- =====================================================================

CREATE TABLE streaming.Doacao (
    video_id        INTEGER               NOT NULL,
    id_canal        BIGINT                NOT NULL,
    id_usuario      INTEGER               NOT NULL,
    seq_comentario  INTEGER               NOT NULL,
    seq_pg          INTEGER               NOT NULL,
    valor           DECIMAL(12,2)         NOT NULL,
    status_doacao   streaming.doacao_enum NOT NULL,
    
    PRIMARY KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg),
    CHECK (valor > 0),
    FOREIGN KEY (video_id, id_usuario, seq_comentario, id_canal)
        REFERENCES streaming.Comentario(video_id, id_usuario, seq, id_canal)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.Bitcoin (
    video_id        INTEGER     NOT NULL,
    id_canal        BIGINT      NOT NULL,
    id_usuario      INTEGER     NOT NULL,
    seq_comentario  INTEGER     NOT NULL,
    seq_pg          INTEGER     NOT NULL,
    TxID            VARCHAR(64) NOT NULL,
    
    PRIMARY KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg),
    FOREIGN KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        REFERENCES streaming.Doacao(video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.PayPal (
    video_id        INTEGER     NOT NULL,
    id_canal        BIGINT      NOT NULL,
    id_usuario      INTEGER     NOT NULL,
    seq_comentario  INTEGER     NOT NULL,
    seq_pg          INTEGER     NOT NULL,
    IdPayPal        VARCHAR(64) NOT NULL,
    
    PRIMARY KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg),
    FOREIGN KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        REFERENCES streaming.Doacao(video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.CartaoCredito (
    video_id        INTEGER     NOT NULL,
    id_canal        BIGINT      NOT NULL,
    id_usuario      INTEGER     NOT NULL,
    seq_comentario  INTEGER     NOT NULL,
    dataH           TIMESTAMP   NOT NULL,
    seq_pg          INTEGER     NOT NULL,
    nro             VARCHAR(19) NOT NULL,
    bandeira        VARCHAR(30) NOT NULL,
    
    PRIMARY KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg),
    FOREIGN KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        REFERENCES streaming.Doacao(video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE streaming.MecanismoPlat (
    video_id        INTEGER     NOT NULL,
    id_canal        BIGINT      NOT NULL,
    id_usuario      INTEGER     NOT NULL,
    seq_comentario  INTEGER     NOT NULL,
    seq_pg          INTEGER     NOT NULL,
    seq_plataforma  VARCHAR(50) NOT NULL,
    
    PRIMARY KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg),
    FOREIGN KEY (video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        REFERENCES streaming.Doacao(video_id, id_canal, id_usuario, seq_comentario, seq_pg)
        ON DELETE CASCADE ON UPDATE CASCADE
);
