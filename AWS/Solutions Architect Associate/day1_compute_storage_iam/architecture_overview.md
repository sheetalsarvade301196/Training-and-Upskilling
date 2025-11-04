# Architecture Overview — Compute + Storage (Text diagrams)

Simple 3-tier (web-app + app + DB) across AZs:
```
Internet -> ALB -> AutoScalingGroup (EC2) -> EBS (App Storage)
                         \-> EFS (Shared)
                         \-> RDS (Multi-AZ) -> EBS (DB storage)
```

S3-based static hosting + CloudFront:
```
User -> CloudFront Edge -> S3 Bucket (website) [Origin Access Identity]
```
