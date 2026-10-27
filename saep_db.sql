CREATE DATABASE IF NOT EXISTS saep_assistencia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE saep_assistencia;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS ordens_servico;
DROP TABLE IF EXISTS equipamentos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS usuarios;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  senha_hash VARCHAR(255) NOT NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cpf_cifrado VARBINARY(512) NULL,
  telefone VARCHAR(30) NOT NULL,
  email VARCHAR(150) NULL,
  endereco VARCHAR(255) NULL,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE equipamentos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  tipo VARCHAR(80) NOT NULL,
  marca VARCHAR(80) NOT NULL,
  modelo VARCHAR(100) NOT NULL,
  numero_serie VARCHAR(100) NULL,
  descricao_problema TEXT NOT NULL,
  recebido_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_equip_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE ordens_servico (
  id INT AUTO_INCREMENT PRIMARY KEY,
  equipamento_id INT NOT NULL,
  data_abertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status ENUM('Aberta','Em análise','Aguardando peça','Em reparo','Concluída','Cancelada') NOT NULL DEFAULT 'Aberta',
  diagnostico TEXT NULL,
  servico_realizado TEXT NULL,
  valor DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  data_conclusao DATETIME NULL,
  CONSTRAINT fk_os_equip FOREIGN KEY (equipamento_id) REFERENCES equipamentos(id)
);

-- Senhas de demonstração: usar a tela de cadastro/alterar senha para ambiente real.
-- Hashes bcrypt válidos de "Trocar123!" (demonstração).
INSERT INTO usuarios (nome,email,senha_hash) VALUES
('Administrador Demo','admin@assistencia.local','$2y$12$Tv9706o0JZ67FKH85p6Uaezr8UwmhXeB1HYMMbVXH33cDGmfjvnJ6'),
('Técnico Demo','tecnico@assistencia.local','$2y$12$Tv9706o0JZ67FKH85p6Uaezr8UwmhXeB1HYMMbVXH33cDGmfjvnJ6'),
('Atendimento Demo','atendimento@assistencia.local','$2y$12$Tv9706o0JZ67FKH85p6Uaezr8UwmhXeB1HYMMbVXH33cDGmfjvnJ6');

-- Dados fictícios. CPF não é armazenado em texto puro.
INSERT INTO clientes (nome,cpf_cifrado,telefone,email,endereco) VALUES
('Mariana Alves',NULL,'81990001001','mariana@example.test','Camaragibe - PE'),
('João Pedro Lima',NULL,'81990001002','joao@example.test','Recife - PE'),
('Camila Santos',NULL,'81990001003','camila@example.test','São Lourenço da Mata - PE');

INSERT INTO equipamentos (cliente_id,tipo,marca,modelo,numero_serie,descricao_problema) VALUES
(1,'Notebook','Lenovo','IdeaPad 3','DEMO-LEN-001','Não liga após atualização.'),
(2,'Desktop','Dell','OptiPlex 3080','DEMO-DEL-002','Lentidão e ruído na ventoinha.'),
(3,'Notebook','Acer','Aspire 5','DEMO-ACE-003','Teclado com algumas teclas sem resposta.');

INSERT INTO ordens_servico (equipamento_id,data_abertura,status,diagnostico,servico_realizado,valor) VALUES
(1,'2026-10-20 09:00:00','Em análise','Aguardando diagnóstico técnico.',NULL,0.00),
(2,'2026-10-21 10:30:00','Em reparo','Possível acúmulo de poeira e software desnecessário.',NULL,120.00),
(3,'2026-10-22 14:15:00','Aberta',NULL,NULL,0.00);
