echo "var generesInfo = {" > jsonGeneres.js
echo "  \"generes\":[" >> jsonGeneres.js
cat jsonGeneres.json >> jsonGeneres.js
echo "]};" >> jsonGeneres.js
# echo "function loadGeneres(){" >> jsonGeneres.js
# echo "  return(generesInfo);" >> jsonGeneres.js
# echo "}" >> jsonGeneres.js
