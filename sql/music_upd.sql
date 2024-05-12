/*
insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/

-- 34.00 Dying Fetus



-- New events
select music.insert_events('"The Tide of Death and fractured Dreams" European Tour 2024', '2024.05.15', 'Wiesbaden (Schlachthof)', 0, 36.0, 2);


-- Bands on events
select music.insert_bands_on_events('Ingested', '"The Tide of Death and fractured Dreams" European Tour 2024');
select music.insert_bands_on_events('Fallujah', '"The Tide of Death and fractured Dreams" European Tour 2024');
select music.insert_bands_on_events('Vulvodynia', '"The Tide of Death and fractured Dreams" European Tour 2024');
select music.insert_bands_on_events('Mélancholia', '"The Tide of Death and fractured Dreams" European Tour 2024');

-- Bands countries
select music.insert_bands_on_countries('Fallujah', 'United States of America');
select music.insert_bands_on_countries('Vulvodynia', 'South Africa');
select music.insert_bands_on_countries('Mélancholia', 'Australia');


-- Bands generes
select music.insert_bands_to_generes('Fallujah', 'Deathcore');
select music.insert_bands_to_generes('Fallujah', 'Progressive Death Metal');
select music.insert_bands_to_generes('Fallujah', 'Technical Death Metal');
select music.insert_bands_to_generes('Vulvodynia', 'Deathcore');
select music.insert_bands_to_generes('Vulvodynia', 'Brutal Death Metal');
select music.insert_bands_to_generes('Mélancholia', 'Deathcore');

/*
 

-- New events
select music.insert_events('Thrash Metal Fest - 05.2024', '2024.05.16', 'Weinheim (Café Central)', 0, 30.0, 2);


-- Bands on events
select music.insert_bands_on_events('Nervosa', 'Thrash Metal Fest - 05.2024');
select music.insert_bands_on_events('Exhorder', 'Thrash Metal Fest - 05.2024');


-- New events
select music.insert_events('Back to the Roots Tour - 05.2024', '2024.05.17', 'Mörlenbach (LIVE MUSIC HALL Weiher)', 0, 23.20, 2);


-- Bands on events
select music.insert_bands_on_events('Spearhead', 'Back to the Roots Tour - 05.2024');
select music.insert_bands_on_events('South of Hessen', 'Back to the Roots Tour - 05.2024');

select music.insert_bands_on_countries('South of Hessen', 'Germany');

select music.insert_bands_to_generes('South of Hessen', 'Tribute to Slayer');




-- New events
select music.insert_events('Fleshcrawl + Fleshsphere + Torment of Souls', '2024.05.18', 'Mörlenbach (LIVE MUSIC HALL Weiher)', 0, 30.0, 2);


-- Bands on events
select music.insert_bands_on_events('Torment of Souls', 'Fleshcrawl + Fleshsphere + Torment of Souls');
select music.insert_bands_on_events('Fleshcrawl', 'Fleshcrawl + Fleshsphere + Torment of Souls');
select music.insert_bands_on_events('Fleshsphere', 'Fleshcrawl + Fleshsphere + Torment of Souls');


*/