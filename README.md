# Azure DevOps → AWS Infrastructure Federation Lab

## Overview

This project demonstrates a multi-cloud DevSecOps pipeline where Azure DevOps securely deploys AWS infrastructure using OIDC federation. Instead of storing static AWS credentials in CI/CD variables, the pipeline authenticates using short-lived AWS STS tokens through an IAM role trust relationship.

Security controls are embedded directly in the pipeline through Checkov infrastructure-as-code scanning, ensuring insecure infrastructure configurations are detected and remediated before deployment.

The lab showcases secure CI/CD identity federation, infrastructure automation, and IaC security enforcement across Azure and AWS.

## Prerequisites

Before running the Azure DevOps pipeline, ensure the following requirements are met.

### Azure DevOps Hosted Agent Requirement

New Azure DevOps organizations running **private projects** may not initially have hosted pipeline parallelism enabled.

If the pipeline fails with the message:

No hosted parallelism has been purchased or granted

request free hosted parallelism using the Microsoft request form:

    https://aka.ms/azpipelines-parallelism-request

Select **Private projects** when submitting the request.

Once approved, rerun the pipeline.

## Core Technologies

Azure DevOps
Amazon Web Services (AWS)
AWS IAM / STS
Amazon EC2
AWS Auto Scaling
Terraform (Infrastructure-as-Code)
Checkov (IaC security scanning)

## Security Concepts Demonstrated

OIDC workload identity federation
Short-lived cloud credentials (STS)
Least-privilege IAM role design
Shift-left infrastructure security scanning
Multi-cloud CI/CD infrastructure delivery

## High Level Architecture

Developer → Git push

Azure DevOps Pipeline executes:

Terraform validation

Checkov security scan

OIDC authentication with AWS

AWS STS AssumeRoleWithWebIdentity

Terraform deployment of infrastructure

Deployed resources:

Amazon EC2 instance

Auto Scaling group

Associated IAM roles and security groups

## Repository Structure

azure-devops-aws-federation-lab
│
├── infra
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── autoscaling.tf
│
├── pipelines
│   └── azure-pipelines.yml
│
├── security
│   ├── checkov.yaml
│   └── scan-results.md
│
├── docs
│   ├── architecture-diagram.png
│   ├── federation-flow.md
│   └── setup-guide.md
│
└── README.md

## Implementation Phases

Phase 1 — Secure AWS Federation

Goal: Allow Azure DevOps pipelines to securely authenticate to AWS.

Steps:

Create an AWS IAM OIDC identity provider
Create an IAM role with a trust policy allowing Azure DevOps to assume the role
Configure Azure DevOps pipeline to authenticate using OIDC
Use AWS STS to generate temporary credentials

Security outcome:

No long-lived AWS access keys stored in CI/CD.

Phase 2 — Infrastructure Deployment

Goal: Automate AWS infrastructure provisioning.

Infrastructure deployed:

EC2 instance
Security group
Launch template
Auto Scaling group

Deployment executed via Terraform within the Azure DevOps pipeline.

Phase 3 — IaC Security Enforcement

Goal: Integrate shift-left security scanning.

Pipeline additions:

Checkov scan of Terraform code
Fail pipeline if critical security issues detected
Remediate misconfigurations and rerun pipeline

Examples of security checks:

Unrestricted security group ingress
Unencrypted resources
Publicly exposed instances

Phase 4 — DevSecOps Hardening

Optional security enhancements:

Restrict IAM role permissions
Add Terraform remote state storage
Add approval gates before deployment
Add logging and monitoring

Validation Scenarios

Security validation will demonstrate:

Checkov failing insecure Terraform configuration
Pipeline blocking deployment
Remediation of IaC vulnerabilities
Successful redeployment after fixes

Learning Outcomes

This project demonstrates practical skills in:

Multi-cloud DevSecOps engineering
CI/CD identity federation
Secure infrastructure automation
Infrastructure-as-Code security scanning
Cloud IAM design patterns
