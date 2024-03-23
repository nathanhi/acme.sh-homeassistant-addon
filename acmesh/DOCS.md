# Acme.sh Add-on

## Installation
Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store** -> **Repositories**.
2. Add the repository: **https://github.com/Angoll/acme.sh-homeassistant-addon**
3. Seach acme.sh add-on
3. Click on the "INSTALL" button.

## Configuration

Add-on configuration:

```yaml
domain: home.example.com
server: ca.example.com
cabundle: /path/to/ca-bundle.crt
args: arbitrary additional arguments to acme.sh
fullchainfile: fullchain.pem
keyfile: privkey.pem
```
