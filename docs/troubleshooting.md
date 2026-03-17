# Troubleshooting Guide

## Purpose

This document records real troubleshooting scenarios encountered while implementing Azure DevOps → AWS OIDC federation, Terraform automation, and DevSecOps security validation.  

Each issue includes the failure symptom, root cause, and remediation steps used to restore pipeline execution.

## 1. Azure DevOps Hosted Parallelism Not Enabled

### Error Example

`No hosted parallelism has been purchased or granted`

### Cause

New or private Azure DevOps organizations may not have Microsoft-hosted pipeline parallelism enabled by default.

### Resolution

Request free hosted parallelism here:

`https://aka.ms/azpipelines-parallelism-request`

Select the appropriate project type and rerun the pipeline after approval.

### Screenshot Placeholder

`docs/images/troubleshoot-parallelism-error.png`

### When to Capture

Capture immediately when the pipeline job is blocked before execution starts.

## 2. Azure DevOps GitHub Repository Authorization Failure

### Error Example

Pipeline fails during the checkout stage or cannot access the configured GitHub repository.

### Cause

Azure DevOps pipeline was not authorized to access the GitHub repository used as the source provider.

### Resolution

Authorize Azure DevOps access to the GitHub repository during pipeline setup or install the Azure DevOps GitHub integration.

### Screenshot Placeholder

`docs/images/troubleshoot-github-repo-authorization.png`

### When to Capture

Capture from the pipeline setup or authorization prompt when connecting Azure DevOps to the GitHub repository.

## 3. AWS OIDC Identity Provider Mismatch

### Error Example

`InvalidIdentityToken: No OpenIDConnect provider found`

### Cause

The OIDC provider URL configured in AWS IAM does not match the token issuer expected from Azure DevOps.

### Resolution

Update the AWS IAM OIDC provider configuration and IAM role trust policy so the issuer URL, audience (`api://AzureADTokenExchange`), and subject pattern match the Azure DevOps token claims.

### Screenshot Placeholder

`docs/images/troubleshoot-oidc-provider-error.png`

### When to Capture

Capture from pipeline logs showing STS or role-assumption failure details.

## 4. A## AWS OIDC Provider Thumbprint Handling

### Explanation

Older AWS OIDC setup guides reference a TLS certificate thumbprint when creating the identity provider.

### Current Behavior

AWS automatically retrieves the TLS certificate thumbprint for many trusted OIDC providers, including Azure DevOps.

### Implementation

When creating the AWS IAM OIDC provider, only the issuer URL and audience are required. AWS automatically manages the certificate thumbprint.

## 5. Terraform Credential Source Error

### Error Example

`No valid credential sources found`

### Cause

Terraform ran outside the AWS-authenticated task context, so federated credentials were not available to the process.

### Resolution

Execute Terraform commands inside an AWS-authenticated task such as `AWSShellScript` so environment credentials propagate to Terraform.

### Screenshot Placeholder

This issue was prevented by executing Terraform commands inside the AWS-authenticated task (AWSShellScript), allowing OIDC-issued credentials to propagate to the Terraform AWS provider.

### When to Capture

Capture from Terraform pipeline step logs where provider authentication fails.

## 6. Checkov Security Scan Failure

### Example Findings

- Security group allowing SSH from `0.0.0.0/0`
- Unencrypted root volume
- IMDSv1 enabled

### Cause

Terraform configuration introduced insecure infrastructure settings that violated Checkov policy checks, including unrestricted SSH access and missing encryption or instance hardening controls.

### Resolution

- Restrict ingress rules
- Enable EBS encryption
- Require IMDSv2
- Enable EC2 monitoring

This ensures insecure infrastructure cannot be deployed until security findings are remediated.

Rerun the pipeline and confirm Checkov passes before deployment.

### Screenshot Placeholder

`docs/images/02-checkov-scan-failure.png`

### When to Capture

Capture right after Checkov fails to preserve finding IDs and policy context.

## Recommended Troubleshooting Workflow

1. Identify the failing stage in Azure DevOps pipeline logs.
2. Capture evidence of the failure before modifying configuration.
3. Determine whether the issue originates from IAM, OIDC federation, Terraform configuration, or pipeline execution context.
4. Apply the minimal corrective change required to resolve the failure.
5. Rerun the pipeline and validate successful execution.
