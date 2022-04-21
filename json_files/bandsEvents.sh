echo "var bandsEventsInfo = {" > jsonBandsEvents.js
echo "  \"bandsevents\":[" >> jsonBandsEvents.js
sed -e 's/$/,/' jsonBandsEvents.json >> jsonBandsEvents.js
# cat jsonBandsEventsTmp.js >> jsonBandsEvents.js
# rm jsonBandsEventsTmp.js 
echo "]};" >> jsonBandsEvents.js
echo "function loadBandsEvents(){" >> jsonBandsEvents.js
echo "  return(bandsEventsInfo);" >> jsonBandsEvents.js
echo "}" >> jsonBandsEvents.js
