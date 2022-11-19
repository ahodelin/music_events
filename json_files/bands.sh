echo "var bandsInfo = {" > jsonBands.js
echo "  \"bands\":[" >> jsonBands.js
cat jsonBands.json >> jsonBands.js
# sed -e 's/$/,/' jsonBands.json >> jsonBands.js
# cat jsonBandsTmp.js >> jsonBands.js
# rm jsonBandsTmp.js
echo "]};" >> jsonBands.js
echo "function loadBands(){" >> jsonBands.js
echo "  return(bandsInfo);" >> jsonBands.js
echo "}" >> jsonBands.js
