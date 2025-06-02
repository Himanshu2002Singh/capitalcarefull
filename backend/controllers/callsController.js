Calls = require("../models/callsModel");

exports.addCalls = async (req, res) => {
    const {emp_id} = req.body;

    if(emp_id == null){
        return res.status(400).json({message : "emp_id is required"});
    }

    try{
        const newCalls = await Calls.create(req.body);
        res.status(200).json({message : "New Call added successfully"});
    }catch(error){
        console.error("Error adding Call : ", error);
        res.status(500).json({message : "Database error", error});
    }
};

exports.getCalls = async(req, res)=> {
    const {id} = req.params;
    try{
        const callsData = await Calls.findAll({
            where :{emp_id : id},
            order: [['createdAt', 'DESC']],
        });
        res.status(200).json({calls : callsData});
    }catch(error){
        console.error("Error fetching Calls", error);
        res.status(500).json({message : "Database error", error});
    }
};