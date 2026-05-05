# Project Plan: Kubernetes Cluster Infrastructure & Dotfiles Integration

> **⚠️ AGENT SAFETY LOCK — READ BEFORE PROCEEDING**
>
> **DO NOT EXECUTE ANY WORK ON THIS PROJECT WITHOUT EXPLICIT USER AUTHORIZATION.**
>
> This project plan is a reference document only. No work may be performed on any phase, step, or deliverable unless the user has given a clear, unambiguous instruction to do so in the current conversation.
>
> **Rules for AI agents:**
>
> 1. **Do not** start, continue, or resume any work on this project autonomously.
> 2. **Do not** create, modify, or delete any files related to this project unless the user explicitly asks you to.
> 3. **Do not** assume that because this file exists, work is authorized — it is not.
> 4. **Do not** offer to begin working on any phase or step. Wait for the user to ask.
> 5. If the user asks a general question about this plan (e.g., "what's in Phase 3?"), answer the question only — do not offer to execute it.
> 6. If the user gives a specific instruction to modify or execute part of this plan, proceed only with that exact instruction.
>
> **Why this exists:** AI agents lose context between sessions. Without this lock, an agent could resume a previous conversation's context and start modifying files or running commands without the user's knowledge or consent. This lock ensures the user remains in control at all times.
>
> **To authorize work:** The user will explicitly say something like "Start Phase 0" or "Work on step 1.1". Until then, do nothing.

## Table of Contents

