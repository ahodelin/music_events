echo "var eventsInfo = {" > jsonEvents_.js
echo "  \"events\":[" >> jsonEvents_.js
sed -e 's/$/,/' jsonEvents.js > jsonEventsTmp.js
cat jsonEventsTmp.js >> jsonEvents_.js
rm jsonEventsTmp.js
echo "]};" >> jsonEvents_.js
echo "function loadEvents(){" >> jsonEvents_.js
echo "  return(eventsInfo);" >> jsonEvents_.js
echo "}" >> jsonEvents_.js
echo "Note: Still Cyco Punk! Change double slash to single slash"
