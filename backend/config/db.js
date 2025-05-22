require("dotenv").config();

const mysql = require("mysql2");
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DBUSER || "root",
  password: process.env.DBPASS || "",
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
  db.connect((err) => {
    if (err) throw err;
    console.log("Connected to MySQL");

    db.query("CREATE DATABASE IF NOT EXISTS capitalcaredb", (err) => {
      if (err) throw err;
      console.log("Database created or exists");

      db.changeUser({ database: process.env.DB_NAME }, (err) => {
        if (err) throw err;
        console.log("Connected to database capitalcaredb");

        callback(); // only run create tables after database selected
      });
    });
  });
}

module.exports = { db, initDatabase };
