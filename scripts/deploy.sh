#!/bin/bash
set -euo pipefail
STACK_NAME=oneclick-cfn-stack
TEMPLATE_FILE=cloudformation/template.yaml
REGION=${AWS_REGION:-us-east-1}

echo "Deploying CloudFormation stack: $STACK_NAME to region $REGION"
aws cloudformation deploy \
  --stack-name $STACK_NAME \
  --template-file $TEMPLATE_FILE \
  --capabilities CAPABILITY_NAMED_IAM \
  --region $REGION
echo "Waiting for stack completion..."
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $REGION
echo "Stack deployed."
ALB_DNS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query "Stacks[0].Outputs[?OutputKey=='ALBDNSName'].OutputValue" --output text)
echo "ALB DNS: $ALB_DNS"
echo "You can test: curl http://$ALB_DNS/"