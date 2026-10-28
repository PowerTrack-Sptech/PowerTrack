USE PowerTrack;

CREATE TABLE empresa (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nome_fantasia VARCHAR(100) NOT NULL,
	cnpj CHAR(14) NOT NULL UNIQUE,
	email VARCHAR(150) NOT NULL UNIQUE,
	telefone_empresa CHAR(11) NOT NULL,
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
	codigo_empresa CHAR(8) NOT NULL UNIQUE,
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
	modelo VARCHAR(50) NOT NULL,
	capacidade_tanque_litros DECIMAL(12,2) NOT NULL,
	largura_tanque_cm DECIMAL(6,2) NOT NULL,
	profundidade_tanque_cm DECIMAL(6,2) NOT NULL,
	altura_tanque_cm DECIMAL(6,2) NOT NULL,
	fk_empresa INT NOT NULL,
	CONSTRAINT chk_gerador_empresa
    FOREIGN KEY (fk_empresa)
    REFERENCES empresa(id)
);

CREATE TABLE alerta(
	id INT PRIMARY KEY AUTO_INCREMENT,
	tipo_alerta VARCHAR(30) NOT NULL,
    data_alerta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
	CONSTRAINT chk_tipo_alerta CHECK( tipo_alerta IN ('Atenção','Crítico')),
    fk_gerador INT NOT NULL,
    CONSTRAINT fk_alerta_gerador 
    FOREIGN KEY (fk_gerador) 
    REFERENCES gerador(id)
);

