# Ubuntu Desktop Notifier for Gemini CLI

Esta extensión optimiza tu flujo de trabajo al integrar Gemini CLI con el sistema de notificaciones nativo de **Ubuntu 24.04 (GNOME)**.

## El Problema: El "Cuello de Botella" de la Terminal
Trabajar con agentes de IA a menudo implica esperar a que completen tareas largas o complejas. Esto genera dos escenarios ineficientes:
1.  **Espera pasiva:** Estar mirando la terminal sin hacer otra cosa hasta que responda.
2.  **Latencia de respuesta:** Ir a otra ventana a trabajar y dejar la terminal "en espera" (sin que trabaje) simplemente por no saber que el agente ya terminó o que está esperando una decisión tuya.

## La Solución: Flujo de Trabajo Ininterrumpido
**Ubuntu Desktop Notifier** elimina la necesidad de monitorear constantemente la terminal. Al recibir alertas visuales y sonoras instantáneas, puedes dedicarte al 100% a otras tareas en tu PC con la tranquilidad de que Gemini CLI te "tocará el hombro" solo cuando sea necesario. Esto maximiza tu productividad al reducir el tiempo muerto de la terminal y el tuyo propio.

## Características Principales
-   **Alertas Visuales y Sonoras:** Notificaciones nativas con sonido para diferenciar entre tareas finalizadas y acciones requeridas.
-   **Sincronización Inteligente:** Las nuevas notificaciones reemplazan a las antiguas en lugar de acumularse, manteniendo tu centro de notificaciones limpio.
-   **Seguridad:** Scripts endurecidos con permisos `700` (`rwx------`) y modo estricto de Bash, garantizando que solo el usuario propietario pueda ejecutarlos de forma segura.

## Requisitos de Sistema
Esta extensión utiliza herramientas integradas por defecto en **Ubuntu 24.04 LTS (Desktop)**, por lo que no requiere instalaciones externas adicionales:
-   **`libnotify-bin` (notify-send):** Instalado por defecto para el envío de burbujas de notificación.
-   **`libcanberra-gtk-module` (canberra-gtk-play):** Estándar de GNOME para alertas sonoras rápidas y eficientes.
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
-   **Modo Estricto:** Todos los scripts usan `set -euo pipefail` para asegurar que el comportamiento ante errores sea predecible y seguro.
