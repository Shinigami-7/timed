const express = require("express");
const router = express.Router();
const create = require("../controllers/userController");

router.post("/signup", create);

module.exports = router