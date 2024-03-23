#!/usr/bin/env bashio
CONFIG_PATH=/data/options.json

[ ! -d "${LE_CONFIG_HOME}" ] && mkdir -p "${LE_CONFIG_HOME}"

if [ ! -f "${LE_CONFIG_HOME}/account.conf" ]; then
    bashio::log.info "Copying the default account.conf file"
    cp /default_account.conf "${LE_CONFIG_HOME}/account.conf"
fi

DOMAIN=$(bashio::config 'domain')
SERVER=$(bashio::config 'server')
CA_BUNDLE=$(bashio::config 'cabundle')
FULLCHAIN_FILE=$(bashio::config 'fullchainfile')
KEY_FILE=$(bashio::config 'keyfile')
ADDITIONAL_ARGS=$(bashio::config 'args')

bashio::log.info "Issuing certificate for domain: ${DOMAIN}"
function issue {
    # Issue the certificate exit correctly if is not time to renew
    local RENEW_SKIP=2
    acme.sh --issue \
            --standalone \
            --domain ${DOMAIN} \
            --server ${SERVER} \
            --ca-bundle "${CA_BUNDLE}" \
            --fullchain-file "/ssl/${DOMAIN}/${FULLCHAIN_FILE}" \
            --key-file "/ssl/${DOMAIN}/${KEY_FILE}" \
	    ${ADDITIONAL_ARGS} \
        || { ret=$?; [ $ret -eq ${RENEW_SKIP} ] && return 0 || return $ret ;}
}

issue

bashio::log.info "Installing certificate to: /ssl/${DOMAIN}"
[ ! -d "/ssl/${DOMAIN}/" ] && mkdir -p "/ssl/${DOMAIN}/"
acme.sh --install-cert --domain ${DOMAIN} \
    --key-file       "/ssl/${DOMAIN}/${KEY_FILE}" \
    --fullchain-file "/ssl/${DOMAIN}/${FULLCHAIN_FILE}"


bashio::log.info "All ok, running cron to automatically renew certificate"
trap "echo stop && killall crond && exit 0" SIGTERM SIGINT
crond && while true; do sleep 30m; done;
