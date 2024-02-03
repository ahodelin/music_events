dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

pg_dump -U $dbuser music_events -x -O -w > ../back/music.sql
