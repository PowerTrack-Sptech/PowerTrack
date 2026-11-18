
var database = require("../database/config")

function autenticar(email, senha) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Verificando login:", email, senha)

    var instrucaoSql = `
        SELECT id, nome, sobrenome, email, fk_empresa, status_usuario
        FROM usuario
        WHERE email = ? AND senha = ?;
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql, [email, senha]);
}

// Coloque os mesmos parâmetros aqui. Vá para a var instrucaoSql
function cadastrar(nome, sobrenome, email, senha, fkEmpresa) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> function cadastrar():", nome, email, fkEmpresa);

    // Insira exatamente a query do banco aqui, lembrando da nomenclatura exata
    // e na ordem de inserção dos dados.
    var instrucaoSql = `
        INSERT INTO usuario (nome, sobrenome, email, senha, fk_empresa)
        VALUES (?, ?, ?, ?, ?);
    `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql, [
        nome, sobrenome, email, senha, fkEmpresa
    ]);
}

function verificarEmail(email) {
    var instrucaoSql = `
        SELECT id FROM usuario WHERE email = ?;
    `;

    return database.executar(instrucaoSql, [email]);
}

function verificarCodigoEmpresa(codigoEmpresa) {
    var instrucaoSql = `
        SELECT id FROM empresa WHERE codigo_empresa = ?;
    `;

    return database.executar(instrucaoSql, [codigoEmpresa]);
}

module.exports = {
    autenticar,
    cadastrar,
    verificarEmail,
    verificarCodigoEmpresa
};
