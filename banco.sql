CREATE DATABASE IF NOT EXISTS pit_controle_chamados
    CHARACTER SET utf8mb4;

USE pit_controle_chamados;

CREATE TABLE IF NOT EXISTS solicitantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS chamados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    descricao TEXT NOT NULL,
    data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Aberto', 'Em atendimento', 'Resolvido')
        NOT NULL DEFAULT 'Aberto',
    solicitante_id INT NOT NULL,
    CONSTRAINT fk_chamado_solicitante
        FOREIGN KEY (solicitante_id) REFERENCES solicitantes (id)
) ENGINE = InnoDB;

-- Cadastra ou recupera a solicitante fictícia.
INSERT INTO solicitantes (nome, email)
VALUES ('Ana Exemplo', 'ana@example.com')
ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);

SET @solicitante_id = LAST_INSERT_ID();

-- Cria um chamado de demonstração.
INSERT INTO chamados (titulo, descricao, solicitante_id)
VALUES ('Falha de acesso ao sistema', 'Chamado fictício para o PIT.', @solicitante_id);

SET @chamado_id = LAST_INSERT_ID();

-- Consulta inicial: o chamado deve aparecer como Aberto.
SELECT c.id, c.titulo, s.nome AS solicitante, c.status
FROM chamados AS c
JOIN solicitantes AS s ON s.id = c.solicitante_id
WHERE c.id = @chamado_id;

-- Atualiza o chamado criado nesta execução.
UPDATE chamados
SET status = 'Resolvido'
WHERE id = @chamado_id;

-- Consulta final: o mesmo chamado deve aparecer como Resolvido.
SELECT id, titulo, status
FROM chamados
WHERE id = @chamado_id;

mysql> 
