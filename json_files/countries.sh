echo "var countriesInfo = {" > jsonCountries_.js
echo "  \"countries\":[" >> jsonCountries_.js
sed -e 's/$/,/' jsonCountries.js > jsonCountriesTmp.js
cat jsonCountriesTmp.js >> jsonCountries_.js
rm jsonCountriesTmp.js
echo "]};" >> jsonCountries_.js
echo "function loadCountries(){" >> jsonCountries_.js
echo "  return(countriesInfo);" >> jsonCountries_.js
echo "}" >> jsonCountries_.js
