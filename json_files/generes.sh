echo "var generesInfo = {" > jsonGeneres.js
echo "  \"generes\":[" >> jsonGeneres.js
sed -e 's/$/,/' jsonGeneres.json >> jsonGeneres.js
# cat jsonGeneresTmp.js >> jsonGeneres.js
# rm jsonGeneresTmp.js
echo "]};" >> jsonGeneres.js
echo "function loadGeneres(){" >> jsonGeneres.js
echo "  return(generesInfo);" >> jsonGeneres.js
echo "}" >> jsonGeneres.js
