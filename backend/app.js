require("dotenv").config();

const express = require("express");
const cors = require("cors");

const bodyParser = require("body-parser");
const leadRoutes = require("./routes/leadRoutes");
const employeeRoutes = require("./routes/employeesRoutes");
const historyRoutes = require("./routes/historyRoutes");
// const { initDatabase } = require("./config/db");
// initDatabase(() => {
//   require("./migrations/createTableEmployee");
//   require("./migrations/createTableLeads");
// });

const app = express();
app.use(cors());

const port = 5000 || process.env.PORT;

app.use(cors());
app.use(bodyParser.json());
app.use("/api", leadRoutes);
app.use("/api", employeeRoutes);
app.use("/api", historyRoutes);

app.get("/", (req, res) => {
  res.json("testing hello from backned");
});

app.listen(port, () => {
  console.log(`server started at :${port}`);
});
