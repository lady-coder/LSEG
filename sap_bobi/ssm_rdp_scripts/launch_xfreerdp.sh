# This script is to be run after you have run the ssm_rdp.sh script, which will create an AWS SSM session tunnel.
# You will need to assume one of the ssm-adfs roles listed below. 
# Iam role variables
devRole="lch-sno-poc-ssm-adfs-role"
preProdRole="lch-cncd-preprod-ssm-adfs-role"
preProdDrRole="lch-cncddr-preprod-ssm-adfs-role"
prodRole="lch-cncd-prod-ssm-adfs-role"
prodDrRole="lch-cncddr-prod-ssm-adfs-role"
secretArn=""
region="eu-west-2"
pw=""

# Get assumed Iam role
currentRole=$(aws sts get-caller-identity --query Arn --output text)

# Cut the role arn down to just the role name
roleName=$(echo $currentRole | awk -F/ '{print $2}')

# Check which Iam role is assumed and set the correct variables for that account.
if [ "$roleName" = "$devRole" ]; then
    secretArn="arn:aws:secretsmanager:eu-west-2:522557265874:secret:LCH/SNO/POC/BOXI/RDP_USER-IrfYZl"
elif
    [ "$roleName" = "$preProdRole" ]; then
    secretArn="arn:aws:secretsmanager:eu-west-2:976554621689:secret:LCH/CNCD/PREPROD/BOXI/RDP_USER-esWgfC"
elif
    [ "$roleName" = "$preProdDrRole" ]; then
    secretArn="arn:aws:secretsmanager:eu-west-1:145549263674:secret:LCH/CNCDDR/PREPROD/BOXI/RDP_USER-4scM3K"
    region="eu-west-1"
elif
    [ "$roleName" = "$prodRole" ]; then
    secretArn="arn:aws:secretsmanager:eu-west-2:776597937122:secret:LCH/CNCD/PROD/BOXI/RDP_USER-QKoGAu"
elif
    [ "$roleName" = "$prodDrRole" ]; then
    secretArn="arn:aws:secretsmanager:eu-west-1:503861199941:secret:LCH/CNCDDR/PROD/BOXI/RDP_USER-ms6fDM"
    region="eu-west-1"
else
    echo "Please assume the correct IAM role"
    exit 1
fi
read -p "Please enter a port number: " port_number
# Pull the boxi_rdp_user password from secrets manager and assign to the $pw variable.
pw=$(aws secretsmanager get-secret-value --region $region --secret-id $secretArn | jq -r '.SecretString | fromjson | .boxi_rdp_user')

# Get the current user Id
userId=$(whoami)

# Cut the user id down to just the user name
userName=$(echo $userId | awk -F\\ '{print $NF}')

# Launch the xfreerdp app and pass the username and password.
xfreerdp /size:1280x960 /u:$userName /p:$pw /v:localhost /port:$port_number /cert:ignore