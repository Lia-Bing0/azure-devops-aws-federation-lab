# Deployment Results

## Purpose

This document provides deployment evidence demonstrating that the Azure DevOps CI/CD pipeline successfully authenticated to AWS using OIDC federation, passed Checkov infrastructure security validation, and executed Terraform infrastructure provisioning.

## Deployment Summary

A successful pipeline run demonstrates the following:

- Azure DevOps authenticated to AWS using OIDC federation.
- AWS Security Token Service (STS) issued temporary credentials via `AssumeRoleWithWebIdentity`, eliminating the need for static AWS credentials.
- Checkov security validation passed after Terraform configuration remediation.
- Terraform successfully generated and applied the infrastructure execution plan.
- AWS resources were provisioned with secure baseline configurations.
- Deployment executed using short-lived federated credentials with no static secrets stored in the pipeline.

## Evidence Screenshots

Add the following screenshots after a successful secure run.

### 1. AWS Identity Verification via STS

- Placeholder path: `docs/images/01-aws-sts-identity-verification.png`
- Capture point: Azure DevOps pipeline log showing `aws sts get-caller-identity` output.
- Validation intent: Confirms Azure DevOps successfully assumed the AWS IAM role using OIDC federation.
  
### 2. AWS EC2 Instance Running

- Placeholder path: `docs/images/08-aws-ec2-instance-running.png`
- Capture point: After pipeline completion, from EC2 console showing instance state `running`.
- Validation intent: Confirms infrastructure creation succeeded.

### 3. AWS IAM Role Attached to EC2 Instance

- Placeholder path: `docs/images/07-aws-ec2-iam-role.png`
- Capture point: From EC2 instance details showing the attached IAM role/profile.
- Validation intent: Confirms role-based identity assignment to compute resource.

### 4. AWS Security Group Configuration

- Placeholder path: `docs/images/09-aws-security-group-restricted.png`
- Capture point: From EC2 security group inbound rules showing restricted access.
- Validation intent: Demonstrates remediated network exposure.

## Capture Guidance

- Capture screenshots in chronological order to tell a clear deployment story.
- Keep account IDs and sensitive details redacted where appropriate.
- Use consistent naming exactly as listed to match repository documentation references.
- Save final evidence images under `docs/images/`.
- Prefer pipeline log screenshots that clearly show the stage name and status.

## Related References

- Main project summary: `README.md`
- Troubleshooting and known fixes: `docs/troubleshooting.md`
- Federation flow documentation: `docs/federation-flow.md`
