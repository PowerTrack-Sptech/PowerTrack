var empresaModel = require("../models/empresaModel");

function listarGerador(req, res) {
  empresaModel.listar().then((resultado) => {
    res.status(200).json(resultado);
  });
}
function cadastrar(req, res) {
    // Crie uma variável que vá recuperar os valores do arquivo cadastro.html
    var nome = req.body.nomeServer;
    var sobrenome = req.body.sobrenomeServer;
    var email = req.body.emailServer;
    var codigoEmpresa = req.body.codigoEmpresaServer;
    var senha = req.body.senhaServer;

    // Faça as validações dos valores
    if (nome == undefined) {
        res.status(400).send("Seu nome está undefined!");
    } else if (sobrenome == undefined) {
        res.status(400).send("Seu sobrenome está undefined!");
    } else if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (codigoEmpresa == undefined) {
        res.status(400).send("O código da empresa está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está undefined!");
    } else {

        // Verifica se o e-mail já está cadastrado
        usuarioModel.verificarEmail(email)
            .then(
                function (resultadoEmail) {

                    if (resultadoEmail.length > 0) {
                        res.status(409).send("Este e-mail já está cadastrado!");
                    } else {

                        // Verifica se o código da empresa existe
                        usuarioModel.verificarCodigoEmpresa(codigoEmpresa)
                            .then(
                                function (resultadoEmpresa) {

                                    if (resultadoEmpresa.length == 0) {
                                        res.status(404).send("Código da empresa inválido!");
                                    } else {

                                        var fkEmpresa = resultadoEmpresa[0].id;

                                        // Passe os valores como parâmetro e vá para o arquivo usuarioModel.js
                                        usuarioModel.cadastrar(nome, sobrenome, email, senha, fkEmpresa)
                                            .then(
                                                function (resultado) {
                                                    res.status(201).json(resultado);
                                                }
                                            ).catch(
                                                function (erro) {
                                                    console.log(erro);
                                                    console.log("\nHouve um erro ao realizar o cadastro! Erro: ", erro.sqlMessage);
                                                    res.status(500).json(erro.sqlMessage);
                                                }
                                            );
                                    }
                                }
                            ).catch(
                                function (erro) {
                                    console.log(erro);
                                    console.log("\nHouve um erro ao verificar a empresa! Erro: ", erro.sqlMessage);
                                    res.status(500).json(erro.sqlMessage);
                                }
                            );
                    }
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log("\nHouve um erro ao verificar o e-mail! Erro: ", erro.sqlMessage);
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }
}

module.exports ={
    listarGerador
}