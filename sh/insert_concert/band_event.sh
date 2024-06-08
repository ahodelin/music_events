source music_events_config_vars.sh
config_var

while IFS=";" read -r band event
do
  psql -U $dbuser -w -d $db -c "select music.insert_bands_on_events('$band', '$event');"
done < bands_on_event.csv
