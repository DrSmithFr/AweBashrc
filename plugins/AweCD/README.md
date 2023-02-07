AweBash Plugin AweCD
====================

Plugin Content
--------------

Amplified `cd` command with aliases capability.

Plugin usage
------------
- `cd <filename|alias>` - Will first try to find a directory with the given name, if not found will try to find an alias with the given name.
- `cd --restore` : restore the last working directory (useful after console restart)
- `cd --last` or `cd -` : restore the last directory in usage
- `cd --save|-s <alias_name>` : create an alias for the current directory
- `cd --remove|-r <alias_name>` - remove an alias
- `cd --list|-l` : list all aliases with their directories

Optional:
---------

If NVM is installed, AweCD will try to find a .nvmrc file in the current folder and use it to switch to the correct node version.