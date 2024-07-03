source database_connection_config_vars.sh
config_var

echo "var bandsGenresInfo = {" > jsonBandsGenres.js
echo "  \"bands_genres\":[" >> jsonBandsGenres.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.bands_genres t join music.bands b on b.id_band = t.id_band order by b.band;" | sed -n '/{/p' >> jsonBandsGenres.js
echo "]};" >> jsonBandsGenres.js