- [Project Overview](#project-overview)
  - [Goals and Objectives](#goals-and-objectives)
  - [Success Criteria](#success-criteria)
- [Project Scope](#project-scope)
  - [In Scope](#in-scope)
  - [Out of Scope](#out-of-scope)
  - [Deliverables](#deliverables)
- [Work Breakdown](#work-breakdown)
  - [Phase 0 — Planning & Preparation](#phase-0--planning--preparation)
  - [Phase 1 — Foundation: MetalLB, Ingress & TLS](#phase-1--foundation-metallb-ingress--tls)
  - [Phas 2 — Monitoring & Observability](#phase-2--monitoring--observability)
  - [Phase 3 — Storage & Data Services](#phase-3--storage--data-services)
  - [Phase 4 — AI Platform & Developer Tools](#phase-4--ai-platform--developer-tools)
    - [4.1 — Deploy Ollama with PVC for model storage](#41--deploy-ollama-with-pvc-for-model-storage)
    - [4.2 — Pull and serve quantized models](#42--pull-and-serve-quantized-models)
    - [4.3 — Create ingress rule for Ollama API with TLS](#43--create-ingress-rule-for-ollama-api-with-tls)
    - [4.4 — Validate Ollama API responds from workstation](#44--validate-ollama-api-responds-from-workstation)
    - [4.5 — Deploy Open WebUI as ChatGPT-like interface for Ollama](#45--deploy-open-webui-as-chatgpt-like-interface-for-ollama)
    - [4.6 — Create ingress rule for Open WebUI with TLS](#46--create-ingress-rule-for-open-webui-with-tls)
    - [4.7 — Deploy n8n for AI workflow automation](#47--deploy-n8n-for-ai-workflow-automation)
    - [4.8 — Create ingress rule for n8n with TLS](#48--create-ingress-rule-for-n8n-with-tls)
    - [4.9 — Configure n8n to use Ollama as AI provider](#49--configure-n8n-to-use-ollama-as-ai-provider)
    - [4.10 — Deploy Dify for LLM application development](#410--deploy-dify-for-llm-application-development)
    - [4.11 — Create ingress rule for Dify with TLS](#411--create-ingress-rule-for-dify-with-tls)
    - [4.12 — Configure avante.nvim to use Ollama as secondary AI provider](#412--configure-avante-nvim-to-use-ollama-as-secondary-ai-provider)
    - [4.13 — Deploy Headlamp Kubernetes dashboard](#413--deploy-headlamp-kubernetes-dashboard)
    - [4.14 — Create ingress rule for Headlamp with TLS](#414--create-ingress-rule-for-headlamp-with-tls)
    - [4.15 — Validate all AI tools accessible from workstation browser](#415--validate-all-ai-tools-accessible-from-workstation-browser)
  - [Phase 5 — Centralized Logging](#phase-5--centralized-logging)
  - [Phase 6 — Dotfiles Integration](#phase-6--dotfiles-integration)
  - [Phase 7 — Polish & Hardening](#phase-7--polish--hardening)
  - [Phase 8 — Network DNS Management](#phase-8--network-dns-management)
  - [Phase 9 — Browser Automation & Testing](#phase-9--browser-automation--testing)
    - [9.1 — Research and select browser automation tools](#91--research-and-select-browser-automation-tools)
    - [9.2 — Set up Playwright Python development environment](#92--set-up-playwright-python-development-environment)
    - [9.3 — Deploy Playwright MCP Server](#93--deploy-playwright-mcp-server)
    - [9.4 — Create browser test suites for cluster services](#94--create-browser-test-suites-for-cluster-services)
    - [9.5 — Create avante.nvim custom tool for test execution](#95--create-avante-nvim-custom-tool-for-test-execution)
    - [9.6 — Create bash aliases and shell completion](#96--create-bash-aliases-and-shell-completion)
    - [9.7 — Integrate with Woodpecker CI](#97--integrate-with-woodpecker-ci)
    - [9.8 — Document the testing framework with usage examples and troubleshooting](#98--document-the-testing-framework-with-usage-examples-and-troubleshooting)
  - [Phase 10 — Load Testing with Locust](#phase-10--load-testing-with-locust)
    - [10.1 — Research and plan Locust test scenarios](#101--research-and-plan-locust-test-scenarios)
    - [10.2 — Set up Locust development environment](#102--set-up-locust-development-environment)
    - [10.3 — Write Locust test scenarios for cluster services](#103--write-locust-test-scenarios-for-cluster-services)
    - [10.4 — Deploy Locust in distributed mode](#104--deploy-locust-in-distributed-mode)
    - [10.5 — Create bash aliases and shell completion](#105--create-bash-aliases-and-shell-completion)
    - [10.6 — Create avante.nvim custom tool for load testing](#106--create-avante-nvim-custom-tool-for-load-testing)
    - [10.7 — Integrate with Woodpecker CI](#107--integrate-with-woodpecker-ci)
    - [10.8 — Document the load testing framework with usage examples and troubleshooting](#108--document-the-load-testing-framework-with-usage-examples-and-troubleshooting)
- [Resources](#resources)
  - [Infrastructure Requirements](#infrastructure-requirements)
  - [Development Environment](#development-environment)
  - [Budget and Costs](#budget-and-costs)
  - [External Services](#external-services)
- [Validation and Testing](#validation-and-testing)
  - [Validation Requirements](#validation-requirements)
  - [Testing Requirements](#testing-requirements)
- [Risks and Issues](#risks-and-issues)
  - [Key Risks](#key-risks)
  - [Current Issues](#current-issues)
- [Dependencies](#dependencies)
  - [Internal Dependencies](#internal-dependencies)
  - [External Dependencies](#external-dependencies)
- [Notes](#notes)
- [Revision History](#revision-history)

## Project Overview

**Project ID:** Proj-003
**Status:** Planning
**Start Date:** 2026-05-04
**Target Completion:** 2026-06-30
**Last Updated:** 2026-05-04

### Goals and Objectives

- **Primary Goal:** Transform the K3s cluster into a fully-featured development infrastructure that integrates deeply with the dotfiles workstation environment
- **Key Objectives:**
  1. Deploy monitoring and observability stack (Prometheus + Grafana)
  2. Deploy ingress controller and certificate management for proper service access
  3. Deploy Ollama for local AI/LLM inference (avante.nvim integration)
  4. Deploy Open WebUI as ChatGPT-like interface for Ollama
  5. Deploy n8n for AI workflow automation with Ollama integration
  6. Deploy Dify for LLM application development with RAG capabilities
  7. Deploy Kubernetes dashboard for visual cluster management
  8. Implement backup strategy for PVC data protection
  9. Deploy centralized logging (Loki + Promtail)
  10. Deploy MetalLB for LoadBalancer service support
  11. Deploy MinIO for S3-compatible object storage
  12. Deploy container registry mirror for faster image pulls
  13. Create dotfiles integration points (Neovim, SSH scripts, bash aliases)

### Success Criteria

- All cluster services accessible via hostnames (not NodePorts)
- Grafana dashboards visible from workstation browser
- Ollama API accessible from avante.nvim for local AI assistance
- Cluster health indicators visible from workstation
- PVC backups running on schedule
- Centralized log search available in Grafana
- All services have TLS certificates
- LoadBalancer services get proper LAN IPs

## Project Scope

### In Scope

- Prometheus + Grafana monitoring stack (kube-prometheus-stack)
- NGINX Ingress Controller for service routing
- cert-manager for TLS certificate management
- Ollama deployment for local LLM inference
- Open WebUI as ChatGPT-like interface for Ollama
- n8n for AI workflow automation with Ollama integration
- Dify for LLM application development with RAG capabilities
- Headlamp Kubernetes dashboard
- Velero or CronJob-based PVC backup solution
- Grafana Loki + Promtail for centralized logging
- MetalLB for LoadBalancer services
- MinIO for S3-compatible storage
- Container registry mirror (using Gitea's built-in registry or standalone)
- Dotfiles integration (Neovim, SSH scripts, bash aliases, avante rules)

### Out of Scope

- Home Assistant / smart home integration
- Code-server / VS Code in browser
- Project management tools (Plane, OpenProject, etc.)
- Vaultwarden password manager
- Pi-hole / AdGuard Home DNS
- Node-RED automation
- Harbor container registry (use Gitea's built-in or simple mirror)
- DevPod / DevContainer environments
- Production-grade HA configurations (single-node control plane is fine)
- Waybar and Hyprland configuration (desktop environment customizations)

### Deliverables

| #   | Phase Name                         | Description                                                          | Completed By |
| --- | ---------------------------------- | -------------------------------------------------------------------- | ------------ |
| 1   | Monitoring & Observability         | Prometheus + Grafana with pre-configured dashboards and alerting     | Phase 2      |
| 2   | Foundation: MetalLB, Ingress & TLS | All services accessible via `*.home.lan` with automatic certificates | Phase 1      |
| 3   | AI Platform & Developer Tools      | Local LLM API endpoint for avante.nvim integration                   | Phase 4      |
| 4   | AI Platform & Developer Tools      | ChatGPT-like chat interface for Ollama models                        | Phase 4      |
| 5   | AI Platform & Developer Tools      | AI workflow automation platform with Ollama integration              | Phase 4      |
| 6   | AI Platform & Developer Tools      | LLM application development with RAG capabilities                    | Phase 4      |
| 7   | AI Platform & Developer Tools      | Headlamp for visual cluster management                               | Phase 4      |
| 8   | Storage & Data Services            | Automated PVC backups with retention policy                          | Phase 3      |
| 9   | Centralized Logging                | Loki + Promtail for centralized log aggregation                      | Phase 5      |
| 10  | Foundation: MetalLB, Ingress & TLS | LoadBalancer IP pool for LAN services                                | Phase 1      |
| 11  | Storage & Data Services            | S3-compatible object storage for backups and artifacts               | Phase 3      |
| 12  | Storage & Data Services            | Local container image cache for faster deployments                   | Phase 3      |
| 13  | Dotfiles Integration               | Neovim tools, SSH port-forward scripts, bash aliases, avante rules   | Phase 6      |

## Dependencies

### Internal Dependencies

- **MetalLB → Ingress**: Ingress controller needs LoadBalancer IP
- **Ingress → cert-manager**: TLS needs ingress to terminate
- **Prometheus → Grafana**: Dashboards need data source
- **Loki → Grafana**: Logs need visualization
- **MinIO → Backups**: Velero needs S3 storage target
- **Ollama → Open WebUI**: Chat interface needs LLM backend
- **Ollama → n8n**: Workflow automation needs AI provider
- **Ollama → Dify**: LLM app platform needs inference backend
- **Ollama → avante.nvim**: Local AI needs API endpoint
- **PostgreSQL → n8n**: Workflow engine needs database
- **PostgreSQL + Redis + Vector DB → Dify**: App platform needs all three

### External Dependencies

- **Helm repositories**: Need to add bitnami, prometheus-community, ingress-nginx, etc.
- **Container images**: Pulled from registries (may fail without mirror initially)
- **DNS resolution**: `*.home.lan` needs to resolve (local DNS or /etc/hosts)

## Work Breakdown

### Phase 0 — Planning & Preparation

**Goal:** Finalize project scope, prepare the cluster, and set up tooling

#### 0.1 — Review and finalize project plan with all stakeholders

- Present the project plan for review and feedback
- Adjust scope, priorities, and timeline based on input
- Get final approval before proceeding with implementation

#### 0.2 — Add required Helm repositories to the cluster

- Add Helm repositories: bitnami, prometheus-community, ingress-nginx, jetstack (cert-manager), grafana, minio, etc.
- Update Helm repo cache to ensure latest charts are available
- Verify repo access with `helm repo list`

#### 0.3 — Configure local DNS resolution for `*.home.lan`

- Add entries to `/etc/hosts` on the workstation for all planned services
- Use a consistent IP scheme (e.g., MetalLB pool IPs or Traefik's LoadBalancer IP)
- Verify resolution with `ping service.home.lan`
- **Note:** This is a temporary solution — Phase 8 will implement network-level DNS

#### 0.4 — Verify kubectl and Helm access from workstation

- Test `kubectl get nodes` to confirm cluster connectivity
- Test `helm list -A` to verify Helm works with the cluster
- Verify kubeconfig context is set correctly
- Document any access issues

#### 0.5 — Document current cluster state as baseline

- Run `kubectl get all -A` and save output
- Document existing services, deployments, and configurations
- Note current resource usage (CPU, memory, storage)
- Save baseline for comparison after infrastructure changes

### Phase 1 — Foundation: MetalLB, Ingress & TLS

**Goal:** Establish core networking layer — LoadBalancer support, ingress routing, and automatic TLS certificates

#### Phase 1 Deliverables

| #   | Deliverable       | Description                                                          |
| --- | ----------------- | -------------------------------------------------------------------- |
| 2   | **Ingress + TLS** | All services accessible via `*.home.lan` with automatic certificates |
| 10  | **MetalLB**       | LoadBalancer IP pool for LAN services                                |

#### 1.1 — Deploy MetalLB with IP address pool

- Deploy MetalLB via Helm with an IP address pool (192.168.1.200-220)
- Configure L2 advertisement mode for LAN visibility
- Verify MetalLB pods are running and ready
- **Note:** The IP pool must avoid the DHCP range (192.168.1.100-199 is likely DHCP)

#### 1.2 — Verify MetalLB assigns IPs to LoadBalancer services

- Create a test LoadBalancer service or check existing pending services
- Verify MetalLB assigns an IP from the configured pool
- Confirm the IP is pingable from the workstation

#### 1.3 — Fix ArgoCD LoadBalancer by switching to MetalLB IP

- ArgoCD's `svclb-argocd-server` pods are currently stuck Pending (no LoadBalancer provider)
- After MetalLB is deployed, verify ArgoCD gets a LoadBalancer IP automatically
- If not, patch the ArgoCD server service to use LoadBalancer type
- Verify ArgoCD is accessible via its new LoadBalancer IP

#### 1.4 — Deploy NGINX Ingress Controller via MetalLB

- Deploy NGINX Ingress Controller via Helm with a LoadBalancer service type
- Configure it to use a static MetalLB IP (e.g., 192.168.1.201)
- Verify the ingress controller pods are running and the LoadBalancer IP is assigned
- **Note:** Traefik is already running as the cluster's default ingress controller. Consider whether to:
  - Replace Traefik with NGINX (more familiar, broader community)
  - Keep Traefik and use it for all ingress (simpler, already works)
  - Run both (NGINX for new services, Traefik for existing)

#### 1.5 — Create ingress rules for existing services (Gitea, ArgoCD, Woodpecker)

- Create Ingress or IngressRoute resources for each existing service
- Map each service to a `*.home.lan` hostname:
  - `gitea.home.lan` → Gitea service (port 3000)
  - `argocd.home.lan` → ArgoCD server service (port 443)
  - `woodpecker.home.lan` → Woodpecker server service (port 8000)
- Test each hostname resolves and routes to the correct service

#### 1.6 — Deploy cert-manager with self-signed cluster issuer

- Deploy cert-manager via Helm (jetstack repo)
- Create a self-signed ClusterIssuer for internal TLS certificates
- Verify the ClusterIssuer is ready with `kubectl get clusterissuer`

#### 1.7 — Configure TLS on all ingress rules

- Annotate each ingress resource to use the cert-manager cluster issuer
- Configure TLS termination for each `*.home.lan` hostname
- Verify certificates are issued and valid with `kubectl get certificate`

#### 1.8 — Validate all services accessible via `https://service.home.lan`

- Test each service from the workstation browser:
  - `https://gitea.home.lan` — should load with valid TLS
  - `https://argocd.home.lan` — should load with valid TLS
  - `https://woodpecker.home.lan` — should load with valid TLS
- Verify TLS certificate details show the correct hostname
- Document any services that fail and troubleshoot

### Phase 2 — Monitoring & Observability

**Goal:** Deploy Prometheus + Grafana for cluster-wide metrics and alerting

#### Phase 2 Deliverables

| #   | Deliverable          | Description                                                      |
| --- | -------------------- | ---------------------------------------------------------------- |
| 1   | **Monitoring Stack** | Prometheus + Grafana with pre-configured dashboards and alerting |

#### 2.1 — Deploy kube-prometheus-stack via Helm

- Add the prometheus-community Helm repository
- Install kube-prometheus-stack chart with default configuration
- Verify all components are running: Prometheus, Alertmanager, Grafana, exporters
- **Note:** This chart includes Prometheus, Alertmanager, Grafana, node-exporter, and kube-state-metrics in a single deployment

#### 2.2 — Configure Prometheus to scrape all cluster nodes and pods

- Verify default scrape configs cover all cluster nodes and pods
- Add additional scrape targets if needed (e.g., custom service endpoints)
- Confirm Prometheus targets are all UP in the UI
- Check Prometheus resource usage after scraping begins

#### 2.3 — Set up Grafana with pre-configured dashboards

- Import pre-configured dashboards for node metrics, pod metrics, and cluster health
- Configure Prometheus as the default data source in Grafana
- Verify dashboards show real-time data (CPU, memory, disk, network)
- **Note:** kube-prometheus-stack ships with several default dashboards — review and customize as needed

#### 2.4 — Create ingress rule for Grafana with TLS

- Create Traefik IngressRoute for `grafana.home.lan` routing to Grafana ClusterIP:3000
- Configure TLS with cert-manager cluster issuer
- Verify Grafana loads in browser with valid TLS

#### 2.5 — Configure basic alerting rules

- Set up alerting rules for common scenarios:
  - Disk space usage > 80%
  - Pod restarts exceeding threshold
  - Node status changes (NotReady, Unknown)
  - High CPU/memory usage on nodes
- Configure Alertmanager to send notifications (email, webhook, or desktop notification)
- Test alerts by triggering a known condition

#### 2.6 — Validate dashboards show real-time data from workstation browser

- Open `https://grafana.home.lan` and verify login works
- Check each dashboard renders graphs with current data
- Verify time range selection and auto-refresh work correctly
- Document any dashboards that need customization

### Phase 3 — Storage & Data Services

**Goal:** Deploy MinIO for S3 storage, backup solution, and container registry mirror

#### Phase 3 Deliverables

| #   | Deliverable         | Description                                            |
| --- | ------------------- | ------------------------------------------------------ |
| 8   | **Backup System**   | Automated PVC backups with retention policy            |
| 11  | **MinIO**           | S3-compatible object storage for backups and artifacts |
| 12  | **Registry Mirror** | Local container image cache for faster deployments     |

#### 3.1 — Deploy MinIO with persistent storage

- Deploy MinIO via Helm or manifest with a PersistentVolumeClaim (10Gi)
- Configure MinIO with admin credentials (store in a Kubernetes secret)
- Create ClusterIP service on port 9000 (API) and 9001 (console)
- **Note:** MinIO provides S3-compatible object storage that will serve as the backup target for Velero and can store application artifacts

#### 3.2 — Create ingress rule for MinIO console with TLS

- Create Traefik IngressRoute for `minio.home.lan` routing to MinIO Console ClusterIP:9001
- Configure TLS with cert-manager cluster issuer
- Verify MinIO console loads in browser with valid TLS

#### 3.3 — Configure MinIO as S3-compatible storage endpoint

- Create a bucket for backups (e.g., `velero-backups`)
- Create a bucket for registry mirror (e.g., `registry-cache`)
- Create access keys for Velero and registry mirror services
- Test S3 API access from workstation using `mc` or AWS CLI

#### 3.4 — Deploy backup solution (Velero or CronJob-based) targeting MinIO

- Evaluate Velero vs CronJob-based backup approach:
  - **Velero:** Full-featured backup/restore for Kubernetes resources and volumes, supports scheduled backups, retention policies, and restores to different namespaces/clusters
  - **CronJob-based:** Simpler approach using `kubectl` commands and `tar`/`restic` for PVC data, less overhead but manual restore process
- Deploy the chosen solution with MinIO as the backup storage target
- Verify the backup solution connects to MinIO successfully

#### 3.5 — Configure backup schedule for all PVCs

- Define backup schedule (e.g., daily at 2 AM for PVCs, weekly for cluster resources)
- Configure retention policy (e.g., keep 7 daily backups, 4 weekly backups)
- Ensure backup jobs have appropriate resource limits
- Test that scheduled backups trigger correctly

#### 3.6 — Perform test backup and restore to validate data integrity

- Trigger a manual backup of a non-critical PVC
- Delete the PVC and its data
- Restore from backup and verify data integrity
- Document the restore procedure for disaster recovery

#### 3.7 — Deploy container registry mirror (via Gitea registry or standalone)

- Evaluate options:
  - **Gitea built-in registry:** Already running, supports container registry as of Gitea 1.19+
  - **Standalone registry mirror:** Deploy `registry:2` with pull-through cache for Docker Hub
- Deploy the chosen option with persistent storage for cached images
- Create ClusterIP service on the registry port

#### 3.8 — Configure containerd on cluster nodes to use local mirror

- Configure `/etc/rancher/k3s/registries.yaml` on each node to point to the local mirror
- Add mirror configuration for `docker.io` (and other registries as needed)
- Restart K3s service to apply registry changes
- Verify image pulls route through the local mirror by pulling a test image and checking mirror logs

### Phase 4 — AI Platform & Developer Tools

**Goal:** Deploy a complete self-hosted AI platform — Ollama for LLM inference, Open WebUI for chat, n8n for workflow automation, Dify for LLM app development, and Headlamp for visual cluster management

#### Phase 4 Deliverables

| #   | Deliverable           | Description                                             |
| --- | --------------------- | ------------------------------------------------------- |
| 3   | **Ollama Service**    | Local LLM API endpoint for avante.nvim integration      |
| 4   | **Open WebUI**        | ChatGPT-like chat interface for Ollama models           |
| 5   | **n8n Automation**    | AI workflow automation platform with Ollama integration |
| 6   | **Dify Platform**     | LLM application development with RAG capabilities       |
| 7   | **Cluster Dashboard** | Headlamp for visual cluster management                  |

#### 4.1 — Deploy Ollama with PVC for model storage

- Create `ollama` namespace
- Deploy Ollama using the official `ollama/ollama` image
- Create a PersistentVolumeClaim (20Gi) for model storage mounted at `/root/.ollama`
- Pin to aconcagua-host via nodeSelector (more CPU cores, won't compete with workstation desktop)
- Set resource requests: 2 CPU, 8Gi memory; limits: 4 CPU, 12Gi memory
- Create ClusterIP service on port 11434

#### 4.2 — Pull and serve quantized models

- Pull initial models via `ollama pull` command (run as init container or post-deploy job):
  - `llama3.2:3b` — fast, general-purpose (~2GB, good for quick tasks)
  - `qwen2.5:7b` — moderate, better reasoning (~4GB, good for coding)
  - `codellama:7b` — code-specific (~4GB, for avante.nvim code assistance)
- Verify models are cached in PVC and survive pod restart
- Test inference with `ollama run llama3.2:3b "hello"`

#### 4.3 — Create ingress rule for Ollama API with TLS

- Create Traefik IngressRoute for `ollama.home.lan` routing to Ollama ClusterIP:11434
- Configure TLS with cert-manager cluster issuer
- Verify TLS certificate is issued and valid

#### 4.4 — Validate Ollama API responds from workstation

- Test from workstation: `curl https://ollama.home.lan/api/tags`
- Verify JSON response lists available models
- Test chat completion: `curl -X POST https://ollama.home.lan/api/chat -d '{"model":"llama3.2:3b","messages":[{"role":"user","content":"hello"}]}'`
- Measure response time for each model

#### 4.5 — Deploy Open WebUI as ChatGPT-like interface for Ollama

- Deploy Open WebUI using the `ghcr.io/open-webui/open-webui` image
- Create PVC (5Gi) for user data and conversation history
- Configure `OLLAMA_BASE_URL` environment variable pointing to Ollama service (`http://ollama.ollama:11434`)
- Set resource requests: 1 CPU, 1Gi memory
- Create ClusterIP service on port 8080
- **Note:** Open WebUI provides a polished ChatGPT-like interface for interacting with Ollama models — useful for experimentation, prompt testing, and non-developer access

#### 4.6 — Create ingress rule for Open WebUI with TLS

- Create Traefik IngressRoute for `openwebui.home.lan` routing to Open WebUI ClusterIP:8080
- Configure TLS with cert-manager cluster issuer
- Verify Open WebUI loads in browser and can chat with Ollama models

#### 4.7 — Deploy n8n for AI workflow automation

- Deploy n8n using the official `n8nio/n8n` image
- Create PVC (5Gi) for workflow data and credentials
- Configure n8n to use PostgreSQL as its database (deploy a lightweight PostgreSQL or reuse existing)
- Set resource requests: 1 CPU, 1Gi memory
- Create ClusterIP service on port 5678
- **Note:** n8n is a low-code workflow automation platform. With Ollama integration, it can power AI-driven automations like:
  - Auto-triage GitHub issues using LLM
  - Generate commit messages from git diffs
  - Summarize CI pipeline failures
  - Route notifications based on log content
  - Automated code review comments

#### 4.8 — Create ingress rule for n8n with TLS

- Create Traefik IngressRoute for `n8n.home.lan` routing to n8n ClusterIP:5678
- Configure TLS with cert-manager cluster issuer
- Verify n8n editor loads in browser

#### 4.9 — Configure n8n to use Ollama as AI provider

- In n8n, add Ollama as a credential (base URL: `http://ollama.ollama:11434`)
- Create test workflow: trigger → Ollama node → respond with model output
- Verify n8n can query Ollama models from within workflows
- Document available models and their capabilities for workflow authors

#### 4.10 — Deploy Dify for LLM application development

- Deploy Dify using the official `langgenius/dify` image stack (API, Worker, Web)
- Deploy required dependencies:
  - PostgreSQL for application data
  - Redis for task queue and caching
  - Weaviate or Qdrant for vector storage (RAG capabilities)
- Create PVCs for Dify storage (10Gi total across components)
- Set resource requests: 2 CPU, 2Gi memory (combined across all Dify components)
- Create ClusterIP services for Dify API (port 5001) and Web (port 3000)
- **Note:** Dify is an LLM application development platform that enables:
  - Building custom AI chatbots with RAG (Retrieval-Augmented Generation)
  - Creating AI assistants with custom tools and knowledge bases
  - Prompt engineering and A/B testing
  - API endpoints for custom AI applications
  - Visual workflow builder for LLM chains

#### 4.11 — Create ingress rule for Dify with TLS

- Create Traefik IngressRoute for `dify.home.lan` routing to Dify Web ClusterIP:3000
- Configure TLS with cert-manager cluster issuer
- Verify Dify loads in browser and can connect to Ollama as LLM provider

#### 4.12 — Configure avante.nvim to use Ollama as secondary AI provider

- Add Ollama provider configuration to `avante.lua`:
  ```lua
  {
    provider = "ollama",
    model = "qwen2.5:7b",
    endpoint = "https://ollama.home.lan/api",
  }
  ```
- Configure fallback behavior: use DeepSeek for complex tasks, Ollama for simple/offline tasks
- Test with a simple code completion request
- Document model selection guidance in avante rules

#### 4.13 — Deploy Headlamp Kubernetes dashboard

- Deploy Headlamp using the official `headlamp-k8s/headlamp` image or Helm chart
- Configure with in-cluster authentication (service account token)
- Create ClusterIP service on port 4466
- Set resource requests: 500m CPU, 256Mi memory

#### 4.14 — Create ingress rule for Headlamp with TLS

- Create Traefik IngressRoute for `headlamp.home.lan` routing to Headlamp ClusterIP:4466
- Configure TLS with cert-manager cluster issuer
- Verify Headlamp loads in browser and shows cluster overview

#### 4.15 — Validate all AI tools accessible from workstation browser

- Verify each service loads with valid TLS:
  - `https://ollama.home.lan/api/tags` — returns model list
  - `https://openwebui.home.lan` — chat interface loads
  - `https://n8n.home.lan` — workflow editor loads
  - `https://dify.home.lan` — app builder loads
  - `https://headlamp.home.lan` — cluster dashboard loads
- Test cross-service integration: n8n workflow → Ollama model → output
- Test Dify app → Ollama model → RAG response
- Document all URLs and credentials

### Phase 5 — Centralized Logging

**Goal:** Deploy Loki + Promtail for centralized log aggregation and search

#### Phase 5 Deliverables

| #   | Deliverable       | Description                                     |
| --- | ----------------- | ----------------------------------------------- |
| 9   | **Logging Stack** | Loki + Promtail for centralized log aggregation |

#### 5.1 — Deploy Grafana Loki via Helm

- Add the grafana Helm repository
- Install Loki chart with simple scalable deployment mode
- Configure retention period and storage settings
- Verify Loki pods are running and ready

#### 5.2 — Deploy Promtail as DaemonSet on all cluster nodes

- Install Promtail via Helm as a DaemonSet
- Configure Promtail to collect container logs from `/var/log/pods/*`
- Set up Kubernetes service discovery for pod metadata
- Verify Promtail pods are running on each node

#### 5.3 — Configure Promtail to collect logs from all pods

- Verify Promtail scrape configs cover all namespaces
- Add structured metadata (namespace, pod name, container name, labels)
- Test log shipping by checking Loki receives entries
- **Note:** Promtail automatically discovers pods via the Kubernetes API — no manual target configuration needed

#### 5.4 — Add Loki as data source in Grafana

- Navigate to Grafana Configuration → Data Sources
- Add Loki with URL `http://loki.monitoring:3100` (or the Loki service endpoint)
- Verify data source is working with "Test" button
- Configure default log query settings (time range, label filters)

#### 5.5 — Create Grafana dashboard for log exploration

- Import or create a Grafana dashboard for log exploration
- Add panels for log volume, log rate, and error count over time
- Configure template variables for namespace and pod filtering
- Verify dashboard shows real-time log data

#### 5.6 — Validate logs from all namespaces are searchable

- Search for known log entries from each namespace (gitea, woodpecker, argocd, etc.)
- Verify log timestamps, labels, and content are correct
- Test LogQL queries with label filters and regex patterns
- Document any namespaces with missing log data

### Phase 6 — Dotfiles Integration

**Goal:** Create workstation integration points — Neovim tools, SSH scripts, bash aliases, avante rules

#### Phase 6 Deliverables

| #   | Deliverable              | Description                                                        |
| --- | ------------------------ | ------------------------------------------------------------------ |
| 13  | **Dotfiles Integration** | Neovim tools, SSH port-forward scripts, bash aliases, avante rules |

#### 6.1 — Create bash aliases for common cluster operations

- Add aliases for `k9s`, `kubectx`, `kubens`, and port-forward helpers
- Create convenience commands for common kubectl operations
- Add tab completion for cluster-related commands
- Test all aliases from a fresh shell session

#### 6.2 — Create SSH port-forward script for quick access to cluster services

- Create a script that sets up SSH port-forwards to cluster services
- Support for common services (Grafana, ArgoCD, Gitea, etc.)
- Allow specifying custom local ports and remote services
- Add to bash aliases for quick invocation

#### 6.3 — Update avante rules with cluster context for AI-assisted management

- Add cluster architecture and service information to avante rules
- Document common kubectl commands and patterns
- Include troubleshooting guidance for cluster issues
- Reference the project plan for implementation context

#### 6.4 — Create Neovim commands/telescope extension for pod log viewing

- Create a telescope extension for browsing and viewing pod logs
- Support for namespace filtering, pod selection, and log tailing
- Add keybindings for quick access to cluster operations
- Integrate with existing Neovim configuration patterns

#### 6.5 — Update `.avante/context/` with cluster architecture documentation

- Add cluster infrastructure details to ARCHITECTURE.md
- Document service URLs, credentials, and access patterns
- Include network topology and service dependency diagrams
- Reference the project plan for detailed implementation notes

#### 6.6 — Test all integration points from workstation

- Verify bash aliases work from terminal
- Test SSH port-forward script with each service
- Validate avante rules provide useful cluster context
- Confirm telescope extension shows pod logs correctly

### Phase 7 — Polish & Hardening

**Goal:** Final testing, security review, documentation, and cleanup

#### 7.1 — Perform integration testing across all services

- Test each service works with its dependencies (e.g., Grafana queries Prometheus and Loki)
- Verify cross-service communication (e.g., n8n workflow → Ollama model)
- Test ingress routing for all `*.home.lan` hostnames
- Document any integration issues and resolve them

#### 7.2 — Review and tighten resource limits/requests on all deployments

- Audit all deployments for appropriate resource requests and limits
- Adjust based on observed usage patterns from monitoring data
- Remove any unused or over-provisioned resources
- Document resource allocation decisions

#### 7.3 — Verify TLS on all ingress endpoints

- Check each `*.home.lan` endpoint for valid TLS certificate
- Verify certificate expiry dates and auto-renewal is configured
- Test TLS 1.2/1.3 support and disable weak cipher suites
- Document certificate management procedures

#### 7.4 — Clean up unused NodePort service exposure where ingress is active

- Identify services with both ingress and NodePort exposure
- Convert NodePort services to ClusterIP where ingress handles routing
- Remove any temporary port-forward or test services
- Verify no unnecessary ports are exposed on node IPs

#### 7.5 — Document all service URLs, credentials, and maintenance procedures

- Create a service inventory with URLs, ports, and access methods
- Document default credentials and how to change them
- Write maintenance procedures for common tasks (restart, upgrade, backup)
- Store documentation in `.avante/context/` for AI-assisted access

#### 7.6 — Update `.avante/context/ARCHITECTURE.md` with cluster infrastructure details

- Add cluster topology and service architecture to ARCHITECTURE.md
- Document network configuration (MetalLB pool, ingress IPs, DNS setup)
- Include service dependency graph and data flow diagrams
- Reference the project plan for detailed implementation notes

#### 7.7 — Final validation against all success criteria

- Review each success criterion from the project overview
- Verify all validation requirements are met
- Run final integration test suite
- Mark project as complete if all criteria are satisfied

### Phase 8 — Network DNS Management

**Goal:** Create a network-first DNS management solution for `*.home.lan` resolution that works across all devices on the LAN, not just individual workstations

**Prerequisite:** Investigate router (192.168.1.2) capabilities — determine if it supports custom DNS entries, custom DNS server forwarding, or DHCP DNS option configuration

#### 8.1 — Investigate router DNS capabilities

- Determine if router supports static DNS entries for `*.home.lan`
- Determine if router supports custom upstream DNS server (for pointing to a cluster-hosted DNS)
- Determine if router DHCP can be configured to hand out a custom DNS server address
- Document findings and choose the best approach

#### 8.2 — Design the DNS architecture

- **Primary (network-level):** Deploy a DNS server on the cluster (dnsmasq or CoreDNS) exposed via MetalLB, configure router to use it as DNS server or forward `*.home.lan` queries to it
- **Fallback (workstation-only):** `/etc/hosts` management for machines that can't use the network DNS
- Auto-discover K8s services with ingress annotations and generate DNS entries dynamically
- Support for static DNS entries (non-K8s services, manual overrides)

#### 8.3 — Deploy cluster DNS server

- Deploy dnsmasq or CoreDNS as a cluster service with `*.home.lan` zone configuration
- Expose via MetalLB LoadBalancer on a static LAN IP (e.g., 192.168.1.200)
- Configure automatic zone file generation from K8s ingress annotations
- Set up health checks and monitoring

#### 8.4 — Configure router to use cluster DNS

- Option A: Set router's DNS server to the cluster DNS IP (if router supports custom DNS)
- Option B: Configure router DHCP option 6 (DNS server) to hand out cluster DNS IP to all DHCP clients
- Option C: Configure router to forward `*.home.lan` queries to cluster DNS IP
- Verify DNS resolution works from multiple devices on the LAN

#### 8.5 — Create CLI tool for DNS management

- `dns-add <service.home.lan> <ip>` — Add/update DNS entry
- `dns-remove <service.home.lan>` — Remove DNS entry
- `dns-list` — List all managed DNS entries
- `dns-sync` — Sync K8s ingress annotations to DNS config
- `dns-watch` — Watch mode for live updates from K8s
- Support for both cluster DNS server and `/etc/hosts` backends

#### 8.6 — Create bash aliases and shell completion

- `dns-add`, `dns-remove`, `dns-list`, `dns-sync`, `dns-watch` commands
- Tab completion for service names
- Integration with existing SSH scripts and kubectl context

#### 8.7 — Create avante.nvim custom tool for DNS management

- Allow AI-assisted DNS entry management
- Integrate with cluster context from avante rules

#### 8.8 — Document the DNS solution

- Architecture overview (network DNS vs workstation fallback)
- Router configuration instructions for different router types
- CLI tool usage examples
- Troubleshooting guide for DNS resolution issues
- How to add new services to DNS automatically

#### 8.9 — Test end-to-end

- Verify DNS resolution from multiple devices (phone, laptop, other machines)
- Verify DNS survives cluster pod restarts
- Verify new K8s services with ingress annotations are auto-discovered
- Test fallback `/etc/hosts` mode when network DNS is unavailable

### Phase 9 — Browser Automation & Testing

**Goal:** Deploy Playwright MCP Server for AI-driven browser automation and create a Python-based browser testing framework for cluster services

#### 9.1 — Research and select browser automation tools

- Evaluate **Playwright MCP Server** for AI-driven browser control (avante.nvim integration)
- Evaluate **Playwright Python** (`playwright` package) for automated test suites
- Evaluate alternatives: Selenium, Puppeteer, Cypress — confirm if Playwright is the best fit
- Document findings and recommendations for the chosen approach

#### 9.2 — Set up Playwright Python development environment

- Create Python virtual environment or dev container
- Install `playwright` package and browser binaries (Chromium, Firefox, WebKit)
- Create project structure for test suites
- Verify browser binaries launch correctly from the development environment

#### 9.3 — Deploy Playwright MCP Server

- Run as a local service or container on the workstation
- Configure MCP server to connect to cluster services via `*.home.lan`
- Integrate with avante.nvim as an MCP tool for AI-driven browser testing
- Verify the MCP server can navigate to cluster URLs and take screenshots
- **Note:** The MCP server enables AI-driven browser automation — avante.nvim can instruct the server to navigate pages, fill forms, take screenshots, and verify content, all from within Neovim

#### 9.4 — Create browser test suites for cluster services

- **Smoke tests**: Verify each service loads (Grafana, ArgoCD, Gitea, Woodpecker, Headlamp, MinIO)
- **Auth tests**: Test login flows for services with authentication
- **Navigation tests**: Verify key workflows (e.g., create repo in Gitea, trigger pipeline in Woodpecker)
- **Responsive tests**: Verify UI renders correctly at different viewport sizes
- Organize tests into reusable modules for maintainability

#### 9.5 — Create avante.nvim custom tool for test execution

- Allow AI to trigger specific test suites via natural language
- Return test results and screenshots to the AI context
- Enable "test this service" workflow from within Neovim
- Integrate with existing avante.nvim custom tool patterns

#### 9.6 — Create bash aliases and shell completion

- `test-smoke`, `test-auth`, `test-all` commands
- `test-service <name>` for targeted testing
- `test-screenshot <service>` for quick visual verification
- Tab completion for service names and test suites

#### 9.7 — Integrate with Woodpecker CI

- Create CI pipeline that runs browser tests against the cluster
- Generate test reports and screenshots as CI artifacts
- Configure webhook triggers for automated testing on deploy
- Fail the pipeline if critical tests fail

#### 9.8 — Document the testing framework with usage examples and troubleshooting

- Write comprehensive documentation covering setup, usage, and troubleshooting
- Include examples for common testing workflows
- Document how to add new test suites and services

### Phase 10 — Load Testing with Locust

**Goal:** Deploy Locust for Python-based load testing with simulated user traffic and real-time metrics UI

#### 10.1 — Research and plan Locust test scenarios

- Identify critical service endpoints to load test (Grafana, Gitea, Woodpecker, Ollama API)
- Define user behavior patterns (browsing, API calls, concurrent sessions)
- Determine performance baselines and acceptable thresholds
- Document findings and test scenario designs

#### 10.2 — Set up Locust development environment

- Create Python virtual environment or dev container
- Install `locust` package
- Create project structure for test scenarios
- Verify Locust web UI launches correctly

#### 10.3 — Write Locust test scenarios for cluster services

- **Web UI scenarios**: Simulate user browsing Grafana dashboards, navigating Gitea repos, triggering Woodpecker pipelines
- **API scenarios**: Simulate concurrent API calls to Ollama, ArgoCD, and service endpoints
- **Auth scenarios**: Simulate login flows under load
- **Mixed workloads**: Combine multiple user types in a single test run
- Organize scenarios into reusable modules for maintainability

#### 10.4 — Deploy Locust in distributed mode

- Run Locust web UI locally or as a container on the workstation
- Configure worker nodes for distributed load generation (optional, for higher concurrency)
- Set up headless mode for CI/CD integration
- Verify metrics collection and real-time reporting

#### 10.5 — Create bash aliases and shell completion

- `load-test-web`, `load-test-api`, `load-test-all` commands
- `load-test <scenario> --users 100 --spawn-rate 10` for custom runs
- `load-test-report` to open the latest test report
- Tab completion for test scenarios and parameters

#### 10.6 — Create avante.nvim custom tool for load testing

- Allow AI to trigger load test scenarios via natural language
- Return test results (RPS, error rate, percentiles) to the AI context
- Enable "load test this service" workflow from within Neovim
- Integrate with existing avante.nvim custom tool patterns

#### 10.7 — Integrate with Woodpecker CI

- Create CI pipeline that runs load tests against the cluster on deploy
- Fail the pipeline if performance thresholds are breached
- Generate HTML reports as CI artifacts
- Configure webhook triggers for automated load testing

#### 10.8 — Document the load testing framework with usage examples and troubleshooting

- Write comprehensive documentation covering setup, usage, and troubleshooting
- Include examples for common load testing workflows
- Document how to add new test scenarios and services
- Provide guidance on interpreting test results and setting performance baselines

## Resources

### Infrastructure Requirements

- **Compute Resources:**
  - aconcagua-host (control-plane): 16GB RAM, 4 vCPUs — runs system pods + monitoring
  - geoff-workstation (worker): 16GB RAM, 4 vCPUs — runs AI workloads + data services
- **Storage:** local-path storage class (rancher.io/local-path) — ~200GB available across both nodes
- **Network:** 192.168.1.0/24 LAN, MetalLB pool: 192.168.1.200-192.168.1.220

### Development Environment

- **Hardware:** Local Arch Linux workstation (Hyprland, Wayland)
- **Software/Tools:** kubectl, Helm, k9s, Neovim, avante.nvim
- **Development Stack:** YAML/Helm charts, Lua (Neovim), Bash (scripts)

### Budget and Costs

- **Infrastructure Costs:** $0 (all local hardware)
- **Service Costs:** $0 (no cloud services)
- **Total Budget:** $0 (time only)

### External Services

- **APIs:** DeepSeek API (existing, for avante.nvim remote AI)
- **Container Images:** Docker Hub, quay.io, ghcr.io (for pulling Helm chart images)

## Validation and Testing

### Validation Requirements

- [ ] **Ingress Validation**: Each service accessible via `https://service.home.lan` from workstation browser
  - **Method:** Open browser to each service URL
  - **Success:** All services return 200 with valid TLS
- [ ] **Monitoring Validation**: Grafana dashboards show real-time cluster metrics
  - **Method:** Check Grafana for node/pod metrics
  - **Success:** CPU, memory, disk, network graphs rendering
- [ ] **Ollama Validation**: API responds with model list
  - **Method:** `curl http://ollama.home.lan/api/tags`
  - **Success:** Returns JSON with available models
- [ ] **Backup Validation**: PVC data can be restored from backup
  - **Method:** Perform test restore to a temp PVC
  - **Success:** Data integrity verified after restore
- [ ] **Logging Validation**: Logs from all namespaces searchable
  - **Method:** Search for known log entries in Grafana/Loki
  - **Success:** Logs from each namespace appear in search results
- [ ] **MetalLB Validation**: LoadBalancer services get IPs from configured pool
  - **Method:** Check service status with `kubectl get svc`
  - **Success:** Services show EXTERNAL-IP in 192.168.1.200-220 range
- [ ] **MinIO Validation**: Can upload/download objects via S3 API
  - **Method:** Use `mc` or AWS CLI to put/get an object
  - **Success:** Object uploads and downloads with correct content
- [ ] **Registry Mirror Validation**: Container pulls route through local mirror
  - **Method:** Pull an image and check mirror logs
  - **Success:** Mirror cache hit logged

### Testing Requirements

- **Integration Testing:** Each service works with its dependencies (e.g., Grafana queries Prometheus and Loki)
- **Failure Testing:** Simulate node failure, pod restart, PVC loss — verify recovery
- **Performance Testing:** Monitor resource usage after all services deployed
- **Security Testing:** Verify TLS certificates, no exposed ports on NodePort after ingress

## Risks and Issues

### Key Risks

1. **Resource Constraints**: 32GB total RAM across both nodes may be tight with all services
   - **Impact:** Medium
   - **Mitigation:** Prioritize essential services, use resource limits/requests, monitor usage

2. **Storage Capacity**: local-path storage uses node-local disk, no replication
   - **Impact:** High
   - **Mitigation:** Regular backups, monitor disk usage, consider adding external storage

3. **Single Control Plane**: No HA for control plane (single node)
   - **Impact:** Medium
   - **Mitigation:** Acceptable for home lab, backups mitigate data loss risk

4. **Ollama Performance**: CPU-only inference may be slow on these nodes
   - **Impact:** Low-Medium
   - **Mitigation:** Use smaller quantized models, accept slower responses for local AI

5. **Network Complexity**: Multiple services on home LAN may cause confusion
   - **Impact:** Low
   - **Mitigation:** Document all service URLs, use consistent naming scheme

### Current Issues

1. **ArgoCD LoadBalancer Pending**: `svclb-argocd-server` pods stuck in Pending due to no LoadBalancer provider
   - **Status:** Open
   - **Next Steps:** MetalLB deployment will resolve this

## Notes

- All infrastructure is local — no cloud costs involved
- MetalLB IP pool should avoid DHCP range (192.168.1.100-199 is likely DHCP)
- Ollama models should be small quantized versions for CPU-only inference
- Consider using Gitea's built-in container registry instead of a separate registry mirror
- DNS can be handled via `/etc/hosts` on the workstation initially, with proper DNS later
- **AI Platform Resource Estimate**: Ollama (~8-12GB), Open WebUI (~1GB), n8n (~1GB + PostgreSQL), Dify (~2-4GB + PostgreSQL + Redis + vector DB), Headlamp (~256MB) — total ~12-18GB RAM for the full AI stack. With 32GB total across both nodes, this is feasible but will be the largest consumer of cluster resources
- **n8n vs Dify**: n8n is a general workflow automation tool that happens to have AI nodes — good for automating processes that involve LLM calls. Dify is purpose-built for LLM application development with RAG, prompt management, and API endpoints — good for building custom AI apps. They complement each other rather than overlap
- **Open WebUI vs Dify**: Open WebUI is a ChatGPT replacement for chatting with models. Dify is for building custom AI applications. Both can use Ollama as their LLM backend

## Revision History

| Version | Date       | Changes                                                                                                                                                  |
| ------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.0     | 2026-05-04 | Initial version — full project plan for K3s infrastructure upgrade                                                                                       |
| 1.1     | 2026-05-04 | Expanded Phase 4 with Open WebUI, n8n, Dify; added h4 headings for each step; updated scope, deliverables, dependencies, and notes                       |
| 1.2     | 2026-05-04 | Standardized all phases to detailed h4 format; added Phases 9 (Browser Automation) and 10 (Load Testing); updated TOC with sub-items for Phases 4, 9, 10 |

---

_This project plan document should be updated as the project evolves. Keep it current to reflect the actual project status._
