
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/


--insert into geo.places values (md5('Ludwigshafen am Rhein (Bon Scott Rock Cafe)'), 'Ludwigshafen am Rhein (Bon Scott Rock Cafe)');

-- New events
select music.insert_events('The young meatal attack', '2024.03.02', 'Ludwigshafen am Rhein (Bon Scott Rock Cafe)', 0);


-- Bands on events
select music.insert_bands_on_events('Warfield', 'The young meatal attack');
select music.insert_bands_on_events('Ascendancy', 'The young meatal attack');
select music.insert_bands_on_events('Screwed Death', 'The young meatal attack');

update music.bands 
set likes = 'm' where band in ('Ascendancy', 'Screwed Death');

-- Bands countries
select music.insert_bands_on_countries('Ascendancy', 'Germany');
select music.insert_bands_on_countries('Screwed Death', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('Ascendancy', 'Heavy Metal');
select music.insert_bands_to_generes('Screwed Death', 'Thrash Metal');
select music.insert_bands_to_generes('Screwed Death', 'Death Metal');