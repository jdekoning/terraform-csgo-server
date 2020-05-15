variable "public-key-path" {}
variable "ssh-access-ip" {}
variable "cidr-block" {}

# Infrastructure related variables
variable "csgo-instance-machine-type" {}

# Server config variables
# For information on values, see https://github.com/crazy-max/csgo-server-launcher#installation
variable "screen-name" {}
variable "user" {}
variable "port" {}
variable "gslt" {}
variable "dir-steamcmd" {}
variable "steam-login" {}
variable "steam-password" {}
variable "steam-runscript" {}
variable "dir-root" {}
variable "dir-game" {}
variable "dir-logs" {}
variable "daemon-game" {}
variable "update-log" {}
variable "update-email" {}
variable "update-retry" {}
variable "api-authorization-key" {}
variable "workshop-collection-id" {
   default = "125499818"
}
variable "workshop-start-map" {
   default = "125488374"
}
variable "maxplayers" {
   default = "18"
}
variable "tickrate" {
   default = "64"
}
variable "extraparams" {
   default = "-nohltv +sv_pure 0 +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust2"
}
variable "param-start" {
   default = "-nobreakpad -game csgo -console -usercon -secure -autoupdate -steam_dir $DIR_STEAMCMD -steamcmd_script $STEAM_RUNSCRIPT -maxplayers_override $MAXPLAYERS -tickrate $TICKRATE +hostport $PORT +net_public_adr $IP $EXTRAPARAMS"
}
variable "param-update" {
   default = "+login $STEAM_LOGIN $STEAM_PASSWORD +force_install_dir $DIR_ROOT +app_update 740 validate +quit"
}
