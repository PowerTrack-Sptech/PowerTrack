# PowerTrack - Monitoramento Remoto de Combustível em Geradores

> **Solução IoT para monitoramento preventivo, contínuo e em tempo real do nível de combustível em grupos geradores de emergência.**

---

## Sobre o Projeto

O **PowerTrack** é uma plataforma de Internet das Coisas (IoT) desenvolvida para fabricantes, empresas de manutenção e prestadores de suporte técnico de grupos geradores. 

O objetivo principal é automatizar o acompanhamento do nível de combustível em tanques de geradores instalados em operações críticas (como hospitais, data centers e indústrias), eliminando a dependência de verificações presenciais e prevenindo falhas no fornecimento de energia por falta de combustível.

---

## O Problema e a Solução

* **O Problema:** A checagem manual e periódica do nível de combustível gera altos custos logísticos, baixa visibilidade histórica e o risco de o gerador não operar no momento de uma interrupção da rede elétrica[cite: 2].
* **A Solução:** Captura automatizada de dados por sensores ultrassônicos, integrados a uma plataforma web centralizada que analisa o consumo, prevê a autonomia do equipamento e emite alertas preventivos.

---

## Funcionalidades Principais

* **Dashboard em Tempo Real:** Painel centralizado para acompanhar o nível (%), volume disponível ($L$) e status de cada gerador cadastrado.
* **Cálculo de Autonomia Estimada:** Estimativa de tempo restante de operação baseada na capacidade do tanque e no consumo médio do equipamento ($L/h$).
* **Alertas de Criticidade:** Notificação imediata quando o combustível atinge níveis abaixo do limite de segurança.
* **Histórico e Detecção de Reabastecimento:** Registro contínuo das medições com detecção automática de entradas de combustível no tanque.
* **Simulador Financeiro:** Ferramenta para estimar a redução de custos operacionais com a diminuição de inspeções presenciais.
* **Controle de Acesso (RBAC):** Níveis de acesso diferenciados entre empresas de suporte/fabricantes e seus clientes finais.

---

## Tecnologias e Arquitetura

### Hardware & IoT
* **Placa Microcontroladora:** Arduino Uno R3
* **Sensor de Medição:** Sensor Ultrassônico HC-SR04 (Mede a distância até a superfície do combustível)
* **Frequência de Leitura:** Coleta e envio de medições em intervalos configuráveis (ex: a cada 30 minutos)

### Software & Infraestrutura
* **Banco de Dados:** MySQL (Mapeamento de Geradores, Tanques, Sensores, Medições, Abastecimentos e Usuários)
* **Ambiente de Desenvolvimento:** Linux (Lubuntu em Máquina Virtual via VirtualBox)
* **Gestão do Projeto:** Trello (Metodologia Ágil / Kanban)

---

## Fluxo de Funcionamento

1. **Leitura:** O sensor ultrassônico instalado no tanque mede a distância até a superfície do combustível.
2. **Processamento:** O sistema calcula a altura do fluido, transformando a distância em volume ($L$) e percentual (%).
3. **Persistência:** As medições são enviadas e registradas no banco de dados MySQL.
4. **Visualização:** A plataforma web consolida as informações em gráficos, calcula a autonomia e monitora os níveis críticos para atuação preventiva da equipe de suporte.
