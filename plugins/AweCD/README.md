AweBash Plugin AweCD
====================

Plugin Content
--------------

Amplified `cd` command with aliases capability.

Plugin usage
------------

To add an alias for the current folder:

    cd -s alias_name
    
When using cd command, AweCD will first try to match a folder, if not found, it will try to find an alias.

    cd alias_name

Optional:
---------

If NVM is installed, AweCD will try to find a .nvmrc file in the current folder and use it to switch to the correct node version.