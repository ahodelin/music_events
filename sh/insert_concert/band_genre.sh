source music_events_config_vars.sh
config_var

band=$1
genre=" "
while [[ $genre != "" ]]; do
  echo -n "Genre: "
  read genre

  ok="no"
  if [[ $genre != "" ]]; then
    echo -n "Is the information ok? "
    read ok
    if [[ $ok = "yes" ]]; then
      psql -U $dbuser -w -d $db -c "select music.insert_bands_to_generes('$band', '$genre');"
    fi
  fi
done
