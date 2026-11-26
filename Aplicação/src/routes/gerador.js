var express = require("express");
var router = express.Router();

var geradorController = require("../controllers/geradorController");

router.get("/listarGerador", function (req, res) {
    geradorController.listarGerador(req, res);
});

router.get("/cadastroGerador", function (req, res) {
    geradorController.cadastroGerador(req, res);
});

module.exports = router;