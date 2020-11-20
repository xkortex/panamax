#!/usr/bin/env zsh

if [[ -f "$HOME/.letmein" ]]; then
  echo "password is currently the default. Please change it"
  passwd
  if [[ $? -eq 0 ]]; then
    rm -f "$HOME/.letmein"
    echo "password set"
  fi
else
  echo "Welcome, $USER!"
fi

source "/opt/ros/$ROS_DISTRO/setup.zsh"

exec "$@"
