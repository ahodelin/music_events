// show band by country
function showBandByCountry(){
        allVoid();
                        
        var id_c = selectDrpDwnCountry.value;
                        
        if(id_c == "void") return;
        var bandsByCountry = [];
        for(bc of objBandsCountries.bands_countries)
        	if(bc['id_country'] == id_c)
                	bandsByCountry.push(bc['id_band']);
        bandsTable(bandsByCountry);                     
}

// show band by genre
function showBandByGenre(){
        allVoid();
                        
        var id_g = selectDrpDwnGenre.value;
                        
        if(id_g == "void") return;
        var bandsByGenre = [];
        for(bg of objBandsGenres.bands_genres)
        	if(bg['id_genre'] == id_g)
                	bandsByGenre.push(bg['id_band']);
        bandsTable(bandsByGenre);                      
}

// show band by event
function showBandByEvent(){
	allVoid();
                        
        var id_e = selectDrpDwnEvent.value;
                  
        if(id_e == "void") return;
        var bandsByEvent = [];
        for(be of objBandsEvents.bands_events)
        	if(be['id_event'] == id_e)
                	bandsByEvent.push(be['id_band']);
         bandsTable(bandsByEvent);
}
