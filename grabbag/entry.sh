#!/bin/bash

echo " <><><> CONDA <><><> <><><> ENTRYPOINT <><><>"
# General project entrypoint. This allows us to "jump in" to the container and not worry about having to
# source conda every time
# Note: this is a huge PITA and I have not worked out all the issues yet
# Note the `exec` !
# All subprocesses must be forked to properly handle signals.
#conda init bash
#conda activate base
source ~/.bashrc
conda activate base
exec "$@"
