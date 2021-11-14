echo "var bandsInfo = {" > jsonBands_.js
echo "  \"bands\":[" >> jsonBands_.js
sed -e 's/$/,/' jsonBands.js > jsonBandsTmp.js
cat jsonBandsTmp.js >> jsonBands_.js
rm jsonBandsTmp.js
echo "]};" >> jsonBands_.js
echo "function loadBands(){" >> jsonBands_.js
echo "  return(bandsInfo);" >> jsonBands_.js
echo "}" >> jsonBands_.js
