# DIEVOPS Architecture

## Infrastructure Overview
```mermaid
graph TD
    subgraph "Developer Workflow"
        Dev["Developer"]
        GitPush["Git Push/PR"]
    end

    subgraph "GitHub Actions"
        GHA["GitHub Actions Workflow"]
        TFFormat["Terraform Format"]
        TFValidate["Terraform Validate"]
        TFPlan["Terraform Plan"]
        TFApply["Terraform Apply"]
    end

    subgraph "Terraform Cloud"
        TFC["Terraform Cloud"]
        State["State Management"]
        VarMgmt["Variable Management"]
    end

    subgraph "Google Cloud Platform"
        GCP["GCP Project: dievops-dev"]
        subgraph "Network Layer"
            VPC["VPC Network"]
            Subnets["Subnets"]
        end
        subgraph "Kubernetes Layer"
            GKE["GKE Cluster"]
            Gateway["Gateway API"]
        end
    end

    Dev -->|"Push Code"| GitPush
    GitPush -->|"Trigger"| GHA
    GHA --> TFFormat
    TFFormat --> TFValidate
    TFValidate --> TFPlan
    TFPlan -->|"PR Comment"| GitPush
    TFPlan -->|"If main branch"| TFApply

    TFApply -->|"Execute"| TFC
    TFC -->|"Manage"| State
    TFC -->|"Use"| VarMgmt
    TFC -->|"Apply Changes"| GCP

    GCP --> VPC
    VPC --> Subnets
    Subnets --> GKE
    GKE --> Gateway
```

## Deployment Flow
```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant GHA as GitHub Actions
    participant TFC as Terraform Cloud
    participant GCP as Google Cloud

    Dev->>GH: Push Code/Create PR
    GH->>GHA: Trigger Workflow
    
    alt PR
        GHA->>TFC: Run Terraform Plan
        TFC-->>GHA: Return Plan
        GHA->>GH: Comment Plan on PR
    else Main Branch
        GHA->>TFC: Run Terraform Apply
        TFC->>GCP: Apply Infrastructure Changes
        GCP-->>TFC: Return Status
        TFC-->>GHA: Return Apply Status
        GHA-->>GH: Update Status
    end

    Note over GCP: Infrastructure Updates<br/>1. Network<br/>2. GKE Cluster<br/>3. Gateway API
```

## How to View These Diagrams

1. **GitHub Rendering**: 
   - GitHub natively renders Mermaid diagrams in markdown files
   - Simply view this file in the GitHub repository

2. **Local Viewing**:
   - Use VS Code with the Mermaid extension
   - Or visit [Mermaid Live Editor](https://mermaid.live) and paste the diagram code

3. **Documentation Updates**:
   - These diagrams are maintained in `docs/architecture.md`
   - Update them when making architectural changes
   - Include the diagram updates in your PRs 