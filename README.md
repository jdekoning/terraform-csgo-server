# CSGO Automated Server Launch in AWS
Create an ubuntu 18 server with CSGO Server installed and configured. Uses [crazy-max/csgo-server-launcher](https://github.com/crazy-max/csgo-server-launcher). More documentation to come.

As it will run in the cloud and accessible over SSH, it currently expects a single IP from which server maintenance is done: ___your IP___, therefore there is also only one public key added: ___your key___.

Optionally you could change the firewall setting, the ingress rule on `aws_security_group.csgo-security-group` 

## Usage
### Prerequisites
* You need credentials for your own AWS account, I put them in my `.aws/credentials` file.
* You need to login into steam programmatically, so you need to disable Steam Guards
* Make sure the block device under the host is big enough (~40GB). Steam throws very ugly errors.

### Configuration
Create the file `secret.auto.tfvars` in the project root. 

Populate it with the minimum config (below).
```
ssh-access-ip="your-ip-address"
cidr-block="172.33.0.0/16"

public-key-path="~/.ssh/id_rsa.pub"

screen-name = "screenName"
steam-login = "myLogin"
steam-password = "myPassword"
gslt = "myLoginCode"
api-authorization-key = ""

tickrate = "128"
maxplayers = "4"
```
Change the [S3 remote backend](https://www.terraform.io/docs/backends/types/s3.html) to store your terraform state.
```
terraform {
  backend "s3" {
    bucket = "your-bucket"
    key    = "terraform-csgo"
    region = "eu-west-1"
  }
}
```

See `variables.tf` for other configuration options.

### Run Terraform
The example below runs `apply` and `init` from a docker container. The volume syntax used assumes Linux or MacOS. You can also use a native installation, see the [Terraform documentation](https://www.terraform.io/intro/index.html) for more information.

### Wait for install to complete
A startup script will automatically run on the host to install and configure the CSGo server. This will likely take 20-30 minutes. 

#### Log files
`/var/log/syslog` contains basic progress information.  
`/var/log/csgo-install-debug.log` contains more detailed progress and debugging info.

### Start and Manage Server
The install script can be rerun to update the server config by rerunning `terraform apply` and rebooting the server. See [crazy-max/csgo-server-launcher documentation](https://github.com/crazy-max/csgo-server-launcher) for information on manually managing the server after provisioning it.