# HiveMQ Cloud SRE Guide

## Overview
This document provides context and guidelines for Claude AI assistant when working with HiveMQ Cloud infrastructure and processes.

## HiveMQ Cloud Terminology

### Core Components
- **hivemq broker**: HiveMQ MQTT broker instance
- **hive**: A cloud deployment of the HiveMQ broker
- **hiveid**: UUIDv4 identifier for hive (e.g., `4605c8ef-8fa6-4205-9cab-e1fb30e41988`)
- **apiary**: Kubernetes cluster (EKS/GKE/AKS) hosting hives
- **cloud deployment**: Either apiary or hive
- **apiary apps**: Apiary-supporting applications, like `apiary-agent` or `apiary-gw`
- **Control Center**: Web interface to HiveMQ broker
- **hive name**: Human-readable name for hive, used in URLs

### Deployment Types
- **starter hive**: Hive on multitenant apiary following "Starter" product specs
- **professional hive**: Hive on multitenant apiary following "Professional" product specs
- **serverless**: Cloud-based multitenant HiveMQ broker instance
- **enterprise/dedicated**: Single-tenant apiary hosting customer's hive exclusively

### Apiary Classifications
- **starter apiary**: Hosts starter hives
  - Label: `apiary-<apiary_id>-<env>-<region>` (e.g., `apiary-a01-prod-eu-central-1`)
- **professional apiary**: Hosts professional hives (similar naming to starter)
- **shared apiary**: `shared-1` or `shared-2` - serverless deployments or multitenant apiaries
- **PoC apiary**: Dedicated for customer proof-of-concept hives
  - Examples: `shared-poc01-aws-prod-eu-central-1`, `shared-poc01-azure-prod-germanywestcentral`
- **enterprise/dedicated apiary**: Customer-specific deployment
  - Label: `<customer>-<env>-<region>` (e.g., `afklm-prod-francecentral`, `bmw-prod-eu-central-1`)

## URL Patterns
- **Control Center**: URLs starting with `cc-` (e.g., `https://cc-dev-853dcbbd.28fc11.cac.az.hivemq.cloud/`)
- **Hive MQTT Service**: `<hive_name>-<random>.<random>.<region_abbrev>.<cloud_abbrev>.hivemq.cloud`
- **Serverless**: `<random>.<s1|s2>.eu.hivemq.cloud`

## Repository Structure
- **Location**: Most deployments have a dedicated repo in the [hivemq-cloud](https://github.com/hivemq-cloud) GitHub organization. We're slowly transitioning to the [apiaries](https://github.com/hivemq-cloud/apiaries) monorepo.
- **Naming**: Repositories include customer name or apiary identifier
  - Examples: `deployment-afklm`, `deployment-apiary-a01`

### Hive Configuration Structure
- **Hive Declarations**: Located at `deployments/<cloud_provider>/<deployment_label>/k8s/apiary/apps/values.yaml`
  - Example: `deployments/azure/shared-poc01-azure-prod-germanywestcentral/k8s/apiary/apps/values.yaml`
- **Individual Hive Values**: Parse hive declarations to locate specific hive configuration files
- **Pattern**: Configuration follows structured path within apiary repository

## Documentation
- **HiveMQ**: https://docs.hivemq.com/hivemq/latest/user-guide/index.html
- **HiveMQ REST APIs**:
  - https://docs.hivemq.com/hivemq/latest/rest-api/index.html
  - https://docs.hivemq.com/hivemq/latest/rest-api/specification/index.html
- **HiveMQ Cloud**: https://docs.hivemq.com/hivemq-cloud/index.html
- **HiveMQ Cloud REST APIs**:
  - https://docs.hivemq.com/hivemq-cloud/rest-api.html
  - https://docs.hivemq.com/hivemq-cloud/rest-api/specification/
