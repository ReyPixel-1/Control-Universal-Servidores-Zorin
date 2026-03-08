🚀 Control Universal de Servidores (Linux Zorin)
Panel gráfico desarrollado en YAD para gestionar de forma eficiente el estado y el arranque de servicios esenciales. Una colaboración entre ReyPixel, Gemini y ChatGPT (Año 2026).

⚡ Optimización de Recursos
El propósito principal de este panel es el ahorro de RAM y CPU, ideal para creadores de contenido, gamers o cualquir usuario de ZorinOS:

Gestión Selectiva: Detén servicios pesados como Docker (Immich) o Nextcloud cuando no los necesites para liberar memoria para juegos o edición.

Control de Procesos: Evita que procesos en segundo plano consuman ciclos de CPU innecesarios.

Arranque Limpio: Tú decides qué inicia con el sistema para un encendido más veloz.

🛠️ Servicios Soportados
Tailscale (VPN Mesh)

Nextcloud (Nube personal - Versión Snap)

Jellyfin (Media Server - Versión Flatpak)

Immich (Gestión de fotos - Docker)

Próximamente: Soporte para Sunshine.

📥 Instalación y Configuración Universal
Para que el acceso directo y el script funcionen siempre, sigue estos pasos:

Instala la dependencia:
sudo apt install yad

Crea la carpeta de scripts en tu carpeta personal:
mkdir -p ~/scripts

Guarda el archivo: Descarga control_universal.sh y colócalo dentro de esa carpeta (~/scripts/).

Permisos de ejecución:
chmod +x ~/scripts/control_universal.sh

Acceso Directo (Opcional): Puedes crear un lanzador .desktop que apunte a bash -c "$HOME/scripts/control_universal.sh".


📥Crea el Lanzador con un solo comando:
Copia y pega todo este comando en tu terminal para crear el acceso directo automáticamente si guerdaste el script en la 📥 Instalación Rápida

Bash
mkdir -p ~/.local/share/applications/"mis apps" && echo -e '[Desktop Entry]\nName=Control de Servidores\nComment=Gestionar Immich, Nextcloud y Jellyfin\nExec=bash -c "$HOME/scripts/control_universal.sh"\nIcon=preferences-system-network\nTerminal=false\nType=Application' > ~/.local/share/applications/"mis apps"/control-servidores.desktop && chmod +x ~/.local/share/applications/"mis apps"/control-servidores.desktop


📜 Licencia
Este proyecto es de uso libre para la comunidad bajo la Licencia MIT.

📺 Apoya mi contenido: Suscríbete a ReyPixel en YouTube: https://www.youtube.com/@ReyPixel-

