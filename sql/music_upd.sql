
insert into geo.places 
  values 
    (md5('Frankfurt am Main (Ponyhof Club)'), 'Frankfurt am Main (Ponyhof Club)');

   
insert into music.events 
   values
     (md5('Brutality Unleashed Tour 2022'), 'Brutality Unleashed Tour 2022', '2022.09.05', md5('Frankfurt am Main (Ponyhof Club)'));



insert into music.bands 
  values
    (md5('Impending Mindfuck'), 'Impending Mindfuck', 'y')
;


/*
insert into geo.countries 
  values 
    (md5(''), '', '');

insert into music.generes 
  values
    (md5(''), ''),
    (md5(''), ''),
    (md5(''), ''),
    (md5(''), ''),
    (md5(''), ''),
    (md5(''), '')
;
*/   
insert into music.bands_countries 
  values
    (md5('Impending Mindfuck'), md5('Germany'))
;

insert into music.bands_generes 
  values
    (md5('Impending Mindfuck'), md5('Slamming Brutal Death Metal'))
;


insert into music.bands_events 
  values
    (md5('Impending Mindfuck'), md5('Brutality Unleashed Tour 2022')),
    (md5('Stillbirth'), md5('Brutality Unleashed Tour 2022')),
    (md5('Gutslit'), md5('Brutality Unleashed Tour 2022')),
    (md5('Organectomy'), md5('Brutality Unleashed Tour 2022'))
;

