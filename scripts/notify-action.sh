#!/bin/bash

# --- BASH STRICT MODE ---
set -euo pipefail

# --- CONFIGURACIÓN ---
# Sonido de alerta crítica para llamar la atención del usuario.
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"
SYNC_ID="gemini-cli-status"

# --- REPRODUCCIÓN DE AUDIO ---
# canberra-gtk-play respeta los niveles de volumen de 'Efectos de Sonido' de GNOME.
if command -v canberra-gtk-play &> /dev/null && [ -f "$SOUND_FILE" ]; then
    canberra-gtk-play -f "$SOUND_FILE" &
fi

# --- NOTIFICACIÓN VISUAL CRÍTICA ---
# Urgencia 'critical': La notificación se mantendrá en pantalla en Ubuntu
# hasta que el usuario interactúe con ella o cierre la terminal.
if command -v notify-send &> /dev/null; then
    notify-send "Gemini CLI - Acción Requerida" "⚠️ Intervención necesaria en la terminal." \
      -h string:x-canonical-private-synchronous:"$SYNC_ID" \
      -u critical
fi
