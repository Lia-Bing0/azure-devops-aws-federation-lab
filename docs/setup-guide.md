# DevSecOps Lab Setup Guide

## Purpose

This guide covers the end-to-end configuration required to run the Azure DevOps to AWS Federation DevSecOps lab, including:

- AWS IAM OIDC identity provider and federated role setup
- Azure DevOps service connection configuration
- Terraform pipeline execution
- Checkov infrastructure security scanning

---

## Prerequisites

- AWS account with IAM permissions to create OIDC providers and roles
- Azure DevOps organization and project
- GitHub repository connected to Azure DevOps
- Hosted pipeline parallelism enabled for private projects (see [Troubleshooting](troubleshooting.md) if not enabled)
- Terraform configuration committed to the repository under `infra/`
- AWS Toolkit for Azure DevOps extension installed in the organization

---

## 1. Create the AWS OIDC Identity Provider

1. Open the AWS Console and navigate to **IAM → Identity providers**.
2. Click **Add provider**.
3. Select **OpenID Connect**.
4. Enter the Azure DevOps OIDC issuer URL for your organization.  
   Example format: `https://vstoken.dev.azure.com/<your-org-name>`  
   The issuer URL must exactly match the token issuer Azure DevOps embeds in the OIDC token, including the org-specific path.
5. Set the **Audience** to: `api://AzureADTokenExchange`
6. AWS will automatically retrieve the TLS certificate thumbprint for the OIDC provider.  
7. Click **Add provider**.

---

## 2. Create the Federated IAM Role

1. Navigate to **IAM → Roles → Create role**.
2. Select **Trusted entity type: Web identity**.
3. Select the Azure DevOps OIDC identity provider created in step 1.
4. Set **Audience** to: `api://AzureADTokenExchange`
5. Attach the required IAM policy for Terraform execution (EC2, Auto Scaling, IAM read permissions as needed).
6. After creating the role, edit the trust policy to ensure the `Condition` block constrains the `sub` claim to match the Azure DevOps service connection subject.

Example trust policy condition:

```json
"Condition": {
  "StringEquals": {
    "vstoken.dev.azure.com/<org-name>:aud": "api://AzureADTokenExchange",
    "vstoken.dev.azure.com/<org-name>:sub": "sc://<org-name>/<project-name>/<service-connection-name>"
  }
}
```

The role must allow `sts:AssumeRoleWithWebIdentity` from the OIDC provider principal.

---

## 3. Configure Azure DevOps Service Connection

1. Go to **Project Settings → Service connections**.
2. Click **New service connection** and select **AWS**.
3. Enable **OIDC** as the authentication method.
4. Provide the **IAM Role ARN** created in step 2.
5. Name the service connection `aws-oidc-federation`.
6. Save and verify the connection.

---

## 4. Connect GitHub Repository

1. In Azure DevOps, go to **Pipelines → Create Pipeline**.
2. Select **GitHub** as the source.
3. Authorize Azure DevOps access to your GitHub account.
4. Select the target repository.
5. Choose **Existing Azure Pipelines YAML file** and select `azure-pipelines.yml` from the repository root.

---

## 5. Configure the Pipeline

The pipeline is defined in `azure-pipelines.yml` and executes the following stages:

- Verify AWS identity using `sts:GetCallerIdentity`
- Install Terraform
- Install Checkov
- Run Checkov security scan against `infra/`
- Run `terraform init` and `terraform plan`
- (Optional) Run `terraform apply` for live deployment validation

Pipeline execution requires the `aws-oidc-federation` service connection to be authorized for the pipeline.

---

## 6. Verify OIDC Federation

After the pipeline authenticates to AWS, the identity verification step runs:

```bash
aws sts get-caller-identity
```

Successful output confirms:

- Azure DevOps generated a valid OIDC token
- AWS STS issued temporary credentials via `AssumeRoleWithWebIdentity`
- The federated IAM role was assumed successfully

Screenshot placeholder: `docs/images/01-aws-sts-identity-verification.png`

---

## 7. Validate Security Controls with Checkov

The Checkov stage scans Terraform under `infra/` and fails the pipeline on policy violations.

Example violations that will trigger failure:

- Security group allowing SSH ingress from `0.0.0.0/0`
- Root EBS volume not encrypted
- IMDSv1 not disabled on EC2

To validate the fail path:

1. Introduce one of the above misconfigurations in Terraform.
2. Push and run the pipeline.
3. Observe the Checkov stage fail with policy findings.

Screenshot placeholder: `docs/images/02-checkov-scan-failure.png`

To validate the pass path:

1. Remediate the Terraform configuration.
2. Rerun the pipeline.
3. Confirm Checkov passes and the pipeline proceeds.

Screenshot placeholder: `docs/images/03-devsecops-pipeline-success.png`

---

## 8. Validate Terraform Execution

After Checkov passes, the pipeline runs Terraform:

```bash
terraform init
terraform plan
```

Optionally, the pipeline may also execute:

``` bash
terraform apply -auto-approve
```

This step should run inside the AWS-authenticated pipeline task so that the OIDC-issued temporary credentials are available to Terraform.

Screenshot placeholders:

- `docs/images/04-terraform-plan-success.png`
- `docs/images/05-terraform-apply-success.png`

---

## 9. Confirm Live AWS Resources

After a successful `terraform apply`, verify the following in the AWS Console:

- EC2 instance shows state `running`
- Security group inbound rules are restricted (no open ingress)
- IAM instance profile is attached to the EC2 instance
- Auto Scaling group and launch template are present (if configured)

Screenshot placeholders:

- `docs/images/06-aws-ec2-instance-running.png`
- `docs/images/07-aws-security-group-restricted.png`
- `docs/images/08-aws-ec2-iam-role.png`

---

## Related Documentation

- [README.md](../README.md) — Project overview and architecture summary
- [docs/federation-flow.md](federation-flow.md) — Detailed OIDC federation token flow
- [docs/deployment-results.md](deployment-results.md) — Deployment evidence and screenshot index
- [docs/troubleshooting.md](troubleshooting.md) — Common setup errors and resolutions
