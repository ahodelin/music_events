dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

echo "var bandsInfo = {" > jsonBands.js
echo "  \"bands\":[" >> jsonBands.js

psql -U $dbuser -w -d music_events -c "select row_to_json(t)|| ',' from music.v_bands t;" | sed -n '/{/p' >> jsonBands.js

echo "]};" >> jsonBands.js
