const express = require("express");
const router = express.Router();
const taskController = require("../controllers/taskController");

router.post('/add_task', taskController.addTask);
router.get('/task/:id', taskController.getTasks);
router.get('/task_by_lead_id/:id', taskController.getTasksByLeadId);

module.exports = router;