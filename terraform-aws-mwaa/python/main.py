import logging
import boto3
from botocore.exceptions import ClientError
import os

from validator import Validate


def upload_file(file_path, bucket, object_name=None):
    """Upload a file to an S3 bucket

    :param file_name: File to upload
    :param bucket: Bucket to upload to
    :param object_name: S3 object name. If not specified then file_name is used
    :return: True if file was uploaded, else False
    """
    # Upload the file
    s3_client = boto3.client('s3')
    try:
        for root,dirs,files in os.walk(file_path):
            for filename in files:
                local_path = os.path.join(root, filename)
                print('Uploading file ',filename)
                response = s3_client.upload_file(local_path, bucket, "dags/"+filename)
    except ClientError as e:
        logging.error(e)
        return False
    return True

if __name__ == '__main__':
    config_validator = Validate()
    args = config_validator.validate_args()
    print("INFO: App Started, Arguments validated.")
    up_file = upload_file(args.directory,args.bucket)
