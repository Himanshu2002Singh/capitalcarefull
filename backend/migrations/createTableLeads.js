const { db } = require('../config/db');

const createTableLeads = `
  CREATE TABLE IF NOT EXISTS leads (
    id INT AUTO_INCREMENT PRIMARY KEY,
    person_id INT,
    name VARCHAR(100),
    number VARCHAR(20),
    owner VARCHAR(100),
    branch VARCHAR(20),
    source VARCHAR(20),
    level VARCHAR(100),
    status VARCHAR(50),
    next_meeting VARCHAR(100),
    refrence VARCHAR(100),
    description VARCHAR(200),
    est_budget INT,
    remark VARCHAR(255),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (person_id) REFERENCES employees(id) ON DELETE CASCADE
  );
`;

db.query(createTableLeads, (err) => {
  if (err) throw err;
  console.log("✅ Lead table created");
});
