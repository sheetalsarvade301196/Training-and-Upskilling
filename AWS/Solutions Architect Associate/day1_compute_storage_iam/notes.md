# Day 1 — Compute, Storage & IAM (Detailed Notes)

## Overview
This day focuses on core compute and storage services and AWS IAM which are foundational for SAA-C03.

---

## IAM (Identity and Access Management)
- **Concepts**: Users, Groups, Roles, Policies, Identity providers, Federation.
- **Roles vs Users**: Roles are assumed by entities (EC2, Lambda, IAM principals); Users represent long-term human credentials.
- **Policies**: JSON documents (Allow/Deny). Use the principle of *least privilege*.
- **Managed Policies**: AWS-managed vs Customer-managed.
- **Policy Elements**: Version, Statement (Effect, Action, Resource, Condition).
- **Best Practices**:
  - Use roles for services and avoid long-lived credentials.
  - Enable MFA for privileged users.
  - Use permission boundaries or SCPs in Organizations for guardrails.

### Example: Inline policy snippet (allow S3 read)
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect":"Allow",
    "Action":["s3:GetObject","s3:ListBucket"],
    "Resource":["arn:aws:s3:::example-bucket","arn:aws:s3:::example-bucket/*"]
  }]
}
```

---

## EC2 (Elastic Compute Cloud)
- **Instance types**: General purpose (t3, m5), compute optimized (c5), memory optimized (r5), storage optimized (i3), GPU (p3).
- **Buying options**: On-Demand, Reserved Instances, Savings Plans, Spot Instances. Choose based on predictability and cost.
- **Networking**: ENI, Security Groups (stateful), NACLs (stateless).
- **Storage options**: EBS (block storage), Instance store (ephemeral), EFS (NFS), S3 (object).
- **High availability**: Use across multiple Availability Zones with Auto Scaling + ELB (ALB/NLB).

### EC2 example CLI
```bash
# Launch an EC2 instance (simplified)
aws ec2 run-instances --image-id ami-0abcdef1234567890 --count 1 --instance-type t3.micro --key-name MyKeyPair --subnet-id subnet-0abc1234
```

---

## Elastic Block Store (EBS)
- **Types**: gp3 (general purpose SSD), io2 (provisioned IOPS SSD), st1/sc1 (throughput-optimized / cold HDD).
- **Features**: Snapshots (stored in S3 internally), encryption at rest (KMS), resizing/volume modification.
- **Best Practices**:
  - Use gp3 for mixed workloads; provision io2 for high IOPS DB workloads.
  - Take regular snapshots and automate backup lifecycles.

### EBS CLI snippets
```bash
# Create a snapshot of a volume
aws ec2 create-snapshot --volume-id vol-0123456789abcdef0 --description "pre-maintenance snapshot"
```

---

## EFS (Elastic File System)
- Managed NFSv4 file system across AZs. Good for shared file storage between EC2 instances.
- Two performance modes: General Purpose and Max I/O.
- Lifecycle management to move cold files to Infrequent Access.

---

## S3 (Simple Storage Service)
- Object storage with 11 9's durability (designed).
- Features: Versioning, Lifecycle policies, Storage classes (Standard, Intelligent-Tiering, IA, Glacier, Deep Archive), Server-side encryption (SSE-S3, SSE-KMS), Client-side encryption.
- Security: Bucket policies, ACLs (avoid), Block Public Access, VPC endpoints for private S3 access.
- Best Practices:
  - Enable bucket versioning and MFA-delete for critical buckets.
  - Use lifecycle to transition older objects to Glacier/Deep Archive.
  - Use S3 Access Points for large-scale multi-tenant datasets.

### S3 CLI examples
```bash
aws s3 cp myfile.txt s3://my-bucket/myfile.txt
aws s3 ls s3://my-bucket --recursive --human-readable --summarize
```

---

## Quick quiz notes (key points)
- When to use EBS vs EFS vs S3?
- Which EC2 instance family is best for CPU-bound workloads?
- What element in an IAM policy controls "when" or "from where" (Condition)?
