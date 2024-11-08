# This script configures proxy settings for your Jupyter notebooks and the SageMaker notebook instance.
# This is useful for use cases where you would like to configure your notebook instance in your custom VPC
# without direct internet access to route all traffic via a proxy server in your VPC.

# Please ensure that you have already configure a proxy server in your VPC.

#!/bin/bash
 
set -e

su - ec2-user -c "mkdir -p /home/ec2-user/.ipython/profile_default/startup/ && touch /home/ec2-user/.ipython/profile_default/startup/00-startup.py"

# Please replace proxy.local:3128 with the URL of your proxy server eg, proxy.example.com:80 or proxy.example.com:443
# Please note that we are excluding S3 because we do not want this traffic to be routed over the public internet, but rather through the S3 endpoint in the VPC.

#PARAMETER
SERVER=http://proxy_vpc-01f1deb2b87ccd94a:3128

echo "export http_proxy='$SERVER'" | tee -a /home/ec2-user/.profile >/dev/null
echo "export https_proxy='$SERVER'" | tee -a /home/ec2-user/.profile >/dev/null
echo "export no_proxy='.r53,.local,.stockex.local,.privatelink.snowflakecomputing.com,169.254,172.16,100.64,10.192.0.0,192.168,10.,nexus.lseg.stockex.local,monitoring.eu-west-2.amazonaws.com,kms.eu-west-2.amazonaws.com,s3.eu-west-2.amazonaws.com,logs.eu-west-2.amazonaws.com,ec2messages.eu-west-2.amazonaws.com,ec2.eu-west-2.amazonaws.com,ssmmessages.eu-west-2.amazonaws.com,ssm.eu-west-2.amazonaws.com,sts.lseg.com,.dx1.lseg.com,.dx1.dev.lseg.com,.dx1.qa.lseg.com'" | tee -a /home/ec2-user/.profile >/dev/null

# Now we change the terminal shell to bash
echo "c.NotebookApp.terminado_settings={'shell_command': ['/bin/bash']}" | tee -a /home/ec2-user/.jupyter/jupyter_notebook_config.py >/dev/null

echo "import sys,os,os.path" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['HTTP_PROXY']="\""$SERVER"\""" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['HTTPS_PROXY']="\""$SERVER"\""" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null
echo "os.environ['NO_PROXY']="\"".r53,.local,.stockex.local,.privatelink.snowflakecomputing.com,169.254,172.16,100.64,10.192.0.0,192.168,10.,nexus.lseg.stockex.local,monitoring.eu-west-2.amazonaws.com,kms.eu-west-2.amazonaws.com,s3.eu-west-2.amazonaws.com,logs.eu-west-2.amazonaws.com,ec2messages.eu-west-2.amazonaws.com,ec2.eu-west-2.amazonaws.com,ssmmessages.eu-west-2.amazonaws.com,ssm.eu-west-2.amazonaws.com,sts.lseg.com,.dx1.lseg.com,.dx1.dev.lseg.com,.dx1.qa.lseg.com"\""" | tee -a /home/ec2-user/.ipython/profile_default/startup/00-startup.py >/dev/null

# Next, we reboot the system so the bash shell setting can take effect. This reboot is only required when applying proxy settings to the shell environment as well.
# If only setting up Jupyter notebook proxy, you can leave this out

#reboot