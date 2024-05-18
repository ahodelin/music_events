/*
insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/

-- New events
select music.insert_events('Fleshcrawl + Fleshsphere + Torment of Souls', '2024.05.18', 'Mörlenbach (LIVE MUSIC HALL Weiher)', 0, 30.0, 2);


-- Bands on events
select music.insert_bands_on_events('Torment of Souls', 'Fleshcrawl + Fleshsphere + Torment of Souls');
select music.insert_bands_on_events('Fleshcrawl', 'Fleshcrawl + Fleshsphere + Torment of Souls');
select music.insert_bands_on_events('Fleshsphere', 'Fleshcrawl + Fleshsphere + Torment of Souls');
 

/*
-- New events
select music.insert_events('', '2024.06.', '', 0, -.0, 2);


-- Bands on events
select music.insert_bands_on_events('', '');
select music.insert_bands_on_events('', '');


-- Bands from countries
select music.insert_bands_on_countries('', '');

-- Music genre
select music.insert_bands_to_generes('', '');

------------------------------------------------------------------------------------

-- New events
select music.insert_events('Throw them in the van European summer tour 2024', '2024.06.27', 'Weinheim (Café Central)', 0, 34.0, 2);


-- Bands on events
select music.insert_bands_on_events('Dying Fetus', 'Throw them in the van European summer tour 2024');
select music.insert_bands_on_events('Fragments of unbecoming', 'Throw them in the van European summer tour 2024');


-- Bands from countries
select music.insert_bands_on_countries('Dying Fetus', 'USA');
select music.insert_bands_on_countries('Fragments of unbecoming', 'DEU');


-- Music genre
select music.insert_bands_to_generes('Dying Fetus', 'Brutal Death Metal');
select music.insert_bands_to_generes('Dying Fetus', 'Grindcore');
select music.insert_bands_to_generes('Fragments of unbecoming', 'Melodic Death Metal');


------------------------------------------------------------------------------------
 



