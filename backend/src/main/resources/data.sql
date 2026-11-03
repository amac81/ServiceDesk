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


-- =====================================================
-- SUPPORT GROUPS
-- =====================================================

INSERT INTO tb_support_group (
    name,
    code,
    description,
    email,
    active,
    created_at,
    updated_at
)
VALUES
(
    'TI - Helpdesk',
    'TI-HELPDESK',
    'Atendimento inicial e resolução de pedidos de suporte informático.',
    'helpdesk@servicedesk.local',
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'TI - Sistemas e Redes',
    'TI-SISTEMAS',
    'Administração de sistemas, servidores, redes e infraestrutura.',
    'sistemas@servicedesk.local',
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'TI - Aplicações',
    'TI-APLICACOES',
    'Suporte às aplicações e sistemas de informação.',
    'aplicacoes@servicedesk.local',
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (code) DO NOTHING;


-- =====================================================
-- SUPPORT GROUP MEMBERS
-- =====================================================

INSERT INTO tb_support_group_member (
    user_id,
    support_group_id,
    joined_at,
    left_at,
    active,
    is_default,
    can_assign_tickets,
    can_manage_group,
    tickets_assigned,
    tickets_resolved,
    average_resolution_time,
    average_first_response_time,
    response_rating,
    resolution_rating
)
SELECT
    u.id,
    sg.id,
    CURRENT_TIMESTAMP - v.joined_interval,
    NULL,
    TRUE,
    v.is_default,
    v.can_assign_tickets,
    v.can_manage_group,
    v.tickets_assigned,
    v.tickets_resolved,
    v.average_resolution_time,
    v.average_first_response_time,
    v.response_rating,
    v.resolution_rating
FROM (
    VALUES
    (
        'admin',
        'TI-HELPDESK',
        INTERVAL '180 days',
        TRUE,
        TRUE,
        TRUE,
        0,
        0,
        NULL::BIGINT,
        NULL::BIGINT,
        NULL::NUMERIC,
        NULL::NUMERIC
    ),
    (
        'tecnico',
        'TI-HELPDESK',
        INTERVAL '150 days',
        TRUE,
        TRUE,
        FALSE,
        3,
        1,
        5400::BIGINT,
        900::BIGINT,
        4.50::NUMERIC,
        4.40::NUMERIC
    ),
    (
        'tecnico',
        'TI-SISTEMAS',
        INTERVAL '120 days',
        FALSE,
        TRUE,
        FALSE,
        1,
        1,
        7200::BIGINT,
        1200::BIGINT,
        4.70::NUMERIC,
        4.60::NUMERIC
    )
) AS v(
    username,
    group_code,
    joined_interval,
    is_default,
    can_assign_tickets,
    can_manage_group,
    tickets_assigned,
    tickets_resolved,
    average_resolution_time,
    average_first_response_time,
    response_rating,
    resolution_rating
)
JOIN tb_user u
    ON u.username = v.username
JOIN tb_support_group sg
    ON sg.code = v.group_code
ON CONFLICT (user_id, support_group_id) DO NOTHING;


-- =====================================================
-- TICKETS
-- =====================================================

INSERT INTO tb_ticket (
    reference,
    title,
    description,
    status,
    priority,
    type,
    requester_id,
    assignee_id,
    assigned_group_id,
    ticket_category_id,
    created_at,
    updated_at,
    first_response_at,
    resolved_at,
    closed_at,
    due_at,
    resolution
)
SELECT
    v.reference,
    v.title,
    v.description,
    v.status,
    v.priority,
    v.type,
    requester.id,
    assignee.id,
    sg.id,
    tc.id,
    CURRENT_TIMESTAMP - v.created_interval,
    CURRENT_TIMESTAMP - v.updated_interval,
    CASE
        WHEN v.first_response_interval IS NOT NULL
        THEN CURRENT_TIMESTAMP - v.first_response_interval
        ELSE NULL
    END,
    CASE
        WHEN v.resolved_interval IS NOT NULL
        THEN CURRENT_TIMESTAMP - v.resolved_interval
        ELSE NULL
    END,
    CASE
        WHEN v.closed_interval IS NOT NULL
        THEN CURRENT_TIMESTAMP - v.closed_interval
        ELSE NULL
    END,
    CURRENT_TIMESTAMP + v.due_interval,
    v.resolution
FROM (
    VALUES

    (
        'TCK-2026-000001',
        'Computador sem acesso à rede',
        'O computador deixou de conseguir aceder à rede interna.',
        'NEW',
        'NORMAL',
        'INCIDENT',
        'utilizador',
        NULL::VARCHAR,
        'TI-HELPDESK',
        'REDES',
        INTERVAL '2 hours',
        INTERVAL '2 hours',
        NULL::INTERVAL,
        NULL::INTERVAL,
        NULL::INTERVAL,
        INTERVAL '2 days',
        NULL::TEXT
    ),

    (
        'TCK-2026-000002',
        'Instalação de aplicação',
        'Pedido de instalação de uma aplicação necessária ao desempenho das funções.',
        'IN_PROGRESS',
        'HIGH',
        'SERVICE_REQUEST',
        'utilizador',
        'tecnico',
        'TI-HELPDESK',
        'SOFTWARE',
        INTERVAL '1 day',
        INTERVAL '2 hours',
        INTERVAL '22 hours',
        NULL::INTERVAL,
        NULL::INTERVAL,
        INTERVAL '1 day',
        NULL::TEXT
    ),

    (
        'TCK-2026-000003',
        'Problema no correio eletrónico',
        'O utilizador não consegue enviar mensagens através do correio eletrónico.',
        'PENDING_USER',
        'HIGH',
        'INCIDENT',
        'utilizador',
        'tecnico',
        'TI-HELPDESK',
        'EMAIL',
        INTERVAL '3 days',
        INTERVAL '1 day',
        INTERVAL '2 days',
        NULL::INTERVAL,
        NULL::INTERVAL,
        INTERVAL '1 day',
        NULL::TEXT
    ),

    (
        'TCK-2026-000004',
        'Configuração de servidor',
        'Pedido de configuração e validação de um serviço num servidor interno.',
        'RESOLVED',
        'NORMAL',
        'SERVICE_REQUEST',
        'utilizador',
        'tecnico',
        'TI-SISTEMAS',
        'SISTEMAS',
        INTERVAL '5 days',
        INTERVAL '1 day',
        INTERVAL '4 days',
        INTERVAL '1 day',
        NULL::INTERVAL,
        INTERVAL '2 days',
        'Serviço configurado e validado com sucesso.'
    ),

    (
        'TCK-2026-000005',
        'Acesso a pasta partilhada',
        'Pedido de validação e configuração de permissões numa pasta partilhada.',
        'CLOSED',
        'LOW',
        'SERVICE_REQUEST',
        'utilizador',
        'tecnico',
        'TI-HELPDESK',
        'CONTAS-ACESSOS',
        INTERVAL '10 days',
        INTERVAL '7 days',
        INTERVAL '9 days',
        INTERVAL '7 days',
        INTERVAL '6 days',
        INTERVAL '2 days',
        'Permissões de acesso configuradas e confirmadas pelo utilizador.'
    )

) AS v(
    reference,
    title,
    description,
    status,
    priority,
    type,
    requester_username,
    assignee_username,
    group_code,
    category_code,
    created_interval,
    updated_interval,
    first_response_interval,
    resolved_interval,
    closed_interval,
    due_interval,
    resolution
)
JOIN tb_user requester
    ON requester.username = v.requester_username
LEFT JOIN tb_user assignee
    ON assignee.username = v.assignee_username
LEFT JOIN tb_support_group sg
    ON sg.code = v.group_code
JOIN tb_ticket_category tc
    ON tc.code = v.category_code
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ticket existing
    WHERE existing.reference = v.reference
);



