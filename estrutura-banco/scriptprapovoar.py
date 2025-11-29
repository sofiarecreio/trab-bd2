import psycopg2
from psycopg2.extras import execute_values
from faker import Faker
import random
from datetime import datetime, timedelta
from collections import defaultdict

fake = Faker()
Faker.seed(42)
random.seed(42)

# -------------------------------------------
# CONFIGURAÇÕES
# -------------------------------------------
NUM_EMPRESAS = 200
NUM_CONVERSAO = 10
NUM_PAIS = 200
NUM_USUARIOS = 20_000
NUM_PLATAFORMAS = 200

# Metas de Povoamento
TARGET_PLATAFORMA_USUARIO = 45_000  # Média > 200 users por plataforma
NUM_CANAIS = 2_000
TARGET_INSCRICOES = 100_000
NUM_VIDEOS = 20_000
TARGET_PARTICIPA = 40_000
TARGET_COMENTARIOS = 150_000
TARGET_DOACOES = 40_000

BATCH = 5000

# DB Config
HOST = "localhost"
DB = "postgres"
USER = "postgres"
PWD = "postgres"
PORT = 5432

# -------------------------------------------
# FUNÇÕES AUXILIARES
# -------------------------------------------
conn = psycopg2.connect(host=HOST, database=DB, user=USER, password=PWD, port=PORT)
cur = conn.cursor()

def batch_insert(cur, sql, data, batch=BATCH):
    if not data: return
    for i in range(0, len(data), batch):
        execute_values(cur, sql, data[i:i+batch])

def random_date(start, end):
    if start >= end: return start # Fallback se datas forem iguais
    delta = end - start
    return start + timedelta(days=random.randint(0, delta.days), seconds=random.randint(0, 86400))

print("\n🧹 Limpando tabelas...")
tables_delete_order = [
    "streaming.Bitcoin", "streaming.PayPal", "streaming.CartaoCredito", "streaming.MecanismoPlat",
    "streaming.Doacao", "streaming.Comentario", "streaming.Participa", "streaming.Video",
    "streaming.Inscricao", "streaming.NivelCanal", "streaming.Patrocinio", "streaming.Canal",
    "streaming.EmpresaPais", "streaming.StreamerPais", "streaming.PlataformaUsuario",
    "streaming.Plataforma", "streaming.Usuario", "streaming.Pais", "streaming.Conversao", "streaming.Empresa"
]
for tbl in tables_delete_order:
    cur.execute(f"DELETE FROM {tbl};")
conn.commit()
print("✔ Tabelas limpas!\n")

# ==============================================================================
# 1. ENTIDADES BÁSICAS (Sem dependência complexa)
# ==============================================================================

# --- Empresa ---
print("Gerando Empresas...")
empresas = [(i, fake.company(), fake.company()) for i in range(1, NUM_EMPRESAS+1)]
batch_insert(cur, "INSERT INTO streaming.Empresa (nro, nome, nome_fantasia) VALUES %s", empresas)

# --- Conversao ---
print("Gerando Moedas...")
moedas_codigos = ["USD","EUR","BRL","GBP","JPY","CAD","AUD","CHF","CNY","SEK"]
if NUM_CONVERSAO > len(moedas_codigos): moedas_codigos = (moedas_codigos * 10)[:NUM_CONVERSAO]
conv = [(i, moedas_codigos[i-1], fake.currency_name(), round(random.uniform(0.1, 10.0), 4))
        for i in range(1, NUM_CONVERSAO+1)]
batch_insert(cur, "INSERT INTO streaming.Conversao (id, moeda, nome, fator_conver) VALUES %s", conv)

# --- Pais ---
print("Gerando Países...")
paises = []
used_ddis = set()
for i in range(1, NUM_PAIS+1):
    ddi = random.randint(1, 9999)
    while ddi in used_ddis: ddi = random.randint(1, 9999)
    used_ddis.add(ddi)
    paises.append((i, ddi, fake.country(), random.randint(1, len(conv))))
batch_insert(cur, "INSERT INTO streaming.Pais (id_pais, ddi, nome, id_moeda) VALUES %s", paises)
valid_paises_ids = [p[0] for p in paises]

# --- Usuario ---
print("Gerando Usuários...")
fake.unique.clear()
usuarios = []
for i in range(1, NUM_USUARIOS + 1):
    usuarios.append((
        i, fake.unique.user_name()[:30], fake.unique.email(),
        fake.date_of_birth(minimum_age=13, maximum_age=70),
        fake.phone_number(), fake.address().replace("\n", " ")[:200],
        random.choice(valid_paises_ids)
    ))
