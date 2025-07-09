const s3 = require('../config/aws_config');
const bucketName = process.env.AWS_BUCKET_NAME;

async function uploadFileToS3(file) {
  const params = {
    Bucket: bucketName,
    Key: `uploads/${Date.now()}-${file.originalname}`,
    Body: file.buffer,
    ContentType: file.mimetype,
    ACL: 'public-read',
  };

  const data = await s3.upload(params).promise();
  return data.Location; // Public URL
}

module.exports = { uploadFileToS3 };
