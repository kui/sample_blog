#!/bin/sh

DEST_HOSTS=
ID_KEY=~/tmp/a.pem

if [ -z "$DEST_HOSTS" ]
then
    echo DEST_HOSTS を設定してください
    echo 例: DEST_HOSTS=\"user@foo.com user2@bar.com\"
    exit 1
fi

if [ -z "$ID_KEY" ]
then
    echo ID_KEY を設定してください
    echo 例: ID_KEY=~/.ssh/id_rsa
    exit 1
fi

BASE_DIR=$(cd $(dirname $0); pwd)
DEST_DIR=$(basename "${BASE_DIR}")

set -eux

for host in $DEST_HOSTS
do
    rsync -avz \
        --exclude=".git" \
        --exclude="*~" \
        --exclude="*.db" \
        --rsh "ssh -i ${ID_KEY}" \
        "${BASE_DIR}" \
        "${host}:"

    ssh -i "${ID_KEY}" "${host}" "cd '${DEST_DIR}' && ( which bundle || gem install bundle) && bundle"
    ssh -i "${ID_KEY}" "${host}" "cd '${DEST_DIR}' && chmod g+rw -R ."
    ssh -i "${ID_KEY}" "${host}" -t "sudo service httpd restart"
done
