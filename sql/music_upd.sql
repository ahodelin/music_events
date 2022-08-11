/*insert into geo.places 
  values 
    (md5('Wacken'), 'Wacken');

   
insert into music.events 
   values
     (md5('Wacken Open Air 2022'), 'Wacken Open Air 2022', '2022.08.03', md5('Wacken'));
*/

insert into music.bands 
  values    
    (md5('Cattle Decapitation'), 'Cattle Decapitation', 'm');   
    (md5(''), 'Orca', 'y'),
    (md5(''), 'Kryn', 'm'),
    (md5(''), 'V.I.D.A', 'y'),
    (md5(''), 'Impartial', 'm'),
    (md5(''), 'Lycanthrope', 'm'),
    (md5(''), 'Speedemon', 'y'),
    (md5(''), 'The Risen Dead', 'y'),
    (md5(''), 'Divide', 'y'),
    (md5(''), 'Almøst Human', 'y'),
    (md5(''), 'Moral Putrefaction', 'y'),
    (md5(''), 'Cadaver', 'y'),
    (md5(''), 'Onslaught', 'm'),
    (md5(''), 'Criminal', 'y'),
    (md5(''), 'Tranatopsy', 'y'),
    (md5(''), 'Ludicia', 'y'),
    (md5(''), 'Komodo', 'm'),
    (md5(''), 'Typhus', 'm'),
    (md5(''), 'Múr', 'y'),
    (md5(''), 'Fusion Bomb', 'y'),
    (md5(''), 'Mork', 'y'),
    (md5(''), 'Gaerea', 'y'),
    (md5(''), 'Kampfar', 'm'),
    
    ;
 

insert into music.bands_countries  
  values
    (md5('Implore'), md5('Germany')),
    (md5('Ill Niño'), md5('USA')),
    (md5('Auðn'), md5('Iceland')),
    (md5('Striker'), md5('Canada')),
    (md5('Moonspell'), md5('Portugal')),
    (md5('Venom'), md5('UK')),
    (md5('Blood Incantation'), md5('USA')),
    (md5('Cattle Decapitation'), md5('USA')),
    (md5('Lost Society'), md5('Finland')),
    (md5('Crypta'), md5('Brazil')),
    (md5('Gwar'), md5('USA')),
    (md5('Kampfar'), md5('Norway')),
    (md5('Gaerea'), md5('')),
    (md5('Mork'), md5('')),
    (md5('Fusion Bomb'), md5('')),
    (md5('Múr'), md5('')),
    (md5('Typhus'), md5('')),
    (md5('Komodo'), md5('')),
    (md5('Ludicia'), md5('')),
    (md5('Tranatopsy'), md5('')),
    (md5('Criminal'), md5('Chile')),
    (md5('Onslaught'), md5('')),
    (md5('Cadaver'), md5('')),
    (md5('Moral Putrefaction'), md5('')),
    (md5('Almøst Human'), md5('')),
    (md5('Divide'), md5('')),
    (md5('The Risen Dead'), md5('')),
    (md5('Speedemon'), md5('')),
    (md5('Lycanthrope'), md5('')),
    (md5('Impartial'), md5('')),
    (md5('V.I.D.A'), md5('')),
    (md5('Kryn'), md5('')),
    (md5('Orca'), md5('')),
    (md5('Mythraeum'), md5(''))
;

insert into music.generes 
  values 
    (md5('Latin Metal'), 'Latin Metal'),
    (md5('New Wave of British Heavy Metal'), 'New Wave of British Heavy Metal'),
    (md5('Various'), 'Various')
;
--select * from music.generes g where genere like 'Melod%';

insert into music.bands_generes 
  values
    (md5('Implore'), md5('Blackened Death Metal')), --Blackened Death Metal/Grindcore/Crust
    (md5('Implore'), md5('Grindcore')), --Blackened Death Metal//
    (md5('Implore'), md5('Crust Metal')), --Blackened Death Metal/Grindcore/Crust
    (md5('Ill Niño'), md5('Nu Metal')),
    (md5('Ill Niño'), md5('Latin Metal')),
    (md5('Ill Niño'), md5('Alternative Metal')),
    (md5('Ill Niño'), md5('Metalcore')),
    (md5('Auðn'), md5('Atmospheric Black Metal')),
    (md5('Striker'), md5('Heavy Metal')),
    (md5('Striker'), md5('Power Metal')),
    (md5('Moonspell'), md5('Black Metal')), -- (early);  (later)
    (md5('Moonspell'), md5('Gothic Metal')), --Black Metal (early); Gothic Metal (later)
    (md5('Venom'), md5('Black Metal')), --NWOBHM//
    (md5('Venom'), md5('Speed Metal')), --NWOBHM/Black/Speed Metal
    (md5('Venom'), md5('New Wave of British Heavy Metal')), --NWOBHM/Black/Speed Metal
    (md5('Blood Incantation'), md5('Death Metal')),
    (md5('Cattle Decapitation'), md5('Progressive Death Metal')), --/Grindcore
    (md5('Cattle Decapitation'), md5('Grindcore')), --Progressive Death Metal/
    (md5('Lost Society'), md5('Thrash Metal')), -- (early); //Nu-Metal 
    (md5('Lost Society'), md5('Groove Metal')), --Thrash Metal (early); Groove Metal/Metalcore/Nu-Metal 
    (md5('Lost Society'), md5('Metalcore')), --Thrash Metal (early); Groove Metal/Metalcore/Nu-Metal 
    (md5('Lost Society'), md5('Nu Metal')), --Thrash Metal (early); Groove Metal/Metalcore/Nu-Metal 
    (md5('Crypta'), md5('Death Metal')),
    (md5('Gwar'), md5('Various')),
    (md5('Kampfar'), md5('Pagan Black Metal')),
    (md5('Gaerea'), md5('')),
    (md5('Mork'), md5('')),
    (md5('Fusion Bomb'), md5('')),
    (md5('Múr'), md5('')),
    (md5('Typhus'), md5('')),
    (md5('Komodo'), md5('')),
    (md5('Ludicia'), md5('')),
    (md5('Tranatopsy'), md5('')),
    (md5('Criminal'), md5('Chile')),
    (md5('Onslaught'), md5('')),
    (md5('Cadaver'), md5('')),
    (md5('Moral Putrefaction'), md5('')),
    (md5('Almøst Human'), md5('')),
    (md5('Divide'), md5('')),
    (md5('The Risen Dead'), md5('')),
    (md5('Speedemon'), md5('')),
    (md5('Lycanthrope'), md5('')),
    (md5('Impartial'), md5('')),
    (md5('V.I.D.A'), md5('')),
    (md5('Kryn'), md5('')),
    (md5('Orca'), md5('')),
    (md5('Mythraeum'), md5(''))
;

delete from music.bands where id_band = md5('Casttle Decapitation');
delete from music.bands_events  where id_band = md5('Cattle Decapitation');


insert into music.bands_events 
  values
    (md5('Cattle Decapitation'), md5('Wacken Open Air 2022'));

select count(id_band) from music.bands_events be where id_event = md5('Wacken Open Air 2022'); 