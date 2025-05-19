const mysql = require('mysql2');
const db = mysql.createConnection({
    host : 'localhost',
    user : 'root',
    password : ''
});
// db.connect(err => {
//     if(err) throw err;
//     console.log("connected to mysql");

//     db.query("CREATE DATABASE IF NOT EXISTS priyanshu", err => {
//         if(err) throw err;
//         console.log("database create or exists");
 
//         db.changeUser({database: "priyanshu"}, err => {
//             if(err) throw err;
//             console.log("connected to database priyanshu");
            
//             callback();

//         });
//     });
// });

// module.exports = db;

function initDatabase(callback) {
  db.connect(err => {
    if (err) throw err;
    console.log("Connected to MySQL");

    db.query("CREATE DATABASE IF NOT EXISTS priyanshu", err => {
      if (err) throw err;
      console.log("Database created or exists");

      db.changeUser({ database: "priyanshu" }, err => {
        if (err) throw err;
        console.log("Connected to database priyanshu");

        callback(); // only run create tables after database selected
      });
    });
  });
}

module.exports = { db, initDatabase };
