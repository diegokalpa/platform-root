# DIEVOPS Platform

Infraestructura como código para GCP usando Terraform Cloud y Cloud Run.

## 🚀 Inicio Rápido

1. **Configurar variables**:
   ```bash
   cp Scripts/config.env.example Scripts/config.env
   nano Scripts/config.env  # Editar con tus valores
   ```

2. **Ejecutar scripts**:
   ```bash
   ./Scripts/workload_identity.sh
   ./Scripts/assign_roles.sh
   ```

3. **Desplegar infraestructura**:
   ```bash
   cd infra-gcp/envs/dev
   terraform init
   terraform apply
   ```

## 📁 Estructura

```
platform-root/
├── infra-gcp/envs/dev/     # Entorno de desarrollo
├── Scripts/                # Scripts de configuración
└── docs/                   # Documentación
```

## 🔧 Configuración

- **Proyecto GCP**: `dievops-dev`
- **Región**: `us-central1`
- **Aplicación**: n8n en Cloud Run

## 📋 Prerequisitos

- Google Cloud SDK
- Terraform CLI
- Cuenta en Terraform Cloud 