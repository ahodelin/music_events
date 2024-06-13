source music_events_config_vars.sh
config_var

while IFS=";" read -r band country
do
  psql -U $dbuser -w -d $db -c "select music.insert_bands_on_countries('$band', '$country');"
done < bands_from_countries.csv
