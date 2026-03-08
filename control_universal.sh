#!/bin/bash
export GDK_BACKEND=x11
T_MAN="/tmp/mop"; T_AUT="/tmp/aop"
do_cmd() { pkexec bash -c "$1"; }

# 1: FUNCIONES DE DETECCIÓN (ESTADO ACTUAL)
check_real() {
    s_ts=$(systemctl is-active tailscaled | grep -q "^active" && echo "🟢 ACTIVO" || echo "🔴 INACTIVO")
    s_nc=$(snap services nextcloud 2>/dev/null | awk '
NR>1 && tolower($3) ~ /^(active|activo)$/ {ok=1}
END{ if(ok) print "🟢 ACTIVO"; else print "🔴 INACTIVO" }'
)=$(snap services nextcloud 2>/dev/null | awk '$3=="active"{ok=1} END{if(ok)print "🟢 ACTIVO"; " "}')
    s_jf=$(pgrep -f jellyfin >/dev/null && echo "🟢 ACTIVO" || echo "🔴 INACTIVO")
    s_im=$(docker ps --format '{{.Names}}' | grep -q "immich_server" && echo "🟢 ACTIVO" || echo "🔴 INACTIVO")
    echo -e "ESTADO ACTUAL\n───\nTailscale: $s_ts\nNextcloud: $s_nc=$(snap services nextcloud 2>/dev/null | awk '
NR>1 && tolower($3) ~ /^(active|activo)$/ {ok=1}
END{ if(ok) print " C.Actual y de C.Arranque "; else print " C.Actual y de C.Arranque " }'
)\nJellyfin: $s_jf\nImmich: $s_im"
}

# 2: FUNCIONES DE DETECCIÓN (BOOT)
check_boot() {
    b_ts=$(systemctl is-enabled tailscaled 2>/dev/null | grep -q "enabled" && echo "✅ SÍ" || echo "🚫 NO")
    b_nc=$(snap services nextcloud 2>/dev/null | awk 'NR>1 && tolower($2) ~ /^(enabled|activado)$/ {ok=1} END{ if(ok) print "✅ SÍ"; else print "🚫 NO" }')
    [ -f "$HOME/.config/autostart/jellyfin.desktop" ] && b_jf="✅ SÍ" || b_jf="🚫 NO"
    [ -f "$HOME/.config/autostart/immich.desktop" ] && b_im="✅ SÍ" || b_im="🚫 NO"
    echo -e "BOOT\n───\nTailscale: $b_ts\nNextcloud: $b_nc\nJellyfin: $b_jf\nImmich: $b_im"
}

# 3: PESTAÑA 1 (C. ACTUAL)
D1="Configuracion Actual: Detenga o Inicie sus servidores. Nextcloud se gestiona solo en Arranque, no aparece aquí porque al ser Snap, para iniciarlo o detenerlo use Configuracion Arranque para próximo reinicio para el o estado actual."
yad --plug=$$ --tabnum=1 --list --text="$D1" --no-headers --column="I" --column="Acción" \
"🚀" "INICIAR TODO" "💀" "DETENER TODO" "---" "---" \
"🟢" "Tailscale" "🔴" "Tailscale" \
"🟢" "Jellyfin" "🔴" "Jellyfin" \
"🟢" "Immich" "🔴" "Immich" > "$T_MAN" &

# 4: PESTAÑA 2 (C. ARRANQUE)
D2="Configuracion Arranque: Aca no detiene ni inicia sus servidores actuales, menos Nextcloud, Puede programas Juntos o individualmente, cada proceso o programa para arrancar en su próxima sesión. es diferente a Configuracion Actual."
yad --plug=$$ --tabnum=2 --list --text="$D2" --no-headers --column="I" --column="Acción" "✅" "ACTIVAR TODOS EN ARRANQUE" "🚫" "DESACTIVAR TODOS EN ARRANQUE" "---" "---" "✅" "Tailscale" "🚫" "Tailscale" "✅" "Nextcloud" "🚫" "Nextcloud" "✅" "Jellyfin" "🚫" "Jellyfin" "✅" "Immich" "🚫" "Immich" > "$T_AUT" &

# 5: PESTAÑAS 3, 4 Y 5 (ESTADO, BOOT Y LICENCIA)
check_real | yad --plug=$$ --tabnum=3 --text-info --text="Estado Actual: Muestra el estado actual de ejecución de sus servidores. Aquí puede verificar si los procesos están operando o si han sido detenidos manualmente. Esta información corresponde exclusivamente a lo que sucede en la sesión presente y se actualiza según las acciones de la primera pestaña." &
check_boot | yad --plug=$$ --tabnum=4 --text-info --text="Estado Boot: Confirma si los servicios están programados para iniciar con el sistema operativo. 'SÍ' indica que el servidor arrancará solo en la próxima sesión; 'NO' indica que permanecerá apagado hasta que lo inicie manualmente. Esta pestaña no refleja si el servidor está encendido ahora, sino su programación futura." &

D5="
  ░█▀▀█ █▀▀ █  █ ░█▀▀█ █  █ █  █ █▀▀ █   
  ░█▄▄▀ █▀▀ ▀▄▄█ ░█▄▄█ ▀▄▄█ ▄▀▀▄ █▀▀ █   
  ░█  █ █▄▄ ▄▄▄█ ░█    ▄▄▄█ █  █ █▄▄ █▄▄
  
Licencia y Créditos:

