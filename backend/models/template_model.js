const { DataTypes } = require('sequelize');
const sequelize = require("../config/database");

const Template = sequelize.define('Template', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  fileType: {
    type: DataTypes.STRING
  },
  fileUrl: {
    type: DataTypes.STRING,
    allowNull: false,
  },
}, {
  tableName: 'templates',
});

module.exports = Template;
