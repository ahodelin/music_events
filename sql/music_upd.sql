
insert into geo.countries 
  values 
    (md5('Jamaica'), 'Jamaica', 'jm');

   
-- New events
select music.insert_events('Summer in the City 2018', '2018.07.08', 'Mainz (Volkspark)', 1);

-- Bands on events


select music.insert_bands_on_events('Sting', 'Summer in the City 2018');
select music.insert_bands_on_events('Shaggy', 'Summer in the City 2018');

-- Bands countries
select music.insert_bands_on_countries('Sting', 'UK');
select music.insert_bands_on_countries('Shaggy', 'Jamaica');


-- Bands generes
select music.insert_bands_to_generes('Sting', 'Rock');
select music.insert_bands_to_generes('Sting', 'Pop');
select music.insert_bands_to_generes('Sting', 'Jazz');

select music.insert_bands_to_generes('Shaggy', 'Reggae');
