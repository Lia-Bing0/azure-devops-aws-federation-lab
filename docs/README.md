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

# Documentation Index

This directory contains detailed documentation, architecture explanations, troubleshooting scenarios, and deployment evidence for the Azure DevOps → AWS OIDC federation DevSecOps lab.

## Documents

### Setup Guide

- `setup-guide.md`
- Step-by-step instructions to configure Azure DevOps, AWS IAM OIDC provider, and Terraform environment.

### Federation Flow

- `federation-flow.md`
- Explains the identity federation process between Azure DevOps and AWS using OIDC and STS.

### Deployment Results

- `deployment-results.md`
- Contains evidence of successful infrastructure deployment and security validation.

### Troubleshooting Guide

- `troubleshooting.md`
- Documents real issues encountered during implementation and how they were resolved.

### Security Scan Results

- `../security/scan-results.md`
- Captures Checkov validation results and security remediation workflow.

## Notes

- Screenshots referenced in these documents are located in `docs/images/`.
- Sensitive values (account IDs, tokens) are redacted where applicable.