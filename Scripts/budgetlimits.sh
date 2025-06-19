# Script para controlar el Budget de GCP (ejecutar en terminal)

# Variables
PROJECT_ID="dievops-dev"
BILLING_ID="01905E-3C9524-D69BCF"

# Crea proyecto y vincúlalo a la cuenta de facturación
gcloud projects create $PROJECT_ID --name="Dev Platform"
gcloud beta billing projects link $PROJECT_ID \
  --billing-account=$BILLING_ID


  gcloud billing budgets create \
  --display-name="GKE Guardrail" \
  --billing-account=$BILLING_ID \
  --budget-amount=25USD \
  --threshold-rule=0.5 \
  --threshold-rule=1.0

# habilitar APIS basicas

gcloud services enable \
  container.googleapis.com \
  compute.googleapis.com \
  iam.googleapis.com \
  artifactregistry.googleapis.com \
  cloudbuild.googleapis.com \
  clouddeploy.googleapis.com
