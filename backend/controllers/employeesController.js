const Employee = require('../models/employeesModel');

exports.addEmployee = (req, res)=>{
    const {emp_id, email, username, ename, password} = req.body;

    if(!username || !password){
        return res.status(400).json({message : "username and password are required"});
    }

    Employee.createEmployee(emp_id, email, username, ename, password, (err, result)=>{
        if(err)
            return res.status(500).json({message: "Database error", error : err});

        res.status(200).json({message : "employee added successfully", id : result.insertId});
    });
};

exports.getEmployees = (req, res)=>{
    Employee.getAllEmployees((err, results)=> {
        if(err)
            return res.status(500).json({message : 'database error', error : err});

        res.status(200).json(results);
    })
}