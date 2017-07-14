wlsvbox
=======

This repository contains SlackBuild script for building VirtualBox on Slackware.

You will need acpica installed before building.
You can find it in <a href="https://slackbuilds.org/result/?search=acpica&sv=" target="_blank">SlackBuilds.org</a>.


Build Order
===========

VBox Host
=========

1. virtualbox
2. virtualbox-kernel
3. virtualbox-extension-pack
4. virtualbox-addons (this meant to be installed in guest)

VBox Guest
==========

1. virtualbox-kernel-addons
