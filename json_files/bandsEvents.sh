dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

echo "var bandsEventsInfo = {" > jsonBandsEvents.js
echo "  \"bands_events\":[" >> jsonBandsEvents.js

psql -U $dbuser -w -d music_events -c "select row_to_json(t)|| ',' from music.bands_events t;" | sed -n '/{/p' >> jsonBandsEvents.js
echo "]};" >> jsonBandsEvents.js
