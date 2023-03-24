/*i
nsert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('Ravaging Europe 2023', '2023.03.29', 'Mannheim (7er-Club)', 0);

-- Bands on events
select music.insert_bands_on_events('Evil Invaders', 'Ravaging Europe 2023');
select music.insert_bands_on_events('Mason', 'Ravaging Europe 2023');
select music.insert_bands_on_events('Schizophrenia', 'Ravaging Europe 2023');
select music.insert_bands_on_events('Warbringer', 'Ravaging Europe 2023');

-- Bands countries
select music.insert_bands_on_countries('Mason', 'Australia'); 

-- Bands generes
select music.insert_bands_to_generes('Mason', 'Thrash Metal');
select music.insert_bands_to_generes('Mason', 'Groove Metal');
