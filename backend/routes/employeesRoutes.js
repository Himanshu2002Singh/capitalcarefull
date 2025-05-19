const express = require('express');
const router = express.Router();
const employeeController = require('../controllers/employeesController');


router.post('/add-employee', employeeController.addEmployee);
router.get('/employees', employeeController.getEmployees);

module.exports = router;