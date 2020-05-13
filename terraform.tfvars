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
api-authorization-key=""
workshop-collection-id="125499818"
workshop-start-map="125488374"
extraparams="-nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust2"
param-start="-nobreakpad -game csgo -console -usercon -secure -autoupdate -steam_dir $DIR_STEAMCMD -steamcmd_script $STEAM_RUNSCRIPT -maxplayers_override $MAXPLAYERS -tickrate $TICKRATE +hostport $PORT +net_public_adr $IP $EXTRAPARAMS"
param-update="+login $STEAM_LOGIN $STEAM_PASSWORD +force_install_dir $DIR_ROOT +app_update 740 validate +quit"

