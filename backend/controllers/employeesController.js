const Employee = require("../models/employeesModel");
const XLSX = require("xlsx");
const nodemailer = require("nodemailer");
const { Op } = require("sequelize");
const bcrypt = require("bcrypt");

exports.addEmployee = async (req, res) => {
  const { emp_id, email, username, ename, password } = req.body;

  if (!username || !password) {
    return res
      .status(400)
      .json({ message: "username and password are required" });
  }

  try {
    const newEmployee = await Employee.create({
      emp_id,
      email,
      username,
      ename,
      password,
    });

    return res.status(200).json({
      message: "employee added successfully",
      id: newEmployee.emp_id, // or newEmployee.id depending on schema
    });
  } catch (error) {
    console.error("Error adding employee:", error);
    return res.status(500).json({ message: "Database error", error });
  }
};

exports.getEmployees = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || "";
    const offset = (page - 1) * limit;

    const whereClause = search
      ? {
          [Op.or]: [
            { ename: { [Op.like]: `%${search}%` } },
            { email: { [Op.like]: `%${search}%` } },
            { emp_id: { [Op.like]: `%${search}%` } },
            { phone: { [Op.like]: `%${search}%` } },
            { username: { [Op.like]: `%${search}%` } },
          ],
        }
      : {};

    const { count, rows: employees } = await Employee.findAndCountAll({
      where: whereClause,
      limit,
      offset,
      order: [["emp_id", "ASC"]],
    });

    const totalPages = Math.ceil(count / limit);

    return res.status(200).json({
      message: "success",

      employees,
      pagination: {
        totalItems: count,
        totalPages,
        currentPage: page,
        itemsPerPage: limit,
        hasNextPage: page < totalPages,
        hasPreviousPage: page > 1,
      },
    });
  } catch (error) {
    console.error("Error fetching employees:", error);
    return res
      .status(500)
      .json({ message: "Database error", error: error.message });
  }
};

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

exports.createuserusingexcel = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const workbook = XLSX.read(req.file.buffer, { type: "buffer" });
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(sheet);

    const createdUsers = [];

    for (const row of data) {
      const {
        "Employee Id": employeeId,
        Name: name,
        "Mobile Number": phone,
        "Email Id": email,
      } = row;
      const password = Math.floor(
        10000000 + Math.random() * 90000000
      ).toString();
      const hashedPassword = await bcrypt.hash(password, 10);

      const newUser = await Employee.create({
        emp_id: employeeId,
        ename: name,
        phone,
        email,
        username: employeeId,
        password: hashedPassword,
      });
      const mailOptions = {
        from: process.env.EMAIL_USER,
        to: email,
        subject: "Your login Details for website",
        text: `Your employee ID is: ${employeeId}\nYour temporary password is: ${password}\nPlease change your password after first login.`,
      };
      await transporter.sendMail(mailOptions);

      createdUsers.push({
        employeeId: newUser.employeeId,
        name: newUser.name,
        email: newUser.email,
        password: password, // Note: This is the unhashed password
      });
    }

    res.status(200).json({
      message: "Users created successfully",
      users: createdUsers,
    });
  } catch (error) {
    console.error("Error creating users from Excel:", error);
    res
      .status(500)
      .json({ message: "Error creating users", error: error.message });
  }
};
