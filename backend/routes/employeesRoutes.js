const express = require("express");
const router = express.Router();
const employeeController = require("../controllers/employeesController");
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });

router.post("/add-employee", employeeController.addEmployee);
router.post(
  "/createuserusingexcel",
  upload.single("file"),
  employeeController.createuserusingexcel
);

router.get("/employees", employeeController.getEmployees);

router.post("/login", employeeController.loginEmployee);

module.exports = router;