CREATE TABLE sensor (
	id INT AUTO_INCREMENT PRIMARY KEY,
	modelo_sensor VARCHAR(20) NOT NULL,
	data_instalacao_sensor DATE NOT NULL,
	status_sensor VARCHAR(20) NOT NULL DEFAULT 'Ativo',
	CONSTRAINT chk_status_sensor CHECK (status_sensor IN ('Ativo', 'Inativo')),
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

-- INSERINDO DADOS SIMULADOS PARA SELECT DAS DASHBOARDS 

INSERT INTO empresa (nome_fantasia, cnpj, email, telefone_empresa, fk_empresa_fabricante) VALUES 
('Data Center Alpha','67283849000198', 'datacenteralpha@gmail.com', '11973625364', NULL),
('Hospital Vida+', '24873281000175', 'hospitalvida@gmail.com', '11928352182', 1),
('Industria Silva', '36278329000123', 'industriasilva@gmail.com', '11987378001', NULL),
('Shopping Central', '26137895000177', 'shoppingcentral@gmail.com', '11987886576', 1),
('Universidade São Paulo', '76243547000197', 'universidadesp@gmail.com', '11924351167', 3),
('Data Center Oliveira', '33459087000155', 'datacenteroliveira@gmail.com', '11985429099', NULL),
('Shopping Paulista', '23775668000139', 'shoppingpaulista@gmail.com', '11988045865', 6);

INSERT INTO endereco (logadouro, numero, bairro, cidade, cep, fk_empresa) VALUES 
('Avenida Tecnologia', '1200', 'Centro Empresarial', 'São Paulo', '09340200', 1),
('Rua das Acácias', '245', 'Jardim Paulista', 'São Paulo', '25670350', 2),
('Avenida Industrial', '850', 'Distrito Industrial', 'Santo André', '15800975', 3),
('Avenida dos Comerciantes', '377', 'Centro', 'São Bernardo do Campo', '35670900', 4),
('Rua do Conhecimento', '233', 'Vila Universitária', 'São Paulo', '23450875', 5),
('Avenida dos Data Centers', '1500', 'Polo Tecnológico', 'São Paulo', '04567000', 6),
('Avenida Paulista', '660', 'Bela Vista', 'São Paulo', '01310100', 7);

INSERT INTO gerador (modelo, capacidade_tanque_litros, largura_tanque_cm, profundidade_tanque_cm, altura_tanque_cm, fk_empresa) VALUES
('PT-DIESEL-500', 10000.00, 200.00, 200.00, 250.00, 1),
('PT-DIESEL-400', 5000.00, 160.00, 160.00, 200.00, 2),
('PT-DIESEL-360', 8000.00, 200.00, 200.00, 200.00, 3),
('PT-DIESEL-670', 6000.00, 180.00, 180.00, 200.00, 4),
('PT-DIESEL-250', 3000.00, 150.00, 150.00, 150.00, 5),
('PT-DIESEL-300', 12000.00, 200.00, 200.00, 300.00, 6),
('PT-DIESEL-550', 4000.00, 160.00, 160.00, 160.00, 7);

INSERT INTO sensor (modelo_sensor, data_instalacao_sensor, status_sensor, fk_gerador) VALUES 
('HC-SR04','2026-10-01','Ativo',1),
('HC-SR04','2026-10-02','Ativo',2),
('HC-SR04','2026-10-03','Ativo',3),
('HC-SR04','2026-10-04','Ativo',4),
('HC-SR04','2026-10-05','Ativo',5),
('HC-SR04','2026-10-06','Ativo',6),
('HC-SR04','2026-10-07','Ativo',7);

-- Dados de acordo com a dashboard
-- Distância medida = altura do tanque × (1 − percentual de combustível)
-- O percentual precisa ser convertido para decimal. Por exemplo, 82% vira 0.82.
INSERT INTO medida (data_medicao, distancia_cm, fk_sensor) VALUES 
('2026-10-26 21:38:00', 45.00, 1),
('2026-10-26 21:28:00', 50.00, 1),
('2026-10-26 21:18:00', 55.00, 1),

('2026-10-26 21:35:00', 72.00, 2),
('2026-10-26 21:25:00', 76.00, 2),
('2026-10-26 21:15:00', 80.00, 2),

('2026-10-26 21:30:00', 150.00, 3),
('2026-10-26 21:20:00', 155.00, 3),
('2026-10-26 21:10:00', 160.00, 3),

('2026-10-26 21:25:00', 54.00, 4),
('2026-10-26 21:15:00', 59.00, 4),
('2026-10-26 21:05:00', 64.00, 4),

('2026-10-26 21:23:00', 82.50, 5),
('2026-10-26 21:13:00', 86.00, 5),
('2026-10-26 21:03:00', 90.00, 5),

('2026-10-26 21:15:00', 237.00, 6),
('2026-10-26 20:55:00', 243.00, 6),
('2026-10-26 20:35:00', 250.00, 6),

('2026-10-26 21:12:00', 75.20, 7),
('2026-10-26 21:02:00', 80.00, 7),
('2026-10-26 20:52:00', 85.00, 7);

-- SELECTS DA DASHBOARD 

-- Listar os geradores e suas empresas
SELECT
    gerador.id,
    gerador.modelo,
    empresa.nome_fantasia
FROM gerador
JOIN empresa
    ON gerador.fk_empresa = empresa.id;
    
-- Mostrar a ultima leitura de cada sensor
SELECT
    sensor.id,
    sensor.modelo_sensor,
    medida.distancia_cm,
    medida.data_medicao
FROM sensor
JOIN medida
    ON sensor.id = medida.fk_sensor
WHERE medida.data_medicao = (
    SELECT MAX(m2.data_medicao)
    FROM medida m2
    WHERE m2.fk_sensor = sensor.id
);

-- KPI: geradores monitorados
SELECT
    COUNT(*) AS geradores_monitorados
FROM gerador;

-- Juntando os dados para a dashboard
SELECT
    empresa.nome_fantasia AS empresa,
    gerador.modelo AS gerador,
    sensor.id AS id_sensor,
    medida.distancia_cm AS distancia_cm,
    medida.data_medicao AS ultima_leitura,

    ROUND(
        (
            (gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm
        ) * 100, 
        0
    ) AS percentual_combustivel,

    CASE
        WHEN (
            (gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm
            ) * 100 > 70
            THEN 'Normal'

        WHEN (
            (gerador.altura_tanque_cm - medida.distancia_cm) / gerador.altura_tanque_cm
        ) * 100 > 25
            THEN 'Atenção'

        ELSE 'Crítico'
    END AS status_combustivel

FROM empresa
JOIN gerador
    ON empresa.id = gerador.fk_empresa
JOIN sensor
    ON gerador.id = sensor.fk_gerador
JOIN medida
    ON sensor.id = medida.fk_sensor

WHERE medida.data_medicao = (
    SELECT MAX(m2.data_medicao)
    FROM medida m2
    WHERE m2.fk_sensor = sensor.id
)

ORDER BY sensor.id;

