function showGenereOfBand(generesOfBand){
	tdGeneres = document.createElement('td');
	for(gob of generesOfBand)
		for(g of objGeneres.generes)
        		if(g['id_genere'] == gob){
                		tdGeneres.appendChild(document.createTextNode(g['genere']));
                        	tdGeneres.appendChild(document.createElement('br'));
               	 	}
	return tdGeneres;
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
