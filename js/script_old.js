document.addEventListener('DOMContentLoaded', () => {
    // Datos globales
    const allBands = typeof musicData_Bands !== 'undefined' ? musicData_Bands : [];
    const allEvents = typeof musicData_Events !== 'undefined' ? musicData_Events : [];
    const bandResultsContainer = document.getElementById('band-results');
    const eventResultsContainer = document.getElementById('event-results');
    // *** Mensajes iniciales en alemán ***
    const initialBandMessage = '<p>Filter auswählen und auf "Band suchen" klicken, um Ergebnisse anzuzeigen.</p>';
    const initialEventMessage = '<p>Filter auswählen und auf "Veranstaltung suchen" klicken, um Ergebnisse anzuzeigen.</p>';

    // --- INICIALIZACIÓN ---
    function initializePage() {
        try {
            displaySummary(typeof musicData_Summary !== 'undefined' ? musicData_Summary : {});

            console.log(`Daten der Bands verfügbar: ${allBands.length}`);
            console.log(`Daten der Veranstaltungen verfügbar: ${allEvents.length}`);

            populateDropdowns(allBands, allEvents);
            setupBandSearch(allBands);
            setupEventSearch(allEvents);

            bandResultsContainer.innerHTML = initialBandMessage;
            eventResultsContainer.innerHTML = initialEventMessage;

            createCharts();

        } catch (error) {
            console.error("Fehler beim Initialisieren der Seite:", error);
            bandResultsContainer.innerHTML = '<p style="color:red;">Fehler beim Initialisieren der Banddaten.</p>';
            eventResultsContainer.innerHTML = '<p style="color:red;">Fehler beim Initialisieren der Veranstaltungsdaten.</p>';
            if (typeof musicData_Summary === 'undefined' || typeof musicData_Bands === 'undefined' || typeof musicData_Events === 'undefined') {
                 document.getElementById('summary').innerHTML = '<p style="color:red;">Fehler beim Laden der Hauptdaten.</p>';
            }
        }
    }

    // --- Poblar Dropdowns (Textos por defecto en alemán) ---
    function populateDropdowns(bandsData, eventsData) {
        const bandSelect = document.getElementById('band-name-select');
        const genreSelect = document.getElementById('genre-select');
        const countrySelect = document.getElementById('country-select');
        const continentSelect = document.getElementById('continent-select');
        const eventSelectBand = document.getElementById('event-select-band');
        const placeSelectBand = document.getElementById('place-select-band');
        const eventSelectEvent = document.getElementById('event-name-select');
        const placeSelectEvent = document.getElementById('place-select-event');
        
	const bandNames = new Set(); 
	const genres = new Set(); 
	const countries = new Set(); 
	const continents = new Set(); 
	const eventNames = new Set(); 
	const placeNames = new Set();

        bandsData.forEach(band => { 
		if (band.band) bandNames.add(band.band); 
		if (band.genres) band.genres.forEach(g => genres.add(g)); 
		if (band.countries) band.countries.forEach(c => countries.add(c.country)); 
		if (band.continents) band.continents.forEach(c => continents.add(c)); 
		if (band.events_attended) { 
			band.events_attended.forEach(e => { 
				if (e.event) eventNames.add(e.event); 
				if (e.place) placeNames.add(e.place); 
			}); 
		} 
	});

        eventsData.forEach(event => { 
		if (event.event) eventNames.add(event.event); 
		if (event.place) placeNames.add(event.place); 
	});

        // *** Usando locale 'de' para ordenar ***
        const fillSelect = (selectElement, optionsSet, defaultText) => { 
		if (!selectElement) return; 
		while (selectElement.options.length > 1) { 
			selectElement.remove(1); 
		} 
		const sortedOptions = Array.from(optionsSet).sort((a, b) => a.localeCompare(b, 'de', { 
			sensitivity: 'base' 
		})); 
		sortedOptions.forEach(optionText => { 
			const option = document.createElement('option'); 
			option.value = optionText; 
			option.textContent = optionText; 
			selectElement.appendChild(option); 
		}); 
	};
        // *** Textos por defecto en alemán ***
        fillSelect(bandSelect, bandNames, '-- Alle Bands --');
        fillSelect(genreSelect, genres, '-- Alle Genres --');
        fillSelect(countrySelect, countries, '-- Alle Länder/Regionen --');
        fillSelect(continentSelect, continents, '-- Alle Kontinente --');
        fillSelect(eventSelectBand, eventNames, '-- Alle Veranstaltungen --');
        fillSelect(placeSelectBand, placeNames, '-- Alle Orte --');
        fillSelect(eventSelectEvent, eventNames, '-- Alle Veranstaltungen --');
        fillSelect(placeSelectEvent, placeNames, '-- Alle Orte --');
    }

    // --- MOSTRAR RESUMEN (Formato Moneda ya correcto) ---
     function displaySummary(data) {
        data = data || {};
        document.getElementById('total-events').textContent = data.total_events ?? 'k.A.'; // Usar k.A. (keine Angabe) o N/A
        document.getElementById('total-bands').textContent = data.total_bands_seen ?? 'k.A.';
        const spent = data.total_money_spent;
        document.getElementById('total-spent').textContent = (spent !== null && spent !== undefined) ? `${parseFloat(spent).toFixed(2)} ` : 'k.A.';
    }


    // --- Lógica de Búsqueda de Bandas (Sin cambios funcionales) ---
    const bandSearchForm = document.getElementById('band-search-form');
    function setupBandSearch(bandsData) {
        bandSearchForm.addEventListener('submit', (e) => { 
		e.preventDefault(); performBandSearch(bandsData); 
	});
        document.getElementById('reset-band-search').addEventListener('click', () => { 
		bandResultsContainer.innerHTML = initialBandMessage; 
	});
    }
    function performBandSearch(bandsData) {
        const nameQuery = document.getElementById('band-name-select').value; 
	const genreQuery = document.getElementById('genre-select').value; 
	const countryQuery = document.getElementById('country-select').value; 
	const continentQuery = document.getElementById('continent-select').value; 
	const eventQuery = document.getElementById('event-select-band').value; 
	const placeQuery = document.getElementById('place-select-band').value;
        const filteredBands = bandsData.filter(band => { 
		const nameMatch = !nameQuery || (band.band === nameQuery); 
		const genreMatch = !genreQuery || (band.genres && band.genres.includes(genreQuery)); 
		const countryMatch = !countryQuery || (band.countries && band.countries.some(c => c.country === countryQuery)); 
		const continentMatch = !continentQuery || (band.continents && band.continents.includes(continentQuery)); 
		const eventPlaceMatch = (!eventQuery && !placeQuery) || (band.events_attended && band.events_attended.some(e => (!eventQuery || e.event === eventQuery) && (!placeQuery || e.place === placeQuery) )); 
		return nameMatch && genreMatch && countryMatch && continentMatch && eventPlaceMatch; 
	});
        displayBandResults(filteredBands);
    }

    // --- displayBandResults (Etiquetas y mensajes en alemán) ---
    function displayBandResults(bands) {
         bandResultsContainer.innerHTML = '';
        if (!bands || bands.length === 0) {
            // *** Mensaje en alemán ***
            bandResultsContainer.innerHTML = '<p>Keine Bands mit diesen Kriterien gefunden.</p>';
            return;
        }
         bands.forEach(band => {
            const card = document.createElement('div');
            card.className = 'band-card';
            let likeIndicator = ''; 
	    if (band.likes) { 
		    likeIndicator = `<span class="like-indicator like-${band.likes}" title="${getLikeText(band.likes)}"></span>`; 
	    } // getLikeText traducirá el title
             // *** Etiquetas en alemán ***
            const genresHtml = band.genres ? band.genres.join(', ') : '<em>k.A.</em>';
            let countriesHtml = '<em>k.A.</em>'; 
	    if (band.countries && band.countries.length > 0) { 
		    countriesHtml = band.countries.map(c => { 
			    const flagHtml = c.flag ? `<img src="img/flags/${c.flag.toLowerCase()}.png" alt="${c.flag}" class="flag-icon" onerror="this.style.display='none'">` : ''; 
			    return `${c.country || '?'}${flagHtml}`; 
		    }).join(', '); 
	    }
            const continentsHtml = band.continents ? band.continents.join(', ') : '<em>k.A.</em>';
            let eventsHtml = '<em>Keine</em>'; 
	    if (band.events_attended && band.events_attended.length > 0) { 
		    eventsHtml = `<ul>${band.events_attended.map(e => `<li>${e.event || '?'} (${e.place || '?' }, ${e.date || '?'})</li>`).join('')}</ul>`;
	    }
            card.innerHTML = `
                <h3>${band.band || 'Unbekannte Band'} ${likeIndicator}</h3>
                <p><strong>Aktiv:</strong> ${band.hasOwnProperty('active') ? (band.active ? 'Ja' : 'Nein') : '?'}</p>
                <p><strong>Genres:</strong> ${genresHtml}</p>
                <p><strong>Land/Region:</strong> ${countriesHtml}</p>
                <p><strong>Kontinent(e):</strong> ${continentsHtml}</p>
                <p><strong>Gesehene Auftritte:</strong></p> <!-- O "Besuchte Events:" -->
                ${eventsHtml}
                ${band.band_note ? `<p><strong>Anmerkung:</strong> ${band.band_note}</p>` : ''}
            `;
            bandResultsContainer.appendChild(card);
        });
     }
    // *** Traducción de preferencias ***
    function getLikeText(likeCode) {
        switch(likeCode) {
            case 'y': return 'Ja'; // O 'Favorit'
            case 'm': return 'Jein';
            case 'n': return 'Nein';
            default: return 'Unbekannt';
        }
     }

    // --- Lógica de Búsqueda de Eventos (Sin cambios funcionales) ---
    const eventSearchForm = document.getElementById('event-search-form');
    function setupEventSearch(eventsData) {
        eventSearchForm.addEventListener('submit', (e) => { e.preventDefault(); performEventSearch(eventsData); });
        document.getElementById('reset-event-search').addEventListener('click', () => { eventResultsContainer.innerHTML = initialEventMessage; });
    }
    function performEventSearch(eventsData) {
        const nameQuery = document.getElementById('event-name-select').value; const yearQuery = document.getElementById('year-search').value.trim(); const placeQuery = document.getElementById('place-select-event').value;
         const filteredEvents = eventsData.filter(event => { const nameMatch = !nameQuery || (event.event === nameQuery); const yearMatch = !yearQuery || (event.event_year && event.event_year.toString() === yearQuery); const placeMatch = !placeQuery || (event.place === placeQuery); return nameMatch && yearMatch && placeMatch; });
        displayEventResults(filteredEvents);
    }

    // --- displayEventResults (Etiquetas y mensajes en alemán) ---
    function displayEventResults(events) {
        eventResultsContainer.innerHTML = '';
        if (!events || events.length === 0) {
             // *** Mensaje en alemán ***
            eventResultsContainer.innerHTML = '<p>Keine Veranstaltungen mit diesen Kriterien gefunden.</p>';
            return;
        }
         events.forEach(event => {
             const card = document.createElement('div');
            card.className = 'event-card';
            const price = (event.price !== null && event.price !== undefined) ? parseFloat(event.price) : null;
            const persons = (event.persons !== null && event.persons !== undefined) ? parseInt(event.persons) : 0;
             // *** Etiquetas en alemán y formato de moneda ***
            const priceText = price !== null ? `${price.toFixed(2)} € (für ${persons} Person${persons !== 1 ? 'en' : ''})` : 'Kostenlos/k.A.';
            card.innerHTML = `
                <h3>${event.event || 'Unbekannte Veranstaltung'}</h3>
                <p><strong>Datum:</strong> ${event.date_event || '?'}</p>
                <p><strong>Ort:</strong> ${event.place || '?'}</p>
                <p><strong>Dauer:</strong> ${event.duration ? (event.duration > 1 ? `${event.duration} Tage` : '1 Tag') : '?'}</p>
                <p><strong>Preis (Haushalt):</strong> ${priceText}</p>
                <p><strong>Bands:</strong> ${event.band_count ?? 'k.A.'}</p>
                ${event.event_note ? `<p><strong>Anmerkung:</strong> ${event.event_note}</p>` : ''}
            `;
             eventResultsContainer.appendChild(card);
        });
    }

    // --- GRÁFICOS ---

    // *** NUEVO: Función para definir colores de barras por año ***
    function eventsYearColorScale(context) {
        const value = context.raw || 0; // Número de eventos
        if (value >= 70) return 'rgba(255, 0, 255, 0.7)';    // Magenta/Fucsia brillante para 70+
        if (value >= 60) return 'rgba(220, 20, 60, 0.7)';     // Rojo carmesí para 60-69
        if (value >= 50) return 'rgba(255, 69, 0, 0.7)';      // Naranja rojizo para 50-59
        if (value >= 40) return 'rgba(255, 165, 0, 0.7)';     // Naranja para 40-49
        if (value >= 30) return 'rgba(255, 215, 0, 0.7)';     // Amarillo dorado para 30-39
        if (value >= 20) return 'rgba(154, 205, 50, 0.7)';    // Verde amarillento para 20-29
        if (value >= 10) return 'rgba(0, 128, 0, 0.7)';       // Verde para 10-19
        return 'rgba(100, 149, 237, 0.7)';      // Azul aciano para 0-9 (o un gris)

        // Alternativa con escala de grises y rojo
        // if (value >= 70) return 'rgba(255, 0, 0, 0.7)';     // Rojo brillante para 70+
        // if (value >= 60) return 'rgba(205, 92, 92, 0.7)';   // Rojo indio para 60-69
        // if (value >= 50) return 'rgba(240, 128, 128, 0.7)'; // Coral claro para 50-59
        // if (value >= 40) return 'rgba(169, 169, 169, 0.7)'; // Gris oscuro para 40-49
        // if (value >= 30) return 'rgba(192, 192, 192, 0.7)'; // Plata para 30-39
        // if (value >= 20) return 'rgba(211, 211, 211, 0.7)'; // Gris claro para 20-29
        // if (value >= 10) return 'rgba(220, 220, 220, 0.7)'; // Gris gainsboro para 10-19
        // return 'rgba(119, 136, 153, 0.7)';       // Gris pizarra claro para 0-9
    }


    function createCharts() {
         try {
            // Eventos por Año (con color y sin leyenda)
            const eventsYearData = typeof musicData_ChartEventsYear !== 'undefined' ? musicData_ChartEventsYear : [];
            // *** Pasar la función de color y ocultar leyenda ***
            createBarChart(
                'events-year-chart',                    // canvasId
                'Anzahl Veranstaltungen',              // label (para tooltip)
                eventsYearData.map(d => d.year),        // labels (eje X)
                eventsYearData.map(d => d.event_count), // data
                'x',                                    // indexAxis
                true,                                   // hideLegend
                eventsYearColorScale                    // colorFunction
            );

            // Top 5 Lugares (sin leyenda)
            const topPlacesData = typeof musicData_ChartTopPlaces !== 'undefined' ? musicData_ChartTopPlaces : [];
             // *** Ocultar leyenda ***
            createBarChart(
                'top-places-chart',
                'Anzahl Besuche', // label (para tooltip)
                topPlacesData.map(d => d.place),
                topPlacesData.map(d => d.visit_count),
                'y',            // indexAxis horizontal
                true            // hideLegend
            );

            // Top 5 Bandas (sin leyenda)
            const topBandsData = typeof musicData_ChartTopBands !== 'undefined' ? musicData_ChartTopBands : [];
             // *** Ocultar leyenda ***
            createBarChart(
                'top-bands-chart',
                'Anzahl Auftritte', // label (para tooltip)
                topBandsData.map(d => d.band),
                topBandsData.map(d => d.event_count),
                'y',            // indexAxis horizontal
                true            // hideLegend
            );

            // Top 5 Géneros (sin leyenda)
            const topGenresData = typeof musicData_ChartTopGenres !== 'undefined' ? musicData_ChartTopGenres : [];
             // *** Ocultar leyenda ***
            createBarChart(
                'top-genres-chart',
                'Anzahl Bands', // label (para tooltip)
                topGenresData.map(d => d.genre),
                topGenresData.map(d => d.band_count),
                'y',            // indexAxis horizontal
                true            // hideLegend
            );

            // Gasto por Año (mantener leyenda si se desea, traducido)
            const spendingYearData = typeof musicData_ChartSpendingYear !== 'undefined' ? musicData_ChartSpendingYear : [];
            // *** Label del tooltip traducido ***
            createLineChart('spending-year-chart', 'Ausgaben', spendingYearData.map(d => d.year), spendingYearData.map(d => parseFloat(d.total_spent || 0)));

            // Preferencias (mantener leyenda si se desea, traducido)
            const likesData = typeof musicData_ChartLikes !== 'undefined' ? musicData_ChartLikes : [];
             // *** Usar preferencias traducidas ***
             const translatedPreferences = likesData.map(d => getLikeText(d.likes));
            createPieChart('likes-chart', translatedPreferences, likesData.map(d => d.band_count), ['#28a745', '#ffc107', '#dc3545', '#6c757d']);

        } catch (error) { console.error("Fehler beim Erstellen der Diagramme:", error); }
    }

    // --- Funciones Auxiliares para Crear Gráficos ---

     // *** MODIFICADO: createBarChart para aceptar función de color y ocultar leyenda ***
     function createBarChart(canvasId, label, labels, data, indexAxis = 'x', hideLegend = false, colorFunction = null) {
        const ctx = document.getElementById(canvasId)?.getContext('2d'); if (!ctx) { console.error(`Canvas ${canvasId} nicht gefunden.`); return; } let existingChart = Chart.getChart(ctx); if (existingChart) { existingChart.destroy(); }

        const dataset = {
            label: label,
            data: data,
            // Usar función de color si se proporciona, sino color por defecto
            backgroundColor: colorFunction ? colorFunction : 'rgba(217, 83, 79, 0.7)',
             // Podríamos hacer el borde dependiente del color también si quisiéramos
            borderColor: 'rgba(217, 83, 79, 1)',
            borderWidth: 1
        };

        new Chart(ctx, {
            type: 'bar',
            data: { labels: labels, datasets: [dataset] },
            options: {
                indexAxis: indexAxis,
                scales: {
                     [indexAxis === 'x' ? 'y' : 'x']: { beginAtZero: true, ticks:{color:'#ccc'} },
                     [indexAxis === 'x' ? 'x' : 'y']: { ticks:{color:'#ccc'}}
                 },
                 responsive: true,
                 maintainAspectRatio: false, // Importante para controlar altura con CSS
                 plugins:{
                    legend: {
                         // *** Ocultar leyenda si hideLegend es true ***
                         display: !hideLegend, // `true` para mostrar, `false` para ocultar
                         labels:{color:'#ccc'}
                    },
                    // Mantener tooltips
                     tooltip: {
                         callbacks: { // Mostrar tooltip simple por defecto
                             label: function(context) {
                                 let lbl = context.dataset.label || '';
                                 if (lbl) { lbl += ': '; }
                                 // Usar valor raw que es el número original
                                 if (context.raw !== null) { lbl += context.raw; }
                                 return lbl;
                             }
                         }
                     }
                 }
             }
        });
     }

     function createLineChart(canvasId, label, labels, data) {
        const ctx = document.getElementById(canvasId)?.getContext('2d'); if (!ctx) { console.error(`Canvas ${canvasId} nicht gefunden.`); return; } let existingChart = Chart.getChart(ctx); if (existingChart) { existingChart.destroy(); }
        new Chart(ctx, {
            type: 'line',
            data: { labels: labels, datasets: [{ label: label, data: data, fill: false, borderColor: '#d9534f', tension: 0.1, pointBackgroundColor: '#d9534f', pointBorderColor: '#fff' }] },
            options: {
                scales: { y: { beginAtZero: true, ticks:{color:'#ccc'} }, x:{ticks:{color:'#ccc'}} },
                responsive: true, maintainAspectRatio: false,
                plugins:{ legend:{ display:false, labels:{color:'#ccc'} }, tooltip: { callbacks: { label: function(context) { let lbl = context.dataset.label || ''; if (lbl) { lbl += ': '; } if (context.parsed.y !== null) { lbl += context.parsed.y.toFixed(2) + ' €'; } return lbl; } } } } } });
     }

     function createPieChart(canvasId, labels, data, backgroundColors) {
        const ctx = document.getElementById(canvasId)?.getContext('2d'); if (!ctx) { console.error(`Canvas ${canvasId} nicht gefunden.`); return; } let existingChart = Chart.getChart(ctx); if (existingChart) { existingChart.destroy(); }
        new Chart(ctx, {
            type: 'pie',
            data: { labels: labels, datasets: [{ label: 'Verteilung', data: data, backgroundColor: backgroundColors, borderColor: '#1e1e1e', borderWidth: 2, hoverOffset: 4 }] }, // Label traducido
            options: { responsive: true, maintainAspectRatio: false, 
		layout: {
                padding: {
                    // Ajusta estos valores según sea necesario
                    top: 10,
                    right: 10,
                    bottom: 20,
                    left: 10
                },
                 // O puedes usar un solo número si quieres el mismo padding en todos lados:
                  //padding: 15
            },
		    plugins:{legend:{position: 'right', labels:{color:'#ccc'}}, tooltip:{}} } });
     }

    // --- INICIAR LA PÁGINA ---
    initializePage();

}); // Fin DOMContentLoaded
