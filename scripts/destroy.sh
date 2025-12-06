#!/bin/bash
set -euo pipefail
STACK_NAME=oneclick-cfn-stack
REGION=${AWS_REGION:-us-east-1}

echo "Deleting CloudFormation stack: $STACK_NAME from region $REGION"
aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION
echo "Waiting for stack deletion..."
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME --region $REGION || true
echo "Stack deleted (or deletion initiated)."