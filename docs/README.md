# Documentation Index

This directory contains supporting documentation for the Azure DevOps → AWS Federation DevSecOps lab, including setup instructions, architecture references, deployment evidence, and troubleshooting notes.

## Documents

### Setup Guide
**File:** `setup-guide.md`

Step-by-step instructions for configuring Azure DevOps, AWS IAM OIDC federation, Terraform execution, and pipeline setup.

### Federation Flow
**File:** `federation-flow.md`

Detailed explanation of how Azure DevOps authenticates to AWS using OIDC federation and AWS STS temporary credentials.

### Deployment Results
**File:** `deployment-results.md`

Evidence that the CI/CD pipeline successfully deployed secure infrastructure in AWS after passing security validation gates.

Includes screenshots of:

- Running EC2 instance
- Security group configuration
- IAM role attachment
- Terraform plan output

### Troubleshooting
**File:** `troubleshooting.md`

Common issues encountered while building the DevSecOps pipeline and their resolutions, including:

- Azure DevOps hosted parallelism limitations
- GitHub repository authorization errors
- AWS OIDC identity provider configuration issues
- Terraform credential propagation problems
- Checkov security scan failures

## Screenshot Storage

All project evidence screenshots are stored in:

docs/images/

Follow the filename conventions referenced throughout the documentation to maintain consistent portfolio presentation.
