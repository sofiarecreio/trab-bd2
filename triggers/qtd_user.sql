CREATE OR REPLACE FUNCTION trg_plataforma_qtd_users()
RETURNS TRIGGER AS $$
BEGIN
    -- Se for um INSERT (novo usuário), incrementa a qtd_users na plataforma
    IF TG_OP = 'INSERT' THEN
        UPDATE streaming.Plataforma
        SET qtd_users = qtd_users + 1
        WHERE nro = NEW.nro_plataforma;

    -- Se for um DELETE (usuário removido), decrementa a qtd_users na plataforma
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE streaming.Plataforma
        SET qtd_users = qtd_users - 1
        WHERE nro = OLD.nro_plataforma;

    END IF;

    RETURN NULL;  -- Trigger é AFTER, então não precisa retornar nada
END;
$$ LANGUAGE plpgsql;

-- Criando a trigger na tabela PlataformaUsuario (para atualizações em qtd_users)
CREATE TRIGGER trg_plataforma_qtd_users
AFTER INSERT OR DELETE ON streaming.PlataformaUsuario
FOR EACH ROW
EXECUTE FUNCTION trg_plataforma_qtd_users();
