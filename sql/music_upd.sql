/*
insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/





-- New events
select music.insert_event('Grabbenacht Festival 2024', '2024.05.31', 'Schriesheim', 1::int2, 49.0, 2::int2);


-- Bands on events
--select music.insert_bands_on_events('Begging for Incest', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Bösedeath', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Hellknife', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Fleshsphere', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Hour of Penance', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Public Grave', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Embrace your Punishment', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Volière', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Zementmord', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('Lunatic Dictator', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('These Days & Those Days', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events('The Creatures from the Tomb', 'Grabbenacht Festival 2024');
--delete from music.bands_events where id_band = md5('The Creatures from the Tomb') and id_event = md5('Grabbenacht Festival 2024');  

--select music.insert_bands_on_events('Napoli Violenta', 'Grabbenacht Festival 2024');
--select music.insert_bands_on_events_mod('Rectal Depravity', 'Grabbenacht Festival 2024');

-- Bands from countries
--select music.insert_bands_on_countries('Satan''s Revenge on Mankind', 'DEU');
--select music.insert_bands_on_countries('Haunted Cemetery', 'DEU');
--select music.insert_bands_on_countries('Hour of Penance', 'ITA');
--select music.insert_bands_on_countries('Public Grave', 'DEU');
--select music.insert_bands_on_countries('Embrace your Punishment', 'FRA');
--select music.insert_bands_on_countries('Zementmord', 'DEU');
--select music.insert_bands_on_countries('Lunatic Dictator', 'DEU');
--select music.insert_bands_on_countries('These Days & Those Days', 'CHE');
--select music.insert_bands_on_countries('Napoli Violenta', 'ITA');
--select music.insert_bands_on_countries('Rectal Depravity', 'CHE');
--select music.insert_bands_on_countries('Volière', 'BEL');

-- Music genre
--select music.insert_bands_to_genres('Satan''s Revenge on Mankind', 'Porno Gore Grind');
--select music.insert_bands_to_genres('Haunted Cemetery', 'Death Metal');
--select music.insert_bands_to_genres('Hour of Penance', 'Technical Death Metal');
--select music.insert_bands_to_genres('Hour of Penance', 'Brutal Death Metal');
--select music.insert_bands_to_genres('Public Grave', 'Death Metal');
--select music.insert_bands_to_genres('Embrace your Punishment', 'Deathcore');
--select music.insert_bands_to_genres('Embrace your Punishment', 'Hardcore');
--select music.insert_bands_to_genres('Embrace your Punishment', 'Brutal Death Metal');
--select music.insert_bands_to_genres('Embrace your Punishment', 'Brutal Hardcore');
--select music.insert_bands_to_genres('Zementmord', 'Grindcore');
--select music.insert_bands_to_genres('Lunatic Dictator', 'Death Metal');
--select music.insert_bands_to_genres('Lunatic Dictator', 'Thrash Metal');
--select music.insert_bands_to_genres('These Days & Those Days', 'Slamming Hardcore Death');
--select music.insert_bands_to_genres('Napoli Violenta', 'Grindcore');
--select music.insert_bands_to_genres('Napoli Violenta', 'Hardcore');
--select music.insert_bands_to_genres('Rectal Depravity', 'Death Metal');
--select music.insert_bands_to_genres('Rectal Depravity', 'Goregrind');
--select music.insert_bands_to_genres('Volière', 'Brutal Death Metal');
--select music.insert_bands_to_genres('Volière', 'Goregrind');


------------------------------------------------------------------------------------
/*
-- New events
select music.insert_events('Europe Summer 2024', '2024.06.17', 'Wiesbaden (Schlachthof)', 0, 29.30, 2);


-- Bands on events
select music.insert_bands_on_events('Necrotted ', 'Europe Summer 2024');
select music.insert_bands_on_events('Sanguisugabogg', 'Europe Summer 2024');

-- Bands from countries
select music.insert_bands_on_countries('Sanguisugabogg', 'USA');

-- Music genre
select music.insert_bands_to_genres('Sanguisugabogg', 'Death Metal');
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
 



