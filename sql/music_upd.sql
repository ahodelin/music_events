
-- EUROPEAN MISERERE 2023: HARLOTT + BLOODSPOT + WITCHKRIEG @Frankfurt
--3 Juli @ 6:00 pm

/*insert into geo.countries 
  values 
    (md5('Israel'), 'Israel', 'il');
*/
-- Ton Steine Scherben - Wiesbaden(Schlachthof) - 01.10.2015
   
-- New events
select music.insert_events('Death Feast Open Air 2023', '2023.08.24', 'Andernach', 2);

-- Bands on events
select music.insert_bands_on_events('Putrid Pile', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Signs of the Swarm', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Squash Bowels', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Implore', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('VILE', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Suffocate Bastard', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Fleshless', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Anime Torment', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Plagueborne', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Schirenc Plays Pungent Stench', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Malignancy', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Milking the Goatmachine', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Kraanium', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Viscera Trail', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Teethgrinder', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Gutrectomy', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Embrace your Punishment', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Devangelic', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Monument of Misanthropy', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Ruins of Perception', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Kanine', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Cephalic Carnage', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Vulvectomy', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Torsofuck', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Cliteater', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Acranius', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Necrotted', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Crepitation', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Amputated', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Embryectomy', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Begging for Incest', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Colpocleisis', 'Death Feast Open Air 2023');
select music.insert_bands_on_events('Kinski', 'Death Feast Open Air 2023');

-- Bands countries
select music.insert_bands_on_countries('Putrid Pile', 'USA');
select music.insert_bands_on_countries('Signs of the Swarm', 'USA');
select music.insert_bands_on_countries('Squash Bowels', 'Poland');
--select music.insert_bands_on_countries('Implore', 'Germany');
select music.insert_bands_on_countries('VILE', 'USA');
select music.insert_bands_on_countries('Suffocate Bastard', 'Germany');
select music.insert_bands_on_countries('Fleshless', 'Czech Republic');
select music.insert_bands_on_countries('Anime Torment', 'Czech Republic');
--select music.insert_bands_on_countries('Plagueborne', 'Germany');
select music.insert_bands_on_countries('Malignancy', 'USA');
select music.insert_bands_on_countries('Kraanium', 'Norway');
select music.insert_bands_on_countries('Viscera Trail', 'Israel');
select music.insert_bands_on_countries('Gutrectomy', 'Germany');
select music.insert_bands_on_countries('Embrace your Punishment', 'France');
select music.insert_bands_on_countries('Devangelic', 'Italy');
select music.insert_bands_on_countries('Monument of Misanthropy', 'Austria');
select music.insert_bands_on_countries('Ruins of Perception', 'Germany');
select music.insert_bands_on_countries('Cephalic Carnage', 'USA');
select music.insert_bands_on_countries('Vulvectomy', 'Italy');
select music.insert_bands_on_countries('Torsofuck', 'Finland');
select music.insert_bands_on_countries('Cliteater', 'Netherlands');
select music.insert_bands_on_countries('Crepitation', 'UK');
select music.insert_bands_on_countries('Amputated', 'UK');
select music.insert_bands_on_countries('Embryectomy', 'Greece');
select music.insert_bands_on_countries('Colpocleisis', 'UK');
select music.insert_bands_on_countries('Kinski', 'Germany');

-- Bands generes
select music.insert_bands_to_generes('Putrid Pile', 'Brutal Death Metal');
select music.insert_bands_to_generes('Signs of the Swarm', 'Deathcore');
select music.insert_bands_to_generes('Squash Bowels', 'Goregrind');
--select music.insert_bands_to_generes('Implore', 'Blackend Death Metal');
--select music.insert_bands_to_generes('Implore', 'Grindcore');
--select music.insert_bands_to_generes('Implore', 'Crust');
select music.insert_bands_to_generes('VILE', 'Brutal Death Metal');
select music.insert_bands_to_generes('VILE', 'Melodic Death Metal');
select music.insert_bands_to_generes('Suffocate Bastard', 'Brutal Death Metal');
select music.insert_bands_to_generes('Fleshless', 'Death Metal');
select music.insert_bands_to_generes('Fleshless', 'Grindcore');
select music.insert_bands_to_generes('Fleshless', 'Melodic Death Metal');
select music.insert_bands_to_generes('Fleshless', 'Brutal Death Metal');
select music.insert_bands_to_generes('Anime Torment', 'Deathcore');
--select music.insert_bands_to_generes('Plagueborne', 'Death Metal');
select music.insert_bands_to_generes('Malignancy', 'Brutal Technical Death Metal');
select music.insert_bands_to_generes('Kraanium', 'Slam');
select music.insert_bands_to_generes('Kraanium', 'Brutal Death Metal');
select music.insert_bands_to_generes('Viscera Trail', 'Brutal Death Metal');
select music.insert_bands_to_generes('Viscera Trail', 'Grindcore');
select music.insert_bands_to_generes('Gutrectomy', 'Slam');
select music.insert_bands_to_generes('Gutrectomy', 'Brutal Death Metal');
select music.insert_bands_to_generes('Embrace your Punishment', 'Deathcore');
select music.insert_bands_to_generes('Embrace your Punishment', 'Hardcore');
select music.insert_bands_to_generes('Embrace your Punishment', 'Brutal Death Metal');
select music.insert_bands_to_generes('Devangelic', 'Brutal Death Metal');
select music.insert_bands_to_generes('Monument of Misanthropy', 'Brutal Deaht Metal');
select music.insert_bands_to_generes('Ruins of Perception', 'Deathcore');
select music.insert_bands_to_generes('Cephalic Carnage', 'Technical Grindcore');
select music.insert_bands_to_generes('Cephalic Carnage', 'Death Metal');
select music.insert_bands_to_generes('Vulvectomy', 'Slam');
select music.insert_bands_to_generes('Vulvectomy', 'Brutal Death Metal');
select music.insert_bands_to_generes('Torsofuck', 'Slam');
select music.insert_bands_to_generes('Torsofuck', 'Brutal Death Metal');
select music.insert_bands_to_generes('Torsofuck', 'Goregrind');
select music.insert_bands_to_generes('Cliteater', 'Goregrind');
select music.insert_bands_to_generes('Crepitation', 'Brutal Death Metal');
select music.insert_bands_to_generes('Amputated', 'Brutal Death Metal');
select music.insert_bands_to_generes('Embryectomy', 'Slam');
select music.insert_bands_to_generes('Embryectomy', 'Brutal Death Metal');
select music.insert_bands_to_generes('Colpocleisis', 'Slam');
select music.insert_bands_to_generes('Colpocleisis', 'Brutal Death Metal');
select music.insert_bands_to_generes('Kinski', 'Grindcore');