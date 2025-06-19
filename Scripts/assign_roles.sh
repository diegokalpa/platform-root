#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# VALORES ESPECÍFICOS DE TU ENTORNO
###############################################################################
PROJECT_ID="dievops-dev"          # ID del proyecto GCP
SA_TF="terraform-gcp-admin"       # SA para Terraform
SA_CI="ci-deployer"              # SA para CI/CD
###############################################################################

echo "💠 Usando proyecto $PROJECT_ID"
gcloud config set project "$PROJECT_ID" >/dev/null

# Roles para terraform-gcp-admin
TF_ROLES=(
    "roles/container.admin"
    "roles/compute.networkAdmin"
    "roles/artifactregistry.admin"
)

# Roles para ci-deployer
CI_ROLES=(
    "roles/cloudbuild.builds.editor"
    "roles/clouddeploy.releaser"
    "roles/artifactregistry.writer"
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