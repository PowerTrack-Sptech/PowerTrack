var usuarioModel = require("../models/usuarioModel");

function autenticar(req, res) {
    var email = req.body.emailServer;
    var senha = req.body.senhaServer;

    if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está indefinida!");
    } else {

        usuarioModel.autenticar(email, senha)
            .then(
                function (resultadoAutenticar) {
                    console.log(`\nResultados encontrados: ${resultadoAutenticar.length}`);
                    console.log(`Resultados: ${JSON.stringify(resultadoAutenticar)}`);

                    if (resultadoAutenticar.length == 1) {
                        console.log(resultadoAutenticar);

                        if (resultadoAutenticar[0].status_usuario == 1) {
                            res.json({
                                id: resultadoAutenticar[0].id,
                                nome: resultadoAutenticar[0].nome,
                                sobrenome: resultadoAutenticar[0].sobrenome,
                                email: resultadoAutenticar[0].email,
                                empresaId: resultadoAutenticar[0].fk_empresa
                            });
                        } else {
                            res.status(403).send("Usuário inativo!");
                        }

                    } else if (resultadoAutenticar.length == 0) {
                        res.status(403).send("Email e/ou senha inválido(s)");
                    } else {
                        res.status(403).send("Mais de um usuário com o mesmo login e senha!");
                    }
                }
            ).catch(
                function (erro) {
                    console.log(erro);
                    console.log("\nHouve um erro ao realizar o login! Erro: ", erro.sqlMessage);
                    res.status(500).json(erro.sqlMessage);
                }
            );
    }
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

module.exports = {
    autenticar,
    cadastrar
};
