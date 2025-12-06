#!/bin/bash
set -euo pipefail
STACK_NAME=oneclick-cfn-stack
REGION=${AWS_REGION:-us-east-1}

ALB_DNS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query "Stacks[0].Outputs[?OutputKey=='ALBDNSName'].OutputValue" --output text)
echo "ALB DNS: $ALB_DNS"
if [ -z "$ALB_DNS" ]; then
  echo "ALB DNS not found. Is the stack deployed?"
  exit 1
fi
echo "Testing root path:"
curl -sS http://$ALB_DNS/ || true
echo
echo "Testing /health:"
curl -sS http://$ALB_DNS/health || true
echo