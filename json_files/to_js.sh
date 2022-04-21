cd ../
mkdir -p old
mv *.js old/
cd json_files

bash bandsCountries.sh
bash bandsEvents.sh
bash bandsGeneres.sh
bash bands.sh
bash countries.sh
bash eventes.sh
bash generes.sh

mv *.js ../

