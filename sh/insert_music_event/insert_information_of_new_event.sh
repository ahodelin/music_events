source music_events_config_vars.sh
config_var

file_of_new_event=$1

if [[ $file_of_new_event == "" ]]; then
  echo "Please run this file with the route of the file with the information of the new event";
  exit 1
fi

if [[ -f $file_of_new_event ]]; then
  new_event=""
  while read line; do
    if [[ $line =~ ^E\; ]]; then
      IFS=';' read -r id music_event date_event place_event duration_event price_event person_event <<< "$line"
      new_event="$music_event"
      psql -U $dbuser -w -d $db -c "select music.insert_event('$music_event', '$date_event', '$place_event', $duration_event::int2, $price_event, $person_event::int2);"
    else
      IFS=';' read -r id band country genre <<< "$line"
      psql -U $dbuser -w -d $db -c "select music.insert_bands_on_events('$band', '$new_event');"
      if [[ $country != "" ]]; then
        psql -U $dbuser -w -d $db -c "select music.insert_bands_on_countries('$band', '$country');"
      fi
      if [[ $genre != "" ]]; then
        IFS='|'
         read -ra genre_of_band <<< "$genre"
         for gen in "${genre_of_band[@]}"; do
          psql -U $dbuser -w -d $db -c "select music.insert_bands_to_genres('$band', '$gen');"
         done
      fi
    fi
  done < "$file_of_new_event"
else
  echo "The file $file_of_new_event does not exist."
  exit 1
fi
