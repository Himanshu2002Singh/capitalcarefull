const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const leadRoutes = require('./routes/leadRoutes');
const employeeRoutes = require('./routes/employeesRoutes');
const { initDatabase } = require('./config/db');
initDatabase(()=> {
    require('./migrations/createTableEmployee');
    require('./migrations/createTableLeads');
})

const app = express();
const port = 5000;

app.use(cors());
app.use(bodyParser.json());
app.use('/api', leadRoutes);
app.use('/api', employeeRoutes);

app.listen(port, ()=> {
    console.log(`Server running on http://localhost:${port}`);
});