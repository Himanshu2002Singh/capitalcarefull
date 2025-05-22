const Lead = require('../models/leadModel');

exports.addLead = (req, res) => {
    const {person_id, name, number, owner, branch, source, level, status, next_meeting, refrence, description} = req.body;

    if(!name || !number){
        return res.status(400).json({message : 'name and number are required'});
    }

    Lead.createLead(person_id, name, number, owner, branch, source, level, status, next_meeting, refrence, description, (err, result) => {
        if(err) return res.status(500).json({message : 'Database error', error : err});

        res.status(200).json({message : 'Lead Added Successfully', id : result.insertId});
    });
};

exports.updateLead = (req, res) => {
    const {id} = req.params;
    const {status, priority, next_meeting, est_budget, remark} = req.body;

    if(!id){
        return res.status(400).json({ message: 'Lead ID is required' });
    }

    Lead.updateLead(id, status, priority, next_meeting, est_budget, remark, (err, result) => {
        if(err) return res.status(500).json({message : 'database Error', error : err});

        res.status(200).json({message : "Lead update successfully"});
    });
};


exports.getLeads = async (req, res)=>{
    // Lead.getAllLeads((err, results)=> {
    //     if(err) return res.status(500).json({message : 'database error', error : err});

    //     res.status(200).json(results);
    // });
    const lead = await Lead.findAll();
    console.log("===============>lead ", lead)
    res.status(200).json(lead);
    
};