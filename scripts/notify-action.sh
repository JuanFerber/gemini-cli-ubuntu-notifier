#!/bin/bash
# 1. Sonido de alerta en segundo plano
paplay /usr/share/sounds/freedesktop/stereo/dialog-warning.oga &

# 2. Notificación crítica con reemplazo
# Se usa el mismo ID 'gemini-cli-status' para que la cola de notificaciones esté limpia.
notify-send "Gemini CLI - Acción Requerida" "⚠️ Intervención necesaria en la terminal." \
  -h string:x-canonical-private-synchronous:gemini-cli-status \
  -u critical
