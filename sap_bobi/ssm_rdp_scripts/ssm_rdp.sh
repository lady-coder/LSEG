#!/bin/bash
# Set variables
instanceId=""
s3Bucket=""
secretId=""
region="eu-west-2"

# Iam role variables
devRole="lch-sno-poc-ssm-adfs-role"
preProdRole="lch-cncd-preprod-ssm-adfs-role"
preProdDrRole="lch-cncddr-preprod-ssm-adfs-role"
prodRole="lch-cncd-prod-ssm-adfs-role"
prodDrRole="lch-cncddr-prod-ssm-adfs-role"

# Get assumed Iam role
currentRole=$(aws sts get-caller-identity --query Arn --output text)

# Cut the role arn down to just the role name
roleName=$(echo $currentRole | awk -F/ '{print $2}')

# Get the current user Id
userId=$(whoami)

# Cut the user id down to just the user name
userName=$(echo $userId | awk -F\\ '{print $NF}')

# Check which Iam role is assumed and set the correct variables for that account.
if [ "$roleName" = "$devRole" ]; then
    s3Bucket="lch-sno-poc-s3-boxi-install"
    secretId="LCH/SNO/POC/BOXI/RDP_USER"
elif
    [ "$roleName" = "$preProdRole" ]; then
    s3Bucket="lch-cncd-preprod-s3-boxi-install"
    secretId="LCH/CNCD/PREPROD/BOXI/RDP_USER"
elif
    [ "$roleName" = "$preProdDrRole" ]; then
    s3Bucket="lch-cncddr-preprod-s3-boxi-install"
    secretId="LCH/CNCDDR/PREPROD/BOXI/RDP_USER"
    region="eu-west-1"
elif
    [ "$roleName" = "$prodRole" ]; then
    s3Bucket="lch-cncd-prod-s3-boxi-install"
    secretId="LCH/CNCD/PROD/BOXI/RDP_USER"
elif
    [ "$roleName" = "$prodDrRole" ]; then
    s3Bucket="lch-cncddr-prod-s3-boxi-install"
    secretId="LCH/CNCDDR/PROD/BOXI/RDP_USER"
    region="eu-west-1"
else
    echo "Please assume the correct IAM role"
    exit 1
fi

# List all instances with the Boxi name tag
listAllInstances=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=LCH-*-*-BOXI*" --query 'Reservations[*].Instances[*].Tags[?Key==`Name`].Value[]' --output text --region $region)

# Create an array from the list of instance name tags.
mapfile -t instance_array < <(echo "$listAllInstances" | sort)
PS3='Please enter your choice: '

# Use select to create a menu of instance Name tags
select instance in "${instance_array[@]}"; do
    if [[ -n $instance ]]; then
        selectedInstance=$instance
        break
    else
        echo "Invalid option."
    fi
done

echo "You selected: $selectedInstance"
# Enter a port number
read -p "Please enter a port number: " port_number

# Find the selected ec2 instance id from the name tag
instanceId=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$selectedInstance" --query "Reservations[*].Instances[*].InstanceId" --output text --region $region)

# Run the aws ssm command that will download the Powershell script from S3 and runt it \
# on the remote instance. 
echo ""
echo "Please wait, while I run the ssm command to create or update the user account!"
commandId=$(aws ssm send-command \
--document-name "AWS-RunPowerShellScript" \
--parameters '{"commands":["$secretValue = (Get-SECSecretValue -SecretId '$secretId').SecretString | ConvertFrom-Json", "$secret = $secretValue.boxi_rdp_user", "aws s3 cp s3://'$s3Bucket'/create_rdp_user.ps1 c:\\temp","c:\\temp\\create_rdp_user.ps1 '$userName' $secret","Remove-Item c:\\temp\\create_rdp_user.ps1"]}' \
--targets "Key=instanceids,Values='$instanceId'" \
--timeout-seconds 300 --output text --region $region --query 'Command.CommandId')

# Exit if the ssm command fails.
if [ $? -ne 0 ]; then
    echo "The ssm command failed to execute! Please check your inputs."
    exit 1
fi

# Fetch the ssm command status result.
commandResult=$(aws ssm get-command-invocation --command-id $commandId --instance-id $instanceId --output text --region $region --query 'StatusDetails')

# Loop until the command completes and check the status.
while [ "$commandResult" == "Pending" ] || [ "$commandResult" == "InProgress" ]; do
  echo "Waiting for command to complete..."
  sleep 10 # Wait for 10 seconds
  commandResult=$(aws ssm get-command-invocation --command-id $commandId --instance-id $instanceId --output text --region $region --query 'StatusDetails')
done
# Exit if the command does not return a success result.
if [ "$commandResult" != "Success" ]; then
  echo "The command failed or timed out! Check Systems Manager Run command in the AWS console for details"
  echo "The ssm command id is: $commandId"
  exit 1
fi
# If the command returned a success result, print a success message and the useful details.
echo "The command was successfully sent to the remote instance."
echo ""
echo "The user name is: $userName"
echo "The instance id is: $instanceId"
echo "The instance name is: $selectedInstance"
echo "The ssm command id is: $commandId"
echo "Creating a Port Forwarding session. This can take several minutes to complete!"

# Start a port forwarding session.
aws ssm start-session \
--target $instanceId \
--document-name AWS-StartPortForwardingSession \
--parameters  '{"portNumber":["3389"],"localPortNumber":["'"$port_number"'"]}' \
--region $region