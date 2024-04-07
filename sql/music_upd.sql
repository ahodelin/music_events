
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/

-- 34.00 Dying Fetus

--insert into geo.places values (md5(' ()'), ' ()');

-- New events
select music.insert_events('', '2024.04.', ' ()', 0);

update music.events 
set price  = 
,persons = 2
where id_event = md5 ('');


-- Bands on events
select music.insert_bands_on_events('', '');

-- Bands countries
select music.insert_bands_on_countries('', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('', ' Metal');
