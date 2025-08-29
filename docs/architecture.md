# Arquitectura

## Flujo Simple

```
Desarrollador → GitHub → GitHub Actions → Terraform Cloud → GCP
```

## Componentes

- **GitHub Actions**: CI/CD automático
- **Terraform Cloud**: Gestión de estado
- **GCP**: Infraestructura (Cloud Run, Secret Manager)
- **Workload Identity**: Autenticación segura

## Aplicaciones

- **n8n**: Automatización de workflows
- **Base de datos**: Supabase (PostgreSQL)
- **Secretos**: Google Secret Manager 