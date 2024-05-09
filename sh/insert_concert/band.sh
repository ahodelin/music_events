source music_events_config_vars.sh
config_var

event=$1

band=""
while
  echo -n "Band: "
  read band

  ok=""
  if [[ $band != "" ]]; then
    echo -n "Is the name ok? "
    read ok
  fi

  if [[ $ok = "yes" ]]; then
    ba=`psql -U $dbuser -w -d $db -c "select band from music.bands t where band = '$band';"`
    if [[ $ba =~ $not_found_in_db ]]; then
      echo -n "Did you like this band? (y, m, n)? "
      read likes
      psql -U $dbuser -w -d $db -c "insert into music.bands values (md5('$band'), '$band', '$likes');"
      echo "New Band $band inserted"

      bash country.sh "$band"
      bash genre.sh "$band"
    fi

    psql -U $dbuser -w -d $db -c "insert into music.bands_events values (md5('$band'), md5('$event'));"
    echo "$band - $event inserted"
  fi

  [[ $band != "" ]]
do :; done
