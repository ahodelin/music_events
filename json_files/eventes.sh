echo "var eventsInfo = {" > jsonEvents.js
echo "  \"events\":[" >> jsonEvents.js
sed -e 's/$/,/' jsonEvents.json >> jsonEvents.js
echo "]};" >> jsonEvents.js
echo "function loadEvents(){" >> jsonEvents.js
echo "  return(eventsInfo);" >> jsonEvents.js
echo "}" >> jsonEvents.js
echo "Note: jsonEvents.json - Still Cyco Punk! Change double slash to single slash and double comilla por simple comilla."
