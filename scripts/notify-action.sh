#!/bin/bash

# --- BASH STRICT MODE ---
set -euo pipefail

# --- RUTAS SEGURAS (ABSOLUTAS) ---
# Garantiza que encontramos el directorio de este script y el de la extensión
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
EXT_DIR="$(dirname "$SCRIPT_DIR")"

# --- CONFIGURACIÓN ---
# Sonido de alerta para llamar la atención del usuario.
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/message-new-instant.oga"
SYNC_ID="gemini-cli-status"
# Archivos temporales locales de la extensión
LOCK_FILE="$EXT_DIR/tmp/action_lock"
DONE_LOCK="$EXT_DIR/tmp/done_lock"


# --- MECANISMO ANTI-REBOTE (DEBOUNCE) ---
# Resuelve la "condición de carrera" de Gemini CLI emitiendo múltiples
# eventos de acción (ej. Notification y BeforeTool) secuencialmente.
# Ventana de tiempo: 3 segundos (basado en telemetría para cubrir delays de NodeJS).
if ! "$SCRIPT_DIR/debounce.sh" "$LOCK_FILE" 3; then
    exit 0 # Bloquear la ejecución duplicada silenciosamente
fi

# --- BLOQUEO CRUZADO (CROSS-LOCK) ---
date +%s > "$DONE_LOCK"

# --- REPRODUCCIÓN DE AUDIO ---
# canberra-gtk-play respeta los niveles de volumen de 'Efectos de Sonido' de GNOME.
if command -v canberra-gtk-play &> /dev/null && [ -f "$SOUND_FILE" ]; then
    canberra-gtk-play -f "$SOUND_FILE" &
fi

# --- NOTIFICACIÓN VISUAL CRÍTICA ---
if command -v notify-send &> /dev/null; then
    notify-send -a "Gemini CLI" "⚠️ Acción Requerida" "Intervención necesaria en la terminal." \
      -h string:x-canonical-private-synchronous:"$SYNC_ID" \
      -u normal -t 3000
fi
