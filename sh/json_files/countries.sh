source database_connection_config_vars.sh
config_var

echo "var countriesInfo = {" > jsonCountries.js
echo "  \"countries\":[" >> jsonCountries.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.v_countries t;" | sed -n '/{/p' >> jsonCountries.js

echo "]};" >> jsonCountries.js
