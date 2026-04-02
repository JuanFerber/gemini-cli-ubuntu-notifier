#!/bin/bash

# --- BASH STRICT MODE ---
set -euo pipefail

# USO: ./debounce.sh <ruta_lock_file> <ventana_segundos>
# FUNCIONAMIENTO:
# Retorna 0 (Éxito): Ha pasado el tiempo suficiente o es la primera vez. Se debe proceder.
# Retorna 1 (Debounced): El tiempo transcurrido es menor a la ventana. El evento debe ser ignorado silenciosamente.
# Retorna 2 (Error Crítico): Falta el argumento de la ruta del archivo de bloqueo.

LOCK_FILE="${1:-}"
WINDOW="${2:-1}"

if [ -z "$LOCK_FILE" ]; then
  echo "Error (Exit 2): Se requiere la ruta del archivo de bloqueo (lock file)." >&2
  exit 2
fi

# --- BLOQUEO ATÓMICO (Kernel Level) ---
exec 9>>"$LOCK_FILE"
if ! flock -n 9; then
  exit 1
fi

# A partir de aquí, este script es el único que está leyendo/escribiendo el archivo.
if [ -s "$LOCK_FILE" ]; then
  LAST_TIME=$(cat "$LOCK_FILE")
  CURRENT_TIME=$(date +%s)
  DIFF=$((CURRENT_TIME - LAST_TIME))

  if [ "$DIFF" -lt "$WINDOW" ]; then
    exit 1 # Debounced
  fi
fi

# Sobrescribimos el archivo con el nuevo timestamp
echo "$(date +%s)" >"$LOCK_FILE"
exit 0 # Proceder
