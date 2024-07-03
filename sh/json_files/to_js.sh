# cd ../..
mkdir -p ../../old
mv ../../js/json*.js ../../old/
# cd sh/json_files/

bash bandsCountries.sh
bash bandsEvents.sh
bash bandsGenres.sh
bash bands.sh
bash countries.sh
bash events.sh
bash genres.sh

mv *.js ../../js
# rm *.json
#cd
