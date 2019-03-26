#!/usr/bin/env bash

if [ -f "$AWE_PLUGIN_CURRENT_FOLDER/AweCD.sh" ]
then
    alias cd=". $AWE_PLUGIN_CURRENT_FOLDER/AweCD.sh"
else
    echo "AweCD ERROR: incorrect alias for better cd"
fi
