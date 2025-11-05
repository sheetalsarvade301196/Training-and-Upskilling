# Day 2 — Networking, Databases & Serverless (Detailed Notes)

## VPC (Virtual Private Cloud)
- **Components**: Subnets (public/private), Route Tables, Internet Gateway (IGW), NAT Gateway, Elastic IPs, Security Groups (stateful), NACLs (stateless).
- **Design**: Public subnets for load balancers and NAT gateways; private subnets for application servers and databases.
- **VPC Peering / Transit Gateway**: For connecting VPCs. Transit Gateway scales better for many-to-many connections.
- **Endpoints**: Interface endpoints (ENI) and Gateway endpoints (S3, DynamoDB) for private connectivity.

### CIDR planning example
- VPC: 10.0.0.0/16 (65536 IPs)
- Subnet A: 10.0.1.0/24 (256 IPs)

## Route 53
- DNS service: public and private hosted zones.
- Health checks and failover routing, latency-based routing, weighted routing.
- Use alias records for AWS resources (ALB, CloudFront, S3 websites).

## Load Balancing & Network
- **ALB**: Layer 7, content-based routing, supports HTTP/HTTPS, WebSockets.
- **NLB**: Layer 4, static IPs, high performance for TCP/UDP.
- **Target groups**: Register EC2, IP, Lambda.

## Databases: RDS & DynamoDB
### RDS
- Engines: MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, Aurora.
- Multi-AZ for high availability; Read Replicas for scaling reads.
- Storage types: GP3, IO1/IO2; consider IOPS needs.
- Backups: Automated snapshots and manual snapshots.

### DynamoDB
- NoSQL key-value store, single-digit millisecond latency.
- Provisioned vs on-demand capacity; DAX for caching.
- Global Tables for multi-region replication.

## Serverless: Lambda, API Gateway, SQS, SNS
- **Lambda**: Stateless functions, cold starts, concurrency limits, environment variables, layers.
- **API Gateway**: REST + WebSocket endpoints; authorization (Cognito, IAM), usage plans.
- **SQS/SNS**: Decoupling patterns: SQS for reliable queue, SNS for pub/sub.
- **Event-driven patterns**: S3 -> Lambda, DynamoDB Streams -> Lambda.

## Observability (brief)
- CloudWatch Logs, Metrics, Alarms.
- X-Ray for tracing distributed systems.

