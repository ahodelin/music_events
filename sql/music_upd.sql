
insert into geo.countries 
  values 
    (md5('Estonia'), 'Estonia', 'ee');
   
insert into geo.countries_continents
  values (md5('Estonia'), md5('Europe'));


-- 34.00 Dying Fetus

-- insert into geo.places values (md5(' ()'), ' ()');

-- New events
select music.insert_events('Fintroll + Metsatöll + Suotana Tour 2024', '2024.04.22', 'Aschaffenburg (Colos-Saal)', 0);

update music.events 
set price  = 34.00
,persons = 2
where id_event = md5 ('Fintroll + Metsatöll + Suotana Tour 2024');


-- Bands on events
select music.insert_bands_on_events('Fintroll', 'Fintroll + Metsatöll + Suotana Tour 2024');
select music.insert_bands_on_events('Metsatöll', 'Fintroll + Metsatöll + Suotana Tour 2024');
select music.insert_bands_on_events('Suotana', 'Fintroll + Metsatöll + Suotana Tour 2024');

-- Bands countries
select music.insert_bands_on_countries('Fintroll', 'Finland');
select music.insert_bands_on_countries('Metsatöll', 'Estonia');
select music.insert_bands_on_countries('Suotana', 'Finland');

-- Bands generes
select music.insert_bands_to_generes('Fintroll', 'Blackened Folk Metal');
select music.insert_bands_to_generes('Metsatöll', 'Folk Metal');
select music.insert_bands_to_generes('Suotana', 'Melodic Death Metal');
select music.insert_bands_to_generes('Suotana', 'Power Metal');
