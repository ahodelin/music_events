source database_connection_config_vars.sh
config_var

echo "var bandsGeneresInfo = {" > jsonBandsGeneres.js
echo "  \"bands_generes\":[" >> jsonBandsGeneres.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.bands_generes t join music.bands b on b.id_band = t.id_band order by b.band;" | sed -n '/{/p' >> jsonBandsGeneres.js
echo "]};" >> jsonBandsGeneres.js
