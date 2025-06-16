const Lead = require('../models/leadModel');
const { Op } = require('sequelize'); // Import Op for date queries


exports.addLead = async (req, res) => {
  const { name, number } = req.body;

  if (!name || !number) {
    return res.status(400).json({ message: 'Name and number are required' });
  }

  try {
    const newLead = await Lead.create(req.body); 
    res.status(200).json({
      message: "Lead added successfully",
      id: newLead.lead_id,
    });
  } catch (error) {
    console.error("Error adding lead:", error);
    res.status(500).json({ message: "Database error", error });
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

exports.getLeadsById = async (req, res)=>{
    const {emp_id} = req.params;
    try{
         const lead = await Lead.findAll({
            where: {person_id : emp_id},
            order: [['createdAt', 'DESC']],
         });
          res.status(200).json(lead);
    }catch(error){
        console.error('Error fetching leads:', error);
        res.status(500).json({ message: 'Database error', error : error });
    } 
};

exports.deleteLead = async (req, res)=> {
    const{id} = req.params;
    try{
        const deleted = Lead.destroy({where:{lead_id : id}});
        if (deleted) {
      res.status(200).json({ message: 'Lead deleted successfully' });
    } else {
      res.status(404).json({ message: 'Lead not found' });
    }
    }catch(error){
        console.error('Error deleting lead:', err);
    res.status(500).json({ message: 'Server error' });
    }
};

exports.getLeadDetails = async (req, res) => {
    const { id } = req.params;
    try {
        const lead = await Lead.findByPk(id); // find by primary key

        if (!lead) {
            return res.status(404).json({ message: "Lead not found" });
        }

        return res.status(200).json(lead);
    } catch (error) {
        console.error("Error fetching lead details:", error);
        return res.status(500).json({ message: "Server error" });
    }
};

exports.searchByName = async (req, res)=>{
  const search = req.query.search || "";

  const leads = await Lead.find({
    name: { $regex: search, $options: "i" }, 
  });

  res.json(leads);
};

exports.leadsByDate = async (req, res) => {
  const { startDate, endDate } = req.query;

  if (!startDate || !endDate) {
    return res.status(400).json({ message: 'Start date and end date are required' });
  }

  try {
    const leads = await Lead.findAll({
      where: {
        createdAt: {
          [Op.between]: [new Date(startDate), new Date(endDate)]
        }
      },
      order: [['createdAt', 'DESC']]
    });

    res.status(200).json(leads);
  } catch (error) {
    console.error('Error fetching leads by date:', error);
    res.status(500).json({ message: 'Database error', error });
  }
} 