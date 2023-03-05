
insert into geo.places 
  values 
    (md5(' ()'), ' ()');


insert into geo.countries 
  values 
    (md5(''), '', '');

insert into music.generes 
  values
    (md5('Death-Grind'), 'Death-Gind')
;
   

insert into music.events 
   values
     (md5('Campaing for musical destruction'), 'Campaing for musical destruction', '2023.03.03', md5('Heidelberg (halle 02)'))
     ;



insert into music.bands 
  values
    (md5('Dropdead'), 'Dropdead', 'y'),
    (md5('Escuela Grind'), 'Escuela Grind', 'y');
    (md5(''), '', 'y'),
    (md5(''), '', 'y');
    (md5(''), '', 'y'),
    (md5(''), '', 'y'),
    (md5(''), '', 'y'),
    (md5(''), '', 'y'),
    (md5(''), '', 'y'),
;


insert into music.bands_countries 
  values
    (md5('Dropdead'), md5('USA')),
    (md5('Escuela Grind'), md5('USA'));
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5(''))
;

insert into music.bands_generes 
  values
    (md5('Dropdead'), md5('Hardcore Punk')),
    (md5('Escuela Grind'), md5('Death-Grind'));
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
;


insert into music.bands_events 
  values
    (md5('Napalm Death'), md5('Campaing for musical destruction')),
    (md5('Siberian Meat Grinder'), md5('Campaing for musical destruction')),
    (md5('Dropdead'), md5('Campaing for musical destruction')),
    (md5('Escuela Grind'), md5('Campaing for musical destruction'));
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
    (md5(''), md5('')),
;

