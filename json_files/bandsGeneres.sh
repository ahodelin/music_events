echo "var bandsGeneresInfo = {" > jsonBandsGeneres_.js
echo "  \"bands_generes\":[" >> jsonBandsGeneres_.js
sed -e 's/$/,/' jsonBandsGeneres.js > jsonBandsGeneresTmp.js
cat jsonBandsGeneresTmp.js >> jsonBandsGeneres_.js
rm jsonBandsGeneresTmp.js
echo "]};" >> jsonBandsGeneres_.js
echo "function loadBandsGeneres(){" >> jsonBandsGeneres_.js
echo "  return(bandsGeneresInfo);" >> jsonBandsGeneres_.js
echo "}" >> jsonBandsGeneres_.js
