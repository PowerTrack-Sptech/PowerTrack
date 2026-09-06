CREATE DATABASE power_track;

USE power_track;

-- CRIAÇÃO TABELAS

CREATE TABLE dimensao_tanque(
id_tanque INT PRIMARY KEY AUTO_INCREMENT,
codigo_gerador VARCHAR (20) NOT NULL,
largura_tanque_cm DECIMAL (6,2),
profundidade_tanque_cm DECIMAL (6,2),
altura_tanque_cm DECIMAL (6,2) NOT NULL, 
formato_tanque VARCHAR (20) NOT NULL,
diametro_tanque_cm DECIMAL (6,2),
CONSTRAINT chFormato CHECK (formato_tanque IN ('cilindrico', 'retangular'))
);

CREATE TABLE gerador (
id_gerador INT PRIMARY KEY AUTO_INCREMENT,
nome_fabricante VARCHAR(50) NOT NULL,
nome_empresa_beneficiada VARCHAR(100) NOT NULL,
codigo_gerador VARCHAR(20) NOT NULL UNIQUE, 
modelo_gerador VARCHAR(50) NOT NULL,
potencia_kva DECIMAL(8,2) NOT NULL,
capacidade_tanque_litros DECIMAL(12,2) NOT NULL, 
consumo_medio_litro_hora DECIMAL(5,2) NOT NULL,
local_instalacao VARCHAR(100) NOT NULL
);

CREATE TABLE sensor (
id_sensor INT PRIMARY KEY AUTO_INCREMENT,
codigo_sensor VARCHAR (20) NOT NULL UNIQUE,
codigo_gerador VARCHAR (20) NOT NULL,
modelo_sensor VARCHAR (20) NOT NULL,
data_instalacao_sensor DATE NOT NULL,
status_sensor VARCHAR (20) NOT NULL,
intervalo_leitura_min INT NOT NULL,
CONSTRAINT chStatus CHECK (status_sensor IN ('ativo', 'manutencao','desativado'))
);

CREATE TABLE medicao (
id_medicao INT PRIMARY KEY AUTO_INCREMENT,
codigo_sensor VARCHAR (20) NOT NULL,
data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
distancia_cm DECIMAL (6,2) NOT NULL,
nivel_percentual DECIMAL (5,2) NOT NULL,
volume_litros DECIMAL (8,2) NOT NULL,
autonomia_horas DECIMAL (6,2) NOT NULL,
status_criticidade VARCHAR (20) NOT NULL,
CONSTRAINT chCriticidade CHECK (status_criticidade IN ('adequado','critico', 'atencao')),
CONSTRAINT chPercentual CHECK (nivel_percentual BETWEEN 0 AND 100)
);

CREATE TABLE abastecimento (
id_abastecimento INT PRIMARY KEY AUTO_INCREMENT,
codigo_gerador VARCHAR (20) NOT NULL, 
data_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
quantidade_litros DECIMAL (6,2) NOT NULL,
responsavel_abastecimento VARCHAR (50) NOT NULL,
nivel_anterior_percentual DECIMAL (5,2) NOT NULL,
nivel_posterior_percentual DECIMAL (5,2) NOT NULL,
CONSTRAINT chPercentual_anterior CHECK (nivel_anterior_percentual BETWEEN 0 AND 100),
CONSTRAINT chPercentual_posterior CHECK (nivel_posterior_percentual BETWEEN 0 AND 100)
);

CREATE TABLE fabricante_gerador (
id_fabricante INT PRIMARY KEY AUTO_INCREMENT,
nome_fabricante VARCHAR (100) NOT NULL,
cnpj_fabricante CHAR (18) NOT NULL UNIQUE,
endereco_fabricante VARCHAR (150) NOT NULL,
email_fabricante VARCHAR (150) NOT NULL UNIQUE,
telefone_fabricante CHAR (11) NOT NULL,
CONSTRAINT chEmail_fabricante CHECK (email_fabricante LIKE '%@%.%')
);

CREATE TABLE empresa_beneficiada (
id_empresa INT PRIMARY KEY AUTO_INCREMENT,
nome_empresa VARCHAR (100) NOT NULL,
ramo_empresa VARCHAR (30) NOT NULL,
representante_empresa VARCHAR (100) NOT NULL,
email_empresa VARCHAR (100) NOT NULL UNIQUE, 
telefone_empresa CHAR (11) NOT NULL,
cnpj_empresa CHAR (18) NOT NULL UNIQUE, 
endereco_empresa VARCHAR (150) NOT NULL,
tipo_unidade VARCHAR(45),
CONSTRAINT chTipo_unidade CHECK (tipo_unidade IN ('matriz', 'filial')),
CONSTRAINT chEmail_empresa CHECK (email_empresa LIKE '%@%.%')
);

