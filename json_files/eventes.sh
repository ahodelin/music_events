echo "var eventsInfo = {" > jsonEvents.js
echo "  \"events\":[" >> jsonEvents.js
sed -e 's/\\"/'"'"'/g' jsonEvents.json >> jsonEvents.js
echo "]};" >> jsonEvents.js
# echo "function loadEvents(){" >> jsonEvents.js
# echo "  return(eventsInfo);" >> jsonEvents.js
#  echo "}" >> jsonEvents.js
