# Day 3 — Security, Cost Optimization & Exam Review (Detailed Notes)

## Security (KMS, CloudTrail, Config, WAF)
- **KMS**: Key management for encryption, CMKs, key policies, grants. Use envelope encryption for large objects.
- **CloudTrail**: Records API activity; centralize logs in a secure S3 bucket and enable log file validation.
- **AWS Config**: Continuous configuration assessment; use managed rules for compliance.
- **WAF & Shield**: Protect web apps from common exploits (OWASP, DDoS mitigation).

## Identity & Access Review
- **IAM Best Practices**: Roles for EC2/Lambda, separate admin accounts, MFA, rotate keys, use service control policies (SCP) in Organizations for boundary controls.

## Cost Management
- **Tools**: AWS Cost Explorer, Budgets, Trusted Advisor.
- **Strategies**:
  - Use Savings Plans / Reserved Instances for steady-state workloads.
  - Rightsize instances based on CloudWatch metrics.
  - Use spot instances for fault-tolerant or non-critical workloads.
  - Archive infrequently accessed data to Glacier/Deep Archive.

## Well-Architected Framework (summary)
- Operational Excellence — run and monitor systems to deliver business value.
- Security — protect information and systems.
- Reliability — recover from failures and meet customer demand.
- Performance Efficiency — use IT and computing resources efficiently.
- Cost Optimization — avoid unnecessary costs.

## Exam Tips & Strategy
- Read questions fully — SAA exams often include multiple constraints.
- Look for keywords: cost-sensitive, high-availability, minimal operational overhead.
- Be cautious with "most secure" vs "most cost-effective".
- Time management: flag and return to tricky scenarios.

