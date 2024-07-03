source database_connection_config_vars.sh
config_var

echo "var genresInfo = {" > jsonGenres.js
echo "  \"genres\":[" >> jsonGenres.js

psql -U $dbuser -w -d $db -c "select row_to_json(t)|| ',' from music.v_genres t;" | sed -n '/{/p' >> jsonGenres.js

echo "]};" >> jsonGenres.js
