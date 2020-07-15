#!/bin/bash
[[ $- == *i* ]] && echo 'Interactive' || echo 'Not interactive'
shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'
