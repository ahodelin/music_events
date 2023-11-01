
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/
   
-- New events
select music.insert_events('Halloween mit Hängerbänd und Hellbent on Rocking', '2023.10.31', 'Mainz (Alexander the Great)', 0);

select music.insert_events('', '2023.11.04', '', 0);

-- Bands on events
select music.insert_bands_on_events('Hängerbänd', 'Halloween mit Hängerbänd und Hellbent on Rocking');
select music.insert_bands_on_events('Hellbent on Rocking', 'Halloween mit Hängerbänd und Hellbent on Rocking');



-- Bands countries
select music.insert_bands_on_countries('Hellbent on Rocking', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('Hellbent on Rocking', 'Punk Rock');
select music.insert_bands_to_generes('Hellbent on Rocking', 'Punk''n''Roll');