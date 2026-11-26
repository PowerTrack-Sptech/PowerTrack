var express = require("express");
var router = express.Router();

var empresaController = require("../controllers/empresaController");

router.get("/filtrar", function (req, res) {
  empresaController.listar(req, res);
});

module.exports = router;