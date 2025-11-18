CREATE TABLE Empresa (
  nro            INTEGER       PRIMARY KEY,
  nome           VARCHAR(80)   NOT NULL,
  nome_fantasia  VARCHAR(80)   NOT NULL
);

CREATE TABLE Plataforma (
  nro            INTEGER      PRIMARY KEY,
  nome           VARCHAR(50)  NOT NULL UNIQUE,
  qtd_users      INT          DEFAULT 0 CHECK (qtd_users >= 0),
  empresa_fund   INT          NOT NULL,
  empresa_respo  INT          NOT NULL,
  data_fund      DATE         NOT NULL,
  FOREIGN KEY (empresa_fund)  REFERENCES Empresa (nro) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (empresa_respo) REFERENCES Empresa (nro) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Conversao (
  id            INT          PRIMARY KEY,
  moeda         VARCHAR(3)   NOT NULL UNIQUE,
  nome          VARCHAR(20)  NOT NULL,
  fator_conver  NUMERIC      NOT NULL CHECK (fator_conver > 0)
);

CREATE TABLE Pais (
  ddi        INT          PRIMARY KEY,
  nome       VARCHAR(50)  NOT NULL,
  id_moeda   INT          NOT NULL,
  FOREIGN KEY (id_moeda) REFERENCES Conversao (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Usuario (
  id              INTEGER       PRIMARY KEY,
  nick            VARCHAR(30)   NOT NULL UNIQUE,
  email           VARCHAR(120)  NOT NULL UNIQUE,
  data_nasc       DATE          NOT NULL,
  telefone        VARCHAR(30)   NOT NULL,
  end_postal      VARCHAR(200)  NOT NULL,
  pais_residencia INT           NOT NULL,
  FOREIGN KEY (pais_residencia) REFERENCES Pais(ddi) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Usuário cadastrado em uma plataforma (necessário para validar streamer/membro/participante)
CREATE TABLE PlataformaUsuario (
  nro_plataforma  INTEGER NOT NULL,
  usuario_id      INTEGER NOT NULL,
  nro_usuario     INTEGER NOT NULL,
  PRIMARY KEY (nro_plataforma, usuario_id),
  FOREIGN KEY (nro_plataforma) REFERENCES Plataforma(nro) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (usuario_id)     REFERENCES Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_plataforma_nro_usuario UNIQUE (nro_plataforma, nro_usuario)
);

CREATE TABLE StreamerPais (
  streamer_id     INTEGER NOT NULL,
  ddi_pais        INT     NOT NULL,
  nro_passaporte  INT     NOT NULL,
  PRIMARY KEY (streamer_id, ddi_pais),
  FOREIGN KEY (streamer_id) REFERENCES Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE  ,
  FOREIGN KEY (ddi_pais)    REFERENCES Pais(ddi) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_streamer_pais          UNIQUE (streamer_id, ddi_pais),
  CONSTRAINT uq_passaporte_por_pais    UNIQUE (ddi_pais, nro_passaporte)
);

CREATE TABLE EmpresaPais (
  nro_empresa  INTEGER NOT NULL,
  ddi_pais     INT     NOT NULL,
  id_nacional  INT     NOT NULL,
  PRIMARY KEY (nro_empresa, ddi_pais),
  FOREIGN KEY (nro_empresa) REFERENCES Empresa(nro) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ddi_pais)    REFERENCES Pais(ddi) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_pais_id_nacional UNIQUE (ddi_pais, id_nacional)
);

-- =====================================================================
-- CANAL / RELACIONADOS
-- =====================================================================
CREATE TYPE tipo_canal_enum AS ENUM ('privado', 'publico', 'misto');

CREATE TABLE Canal (
  id                   INTEGER         PRIMARY KEY,
  nome                 VARCHAR(50)     NOT NULL UNIQUE,
  tipo                 tipo_canal_enum NOT NULL,
  data_fund            DATE            NOT NULL,
  descricao            VARCHAR(200),
  qtd_visualizacoes    INTEGER         DEFAULT 0 CHECK (qtd_visualizacoes >= 0),
  id_streamer          INTEGER         NOT NULL,
  nro_plataforma       INTEGER         NOT NULL,
  FOREIGN KEY (nro_plataforma) REFERENCES Plataforma(nro) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_streamer)    REFERENCES Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
  -- Garantir que o streamer existe na MESMA plataforma do canal
  FOREIGN KEY (nro_plataforma, id_streamer)
    REFERENCES PlataformaUsuario(nro_plataforma, usuario_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_canal_id_plat UNIQUE (id, nro_plataforma)
);

CREATE TABLE Patrocinio (
  nro_empresa     INTEGER       NOT NULL,
  id_canal        INTEGER       NOT NULL,
  nro_plataforma  INTEGER       NOT NULL,
  valor           DECIMAL(12,2) NOT NULL CHECK (valor > 0),
  PRIMARY KEY (nro_empresa, id_canal, nro_plataforma),
  FOREIGN KEY (nro_empresa)                REFERENCES Empresa(nro),
  FOREIGN KEY (id_canal, nro_plataforma)   REFERENCES Canal(id, nro_plataforma) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TYPE nivel_canal_enum AS ENUM ('FREE', 'BASIC', 'PREMIUM', 'DIAMOND', 'PLATINUM');

CREATE TABLE NivelCanal (
  id_canal        INTEGER          NOT NULL,
  nro_plataforma  INTEGER          NOT NULL,
  nivel           nivel_canal_enum NOT NULL,
  valor           DECIMAL(12,2)    NOT NULL CHECK (valor >= 0),
  gif             VARCHAR(200)     NOT NULL,
  PRIMARY KEY (id_canal, nro_plataforma, nivel),
  FOREIGN KEY (id_canal, nro_plataforma) REFERENCES Canal(id, nro_plataforma) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Inscricao (
  id_canal        INTEGER          NOT NULL,
  nro_plataforma  INTEGER          NOT NULL,
  id_membro       INTEGER          NOT NULL,
  nivel           nivel_canal_enum NOT NULL,
  PRIMARY KEY (id_canal, nro_plataforma, id_membro),
  FOREIGN KEY (id_membro)                         REFERENCES Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_canal, nro_plataforma, nivel)   REFERENCES NivelCanal(id_canal, nro_plataforma, nivel) ON DELETE CASCADE ON UPDATE CASCADE,
  -- Garantir que o membro existe na MESMA plataforma do canal
  FOREIGN KEY (nro_plataforma, id_membro)
    REFERENCES PlataformaUsuario(nro_plataforma, usuario_id)
);

-- =====================================================================
-- VIDEO / PARTICIPA / COMENTARIO
-- =====================================================================
CREATE TABLE Video (
  id             INTEGER      NOT NULL,
  id_canal       INTEGER      NOT NULL,
  nro_plataforma INTEGER      NOT NULL,
  dataH          TIMESTAMP    NOT NULL,
  titulo         VARCHAR(100) NOT NULL,
  tema           VARCHAR(50)  NOT NULL,
  duracao        FLOAT        NOT NULL CHECK (duracao > 0),
  visu_simul     INT          CHECK (visu_simul IS NULL OR visu_simul >= 0),
  visu_total     INT          NOT NULL CHECK (visu_total >= 0),
  PRIMARY KEY (id, id_canal, nro_plataforma),
  FOREIGN KEY (id_canal, nro_plataforma) REFERENCES Canal(id, nro_plataforma) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT uq_video_natural UNIQUE (id_canal, nro_plataforma, dataH, titulo)
);

CREATE TABLE Participa (
  video_id       INTEGER     NOT NULL,
  id_streamer    INTEGER    NOT NULL,
  PRIMARY KEY (video_id, id_streamer),
  FOREIGN KEY (video_id)    REFERENCES Video(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_streamer) REFERENCES Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Comentario (
  video_id       INTEGER    NOT NULL,
  id_canal       INTEGER    NOT NULL,
  id_usuario     INTEGER    NOT NULL,
  seq            INTEGER    NOT NULL,
  texto          VARCHAR(500) NOT NULL,
  dataH          TIMESTAMP  NOT NULL,
  coment_on      BOOLEAN     NOT NULL,
  nro_plataforma INTEGER    NOT NULL,          
  PRIMARY KEY (video_id, id_usuario, seq, nro_plataforma, id_canal),
  FOREIGN KEY (video_id)   REFERENCES Video(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (nro_plataforma, id_usuario)
    REFERENCES PlataformaUsuario(nro_plataforma, usuario_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- =====================================================================
-- DOAÇÕES E MEIOS DE PAGAMENTO (com video_id)
-- =====================================================================
CREATE TYPE doacao_enum AS ENUM ('recusado', 'recebido', 'lido');

CREATE TABLE Doacao (
  video_id        INTEGER       NOT NULL,
  id_canal        INTEGER       NOT NULL,
  nro_plataforma  INTEGER       NOT NULL,
  id_usuario      INTEGER       NOT NULL,
  seq_comentario  INTEGER       NOT NULL,
  seq_pg          INTEGER       NOT NULL,
  valor           DECIMAL(12,2) NOT NULL CHECK (valor > 0),
  status_doacao   doacao_enum   NOT NULL,
  PRIMARY KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg),
  FOREIGN KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario)
    REFERENCES Comentario(video_id, id_usuario, seq)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Bitcoin (
  video_id        INTEGER       NOT NULL,
  id_canal        INTEGER       NOT NULL,
  nro_plataforma  INTEGER       NOT NULL,
  id_usuario      INTEGER       NOT NULL,
  seq_comentario  INTEGER       NOT NULL,
  seq_pg          INTEGER       NOT NULL,
  TxID            VARCHAR(64)   NOT NULL,
  PRIMARY KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg),
  FOREIGN KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    REFERENCES Doacao(video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PayPal (
  video_id        INTEGER       NOT NULL,
  id_canal        INTEGER       NOT NULL,
  nro_plataforma  INTEGER       NOT NULL,
  id_usuario      INTEGER       NOT NULL,
  seq_comentario  INTEGER       NOT NULL,
  seq_pg          INTEGER       NOT NULL,
  IdPayPal        VARCHAR(64)   NOT NULL,
  PRIMARY KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg),
  FOREIGN KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    REFERENCES Doacao(video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CartaoCredito (
  video_id        INTEGER       NOT NULL,
  id_canal        INTEGER       NOT NULL,
  nro_plataforma  INTEGER       NOT NULL,
  id_usuario      INTEGER       NOT NULL,
  seq_comentario  INTEGER       NOT NULL,
  dataH           TIMESTAMP     NOT NULL,
  seq_pg          INTEGER       NOT NULL,
  nro             VARCHAR(19)   NOT NULL,
  bandeira        VARCHAR(30)   NOT NULL,
  PRIMARY KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg),
  FOREIGN KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    REFERENCES Doacao(video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE MecanismoPlat (
  video_id        INTEGER       NOT NULL,
  id_canal        INTEGER       NOT NULL,
  nro_plataforma  INTEGER       NOT NULL,
  id_usuario      INTEGER       NOT NULL,
  seq_comentario  INTEGER       NOT NULL,
  seq_pg          INTEGER       NOT NULL,
  seq_plataforma  VARCHAR(50)   NOT NULL,
  PRIMARY KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg),
  FOREIGN KEY (video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    REFERENCES Doacao(video_id, id_canal, nro_plataforma, id_usuario, seq_comentario, seq_pg)
    ON DELETE CASCADE ON UPDATE CASCADE
);