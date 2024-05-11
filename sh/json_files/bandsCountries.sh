source database_connection_config_vars.sh
config_var

echo "var bandsCountriesInfo = {" > jsonBandsCountries.js
echo "  \"bands_countries\":[" >> jsonBandsCountries.js
psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.bands_countries t join music.bands b on t.id_band = b.id_band order by b.band;"  | sed -n '/{/p' >> jsonBandsCountries.js
echo "]};" >> jsonBandsCountries.js
