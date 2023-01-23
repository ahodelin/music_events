echo "var bandsGeneresInfo = {" > jsonBandsGeneres.js
echo "  \"bands_generes\":[" >> jsonBandsGeneres.js
cat jsonBandsGeneres.json >> jsonBandsGeneres.js
#sed -e 's/$/,/' jsonBandsGeneres.json >> jsonBandsGeneres.js
echo "]};" >> jsonBandsGeneres.js
echo "function loadBandsGeneres(){" >> jsonBandsGeneres.js
echo "  return(bandsGeneresInfo);" >> jsonBandsGeneres.js
echo "}" >> jsonBandsGeneres.js
