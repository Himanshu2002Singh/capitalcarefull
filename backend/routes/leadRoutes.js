const express = require('express');
const router = express.Router();
const leadController = require('../controllers/leadController');

router.post('/submit-lead', leadController.addLead);
router.get('/leads', leadController.getLeads);
router.get('/leads/:emp_id', leadController.getLeadsById);
router.put('/leads/:id', leadController.updateLead);

module.exports = router;