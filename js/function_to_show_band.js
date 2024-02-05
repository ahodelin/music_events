// show one band
function showBand(){
         allVoid();
                        
         var id_b = selectDrpDwnBand.value;
                                                
         if(id_b == "void") return;
         var stop = false;
         var bandsByBands = [id_b];
         bandsTable(bandsByBands);
                        
         var generesOfThisBand = [];
         var eventsOfThisBand = [];
                        
         for(bg of objBandsGeneres.bands_generes)
                if(bg['id_band'] == id_b)
                        generesOfThisBand.push(bg['id_genere']);
                                        
        for(be of objBandsEvents.bands_events)
        	if(be['id_band'] == id_b)
                	eventsOfThisBand.push(be['id_event']);
                                        
        var tb = document.createElement('table');
                                
        var trh = document.createElement('tr');
                                
        var thGenere = document.createElement('th');
        var thEvent = document.createElement('th');
                                
        thGenere.appendChild(document.createTextNode('Generes'));
        thEvent.appendChild(document.createTextNode('Events'));                         
                                
        trh.appendChild(thGenere);
        trh.appendChild(thEvent);
                                
        var tr = document.createElement('tr');

        var tdGenere = showGenereOfBand(generesOfThisBand);
        var tdEvent = showEventOfBand(eventsOfThisBand);
                                
        tr.appendChild(tdGenere);
        tr.appendChild(tdEvent);
                                                
        tb.appendChild(trh);
        tb.appendChild(tr);
                                
	document.getElementById('generes_events').appendChild(tb);                                      
}
