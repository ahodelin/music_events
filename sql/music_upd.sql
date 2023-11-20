
/*insert into geo.countries 
  values 
    (md5(''), '', '');
   
insert into geo.countries_continents
  values (md5(''), md5(''));
*/
   
-- New events

insert into geo.places values (md5('Weibersbrunn (Mehrzweckhalle)'), 'Weibersbrunn (Mehrzweckhalle)');

select music.insert_events('Paganische Nacht - 2023', '2023.11.24', 'Weibersbrunn (Mehrzweckhalle)', 0);
select music.insert_events('Hell over Aschaffenburg - 2023', '2023.11.25', 'Weibersbrunn (Mehrzweckhalle)', 0);

-- Bands on events
select music.insert_bands_on_events('Asenblut', 'Paganische Nacht - 2023');
select music.insert_bands_on_events('Finterforst', 'Paganische Nacht - 2023');
select music.insert_bands_on_events('Arkuum', 'Paganische Nacht - 2023');
select music.insert_bands_on_events('Gernotshagen', 'Paganische Nacht - 2023');


select music.insert_bands_on_events('Fleschrawl', 'Hell over Aschaffenburg - 2023');
select music.insert_bands_on_events('Bodyfarm', 'Hell over Aschaffenburg - 2023');
select music.insert_bands_on_events('Discreation', 'Hell over Aschaffenburg - 2023');
select music.insert_bands_on_events('Divide', 'Hell over Aschaffenburg - 2023');
select music.insert_bands_on_events('Soul Grinder', 'Hell over Aschaffenburg - 2023');

-- Bands countries
select music.insert_bands_on_countries('Soul Grinder', 'Germany');
select music.insert_bands_on_countries('Arkuum', 'Germany');
select music.insert_bands_on_countries('Gernotshagen', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('Soul Grinder', 'Death Metal');
select music.insert_bands_to_generes('Arkuum', 'Atmospheric Post-Black Metal');
select music.insert_bands_to_generes('Gernotshagen', 'Pagan Black Metal');
select music.insert_bands_to_generes('Gernotshagen', 'Folk Metal');