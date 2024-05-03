source music_events_config_vars.sh
config_var

event=$1

band=" "
while [[ $band != "" ]]; do
  echo -n "Band: "
  read band

  if [[ $band != "" ]]; then 
    ba=`psql -U $dbuser -w -d $db -c "select band from music.bands t where band = '$band';"`

    if [[ $ba =~ $not_found_in_db ]]; then
      psql -U $dbuser -w -d $db -c "insert into music.bands values (md5('$band'), '$band');"
      echo "New Band $band inserted"

      bash country.sh "$band"
      bash genre.sh "$band"
    fi
  
    psql -U $dbuser -w -d $db -c "insert into music.bands_events values (md5('$band'), md5('$event'));"
    echo "$band - $event inserted"
  fi
done
