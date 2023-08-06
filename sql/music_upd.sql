
-- EUROPEAN MISERERE 2023: HARLOTT + BLOODSPOT + WITCHKRIEG @Frankfurt
--3 Juli @ 6:00 pm

/*insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('Dortmund Deathfest 2023', '2023.08.04', 'Dotmund (JunkYard)', 1);

-- Bands on events
select music.insert_bands_on_events('Kadaverficker', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Kanine', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Endseeker', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Brand of Secrifice', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Baest', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Cancer', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Defleshed', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('I am Morbid', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Kataklysm', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Resurrected', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Rise of Kronos', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Phantom Corporation', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Vomit the Soul', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Stillbirth', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Coffin Feeder', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Gutalax', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Schizophrenia', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Bodyfarm', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Blood Red Throne', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Krisiun', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Bloodbath', 'Dortmund Deathfest 2023');
select music.insert_bands_on_events('Decide', 'Dortmund Deathfest 2023');


-- Bands countries
select music.insert_bands_on_countries('Brand of Secrifice', 'Canada');
select music.insert_bands_on_countries('Defleshed', 'Sweden');
select music.insert_bands_on_countries('Resurrected', 'Germany');
select music.insert_bands_on_countries('Phantom Corporation', 'Germany');
select music.insert_bands_on_countries('Bodyfarm', 'Netherlands');
select music.insert_bands_on_countries('Krisiun', 'Brazil');
select music.insert_bands_on_countries('Bloodbath', 'Sweden');

-- Bands generes
select music.insert_bands_to_generes('Bloodbath', 'Death Metal');
select music.insert_bands_to_generes('Krisiun', 'Death Metal');
select music.insert_bands_to_generes('Bodyfarm', 'Death Metal');
select music.insert_bands_to_generes('Phantom Corporation', 'Death Metal');
select music.insert_bands_to_generes('Phantom Corporation', 'Crust');
select music.insert_bands_to_generes('Defleshed', 'Death Metal');
select music.insert_bands_to_generes('Defleshed', 'Thrash Metal');
select music.insert_bands_to_generes('Brand of Secrifice', 'Death Metal');
select music.insert_bands_to_generes('Brand of Secrifice', 'Brutal Death Metal');
select music.insert_bands_to_generes('Brand of Secrifice', 'Deathcore');
select music.insert_bands_to_generes('Resurrected', 'Brutal Death Metal');
select music.insert_bands_to_generes('Resurrected', 'Grindcore');