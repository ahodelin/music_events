source database_connection_config_vars.sh
config_var

echo "var eventsInfo = {" > jsonEvents.js
echo "  \"events\":[" >> jsonEvents.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from (select id_event, year, date, event, place, bands from music.v_events) t;" | sed -n '/{/p' >> jsonEvents.js
sed -i 's/\\"/'"'"'/g' jsonEvents.js
echo "]};" >> jsonEvents.js
