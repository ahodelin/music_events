source database_connection_config_vars.sh
config_var

echo "var generesInfo = {" > jsonGeneres.js
echo "  \"generes\":[" >> jsonGeneres.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.v_generes t;" | sed -n '/{/p' >> jsonGeneres.js

echo "]};" >> jsonGeneres.js
