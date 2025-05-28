const Lead = require('../models/leadModel');


exports.addLead = async (req, res) => {
    const {person_id, name, number, email, owner, branch, source, priority, status, next_meeting, refrence, description, address, loan_type} = req.body;

    if(!name || !number){
        return res.status(400).json({message : 'name and number are required'});
    }

    try{
        const newLead = await Lead.create({
            person_id, 
            name,
            number,
            email, 
            owner, 
            branch,
            source, 
            priority,
            status,
            next_meeting,
            refrence, 
            description,
            address,
            loan_type
        });
        res.status(200).json({message : "lead added successfully", id : newLead.lead_id});
    }catch(error){
        console.error("Error adding lead : ",error);
        res.status(500).json({message: "database error", error});
    }
};

exports.updateLead = async (req, res) => {
    const { id } = req.params;
    const updateData = req.body;  // Accept any fields from the request body

    if (!id) {
        return res.status(400).json({ message: 'Lead ID is required' });
    }

    try {
        const [updated] = await Lead.update(updateData, {
            where: { lead_id: id }
        });

        if (updated === 0) {
            return res.status(404).json({ message: 'Lead not found or no changes made' });
        }

        res.status(200).json({ message: 'Lead updated successfully' });
    } catch (error) {
        console.error('Error updating lead:', error);
        res.status(500).json({ message: 'Database error', error });
    }
};



exports.getLeads = async (req, res)=>{
    try{
         const lead = await Lead.findAll();
          res.status(200).json(lead);
    }catch(error){
        console.error('Error fetching leads:', error);
        res.status(500).json({ message: 'Database error', error });
    } 
};