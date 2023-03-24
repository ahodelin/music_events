echo "var bandsCountriesInfo = {" > jsonBandsCountries.js
echo "  \"bands_countries\":[" >> jsonBandsCountries.js
cat jsonBandsCountries.json >> jsonBandsCountries.js
echo "]};" >> jsonBandsCountries.js
# echo "function loadBandsCountries(){" >> jsonBandsCountries.js
# echo "  return(bandsCountriesInfo);" >> jsonBandsCountries.js
# echo "}" >> jsonBandsCountries.js
