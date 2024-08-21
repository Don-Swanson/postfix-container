#!/bin/bash
# shellcheck disable=SC2016

set -e
#set -x

main="/config/main.cf"
master="/config/master.cf"
transport="/config/transport"

if [ ! -f "$main"  ] ||  [ ! -f "$master" ];then
  echo "Required files are missing."
  cp /etc/postfix/main.cf.orig /config/main.cf
  cp /etc/postfix/master.cf.orig /config/master.cf
fi

if [ -f "$transport" ];then
  echo "Postmaping transport"
  postmap /etc/postfix/transport
fi

if [ "$1" = 'postfix' ]; then
  echo "Starting mail server"

  # postfix needs fresh copies of files in its chroot jail
  cp /etc/{hosts,localtime,nsswitch.conf,resolv.conf,services} /var/spool/postfix/etc/
  exec "$@"
fi


exec "$@"