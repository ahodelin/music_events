echo "var generesInfo = {" > jsonGeneres_.js
echo "  \"generes\":[" >> jsonGeneres_.js
sed -e 's/$/,/' jsonGeneres.js > jsonGeneresTmp.js
cat jsonGeneresTmp.js >> jsonGeneres_.js
rm jsonGeneresTmp.js
echo "]};" >> jsonGeneres_.js
echo "function loadGeneres(){" >> jsonGeneres_.js
echo "  return(generesInfo);" >> jsonGeneres_.js
echo "}" >> jsonGeneres_.js
