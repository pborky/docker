declare -a ARR1=("${!1}")
# get latest repository form github
get_latest() {
  curl --silent https://api.github.com/repos/$1/releases/latest |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/'
}

# get gids of groups
get_gid() {
  for grp in ${1//,/ }; do
    echo -n "$(cut -d: -f3 < <(getent group $grp)) "
  done
}

get_host_dir_groups() {
  for v in ${1//,/ }; do 
     stat --printf="%g " "$(cut -d: -f1 < <(echo $v))"
  done
}

merge_unique_int() {
  declare -a merged=( "${!1}" "${!2}" "${!3}" ${!4} )
  merged=( $(printf '%s\n' ${merged[@]} | sort -un) )
  echo "${merged[@]}"
}