batch_insert(cur, "INSERT INTO streaming.Usuario (id, nick, email, data_nasc, telefone, end_postal, pais_residencia) VALUES %s", usuarios)
fake.unique.clear()

# --- Plataforma ---
print("Gerando Plataformas...")
plataformas = []
plat_data_fund = {} # Para checar datas futuras
for i in range(1, NUM_PLATAFORMAS+1):
    dt_fund = random_date(datetime(2005,1,1), datetime(2022,12,31))
    plat_data_fund[i] = dt_fund
    plataformas.append((
        i, f"Platform_{i}", random.randint(0, 1000000),
        random.randint(1, NUM_EMPRESAS), random.randint(1, NUM_EMPRESAS), dt_fund
    ))
batch_insert(cur, "INSERT INTO streaming.Plataforma (nro, nome, qtd_users, empresa_fund, empresa_respo, data_fund) VALUES %s", plataformas)

# ==============================================================================
# 2. RELACIONAMENTOS CRÍTICOS (Lógica "Set" para Unicidade)
# ==============================================================================

# ==============================================================================
# 6. PlataformaUsuario (CORRIGIDO: Garantia de nro_usuario único por plataforma)
# ==============================================================================
print("Gerando PlataformaUsuario (Mapeamento)...")

# 1. Definir quem está em qual plataforma (Conjunto para evitar duplicidade de PK)
plat_user_set = set()
all_users = list(range(1, NUM_USUARIOS+1))
all_plats = list(range(1, NUM_PLATAFORMAS+1))

# Garante que todo usuário tenha ao menos 1 plataforma
for u in all_users:
    p = random.choice(all_plats)
    plat_user_set.add((p, u))

# Preenche até atingir a meta de volume
while len(plat_user_set) < TARGET_PLATAFORMA_USUARIO:
    p = random.randint(1, NUM_PLATAFORMAS)
    u = random.randint(1, NUM_USUARIOS)
    plat_user_set.add((p, u))

# 2. Agrupar temporariamente para gerar IDs internos únicos
temp_plat_users = defaultdict(list)
for (p, u) in plat_user_set:
    temp_plat_users[p].append(u)

plat_user_list = []
users_by_plat = defaultdict(list) # Dicionário usado no resto do script

for p, users in temp_plat_users.items():
    # AQUI ESTÁ A CORREÇÃO:
    # random.sample garante que nunca pegaremos o mesmo número duas vezes nessa lista
    # Usamos range amplo (até 9.999.999) para ter espaço de sobra
    nros_internos = random.sample(range(1000, 9999999), len(users))
    
    for idx, u in enumerate(users):
        nro_usuario = nros_internos[idx]
        plat_user_list.append((p, u, nro_usuario))
        users_by_plat[p].append(u)

batch_insert(cur, "INSERT INTO streaming.PlataformaUsuario (nro_plataforma, usuario_id, nro_usuario) VALUES %s", plat_user_list)

# --- StreamerPais / EmpresaPais ---
print("Gerando Relacionamentos de País (Sem duplicatas)...")
# Usamos sets para garantir unicidade da PK composta
sp_set = set()
while len(sp_set) < (NUM_PAIS * 2):
    sp_set.add((random.randint(1, NUM_USUARIOS), random.choice(valid_paises_ids)))
streamer_pais = [(u, p, random.randint(1000, 9999999)) for (u, p) in sp_set]
batch_insert(cur, "INSERT INTO streaming.StreamerPais VALUES %s", streamer_pais)

ep_set = set()
while len(ep_set) < (NUM_PAIS * 2):
    ep_set.add((random.randint(1, NUM_EMPRESAS), random.choice(valid_paises_ids)))
empresa_pais = [(e, p, random.randint(1000, 9999999)) for (e, p) in ep_set]
batch_insert(cur, "INSERT INTO streaming.EmpresaPais VALUES %s", empresa_pais)

conn.commit()

# ==============================================================================
# 3. NÚCLEO DO STREAMING (Canais, Videos, Interações)
# ==============================================================================

# --- Canal ---
print("Gerando Canais...")
# Regra: O dono do canal (streamer) deve estar na plataforma do canal.
canais = []
canal_map = {} # id_canal -> {plat: int, dt: datetime, streamer: int}

