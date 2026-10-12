CREATE DATABASE PowerTrack;

USE PowerTrack;

CREATE TABLE fabricante_gerador (
  id_fabricante INT AUTO_INCREMENT PRIMARY KEY,
  nome_fabricante VARCHAR(100),
  cnpj_fabricante CHAR(18),
  endereco_fabricante VARCHAR(150),
  email_fabricante VARCHAR(150),
  telefone_fabricante CHAR(11)
);

CREATE TABLE usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nome_completo VARCHAR(150),
  email_usuario VARCHAR(100),
  codigo_empresa CHAR(8),
  senha_usuario VARCHAR(45),
  status_usuario TINYINT,
  fabricante_gerador_id_fabricante INT,
  FOREIGN KEY (fabricante_gerador_id_fabricante) REFERENCES fabricante_gerador(id_fabricante)
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
  FOREIGN KEY (usuario_id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE sensor (
  id_sensor INT AUTO_INCREMENT PRIMARY KEY,
  modelo_sensor VARCHAR(20),
  data_instalacao_sensor DATE,
  status_sensor VARCHAR(20),
  gerador_id_gerador INT,
  FOREIGN KEY (gerador_id_gerador) REFERENCES gerador(id_gerador)
);

CREATE TABLE medidas (
  id_medicao INT AUTO_INCREMENT PRIMARY KEY,
  data_hora TIMESTAMP,
  distancia_cm DECIMAL(6,2),
  sensor_id_sensor INT,
  sensor_gerador_id_gerador INT,
  FOREIGN KEY (sensor_id_sensor) REFERENCES sensor(id_sensor)
);