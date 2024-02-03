dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

echo "var generesInfo = {" > jsonGeneres.js
echo "  \"generes\":[" >> jsonGeneres.js

psql -U $dbuser -w -d music_events -c "select row_to_json(t)|| ',' from music.v_generes t;" | sed -n '/{/p' >> jsonGeneres.js

echo "]};" >> jsonGeneres.js
