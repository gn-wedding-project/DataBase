DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'wedding') THEN
        CREATE DATABASE wedding;
    END IF;
END $$;

\c wedding;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    rg VARCHAR(20),
    number_tel VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_confirmed BOOLEAN NOT NULL,
    is_special BOOLEAN NOT NULL,
    is_invited BOOLEAN  NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_update_trigger
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_users_updated_at();
