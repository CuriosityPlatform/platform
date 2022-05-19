set -o errexit

PROJECT_ROOT_DIR=$(dirname "$(dirname "$(readlink -f "$0")")")

TEMPORARY_CONFIG_FILE=$(mktemp)

ESCAPED_REPLACE=$(printf '%s\n' "$PROJECT_ROOT_DIR" | sed -e 's/[\/&]/\\&/g')

sed "s/{{PROJECT_ROOT_DIR}}/$ESCAPED_REPLACE/g" env/k3d/config.yaml > "${TEMPORARY_CONFIG_FILE}"

k3d cluster create \
  --config "${TEMPORARY_CONFIG_FILE}"