-- =====================================================
-- TICKET COMMENTS
-- =====================================================

INSERT INTO tb_ticket_comment (
    ticket_id,
    user_id,
    content,
    internal,
    created_at
)
SELECT
    t.id,
    u.id,
    c.content,
    c.internal,
    CURRENT_TIMESTAMP - (c.days_ago * INTERVAL '1 day')
FROM (
    VALUES
        (
            'TCK-2026-000001',
            'utilizador',
            'O computador deixou de iniciar depois da última atualização.',
            FALSE,
            5
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'Estamos a analisar o problema. Vamos verificar os registos de arranque.',
            FALSE,
            4
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'Foi identificada uma falha no processo de atualização. Estamos a testar uma solução.',
            TRUE,
            3
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'O problema foi corrigido. O computador já inicia normalmente.',
            FALSE,
            2
        ),
        (
            'TCK-2026-000002',
            'utilizador',
            'Não consigo aceder à minha conta de correio eletrónico.',
            FALSE,
            3
        ),
        (
            'TCK-2026-000002',
            'tecnico',
            'Pode confirmar se consegue aceder através do webmail?',
            FALSE,
            2
        ),
        (
            'TCK-2026-000002',
            'utilizador',
            'Sim, através do webmail consigo aceder normalmente.',
            FALSE,
            1
        ),
        (
            'TCK-2026-000003',
            'tecnico',
            'Foi necessário atualizar a configuração do equipamento de rede.',
            TRUE,
            2
        ),
        (
            'TCK-2026-000003',
            'tecnico',
            'A intervenção foi concluída. A ligação à rede encontra-se operacional.',
            FALSE,
            1
        ),
        (
            'TCK-2026-000004',
            'utilizador',
            'Solicito a instalação de uma aplicação necessária ao desempenho das minhas funções.',
            FALSE,
            1
        )
) AS c(reference, username, content, internal, days_ago)
INNER JOIN tb_ticket t
    ON t.reference = c.reference
