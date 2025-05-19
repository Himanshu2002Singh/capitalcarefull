const {db} = require('../config/db');

const createEmployee = (emp_id, email, username, ename, password, callback)=> {
    const sql = 'insert into employees (emp_id, email, username, ename, password) values(?, ?, ?, ?, ?)';
    db.query(sql, [emp_id, email, username, ename, password], callback);
};

const getAllEmployees = (callback)=>{
    const sql = 'select * from employees';
    db.query(sql, callback);
}

module.exports = {createEmployee, getAllEmployees};