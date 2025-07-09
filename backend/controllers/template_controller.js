const { uploadFileToS3 } = require('../services/s3_services');
const Template = require('../models/template_model');

exports.createTemplate = async (req, res) => {
  try {
    const { name, description, fileType } = req.body;
    let fileUrl = null;  // change const → let

    // If fileType is not 'none', then file must be uploaded
    if (fileType !== "none") {
      if (!req.file) {
        return res.status(400).json({ error: 'No file uploaded' });
      }
      fileUrl = await uploadFileToS3(req.file);  // upload and get URL
    }

    const newTemplate = await Template.create({
      name,
      description,
      fileType,
      fileUrl,
    });

    return res.status(200).json({
      success: true,
      message: 'Template created successfully',
      data: newTemplate,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
};


exports.getAllTemplates = async (req, res) => {
  try {
    const templates = await Template.findAll();
    res.status(200).json({ success: true, data: templates });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
};