for i in range(1, NUM_CANAIS + 1):
    # Escolhe plataforma
    nro_plat = random.randint(1, NUM_PLATAFORMAS)
    
    # Escolhe streamer válido nessa plataforma
    if not users_by_plat[nro_plat]:
        # Fallback raro se plataforma estiver vazia (improvável pela lógica anterior)
        streamer_id = random.randint(1, NUM_USUARIOS) 
    else:
        streamer_id = random.choice(users_by_plat[nro_plat])
    
    # Data do canal deve ser após fundação da plataforma
    dt_plat = plat_data_fund[nro_plat]
    dt_canal = random_date(dt_plat, datetime(2024, 1, 1))
    
    canais.append((
        i, f"Canal_{i}", random.choice(["privado","publico","misto"]),
        dt_canal, fake.text(100)[:200], random.randint(0, 1000000),
        streamer_id, nro_plat
    ))
    canal_map[i] = {'plat': nro_plat, 'dt': dt_canal, 'streamer': streamer_id}

batch_insert(cur, "INSERT INTO streaming.Canal (id, nome, tipo, data_fund, descricao, qtd_visualizacoes, id_streamer, nro_plataforma) VALUES %s", canais)

# --- Patrocinio ---
# Garantia de unicidade (Empresa, Canal)
print("Gerando Patrocínios...")
patroc_set = set()
while len(patroc_set) < NUM_CANAIS: # ~1 por canal
    patroc_set.add((random.randint(1, NUM_EMPRESAS), random.randint(1, NUM_CANAIS)))
patroc = [(e, c, round(random.uniform(100, 50000), 2)) for (e, c) in patroc_set]
batch_insert(cur, "INSERT INTO streaming.Patrocinio (nro_empresa, id_canal, valor) VALUES %s", patroc)

# --- NivelCanal ---
# PK: (id_canal, nivel)
print("Gerando Níveis de Canal...")
niveis_nomes = ["FREE","BASIC","PREMIUM","DIAMOND","PLATINUM"]
nivel_canal = []
for c_id in range(1, NUM_CANAIS + 1):
    for n_nome in niveis_nomes:
        nivel_canal.append((c_id, n_nome, round(random.uniform(0, 50), 2), "icon.gif"))
batch_insert(cur, "INSERT INTO streaming.NivelCanal (id_canal, nivel, valor, gif) VALUES %s", nivel_canal)

# --- Inscricao ---
# Regra: Usuario deve ser da mesma plataforma do canal. 
# PK: (id_canal, id_membro) - Assumindo que usuario nao pode se inscrever 2x no mesmo canal
print("Gerando Inscrições (Validando Plataforma)...")
insc_set = set()
attempts = 0
all_canal_ids = list(canal_map.keys())

while len(insc_set) < TARGET_INSCRICOES and attempts < TARGET_INSCRICOES * 5:
    attempts += 1
    c_id = random.choice(all_canal_ids)
    plat = canal_map[c_id]['plat']
    
    possible_users = users_by_plat[plat]
    if not possible_users: continue
    
    u_id = random.choice(possible_users)
    
    # Evita auto-inscrição (opcional, mas faz sentido)
    if u_id == canal_map[c_id]['streamer']: continue
    
    insc_set.add((c_id, plat, u_id)) # Adiciona à tupla para verificar unicidade

inscricoes = [(c, p, u, random.choice(niveis_nomes)) for (c, p, u) in insc_set]
batch_insert(cur, "INSERT INTO streaming.Inscricao (id_canal, nro_plataforma, id_membro, nivel) VALUES %s", inscricoes)

# --- Video ---
print("Gerando Vídeos...")
videos = []
video_map = {} # id -> {canal: int, dt: datetime, plat: int}

for v_id in range(1, NUM_VIDEOS + 1):
    c_id = random.choice(all_canal_ids)
    info_c = canal_map[c_id]
    
    # Data Video > Data Canal
    dt_video = random_date(info_c['dt'], datetime.now())
    
    videos.append((
        v_id, c_id, dt_video, f"Video_{v_id}", 
        random.choice(["games","tech","vlog"]), round(random.uniform(1, 300), 2),
        random.randint(0, 500), random.randint(0, 100000)
    ))
    video_map[v_id] = {'canal': c_id, 'dt': dt_video, 'plat': info_c['plat']}

batch_insert(cur, "INSERT INTO streaming.Video (id, id_canal, dataH, titulo, tema, duracao, visu_simul, visu_total) VALUES %s", videos)

