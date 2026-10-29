ALTER TABLE tb_user
    ADD COLUMN username VARCHAR(50);

UPDATE tb_user
SET username = 'user_' || id
WHERE username IS NULL;

ALTER TABLE tb_user
    ALTER COLUMN username SET NOT NULL;

ALTER TABLE tb_user
    ADD CONSTRAINT uk_tb_user_username UNIQUE (username);