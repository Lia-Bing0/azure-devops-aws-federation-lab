# OIDC Federation Flow

## Overview

This document describes how Azure DevOps securely authenticates to AWS using OpenID Connect (OIDC) without storing long-lived credentials.

## Authentication Flow

1. Azure DevOps pipeline requests an OIDC token from Azure.
2. The token includes:
   - Issuer (Azure DevOps OIDC endpoint)
   - Subject (pipeline identity)
   - Audience (`api://AzureADTokenExchange`)
3. The pipeline sends the token to AWS STS.
4. AWS validates the token against the configured IAM OIDC provider.
5. AWS allows `AssumeRoleWithWebIdentity` based on the IAM role trust policy.
6. Temporary credentials are issued.
7. Terraform uses these temporary credentials to deploy infrastructure.

## Security Benefits

- No static AWS credentials stored in pipelines
- Short-lived credentials reduce attack surface
- IAM trust policy enforces least privilege
- Federation enables secure cross-cloud identity

## Key Components

- Azure DevOps OIDC token issuer
- AWS IAM OIDC provider
- IAM role with trust relationship
- AWS STS (AssumeRoleWithWebIdentity)
- Terraform AWS provider

## Reference

See:

- `docs/deployment-results.md`
- `docs/troubleshooting.md`