CREATE TABLE usuario (
id_usuario INT PRIMARY KEY AUTO_INCREMENT,
nome_completo VARCHAR(150) NOT NULL,
email_usuario VARCHAR(100) NOT NULL UNIQUE,
usuario_login VARCHAR(20) NOT NULL UNIQUE,
empresa VARCHAR(50) NOT NULL,
senha_usuario VARCHAR(45) NOT NULL,
status_usuario TINYINT DEFAULT 1 ,
CONSTRAINT chStatus_usuario CHECK(status_usuario IN('1', '0')),
CONSTRAINT chEmail_usuario CHECK (email_usuario LIKE '%@%.%')
);


-- INSERTS


-- INSERT TABELA DIMENSÃO TANQUE (RETANGULAR)

INSERT INTO dimensao_tanque (codigo_gerador, largura_tanque_cm, profundidade_tanque_cm, altura_tanque_cm, formato_tanque) VALUES 
('GER-01', 200, 100, 50, 'retangular'),
('GER-02', 100, 50, 40, 'retangular'),
('GER-03', 120, 50, 50, 'retangular'),
('GER-04', 125, 80, 50, 'retangular'),
('GER-05', 80, 50, 25, 'retangular'),
('GER-06', 120, 50, 50, 'retangular');

-- INSERT TABELA DIMENSAO TANQUE (CILINDRICO)

INSERT INTO dimensao_tanque (codigo_gerador, altura_tanque_cm, diametro_tanque_cm, formato_tanque) VALUES
('GER-07', 51, 50, 'cilindrico'),
('GER-08', 78, 70, 'cilindrico'),
('GER-09', 100, 80, 'cilindrico'),
('GER-10', 127, 100, 'cilindrico');

-- INSERT TABELA GERADOR

INSERT INTO gerador VALUES
(DEFAULT, 'Smart Geradores', 'Hospital Albert Einstein', 'GER-01', 'PG-350', 350, 1000, 65, 'Hospital Albert Einstein - Morumbi'),
(DEFAULT, 'Total Energy', 'Data Center X', 'GER-02', 'PG-60', 60, 200, 12, 'Data Center X - Sorocaba'),
(DEFAULT, 'Total Energy', 'Data Center X', 'GER-03', 'PG-100', 100, 300, 20, 'Data Center X - Sorocaba'),
(DEFAULT, 'MGM', 'Industria Alpha', 'GER-04', 'PG-180', 180, 500, 34, 'Industria Alpha - São Bernardo do Campo'),
(DEFAULT, 'MGM', 'Industria Alpha', 'GER-05', 'PG-30', 30, 100, 7, 'Industria Alpha - São Bernardo do Campo'),
(DEFAULT, 'Smart Geradores', 'Industria Beta', 'GER-06', 'PG-120', 120, 300, 24, 'Industria Beta - São Paulo'),
(DEFAULT, 'GenPower', 'Hospital Vida Nova', 'GER-07', 'PG-40', 40, 100, 9, 'Hospital Vida Nova - Pinheiros'),
(DEFAULT, 'MegaVolt', 'Data Center Vertex', 'GER-08', 'PG-110', 110, 300, 22, 'Data Center Vertex - Cotia'),
(DEFAULT, 'Smart Geradores', 'Industria Prime', 'GER-09', 'PG-200', 200, 500, 38, 'Industria Prime - São Caetano do Sul'),
(DEFAULT, 'GenPower', 'Data Center Sigma', 'GER-10', 'PG-400', 400, 1000, 75, 'Data Center Sigma - Barueri');

-- INSERT TABELA SENSOR

INSERT INTO sensor VALUES
(DEFAULT, 'SR-01', 'GER-01', 'HC-SR04', '2026-08-10', 'ativo', 30),
(DEFAULT, 'SR-02', 'GER-02', 'HC-SR04', '2026-01-04', 'ativo', 30),
(DEFAULT, 'SR-03', 'GER-03', 'HC-SR04', '2024-05-28', 'desativado', 30),
(DEFAULT, 'SR-04', 'GER-04', 'HC-SR04', '2025-07-15', 'manutencao', 30),
(DEFAULT, 'SR-05', 'GER-05', 'HC-SR04', '2025-02-13', 'ativo', 30),
(DEFAULT, 'SR-06', 'GER-06', 'HC-SR04', '2026-05-16', 'ativo', 30),
(DEFAULT, 'SR-07', 'GER-07', 'HC-SR04', '2023-09-21', 'ativo', 30),
(DEFAULT, 'SR-08', 'GER-08', 'HC-SR04', '2024-09-29', 'manutencao', 30),
(DEFAULT, 'SR-09', 'GER-09', 'HC-SR04', '2026-03-01', 'ativo', 30),
(DEFAULT, 'SR-10', 'GER-10', 'HC-SR04', '2025-03-12', 'desativado', 30);

