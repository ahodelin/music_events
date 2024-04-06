
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/

-- 34.00 Dying Fetus

insert into geo.places values (md5('Ludwigshafen (Kulturzentrum dasHaus)'), 'Ludwigshafen (Kulturzentrum dasHaus)');

-- New events
select music.insert_events('Thrash Attack - 06.04.2024', '2024.04.06', 'Ludwigshafen (Kulturzentrum dasHaus)', 0);

update music.events 
set price  = 16.52
,persons = 2
where id_event = md5 ('Thrash Attack - 06.04.2024');


-- Bands on events
select music.insert_bands_on_events('Warfield', 'Thrash Attack - 06.04.2024');
select music.insert_bands_on_events('Megalive', 'Thrash Attack - 06.04.2024');
select music.insert_bands_on_events('Hell Patröl', 'Thrash Attack - 06.04.2024');
select music.insert_bands_on_events('Spitfire', 'Thrash Attack - 06.04.2024');


-- Bands countries
select music.insert_bands_on_countries('Welded', 'Germany');
select music.insert_bands_on_countries('Megalive', 'Germany');
select music.insert_bands_on_countries('Spitfire', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('Megalive', 'Tribute to Megadeth');
select music.insert_bands_to_generes('Spetfire', 'Speed Metal');
select music.insert_bands_to_generes('Spetfire', 'Thrash Metal');
