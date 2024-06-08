source music_events_config_vars.sh
config_var

while IFS=";" read -r music_event date_event place_event duration_event price_event person_event
do
  psql -U $dbuser -w -d $db -c "select music.insert_event('$music_event', '$date_event', '$place_event', $duration_event::int2, $price_event, $person_event::int2);"

done < new_event.csv
