# Ubuntu Desktop Notifier for Gemini CLI

Esta extensión optimiza tu flujo de trabajo al integrar Gemini CLI con el sistema de notificaciones nativo de **Ubuntu 24.04 (GNOME)**.

## El Problema: El "Cuello de Botella" de la Terminal
Trabajar con agentes de IA a menudo implica esperar a que completen tareas largas o complejas. Esto genera dos escenarios ineficientes:
1.  **Espera pasiva:** Estar mirando la terminal sin hacer otra cosa hasta que responda.
2.  **Latencia de respuesta:** Ir a otra ventana a trabajar y dejar la terminal "en espera" (sin que trabaje) simplemente por no saber que el agente ya terminó o que está esperando una decisión tuya.

## La Solución: Flujo de Trabajo Ininterrumpido
**Ubuntu Desktop Notifier** elimina la necesidad de monitorear constantemente la terminal. Al recibir alertas visuales y sonoras instantáneas, puedes dedicarte al 100% a otras tareas en tu PC con la tranquilidad de que Gemini CLI te "tocará el hombro" solo cuando sea necesario. Esto maximiza tu productividad al reducir el tiempo muerto de la terminal y el tuyo propio.

## Características Principales
-   **Alertas Nativas de GNOME:** Notificaciones integradas con título de aplicación ("Gemini CLI") y sonido nítido estandarizado (`message-new-instant.oga`) para una experiencia limpia y poco intrusiva.
-   **Mecanismo Anti-rebote (Debounce) Aislado:** Evita el "spam" y los sonidos duplicados generados por condiciones de carrera de la CLI. Utiliza un directorio `tmp/` local en la propia extensión para ser 100% portable y seguro.
-   **Bloqueo Cruzado (Cross-Locking):** Sistema inteligente de prioridades donde las alertas críticas ("Acción Requerida") amordazan automáticamente a las notificaciones normales ("Turno Completado") si ocurren al mismo tiempo.
-   **Sincronización Inteligente:** Las nuevas notificaciones reemplazan a las antiguas en la interfaz de GNOME en lugar de acumularse.
-   **Seguridad y Robustez:** Scripts con rutas dinámicas seguras (`${BASH_SOURCE[0]}`), endurecidos con permisos `700` (`rwx------`) y modo estricto de Bash (`set -euo pipefail`).
-   **Directorio Auto-reparable:** Utiliza un directorio local `tmp/` excluido de control de versiones (vía `.gitignore`) que los scripts generan automáticamente en tiempo de ejecución si llega a ser eliminado.

## Requisitos de Sistema
Esta extensión utiliza herramientas integradas por defecto en **Ubuntu 24.04 LTS (Desktop)**, por lo que no requiere instalaciones externas adicionales:
-   **`libnotify-bin` (notify-send):** Instalado por defecto para el envío de burbujas de notificación.
-   **`libcanberra-gtk-module` (canberra-gtk-play):** Estándar de GNOME para alertas sonoras rápidas y eficientes.
-   **`util-linux` (flock):** Integrado en el Kernel para el bloqueo atómico de archivos.
-   **Sistemas de archivos compatibles:** Ext4 o similares con soporte para permisos Unix.

## Instalación Local (Desarrollo)
1.  Clona este repositorio en tu carpeta de extensiones.
2.  Asegúrate de que los scripts tengan permisos de ejecución:
    ```bash
    chmod 700 scripts/*.sh
    ```
3.  Vincula la extensión con Gemini CLI:
    ```bash
    gemini extensions link .
    ```

## Estructura Técnica (Hooks)
La extensión opera mediante interceptación de eventos de bajo nivel (`hooks.json`) y scripts de Bash robustos:
-   `AfterAgent`: Notifica cuando el turno del agente ha finalizado.
-   `Notification` & `BeforeTool (ask_user)`: Notifica inmediatamente cuando se requiere intervención humana o permisos de seguridad.
-   `scripts/debounce.sh`: Utilidad DRY modular para controlar las ventanas de tiempo entre ejecuciones.
