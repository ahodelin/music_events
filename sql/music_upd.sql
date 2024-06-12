/*
insert into geo.countries 
  values 
    ('TCC', 'Test Country', 'tc');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/



-- New events
select music.insert_event('Mahlstrom Open Air 2024', '2024.06.13', 'Wiesbaden (Schlachthof)', 1::int2, 29.30, 2::int2);


-- Bands on events
select music.insert_bands_on_events('Asagraum', 'Mahlstrom Open Air 2024'); --
--select music.insert_bands_on_events('Mighty Dragonlords of the Promised Land', 'Mahlstrom Open Air 2024');
--select music.insert_bands_on_events('Blood Fire Death', 'Mahlstrom Open Air 2024'); --
select music.insert_bands_on_events('EÏS', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Gernotshagen', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Ignis Fatuu', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Mourning Wood', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Sarkh', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Thjodrörir', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Vader', 'Mahlstrom Open Air 2024');--
select music.insert_bands_on_events('Baumbart', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Black Messiah', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Horn', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Countless Skies', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Haggard', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Theotoxin', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Toter Fisch', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Vansind', 'Mahlstrom Open Air 2024');
select music.insert_bands_on_events('Waldgeflüster', 'Mahlstrom Open Air 2024');

-- Bands from countries
select music.insert_bands_on_countries('Gernotshagen', 'DEU');
select music.insert_bands_on_countries('Black Messiah', 'DEU');
--select music.insert_bands_on_countries('Mighty Dragonlords of the Promised Land', 'DEU');
select music.insert_bands_on_countries('EÏS', 'DEU');
select music.insert_bands_on_countries('Ignis Fatuu', 'DEU');
select music.insert_bands_on_countries('Mourning Wood', 'FIN');
select music.insert_bands_on_countries('Sarkh', 'DEU');
select music.insert_bands_on_countries('Thjodrörir', 'DEU');
select music.insert_bands_on_countries('Baumbart', 'DEU');
select music.insert_bands_on_countries('Countless Skies', 'GBR');
select music.insert_bands_on_countries('Haggard', 'DEU');
select music.insert_bands_on_countries('Theotoxin', 'AUS');
select music.insert_bands_on_countries('Toter Fisch', 'FRA');
select music.insert_bands_on_countries('Vansind', 'DNK');
select music.insert_bands_on_countries('Waldgeflüster', 'DEU');
select music.insert_bands_on_countries('Horn', 'DEU');

-- Music genre
select music.insert_bands_to_genres('Gernotshagen', 'Pagan Black Metal');
select music.insert_bands_to_genres('Gernotshagen', 'Folk Metal');
select music.insert_bands_to_genres('Black Messiah', 'Symphonic Black Metal');
select music.insert_bands_to_genres('Black Messiah', 'Folk Metal');
select music.insert_bands_to_genres('Black Messiah', 'Viking Metal');
--select music.insert_bands_to_genres('Mighty Dragonlords of the Promised Land', 'Power Metal');
select music.insert_bands_to_genres('EÏS', 'Black Metal');
select music.insert_bands_to_genres('Ignis Fatuu', 'Mediaval Rock');
select music.insert_bands_to_genres('Mourning Wood', 'Heavy Metal');
select music.insert_bands_to_genres('Sarkh', 'Post-Metal');
select music.insert_bands_to_genres('Sarkh', 'Post-Rock');
select music.insert_bands_to_genres('Thjodrörir', 'Pagan Metal');
select music.insert_bands_to_genres('Baumbart', 'Folk Metal');
select music.insert_bands_to_genres('Countless Skies', 'Melodic Death Metal');
select music.insert_bands_to_genres('Haggard', 'Progressive Death Metal');
select music.insert_bands_to_genres('Haggard', 'Classical Metal');
select music.insert_bands_to_genres('Haggard', 'Orchestral Metal');
select music.insert_bands_to_genres('Haggard', 'Symphonic Metal');
select music.insert_bands_to_genres('Theotoxin', 'Death Metal');
select music.insert_bands_to_genres('Theotoxin', 'Black Metal');
select music.insert_bands_to_genres('Toter Fisch', 'Melodic Death Metal');
select music.insert_bands_to_genres('Toter Fisch', 'Folk Metal');
select music.insert_bands_to_genres('Vansind', 'Folk Metal');
select music.insert_bands_to_genres('Waldgeflüster', 'Pagan Metal');
select music.insert_bands_to_genres('Horn', 'Pagan Black Metal');



------------------------------------------------------------------------------------
/*
-- New events
select music.insert_event('Europe Summer 2024', '2024.06.17', 'Wiesbaden (Schlachthof)', 0::int2, 29.30, 2::int2);


-- Bands on events
select music.insert_bands_on_events('Necrotted', 'Europe Summer 2024');
select music.insert_bands_on_events('Sanguisugabogg', 'Europe Summer 2024');

-- Bands from countries
select music.insert_bands_on_countries('Sanguisugabogg', 'USA');

-- Music genre
select music.insert_bands_to_genres('Sanguisugabogg', 'Death Metal');

*/

------------------------------------------------------------------------------------
/*

-- New events
select music.insert_event('Asinhell Live 2024', '2024.06.19', 'Frankfur am Main (Zoom)', 0::int2, 33.45, 2::int2);


-- Bands on events
select music.insert_bands_on_events('Asinhell', 'Asinhell Live 2024');
select music.insert_bands_on_events('Endseeker', 'Asinhell Live 2024');

-- Bands from countries
select music.insert_bands_on_countries('Asinhell', 'DNK');

-- Music genre
select music.insert_bands_to_genres('Asinhell', 'Death Metal');
*/

------------------------------------------------------------------------------------

/*
-- New events
select music.insert_events('Throw them in the van European summer tour 2024', '2024.06.27', 'Weinheim (Café Central)', 0, 34.0, 2);


-- Bands on events
select music.insert_bands_on_events('Dying Fetus', 'Throw them in the van European summer tour 2024');
select music.insert_bands_on_events('Fragments of unbecoming', 'Throw them in the van European summer tour 2024');


-- Bands from countries
select music.insert_bands_on_countries('Dying Fetus', 'USA');
select music.insert_bands_on_countries('Fragments of unbecoming', 'DEU');


-- Music genre
select music.insert_bands_to_genres('Dying Fetus', 'Brutal Death Metal');
select music.insert_bands_to_genres('Dying Fetus', 'Grindcore');
select music.insert_bands_to_genres('Fragments of unbecoming', 'Melodic Death Metal');
*/


------------------------------------------------------------------------------------
 