INNER JOIN tb_user u
    ON u.username = c.username
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ticket_comment existing
    WHERE existing.ticket_id = t.id
      AND existing.user_id = u.id
      AND existing.content = c.content
);



-- =====================================================
-- TICKET ATTACHMENTS
-- =====================================================

INSERT INTO tb_ticket_attachment (
    ticket_id,
    ticket_comment_id,
    uploaded_by,
    file_name,
    content_type,
    file_size,
    storage_path,
    uploaded_at
)
SELECT
    t.id,
    tc.id,
    u.id,
    a.file_name,
    a.content_type,
    a.file_size,
    a.storage_path,
    CURRENT_TIMESTAMP - (a.days_ago * INTERVAL '1 day')
FROM (
    VALUES
        (
            'TCK-2026-000001',
            'utilizador',
            'O computador deixou de iniciar depois da última atualização.',
            'erro_arranque.jpg',
            'image/jpeg',
            245760,
            'tickets/2026/000001/erro_arranque.jpg',
            5
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'Foi corrigido o problema de arranque.',
            'relatorio_intervencao.pdf',
            'application/pdf',
            512000,
            'tickets/2026/000001/relatorio_intervencao.pdf',
            2
        ),
        (
            'TCK-2026-000002',
            'utilizador',
            'Não consigo aceder à minha conta de correio eletrónico.',
            'erro_outlook.png',
            'image/png',
            184320,
            'tickets/2026/000002/erro_outlook.png',
            3
        ),
        (
            'TCK-2026-000003',
            'tecnico',
            NULL,
            'configuracao_rede.pdf',
            'application/pdf',
            327680,
            'tickets/2026/000003/configuracao_rede.pdf',
            1
        ),
        (
            'TCK-2026-000004',
            'utilizador',
            'Solicito a instalação de uma aplicação necessária ao desempenho das minhas funções.',
            'requisitos_aplicacao.docx',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            98304,
            'tickets/2026/000004/requisitos_aplicacao.docx',
            1
        )
) AS a(
    reference,
    username,
    comment_content,
    file_name,
    content_type,
    file_size,
    storage_path,
    days_ago
)
INNER JOIN tb_ticket t
    ON t.reference = a.reference
INNER JOIN tb_user u
    ON u.username = a.username
LEFT JOIN tb_ticket_comment tc
    ON tc.ticket_id = t.id
    AND tc.user_id = u.id
    AND tc.content = a.comment_content
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ticket_attachment existing
    WHERE existing.storage_path = a.storage_path
);



-- =====================================================
-- TICKET HISTORY
-- =====================================================

INSERT INTO tb_ticket_history (
    ticket_id,
    user_id,
    action,
    field_changed,
    old_value,
    new_value,
    description,
    created_at
)
SELECT
    t.id,
    u.id,
    h.action,
    h.field_changed,
    h.old_value,
    h.new_value,
    h.description,
    CURRENT_TIMESTAMP - (h.days_ago * INTERVAL '1 day')
FROM (
    VALUES
        (
            'TCK-2026-000001',
            'utilizador',
            'CREATED',
            NULL,
            NULL,
            NULL,
            'Ticket criado pelo utilizador.',
            5
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'ASSIGNED',
            'assignee',
            NULL,
            'tecnico',
            'Ticket atribuído ao técnico.',
            4
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'PRIORITY_CHANGED',
            'priority',
            'NORMAL',
            'HIGH',
            'Prioridade alterada após análise do problema.',
            4
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'STATUS_CHANGED',
            'status',
            'OPEN',
            'IN_PROGRESS',
            'Início da intervenção técnica.',
            3
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'RESOLVED',
            'status',
            'IN_PROGRESS',
            'RESOLVED',
            'Problema de arranque resolvido.',
            2
        ),
        (
            'TCK-2026-000002',
            'utilizador',
            'CREATED',
            NULL,
            NULL,
            NULL,
            'Ticket criado pelo utilizador.',
            3
        ),
        (
            'TCK-2026-000002',
            'tecnico',
            'ASSIGNED',
            'assignee',
            NULL,
            'tecnico',
            'Ticket atribuído ao técnico.',
            2
        ),
        (
            'TCK-2026-000002',
            'tecnico',
            'STATUS_CHANGED',
            'status',
            'OPEN',
            'IN_PROGRESS',
            'Análise do problema de correio eletrónico.',
            2
        ),
        (
            'TCK-2026-000003',
            'tecnico',
            'GROUP_CHANGED',
            'assignedGroup',
            'TI-HELPDESK',
            'TI-SISTEMAS',
            'Ticket encaminhado para a equipa de sistemas.',
            2
        ),
        (
            'TCK-2026-000003',
            'tecnico',
            'STATUS_CHANGED',
            'status',
            'OPEN',
            'IN_PROGRESS',
            'Intervenção técnica iniciada.',
            2
        ),
        (
            'TCK-2026-000003',
            'tecnico',
            'RESOLVED',
            'status',
            'IN_PROGRESS',
            'RESOLVED',
            'Problema de rede resolvido.',
            1
        ),
        (
            'TCK-2026-000004',
            'utilizador',
            'CREATED',
            NULL,
            NULL,
            NULL,
            'Pedido de instalação de aplicação criado.',
            1
        )
) AS h(
    reference,
    username,
    action,
    field_changed,
    old_value,
    new_value,
    description,
    days_ago
)
INNER JOIN tb_ticket t
    ON t.reference = h.reference
