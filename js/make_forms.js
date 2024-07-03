var objBands = loadBands();
var objGenres = loadGenres();
var objCountries = loadCountries();
var objEvents = loadEvents(); 
var objBandsGenres = loadBandsGenres();
var objBandsCountries = loadBandsCountries();
var objBandsEvents = loadBandsEvents();
                          
var allBands = objBands.bands.length;
var allEvents = objEvents.events.length;
                          
document.getElementById('allInfo').innerHTML = '<b>Viewed Bands: </b>' + allBands + 
	'<br> <b> Events: </b>' + allEvents;            
                          
var selectDrpDwnBand = document.getElementById('selectBandId');
var selectDrpDwnGenre = document.getElementById('selectGenreId');
var selectDrpDwnCountry = document.getElementById('selectCountryId');
var selectDrpDwnEvent = document.getElementById('selectEventId');
                          
selectDrpDwnBand.innerHTML = '<option value = "void" selected>Select Band</option>';
for(b of objBands.bands){
	selectDrpDwnBand.innerHTML = selectDrpDwnBand.innerHTML + 
        	'<option value = "' + b['id_band'] + '">' +
		b['band'] + '</option>';
}
                          
selectDrpDwnGenre.innerHTML = '<option value = "void" selected>Select Genre</option>';
for(g of objGenres.genres){
	selectDrpDwnGenre.innerHTML = selectDrpDwnGenre.innerHTML + 
        	'<option value = "' + g['id_genre'] + '">' +
                g['genre'] + '</option>';
}
                          
selectDrpDwnCountry.innerHTML = '<option value = "void" selected>Select Country</option>';
for(c of objCountries.countries){
	selectDrpDwnCountry.innerHTML = selectDrpDwnCountry.innerHTML + 
        	'<option value = "' + c['id_country'] + '">' +
                c['country'] + '</option>';
}
                          
selectDrpDwnEvent.innerHTML = '<option value = "void" selected>Select Event</option>';
for(e of objEvents.events){
	selectDrpDwnEvent.innerHTML = selectDrpDwnEvent.innerHTML + 
        	'<option value = "' + e['id_event'] + '">' +
                e['event'] + '</option>';
}
