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
telefone_fabricante CHAR (11) NOT NULL
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
CONSTRAINT chk_tipo_unidade
        CHECK (tipo_unidade IN ('matriz', 'filial')),
CONSTRAINT chk_email_empresa
        CHECK (email_empresa LIKE '%@%.%')
);

CREATE TABLE usuario (
id_usuario INT PRIMARY KEY AUTO_INCREMENT,
nome_completo VARCHAR(150) NOT NULL,
email_usuario VARCHAR(100) NOT NULL UNIQUE,
usuario_login VARCHAR(20) NOT NULL UNIQUE,
empresa VARCHAR(50) NOT NULL,
ultimo_acesso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
senha_usuario VARCHAR(45) NOT NULL,
status_usuario TINYINT DEFAULT 1 CONSTRAINT chStatus_usuario CHECK(status_usuario IN('1', '0'))
);