LEFT JOIN tb_user u
    ON u.username = h.username
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ticket_history existing
    WHERE existing.ticket_id = t.id
      AND existing.action = h.action
      AND existing.created_at =
          CURRENT_TIMESTAMP - (h.days_ago * INTERVAL '1 day')
      AND existing.description IS NOT DISTINCT FROM h.description
);



-- =====================================================
-- TICKET WATCHERS
-- =====================================================

INSERT INTO tb_ticket_watcher (
    ticket_id,
    user_id,
    created_at,
    active
)
SELECT
    t.id,
    u.id,
    CURRENT_TIMESTAMP - (w.days_ago * INTERVAL '1 day'),
    w.active
FROM (
    VALUES
        (
            'TCK-2026-000001',
            'admin',
            5,
            TRUE
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            4,
            TRUE
        ),
        (
            'TCK-2026-000002',
            'admin',
            3,
            TRUE
        ),
        (
            'TCK-2026-000002',
            'tecnico',
            2,
            TRUE
        ),
        (
            'TCK-2026-000003',
            'admin',
            2,
            TRUE
        ),
        (
            'TCK-2026-000003',
            'utilizador',
            2,
            FALSE
        ),
        (
            'TCK-2026-000004',
            'tecnico',
            1,
            TRUE
        ),
        (
            'TCK-2026-000005',
            'admin',
            1,
            TRUE
        )
) AS w(reference, username, days_ago, active)
INNER JOIN tb_ticket t
    ON t.reference = w.reference
INNER JOIN tb_user u
    ON u.username = w.username
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ticket_watcher existing
    WHERE existing.ticket_id = t.id
      AND existing.user_id = u.id
);



-- =====================================================
-- TICKET WORKLOGS
-- =====================================================

INSERT INTO tb_ticket_worklog (
    ticket_id,
    user_id,
    description,
    time_spent,
    work_date,
    created_at
)
SELECT
    t.id,
    u.id,
    w.description,
    w.time_spent,
    CURRENT_DATE - w.days_ago,
    CURRENT_TIMESTAMP - (w.days_ago * INTERVAL '1 day')
FROM (
    VALUES
        (
            'TCK-2026-000001',
            'tecnico',
            'Diagnóstico inicial do problema de arranque.',
            30,
            5
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'Análise dos registos do sistema e identificação da falha na atualização.',
            45,
            4
        ),
        (
            'TCK-2026-000001',
            'tecnico',
            'Correção do problema e realização de testes de arranque.',
            60,
            2
        ),
        (
            'TCK-2026-000002',
            'tecnico',
            'Verificação da configuração da conta de correio eletrónico.',
            20,
            2
        ),
        (
            'TCK-2026-000002',
            'tecnico',
            'Análise da configuração do Outlook e testes de acesso.',
            35,
            1
        ),
        (
            'TCK-2026-000003',
            'tecnico',
            'Diagnóstico da ligação de rede e análise da configuração do equipamento.',
            40,
            2
        ),
        (
            'TCK-2026-000003',
            'admin',
            'Acompanhamento da intervenção e validação da solução.',
            20,
            1
        ),
        (
            'TCK-2026-000004',
            'tecnico',
            'Análise dos requisitos e verificação de compatibilidade da aplicação.',
            25,
            1
        ),
        (
            'TCK-2026-000005',
            'tecnico',
            'Análise inicial do pedido e recolha de informação.',
            15,
            0
        )
) AS w(
    reference,
    username,
    description,
    time_spent,
    days_ago
)
INNER JOIN tb_ticket t
    ON t.reference = w.reference
INNER JOIN tb_user u
    ON u.username = w.username
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ticket_worklog existing
    WHERE existing.ticket_id = t.id
      AND existing.user_id = u.id
      AND existing.description = w.description
);

