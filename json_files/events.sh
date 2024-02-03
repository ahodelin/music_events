dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

echo "var eventsInfo = {" > jsonEvents.js
echo "  \"events\":[" >> jsonEvents.js

psql -U $dbuser -w -d music_events -c "select row_to_json(t)|| ',' from music.v_events t;" | sed -n '/{/p' >> jsonEvents.js
sed -i 's/\\"/'"'"'/g' jsonEvents.js
echo "]};" >> jsonEvents.js
