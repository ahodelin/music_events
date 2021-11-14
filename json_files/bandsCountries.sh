echo "var bandsCountriesInfo = {" > jsonBandsCountries_.js
echo "  \"bands_countries\":[" >> jsonBandsCountries_.js
sed -e 's/$/,/' jsonBandsCountries.js > jsonBandsCountriesTmp.js
cat jsonBandsCountriesTmp.js >> jsonBandsCountries_.js
rm jsonBandsCountriesTmp.js
echo "]};" >> jsonBandsCountries_.js
echo "function loadBandsCountries(){" >> jsonBandsCountries_.js
echo "  return(bandsCountriesInfo);" >> jsonBandsCountries_.js
echo "}" >> jsonBandsCountries_.js
