#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# VALORES ESPECÍFICOS DE TU ENTORNO - Configura via variables de entorno
###############################################################################
PROJECT_ID=${PROJECT_ID:-""}          # ID del proyecto GCP
SA_TF=${SA_TF:-"terraform-gcp-admin"} # SA para Terraform
SA_CI=${SA_CI:-"ci-deployer"}        # SA para CI/CD

# Validar que PROJECT_ID esté configurado
if [ -z "$PROJECT_ID" ]; then
    echo "❌ Error: PROJECT_ID no está configurado"
    echo "Configura la variable de entorno PROJECT_ID antes de ejecutar este script"
    exit 1
fi
###############################################################################

echo "💠 Usando proyecto $PROJECT_ID"
gcloud config set project "$PROJECT_ID" >/dev/null

# Roles para terraform-gcp-admin
TF_ROLES=(
    "roles/container.admin"
    "roles/compute.networkAdmin"
    "roles/artifactregistry.admin"
    "roles/storage.admin"
    "roles/iam.serviceAccountTokenCreator"
    "roles/iam.serviceAccountUser"
    "roles/iam.serviceAccountAdmin"
    "roles/iam.workloadIdentityUser"
    "roles/resourcemanager.projectIamAdmin"
    "roles/run.admin"
)

# Roles para ci-deployer
CI_ROLES=(
    "roles/cloudbuild.builds.editor"
    "roles/clouddeploy.releaser"
    "roles/artifactregistry.writer"
    "roles/storage.objectViewer"
    "roles/iam.serviceAccountTokenCreator"
)

# Función para asignar roles a una Service Account
assign_roles() {
    local sa_name=$1
    shift
    local roles=("$@")
    
    echo "🔑 Asignando roles a $sa_name@${PROJECT_ID}.iam.gserviceaccount.com:"
    for role in "${roles[@]}"; do
        echo "  • $role"
        gcloud projects add-iam-policy-binding "$PROJECT_ID" \
            --member="serviceAccount:${sa_name}@${PROJECT_ID}.iam.gserviceaccount.com" \
            --role="$role" \
            --condition=None >/dev/null
    done
    echo "✅ Roles asignados correctamente a $sa_name"
    echo
}

# Asignar roles a terraform-gcp-admin
echo "🚀 Configurando permisos para Terraform Service Account..."
assign_roles "$SA_TF" "${TF_ROLES[@]}"

# Asignar roles a ci-deployer
echo "🚀 Configurando permisos para CI/CD Service Account..."
assign_roles "$SA_CI" "${CI_ROLES[@]}"

echo "🎉 Configuración de roles completada con éxito!"
echo
echo "📝 Resumen de roles asignados:"
echo
echo "terraform-gcp-admin:"
printf "  • %s\n" "${TF_ROLES[@]}"
echo
echo "ci-deployer:"
printf "  • %s\n" "${CI_ROLES[@]}" 