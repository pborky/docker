
GITHUB_REPO="foosel/OctoPrint"
TAG_BASE="pborky/octoprint"
CONT_NAME="octoprint"
# new unprivileged user
CONT_UID=666
CONT_GID=666
CONT_USER="octoprint"
# groups of the new user, comma sepparated list
CONT_GROUPS="dialout,$(id -gn)"
# RUNTIME
VOLUMES=$PWD/config:$CONT_HOME/.octoprint
DEVICES=/dev/ttyACM0:/dev/ttyACM0
PUBLISH_PORTS=5000

