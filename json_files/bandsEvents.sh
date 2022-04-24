echo "var bandsEventsInfo = {" > jsonBandsEvents.js
echo "  \"bands_events\":[" >> jsonBandsEvents.js
sed -e 's/$/,/' jsonBandsEvents.json >> jsonBandsEvents.js
echo "]};" >> jsonBandsEvents.js
echo "function loadBandsEvents(){" >> jsonBandsEvents.js
echo "  return(bandsEventsInfo);" >> jsonBandsEvents.js
echo "}" >> jsonBandsEvents.js
