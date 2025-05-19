const {db} = require('../config/db');

createTableEmployee = `create table if not exists employees(
id int auto_increment primary key,
emp_id varchar(50),
email varchar(100),
username varchar(100),
ename varchar(100),
password varchar(100)
)`;

db.query(createTableEmployee , err =>{
    if (err) throw err;

    console.log('employee table created');
});