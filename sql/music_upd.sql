/*insert into geo.places 
  values 
    (md5('Wacken'), 'Wacken');

   
insert into music.events 
   values
     (md5('Wacken Open Air 2022'), 'Wacken Open Air 2022', '2022.08.03', md5('Wacken'));
*/

insert into music.bands 
  values
    (md5(''), '', '')
;

insert into geo.countries 
  values 
    (md5(''), '', '')
;



--select * from music.generes g where genere like 'Melod%';

insert into music.bands_generes 
  values
    (md5(''), md5(''))
   ;


insert into music.bands_events 
  values
    (md5(''), md5(''));

select count(id_band) from music.bands_events be where id_event = md5('Wacken Open Air 2022'); 