-- INSERT TABELA MEDICAO

INSERT INTO medicao VALUES
(DEFAULT, 'SR-01', DEFAULT, 10.00, 80.00, 800.00, 12.31, 'adequado'),
(DEFAULT, 'SR-01', DEFAULT, 13.25, 73.50, 735.00, 11.31, 'adequado'),
(DEFAULT, 'SR-02', DEFAULT, 8.00, 80.00, 160.00, 13.33, 'adequado'),
(DEFAULT, 'SR-02', DEFAULT, 10.40, 74.00, 148.00, 12.33, 'adequado'),
(DEFAULT, 'SR-05', DEFAULT, 18.75, 25.00, 25.00, 3.57, 'atencao'),
(DEFAULT, 'SR-05', DEFAULT, 20.50, 18.00, 18.00, 2.57, 'critico'),
(DEFAULT, 'SR-06', DEFAULT, 5.00, 90.00, 270.00, 11.25, 'adequado'),
(DEFAULT, 'SR-06', DEFAULT, 9.00, 82.00, 246.00, 10.25, 'adequado'),
(DEFAULT, 'SR-07', DEFAULT, 10.20, 80.00, 80.00, 8.89, 'adequado'),
(DEFAULT, 'SR-07', DEFAULT, 14.79, 71.00, 71.00, 7.89, 'adequado'),
(DEFAULT, 'SR-09', DEFAULT, 55.00, 45.00, 225.00, 5.92, 'atencao'),
(DEFAULT, 'SR-09', DEFAULT, 62.60, 37.40, 187.00, 4.92, 'atencao');

-- INSERT TABELA ABASTECIMENTOS

INSERT INTO abastecimento VALUES
(DEFAULT, 'GER-02', DEFAULT, 120.00, 'Gustavo Henrique', 20.00, 80.00),
(DEFAULT, 'GER-05', DEFAULT, 70.00, 'Larissa Queiroz', 18.00, 88.00),
(DEFAULT, 'GER-07', DEFAULT, 60.00, 'Tiago Macota', 25.00, 85.00),
(DEFAULT, 'GER-09', DEFAULT, 250.00, 'Thais Nunes', 30.00, 80.00),
(DEFAULT, 'GER-01', DEFAULT, 400.00, 'Gabriel Bergas', 40.00, 80.00);

-- INSERT TABELA FABRICANTE GERADOR

INSERT INTO fabricante_gerador VALUES
(DEFAULT, 'Smart Geradores', '12.345.654/0001-32', 'Rua das Flores - Morumbi/SP', 'smartgeradores@gmail.com', '11919384765'),
(DEFAULT, 'Total Energy', '43.645.234/0001-12', 'Rua das Melancias - Sorocaba/SP', 'totalenergy@gmail.com', '11911237645'),
(DEFAULT, 'MGM', '54.345.765/4567-34', 'Rua das Orquídeas - São Bernardo do Campo/SP', 'mgm@gmail.com', '11910129837'),
(DEFAULT, 'GenPower', '54.257.345/2223-65', 'Rua São Miguel - Barueri/SP', 'genpower@gmail.com', '11911092637'),
(DEFAULT, 'MegaVolt', '56.645.333/3467-09', 'Rua Paralelepipedo- Cotia/SP', 'megavolt@gmail.com', '11910917384');

-- INSERT TABELA EMPRESA BENEFICIADA

INSERT INTO empresa_beneficiada VALUES
(DEFAULT, 'Hospital Albert Einstein', 'Hospital', 'Jose Anderson', 'alberteinstein@gmail.com', '11912736897', '12.343.622/0011-32', 'Av Albert Einstein - Morumbi/SP', 'matriz'),
(DEFAULT, 'Data Center X', 'Data Center', 'Ezequiel Eleuterio', 'datacenterx@gmail.com', '11919652898', '10.233.432/0011-34', 'Av Figueiras - Sorocaba/SP', 'matriz'),
(DEFAULT, 'Industria Alpha', 'Industria Farmaceutica', 'Fabio Machado', 'alpha@gmail.com', '11912726739', '12.465.423/4356-98', 'Av Faria Lima - São Bernardo do Campo/SP', 'matriz'),
(DEFAULT, 'Industria Beta', 'Industria Alimenticia', 'Manoel Elias', 'beta@gmail.com', '11912563487', '08.213.232/0231-12', 'Av Robert Nogueira - São Paulo/SP', 'matriz'),
(DEFAULT, 'Hospital Vida Nova', 'Hospital', 'Flavio Machado', 'vidanova@gmail.com', '11912708644', '24.234.423/0231-21', 'Av São Luiz - Pinheiros/SP', 'matriz'),
(DEFAULT, 'Data Center Vertex', 'Data Center', 'Maria Fernanda', 'vertex@gmail.com', '11912345341', '45.673.867/0867-67', 'Av Girassol - Cotia/SP', 'matriz'),
(DEFAULT, 'Industria Prime', 'Industria Metalurgica', 'Julia Cristina', 'prime@gmail.com', '11912715209', '23.987.765/0001-76', 'Av Goias - São Caetano do Sul/SP', 'filial'),
(DEFAULT, 'Data Center Sigma', 'Data Center', 'Fabiana Pereira', 'sigma@gmail.com', '11910984127', '34.645.867/0002-23', 'Av Luz do Sol - Barueri/SP', 'matriz');

