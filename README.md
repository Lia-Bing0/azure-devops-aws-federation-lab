# Azure DevOps to AWS Federation DevSecOps Lab

## Overview

This repository demonstrates a professional DevSecOps workflow where Azure DevOps deploys AWS infrastructure using OIDC federation and temporary AWS STS credentials, with Terraform automation and Checkov security validation built into CI/CD.

The pipeline intentionally includes a fail-then-fix validation path:

- Insecure Terraform configuration causes security scan failure.
- Checkov identifies policy violations before deployment.
- Terraform is remediated to meet security controls.
- Pipeline reruns and passes secure deployment gates.

## Architecture Overview

End-to-end flow:

1. Developer pushes changes to repository.
2. Azure DevOps pipeline starts and requests an OIDC token.
3. AWS IAM OIDC provider validates token issuer and trust policy.
4. AWS STS issues temporary credentials via `AssumeRoleWithWebIdentity`.
5. Terraform initializes and plans infrastructure changes.
6. Checkov scans Terraform for security misconfigurations.
7. Deployment proceeds only when security validation passes.

Deployed AWS resources include:

- EC2 instance
- Security group
- Launch template and Auto Scaling configuration
- IAM role association for compute identity

### Secure CI/CD Identity Federation Flow

Developer
   │
   │  git push
   ▼
Azure DevOps Pipeline
   │
   │ Generate OIDC Token
   ▼
Azure DevOps OIDC Provider
   │
   │ Present identity token
   ▼
AWS IAM OIDC Identity Provider
   │
   │ Validate trust policy
   ▼
AWS Security Token Service (STS)
   │
   │ AssumeRoleWithWebIdentity
   │ Issue temporary credentials
   ▼
Terraform Execution
   │
   │ Run Checkov Security Scan
   │
   ▼
AWS Infrastructure Deployment
   ├─ EC2 Instance
   ├─ Security Group
   └─ Auto Scaling Group

Azure DevOps authenticates to AWS using OpenID Connect (OIDC) federation.  
The pipeline generates an OIDC identity token that is validated by the AWS IAM OIDC identity provider.

AWS Security Token Service (STS) then issues temporary credentials using `AssumeRoleWithWebIdentity`.  
Terraform uses these short-lived credentials to provision infrastructure without storing long-lived AWS access keys in the CI/CD pipeline.

## Technology Stack

- Azure DevOps Pipelines
- AWS IAM and AWS STS
- AWS EC2 and Auto Scaling
- Terraform
- Checkov

## Security Concepts Demonstrated

- OIDC workload identity federation
- Short-lived cloud credentials (no static access keys in pipeline)
- IAM trust policy validation for federated principals
- Shift-left IaC security scanning
- DevSecOps fail-fast remediation workflow

## IAM Least-Privilege Debugging (Real Deployment Iteration)

During initial deployment, Terraform apply failed due to insufficient IAM permissions on the federated OIDC role.

Example failure:

- ec2:CreateSecurityGroup → UnauthorizedOperation  
- iam:CreateRole → AccessDenied  

Instead of granting broad permissions, the IAM policy was incrementally refined using least-privilege principles.

Additional permission gaps discovered during deployment:

- iam:ListRolePolicies (required for role inspection)
- ec2:MonitorInstances (required for EC2 monitoring configuration)

This iterative approach ensured that:

- Only required actions were granted
- Over-permissioning (e.g., AdministratorAccess) was avoided
- The pipeline remained secure while enabling successful deployment

Final result:
Terraform apply completed successfully with a minimal, explicitly defined IAM policy.

![Terraform Apply Permission Failure](docs/images/26-terraform-apply-permission-denied.png)

## DevSecOps Security Validation Workflow

This project validates security as a required deployment gate:

1. Introduce insecure Terraform (for example, SSH open to `0.0.0.0/0`, missing encryption, or weak metadata configuration).
2. Run pipeline and observe Checkov security failure.
3. Review findings and remediate Terraform configuration.
4. Rerun pipeline and confirm scan passes.
5. Confirm secure infrastructure deployment in AWS.

Primary remediation patterns used:

- Restrict security group ingress
- Enforce encrypted root volume
- Require IMDSv2
- Enable EC2 monitoring

## Pipeline Execution Evidence (CI/CD Security Gates)

- Checkov failure example: `docs/images/02-checkov-scan-failure.png`
- Successful pipeline run: `docs/images/03-devsecops-pipeline-success.png`
- Terraform plan success output: `docs/images/04-terraform-plan-success.png`

Screenshot timing guidance:

- Capture `02-checkov-scan-failure.png` immediately after the security stage fails on insecure Terraform.
- Capture `04-terraform-plan-success.png` from the Terraform planning stage after remediation.
- Capture `03-devsecops-pipeline-success.png` from the final successful pipeline summary view.

## Deployment Results

Live deployment evidence is documented in `docs/deployment-results.md`.

Expected evidence set:

- Running EC2 instance
- Restricted security group configuration
- IAM role attached to EC2 instance
- Terraform plan output from CI/CD execution

Final deployment includes a successfully provisioned EC2 instance via federated OIDC authentication, validated through Terraform apply execution and AWS console verification.

## Prerequisites

- Azure DevOps project with pipeline permissions
- AWS account with IAM role and OIDC provider configured
- Terraform and Checkov available in pipeline runtime
- Hosted Azure DevOps parallelism enabled for private projects

If you encounter hosted parallelism limitations, see `docs/troubleshooting.md`.

## Repository Structure

```text
azure-devops-aws-federation-lab/
|-- azure-pipelines.yml
|-- infra/
|   |-- autoscaling.tf
|   |-- ec2.tf
|   |-- main.tf
|   |-- outputs.tf
|   `-- variables.tf
|-- pipelines/
|-- security/
|   |-- checkov.yaml
|   `-- scan-results.md
|-- docs/
|   |-- README.md
|   |-- deployment-results.md
|   |-- federation-flow.md
|   |-- setup-guide.md
|   |-- troubleshooting.md
|   `-- images/
|       `-- archive/
`-- README.md
```

## Learning Outcomes

This lab demonstrates practical capability in:

- Designing secure multi-cloud CI/CD federation
- Eliminating long-lived cloud secrets from pipelines
- Enforcing IaC policy checks before infrastructure changes
- Debugging and remediating cloud security misconfigurations
- Presenting verifiable deployment and security evidence for audit and portfolio use

## Documentation

Detailed guides and evidence are indexed in `docs/README.md`.