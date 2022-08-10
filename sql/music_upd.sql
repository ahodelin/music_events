/*insert into geo.places 
  values 
    (md5('Wacken'), 'Wacken');

   
insert into music.events 
   values
     (md5('Wacken Open Air 2022'), 'Wacken Open Air 2022', '2022.08.03', md5('Wacken'));
*/

insert into music.bands 
  values    
    (md5(''), 'Mythraeum', 'y'),   
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
    (md5('Implore'), md5('')),
    (md5('Ill Niño'), md5('')),
    (md5('Auðn'), md5('')),
    (md5('Striker'), md5('Canada')),
    (md5('Moonspell'), md5('Portugal')),
    (md5('Venom'), md5('UK')),
    (md5('Blood Incarnation'), md5('')),
    (md5('Casttle Decapitation'), md5('')),
    (md5('Lost Society'), md5('')),
    (md5('Crypta'), md5('Brazil')),
    (md5('Gwar'), md5('')),
    (md5('Kampfar'), md5('')),
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

/*insert into music.generes 
  values 
    (md5(''), '')
;*/
--select * from music.generes g where genere like 'Melod%';

insert into music.bands_generes 
  values
    (md5(''), md5(''));


insert into music.bands_events 
  values
    (md5(''), md5(''));

select count(id_band) from music.bands_events be where id_event = md5('Wacken Open Air 2022'); 