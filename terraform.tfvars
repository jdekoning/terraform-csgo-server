csgo-instance-machine-type="t2.micro"

# Server config variables
# For information on values, see https://github.com/crazy-max/csgo-server-launcher#installation
screen-name="csgo"
user="steam"
port="27015"
dir-steamcmd="/var/steamcmd"
steam-runscript="$DIR_STEAMCMD/runscript_$SCREEN_NAME"
dir-root="$DIR_STEAMCMD/games/csgo"
dir-game="$DIR_ROOT/csgo"
dir-logs="$DIR_GAME/logs"
daemon-game="srcds_run"
update-log="$DIR_LOGS/update_$(date +%Y%m%d).log"
update-email=""
update-retry="3"
