config_var(){
  # database connection

  dbpass=`pass postgres_pass`
  export PGPASSWORD=$dbpass
  dbuser=`pass postgres_user`
  db="music_events"
  not_found_in_db="\(0 rows\)"
}
