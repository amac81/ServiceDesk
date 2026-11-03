-- =====================================================
-- USERS 
-- =====================================================

INSERT INTO tb_user (
    username,
    name,
    email,
    password_hash,
    active,
    created_at,
    updated_at
)
SELECT
    data.username,
    data.name,
    data.email,
    data.password_hash,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM (
    VALUES
        ('admin', 'Administrador de Teste',
         'admin@servicedesk.local', '{noop}Admin123!'),
        ('tecnico', 'Técnico de Teste',
         'tecnico@servicedesk.local', '{noop}Tecnico123!'),
        ('utilizador', 'Utilizador de Teste',
         'utilizador@servicedesk.local', '{noop}Utilizador123!')
) AS data(username, name, email, password_hash)
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_user existing
    WHERE existing.email = data.email
       OR existing.username = data.username
);


-- =====================================================
-- TICKET CATEGORIES
-- =====================================================

INSERT INTO tb_ticket_category (
    name,
    code,
    description,
    active,
    created_at,
    updated_at
)
VALUES
    (
        'Hardware',
        'HARDWARE',
        'Computadores, monitores, impressoras, periféricos e outros equipamentos.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Software',
        'SOFTWARE',
        'Instalação, configuração e resolução de problemas de aplicações e programas.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Redes e Comunicações',
        'REDES',
        'Problemas de conectividade, rede cablada, Wi-Fi e acesso remoto.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Contas e Acessos',
        'CONTAS-ACESSOS',
        'Criação de contas, palavras-passe, permissões e controlo de acessos.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Correio Eletrónico',
        'EMAIL',
        'Problemas com correio eletrónico, calendários e listas de distribuição.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Sistemas e Servidores',
        'SISTEMAS',
        'Servidores, sistemas operativos, virtualização e serviços de infraestrutura.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Impressão e Digitalização',
        'IMPRESSAO',
        'Impressoras, equipamentos multifunções, digitalização e filas de impressão.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Aplicações de Gestão',
        'APLICACOES-GESTAO',
        'Aplicações de gestão, ERP e sistemas de informação institucionais.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Segurança Informática',
        'SEGURANCA',
        'Antivírus, malware, incidentes de segurança e proteção de informação.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ),
    (
        'Pedidos Gerais',
        'GERAL',
        'Pedidos de apoio informático que não se enquadram noutras categorias.',
        TRUE,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    )
ON CONFLICT DO NOTHING;