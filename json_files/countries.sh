dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

echo "var countriesInfo = {" > jsonCountries.js
echo "  \"countries\":[" >> jsonCountries.js

psql -U $dbuser -w -d music_events -c "select row_to_json(t)|| ',' from music.v_countries t;" | sed -n '/{/p' >> jsonCountries.js

echo "]};" >> jsonCountries.js
