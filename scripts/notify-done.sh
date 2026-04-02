#!/bin/bash
# 1. Sonido de éxito en segundo plano (para no bloquear la notificación)
paplay /usr/share/sounds/freedesktop/stereo/complete.oga &

# 2. Notificación con reemplazo (hint x-canonical-private-synchronous)
# El ID 'gemini-cli-status' asegura que esta notificación reemplace a la anterior.
notify-send "Gemini CLI" "✅ Turno completado. Esperando instrucciones." \
  -h string:x-canonical-private-synchronous:gemini-cli-status \
  -u normal -t 3000
