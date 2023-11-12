
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/
   
-- New events

--insert into geo.places values (md5(''), '');

select music.insert_events('"Morbid Devastation"-Tour', '2023.11.17', 'Wiesbaden (Schlachthof)', 0);

-- Bands on events
select music.insert_bands_on_events('Cavalera Conspiracy', '"Morbid Devastation"-Tour');
select music.insert_bands_on_events('Incite', '"Morbid Devastation"-Tour');


-- Bands countries
select music.insert_bands_on_countries('Cavalera Conspiracy', 'USA');


-- Bands generes
select music.insert_bands_to_generes('Cavalera Conspiracy', 'Death Metal');
select music.insert_bands_to_generes('Cavalera Conspiracy', 'Thrash Metal');
select music.insert_bands_to_generes('Cavalera Conspiracy', 'Groove Metal');