-- INSERT TABELA USUARIO
INSERT INTO usuario VALUES 
(DEFAULT, 'Gustavo Henrique', 'gustavo@gmail.com', 'ghenrique', 'Total Energy', '0123456', 1),
(DEFAULT, 'Larissa Queiroz', 'larissa@gmail.com', 'lariqueiroz', 'MGM', '0123456', 1),
(DEFAULT, 'Tiago Macota', 'tiago@gmail.com', 'tmacota', 'GenPower', '0123456', 1),
(DEFAULT, 'Thais Nunes', 'thais@gmail.com', 'thainunes', 'Smart Geradores', '0123456', 1),
(DEFAULT, 'Gabriel Bergas', 'gabriel@gmail.com', 'gbergas', 'Smart Geradores', '0123456', 1),
(DEFAULT, 'Lucas Almeida', 'lucas@gmail.com', 'lalmeida', 'MegaVolt', '0123456', 0),
(DEFAULT, 'Felipe Silva', 'felipe@gmail.com', 'fsilva', 'MGM', '0123456', 0);


-- CONSULTAS


-- VERIFICAR SENSORES QUE NÃO ESTÃO FUNCIONANDO 100%
SELECT codigo_sensor,
codigo_gerador, 
status_sensor
FROM sensor 
WHERE status_sensor IN ('manutencao', 'desativado');

-- ALERTA DE COMBUSTÍVEL
SELECT codigo_sensor,
nivel_percentual,
CASE 
	WHEN nivel_percentual < 30 THEN CONCAT('Nível Crítico: ', nivel_percentual, '%. Abastecimento necessário!')
    WHEN nivel_percentual <= 70 THEN CONCAT('Nível de atenção: ', nivel_percentual, '%')
    ELSE CONCAT('Nível seguro: ', nivel_percentual, '%')
END AS alerta
FROM medicao;

-- CALCULAR O NÍVEL EM PORCENTAGEM DE ABASTECIMENTO
SELECT codigo_gerador,
responsavel_abastecimento, 
nivel_anterior_percentual,
nivel_posterior_percentual,
nivel_posterior_percentual - nivel_anterior_percentual AS percentual_abastecido
FROM abastecimento; 

-- FILTRAR EMPRESAS BENEFICIADAS DO RAMO INDUSTRIA
SELECT nome_empresa,
ramo_empresa,
endereco_empresa
FROM empresa_beneficiada
WHERE ramo_empresa LIKE ('Industria%');

-- 	VERIFICAR CONSUMO DOS GERADORES EM ORDEM DECRESCENTE
SELECT
codigo_gerador, 
modelo_gerador,
local_instalacao,
consumo_medio_litro_hora AS consumo
FROM gerador
ORDER BY consumo DESC;

-- VERIFICAR USUARIOS ATIVOS E INATIVOS NO SISTEMA
SELECT 
nome_completo,
email_usuario,
usuario_login, empresa, 
CASE 
	WHEN status_usuario = 1 THEN 'Ativo'
    ELSE 'Inativo'
END AS status_usuario
FROM usuario;

-- VERIFICAR GERADORES INSTALADOS EM HOSPITAIS
SELECT codigo_gerador,
nome_fabricante,
modelo_gerador,
local_instalacao
FROM gerador
WHERE local_instalacao LIKE ('Hospital%');

-- FILTRAR APENAS TANQUES NO FOMRATO CILINDRICO
SELECT codigo_gerador,
formato_tanque
FROM dimensao_tanque 
WHERE formato_tanque = 'cilindrico';

-- VERIFICAR GERADORES QUE POSSUEM MENOR AUTONOMIA E PRECISAM DE ATENCAO
SELECT codigo_sensor,
nivel_percentual, 
volume_litros,
autonomia_horas,
status_criticidade
FROM medicao
WHERE nivel_percentual < 50 AND
autonomia_horas < 6
ORDER BY autonomia_horas ASC;

