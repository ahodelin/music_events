source music_events_config_vars.sh
config_var

band=$1

genre=" "
while [[ $genre != "" ]]; do
  echo -n "Genre: "
  read genre
  if [[ $genre != "" ]]; then
    ge=`psql -U $dbuser -w -d $db -c "select genere from music.generes g where genere = '$genre';"`

    if [[ $ge =~ $not_found_in_db ]]; then
      psql -U $dbuser -w -d $db -c "insert into music.generes values (md5('$genre'), '$genre');"
      echo "New Genre $genre inserted"
    fi

    psql -U $dbuser -w -d $db -c "insert into music.bands_generes values (md5('$band'), md5('$genre'));"
    echo "$band - $genre iserted"
  fi
done
