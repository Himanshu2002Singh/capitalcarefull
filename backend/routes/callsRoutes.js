const express = require("express");
const router = express.Router();
const callsController = require("../controllers/callsController");

router.post('/calls', callsController.addCalls);
router.get('/calls/:id', callsController.getCalls);

module.exports = router;