# --- Participa ---
# PK: (video_id, id_streamer) -- Um streamer participa de um video
# Regra: Streamer convidado deve ser da mesma plataforma
print("Gerando Participações...")
part_set = set()
all_video_ids = list(video_map.keys())
attempts = 0

while len(part_set) < TARGET_PARTICIPA and attempts < TARGET_PARTICIPA * 5:
    attempts += 1
    v_id = random.choice(all_video_ids)
    info_v = video_map[v_id]
    
    plat = info_v['plat']
    possible_users = users_by_plat[plat]
    if not possible_users: continue
    
    guest = random.choice(possible_users)
    
    # Evita que o dono do canal seja "convidado" no próprio vídeo
    dono_canal = canal_map[info_v['canal']]['streamer']
    if guest == dono_canal: continue
    
    part_set.add((v_id, info_v['canal'], guest)) # PK composta implícita na unicidade do set

part_list = list(part_set)
batch_insert(cur, "INSERT INTO streaming.Participa (video_id, id_canal, id_streamer) VALUES %s", part_list)

# --- Comentario ---
# PK: (video_id, id_usuario, seq) ... assumindo que 'seq' diferencia comentarios do mesmo usuario no mesmo video
# Regra: Usuario da mesma plataforma. Data Comentario > Data Video
print("Gerando Comentários...")
coment_list = []
# Controle de sequencia: dict[(video_id, user_id)] = ultima_seq
seq_control = defaultdict(int) 

attempts = 0
while len(coment_list) < TARGET_COMENTARIOS and attempts < TARGET_COMENTARIOS * 2:
    attempts += 1
    v_id = random.choice(all_video_ids)
    info_v = video_map[v_id]
    
    possible_users = users_by_plat[info_v['plat']]
    if not possible_users: continue
    
    u_id = random.choice(possible_users)
    
    # Incrementa sequencia para esse par video-usuario
    key = (v_id, u_id)
    seq_control[key] += 1
    seq = seq_control[key]
    
    dt_coment = random_date(info_v['dt'], datetime.now())
    
    coment_list.append((
        v_id, info_v['canal'], u_id, seq, 
        fake.text(60).replace("\n"," "), dt_coment, random.choice([True, False])
    ))

batch_insert(cur, "INSERT INTO streaming.Comentario (video_id, id_canal, id_usuario, seq, texto, dataH, coment_on) VALUES %s", coment_list)

# --- Doacao ---
# Doação é filha de Comentário. Selecionamos comentários aleatórios para virarem doações.
print("Gerando Doações...")
if TARGET_DOACOES > len(coment_list):
    TARGET_DOACOES = len(coment_list)

comentarios_para_doacao = random.sample(coment_list, TARGET_DOACOES)

doacoes = []
bitcoin, paypal, cartao, mecplat = [], [], [], []

for com in comentarios_para_doacao:
    # Desempacota dados do comentário (video, canal, user, seq, texto, data, on)
    vid, canal, user, seq, _, dt_coment, _ = com
    
    seq_pg = random.randint(1, 9999999) # Sequencial do pagamento
    valor = round(random.uniform(1.0, 1000.0), 2)
    
    doacoes.append((vid, canal, user, seq, seq_pg, valor, "recebido"))
    
    metodo = random.choice(["btc", "paypal", "cartao", "mec"])
    if metodo == "btc":
        bitcoin.append((vid, canal, user, seq, seq_pg, fake.sha256()))
    elif metodo == "paypal":
        paypal.append((vid, canal, user, seq, seq_pg, fake.uuid4()))
    elif metodo == "cartao":
        # Data do pagamento proxima ao comentario
        cartao.append((vid, canal, user, seq, dt_coment, seq_pg, fake.credit_card_number(), fake.credit_card_provider()))
    else:
        mecplat.append((vid, canal, user, seq, seq_pg, "ExternalSys"))

batch_insert(cur, "INSERT INTO streaming.Doacao VALUES %s", doacoes)
if bitcoin: batch_insert(cur, "INSERT INTO streaming.Bitcoin VALUES %s", bitcoin)
if paypal: batch_insert(cur, "INSERT INTO streaming.PayPal VALUES %s", paypal)
if cartao: batch_insert(cur, "INSERT INTO streaming.CartaoCredito VALUES %s", cartao)
if mecplat: batch_insert(cur, "INSERT INTO streaming.MecanismoPlat VALUES %s", mecplat)

conn.commit()
cur.close()
conn.close()
print("\n✨ SCRIPT FINALIZADO COM SUCESSO - DADOS CONSISTENTES ✨")