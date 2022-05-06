drop schema if exists geo cascade;
drop schema if exists events cascade;

create schema geo;
create schema events;

create table geo.countries(
  country_id varchar primary key,
  country_name varchar not null unique
);

create table geo.places(
  place_id varchar primary key,
  place_name varchar not null unique,
  country_id varchar not null references geo.countries(country_id)
);

create table events.units(
  unit_id varchar primary key,
  unit_name varchar not null unique
);

create table events.distances(
  distance_id varchar primary key,
  distance decimal unique not null,
  unit_id varchar references events.units(unit_id)
);

create table events.competition(
  competition_id varchar primary key,
  competition_name varchar not null,
  competition_date date not null,
  competition_time interval not null,
  competition_number varchar,
  place_id varchar not null references geo.places(place_id),
  distance_id varchar not null references events.distances(distance_id)
);


insert into geo.countries
  values
    (md5('Cuba'), 'Cuba'),
    (md5('Germany'), 'Gremany')
;

insert into geo.places
  values
    (md5('Havana'), 'Havana', md5('Cuba')),
    (md5('Mainz'), 'Mainz', md5('Germany')),
    (md5('Bingen'), 'Bingen', md5('Germany'))
;

insert into events.units
  values 
    (md5('km'), 'km')
;

insert into events.distances
  values 
    (md5('5'), 5, md5('km')),
    (md5('7.8'), 7.8, md5('km')),
    (md5('21.0975'), 21.0975, md5('km')),
    (md5('42.195'), 42.195, md5('km'))
;


insert into events.competition
  values 
    (md5('Marabana 2007'),'Marabana 2007','2007-11-18','04:40:27','6142',md5('Havana'),md5('42.195')),
    (md5('Marabana 2008'),'Marabana 2008','2008-11-16','01:40:00','312',md5('Havana'),md5('21.0975')),
    (md5('Marabana 2009'),'Marabana 2009','2009-11-15','01:35:38','94',md5('Havana'),md5('21.0975')),
    (md5('12. Gutenberg Marathon'),'12. Gutenberg Marathon','2011-05-08','04:07:42','720',md5('Mainz'),md5('42.195')),
    (md5('13. Gutenberg Marathon'),'13. Gutenberg Marathon','2012-05-06','01:35:13','895',md5('Mainz'),md5('21.0975')),
    (md5('14. Gutenberg Marathon'),'14. Gutenberg Marathon','2013-05-12','01:41:05','5305',md5('Mainz'),md5('21.0975')),
    (md5('18. Gutenberg Marathon'),'18. Gutenberg Marathon','2017-05-07','01:39:27','1182',md5('Mainz'),md5('21.0975')),
    (md5('20. Gutenberg Marathon'),'20. Gutenberg Marathon','2019-05-05','01:41:31','1254',md5('Mainz'),md5('21.0975')),
    (md5('2. Binger Firmenlauf'),'2. Binger Firmenlauf','2015-06-18','00:19:37','0246',md5('Bingen'),md5('5')),
    (md5('3. Binger Firmenlauf'),'3. Binger Firmenlauf','2016-06-23','00:21:28','1174',md5('Bingen'),md5('5')),
    (md5('4. Binger Firmenlauf'),'4. Binger Firmenlauf','2017-06-23','00:19:09','0793',md5('Bingen'),md5('5')),
    (md5('26. Mainzer Drei-Brücken-Lauf'),'26. Mainzer Drei-Brücken-Lauf','2016-06-26','00:36:30','461',md5('Mainz'),md5('7.8')),
    (md5('22. Mainzer Drei-Brücken-Lauf'),'22. Mainzer Drei-Brücken-Lauf','2012-06-24','00:34:10','133',md5('Mainz'),md5('7.8')),
    (md5('27. Mainzer Drei-Brücken-Lauf'),'27. Mainzer Drei-Brücken-Lauf','2017-06-25','00:36:06','400',md5('Mainz'),md5('7.8')),
    (md5('25. Mainzer Drei-Brücken-Lauf'),'25. Mainzer Drei-Brücken-Lauf','2015-06-21','00:37:00','305',md5('Mainz'),md5('7.8')),
    (md5('Mainova Firmenlauf Mainz 2019'),'Mainova Firmenlauf Mainz 2019','2019-08-22','00:21:21','6398',md5('Mainz'),md5('5'))
;


create or replace view events.v_competitions
as
  select 
    e.competition_name "Competition",
    date_part('year', e.competition_date)::varchar "Year",
    to_char(e.competition_date, 'DayDD. Month') "Date",
    e.competition_number "Number",
    p.place_name 
    || ' (' || 
    c.country_name || ')' "Place",
    d.distance 
    || ' ' ||
    u.unit_name "Distance",
    e.competition_time "Time"
  from events.competition e
  join geo.places p
    on p.place_id = e.place_id 
  join geo.countries c 
    on p.country_id = c.country_id 
  join events.distances d 
    on e.distance_id = d.distance_id
  join events.units u
    on u.unit_id = d.unit_id
  order by e.competition_date
;

select * from events.v_competitions;