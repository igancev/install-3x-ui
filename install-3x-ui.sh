#!/bin/bash

# colors for output
red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
plain='\033[0m'

echo -e "${blue}### Start install 3x-ui panel ###${plain}\n"
bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)

# Check that everything is ok
lastExitCode=$?
if [[ $lastExitCode -ne 0 ]]; then
  echo -e "${red}### Sorry, something went wrong...read the output logs above ###${plain}\n"
  exit $lastExitCode
fi

echo -e "${blue}### Generate self signed SSL cert and key for web panel ###${plain}\n"
sudo mkdir -p /root/cert/3x-ui-selfsigned && \
  openssl req -x509 -nodes -newkey rsa:2048 -days 1825 \
    -keyout /root/cert/3x-ui-selfsigned/key.pem \
    -out /root/cert/3x-ui-selfsigned/cert.pem \
    -subj "/C=US/ST=California/L=San Francisco/O=Example Company/OU=IT Department/CN=example.com"

echo -e "${blue}### Set generated SSL cert into 3x-ui settings ###${plain}\n"
/usr/local/x-ui/x-ui cert \
  -webCert "/root/cert/3x-ui-selfsigned/cert.pem" \
  -webCertKey "/root/cert/3x-ui-selfsigned/key.pem"

echo -e "${blue}### Restart 3x-ui panel ... ###${plain}\n"
/usr/local/x-ui/x-ui migrate
systemctl restart x-ui

# Show link to panel
server_ip=$(curl -s https://api.ipify.org)
config_username=$(/usr/local/x-ui/x-ui setting -show true | grep -Eo 'username: .+' | awk '{print $2}')
config_password=$(/usr/local/x-ui/x-ui setting -show true | grep -Eo 'password: .+' | awk '{print $2}')
config_webBasePath=$(/usr/local/x-ui/x-ui setting -show true | grep -Eo 'webBasePath: .+' | awk '{print $2}')
config_port=$(/usr/local/x-ui/x-ui setting -show true | grep -Eo 'port: .+' | awk '{print $2}')

echo -e "${green}#######"
echo -e "${green}Username: ${config_username}${plain}"
echo -e "${green}Password: ${config_password}${plain}"
echo -e "${green}Access URL: https://${server_ip}:${config_port}${config_webBasePath}${plain}"
echo -e "${green}#######${plain}\n"
