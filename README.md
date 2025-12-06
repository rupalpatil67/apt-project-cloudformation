# Apt DevOps Assignment — One-Click CloudFormation (ALB -> ASG -> Private EC2)

This repository contains a full CloudFormation-based solution to deploy a Node.js HTTP server running on private EC2 instances behind an Application Load Balancer and Auto Scaling Group.

## Repo layout
```
cloudformation/
  template.yaml       # CloudFormation template (create VPC, ALB, ASG, LT, IAM, etc)
app/
  index.js            # Node.js sample app (also embedded in LaunchTemplate user-data)
scripts/
  deploy.sh           # Deploys the CloudFormation stack using AWS CLI
  destroy.sh          # Deletes the CloudFormation stack
  test.sh             # Tests the ALB endpoints
.github/workflows/
  deploy.yml          # GitHub Actions workflow to deploy on push (optional)
screenshots/
  alb.png
  target-group.png
  api-test.png
  private-ec2.png
README.md
```

## Prerequisites
- AWS CLI configured with credentials and a region:
  - `aws configure`
- Permissions: ability to create IAM roles, VPCs, EC2, ALB, ASG, EIP, NAT, CloudFormation, etc.
- Optional: `jq`, `curl` locally for convenience.

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
- `curl http://<ALB_DNS>/` should return `Hello from private EC2 (index)` (200)
- `curl http://<ALB_DNS>/health` should return `ok` (200)

## Accessing private EC2 instances
- Instances are launched in private subnets (no public IP).
- Use AWS Systems Manager Session Manager:
```bash
aws ssm start-session --target <INSTANCE_ID>
```
Instances have the `AmazonSSMManagedInstanceCore` policy attached via instance role.

## Teardown
```bash
./scripts/destroy.sh
```

## GitHub Actions
The workflow `/.github/workflows/deploy.yml` will deploy the CloudFormation stack on pushes to `main`. It expects secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION` (optional)

You can also use OIDC or more secure methods — update workflow as needed.

## Screenshots
Place the required screenshots in the `screenshots/` folder named:
- `alb.png`
- `target-group.png`
- `api-test.png`
- `private-ec2.png`

If you cannot capture them, create placeholder images (already included).

## Notes and caveats
- The template uses latest Amazon Linux 2 AMI via SSM parameter.
- Instances run a small Node server installed via user-data — no external artifact repository required.
- ALB health check uses `/health`.
- Instances do not have public IPs; ALB is public-facing.
- Costs: ensure you destroy the stack when done to avoid charges.