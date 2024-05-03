# id_place place
# id_event event date(yyyy-mm-dd) id_place duration price persons

source music_events_config_vars.sh
config_var

days_ago_pattr="[0-9]+"
price_pattr="[0-9]*\.[0-9]*"
duration_pattr="[0-9]+"
person_pattr="[1-2]"

echo "Information of music event."

ok="no"
while [[ $ok != "yes" ]]; do
  echo -n "Event: "
  read music_event

  echo
  days_ago=""
  while [[ ! $days_ago =~ $days_ago_pattr ]]; do
    echo -n "Days ago (d): "
    read days_ago
  done

  date_event=`date --date="$days_ago days ago" +%Y-%m-%d`

  echo
  echo -n "Place: "
  read place_event

  echo
  duration_event=""
  while [[ ! $duration_event =~ $duration_pattr ]]; do
    echo -n "Duration of event in days minus one day (d): "
    read duration_event
  done

  echo
  price_event=""
  while [[ ! $price_event =~ $price_pattr ]]; do
    echo -n "Price of event (dd.dd): "
    read price_event
  done

  echo
  person_event=""
  while [[ ! $person_event =~ $person_pattr ]]; do
    echo -n "How many persons visited the event: "
    read person_event
  done

  echo
  echo "Information of new event"
  echo "------------------------"
  echo "Name: $music_event"
  echo "Date: $date_event"
  echo "Place: $place_event"
  echo "Duration: $duration_event"
  echo "Price: $price_event"
  echo "Persons: $person_event"
  echo
  echo -n "Is this information ok? "
  read ok
done

echo 

bash place.sh "$place_event"

psql -U $dbuser -w -d music_events -c "insert into music.events values (md5('$music_event'), '$music_event', '$date_event', md5('$place_event'), $duration_event, $price_event, $person_event);"
echo "Event inserted."
bash band.sh "$music_event"

