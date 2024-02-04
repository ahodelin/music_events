dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

echo "var bandsGeneresInfo = {" > jsonBandsGeneres.js
echo "  \"bands_generes\":[" >> jsonBandsGeneres.js

psql -U $dbuser -w -d music_events -c "select row_to_json(t)|| ',' from music.bands_generes t;" | sed -n '/{/p' >> jsonBandsGeneres.js
echo "]};" >> jsonBandsGeneres.js
