echo "var bandsEventsInfo = {" > jsonBandsEvents_.js
echo "  \"bands_events\":[" >> jsonBandsEvents_.js
sed -e 's/$/,/' jsonBandsEvents.js > jsonBandsEventsTmp.js
cat jsonBandsEventsTmp.js >> jsonBandsEvents_.js
rm jsonBandsEventsTmp.js 
echo "]};" >> jsonBandsEvents_.js
echo "function loadBandsEvents(){" >> jsonBandsEvents_.js
echo "  return(bandsEventsInfo);" >> jsonBandsEvents_.js
echo "}" >> jsonBandsEvents_.js
