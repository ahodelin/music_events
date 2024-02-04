dbpass=`pass postgres_pass`
export PGPASSWORD=$dbpass
dbuser=`pass postgres_user`

cat Music_Events1.tex > Music_Events.tex

psql -U $dbuser -w -d music_events -c "select * from music.v_bands_to_tex t;" | sed -n '/\&/p' | sed -e 's/|//g' >> Music_Events.tex

cat Music_Events2.tex >> Music_Events.tex
pdflatex --interaction=batchmode Music_Events.tex 2>&1 /dev/null
