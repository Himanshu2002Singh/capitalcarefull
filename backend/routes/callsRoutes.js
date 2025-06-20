const express = require("express");
const router = express.Router();
const callsController = require("../controllers/callsController");

router.post('/calls', callsController.addCalls);
router.get('/calls/:id', callsController.getCalls);
router.get('/callsByLeadId/:id', callsController.getCallsByLeadId);
router.put('/updateCall/:callId', callsController.updateCall);
router.get('/callsByDates', callsController.getCallsByDates);

module.exports = router;