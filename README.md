# install-3x-ui
Bash script for installation 3x-ui web panel and perform post-installation actions

## Usage

For install 3x-ui run script:

```shell
bash <(curl -Ls https://raw.githubusercontent.com/igancev/install-3x-ui/refs/heads/master/install-3x-ui.sh)
```

It will install 3x-ui from [official repo script](https://github.com/MHSanaei/3x-ui), 
generate and set SSL self-signed certs, and print credentials. Therefore, the first login
will occur through a secure connection.

