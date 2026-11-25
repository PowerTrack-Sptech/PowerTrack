CREATE DATABASE PowerTrack;

USE PowerTrack;

CREATE TABLE empresa (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nome_fantasia VARCHAR(100) NOT NULL,
	cnpj CHAR(14) NOT NULL UNIQUE,
	email VARCHAR(150) NOT NULL UNIQUE,
	telefone_empresa CHAR(11) NOT NULL,
    codigo_empresa CHAR(8) NOT NULL UNIQUE,
    fk_empresa_fabricante INT,
	CONSTRAINT chk_empresa_fabricante
	FOREIGN KEY(fk_empresa_fabricante)
	REFERENCES empresa(id)
);

CREATE TABLE usuario (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE,
	senha VARCHAR(45) NOT NULL,
    status_usuario TINYINT NOT NULL DEFAULT 1,
	CONSTRAINT chk_usuario_status CHECK (status_usuario IN (0, 1)),
	fk_empresa INT NOT NULL,
	CONSTRAINT chk_usuario_empresa
    FOREIGN KEY (fk_empresa)
    REFERENCES empresa(id)
);

CREATE TABLE endereco (
	id INT AUTO_INCREMENT PRIMARY KEY,
    logradouro VARCHAR(50) NOT NULL,
    numero VARCHAR(50),
    bairro VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    cep CHAR(8) NOT NULL,
    fk_empresa INT NOT NULL,
    CONSTRAINT chk_endereco_empresa 
    FOREIGN KEY (fk_empresa) 
    REFERENCES empresa(id)
);

CREATE TABLE gerador (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
	modelo VARCHAR(50) NOT NULL,
	capacidade_tanque_litros DECIMAL(12,2) NOT NULL,
	largura_tanque_cm DECIMAL(6,2) NOT NULL,
	altura_tanque_cm DECIMAL(6,2) NOT NULL,
	fk_empresa INT NOT NULL,
	CONSTRAINT chk_gerador_empresa
    FOREIGN KEY (fk_empresa)
    REFERENCES empresa(id)
);

CREATE TABLE sensor (
	id INT AUTO_INCREMENT PRIMARY KEY,
	modelo VARCHAR(20) NOT NULL,
	data_instalacao_sensor DATE NOT NULL,
	status_sensor VARCHAR(20) NOT NULL DEFAULT 'Ativo',
	CONSTRAINT chk_status_sensor CHECK (status_sensor IN ('Ativo', 'Inativo')),
    tipo_alerta VARCHAR(20) DEFAULT 'Normal', -- Vai ser definido através do nivel do combustivel, com Case
    CONSTRAINT chk_tipo_alerta CHECK (tipo_alerta IN ('Critico', 'Atenção', 'Normal')),
	fk_gerador INT NOT NULL,
	CONSTRAINT chk_sensor_gerador
	FOREIGN KEY (fk_gerador)
	REFERENCES gerador(id)
);

CREATE TABLE medida (
	id INT AUTO_INCREMENT PRIMARY KEY,
	data_medicao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	distancia_cm DECIMAL(6,2) NOT NULL,
	fk_sensor INT NOT NULL,
  	CONSTRAINT chk_medidas_sensor
	FOREIGN KEY (fk_sensor)
	REFERENCES sensor(id)
);

-- INSERINDO DADOS NAS TABELAS 

INSERT INTO usuario (nome, sobrenome, email, senha, status_usuario, fk_empresa) VALUES 
('João', 'Victor', 'joaovictor@gmail.com', 'Joao1234', 1, 1 );

INSERT INTO empresa (nome_fantasia, cnpj, email, telefone_empresa, codigo_empresa, fk_empresa_fabricante) VALUES 
('Data Center Alpha','67283849000198', 'datacenteralpha@gmail.com', '11973625364', '77890651', NULL),
('Hospital Vida+', '24873281000175', 'hospitalvida@gmail.com', '11928352182', '28970985', 1),
('Industria Silva', '36278329000123', 'industriasilva@gmail.com', '11987378001', '12567680', NULL),
('Shopping Central', '26137895000177', 'shoppingcentral@gmail.com', '11987886576', '51278642', 1),
('Universidade São Paulo', '76243547000197', 'universidadesp@gmail.com', '11924351167', '78329045', 3),
('Data Center Oliveira', '33459087000155', 'datacenteroliveira@gmail.com', '11985429099', '12386258', NULL),
('Shopping Paulista', '23775668000139', 'shoppingpaulista@gmail.com', '11988045865', '87538426', 6);

INSERT INTO gerador (nome, modelo, capacidade_tanque_litros, largura_tanque_cm, profundidade_tanque_cm, altura_tanque_cm, fk_empresa) VALUES
('GER - 01','VoltForce', 10000.00, 200.00, 200.00, 250.00, 1),
('GER - 02','VoltForce', 5000.00, 160.00, 160.00, 200.00, 2),
('GER - 03','VoltForce', 8000.00, 200.00, 200.00, 200.00, 3),
('GER - 04','VoltForce', 6000.00, 180.00, 180.00, 200.00, 4),
('GER - 05','VoltForce', 3000.00, 150.00, 150.00, 150.00, 5),
('GER - 06','VoltForce', 12000.00, 200.00, 200.00, 300.00, 6),
('GER - 07','VoltForce', 4000.00, 160.00, 160.00, 160.00, 7);

