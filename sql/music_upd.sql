
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/
   
-- New events
select music.insert_events('', '2023.10.', '', 0);

-- Bands on events
select music.insert_bands_on_events('', '');

select * from music.bands b 
where band like '';

-- Bands countries
select music.insert_bands_on_countries('', '');

-- Bands generes
select music.insert_bands_to_generes('', '');