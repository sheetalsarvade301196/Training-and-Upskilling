# Exam Review Notes — Day 3

## Common Exam Topics
- VPC design (public/private subnets, NAT, IGW) and connectivity patterns.
- High availability: Multi-AZ, RDS Multi-AZ vs Read Replica differences.
- Security: IAM role usage, KMS, CloudTrail, endpoint security (VPC endpoints).
- Cost: When to use Savings Plans / RI vs Spot Instances.

## Practice question approach
1. Identify the core requirement (e.g., "persist logs", "minimize latency").
2. Identify constraints (cost, operational overhead, compliance).
3. Eliminate choices that fail mandatory constraints.
4. Choose the best-fit service/approach.

## Short checklist before exam
- VPC basics & common CLI commands
- IAM principal differences and policy basics
- Differences: S3 vs EFS vs EBS; RDS vs DynamoDB
- Autoscaling & ELB behavior
