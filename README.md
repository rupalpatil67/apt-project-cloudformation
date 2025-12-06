# Apt DevOps Assignment — One-Click CloudFormation (ALB -> ASG -> Private EC2)

This repository contains a full CloudFormation-based solution to deploy a Node.js HTTP server running on private EC2 instances behind an Application Load Balancer and Auto Scaling Group.

## Repo layout
```
cloudformation/
  template.yaml       # CloudFormation template
app/
  index.js            # Node.js sample app 
scripts/
  deploy.sh           # Deploys the CloudFormation stack 
  destroy.sh          # Deletes the CloudFormation stack
  test.sh             # Tests the ALB endpoints
screenshots/
  alb.png
  target-group.png
  api-test.png
  private-ec2.png

README.md
```



## Deployment (local)
1. Unzip the repo and `cd` into it.
2. Make scripts executable:
```bash
chmod +x scripts/*.sh
```
3. Deploy:
```bash
./scripts/deploy.sh
```
4. The deploy script waits for stack creation and prints the ALB DNS name. You can also check CloudFormation console.

## Testing
After deployment:
```bash
./scripts/test.sh
```
Expected output:
- `curl http://<ALB_DNS>/` should return `Hello from Node.js app` (200)
- `curl http://<ALB_DNS>/health` should return `ok` (200)


## Destroy Cloudformation Stack 
```bash
./scripts/destroy.sh
```
