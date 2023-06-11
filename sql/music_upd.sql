/*
insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
--select music.insert_events('Grabbenacht Festival 2023', '2023.06.09', 'Schriesheim', 1);

-- Bands on events
--select music.insert_bands_on_events('Revel in Flesh', 'Grabbenacht Festival 2023');
--select music.insert_bands_on_events('Acranius', 'Grabbenacht Festival 2023');
--select music.insert_bands_on_events('sign of death', 'Grabbenacht Festival 2023');
--select music.insert_bands_on_events('Nervecell', 'Grabbenacht Festival 2023');
--select music.insert_bands_on_events('Knockdown Brutality', 'Grabbenacht Festival 2023');
--select music.insert_bands_on_events('Bitchfork', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('WeedWizard', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Human Waste', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Braincasket', 'Grabbenacht Festival 2023');
--select music.insert_bands_on_events('Pighead', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('5 Stabbed 4 Corpses', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Pusboil', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Vibrio Cholera', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Demorphed', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('OPS - Orphan Playground Sniper', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Vor die Hunde', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Hereza', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Gorgatron', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Rottenness', 'Grabbenacht Festival 2023');
select music.insert_bands_on_events('Nuclear Vomit', 'Grabbenacht Festival 2023');

-- Bands countries
select music.insert_bands_on_countries('WeedWizard', 'Germany');
select music.insert_bands_on_countries('Human Waste', 'Germany');
select music.insert_bands_on_countries('Braincasket', 'Netherlands');
select music.insert_bands_on_countries('5 Stabbed 4 Corpses', 'Germany');
select music.insert_bands_on_countries('Pusboil', 'Switzerland');
select music.insert_bands_on_countries('Vibrio Cholera', 'Germany');
select music.insert_bands_on_countries('Demorphed', 'Germany');
select music.insert_bands_on_countries('OPS - Orphan Playground Sniper', 'Germany');
select music.insert_bands_on_countries('Vor die Hunde', 'Germany');
select music.insert_bands_on_countries('Hereza', 'Croatia');
select music.insert_bands_on_countries('Nuclear Vomit', 'Poland');
--select music.insert_bands_on_countries('Nervecell', 'Dubai');
select music.insert_bands_on_countries('Gorgatron', 'USA');
select music.insert_bands_on_countries('Rottenness', 'Mexico');

-- Bands generes
--select music.insert_bands_to_generes('Nervecell', 'Death Metal');
--select music.insert_bands_to_generes('Nervecell', 'Thrash Metal');
select music.insert_bands_to_generes('WeedWizard', 'Stoner Metal');
select music.insert_bands_to_generes('WeedWizard', 'Doom Metal');
select music.insert_bands_to_generes('WeedWizard', 'Sludge Metal');
select music.insert_bands_to_generes('Human Waste', 'Brutal Death Metal');
select music.insert_bands_to_generes('Braincasket', 'Brutal Death Metal');
select music.insert_bands_to_generes('5 Stabbed 4 Corpses', 'Brutal Death Metal');
select music.insert_bands_to_generes('5 Stabbed 4 Corpses', 'Goregrind');
select music.insert_bands_to_generes('Pusboil', 'Brutal Death Metal');
select music.insert_bands_to_generes('Pusboil', 'Slam Metal');
select music.insert_bands_to_generes('Vibrio Cholera', 'Hardcore');
select music.insert_bands_to_generes('Vibrio Cholera', 'Death Metal');
select music.insert_bands_to_generes('Demorphed', 'Death Metal');
select music.insert_bands_to_generes('OPS - Orphan Playground Sniper', 'Brutal Death Metal');
select music.insert_bands_to_generes('Vor die Hunde', 'Grindcore');
select music.insert_bands_to_generes('Vor die Hunde', 'Death Metal');
select music.insert_bands_to_generes('Vor die Hunde', 'Crust Punk');
select music.insert_bands_to_generes('Hereza', 'Death Metal');
select music.insert_bands_to_generes('Hereza', 'Thras Metal');
select music.insert_bands_to_generes('Gorgatron', 'Death Metal');
select music.insert_bands_to_generes('Gorgatron', 'Grindcore');
select music.insert_bands_to_generes('Rottenness', 'Grindcore');
select music.insert_bands_to_generes('Rottenness', 'Brutal Death Metal');
select music.insert_bands_to_generes('Nuclear Vomit', 'Grindcore');
select music.insert_bands_to_generes('Nuclear Vomit', 'Death Metal');