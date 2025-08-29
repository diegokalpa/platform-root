#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# VALORES ESPECÍFICOS DE TU ENTORNO
###############################################################################
# Load configuration from config.env if it exists
if [ -f "config.env" ]; then
    echo "📁 Loading configuration from config.env..."
    source config.env
else
    echo "⚠️  config.env not found. Using default values or environment variables."
    echo "   Copy config.env.example to config.env and configure your values."
fi

# Fallback to environment variables or defaults
PROJECT_ID=${PROJECT_ID:-"dievops-dev"}
GITHUB_USER=${GITHUB_USER:-"diegokalpa"}
REPO_NAME=${REPO_NAME:-"platform-root"}
POOL_ID=${POOL_ID:-"ci-pool"}
PROVIDER_ID=${PROVIDER_ID:-"github"}
###############################################################################

# ─────────────────────────────────────────────────────────────────────────────
# No modifiques nada a partir de aquí
# ─────────────────────────────────────────────────────────────────────────────
REPO_REF="repo:${GITHUB_USER}/${REPO_NAME}"
SA_TF="terraform-gcp-admin"
SA_CI="ci-deployer"

echo "💠  Usando proyecto $PROJECT_ID"
gcloud config set project "$PROJECT_ID" >/dev/null

# 1. Workload Identity Pool
if ! gcloud iam workload-identity-pools describe "$POOL_ID" --location=global &>/dev/null; then
  echo "🚀  Creando pool '$POOL_ID'..."
  gcloud iam workload-identity-pools create "$POOL_ID" \
      --location=global \
      --display-name="CI/OIDC Pool"
else
  echo "✅  Pool '$POOL_ID' ya existe."
fi

# 2. Provider OIDC con mapeos completos
MAPPING="google.subject=assertion.sub,google.groups=assertion.repository"
ATTRIBUTE_CONDITION="assertion.repository=='${GITHUB_USER}/${REPO_NAME}'"

if ! gcloud iam workload-identity-pools providers describe "$PROVIDER_ID" \
        --workload-identity-pool="$POOL_ID" --location=global &>/dev/null; then
  echo "🚀  Creando provider '$PROVIDER_ID'..."
  gcloud iam workload-identity-pools providers create-oidc "$PROVIDER_ID" \
      --workload-identity-pool="$POOL_ID" --location=global \
      --display-name="GitHub" \
      --issuer-uri="https://token.actions.githubusercontent.com" \
      --attribute-mapping="$MAPPING" \
      --attribute-condition="$ATTRIBUTE_CONDITION"
else
  echo "✅  Provider '$PROVIDER_ID' ya existe; actualizando mapeos..."
  gcloud iam workload-identity-pools providers update-oidc "$PROVIDER_ID" \
      --workload-identity-pool="$POOL_ID" --location=global \
      --attribute-mapping="$MAPPING" \
      --attribute-condition="$ATTRIBUTE_CONDITION"
fi

# 3. Service Accounts
for sa in "$SA_TF" "$SA_CI"; do
  if ! gcloud iam service-accounts describe "${sa}@${PROJECT_ID}.iam.gserviceaccount.com" &>/dev/null; then
    echo "🚀  Creando Service Account $sa ..."
    gcloud iam service-accounts create "$sa" --display-name="$sa"
  else
    echo "✅  Service Account $sa ya existe."
  fi
done

# 4. Bindings principalSet://
PROJECT_NUM=$(gcloud projects describe "$PROJECT_ID" --format='value(projectNumber)')
POOL_FQN="projects/$PROJECT_NUM/locations/global/workloadIdentityPools/$POOL_ID"
BIND_MEMBER="principalSet://iam.googleapis.com/${POOL_FQN}/attribute.repository/${REPO_REF}"

for sa in "$SA_TF" "$SA_CI"; do
  POLICY=$(gcloud iam service-accounts get-iam-policy "${sa}@${PROJECT_ID}.iam.gserviceaccount.com" \
           --format="text(bindings[].members)")
  if ! grep -q "$BIND_MEMBER" <<< "$POLICY"; then
    echo "🚀  Añadiendo binding WorkloadIdentityUser a $sa ..."
    gcloud iam service-accounts add-iam-policy-binding "${sa}@${PROJECT_ID}.iam.gserviceaccount.com" \
      --member="$BIND_MEMBER" \
      --role="roles/iam.workloadIdentityUser" >/dev/null
  else
    echo "✅  Binding ya existe para $sa."
  fi
done

# 5. Salida para Secrets de GitHub
PROVIDER_FQN="$POOL_FQN/providers/$PROVIDER_ID"
cat <<EOF

🎉  Workload Identity Federation configurada con éxito.

👉  Copia estos valores en GitHub » Settings » Secrets and variables » Actions:

   • GCP_WORKLOAD_PROVIDER      = $PROVIDER_FQN
   • GCP_SERVICE_ACCOUNT_INFRA  = ${SA_TF}@${PROJECT_ID}.iam.gserviceaccount.com
   • GCP_SERVICE_ACCOUNT_CONFIG = ${SA_CI}@${PROJECT_ID}.iam.gserviceaccount.com

EOF 