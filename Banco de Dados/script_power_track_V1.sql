USE PowerTrack;

CREATE TABLE empresa (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nome_fantasia VARCHAR(100),
	cnpj CHAR(18),
	email VARCHAR(150),
	telefone_empresa CHAR(11),
    fk_empresa_beneficiada INT,
	CONSTRAINT chk_empresa_beneficiada
	FOREIGN KEY(fk_empresa_beneficiada)
	REFERENCES empresa(id)
);

CREATE TABLE usuario (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(40),
    sobrenome VARCHAR(100),
	email VARCHAR(100),
	codigo_empresa CHAR(8),
	senha VARCHAR(45),
	status_usuario TINYINT,
	fk_usuario INT,
	CONSTRAINT chk_usuario_empresa
    FOREIGN KEY (fk_usuario)
    REFERENCES empresa(id)
);

CREATE TABLE endereco (
	id INT AUTO_INCREMENT PRIMARY KEY,
    logadouro VARCHAR(50),
    numero VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    cep CHAR(8),
    fk_empresa INT,
    CONSTRAINT cjk_endereco_empresa 
    FOREIGN KEY (fk_empresa) 
    REFERENCES empresa(id)
);

CREATE TABLE gerador (
	id INT AUTO_INCREMENT PRIMARY KEY,
	modelo VARCHAR(50),
	capacidade_tanque_litros DECIMAL(12,2),
	largura_tanque_cm DECIMAL(6,2),
	profundidade_tanque_cm DECIMAL(6,2),
	altura_tanque_cm DECIMAL(6,2),
	diametro_tanque_cm DECIMAL(6,2),
	fk_empresa INT,
	CONSTRAINT chk_gerador_empresa
    FOREIGN KEY (fk_empresa)
    REFERENCES empresa(id)
);

CREATE TABLE alerta(
	id INT PRIMARY KEY AUTO_INCREMENT,
	tipo_alerta VARCHAR(30),
    data_alerta DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT chk_tipo_alerta CHECK( tipo_alerta IN ('Atenção','Crítico')),
    fk_gerador INT,
    CONSTRAINT fk_alerta_gerador 
    FOREIGN KEY (fk_gerador) 
    REFERENCES gerador(id)
);

CREATE TABLE sensor (
	id INT AUTO_INCREMENT PRIMARY KEY,
	modelo_sensor VARCHAR(20),
	data_instalacao_sensor DATETIME DEFAULT CURRENT_TIMESTAMP,
	status_sensor VARCHAR(20),
	fk_gerador INT,
	CONSTRAINT chk_sensor_gerador
	FOREIGN KEY (fk_gerador)
	REFERENCES gerador(id)
);

CREATE TABLE medida (
	id INT AUTO_INCREMENT PRIMARY KEY,
	data_medicao DATETIME DEFAULT CURRENT_TIMESTAMP,
	distancia_cm DECIMAL(6,2),
	fk_sensor INT,
  	CONSTRAINT chk_medidas_sensor
	FOREIGN KEY (fk_sensor)
	REFERENCES sensor(id)
);