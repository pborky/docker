
# get latest repository form github
get_latest() {
  curl --silent https://api.github.com/repos/$1/releases/latest |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/'
}

# get gids of groups
get_gid() {
  for grp in ${1//,/ }; do
    echo -n "$(cut -d: -f3 < <(getent group $grp)),"
  done
}
