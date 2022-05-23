#To ensure temporary credentials aren’t already in place we will also remove any existing credentials file:
rm -vf ${HOME}/.aws/credentials

#Install jq
sudo yum install jq -y

#We should configure our AWS CLI with our current region as default.
export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')

#Check if AWS_REGION is set to desired region
test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set

#Let’s save these into bash_profile
echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
aws configure set default.region ${AWS_REGION}
aws configure get default.region

#Validate the IAM role
aws sts get-caller-identity --query Arn | grep cdk-workshop-admin -q && echo "IAM role valid" || echo "IAM role NOT valid"

aws --version
aws configure get region

#Install pre-requisite packages for the CDK:
sudo yum -y update
sudo yum -y install npm
nvm install v16.10.0
nvm alias default 16.10.0
npm install -gf typescript@4.5.2
