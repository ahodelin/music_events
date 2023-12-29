
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/


--insert into geo.places values (md5(''), '');

-- New events
select music.insert_events('Evil Obsession 2023', '2023.12.28', 'Heidelberg (halle 02)', 0);


-- Bands on events
select music.insert_bands_on_events('Sodom', 'Evil Obsession 2023');
select music.insert_bands_on_events('Knife2', 'Evil Obsession 2023');
select music.insert_bands_on_events('Soulburn', 'Evil Obsession 2023');
select music.insert_bands_on_events('Imha Tarikat', 'Evil Obsession 2023');


-- Bands countries
select music.insert_bands_on_countries('Knife2', 'Germany');
select music.insert_bands_on_countries('Imha Tarikat', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('Knife2', 'Blackened Speed Metal');
select music.insert_bands_to_generes('Knife2', 'Punk');
select music.insert_bands_to_generes('Imha Tarikat', 'Black Metal');