Este script es una colaboración entre ReyPixel y Gemini (2026).
Todos los derechos compartidos. 
Uso libre para la comunidad.
____________________________________________________________________________
____________________________________________________________________________
Comparto Comandos
Para Verificar Estados pero no es Obligatorio ni necesario:

*Tailscale:
watch -n 5 'systemctl status tailscaled | head -n 5'
#BOOT DICE: service; disabled o enable
#En Estado Dice: Active: inactive (dead) o active (running)

*Nextcloud:
watch -n 5 snap services nextcloud
#Encendido dice: desactivado o activado
#Actual Dice: inactivo o Activo

*Jellyfin:
watch -n 5 'pgrep -f jellyfin >/dev/null && echo ACTUAL:SI || echo ACTUAL:NO; [ -f ~/.config/autostart/jellyfin.desktop ] && echo BOOT:SI || echo BOOT:NO'
###

*Immich:
watch -n 5 'pgrep -f immich >/dev/null && echo ACTUAL:SI || echo ACTUAL:NO; [ -f ~/.config/autostart/immich.desktop ] && echo BOOT:SI || echo BOOT:NO'
###
____________________________________________________________________________
____________________________________________________________________________
https://www.youtube.com/@ReyPixel-
Suscribete y Apoyame en YouTube

Gracias
Chaolin Pinguin
"

echo -e "$D5" | yad --plug=$$ --tabnum=5 --text-info --text="Licencia" &

res=$(yad --notebook --key=$$ --title="Control Universal" --width=500 --height=750 \
--tab="Configuracion Actual" --tab="Configuracion Arranque" --tab="Estado Actual" --tab="Boot" --tab="Licencia" \
--button="By ReyPixel & Gemini:bash -c 'xdg-open https://www.youtube.com/@ReyPixel-'" \
--button="Ejecutar:0" --button="Salir:1")

# 6: LÓGICA DE EJECUCIÓN (SESIÓN ACTUAL)
if [ $? -eq 0 ]; then
    sel_m=$(cat "$T_MAN" | awk -F'|' '{print $1,$2}')
    sel_a=$(cat "$T_AUT" | awk -F'|' '{print $1,$2}')

    case "$sel_m" in
        "🚀 INICIAR TODO") do_cmd "systemctl start tailscaled"; docker start immich_server immich_postgres immich_machine_learning immich_redis; flatpak run org.jellyfin.JellyfinServer & ;;
        "💀 DETENER TODO") do_cmd "systemctl stop tailscaled"; docker stop immich_server immich_postgres immich_machine_learning immich_redis; pkill -f jellyfin ;;
        "🟢 Tailscale") do_cmd "systemctl start tailscaled" ;;
        "🔴 Tailscale") do_cmd "systemctl stop tailscaled" ;;
        "🟢 Jellyfin")  flatpak run org.jellyfin.JellyfinServer & ;;
        "🔴 Jellyfin")  pkill -f jellyfin ;;
        "🟢 Immich")    docker start immich_server immich_postgres immich_machine_learning immich_redis ;;
        "🔴 Immich")    docker stop immich_server immich_postgres immich_machine_learning immich_redis ;;
    esac

# 7: LÓGICA DE EJECUCIÓN (BOOT/ARRANQUE)
    case "$sel_a" in
        "✅ ACTIVAR TODOS EN ARRANQUE") 
            do_cmd "systemctl enable tailscaled; snap enable nextcloud"
            mkdir -p ~/.config/autostart
            echo -e "[Desktop Entry]\nType=Application\nExec=docker start immich_server immich_postgres immich_machine_learning immich_redis\nHidden=false\nX-GNOME-Autostart-enabled=true\nName=Immich" > ~/.config/autostart/immich.desktop
            echo -e "[Desktop Entry]\nType=Application\nExec=flatpak run org.jellyfin.JellyfinServer\nHidden=false\nX-GNOME-Autostart-enabled=true\nName=Jellyfin" > ~/.config/autostart/jellyfin.desktop ;;
        "🚫 DESACTIVAR TODOS EN ARRANQUE") 
            do_cmd "systemctl disable tailscaled; snap disable nextcloud"
            docker update --restart no $(docker ps -a -q --filter name=immich)
            rm -f ~/.config/autostart/jellyfin.desktop ~/.config/autostart/immich.desktop ;;
        "✅ Tailscale") do_cmd "systemctl enable tailscaled" ;;
        "🚫 Tailscale") do_cmd "systemctl disable tailscaled" ;;
        "✅ Nextcloud") do_cmd "snap enable nextcloud" ;;
        "🚫 Nextcloud") do_cmd "snap disable nextcloud" ;;
        "✅ Jellyfin") 
            mkdir -p ~/.config/autostart
            echo -e "[Desktop Entry]\nType=Application\nExec=flatpak run org.jellyfin.JellyfinServer\nHidden=false\nX-GNOME-Autostart-enabled=true\nName=Jellyfin" > ~/.config/autostart/jellyfin.desktop ;;
        "🚫 Jellyfin") rm -f ~/.config/autostart/jellyfin.desktop ;;
        "✅ Immich") 
            mkdir -p ~/.config/autostart
            echo -e "[Desktop Entry]\nType=Application\nExec=docker start immich_server immich_postgres immich_machine_learning immich_redis\nHidden=false\nX-GNOME-Autostart-enabled=true\nName=Immich" > ~/.config/autostart/immich.desktop ;;
        "🚫 Immich") 
            docker update --restart no $(docker ps -a -q --filter name=immich)
            rm -f ~/.config/autostart/immich.desktop ;;
    esac
    exec "$0"
fi
