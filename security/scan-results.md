# Checkov Scan Results

## Purpose

This document captures security validation performed using Checkov during the CI/CD pipeline.

## Summary

Initial Terraform configuration failed security checks, including:

- Overly permissive SSH access (0.0.0.0/0)
- Missing encryption or secure defaults
- Lack of instance hardening configurations

After remediation:

- SSH access restricted to internal CIDR
- Secure configurations applied
- All critical Checkov checks passed

## Result

Checkov scan passed successfully before Terraform apply.

## Evidence

- Pipeline stage: "Run Checkov Security Scan"
- See Azure DevOps pipeline logs for the "Run Checkov Security Scan" stage (see `docs/images/02-checkov-scan-failure.png`), where Checkov evaluates Terraform configurations and reports policy violations prior to deployment.

## Notes

Checkov acts as a security gate, preventing insecure infrastructure from being deployed.