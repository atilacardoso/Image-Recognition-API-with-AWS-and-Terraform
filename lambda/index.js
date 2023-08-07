const AWS = require('aws-sdk');
const rekognition = new AWS.Rekognition();

exports.handler = async (event) => {
    const s3Bucket = event.Records[0].s3.bucket.name;
    const s3Key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    
    const params = {
        Image: {
            S3Object: {
                Bucket: s3Bucket,
                Name: s3Key
            }
        }
    };
    
    try {
        const response = await rekognition.detectLabels(params).promise();
        console.log('Detected labels:', response.Labels);
        
        // Your additional logic here
    } catch (error) {
        console.error('Error detecting labels:', error);
    }
};
