source database_connection_config_vars.sh
config_var

echo "var bandsInfo = {" > jsonBands.js
echo "  \"bands\":[" >> jsonBands.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.v_bands t;" | sed -n '/{/p' >> jsonBands.js

echo "]};" >> jsonBands.js
