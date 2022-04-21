echo "var bandsGeneresInfo = {" > jsonBandsGeneres.js
echo "  \"bandsgeneres\":[" >> jsonBandsGeneres.js
sed -e 's/$/,/' jsonBandsGeneres.json >> jsonBandsGeneres.js
# cat jsonBandsGeneresTmp.js >> jsonBandsGeneres.js
# rm jsonBandsGeneresTmp.js
echo "]};" >> jsonBandsGeneres.js
echo "function loadBandsGeneres(){" >> jsonBandsGeneres.js
echo "  return(bandsGeneresInfo);" >> jsonBandsGeneres.js
echo "}" >> jsonBandsGeneres.js
