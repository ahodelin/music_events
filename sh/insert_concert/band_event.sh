source music_events_config_vars.sh
config_var

new_event=""
while IFS=";" read -r music_event date_event place_event duration_event price_event person_event
do
  new_event=$music_event
  psql -U $dbuser -w -d $db -c "select music.insert_event('$music_event', '$date_event', '$place_event', $duration_event::int2, $price_event, $person_event::int2);"

done < new_event.csv

while IFS=";" read -r band
do
  psql -U $dbuser -w -d $db -c "select music.insert_bands_on_events('$band', '$new_event');"
done < bands_on_event.csv
