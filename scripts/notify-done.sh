#!/bin/bash

# --- BASH STRICT MODE ---
# -e: Abortar si un comando devuelve error.
# -u: Abortar si se intenta usar una variable no definida.
# -o pipefail: Abortar si falla cualquier comando en una tubería (pipe).
set -euo pipefail

# --- CONFIGURACIÓN ---
# Ruta estándar de sonidos en GNOME (Ubuntu)
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/complete.oga"
# ID de sincronización para que las notificaciones se reemplacen en lugar de acumularse
SYNC_ID="gemini-cli-status"

# --- REPRODUCCIÓN DE AUDIO ---
# canberra-gtk-play es el estándar de GNOME para sonidos de sistema.
# Se verifica que el comando exista y que el archivo de audio esté presente.
# El '&' al final asegura que el sonido no bloquee la ejecución del CLI de Gemini.
if command -v canberra-gtk-play &> /dev/null && [ -f "$SOUND_FILE" ]; then
    canberra-gtk-play -f "$SOUND_FILE" &
fi

# --- NOTIFICACIÓN VISUAL ---
# Se utiliza notify-send (libnotify) para enviar la alerta al escritorio.
# Urgencia 'normal' con expiración de 3 segundos (-t 3000).
if command -v notify-send &> /dev/null; then
    notify-send "Gemini CLI" "✅ Turno completado. Esperando instrucciones." \
      -h string:x-canonical-private-synchronous:"$SYNC_ID" \
      -u normal -t 3000
fi
