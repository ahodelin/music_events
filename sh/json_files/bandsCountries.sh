dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

echo "var bandsCountriesInfo = {" > jsonBandsCountries.js
echo "  \"bands_countries\":[" >> jsonBandsCountries.js
psql -U $dbuser -w -d music_events -c "select row_to_json(t)|| ',' from music.bands_countries t;" | sed -n '/{/p' >> jsonBandsCountries.js
echo "]};" >> jsonBandsCountries.js
