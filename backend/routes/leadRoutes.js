const express = require('express');
const router = express.Router();
const leadController = require('../controllers/leadController');

router.post('/submit-lead', leadController.addLead);
router.get('/leads', leadController.getLeads);
router.get('/leads/:emp_id', leadController.getLeadsById);
router.put('/leads/:id', leadController.updateLead);
router.delete('/delete-lead/:id', leadController.deleteLead);
router.get('/getLead/:id', leadController.getLeadDetails);
router.get('/getLeadsByDate', leadController.leadsByDate);
router.get('/getLeadsByEmpIdAndDate/:emp_id', leadController.leadsByEmpIdAndDate);

module.exports = router;