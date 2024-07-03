// show one band
function showBand(){
         allVoid();
                        
         var id_b = selectDrpDwnBand.value;
                                                
         if(id_b == "void") return;
         var stop = false;
         var bandsByBands = [id_b];
         bandsTable(bandsByBands);
                        
         var genresOfThisBand = [];
         var eventsOfThisBand = [];
                        
         for(bg of objBandsGenres.bands_genres)
                if(bg['id_band'] == id_b)
                        genresOfThisBand.push(bg['id_genre']);
                                        
        for(be of objBandsEvents.bands_events)
        	if(be['id_band'] == id_b)
                	eventsOfThisBand.push(be['id_event']);
                                        
        var tb = document.createElement('table');
                                
        var trh = document.createElement('tr');
                                
        var thGenre = document.createElement('th');
        var thEvent = document.createElement('th');
                                
        thGenre.appendChild(document.createTextNode('Genres'));
        thEvent.appendChild(document.createTextNode('Events'));                         
                                
        trh.appendChild(thGenre);
        trh.appendChild(thEvent);
                                
        var tr = document.createElement('tr');

        var tdGenre = showGenreOfBand(genresOfThisBand);
        var tdEvent = showEventOfBand(eventsOfThisBand);
                                
        tr.appendChild(tdGenre);
        tr.appendChild(tdEvent);
                                                
        tb.appendChild(trh);
        tb.appendChild(tr);
                                
	document.getElementById('genres_events').appendChild(tb);                                      
}
