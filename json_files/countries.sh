echo "var countriesInfo = {" > jsonCountries.js
echo "  \"countries\":[" >> jsonCountries.js
sed -e 's/$/,/' jsonCountries.json >> jsonCountries.js
# cat jsonCountriesTmp.js >> jsonCountries.js
# rm jsonCountriesTmp.js
echo "]};" >> jsonCountries.js
echo "function loadCountries(){" >> jsonCountries.js
echo "  return(countriesInfo);" >> jsonCountries.js
echo "}" >> jsonCountries.js
