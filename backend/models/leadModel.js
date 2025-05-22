// models/lead.js
const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const Lead = sequelize.define(
  "Lead",
  {
    person_id: {
      type: DataTypes.STRING,
      primaryKey: true,
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    number: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    owner: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    branch: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    source: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    priority: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    next_meeting: {
      type: DataTypes.DATE,
      allowNull: true,
    },
    refrence: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
  },
  {
    tableName: "leads",
    timestamps: false,
  }
);

// Create table if not exists
Lead.sync({ alter: false })
  .then(() => {
    console.log("Lead table created");
  })
  .catch((error) => {
    console.error("Error creating Lead table:", error);
  });

module.exports = Lead;
