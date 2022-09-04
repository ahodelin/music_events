
insert into geo.places 
  values 
    (md5('Büchold'), 'Büchold');

   
insert into music.events 
   values
     (md5('Infernum meets Porkcore Festevil 2022'), 'Infernum meets Porkcore Festevil 2022', '2022.09.02', md5('Büchold'));



insert into music.bands 
  values
    (md5('Shores of Lunacy'), 'Shores of Lunacy', 'y'),
    (md5('April in Flames'), 'April in Flames', 'y'),
    (md5('Asinis'), 'Asinis', 'y'),
    (md5('Mike Litoris Complot'), 'Mike Litoris Complot', 'y'),
    (md5('Lesson in Violence'), 'Lesson in Violence', 'y'),
    (md5('Urinal Tribunal'), 'Urinal Tribunal', 'y'),
    (md5('Melodramatic Fools'), 'Melodramatic Fools', 'y'),
    
    (md5('Cypecore'), 'Cypecore', 'y')
;
insert into music.bands 
values (md5('Shot Crew'), 'Shot Crew', 'y');


delete from music.bands where id_band = md5('Shotcrew');

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
    (md5('Shores of Lunacy'), md5('Germany')),
    (md5('April in Flames'), md5('Germany')),
    (md5('Asinis'), md5('Germany')),
    (md5('Mike Litoris Complot'), md5('Luxembourg')),
    (md5('Lesson in Violence'), md5('Germany')),
    (md5('Urinal Tribunal'), md5('Germany')),
    (md5('Melodramatic Fools'), md5('Germany')),
    (md5('Cypecore'), md5('Germany')),
    (md5('Shot Crew'), md5('Germany'))
;

insert into music.bands_generes 
  values
    (md5('Shores of Lunacy'), md5('Deathcore')),
    (md5('April in Flames'),  md5('Groove Metal')),
    (md5('Asinis'), md5('Metalcore')),
    (md5('Mike Litoris Complot'), md5('Brutal Death Metal')),
    (md5('Mike Litoris Complot'), md5('Grindcore')),
    (md5('Lesson in Violence'), md5('Thrash Metal')),
    (md5('Urinal Tribunal'), md5('Grindcore')),
    (md5('Melodramatic Fools'), md5('Thrash Metal')),
    (md5('Melodramatic Fools'), md5('Heavy Metal')),
    (md5('Melodramatic Fools'), md5('Hard Rock')),
    (md5('Cypecore'), md5('Metalcore')),
    (md5('Cypecore'), md5('Melodic Groove Metal')),
    (md5('Cypecore'), md5('Industrial Metal')),
    (md5('Shot Crew'), md5('Rock')),
    (md5('Shot Crew'), md5('Metal'))
;


insert into music.bands_events 
  values
    (md5('Shores of Lunacy'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('April in Flames'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Asinis'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Disbelief'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Debauchery''s Balgeroth'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Mike Litoris Complot'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Lesson in Violence'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Urinal Tribunal'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Melodramatic Fools'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Endlevel'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Stillbirth'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Cypecore'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Crisix'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Ektomorf'), md5('Infernum meets Porkcore Festevil 2022')),
    (md5('Shot Crew'), md5('Infernum meets Porkcore Festevil 2022'))
;

