echo "var bandsCountriesInfo = {" > jsonBandsCountries.js
echo "  \"bandscountries\":[" >> jsonBandsCountries.js
sed -e 's/$/,/' jsonBandsCountries.json >> jsonBandsCountries.js
# cat jsonBandsCountriesTmp.js >> jsonBandsCountries.js
# rm jsonBandsCountriesTmp.js
echo "]};" >> jsonBandsCountries.js
echo "function loadBandsCountries(){" >> jsonBandsCountries.js
echo "  return(bandsCountriesInfo);" >> jsonBandsCountries.js
echo "}" >> jsonBandsCountries.js
