#!/usr/bin/env bash

# make link to custom location of /etc/cron.d if provided
if [ "${CRON_PATH}" ]; then
    echo "CRON_PATH provided, creating link: /etc/cron.d -> ${CRON_PATH}"
    ln -s "${CRON_PATH}"/* /etc/cron.d/
fi

# remove write permission for (g)roup and (o)ther (required by cron)
chmod -R go-w /etc/cron.d

CRONTAB_USER_OPTIONS=""

if [ "${CRONTAB_USER}" ]; then
	CRONTAB_USER_OPTIONS="-u ${CRONTAB_USER}"
fi

# adding additional cron jobs passed by arguments
# every job must be a single quoted string and have standard crontab format,
# e.g.: start-cron --user user "0 \* \* \* \* env >> /var/log/cron.log 2>&1"
{ for cron_job in "$@"; do echo -e ${cron_job}; done } \
    | sed --regexp-extended 's/\\(.)/\1/g' \
    | crontab ${CRONTAB_USER_OPTIONS} -

# update default values of PAM environment variables (used by CRON scripts)
env -0 | while read -d $'\0' -r line; do  # read STDIN by line
    # split LINE by "="
    IFS="=" read var val <<< ${line}
    # remove existing definition of environment variable, ignoring exit code
    sed --in-place "/^${var}[[:blank:]=]/d" /etc/security/pam_env.conf || true
    # append new default value of environment variable
    echo "${var} DEFAULT=\"${val}\"" >> /etc/security/pam_env.conf
done

if [ "${CRONTAB_CONTENT}" ]; then
    echo "CRONTAB_CONTENT provided, setting up crontab"
    echo "PATH=$PATH
$CRONTAB_CONTENT" | crontab ${CRONTAB_USER_OPTIONS} -
fi

# start cron
service cron start

# trap SIGINT and SIGTERM signals and gracefully exit
trap "service cron stop; kill \$!; exit" SIGINT SIGTERM

# start "daemon"
#while true
#do
#    # watch /var/log/cron.log restarting if necessary
#    cat /var/log/cron.log & wait $!
#done