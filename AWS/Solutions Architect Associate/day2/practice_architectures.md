# Practice Architectures — Day 2

## 3-tier web application (classic)
```
User -> ALB (public) -> App EC2 (private subnets, ASG) -> RDS (private subnet, Multi-AZ)
                 \-> EFS for shared storage
                 \-> CloudFront (optional) for caching
```

## Serverless API
```
Client -> CloudFront -> API Gateway -> Lambda -> DynamoDB
                         \-> WAF for protection
```

## VPC with Private S3 Access
```
App instances (private) -> VPC Endpoint (gateway) -> S3 (data lake) 
(no internet egress required)
```
