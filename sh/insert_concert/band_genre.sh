source music_events_config_vars.sh
config_var

while IFS=";" read -r band genre
do
  psql -U $dbuser -w -d $db -c "select music.insert_bands_to_generes('$band', '$genre');"
done < bands_play_genres.csv
