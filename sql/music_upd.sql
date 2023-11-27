
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/
   
-- New events

insert into geo.places values (md5('Hofheim (Jazzkeller)'), 'Hofheim (Jazzkeller)');

select music.insert_events('Slice Me Nice 2023', '2023.12.02', 'Hofheim (Jazzkeller)', 0);
-- Bands on events
select music.insert_bands_on_events('Gutalax', 'Slice Me Nice 2023');
select music.insert_bands_on_events('Brutal Sphincter', 'Slice Me Nice 2023');
select music.insert_bands_on_events('Mike Litoris Complot', 'Slice Me Nice 2023');
select music.insert_bands_on_events('Slamentation', 'Slice Me Nice 2023');



-- Bands countries
select music.insert_bands_on_countries('Slamentation', 'International');
select music.insert_bands_on_countries('Mike Litoris Complot', 'Luxembourg');

-- Bands generes
select music.insert_bands_to_generes('Slamentation', 'Slam Metal');
select music.insert_bands_to_generes('Slamentation', 'Brutal Death Metal');
select music.insert_bands_to_generes('Mike Litoris Complot', 'Brutal Death Metal');
select music.insert_bands_to_generes('Mike Litoris Complot', 'Grindcore');