INSERT INTO tb_support_group (
    name, code, description, email, active, created_at, updated_at
)
VALUES
    ('TI — Helpdesk', 'TI-HELPDESK',
     'Atendimento inicial e resolução de pedidos de suporte informático.',
     'helpdesk@servicedesk.local', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('TI — Sistemas e Redes', 'TI-SISTEMAS',
     'Administração de sistemas, servidores, redes e infraestrutura.',
     'sistemas@servicedesk.local', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('TI — Aplicações', 'TI-APLICACOES',
     'Suporte às aplicações e sistemas de informação.',
     'aplicacoes@servicedesk.local', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO tb_ticket_category (
    name, code, description, active, created_at, updated_at
)
VALUES
    ('Hardware', 'HARDWARE',
     'Computadores, monitores, impressoras e outros equipamentos.',
     TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Software', 'SOFTWARE',
     'Aplicações, programas e problemas de utilização de software.',
     TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Redes', 'REDES',
     'Conectividade, rede cablada, Wi-Fi e acesso remoto.',
     TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Contas e Acessos', 'CONTAS-ACESSOS',
     'Contas de utilizador, palavras-passe e permissões de acesso.',
     TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Email e Colaboração', 'EMAIL-COLABORACAO',
     'Correio eletrónico, calendários e ferramentas de colaboração.',
     TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('Sistemas e Servidores', 'SISTEMAS-SERVIDORES',
     'Servidores, infraestrutura, armazenamento e cópias de segurança.',
     TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
