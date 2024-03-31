
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/


insert into geo.places values (md5('Karlsruhe (Alter Schlachthof - Substage)'), 'Karlsruhe (Alter Schlachthof - Substage)');

-- New events
select music.insert_events('Necromanteum EU/UK Tour 2024', '2024.03.30', 'Karlsruhe (Alter Schlachthof - Substage)', 0);

update music.events 
set price  = 
,persons = 2
where id_event = md5 ('Necromanteum EU/UK Tour 2024');


-- Bands on events
select music.insert_bands_on_events('Aborted', 'Necromanteum EU/UK Tour 2024');
select music.insert_bands_on_events('Carnifex', 'Necromanteum EU/UK Tour 2024');
select music.insert_bands_on_events('Revocation', 'Necromanteum EU/UK Tour 2024');
select music.insert_bands_on_events('Vexed', 'Necromanteum EU/UK Tour 2024');


-- Bands countries
select music.insert_bands_on_countries('Carnifex', 'USA');
select music.insert_bands_on_countries('Vexed', 'UK');

-- Bands generes
select music.insert_bands_to_generes('Carnifex', 'Deathcore');
select music.insert_bands_to_generes('Vexed', 'Alternative Metal');