INSERT INTO sensor (modelo, data_instalacao_sensor, status_sensor, fk_gerador) VALUES 
('HC-SR04','2026-10-01','Ativo',1),
('HC-SR04','2026-10-02','Ativo',2),
('HC-SR04','2026-10-03','Ativo',3),
('HC-SR04','2026-10-04','Ativo',4),
('HC-SR04','2026-10-05','Ativo',5),
('HC-SR04','2026-10-06','Ativo',6),
('HC-SR04','2026-10-07','Ativo',7);

-- Distância medida = altura do tanque × (1 − percentual de combustível)
-- O percentual precisa ser convertido para decimal. Por exemplo, 82% vira 0.82.

-- SELECTS DA DASHBOARD 

-- Listar os geradores e suas empresas
SELECT
    gerador.id AS gerador,
    gerador.modelo AS modelo_gerador,
    empresa.nome_fantasia AS nome_empresa
FROM gerador
JOIN empresa ON gerador.fk_empresa = empresa.id;
    
-- Mostrar a ultima leitura de cada sensor
SELECT 
    sensor.id AS sensor, 
    sensor.modelo_sensor AS modelo_sensor,
    medida.distancia_cm AS medicao,
    medida.data_medicao AS data_medicao
FROM sensor
JOIN medida ON sensor.id = medida.fk_sensor
WHERE medida.data_medicao = (
    SELECT MAX(m2.data_medicao)
    FROM medida m2
    WHERE m2.fk_sensor = sensor.id
);

-- KPI: geradores monitorados
SELECT
    CONCAT('Total de geradores monitorados: ',COUNT(*)) AS Geradores_Monitorados
FROM gerador;

-- Juntando os dados para a dashboard
SELECT
	gerador.id AS id_gerador,
    empresa.nome_fantasia AS nome_empresa,
    medida.data_medicao AS ultima_leitura,
    sensor.id AS id_sensor,

    ROUND(
        (
            (gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm
        ) * 100, 
        0
    ) AS percentual_combustivel,

    CASE
        WHEN ((gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm) * 100 > 75
		THEN 'Normal'
		WHEN ((gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm) * 100 > 25
		THEN 'Atenção'
		ELSE 'Crítico'
    END AS status_combustivel

FROM empresa
JOIN gerador ON empresa.id = gerador.fk_empresa
JOIN sensor ON gerador.id = sensor.fk_gerador
JOIN medida ON sensor.id = medida.fk_sensor

WHERE medida.data_medicao = (
    SELECT MAX(m2.data_medicao)
    FROM medida m2
    WHERE m2.fk_sensor = sensor.id
) ORDER BY sensor.id;

-- Select da kpi para o resumo do gerador 
SELECT
    gerador.id AS id_gerador,
    empresa.nome_fantasia AS nome_empresa,
    gerador.modelo AS modelo_gerador,
    gerador.capacidade_tanque_litros AS capacidade_tanque,
    sensor.status_sensor AS status_sensor,
    sensor.data_instalacao_sensor AS instalacao_sensor,
    endereco.logradouro,
    endereco.numero,
    endereco.bairro,
    endereco.cidade,
    medida.data_medicao AS ultima_leitura,

    ROUND(
        ((gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm) * 100,
        0
    ) AS percentual_combustivel,

    CASE
        WHEN ((gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm) * 100 > 75
		THEN 'Normal'
        WHEN ((gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm) * 100 > 25
		THEN 'Atenção'
        ELSE 'Crítico'
    END AS status_combustivel
FROM gerador
JOIN empresa ON gerador.fk_empresa = empresa.id
JOIN endereco ON empresa.id = endereco.fk_empresa
JOIN sensor ON gerador.id = sensor.fk_gerador
JOIN medida ON sensor.id = medida.fk_sensor

WHERE gerador.id = 6
AND medida.data_medicao = (
    SELECT MAX(m2.data_medicao)
    FROM medida m2
    WHERE m2.fk_sensor = sensor.id
);

-- Select do histórico para o gráfico
SELECT
    medida.data_medicao,
    ROUND(
        ((gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm) * 100,
        0
    ) AS percentual_combustivel
FROM gerador
JOIN sensor ON gerador.id = sensor.fk_gerador
JOIN medida ON sensor.id = medida.fk_sensor
WHERE gerador.id = 6
ORDER BY medida.data_medicao ASC;

-- Select dos alertas recentes 
SELECT
    alerta.data_alerta AS data_alerta,
    gerador.id AS id_gerador,
    alerta.tipo_alerta AS tipo_alerta,
    ROUND(
        ((gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm) * 100,
        0
    ) AS percentual_combustivel
FROM alerta
JOIN gerador ON alerta.fk_gerador = gerador.id
JOIN sensor ON gerador.id = sensor.fk_gerador
JOIN medida ON sensor.id = medida.fk_sensor
WHERE gerador.id = 6
AND medida.data_medicao = (
    SELECT MAX(m2.data_medicao)
    FROM medida m2
    WHERE m2.fk_sensor = sensor.id
)
ORDER BY alerta.data_alerta DESC;