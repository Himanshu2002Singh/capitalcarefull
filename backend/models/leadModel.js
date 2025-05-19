const {db} = require('../config/db');

const createLead = (person_id, name, number, owner, branch, source, priority, status, next_meeting, refrence, description, callback)=> {
    const sql = 'INSERT INTO leads (person_id, name, number, owner, branch, source, priority, status, next_meeting, refrence, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
    db.query(sql, [person_id, name, number, owner, branch, source, priority, status, next_meeting, refrence, description], callback);
};

const updateLead = (
    id, status, priority, next_meeting, est_budget, remark, callback 
)=> {
const sql = `UPDATE leads SET
status = ?, priority = ?, next_meeting = ?, est_budget = ?, remark = ?
where id = ?
`;

    db.query(sql, [status, priority, next_meeting, est_budget, remark, id], callback);
};


const getAllLeads = (callback) => {
    const sql = 'SELECT * FROM leads join employees on leads.person_id = employees.id';
    db.query(sql, callback);
};

module.exports = {createLead, getAllLeads, updateLead};