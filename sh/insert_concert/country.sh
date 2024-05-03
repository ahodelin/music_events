source music_events_config_vars.sh
config_var

band=$1

ok="no"
country=""

while [[ $ok != "yes" ]]; do
  echo -n "Country of $band: "
  read country
  echo "Is the information ok?"
  read ok
done

co=`psql -U $dbuser -w -d $db -c "select country from geo.countries where country = '$country';"`

if [[ $co =~ $not_found_in_db ]]; then
  echo -n "Flag of country: "
  read flag

  psql -U $dbuser -w -d $db -c "insert into geo.countries values (md5('$country'), '$country', '$flag');"
  echo "New Country $country inserted"
fi

psql -U $dbuser -w -d $db -c "insert into music.bands_countries values (md5('$band'), md5('$country'));"
echo "$band - $country inserted"
