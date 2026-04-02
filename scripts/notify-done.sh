#!/bin/bash

# --- BASH STRICT MODE ---
# -e: Abortar si un comando devuelve error.
# -u: Abortar si se intenta usar una variable no definida.
# -o pipefail: Abortar si falla cualquier comando en una tubería (pipe).
set -euo pipefail

# --- RUTAS SEGURAS (ABSOLUTAS) ---
# Garantiza que encontramos el directorio de este script y el de la extensión
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
EXT_DIR="$(dirname "$SCRIPT_DIR")"

# --- CONFIGURACIÓN ---
# Ruta estándar de sonidos en GNOME (Ubuntu)
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/message-new-instant.oga"
# ID de sincronización para que las notificaciones se reemplacen en lugar de acumularse
SYNC_ID="gemini-cli-status"
# Archivo temporal para el control de debounce en el directorio local de la extensión
mkdir -p "$EXT_DIR/tmp"
LOCK_FILE="$EXT_DIR/tmp/done_lock"

# --- MECANISMO ANTI-REBOTE (DEBOUNCE) ---
# Previene ejecuciones duplicadas (condición de carrera) en un lapso de 3 segundos.
# Delega la lógica al script utilidad externo.
if ! "$SCRIPT_DIR/debounce.sh" "$LOCK_FILE" 3; then
  exit 0 # Salir silenciosamente si el script de debounce indica que no pasó el tiempo
fi
# --- REPRODUCCIÓN DE AUDIO ---
# canberra-gtk-play es el estándar de GNOME para sonidos de sistema.
# Se verifica que el comando exista y que el archivo de audio esté presente.
# El '&' al final asegura que el sonido no bloquee la ejecución del CLI de Gemini.
if command -v canberra-gtk-play &>/dev/null && [ -f "$SOUND_FILE" ]; then
  canberra-gtk-play -f "$SOUND_FILE" &
fi

# --- NOTIFICACIÓN VISUAL ---
# Se utiliza notify-send (libnotify) para enviar la alerta al escritorio.
# -a "Gemini CLI": Define el nombre de la aplicación en la cabecera de GNOME.
# Urgencia 'normal' con expiración de 3 segundos (-t 3000).
if command -v notify-send &>/dev/null; then
  notify-send -a "Gemini CLI" "✅ Turno completado" "Esperando instrucciones." \
    -h string:x-canonical-private-synchronous:"$SYNC_ID" \
    -u normal -t 3000
fi
