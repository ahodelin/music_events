/*i
nsert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('Easter Mosh', '2023.04.12', 'Mannheim (MS Connexion Complex)', 0);

-- Bands on events
select music.insert_bands_on_events('Antagonism', 'Easter Mosh');
select music.insert_bands_on_events('Inssanity Alert', 'Easter Mosh');
select music.insert_bands_on_events('Dust Bolt', 'Easter Mosh');
select music.insert_bands_on_events('Crisix', 'Easter Mosh');

-- Bands countries
select music.insert_bands_on_countries('Antagonism', 'France'); 

-- Bands generes
select music.insert_bands_to_generes('Antagonism', 'Thrash Metal');

