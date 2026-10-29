INSERT INTO tb_ticket (
    reference, title, description, status, priority, type,
    requester_id, assignee_id, assigned_group_id, ticket_category_id,
    created_at, updated_at, first_response_at, resolved_at, closed_at,
    due_at, resolution
)
SELECT
    v.reference, v.title, v.description, v.status, v.priority, v.type,
    requester.id, assignee.id, grp.id, cat.id,
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, v.first_response_at,
    v.resolved_at, v.closed_at, v.due_at, v.resolution
FROM (
    VALUES
    ('TCK-2026-000001', 'Computador sem acesso à rede',
     'O computador deixou de conseguir aceder à rede.',
     'NEW', 'NORMAL', 'INCIDENT',
     'utilizador@servicedesk.local', NULL::VARCHAR,
     'TI-HELPDESK', 'REDES',
     NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
     CURRENT_TIMESTAMP + INTERVAL '2 days', NULL::TEXT),

    ('TCK-2026-000002', 'Instalação de aplicação',
     'Pedido de instalação de uma aplicação necessária ao trabalho.',
     'IN_PROGRESS', 'NORMAL', 'SERVICE_REQUEST',
     'utilizador@servicedesk.local', 'tecnico@servicedesk.local',
     'TI-HELPDESK', 'SOFTWARE',
     CURRENT_TIMESTAMP, NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
     CURRENT_TIMESTAMP + INTERVAL '3 days', NULL::TEXT),

    ('TCK-2026-000003', 'Problema de acesso ao correio eletrónico',
     'O utilizador não consegue aceder à caixa de correio eletrónico.',
     'PENDING_USER', 'HIGH', 'INCIDENT',
     'utilizador@servicedesk.local', 'tecnico@servicedesk.local',
     'TI-HELPDESK', 'EMAIL-COLABORACAO',
     CURRENT_TIMESTAMP, NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
     CURRENT_TIMESTAMP + INTERVAL '1 day', NULL::TEXT),

    ('TCK-2026-000004', 'Acesso a pasta partilhada',
     'Pedido de verificação das permissões de acesso a uma pasta partilhada.',
     'RESOLVED', 'LOW', 'SERVICE_REQUEST',
     'utilizador@servicedesk.local', 'tecnico@servicedesk.local',
     'TI-SISTEMAS', 'CONTAS-ACESSOS',
     CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL::TIMESTAMPTZ,
     NULL::TIMESTAMPTZ,
     'Acesso concedido após validação da autorização do responsável.'),

    ('TCK-2026-000005', 'Indisponibilidade de serviço interno',
     'Foi reportada indisponibilidade de um serviço interno utilizado por vários trabalhadores.',
     'OPEN', 'CRITICAL', 'INCIDENT',
     'admin@servicedesk.local', NULL::VARCHAR,
     'TI-SISTEMAS', 'SISTEMAS-SERVIDORES',
     NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ, NULL::TIMESTAMPTZ,
     CURRENT_TIMESTAMP + INTERVAL '4 hours', NULL::TEXT)
) AS v(
    reference, title, description, status, priority, type,
    requester_email, assignee_email, group_code, category_code,
    first_response_at, resolved_at, closed_at, due_at, resolution
)
JOIN tb_user requester ON requester.email = v.requester_email
LEFT JOIN tb_user assignee ON assignee.email = v.assignee_email
JOIN tb_support_group grp ON grp.code = v.group_code
JOIN tb_ticket_category cat ON cat.code = v.category_code
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ticket existing
    WHERE existing.reference = v.reference
);
