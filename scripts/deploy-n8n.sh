#!/usr/bin/env bash
# Despliega (o actualiza) n8n en el cluster K3s con el chart local helm/n8n,
# tomando endpoints y credenciales de los outputs de Terraform del workspace
# activo. Basado en scripts/deploy-n8n.sh del proyecto Seminario.
#
# Requisitos:
#   - terraform apply ya ejecutado en el workspace (dev, ...)
#   - helm y kubectl en el PATH
#   - kubeconfig-<workspace>.yaml descargado del master en la raiz del proyecto
#
# Uso (desde Git Bash, en la raiz del proyecto):
#   ./scripts/deploy-n8n.sh [args adicionales para helm upgrade]
set -euo pipefail

cd "$(dirname "$0")/.."

WORKSPACE="$(terraform workspace show)"
if [ "$WORKSPACE" = "default" ]; then
  echo "ERROR: selecciona el workspace del ambiente (ej: terraform workspace select dev)." >&2
  exit 1
fi

# En Git Bash, kubectl/helm son binarios de Windows: necesitan la ruta en formato C:/...
ROOT="$(pwd -W 2>/dev/null || pwd)"
export KUBECONFIG="${KUBECONFIG:-$ROOT/kubeconfig-${WORKSPACE}.yaml}"
if [ ! -f "$KUBECONFIG" ]; then
  echo "ERROR: no existe $KUBECONFIG. Descargalo del master con ssh (ver README del curso)." >&2
  exit 1
fi

for bin in helm kubectl terraform; do
  command -v "$bin" >/dev/null || { echo "ERROR: falta '$bin' en el PATH." >&2; exit 1; }
done

NAMESPACE="${NAMESPACE:-n8n}"
RELEASE="${RELEASE:-n8n}"
SECRET_NAME="n8n-secrets"

tf_out() { terraform output -raw "$1"; }

echo "Workspace: $WORKSPACE | kubeconfig: $KUBECONFIG | namespace: $NAMESPACE"

# 1. Namespace (se crea solo si no existe)
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

# 2. Credenciales en un Secret de Kubernetes (no en values ni en el historial de Helm)
kubectl -n "$NAMESPACE" create secret generic "$SECRET_NAME" \
  --from-literal=DB_POSTGRESDB_PASSWORD="$(tf_out db_password)" \
  --from-literal=QUEUE_BULL_REDIS_PASSWORD="$(tf_out redis_auth_token)" \
  --from-literal=N8N_ENCRYPTION_KEY="$(tf_out n8n_encryption_key)" \
  --dry-run=client -o yaml | kubectl apply -f -

# Hash del Secret: si las credenciales cambian, cambia la anotacion del POD y
# Kubernetes lo recrea; si no cambian, un nuevo deploy no reinicia nada.
SECRET_CHECKSUM="$(kubectl -n "$NAMESPACE" get secret "$SECRET_NAME" -o jsonpath='{.data}' | sha256sum | cut -d' ' -f1)"

# 3. Instala o actualiza el chart con los datos de la infraestructura
helm upgrade --install "$RELEASE" ./helm/n8n \
  --namespace "$NAMESPACE" \
  --set secretChecksum="$SECRET_CHECKSUM" \
  --set existingSecret="$SECRET_NAME" \
  --set publicHost="$(tf_out master_public_ip)" \
  --set efs.server="$(tf_out efs_dns_name)" \
  --set postgres.host="$(tf_out db_address)" \
  --set postgres.port="$(tf_out db_port)" \
  --set postgres.database="$(tf_out db_name)" \
  --set postgres.user="$(tf_out db_username)" \
  --set redis.host="$(tf_out redis_primary_endpoint)" \
  --set redis.port="$(tf_out redis_port)" \
  --wait --timeout 10m \
  "$@"

echo
echo "n8n disponible en: http://$(tf_out master_public_ip):30678/"
