var objBands = loadBands();
var objGeneres = loadGeneres();
var objCountries = loadCountries();
var objEvents = loadEvents(); 
var objBandsGeneres = loadBandsGeneres();
var objBandsCountries = loadBandsCountries();
var objBandsEvents = loadBandsEvents();
                          
var allBands = objBands.bands.length;
var allEvents = objEvents.events.length;
                          
document.getElementById('allInfo').innerHTML = '<b>Viewed Bands: </b>' + allBands + 
	'<br> <b> Events: </b>' + allEvents;            
                          
var selectDrpDwnBand = document.getElementById('selectBandId');
var selectDrpDwnGenere = document.getElementById('selectGenereId');
var selectDrpDwnCountry = document.getElementById('selectCountryId');
var selectDrpDwnEvent = document.getElementById('selectEventId');
                          
selectDrpDwnBand.innerHTML = '<option value = "void" selected>Select Band</option>';
for(b of objBands.bands){
	selectDrpDwnBand.innerHTML = selectDrpDwnBand.innerHTML + 
        	'<option value = "' + b['id_band'] + '">' +
		b['band'] + '</option>';
}
                          
selectDrpDwnGenere.innerHTML = '<option value = "void" selected>Select Genre</option>';
for(g of objGeneres.generes){
	selectDrpDwnGenere.innerHTML = selectDrpDwnGenere.innerHTML + 
        	'<option value = "' + g['id_genere'] + '">' +
                g['genere'] + '</option>';
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
