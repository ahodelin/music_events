source music_events_config_vars.sh
config_var

band=$1

ok="no"
country=""
flag=""

while [[ $ok != "yes" ]]; do
  echo -n "Country of $band: "
  read country

  echo -n "Flag of $country: "
  read flag

  echo "Is the information ok?"
  read ok
done

co=`psql -U $dbuser -w -d $db -c "select country from geo.countries where country = '$country';"`

if [[ $co =~ $not_found_in_db ]]; then
  psql -U $dbuser -w -d $db -c "insert into geo.countries values (md5('$country'), '$country', '$flag');"
  echo "$country inserted"
fi

psql -U $dbuser -w -d $db -c "select from music.insert_bands_on_countries('$band', '$country');"
echo "$band - $country inserted"
