
-- EUROPEAN MISERERE 2023: HARLOTT + BLOODSPOT + WITCHKRIEG @Frankfurt
--3 Juli @ 6:00 pm

/*insert into geo.countries 
  values 
    (md5(''), '', '');
*/
   
-- New events
select music.insert_events('In Flammen Open Air 2023', '2023.07.13', 'Turgau/Entenfang', 2);

-- update music.events set duration = 0 where id_event in ('e59ace10fad0af976f723748e6fd2ea8', '2200574eb6396407ec9fc642c91f0e5a');

-- Bands on events
delete from music.bands where id_band = md5('Lik'); 

insert into music.bands values(md5('LIK'), 'LIK', 'y');

update music.bands_generes  set id_band = md5('LIK') where id_band = md5('Lik');


--select music.insert_bands_on_events('Demored', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Angstskíg', 'In Flammen Open Air 2023');
select music.insert_bands_on_events('Ash Nazg Búrz', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Infest', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Corrupt', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Ellende', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Incantation', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Unleashed', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Tiamat', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Embryo', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Shampoon Killer', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Boötes Void', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Divide', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Ash Nazg Búrz', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Gorleben', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Bitchhammer', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Sněť', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Kadaverficker', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Maceration', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Mephorash', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Holy Moses', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Haemorrhage', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Methane', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Necrosy', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Heretoir', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Hierophant', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Crypta', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Massacre', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Sirrush', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Midnight', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Tankard', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Mystifier', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('Possessed', 'In Flammen Open Air 2023');
--select music.insert_bands_on_events('', 'In Flammen Open Air 2023');

-- Bands countries
select music.insert_bands_on_countries('Angstskíg', 'Denmark');
select music.insert_bands_on_countries('Infest', 'Serbia');
select music.insert_bands_on_countries('Corrupt', 'USA');
select music.insert_bands_on_countries('Incantation', 'USA');
select music.insert_bands_on_countries('Tiamat', 'Sweden');
select music.insert_bands_on_countries('Embryo', 'Italy');
select music.insert_bands_on_countries('Shampoon Killer', 'Czech Republic');
select music.insert_bands_on_countries('Boötes Void', 'Germany');
--select music.insert_bands_on_countries('Divide', 'Germany');
select music.insert_bands_on_countries('Ash Nazg Búrz', 'Mexico');
select music.insert_bands_on_countries('Gorleben', 'Germany');
select music.insert_bands_on_countries('Bitchhammer', 'Germany');
select music.insert_bands_on_countries('Sněť', 'Czech Republic');
select music.insert_bands_on_countries('Kadaverficker', 'Germany');
select music.insert_bands_on_countries('Maceration', 'Denmark');
select music.insert_bands_on_countries('Mephorash', 'Sweden');
select music.insert_bands_on_countries('Holy Moses', 'Germany');
select music.insert_bands_on_countries('Haemorrhage', 'Spain');
select music.insert_bands_on_countries('Methane', 'Sweden');
select music.insert_bands_on_countries('Necrosy', 'Italy');
select music.insert_bands_on_countries('Massacre', 'USA');
select music.insert_bands_on_countries('Sirrush', 'Italy');
select music.insert_bands_on_countries('Midnight', 'USA');
select music.insert_bands_on_countries('Mystifier', 'Brazil');
select music.insert_bands_on_countries('Possessed', 'USA');


-- Bands generes
select music.insert_bands_to_generes('Ash Nazg Búrz', 'Black Metal');

delete from music.bands_generes where id_band in ('82fec7eb7e259958a93f232e0748fe3f', '07cbac194f0065562af797f619d04635');


select music.insert_bands_to_generes('Infest', 'Thrash Metal');
select music.insert_bands_to_generes('Infest', 'Death Metal');
select music.insert_bands_to_generes('Corrupt', 'Thrash Metal');
select music.insert_bands_to_generes('Corrupt', 'Death Metal');
select music.insert_bands_to_generes('Incantation', 'Death Metal');
select music.insert_bands_to_generes('Tiamat', 'Death Metal');
select music.insert_bands_to_generes('Tiamat', 'Doom Metal');
select music.insert_bands_to_generes('Tiamat', 'Gothic Metal');
select music.insert_bands_to_generes('Tiamat', 'Gothic Rock');
select music.insert_bands_to_generes('Embryo', 'Melodic Death Metal');
select music.insert_bands_to_generes('Embryo', 'Metalcore');
select music.insert_bands_to_generes('Shampoon Killer', 'Brutal Death Metal');
select music.insert_bands_to_generes('Boötes Void', 'Black Metal');
select music.insert_bands_to_generes('Divide', 'Death Metal');
select music.insert_bands_to_generes('Ash Nasg Búrz', 'Black Metal');
select music.insert_bands_to_generes('Gorleben', 'Doom Metal');
select music.insert_bands_to_generes('Gorleben', 'Death Metal');
select music.insert_bands_to_generes('Gorleben', 'Hardcore');
select music.insert_bands_to_generes('Bitchhammer', 'Black Metal');
select music.insert_bands_to_generes('Bitchhammer', 'Thrash Metal');
select music.insert_bands_to_generes('Sněť', 'Death Metal');
select music.insert_bands_to_generes('Kadaverficker', 'Sludge Metal');
select music.insert_bands_to_generes('Kadaverficker', 'Death Metal');
select music.insert_bands_to_generes('Kadaverficker', 'Grindcore');
select music.insert_bands_to_generes('Maceration', 'Death Metal');
select music.insert_bands_to_generes('Mephorash', 'Black Metal');
select music.insert_bands_to_generes('Holy Moses', 'Speed Metal');
select music.insert_bands_to_generes('Holy Moses', 'Thrash Metal');
select music.insert_bands_to_generes('Haemorrhage', 'Goregrind');
select music.insert_bands_to_generes('Methane', 'Southern Metal');
select music.insert_bands_to_generes('Methane', 'Groove Metal');
select music.insert_bands_to_generes('Methane', 'Thrash Metal');
select music.insert_bands_to_generes('Necrosy', 'Technical Death Metal');
select music.insert_bands_to_generes('Massacre', 'Death Metal');
select music.insert_bands_to_generes('Sirrush', 'Black Metal');
select music.insert_bands_to_generes('Sirrush', 'Death Metal');
select music.insert_bands_to_generes('Midnight', 'Black Metal');
select music.insert_bands_to_generes('Midnight', 'Speed Metal');
select music.insert_bands_to_generes('Mystifier', 'Black Metal');
select music.insert_bands_to_generes('Mystifier', 'Death Metal');
select music.insert_bands_to_generes('Possessed', 'Death Metal');
select music.insert_bands_to_generes('Possessed', 'Thrash Metal');