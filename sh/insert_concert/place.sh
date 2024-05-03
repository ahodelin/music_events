source music_events_config_vars.sh

config_var

place_event=$1

pl=`psql -U $dbuser -w -d $db -c "select place from geo.places p where place = '$place_event';"`

if [[ $pl =~ $not_found_in_db ]]
then
  psql -U $dbuser -w -d $db -c "insert into geo.places values (md5('$place_event'), '$place_event');"
  echo "New Place $place_event inserted"
fi

