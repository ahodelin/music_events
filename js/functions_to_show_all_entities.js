// show all bands
function showAllBands(){                                
	allVoid();
        var allBandsArray = [];

	for(ab of objBands.bands)  
        	allBandsArray.push(ab['id_band']);

        bandsTable(allBandsArray);
}

// show all countries
function showAllCountries(){
                allVoid();
                                
                var tb = document.createElement('table');                               
                                
                var thFlag = document.createElement('th');
                var thCountry = document.createElement('th');
                var thBand = document.createElement('th');
                                
                thFlag.appendChild(document.createTextNode('Flag'));
                thCountry.appendChild(document.createTextNode('Country'));
                thBand.appendChild(document.createTextNode('Bands'));

                var trh = document.createElement('tr');                         
                                
                trh.appendChild(thFlag);
                trh.appendChild(thCountry);
                trh.appendChild(thBand);
                                
                tb.appendChild(trh);

                for(ac of objCountries.countries){
                	var tr = document.createElement('tr');                                                          
                                          
                	var tdFlag = document.createElement('td');
                	var tdCountry = document.createElement('td');
                	var tdBand = document.createElement('td');                                      
                                          
                	var bFlag = document.createElement('img');
                	bFlag.src = "4x3/" + ac['flag'] + ".png";
                                                                                  
                	tdFlag.appendChild(bFlag);
                	tdCountry.appendChild(document.createTextNode(ac['country']));
                	tdBand.appendChild(document.createTextNode(ac['bands']));                                       
                                          
                	tr.appendChild(tdFlag);
                	tr.appendChild(tdCountry);
                	tr.appendChild(tdBand);                                         
                                  
        		tb.appendChild(tr);
        }                       
	document.getElementById('bands_info').appendChild(tb);
}

// show all genres
function showAllGenres(){
	allVoid();
                 
        var tb = document.createElement('table');                               
                                
        var thGenre = document.createElement('th');
        var thBand = document.createElement('th');
                                                        
        thGenre.appendChild(document.createTextNode('Genre'));
        thBand.appendChild(document.createTextNode('Bands'));

        var trh = document.createElement('tr');                         
                                
        trh.appendChild(thGenre);
        trh.appendChild(thBand);
                                
        tb.appendChild(trh);

        for(ag of objGenres.genres){  
        	var tr = document.createElement('tr');
                                        
                var tdGenre = document.createElement('td');
                var tdBand = document.createElement('td');
                                          
                tdGenre.appendChild(document.createTextNode(ag['genre']));
                tdBand.appendChild(document.createTextNode(ag['bands']));                                       
                                         
                tr.appendChild(tdGenre);
                tr.appendChild(tdBand);                                         
                                          
                tb.appendChild(tr);
	}                       
        document.getElementById('bands_info').appendChild(tb);
}

// show all events
function showAllEvents(){
	allVoid();
                                
        var tb = document.createElement('table');                               
                                
        var thYear = document.createElement('th');
        var thDate = document.createElement('th');
        var thEvent = document.createElement('th');
        var thPlace = document.createElement('th');
        var thBands = document.createElement('th');
                                                        
        thYear.appendChild(document.createTextNode('Year'));
        thDate.appendChild(document.createTextNode('Date'));
        thEvent.appendChild(document.createTextNode('Event'));
        thPlace.appendChild(document.createTextNode('Place'));
        thBands.appendChild(document.createTextNode('Bands'));

        var trh = document.createElement('tr');                         
                                
        trh.appendChild(thYear);
        trh.appendChild(thDate);
        trh.appendChild(thEvent);
        trh.appendChild(thPlace);
        trh.appendChild(thBands);
                                
        tb.appendChild(trh);

        for(ae of objEvents.events){
        	var tr = document.createElement('tr');
                                
               var tdYear = document.createElement('td');
               var tdDate = document.createElement('td');
               var tdEvent = document.createElement('td');
               var tdPlace = document.createElement('td');
               var tdBands = document.createElement('td');

               tdYear.appendChild(document.createTextNode(ae['year']));
               tdDate.appendChild(document.createTextNode(ae['date']));
               tdEvent.appendChild(document.createTextNode(ae['event']));
               tdPlace.appendChild(document.createTextNode(ae['place']));
               tdBands.appendChild(document.createTextNode(ae['bands']));                                      
                                  
               tr.appendChild(tdYear);
	       tr.appendChild(tdDate);
               tr.appendChild(tdEvent);
               tr.appendChild(tdPlace);
               tr.appendChild(tdBands);                                        
                                  
               tb.appendChild(tr);
 	}                       
        document.getElementById('bands_info').appendChild(tb);
}
