const { json } = require("sequelize");
const Tasks = require("../models/taskModel");

exports.addTask = async (req, res)=>{
    const {emp_id} = req.body;
    if(emp_id == null){
        return res.status(400).json({message: "empid is required"});
    } 

    try{
        const newTask = await Tasks.create(req.body);
        res.status(200).json({message: "Task added successfully", task: newTask});
    }catch(error){
        console.log("error while adding task");
        res.status(500).json({message: "Database Error", error});
    }
};

exports.getTasks = async (req, res)=>{
    const {id} = req.params;
    try{
        const task = await Tasks.findAll({
            where: {emp_id : id},
        });
        res.status(200).json({tasks: task});
    }catch(error){
        console.error("Error fetching tasks", error);
        res.status(500).json({message : "Database error", error});
    }
};