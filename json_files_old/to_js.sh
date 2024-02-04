cd ..
mkdir -p old
mv json*.js old/
cd json_files

bash bandsCountries.sh
bash bandsEvents.sh
bash bandsGeneres.sh
bash bands.sh
bash countries.sh
bash events.sh
bash generes.sh

mv *.js ../
# rm *.json
cd
