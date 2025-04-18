#dbpass=`pass postgres_pass`
#export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

pg_dump -U $dbuser -d music_events -x -O > ../back/music.sql
