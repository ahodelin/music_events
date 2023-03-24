echo "var countriesInfo = {" > jsonCountries.js
echo "  \"countries\":[" >> jsonCountries.js
cat jsonCountries.json >> jsonCountries.js
echo "]};" >> jsonCountries.js
#echo "function loadCountries(){" >> jsonCountries.js
#echo "  return(countriesInfo);" >> jsonCountries.js
#echo "}" >> jsonCountries.js
