function showGenreOfBand(genresOfBand){
	tdGenres = document.createElement('td');
	for(gob of genresOfBand)
		for(g of objGenres.genres)
        		if(g['id_genre'] == gob){
                		tdGenres.appendChild(document.createTextNode(g['genre']));
                        	tdGenres.appendChild(document.createElement('br'));
               	 	}
	return tdGenres;
}
                                
function showEventOfBand(eventsOfBand){
	tdEvents = document.createElement('td');
        for(eob of eventsOfBand)
        	for(e of objEvents.events)
                	if(e['id_event'] == eob){
                        	tdEvents.appendChild(document.createTextNode(e['event']));
                                tdEvents.appendChild(document.createElement('br'));
                        }
        return tdEvents;
}
