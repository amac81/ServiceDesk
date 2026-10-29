INSERT INTO tb_user (
    name,
    email,
    password_hash,
    active,
    created_at,
    updated_at
)
VALUES
(
    'Administrador de Teste',
    'admin@servicedesk.local',
    '{noop}Admin123!',
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Técnico de Teste',
    'tecnico@servicedesk.local',
    '{noop}Tecnico123!',
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Utilizador de Teste',
    'utilizador@servicedesk.local',
    '{noop}Utilizador123!',
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);