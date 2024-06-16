/*
insert into geo.countries 
  values 
    ('TCC', 'Test Country', 'tc');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/



-- New events
select music.insert_event('Europe Summer 2024', '2024.06.17', 'Wiesbaden (Schlachthof)', 0::int2, 29.30, 2::int2);


-- Bands on events
select music.insert_bands_on_events('Necrotted', 'Europe Summer 2024');
select music.insert_bands_on_events('Sanguisugabogg', 'Europe Summer 2024');

-- Bands from countries
select music.insert_bands_on_countries('Sanguisugabogg', 'USA');

-- Music genre
select music.insert_bands_to_genres('Sanguisugabogg', 'Death Metal');



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
 



