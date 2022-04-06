#!/bin/sh

################################################################################
# START as SERVER
################################################################################

AUTH=$(cat /home/$USER/.ssh/authorized_keys)
if [ -z "$AUTH" ]; then
  echo "=================================================================================="
  echo "ERROR: No SSH_AUTH_KEY provided, you'll not be able to connect to this container. "
  echo "=================================================================================="
  exit 1
fi

SSH_PARAMS="-D -e -p ${SSH_PORT:-22} $SSH_PARAMS"
echo "================================================================================"
echo "Running: /usr/sbin/sshd $SSH_PARAMS                                             "
echo "================================================================================"

exec /usr/sbin/sshd -D $SSH_PARAMS

echo "Please add this ssh key to your server /home/user/.ssh/authorized_keys        "
echo "================================================================================"
echo "`cat /home/$USER/.ssh/id_rsa.pub`"
echo "================================================================================"


