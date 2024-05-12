function bandsTable(bandId){								
    var tb = document.createElement('table');

    var thBand = document.createElement('th');
    var thFlag = document.createElement('th');
    var thCountry = document.createElement('th');
    var thGenere = document.createElement('th');
    var thEvent = document.createElement('th');
    var thLike = document.createElement('th');

    thBand.appendChild(document.createTextNode('Band'));
    thFlag.appendChild(document.createTextNode('Flag'));
    thCountry.appendChild(document.createTextNode('Country'));
    thGenere.appendChild(document.createTextNode('Genres'));
    thEvent.appendChild(document.createTextNode('Events'));
    thLike.appendChild(document.createTextNode('Like'));

    var trh = document.createElement('tr');

    trh.appendChild(thBand);
    trh.appendChild(thFlag);
    trh.appendChild(thCountry);
    trh.appendChild(thGenere);
    trh.appendChild(thEvent);
    trh.appendChild(thLike);

    tb.appendChild(trh);

    var stop = false;
    for(b of bandId){
    for(i = 0; i < objBands.bands.length && !stop; i++)
        if (objBands.bands[i].id_band == b){
            stop = true;
            
            var tr = document.createElement('tr');
                
            var tdBand = document.createElement('td');
            var tdFlag = document.createElement('td');
            var tdCountry = document.createElement('td');
            var tdGenere = document.createElement('td');
            var tdEvent = document.createElement('td');
            var tdLike = document.createElement('td');

            var bFlag = document.createElement('img');
            bFlag.src = "4x3/" + objBands.bands[i].flag + ".png";
            var bLike = document.createElement('img');
            bLike.src = "likes/" + objBands.bands[i].likes + ".png";

            tdBand.appendChild(document.createTextNode(objBands.bands[i].band));
            tdFlag.appendChild(bFlag);
            tdCountry.appendChild(document.createTextNode(objBands.bands[i].country));
            tdGenere.appendChild(document.createTextNode(objBands.bands[i].generes));
            tdEvent.appendChild(document.createTextNode(objBands.bands[i].events));
            tdLike.appendChild(bLike);
            
            tr.appendChild(tdBand);
            tr.appendChild(tdFlag);
            tr.appendChild(tdCountry);
            tr.appendChild(tdGenere);
            tr.appendChild(tdEvent);
            tr.appendChild(tdLike);
            
            tb.appendChild(tr);
        }
        stop = false;
    }
document.getElementById('bands_info').appendChild(tb);
}
