CREATE DATABASE PowerTrack;

USE PowerTrack;

CREATE TABLE empresa_cliente (
  id_empresa INT AUTO_INCREMENT PRIMARY KEY,
  nome_empresa VARCHAR(100),
  cnpj_empresa CHAR(18),
  endereco_empresa VARCHAR(150),
  email_empresa VARCHAR(150),
  telefone_empresa CHAR(11),
  
    fk_empresa_beneficiada INT,

  CONSTRAINT chk_empresa_beneficiada
	FOREIGN KEY(fk_empresa_beneficiada)
	REFERENCES empresa_cliente(id_empresa)
);

CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nome_completo VARCHAR(150),
  email_usuario VARCHAR(100),
  codigo_empresa CHAR(8),
  senha_usuario VARCHAR(45),
  status_usuario TINYINT,
  
	fk_usuario_empresa INT,

  CONSTRAINT chk_usuario_empresa
    FOREIGN KEY (fk_usuario_empresa)
    REFERENCES empresa_cliente(id_empresa)
  
);

CREATE TABLE gerador (
  id_gerador INT AUTO_INCREMENT PRIMARY KEY,
  modelo_gerador VARCHAR(50),
  capacidade_tanque_litros DECIMAL(12,2),
  local_instalacao VARCHAR(100),
  usuario_id_usuario INT,
  usuario_fabricante_gerador_id_fabricante INT,
  nome_empresa_beneficiada VARCHAR(100),
  cnpj_empresa_beneficiada CHAR(14),
  largura_tanque_cm DECIMAL(6,2),
  profundidade_tanque_cm DECIMAL(6,2),
  altura_tanque_cm DECIMAL(6,2),
  diametro_tanque_cm DECIMAL(6,2),
  
  fk_gerador_empresa INT,

  CONSTRAINT chk_gerador_empresa
    FOREIGN KEY (fk_gerador_empresa)
    REFERENCES empresa_cliente(id_empresa)
);

CREATE TABLE endereco (
	id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    logadouro VARCHAR(50),
    numero VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    cep CHAR(8),
    
    fk_endereco_gerador INT,
    
    CONSTRAINT chk_endereco_gerador
	 FOREIGN KEY(fk_endereco_gerador)
     REFERENCES gerador(id_gerador)
);

CREATE TABLE sensor (
  id_sensor INT AUTO_INCREMENT PRIMARY KEY,
  modelo_sensor VARCHAR(20),
  data_instalacao_sensor DATE,
  status_sensor VARCHAR(20),
  
  fk_sensor_gerador INT,
  
	CONSTRAINT chk_sensor_gerador
     FOREIGN KEY (fk_sensor_gerador)
     REFERENCES gerador(id_gerador)
);

CREATE TABLE medidas (
  id_medicao INT AUTO_INCREMENT PRIMARY KEY,
  data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  distancia_cm DECIMAL(6,2),
  
  fk_medidas_sensor INT,
  
	CONSTRAINT chk_medidas_sensor
     FOREIGN KEY (fk_medidas_sensor)
     REFERENCES sensor(id_sensor)
);