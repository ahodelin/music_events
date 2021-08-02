echo "var countriesInfo = " > jsonCountries_new.js
cat v_countries_202108022141.json >> jsonCountries_new.js
echo ";" >> jsonCountries_new.js
echo "function loadCountries(){" >> jsonCountries_new.js
echo "  return(countriesInfo);" >> jsonCountries_new.js
echo "}" >> jsonCountries_new.js
