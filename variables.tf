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
variable "workshop-collection-id" {}
variable "workshop-start-map" {}
variable "maxplayers" {
   default = "18"
}
variable "tickrate" {
   default = "64"
}
variable "extraparams" {}
variable "param-start" {}
variable "param-update" {}
