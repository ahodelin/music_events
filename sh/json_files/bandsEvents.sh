source database_connection_config_vars.sh
config_var

echo "var bandsEventsInfo = {" > jsonBandsEvents.js
echo "  \"bands_events\":[" >> jsonBandsEvents.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.bands_events t join music.bands b on t.id_band = b.id_band order by b.band;" | sed -n '/{/p' >> jsonBandsEvents.js
echo "]};" >> jsonBandsEvents.js
