# DevSecOps Pipeline: Remote Jenkins to OpenShift Cloud

This repository contains a Proof of Concept (POC) for a secure software supply chain. It bridges an external **Jenkins Agent** with a remote **OpenShift Cluster**, enforcing a mandatory security gate using **Trivy**.

## 🚀 Architecture Overview
The pipeline implements a "Scan-Before-Push" logic, ensuring that only verified, vulnerability-free images reach the production registry.

- **CI Tool:** Jenkins (External Agent)
- **Security Scanner:** Trivy (SCA & SBOM)
- **Target Platform:** OpenShift Container Platform (OCP)
- **Registry:** OpenShift Internal Registry (via Passthrough Route)

## 🛠️ Features
- **Automated Security Gate:** Blocks image promotion if `CRITICAL` vulnerabilities are detected.
- **SBOM Generation:** Produces a machine-readable Software Bill of Materials (CycloneDX).
- **Cloud Integration:** Handles authenticated handshake between external agents and OCP.
- **Troubleshooting:** Includes fixes for X509 certificate errors and 503 Service Unavailable via Ingress Passthrough.

## 📋 Prerequisites
- Jenkins Agent with Docker and `oc` CLI installed.
- Trivy installed on the Jenkins node.
- Access to an OpenShift cluster with `image-registry` operator configured.

## 🔧 Setup & Usage
1. Configure your OCP credentials in Jenkins.
2. Update the `REGISTRY` and `API` variables in the `Jenkinsfile`.
3. Run the pipeline.
