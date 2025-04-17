--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Ubuntu 17.4-1.pgdg24.04+2)
-- Dumped by pg_dump version 17.4 (Ubuntu 17.4-1.pgdg24.04+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: geo; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA geo;


--
-- Name: music; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA music;


--
-- Name: insert_bands_on_countries(character varying, character varying); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_bands_on_countries(ban character varying, countr character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
declare 
  i_band varchar;
  i_countr varchar;
begin 
	
  select id_band, id_country into i_band, i_countr
  from music.bands_countries bc
  where id_band = md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))) and id_country = countr for update;
 
  if found then
    return 'This combination of band and country exist';
  else
	 
    select id_country into i_countr 
    from geo.countries c  
    where id_country = countr for update;
 
    if not found then    
      return 'Please insert this country first';
    end if;
   
    select id_band into i_band
    from music.bands
    where band = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), ban, 'y');
    end if; 
  
    insert into music.bands_countries
    values(md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), countr);
    return concat(ban, ' - ', countr, ' inserted'); 
   
  end if;
	  
end;
$$;


--
-- Name: insert_bands_on_events(character varying, character varying); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_bands_on_events(ban character varying, eve character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
declare 
  i_band varchar;
  i_e varchar;
begin 
	
  select id_band, id_event into i_band, i_e
  from music.bands_events be 
  where id_band = md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))) and id_event = md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))) for update;
 
 if found then
   return 'This combination Band - Event exist.';
 end if;
 
  select id_event into i_e 
  from music.events e 
  where "event" = eve for update;
 
  if not found then    
    return 'This event does not exist';
  else 
    select id_band into i_band
    from music.bands
    where band  = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), ban, 'y');
  	 
  	  insert into music.bands_events
      values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))));
     
      return 'New Band - Event inserted';
     
    else
      insert into music.bands_events
      values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))));
     
      return concat(ban, ' - ', eve, ' inserted');  
    end if;
  end if;
end;
$$;


--
-- Name: insert_bands_to_genres(character varying, character varying); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_bands_to_genres(ban character varying, gen character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
declare 
  i_band varchar;
  i_gen varchar;
begin 
	
  select id_genre, id_band into i_gen, i_band
  from music.bands_genres bg 
  where id_band = md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))) and id_genre = md5(lower(regexp_replace(gen, '\s|\W', '', 'g'))) for update;
  
  if found then
    return concat('This combination ', ban, ' - ', gen, ' exist');
  else
  
    select id_genre into i_gen 
    from music.genres g
    where genre = gen for update;
 
    if not found then    
      insert into music.genres
  	  values (md5(lower(regexp_replace(gen, '\s|\W', '', 'g'))), gen);
    end if;
	
    select id_band into i_band
    from music.bands
    where band = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), ban, 'y');
    end if;
  
    insert into music.bands_genres
    values(md5(lower(regexp_replace(ban, '\s|\W', '', 'g'))), md5(lower(regexp_replace(gen, '\s|\W', '', 'g'))));
    return concat(ban, ' - ', gen, ' inserted');
    
  end if;  
end;
$$;


--
-- Name: insert_event(character varying, date, character varying, smallint, numeric, smallint); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_event(eve character varying, dat date, plac character varying, dur smallint, pri numeric, per smallint) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
declare 
  i_p varchar;
  i_e varchar;
begin
	
  select id_event into i_e 
  from music.events e 
  where "event" = eve for update;
 
  if not found then
  
    select id_place into i_p
    from geo.places
    where place = plac for update;
   
    if not found then 
      insert into geo.places
  	  values (md5(lower(regexp_replace(plac, '\s|\W', '', 'g'))), plac);
  	end if;
  
  	insert into music.events
    values (md5(lower(regexp_replace(eve, '\s|\W', '', 'g'))), eve, dat, md5(lower(regexp_replace(plac, '\s|\W', '', 'g'))), dur, pri, per);
    return concat(eve, ' inserted');  
  else return 'Event alredy exist';
    
  end if;end;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: continents; Type: TABLE; Schema: geo; Owner: -
--

CREATE TABLE geo.continents (
    id_continent character varying NOT NULL,
    continent character varying NOT NULL
);


--
-- Name: countries; Type: TABLE; Schema: geo; Owner: -
--

CREATE TABLE geo.countries (
    id_country character varying(4) NOT NULL,
    country character varying(100) NOT NULL,
    flag character(2)
);


--
-- Name: countries_continents; Type: TABLE; Schema: geo; Owner: -
--

CREATE TABLE geo.countries_continents (
    id_country character varying(4) NOT NULL,
    id_continent character varying NOT NULL
);


--
-- Name: places; Type: TABLE; Schema: geo; Owner: -
--

CREATE TABLE geo.places (
    id_place character(32) NOT NULL,
    place character varying(100) NOT NULL
);


--
-- Name: bands; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.bands (
    id_band character(32) NOT NULL,
    band character varying(100) NOT NULL,
    likes character(1),
    active boolean DEFAULT true,
    note character varying,
    CONSTRAINT bands_likes_check CHECK ((likes = ANY (ARRAY['y'::bpchar, 'n'::bpchar, 'm'::bpchar])))
);


--
-- Name: bands_countries; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.bands_countries (
    id_band character(32) NOT NULL,
    id_country character varying(4) NOT NULL
);


--
-- Name: bands_events; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.bands_events (
    id_band character(32) NOT NULL,
    id_event character(32) NOT NULL
);


--
-- Name: bands_genres; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.bands_genres (
    id_band character(32) NOT NULL,
    id_genre character(32) NOT NULL
);


--
-- Name: events; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.events (
    id_event character(32) NOT NULL,
    event character varying(255) NOT NULL,
    date_event date NOT NULL,
    id_place character(32) NOT NULL,
    duration smallint DEFAULT 0,
    price numeric DEFAULT 30.00,
    persons smallint DEFAULT 1,
    note character varying
);


--
-- Name: genres; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.genres (
    id_genre character(32) NOT NULL,
    genre character varying(100) NOT NULL
);


--
-- Name: mv_musical_info; Type: MATERIALIZED VIEW; Schema: music; Owner: -
--

CREATE MATERIALIZED VIEW music.mv_musical_info AS
 SELECT b.band,
    b.likes,
    c.country,
    g.genre,
    e.event,
    e.date_event,
    p.place,
    e.duration,
    (e.price * (e.persons)::numeric) AS price
   FROM (((((((music.bands b
     JOIN music.bands_countries bc ON ((b.id_band = bc.id_band)))
     JOIN geo.countries c ON (((c.id_country)::text = (bc.id_country)::text)))
     JOIN music.bands_genres bg ON ((b.id_band = bg.id_band)))
     JOIN music.genres g ON ((g.id_genre = bg.id_genre)))
     JOIN music.bands_events be ON ((be.id_band = b.id_band)))
     JOIN music.events e ON ((e.id_event = be.id_event)))
     JOIN geo.places p ON ((p.id_place = e.id_place)))
  ORDER BY b.band
  WITH NO DATA;


--
-- Name: next_events_with_tickets; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.next_events_with_tickets (
    id_event character(32) NOT NULL,
    event character varying(255) NOT NULL,
    date_event date NOT NULL,
    id_place character(32) NOT NULL,
    duration smallint DEFAULT 0,
    price numeric DEFAULT 30.00,
    persons smallint DEFAULT 1,
    CONSTRAINT next_events_with_tickets_date_event_check CHECK ((date_event > now()))
);


--
-- Name: v_bands; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_bands AS
 SELECT b.id_band,
        CASE
            WHEN ((b.band)::text ~~ 'Knife%'::text) THEN 'Knife'::character varying
            ELSE b.band
        END AS band,
    c.country,
    c.flag,
    b.likes,
    count(DISTINCT bg.id_genre) AS genres,
    count(DISTINCT be.id_event) AS events
   FROM ((((music.bands b
     JOIN music.bands_countries bc ON ((b.id_band = bc.id_band)))
     JOIN geo.countries c ON (((c.id_country)::text = (bc.id_country)::text)))
     JOIN music.bands_genres bg ON ((bg.id_band = b.id_band)))
     JOIN music.bands_events be ON ((be.id_band = b.id_band)))
  GROUP BY b.id_band, b.band, c.country, c.flag, b.likes
  ORDER BY b.band;


--
-- Name: v_bands_events; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_bands_events AS
 SELECT b.id_band,
    b.band,
    e.event
   FROM ((music.bands b
     JOIN music.bands_events be ON ((b.id_band = be.id_band)))
     JOIN music.events e ON ((be.id_event = e.id_event)))
  ORDER BY b.band, e.date_event;


--
-- Name: v_bands_generes; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_bands_generes AS
 SELECT b.id_band,
    b.band,
    g.genre AS genere
   FROM ((music.bands b
     JOIN music.bands_genres bg ON ((b.id_band = bg.id_band)))
     JOIN music.genres g ON ((bg.id_genre = g.id_genre)))
  ORDER BY b.band, g.genre;


--
-- Name: v_bands_likes; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_bands_likes AS
 SELECT likes,
    count(id_band) AS bands
   FROM music.bands
  GROUP BY likes
  ORDER BY (count(id_band)) DESC;


--
-- Name: v_bands_to_tex; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_bands_to_tex AS
 SELECT
        CASE
            WHEN ((band)::text ~* '\&'::text) THEN (regexp_replace((band)::text, '\&'::text, '\\&'::text))::character varying
            WHEN ((band)::text ~* 'ð'::text) THEN (regexp_replace((band)::text, 'ð'::text, '\\dh '::text))::character varying
            ELSE band
        END AS "Gruppe",
    ((' & \includegraphics[width=1cm]{../4x3/'::text || (flag)::text) || '} & '::text) AS "Land",
    ((('\includegraphics[width=1cm]{'::text || '../likes/'::text) || (likes)::text) || '} \\ \hline'::text) AS "Farbe"
   FROM music.v_bands vb;


--
-- Name: v_countries; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_countries AS
 SELECT c.id_country,
    c.country,
    c.flag,
    count(DISTINCT bc.id_band) AS bands
   FROM (geo.countries c
     JOIN music.bands_countries bc ON (((c.id_country)::text = (bc.id_country)::text)))
  GROUP BY c.country, c.flag, c.id_country
  ORDER BY (count(DISTINCT bc.id_band)) DESC, c.country;


--
-- Name: v_events; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_events AS
SELECT
    NULL::character(32) AS id_event,
    NULL::double precision AS year,
    NULL::text AS date,
    NULL::character varying(255) AS event,
    NULL::character varying(100) AS place,
    NULL::bigint AS bands,
    NULL::integer AS days;


--
-- Name: v_events_price; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_events_price AS
 SELECT (date_part('year'::text, date_event))::character varying AS years,
    sum((price * (persons)::numeric)) AS price
   FROM music.events e
  GROUP BY (date_part('year'::text, date_event))
  ORDER BY (date_part('year'::text, date_event));


--
-- Name: v_events_years; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_events_years AS
 SELECT date_part('year'::text, date_event) AS years,
    count(id_event) AS events
   FROM music.events
  GROUP BY (date_part('year'::text, date_event))
  ORDER BY (date_part('year'::text, date_event));


--
-- Name: v_genres; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_genres AS
 SELECT g.id_genre,
    g.genre,
    count(bg.id_band) AS bands
   FROM ((music.genres g
     JOIN music.bands_genres bg ON ((g.id_genre = bg.id_genre)))
     JOIN music.bands b ON ((b.id_band = bg.id_band)))
  WHERE (b.likes = 'y'::bpchar)
  GROUP BY g.genre, g.id_genre
  ORDER BY (count(bg.id_band)) DESC, g.genre;


--
-- Name: v_places_events; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_places_events AS
 SELECT gp.id_place,
    gp.place,
    count(e.id_event) AS events
   FROM (geo.places gp
     JOIN music.events e ON ((e.id_place = gp.id_place)))
  GROUP BY gp.place, gp.id_place
  ORDER BY (count(e.id_event)) DESC, gp.place;


--
-- Name: v_quantities; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_quantities AS
 SELECT 'bands'::text AS entities,
    count(*) AS quantity
   FROM music.bands
UNION
 SELECT 'events'::text AS entities,
    count(*) AS quantity
   FROM music.events
UNION
 SELECT 'places'::text AS entities,
    count(*) AS quantity
   FROM geo.places
UNION
 SELECT 'genres'::text AS entities,
    count(*) AS quantity
   FROM music.genres;


--
-- Name: test_country; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_country (
    id_country character(32),
    country character varying(100),
    flag character(2)
);


--
-- Name: v_events_by_months; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_events_by_months AS
 SELECT count(id_event) AS "Events",
    (date_trunc('month'::text, (date_event)::timestamp with time zone))::date AS "Monat"
   FROM music.events
  GROUP BY ((date_trunc('month'::text, (date_event)::timestamp with time zone))::date)
  ORDER BY ((date_trunc('month'::text, (date_event)::timestamp with time zone))::date);


--
-- Name: v_last_event; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_last_event AS
 SELECT event AS "Event",
    date AS "Datum",
    place AS "Ort",
    bands AS "Bands",
    days AS "Tage"
   FROM music.v_events v
  GROUP BY event, date, place, bands, days
 HAVING (to_date(date, 'DD.MM.YYYY'::text) = ( SELECT max(to_date(v_events.date, 'DD.MM.YYYY'::text)) AS max
           FROM music.v_events));


--
-- Data for Name: continents; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.continents (id_continent, continent) FROM stdin;
150	Europe
002	Africa
142	Asia
009	Oceania
019	Americas
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.countries (id_country, country, flag) FROM stdin;
NLD	Netherlands	nl
RUS	Russian Federation	ru
IRN	Iran	ir
ARE	United Arab Emirates	ae
CZE	Czechia	cz
001	International	un
LTU	Lithuania	lt
MYS	Malaysia	my
150	Europe	eu
EGY	Egypt	eg
ZAF	South Africa	za
CUB	Cuba	cu
JAM	Jamaica	jm
CRI	Costa Rica	cr
MEX	Mexico	mx
PAN	Panama	pa
ARG	Argentina	ar
BRA	Brazil	br
CHL	Chile	cl
COL	Colombia	co
CAN	Canada	ca
USA	United States of America	us
CHN	China	cn
JPN	Japan	jp
MNG	Mongolia	mn
IDN	Indonesia	id
PHL	Philippines	ph
IND	India	in
ISR	Israel	il
TUR	Türkiye	tr
BLR	Belarus	by
HUN	Hungary	hu
POL	Poland	pl
ROU	Romania	ro
UKR	Ukraine	ua
DNK	Denmark	dk
EST	Estonia	ee
FRO	Faroe Islands	fo
FIN	Finland	fi
ISL	Iceland	is
IRL	Ireland	ie
NOR	Norway	no
SWE	Sweden	se
HRV	Croatia	hr
GBR	United Kingdom of Great Britain and Northern Ireland	gb
GRC	Greece	gr
ITA	Italy	it
MLT	Malta	mt
PRT	Portugal	pt
SRB	Serbia	rs
SVN	Slovenia	si
ESP	Spain	es
AUT	Austria	at
BEL	Belgium	be
FRA	France	fr
DEU	Germany	de
LUX	Luxembourg	lu
CHE	Switzerland	ch
AUS	Australia	au
NZL	New Zealand	nz
SVK	Slovakia	sk
\.


--
-- Data for Name: countries_continents; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.countries_continents (id_country, id_continent) FROM stdin;
150	150
IRN	142
CZE	150
AUS	009
NZL	009
ARG	019
BRA	019
CHL	019
COL	019
CHN	142
JPN	142
MNG	142
IDN	142
PHL	142
IND	142
ISR	142
TUR	142
BLR	150
HUN	150
POL	150
ROU	150
UKR	150
JAM	019
CRI	019
DNK	150
MEX	019
PAN	019
CAN	019
CUB	019
USA	019
LTU	150
MYS	142
FRO	150
FIN	150
ISL	150
NOR	150
SWE	150
GRC	150
ITA	150
PRT	150
SRB	150
SVN	150
ESP	150
AUT	150
BEL	150
LUX	150
CHE	150
NLD	150
RUS	142
RUS	150
DEU	150
FRA	150
ARE	142
001	002
001	142
EGY	002
ZAF	002
001	150
EST	150
001	009
001	019
GBR	150
IRL	150
HRV	150
MLT	150
SVK	150
\.


--
-- Data for Name: places; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.places (id_place, place) FROM stdin;
b77734e4928596fac1db05cab7b39710	Holzappel
62a758afc72d2e3f7933fa4b917944c8	Frankfurt am Main (Zoom)
67bac16ced3de0e99516cf21505718a1	Tilburg (013 Poppodium)
b27e07993299ee0b2ecd26dabd77eaf8	Schlotheim
625d260d98326f7dfffd0dd49ebbfc8e	Hamburg (Messe Halle Schnelsen)
6dde0719f779b373e62a7283e717d384	Landau (Gloria Kulturpalast)
17648f3308a5acb119d9aee1b5eafceb	Mainz (Alexander the Great)
76f9a958c2ebbd2f42456523d749fb5e	Offenbach (Stadthalle)
eca8fc96e027328005753be360587de2	Aschaffenburg (Colos-Saal)
05be609ce9831967baa4f12664dc4d73	Barleben
f3a90318abb3e16166d96055fd6f9096	Weinheim (Café Central)
a91bcaf7db7d174ee2966d9c293fd575	Mainz (M8 im Haus der Jugend)
fc9917fb6f46c0eb12f1e429a33ba66b	Worms (Schwarzer Bär)
c72b4173a6a7131bf31a711212305fd3	Heidelberg (halle 02)
b10506e85b6bf48eace09359fb36d5e0	Aschaffenburg (JUKUZ)
1b90e6739989e49dd0c81f338b61c134	Mainz (Rheinhufer)
5208c9de2f1b498a350984d55bcbc314	Frankfurt am Main (Nachtleben)
3a98149817a5aafba14c1b822db056fa	Mainz (Alte Ziegelei)
990c04bd6b40c3ca7352a838e2208dac	Oberursel
f7f2bc012754bd5d77de32e5c2674553	Offenbach (Capitol)
6e763e01d71c71e3b53502c35bfbb98c	Rüsselsheim (Das Rind)
0dbca791a775eab280cc7766794627cb	Hockenheim (Hockenheim-Ring)
010c9e9e86100e63919a6051b399d662	Schriesheim
588671317bf1864e5a95445ec51aac65	Wiesbaden (Schlachthof)
99b522e44d05813118dcf562022b4a2a	Mainz (KUZ - Kulturzentrum)
49d6cee27482319877690f7d0409abbd	Mannheim (MS Connexion Complex)
3264a9d4fedca758f18391ecca28f0e5	Rockenhausen
539960fca282c1966cfa15e15aca1d84	Magdeburg (Factory)
ed2c8a76cc01eeb645011e8154737a49	Ballenstedt
d5a4559236ce011e72312e02aafc05d0	Mainz-Kastel (Reduit)
6c33b0a7db1a4982d74edfe98239cec5	Neuborn
f17fc1362e3637ae8ede170a2a5d6bea	Mannheim (Maimarkt)
29935ed69008b59e8758afcf7eeb7d7b	Neckargemünd (Metal Club Odinwald)
840b0d06d6be5d714e2228a4be26cbcc	Mannheim (SAP Arena)
15f10194f67b967b0f0b5a22561a7c95	Bad Kreuznach (Jakob-Kiefer-Halle)
406b32caecad16e87606fa84a77f4e35	Havana (Sala Maxim Rock)
d61cb6460de2df9d1d64dc35cb293f6a	Ulm (Hexenhaus)
6c55ed753e5b2355307bf2b494f2384a	Mainz (Kulturcafé auf dem Campus)
44ab9f5977e8956f9dd15003efc8743b	Kaiserslautern (Irish House)
eb83e6da9292e995b44f789c42bb7e65	Bonn (Bla)
6ddb911ae1e79899c2d90067b761d6b4	Darmstadt (Goldene Krone)
ca7fb13a9cd0887dfabbb573c070fb2e	Hirschaid
968e5509ddd33538eec4fff752bda4ff	Lindau (Club Vaudeville)
481c1aef68fb3531c92c85ccf1e8643d	Wacken
6a21939c14c8f6030de787b05d66c3ef	Andernach
4806febaa9c494fdd030ee4163e33c8c	Büchold
0280c9c3b98763f5a8d2ce7e97ce1b05	Frankfurt am Main (Ponyhof Club)
83b0fe992121ae7d39f6bcc58a48160c	Frankfurt am Main (Das Bett)
50eb9f93583f844e0684af399dc7fc3c	Frankfurt am Main (Festhalle)
400c46fc5f22decc791a97c27363df40	Frankfurt am Main (Jahrhunderthalle)
09ddc8804dd5908fef3c8c0c474ad238	Mörlenbach (LIVE MUSIC HALL Weiher)
9f629f2265000ff7abf380b363b2de49	Kusel (Kinett)
69e2a1bbdd4b334d3da05ae012836b18	Köln (Live Music Hall)
69bdcf616a03acef49e3697d73adcbb3	Frankfurt am Main (Haus Sindlingen)
efeaa516107a31ce2d1217e055b767f7	Leipzig
a7f15733dd688dee75571597f8636ba7	Wernigerode
779076573cef469faf694cd40d92f40a	Frankfurt am Main (Batschkapp)
692fc1deabc4b9afa9387af15c02b19a	Mainz (Volkspark)
cb6036cdf8009fc4b41eb0e56eab553d	Turgau/Entenfang
cf1c12d42f59db3667fc162556aab169	Buchenbach
85683aa688e302e1de7ec78dc4440dff	Dotmund (JunkYard)
10effefa9cc583f38ff0518dcaa72ef5	Weilburg-Kubach (Bürgerhalle)
fc36c84b02e473bec246e5d2cfc513ef	Frankfurt am Main (Schöppche-Keller)
6032938ceb573d952fdae1a40ef39837	Bechtheim (Gasthaus Bechtheimer Hof)
b13f71a1a5f7e89c2603d5241c2aca25	Weibersbrunn (Mehrzweckhalle)
817974aa11f84c9ebc640d3de92737f5	Hofheim (Jazzkeller)
738af31c1a528baa30e7df31384e550b	Wiesbaden (GMZ Georg-Buch-Haus)
b00bae5a5f8ff8830d486747e78d7d8d	Alzey (Oberhaus)
9ca0396f7fce5729940fcef7383728b3	Ludwigshafen am Rhein (Bon Scott Rock Cafe)
f0f0e638999829b846be6e20b5591898	Mainz (Zitadelle - Die Kulturei)
7590124802ade834dbe9e7c0d2c1a897	Hamm
051fa36efd99a2ae24d56b198e7b1992	Karlsruhe (Alter Schlachthof - Substage)
5515ceaeca4b8b62ee5275de54ea77ad	Ludwigshafen (Kulturzentrum dasHaus)
cccce7f0011bc27dee7c60945cd5f962	Mainz (Kulturclub schon schön)
e248bb7c1164a44fa358593e28769a23	Mannheim (7er Club)
2dd00779b7dd00b6cbbc574779ba1f40	Mühltal (Steinbruch Theater)
c792b3f05ce40f0ff54fcf79573c89b4	Darmstadt (Radrennbahn)
4dac5916befa9f4e29989cd5f717beb4	Balver Höhle
c8f566954fe846be7d35f707901d7bf5	Luxemburg (Rockhal)
9891ba35bb7474ae750bdbf62a4eee4f	Marburg (Kulturzentrum KFZ)
b9a697f7f6fe15cad76add1dd64b688f	Kassel (Goldgrube)
a04166db1f1c6d75ab79b04756750bf5	Lichtenfels (Stadthalle)
fa5218c9167a20e6b9f6bf2a139433ce	Flörsheim (Moshpit)
d90ac22c4f2291b68cb07746d0472dbf	Karlsruhe (AKK)
4e1c34ddafa9b33187fb34b43ceb2010	Ostfildern (Zentrum Zinsholz)
9c26f60f17bb584dff3b85695fd2b284	Mainz (Caveau)
5948b7ac21c1697473de19197df1f172	Frankfurt am Main (Elfer Club)
de64de56f43ca599fc450a9e0dc4ff25	Mainz (Capitol)
b5c6ef76dd3784cc976d507c890973c3	Schneckenhausen (Festhalle)
\.


--
-- Data for Name: bands; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands (id_band, band, likes, active, note) FROM stdin;
9777f12d27d48261acb756ca56ceea96	EÏS	y	t	\N
e21ad7a2093c42e374fee6ec3b31efd3	Vansind	m	t	\N
304d29d27816ec4f69c7b1ba5836c57a	Sanguisugabogg	y	t	\N
37e2e92ced5d525b3e79e389935cd669	Asinhell	y	t	\N
f3cb86dd6b6caf33a8a05571e195e7dc	Anaal Nathrakh	n	t	\N
3cb5ffaba5b396de828bc06683b5e058	Dying Fetus	y	t	\N
a35033c250bd9c577f20f2b253be0021	The Exploited	y	t	\N
cfd7b6bdd92dbe51d1bdb8cb3b98cd58	Uada	y	t	\N
76aebba2f63483b6184f06f0a2602643	Rebaellium	y	t	\N
f7a13e18c9c1e371b748facfef98a9a5	Vulture	n	t	\N
7d067ef3bf74d1659b8fa9df3de1a047	Cloak	y	t	\N
3cc1eb35683942bb5f7e30b187438c5e	The Mayflower Aspect	y	t	\N
35f3e8a1461c3ce965993e4eafccfa43	Disentomb	y	t	\N
54ca3eeff0994926cb7944cca0797474	Konvent	y	t	\N
568afb74bcc1ce84f8562a4fbfdc31ba	Ulthar	y	t	\N
9a876908f511193b53ce983ab276bd73	.357 Homicide	y	t	\N
d7a97c2ff91f7aa07fa9e2f8265ceab6	Gorod	y	t	\N
5da7161758c4b9241330afb2e1503bbc	Putridity	y	t	\N
6949c5ed6eda8cf7a40adb2981d4671d	Sattmar	n	t	\N
40eefb87bb24ed4efc3fc5eeeb7e5003	Imperial Demonic	y	t	\N
370cde851ed429f1269f243dd714cce2	1000Mods	y	t	\N
dfb7069bfc6e0064a6c667626eca07b4	Aborted	y	t	\N
58bbd6135961e3d837bacceb3338f082	Mourning Wood	y	t	\N
0ab7d3a541204a9cab0d2d569c5b173f	Waldgeflüster	y	t	\N
a7eda23a9421a074fe5ec966810018d7	Revel in Flesh	y	f	\N
20aba645df0b3292c63f0f08b993966e	Anheim	y	t	\N
31897528a567059ed581f119a0e1e516	Fragments of Unbecoming	y	t	\N
41f062d8603a9705974083360fb69892	Hot Action Waxing	y	t	\N
ad7de486b34143f00a56127a95787e78	Jungle Rot	y	t	\N
8cb8e8679062b574afcb78a983b75a9f	Mezzrow	y	t	\N
6caa2c6d69ebdc30a3c4580979c3e630	Verwoed	y	t	\N
16ff0968c682d98cb29b42c793066f29	Sarcator	y	t	\N
d2556a1452bc878401a6cde5cb89264d	Bastard Grave	y	t	\N
efb83e3ae12d8d95a5d01b6d762baa98	Enthroned	y	t	\N
bccaee4d143d381c8c617dd98b9ee463	Necrot	y	t	\N
1680c4ab3ce61ab3e1514fba8b99e3c5	A Call for Revenge	y	t	\N
cdd65383f4d356e459018c3b295d678b	Guttural Slug	y	t	\N
1ae6e4c42571b2d7275b5922ce3d5f39	Teething	m	t	\N
6e610e4ff7101f3a1837544e9fb5d0bf	Humanity's last Breath	y	t	\N
9d919b88be43eb3a9056a54e57894f84	Memoriam	y	t	\N
eaacb8ee01500f18e370303be3d5c591	Dead Eyed Sleeper (Legacy)	y	t	\N
8e1cfd3bf5a7f326107f82f8f28649be	Thjodrörir	y	t	\N
454cce609b348a95fb627e5c02dddd1b	Bio-Cancer	y	t	\N
5e13fedbc93d74e8d42eadee1def2ae6	Der Weg einer Freiheit	y	t	\N
0bc231190faa69e7545dfa084f2bed56	Gruesome	y	t	\N
246e0913685e96004354b87cbab4ea78	Sear Bliss	y	t	\N
1bebc288d8fce192365168e890c956c8	Mýdral	y	t	\N
7359d3b2ff69eb4127c60756cc77faa9	Sinister	y	t	\N
974cd6e62ff1a4101db277d936b41058	Afsky	y	t	\N
e389ffc844004b963c3b832faeea873d	Regarde les Hommes Tomber	y	t	\N
5e8df9b073e86a3272282977d2c9dc85	Hideous Divinity	y	t	\N
d0932e0499b24d42233616e053d088ea	The Voynich Code	y	t	\N
31b9bbcd5d3cb8e18af8f6ea59aea836	Barren	m	t	\N
649df53f8249bdb0aa26e52d6ee517bb	Through the Void	y	t	\N
99557f46ccef290d9d93c546f64fb7d6	Moor	y	t	\N
1b62f034014b1d242c84c6fe7e6470f0	Horisont	m	t	\N
b02ba5a5e65487122c2c1c67351c3ea0	Horresque	y	t	\N
ea3b6b67824411a4cfaa5c8789282f48	Humator	y	t	\N
2e6df049342acfb3012ac702ed93feb4	Baumbart	y	t	\N
a8fcba36c9e48e9e17ba381a34444dd0	As the Sun falls	y	t	\N
c08567e9006dc768bdb72bb7b14e53a1	Desaster	y	t	\N
8717871a38810cc883cce02ea54a7017	Alfahanne	y	t	\N
14b33fbc65adcc1655f82c82d232f6e7	Bloody Vengeance	y	t	\N
b99927de4e0ed554b381b920c01e0481	Carnivore A.D.	m	t	\N
ca7f6314915171b302f62946dcd9a369	Eternal Champion	y	t	\N
2e3163bc98304958ccafbb2810210714	Cenotaph	y	t	\N
c38529decc4815a9932f940af2a16d37	Human Vivisection	y	t	\N
6e2f236ffef50c45058f6127b30ecece	Unhallowed Deliverance	y	t	\N
fb8b0c4fbbd2bc0ab10fcf67a9f1d1ff	Creeping Flesh	y	t	\N
44a468f083ac27ea7b6847fdaf515207	Non est Deus	y	t	\N
024e91d84c3426913db8367f4df2ceb3	Poltergeist	m	t	\N
773b5037f85efc8cc0ff3fe0bddf2eb8	Porn the Gore	y	t	\N
46ea4c445a9ff8e288258e3ec9cd1cf0	Power Trip	y	t	\N
4545c676e400facbb87cbc7736d90e85	Black Messiah	y	t	\N
d86431a5bbb40ae41cad636c2ddbf746	Drudensang	y	t	\N
85ed977a5fcd1ce0c970827078fdb7dd	Pentagram Chile	y	t	\N
7bc230f440d5d70d2c573341342d9c81	Ondfødt	y	t	\N
b9a0ad15427ab09cfd7b85dadf2c4487	Teratoma	y	t	\N
4ccc28be05a98375d9496dc2eba7006a	Vltimas	y	t	\N
4e9a84da92180e801263860bfbea79d6	Bewitched	y	t	\N
ccc9b8a517c7065d907e283040e6bc91	Crown the Beast	y	t	\N
d7e0c43c16a9f8385b49d23cd1178598	Infestation	y	t	\N
14bbaec7f5e0eba98d90cd8353c2e79f	Waking the Cadaver	y	t	\N
d0a0817c2cd33b0734f70fcf3240eb41	Born of Osiris	y	t	\N
f0ae03df4fd08abd1f844fea2f4bbfb0	Parasite Inc.	y	t	\N
5f07809ecfce3af23ed5550c6adf0d78	Unleashed	m	t	\N
baceebebc179d3cdb726f5cbfaa81dfe	Ur	y	t	\N
50d48c9002eb08e248225c1d91732bbc	Horn	y	t	\N
f517a9dc937888bed2f3fbeb38648372	KHNVM	y	t	\N
f114176afa9d9d44e8ef8ce2b586469d	Shape of Despair	y	t	\N
14aedd89f13973e35f9ba63149a07768	Assi Assassin	y	t	\N
d42e907e9c61d30d23ce9728d97aa862	Chemicide	y	t	\N
33b8199a303b059dfe3a3f9ace77c972	Sadus	y	t	\N
4a0ea81570ab9440e8899b9f5fb3a61a	Alkaloid	y	t	\N
f2576a80ee7893b24dd33a8af3911eac	Deathawaits	y	t	\N
749b17536e08489cb3b2437715e89001	Inhume	y	t	\N
f6f1f5df964a4620e88527d4e4ff84fc	Taskforce Toxicator	y	t	\N
c61b8639de558fcc2ee0b1d11e120df9	This Ending	y	t	\N
8b3f40e0243e2307a1818d3f456df153	Crypta	y	t	\N
8b0cfde05d166f42a11a01814ef7fa86	Lost Society	n	t	\N
c0118be307a26886822e1194e8ae246d	Venom	y	t	\N
a66394e41d764b4c5646446a8ba2028b	Moonspell	n	t	\N
e9e0664816c35d64f26fc1382708617b	Striker	n	t	\N
f29f7213d1c86c493ca7b4045e5255a9	Auðn	y	t	\N
65f889eb579641f6e5f58b5a48f3ec12	Ill Niño	m	t	\N
9d5c1f0c1b4d20a534fe35e4e699fb7b	Countless Skies	m	t	\N
db572afa3dcc982995b5528acb350299	Kvaen	y	t	\N
b12986f0a962c34c6669d59f40b1e9eb	Escarnium	y	t	\N
e8ead85c87ecdab1738db48a10cae6da	Ultima Necat	y	t	\N
2a67e4bd1ef39d36123c84cad0b3f974	Sabbat	m	t	\N
20db933d4ddd11d5eff99a441e081550	Dehumanizing Itatrain Worship	y	t	\N
a54196a4ae23c424c6c01a508f4c9dfb	Maximize Bestiality	y	t	\N
d0dc5a2eab283511301b75090afe11ab	Deliver the Galaxy	y	t	\N
65f24dbd08671d51fda7de723afc41d9	Vorga	y	t	\N
7a43dd4c2bb9bea14a95ff3acd4dfb18	Creeping Death	y	t	\N
c8bc4f15477ea3131abb1a3f0649fac2	Dropdead	y	t	\N
fb3a67e400fde856689076418034cdf2	Haggard	y	t	\N
3705bfe1d1b3b5630618b164716ae700	Muggeseggel	y	t	\N
801c01707f48bfa8875d4a2ac613920d	Ciemra	y	t	\N
6dffdacffe80aad339051ef4fbbf3f29	Manos	y	t	\N
b531de2f903d979f6a002d5a94b136aa	Total Hate	y	t	\N
513fc59781f0030dc6e7a7528a45b35b	Left to Die	y	t	\N
6a826993d87c8fc0014c43edd8622b6c	Obscura	y	t	\N
a7eb281bcaab3446ece1381b190d34e0	Devine Defilement	y	t	\N
3ec4a598041aa926d5f075e3d69dfc0a	Paediatrician	y	t	\N
3f7e7508d7af00ea2447bfffbbac2178	Faces of Fear	y	t	\N
e3c1fd64db1923585a22632681c95d35	Wormwood	y	t	\N
d0e551d6887e0657952b3c5beb7fed74	Gutrectomy	y	t	\N
3f460e130f37e8974fbcdc4d0056b468	Theotoxin	y	t	\N
ce8e1e23e9672f5bf43894879f89c17a	Thormesis	m	t	\N
50bac8fb5d0c55efd23de4c216e440f1	Ratos de Porão	y	t	\N
0aff394c56096d998916d2673d7ea0b6	Kilatus	y	t	\N
96406d44fcf110be6a4b63fa6d26de3b	Iron Walrus	y	t	\N
3757709518b67fddd9ae5a368d219334	Terrorizer	y	t	\N
359dda2e361814c0c8b7b358e654691d	Unto Others	n	t	\N
eef1b009f602bb255fa81c0a7721373d	Disavowed	y	t	\N
03aa4e5b2b49a82eb798d33afe9e8523	Pray for Pain	y	t	\N
1175d5b2a935b9f4daf6b39e5e74138c	Fleshworks	y	t	\N
f8b3eaefc682f8476cc28caf71cb2c73	Los Mezcaleros	n	t	\N
312793778e3248b6577e3882a77f68f3	Abrogation	y	t	\N
dd3e531c469005b17115dbf611b01c88	Acranius	y	t	\N
4a27a1ef21d32d1b30d55f092af0d5a7	Aeon of Disease	y	t	\N
398af626887ad21cd66aeb272b8337be	Agrypnie	y	t	\N
786d3481362b8dee6370dfb9b6df38a2	Airborn	m	t	\N
eb999c99126a456f9db3c5d3b449fa7f	All its Grace	y	t	\N
0f9fb8452cc5754f83e084693d406721	Amon Amarth	y	t	\N
dab701a389943f0d407c6e583abef934	Analepsy	y	t	\N
8ac49bad86eacffcea299416cd92c3b7	Angelus Apatrida	y	t	\N
b7f0e9013f8bfb209f4f6b2258b6c9c8	Anthrax	y	t	\N
3c6444d9a22c3287b8c483117188b3f4	AntiPeeWee	m	t	\N
0da2e7fa0ba90f4ae031b0d232b8a57a	Anubis	m	t	\N
2f623623ce7eeb08c30868be121b268a	Anüs	y	t	\N
71b6971b6323b97f298af11ed5455e55	Apey & The Pea	n	t	\N
b66781a52770d78b260f15d125d1380b	Arch Enemy	y	t	\N
35bde21520f1490f0333133a9ae5b4fc	Arroganz	y	t	\N
36233ed8c181dfacc945ad598fb4f1a1	Artillery	n	t	\N
221fa1624ee1e31376cb112dd2487953	Asomvel	y	t	\N
5958cd5ce011ea83c06cb921b1c85bb3	Asphyx	y	t	\N
4a9cd04fd04ab718420ee464645ccb8b	Atomwinter	m	t	\N
8765cfbf81024c3bd45924fee9159982	Audrey Horne	m	t	\N
824f75181a2bbd69fb2698377ea8a952	Außerwelt	y	t	\N
4190210961bce8bf2ac072c878ee7902	Aversions Crown	y	t	\N
d92ee81a401d93bb2a7eba395e181c04	Avowal	y	t	\N
50737756bd539f702d8e6e75cf388a31	Avulsed	y	t	\N
15ba70625527d7bb48962e6ba1a465f7	Odd Couple	y	t	\N
a571d94b6ed1fa1e0cfff9c04bbeb94d	Tiny Fingers	y	t	\N
e37e9fd6bde7509157f864942572c267	Crimson Fire	n	t	\N
5e62fc773369f140db419401204200e8	Apostasie	y	t	\N
9592b3ad4d7f96bc644c7d6f34c06576	Carnifex	y	t	\N
fd1a5654154eed3c0a0820ab54fb90a7	Vexed	y	t	\N
2045b9a6609f6d5bca3374fd370e54ff	Welded	y	t	\N
78b532c25e4a99287940b1706359d455	Hell Patröl	y	t	\N
fc935f341286c735b575bd50196c904b	Alltheniko	y	t	\N
f159fc50b5af54fecf21d5ea6ec37bad	Bütcher	y	t	\N
265dbcbd2bce07dfa721ed3daaa30912	Martyr	n	t	\N
ec4f407118924fdc6af3335c8d2961d9	Megalive	y	t	\N
11a7f956c37bf0459e9c80b16cc72107	Spitfire	y	t	\N
41e744bdf3114b14f5873dfb46921dc4	Devil's Hours	y	t	\N
e37015150c8944d90e306f19eaa98de8	Reflexor	y	t	\N
ed795c86ba21438108f11843f7214c95	Fintroll	y	t	\N
dbc940d02a217c923c52d3989be9b391	Metsatöll	y	t	\N
8845da022807c76120b5b6f50c218d9a	Suotana	y	t	\N
f520f53edf44d466fb64269d5a67b69a	Keep of Kalessin	y	t	\N
61e5d7cb15bd519ceddcf7ba9a22cbc6	Gasbrand	y	t	\N
9563a6fd049d7c1859196f614b04b959	Medico Peste	y	t	\N
90fb95c00db3fde6b86e6accf2178fa7	Devastator	y	t	\N
b80aecda9ce9783dab49037eec5e4388	Tears of Fire	y	t	Location: Germany
b81dd41873676af0f9533d413774fa8d	Slaughter Messiah	m	t	\N
094655515b3991e73686f45e4fe352fe	Nakkeknaekker	y	t	\N
fbe95242f85d4bbe067ddc781191afb5	Plaguemace	y	t	\N
fc46b0aa6469133caf668f87435bfd9f	Cognitive	y	t	\N
8872fbd923476b7cf96913260ec59e66	Macabre Demise	y	t	\N
ad759a3d4f679008ffdfb07cdbda2bb0	Baleful Abyss (Zombieslut)	y	t	\N
3480c10b83b05850ec18b6372e235139	Battle against the Empire	y	t	\N
28bc0abd0cf390a4472b1f60bd0cfe4a	Battle Beast	m	t	\N
844de407cd83ea1716f1ff57ea029285	Behemoth	y	t	\N
df24a5dd8a37d3d203952bb787069ea2	Benediction	y	t	\N
048d40092f9bd3c450e4bdeeff69e8c3	Benighted	y	t	\N
ef297890615f388057b6a2c0a2cbc7ab	Agnostic Front	m	t	\N
0959583c7f421c0bb8adb20e8faeeea1	Amorphis	m	t	\N
c5d3d165539ddf2020f82c17a61f783d	Betrayal	y	t	\N
33b39f2721f79a6bb6bb5e1b2834b0bd	Betraying the Martyrs	m	t	\N
d2d67d63c28a15822569c5033f26b133	Bitchfork	y	t	\N
c827a8c6d72ff66b08f9e2ab64e21c01	Black Crown Initiate	y	t	\N
b1d18f9e5399464bbe5dea0cca8fe064	Black Medusa	y	t	\N
f986b00063e79f7c061f40e6cfbbd039	Black Reunion	y	t	\N
7c7e63c9501a790a3134392e39c3012e	Blæck Fox	y	t	\N
e3e9ccd75f789b9689913b30cb528be0	Blessed Hellride	y	t	\N
d02f33b44582e346050cefadce93eb95	Blizzen	m	t	\N
298a577c621a7a1c365465f694e0bd13	Bloodbound	y	t	\N
707270d99f92250a07347773736df5cc	Blood Fire Death	y	t	\N
fecc75d978ad94aaa4e17b3ff9ded487	Bloodred Hourglass	y	t	\N
333ca835f34af241fe46af8e7a037e17	Blood Red Throne	y	t	\N
ee36fdf153967a0b99d3340aadeb4720	Bloodspot	y	t	\N
13291409351c97f8c187790ece4f5a97	Bobby Sixkiller and the Renegades	y	t	\N
647a73dd79f06cdf74e1fa7524700161	Böhse Onkelz	m	t	\N
cbefc03cdd1940f37a7033620f8ff69f	Booze & Glory	m	t	\N
b145159df60e1549d1ba922fc8a92448	Born from Pain	m	t	\N
d9c849266ee3ac1463262df200b3aab8	Bösedeath	y	t	\N
8b22cf31089892b4c57361d261bd63f7	Bowel Evacuation	y	t	\N
ab1d9c0bfcc2843b8ea371f48ed884bb	Brainstorm	m	t	\N
16a56d0941a310c3dc4f967041574300	Brand of Sacrifice	y	t	\N
2eb42b9c31ac030455e5a4a79bccf603	Broken Teeth	m	t	\N
a0cdbd2af8f1ddbb2748a2eaddce55da	Bullet	m	t	\N
a985c9764e0e6d738ff20f2328a0644b	Burn	m	t	\N
ea3f5f97f06167f4819498b4dd56508e	Bury Tomorrow	y	t	\N
e2be3c3c22484d1872c7b225339c0962	Caliban	y	t	\N
a99dca5593185c498b63a5eed917bd4f	Cancer	y	t	\N
3b6d90f85e8dadcb3c02922e730e4a9d	Candlemass	m	t	\N
573f13e31f1be6dea396ad9b08701c47	Cannibal Corpse	y	t	\N
1fbd4bcce346fd2b2ffb41f6e767ea84	Carach Angren	y	t	\N
9436650a453053e775897ef5733e88fe	Carnal Decay	y	t	\N
cf6a93131b0349f37afeb9319b802136	Carnation	y	t	\N
bca8f048f2c5ff787950eb1ba088c70e	CCCP	y	t	\N
5629d465ed80efff6e25b8775b98c2d1	Circle of Execution	y	t	\N
3a7e46261a591b3e65d1e7d0b2439b20	Combichrist	y	t	\N
c9dc004fc3d039ad7fb49456e5902b01	Conan	m	t	\N
748ac622dcfda98f59c3c99593226a75	Condemned	y	t	\N
f00bbb7747929fafa9d1afd071dba78e	Converge	m	t	\N
9a6c0d8ea613c5b002ff958275318b08	Corpsessed	y	t	\N
67cc86339b2654a35fcc57da8fc9d33d	Counterparts	m	t	\N
6916ed9292a811c895e259c542af0e8a	Critical Mess	y	t	\N
fd401865b6db200e5eb8a1ac1b1fbab1	Crossplane	y	t	\N
218d618a041c057d0e05799670e7e2c8	Crusher	y	t	\N
a4bcd57d5cda816e4ffd1f83031a36ca	Cryptopsy	y	t	\N
ec5c65bfe530446b696f04e51aa19201	Cytotoxin	y	t	\N
14af57131cbbf57afb206c8707fdab6c	Dagoba	y	t	\N
a45ff5de3a96b103a192f1f133d0b0cf	Daily Insanity	y	t	\N
de3e4c12f56a35dc1ee6866b1ddd9d53	Darkall Slaves	y	t	\N
88726e1a911181e20cf8be52e1027f26	Darkened Nocturn Slaughtercult	y	t	\N
9b7d722b58370498cd39104b2d971978	Darkness	m	t	\N
ac61757d33fc8563eb2409ed08e21974	Dark Zodiak	y	t	\N
93299af7c9e3c63c7b3d9bb2242c9d6b	Dawn of Disease	y	t	\N
afb6e0f1e02be39880596a490c900775	Dead Congregation	y	t	\N
bc5daaf162914ff1200789d069256d36	Gwar	m	t	\N
a6c27c0fb9ef87788c1345041e840f95	Begging for Incest	y	t	\N
98e8599d1486fadca0bf7aa171400dd8	Colours of Autumn	y	t	\N
66857d7c2810238438483356343ff26e	Bloodgod	y	f	\N
aa5e46574bdc6034f4d49540c0c2d1ad	Batushka	y	t	Krzysztof Drabikowski's Batushka
13d81f0ed06478714344fd0f1a6a81bb	Al Goregrind	m	f	\N
9a8d3efa0c3389083df65f4383b155fb	Death Angel	y	t	\N
22ef651048289b302401afe2044c5c01	Deathrite	y	t	\N
9ff04a674682ece6ee93ca851db56387	Deathstorm	y	t	\N
08f8c67c20c4ba43e8ba6fa771039c94	Debauchery's Balgeroth	y	t	\N
3577f7160794aa4ba4d79d0381aefdb1	Decapitated	y	t	\N
b4c5b422ab8969880d9f0f0e9124f0d7	Decaying Days	y	t	\N
16fe483d0681e0c86177a33e22452e13	Defaced	y	t	\N
01a9f3fdd96daef6bc85160bd21d35dc	Defocus	y	t	\N
2187711aeaa2944a707c9eabaa2df72a	Demored	y	t	\N
6a4e8bab29666632262eb20c336e85e2	Denyal	y	t	\N
ac8eab98e370e2a8711bad327f5f7c55	Depulsed	y	t	\N
02677b661c84417492e1c1cb0b0563b2	Deranged	y	t	\N
53199d92b173437f0207a916e8bcc23a	Desbroce	y	t	\N
4db3435be88015c70683b4368d9b313b	Desdemonia	y	t	\N
53a5da370321dac39033a5fe6af13e77	Deserted Fear	y	t	\N
b0cc1a3a1aee13a213ee73e3d4a2ce70	Destinity	y	t	\N
2f090f093a2868dccca81a791bc4941f	Deströyer 666	y	t	\N
717ec52870493e8460d6aeddd9b7def8	Devil Driver	y	t	\N
9d1ecaf46d6433f9dd224111440cfa3b	Dimmu Borgir	y	t	\N
c2ab38206dce633f15d66048ad744f03	Disbelief	y	t	\N
630500eabc48c986552cb01798a31746	Discreation	m	t	\N
e5ea2ac2170d4f9c2bdbd74ab46523f7	Disquiet	m	t	\N
ceffa7550e5d24a8c808d3516b5d6432	Dissecdead	y	t	\N
81200f74b5d831e3e206a66fe4158370	Double Crush Syndrome	m	t	\N
5e6ff2b64b4c0163ab83ab371abe910b	Downfall of Gaia	m	t	\N
71f4e9782d5f2a5381f5cdf7c5a35d89	Down to Nothing	m	t	\N
262a49b104426ba0d1559f8785931b9d	Dragonsfire	n	t	\N
0add3cab2a932f085109a462423c3250	Dust Bolt	y	t	\N
20a75b90511c108e3512189ccb72b0ac	Dyscarnate	y	t	\N
7d6ede8454373d4ca5565436cbfeb5c0	EDGEBALL	n	t	\N
92ad5e8d66bac570a0611f2f1b3e43cc	Einherjer	y	t	\N
90669320cd8e4a09bf655310bffdb9ba	Eisregen	y	t	\N
20de83abafcb071d854ca5fd57dec0e8	Ektomorf	y	t	\N
4900e24b2d0a0c5e06cf3db8b0638800	Embrace Decay	y	t	\N
bd9059497b4af2bb913a8522747af2de	Emerald	n	t	\N
b9ffbdbbe63789cc6fa9ee2548a1b2ed	Eminenz	y	t	\N
cfe122252751e124bfae54a7323bf02d	Endlevel	y	t	\N
7f3e5839689216583047809a7f6bd0ff	End of Green	y	t	\N
be2c012d60e32fbf456cd8184a51973d	Bokassa	m	t	\N
11a5f9f425fd6da2d010808e5bf759ab	Cradle of Filth	m	t	\N
491801c872c67db465fda0f8f180569d	Enforcer	n	t	\N
647dadd75e050b230269e43a4fe351e2	Enisum	y	t	\N
05ee6afed8d828d4e7ed35b0483527f7	Enterprise Earth	y	t	\N
5fa07e5db79f9a1dccb28d65d6337aa6	Epica	n	t	\N
0feeee5d5e0738c1929bf064b184409b	Epicardiectomy	y	t	\N
38734dcdff827db1dc3215e23b4e0890	Eradicator	m	t	\N
3e28a735f3fc31a9c8c30b47872634bf	Ereb Altor	m	t	\N
02fd1596536ea89e779d37ded52ac353	Evertale	m	t	\N
25f5d73866a52be9d0e2e059955dfd56	Evil Invaders	y	t	\N
9639834b69063b336bb744a537f80772	Exhorder	y	t	\N
272a23811844499845c6e33712c8ba6c	Exodus	y	t	\N
8cd1cca18fb995d268006113a3d6e4bf	Extermination Dismemberment	y	t	\N
2b068ea64f42b2ccd841bb3127ab20af	Exumer	y	t	\N
979b5de4a280c434213dd8559cf51bc0	Fallen Temple	y	t	\N
45d592ef3a8dc14dccc087e734582e82	Far from ready	m	t	\N
71a520b6d0673d926d02651b269cf92c	Feuerschwanz	y	t	\N
22aaaebe901de8370917dcc53f53dbf6	Finsterforst	y	t	\N
aa98c9e445775e7c945661e91cf7e7aa	Firtan	y	t	\N
4e9b4bdef9478154fc3ac7f5ebfb6418	Five Finger Death Punch	y	t	\N
198445c0bbe110ff65ac5ef88f026aff	Fjoergyn	y	t	\N
abc73489d8f0d1586a2568211bdeb32f	Fleshcrawl	y	t	\N
458da4fc3da734a6853e26af3944bf75	Fleshgod Apocalypse	y	t	\N
26ad58455460d75558a595528825b672	Fleshsphere	y	t	\N
6e064a31dc53ab956403ec3654c81f1f	Flesh Trading Company	y	t	\N
dddfdb5f2d7991d93f0f97dce1ef0f45	Fracture	m	t	\N
56b07537df0c44402f5f87a8dcb8402c	From North	m	t	\N
e6793169497d66ac959a7beb35d6d497	Funeral Whore	y	t	\N
0ab01e57304a70cf4f7f037bd8afbe49	Furies	n	t	\N
71144850f4fb4cc55fc0ee6935badddf	Ghost	y	t	\N
eed35187b83d0f2e0042cf221905163c	Gingerpig	m	t	\N
b615ea28d44d2e863a911ed76386b52a	God Dethroned	y	t	\N
bda66e37bf0bfbca66f8c78c5c8032b8	GodSkill	y	t	\N
2799b4abf06a5ec5e262d81949e2d18c	Godslave	y	t	\N
a20050efc491a9784b5cced21116ba68	Grabak	y	t	\N
05fcf330d8fafb0a1f17ce30ff60b924	Grand Magus	y	t	\N
386a023bd38fab85cb531824bfe9a879	Grave	y	t	\N
abe78132c8e446430297d08bd1ecdab0	Grave Pleasures	m	t	\N
7b3ab6743cf8f7ea8491211e3336e41d	Graveyard	y	t	\N
bd4ca3a838ce3972af46b6e2d85985f2	Gut	n	t	\N
6caa47f7b3472053b152f84ce72c182c	H2O	m	t	\N
a05a13286752cb6fc14f39f51cedd9ce	Hadal Maw	m	t	\N
781c745a0d6b02cdecadf2e44d445d1a	Hailstone	m	t	\N
71ac59780209b4c074690c44a3bba3b7	Hämatom	y	t	\N
82f43cc1bda0b09efff9b356af97c7ab	Hammer King	m	t	\N
d908b6b9019639bced6d1e31463eea85	Hängerbänd	y	t	\N
1437c187d64f0ac45b6b077a989d5648	Hark	y	t	\N
4be3e31b7598745d0e96c098bbf7a1d7	Hatebreed	y	t	\N
d1e0bdb2b2227bdd5e47850eec61f9ea	Hate Eternal	y	t	\N
123131d2d4bd15a0db8f07090a383157	Haunted Cemetery	y	t	\N
78bbff6bf39602a577c9d8a117116330	Havok	y	t	\N
2054decb2290dbaab1c813fd86cc5f8b	Hell Boullevard	y	t	\N
6adc39f4242fd1ca59f184e033514209	Hellknife	y	t	\N
281eb11c857bbe8b6ad06dc1458e2751	Hell:On	y	t	\N
dfa61d19b62369a37743b38215836df9	Hellripper	y	t	\N
efe9ed664a375d10f96359977213d620	Helrunar	y	t	\N
30a100fe6a043e64ed36abb039bc9130	Hexenizer	y	t	\N
c5f4e658dfe7b7af3376f06d7cd18a2a	Hierophant	y	t	\N
dcab0d84960cda81718e38ee47688a75	High Fighter	m	t	\N
3aa1c6d08d286053722d17291dc3f116	Hills have Eyes	m	t	\N
818ce28daba77cbd2c4235548400ffb2	Hollowed	y	t	\N
6d25c7ad58121b3effe2c464b851c27a	Hollow World	m	t	\N
8791e43a8287ccbc21f61be21e90ce43	Ellende	y	t	\N
5c59b6aa317b306a1312a67fe69bf512	Embryectomy	y	t	\N
cd004b87e2adfb72b28752a6ef6cd639	Exorcised Gods	y	t	\N
f2a863a08c3e22cc942264ac4bc606e3	Hypocrisy	y	t	\N
eb39fa9323a6b3cbc8533cd3dadb9f76	Ichor	y	t	\N
768207c883fd6447d67f3d5bc09211bd	I Declare War	y	t	\N
8981b4a0834d2d59e1d0dceb6022caae	Igel vs. Shark	m	t	\N
a7e071b3de48cec1dd24de6cbe6c7bf1	Ignite	n	t	\N
f3ac75dfbf1ce980d70dc3dea1bf4636	I'll be damned	m	t	\N
de1e0ed5433f5e95c8f48e18e1c75ff6	Illdisposed	y	t	\N
e20976feda6d915a74c751cbf488a241	Imperium Dekadenz	y	t	\N
b3d0eb96687420dc4e5b10602ac42690	Inconcessus Lux Lucis	y	t	\N
e4f13074d445d798488cb00fa0c5fbd4	Indian Nightmare	n	t	\N
5dd5b236a364c53feb6db53d1a6a5ab9	Infected World	m	t	\N
486bf23406dec9844b97f966f4636c9b	In Flames	y	t	\N
1fd7fc9c73539bee88e1ec137b5f9ad2	Ingested	y	t	\N
ef3c0bf190876fd31d5132848e99df61	Inhumate	y	t	\N
2569a68a03a04a2cd73197d2cc546ff2	Insanity Alert	m	t	\N
05c87189f6c230c90bb1693567233100	Insulter	m	t	\N
77bfe8d21f1ecc592062f91c9253d8ab	In the Woods	n	t	\N
018b60f1dc74563ca02f0a14ee272e4d	Into Darkness	y	t	\N
40fcfb323cd116cf8199485c35012098	Iron Bastards	m	t	\N
d68956b2b5557e8f1be27a4632045c1e	Iron Reagan	y	t	\N
ba9bfb4d7c1652a200d1d432f83c5fd1	Isole	m	t	\N
4dde2c290e3ee11bd3bd1ecd27d7039a	Jinjer	n	t	\N
34fd3085dc67c39bf1692938cf3dbdd9	Kaasschaaf	y	t	\N
fcf66a6d6cfbcb1d4a101213b8500445	Kadavar	m	t	\N
d5ec808c760249f11fbcde2bf4977cc6	Kambrium	y	t	\N
5637bae1665ae86050cb41fb1cdcc3ee	Kataklysm	y	t	\N
0cd2b45507cc7c4ead2aaa71c59af730	Knockdown Brutality	y	t	\N
34ef35a77324b889aab18380ad34b51a	Korpiklaani	y	t	\N
869bb972f8bef83979774fa123c56a4e	Korpse	y	t	\N
472e67129f0c7add77c7c907dac3351f	Kosmokrator	m	t	\N
23f5e1973b5a048ffaaa0bd0183b5f87	Kreator	y	t	\N
08b84204877dce2a08abce50d9aeceed	Lacrimas Profundere	m	t	\N
309263122a445662099a3dabce2a4f17	Legion of the Damned	y	t	\N
c833c98be699cd7828a5106a37d12c2e	Light to the blind	m	t	\N
40a259aebdbb405d2dc1d25b05f04989	Liver Values	m	t	\N
563fcbf5f44e03e0eeb9c8d6e4c8e127	Lonewolf	y	t	\N
f1022ae1bc6b46d51889e0bb5ea8b64f	Lordi	m	t	\N
ed783268eca01bff52c0f135643a9ef7	Los Skeleteros	y	t	\N
f49f851c639e639b295b45f0e00c4b4c	Lyra's Legacy	n	t	\N
9b55ad92062221ec1bc80f950f667a6b	Määt	y	t	\N
f6708813faedbf607111d83fdce91828	Madball	y	t	\N
f3b8f1a2417bdc483f4e2306ac6004b2	Manegarm	y	t	\N
bf2c8729bf5c149067d8e978ea3dcd32	Mantar	y	t	\N
72b73895941b319645450521aad394e8	Marduk	y	t	\N
436f76ddf806e8c3cbdc9494867d0f79	Meatknife	y	t	\N
4e7054dff89623f323332052d0c7ff6e	Mecalimb	m	t	\N
5cc06303f490f3c34a464dfdc1bfb120	Membaris	m	t	\N
cbf6de82cf77ca17d17d293d6d29a2b2	Metal Inquisitor	n	t	\N
3c2234a7ce973bc1700e0c743d6a819c	Metallica	y	t	\N
cd0bc2c8738b2fef2d78d197223b17d5	Milking the Goatmachine	y	t	\N
2c5705766131b389fa1d88088f1bb8a8	Mindflair	y	t	\N
3e98ecfa6a4c765c5522f897a4a8de23	Ministry	y	t	\N
db472eaf615920784c2b83fc90e8dcc5	Misery Index	y	t	\N
6772cdb774a6ce03a928d187def5453f	Mizery	m	t	\N
f655d84d670525246ee7d57995f71c10	MØL	y	t	\N
cb80a6a84ec46f085ea6b2ff30a88d80	Molotov	y	t	\N
6a13b854e05f5ba6d2a0d873546fc32d	Mono Inc.	m	t	\N
24af2861df3c72c8f1b947333bd215fc	Moontowers	n	t	\N
7bc374006774a2eda5288fea8f1872e3	Morasth	y	t	\N
846a0115f0214c93a5a126f0f9697228	More Than A Thousand	m	t	\N
0964b5218635a1c51ff24543ee242514	Mosaic	y	t	\N
c52d5020aad50e03d48581ffb34cd1c3	Motörblast	y	t	\N
dcdcd2f22b1d5f85fa5dd68fa89e3756	Motorowl	y	t	\N
c82b23ed65bb8e8229c54e9e94ba1479	Mr. Irish Bastard	y	t	\N
91abd5e520ec0a40ce4360bfd7c5d573	Nailed to Obscurity	y	t	\N
e6624ef1aeab84f521056a142b5b2d12	Napalm Death	y	t	\N
3ddbf46000c2fbd44759f3b4672b64db	Nasty	m	t	\N
33f03dd57f667d41ac77c6baec352a81	need2destroy	y	t	\N
38b2886223461f15d65ff861921932b5	Nekrovault	y	t	\N
dfca36a68db327258a2b0d5e3abe86af	Nepumuc	m	t	\N
07d82d98170ab334bc66554bafa673cf	Nervosa	y	t	\N
42f6dd3a6e21d6df71db509662d19ca4	Nifelheim	y	t	\N
118c9af69a42383387e8ce6ab22867d7	Nile	y	t	\N
07f467f03da5f904144b0ad3bc00a26d	NIOR	y	t	\N
e29470b6da77fb63e9b381fa58022c84	No Brainer	y	t	\N
2d1ba9aa05ea4d94a0acb6b8dde29d6b	Nocturnal Graves	y	t	\N
3fae5bf538a263e96ff12986bf06b13f	No Return	y	t	\N
a9ef9373c9051dc4a3e2f2118537bb2d	Of Colours	y	t	\N
009f51181eb8c6bb5bb792af9a2fdd07	Omnium Gatherum	y	t	\N
e63a014f1310b8c7cbe5e2b0fd66f638	Omophagia	y	t	\N
55b6aa6562faa9381e43ea82a4991079	Orbit Culture	y	t	\N
1dc7d7d977193974deaa993eb373e714	Orcus Patera	y	t	\N
5ab944fac5f6a0d98dc248a879ec70ff	Orden Ogan	y	t	\N
0a0f6b88354de7afe84b8a07dfadcc26	Overkill	m	t	\N
240e556541427d81f4ed1eda86f33ad3	Pain City	y	t	\N
d162c87d4d4b2a8f6dda58d4fba5987f	Papa Roach	m	t	\N
21077194453dcf49c2105fda6bb89c79	Paradise Lost	m	t	\N
5bd15db3f3bb125cf3222745f4fe383f	Party Cannon	y	t	\N
1e71013b49bbd3b2aaa276623203453f	Paxtilence	y	t	\N
541fa0085b17ef712791151ca285f1a7	Pighead	y	t	\N
f2ba1f213e72388912791eb68adc3401	P.O. Box	y	t	\N
210e99a095e594f2547e1bb8a9ac6fa7	Pokerface	m	t	\N
6cec93398cd662d79163b10a7b921a1b	Moronic	y	f	\N
6ca47c71d99f608d4773b95f9b859142	Incite	y	t	\N
c41b9ec75e920b610e8907e066074b30	Prediction	y	t	\N
a91887f44d8d9fdcaa401d1c719630d7	Pripjat	y	t	\N
cd80c766840b7011fbf48355c0142431	Promethee	y	t	\N
4f5b2e20e9b7e5cc3f53256583033752	Prostitute Desfigurement	y	t	\N
7b675f4c76aed34cf2d5943d83198142	Psycroptic	y	t	\N
1f56e4b8b8a0da3b8ec5b32970e4b0d8	Public Grave	y	t	\N
fcc491ba532309d8942df543beaec67e	Purify	y	t	\N
662d17c67dcabc738b8620d3076f7e46	Randy Hansen	y	t	\N
c349bc9795ba303aa49e44f64301290e	Raw Ensemble	y	t	\N
aa5808895fd2fca01d080618f08dca51	Reactory	y	t	\N
66597873e0974fb365454a5087291094	Rectal Smegma	y	t	\N
6ffa656be5ff3db085578f54a05d4ddb	Refuge	y	t	\N
891b302f7508f0772a8fdb71ccbf9868	Relics of Humanity	y	t	\N
dddbd203ace7db250884ded880ea7be4	Revelation Steel	m	t	\N
ddae1d7419331078626bc217b23ea8c7	Rezet	y	t	\N
c82a107cd7673a4368b7252aa57810fc	Rings of Saturn	y	t	\N
1cc93e4af82b1b7e08bace9a92d1f762	Risk it	y	t	\N
fb80cd69a40a73fb3b9f22cf58fd4776	Riverroth	m	t	\N
6d779916de27702814e4874dcf4f9e3a	Rivers of Nihil	y	t	\N
63a9f0ea7bb98050796b649e85481845	Root	y	t	\N
7d3618373e07c4ce8896006919bbb531	Saltatio Mortis	n	t	\N
93025091752efa184fd034f285573afe	Samael	y	t	\N
460bf623f241651a7527a63d32569dc0	Sanguine	n	t	\N
ef75c0b43ae9ba972900e83c5ccf5cac	Satan's Fall	n	t	\N
182a1e726ac1c8ae851194cea6df0393	Schizophrenia	y	t	\N
0d8ef82742e1d5de19b5feb5ecb3aed3	Scordatura	y	t	\N
90802bdf218986ffc70f8a086e1df172	Scornebeke	y	t	\N
d1ba47339d5eb2254dd3f2cc9f7e444f	Scrvmp	y	t	\N
7cb94a8039f617f505df305a1dc2cc61	Seii Taishogun	y	t	\N
a9afdc809b94392fb1c2e873dbb02781	Sensles	m	t	\N
55696bac6cdd14d47cbe7940665e21d3	Serrabulho	y	t	\N
f79485ffe5db7e276e1e625b0be0dbec	Shoot the Girl first	n	t	\N
eb4558fa99c7f8d548cbcb32a14d469c	Shores of Null	y	t	\N
d76db99cdd16bd0e53d5e07bcf6225c8	Siberian Meat Grinder	y	t	\N
4c576d921b99dad80e4bcf9b068c2377	Sick of it all	y	t	\N
2e4e6a5f485b2c7e22f9974633c2b900	Phantom Winter	m	t	\N
13c8bd3a0d92bd186fc5162eded4431d	Six Feet Under	m	t	\N
50026a2dff40e4194e184b756a7ed319	Skeleton Pit	y	t	\N
92edfbaa71b7361a3081991627b0e583	Skeletonwitch	y	t	\N
062c44f03dce5bf39f81d0bf953926fc	Skinned Alive	y	t	\N
79cbf009784a729575e50a3ef4a3b1cc	Skull Fist	n	t	\N
6f60a61fcc05cb4d42c81ade04392cfc	Slaughterra	y	t	\N
0a3a1f7ca8d6cf9b2313f69db9e97eb8	Nocte Obducta	y	t	\N
073f87af06b8d8bc561bb3f74e5f714f	Sleepers' Guilt	y	t	\N
f34c903e17cfeea18e499d4627eeb3ec	Slipknot	y	t	\N
03fec47975e0e1e2d0bc723af47281de	Sober Truth	m	t	\N
118b96dde2f8773b011dfb27e51b2f95	Sodom	y	t	\N
75241d56d63a68adcd51d828eb76ca80	Solstafir	n	t	\N
381b834c6bf7b25b9b627c9eeb81dd8a	Soulburn	y	t	\N
cabcfb35912d17067131f7d2634ac270	Soulfly	y	t	\N
60a105e79a86c8197cec9f973576874b	Spasm	y	t	\N
34a9067cace79f5ea8a6e137b7a1a5c8	Obscenity	y	t	\N
e6cbb2e0653a61e35d26df2bcb6bc4c7	Stam1na	y	t	\N
e039d55ed63a723001867bc4eb842c00	Stillbirth	y	t	\N
010fb41a1a7714387391d5ea1ecdfaf7	Still Patient?	m	t	\N
3123e3df482127074cdd5f830072c898	Stonefall	y	t	\N
849c829d658baaeff512d766b0db3cce	Storm	y	t	\N
3b8d2a5ff1b16509377ce52a92255ffe	Street Dogs	y	t	\N
2460cdf9598c810ac857d6ee9a84935a	Sucking Leech	y	t	\N
01bcfac216d2a08cd25930234e59f1a1	Suicidal Angels	y	t	\N
c63b6261b8bb8145bc0fd094b9732c24	Suicidal Tendencies	y	t	\N
5ef02a06b43b002e3bc195b3613b7022	Sulphur Aeon	y	t	\N
5934340f46d5ab773394d7a8ac9e86d5	Sun of the Sleepless	y	t	\N
1c4af233da7b64071abf94d79c41a361	Supreme Carnage	y	t	\N
b36eb6a54154f7301f004e1e61c87ce8	Switch	y	t	\N
bbbb086d59122dbb940740d6bac65976	Take Offense	m	t	\N
26c2bb18f3a9a0c6d1392dae296cfea7	Task Force Beer	y	t	\N
6af2c726b2d705f08d05a7ee9509916e	Teethgrinder	y	t	\N
3a232003be172b49eb64e4d3e9af1434	Terror	y	t	\N
e3c8afbeb0ec4736db977d18e7e37020	Testament	y	t	\N
f32badb09f6aacb398d3cd690d90a668	The black Dahlia Murder	y	t	\N
99761fad57f035550a1ca48e47f35157	The Creatures from the Tomb	y	t	\N
87bd9baf0b0d760d1f0ca9a8e9526161	The Feelgood McLouds	y	t	\N
f975b4517b002a52839c42e86b34dc96	The Idiots	y	t	\N
5b5fc236828ee2239072fd8826553b0a	The Jailbreakers	y	t	\N
218ac7d899a995dc53cabe52da9ed678	The Monolith Project	y	t	\N
364be07c2428493479a07dbefdacc11f	The Ominous Circle	y	t	\N
56bf60ca682b8f68e8843ad8a55c6b17	The Phobos Ensemble	m	t	\N
8ee257802fc6a4d44679ddee10bf24a9	The Privateer	m	t	\N
94a62730604a985647986b509818efee	The Prophecy 23	y	t	\N
09c00610ca567a64c82da81cc92cb846	The Vintage Caravan	m	t	\N
bc834c26e0c9279cd3139746ab2881f1	Thornafire	y	t	\N
64a25557d4bf0102cd8f60206c460595	Thrudvangar	y	t	\N
445a222489d55b5768ec2f17b1c3ea34	Thunderstorm	m	t	\N
fd0a7850818a9a642a125b588d83e537	Thy Antichrist	y	t	\N
93aa5f758ad31ae4b8ac40044ba6c110	Too many Assholes	y	t	\N
99bdf8d95da8972f6979bead2f2e2090	Tornado	m	t	\N
123f90461d74091a96637955d14a1401	Traitors	y	t	\N
60eb61670a5385e3150cd87f915b0967	Trancemission	m	t	\N
b454fdfc910ad8f6b7509072cf0b4031	Tribulation	y	t	\N
06c5c89047bfd6012e6fb3c2bd3cb24b	Twitching Tongues	m	t	\N
156c19a6d9137e04b94500642d1cb8c2	Übergang	y	t	\N
827bf758c7ce2ac0f857379e9e933f77	Undertow	y	t	\N
e2afc3f96b4a23d451c171c5fc852d0f	Une Misere	y	t	\N
cd3296ec8f7773892de22dfade4f1b04	Tankard	y	t	\N
05bea3ed3fcd45441c9c6af3a2d9952d	Shambala	m	f	\N
2db1850a4fe292bd2706ffd78dbe44b9	Vader	y	t	\N
a30c1309e683fcf26c104b49227d2220	Vargsheim	y	t	\N
246d570b4e453d4cb6e370070c902755	Vektor	y	t	\N
dd0e61ab23e212d958112dd06ad0bfd2	Victorius	n	t	\N
5a534330e31944ed43cb6d35f4ad23c7	Visdom	m	t	\N
96aa953534221db484e6ec75b64fcc4d	Visions of Disfigurement	y	t	\N
75fea12b82439420d1f400a4fcf3386b	Völkerball	y	t	\N
951af0076709a6da6872f9cdf41c852b	Vomitory	y	t	\N
5c19e1e0521f7b789a37a21c5cd5737b	Vortex	n	t	\N
863e7a3d6d4a74739bca7dd81db5d51f	Walls of Jericho	y	t	\N
ce14eb923a380597f2aff8b65a742048	Warbringer	y	t	\N
a7111b594249d6a038281deb74ef0d04	Warfield	y	t	\N
02670bc3f496ce7b1393712f58033f6c	Warkings	m	t	\N
70492d5f3af58ace303d1c5dfc210088	When Plagues Collide	y	t	\N
26211992c1edc0ab3a6b6506cac8bb52	Whitechapel	m	t	\N
384e94f762d3a408cd913c14b19ac5e0	Who killed Janis	m	t	\N
3b544a6f1963395bd3ae0aeebdf1edd8	Wintersun	y	t	\N
511ac85b55c0c400422462064d6c77ed	Wisdom in Chains	m	t	\N
f9ff0bcbb45bdf8a67395fa0ab3737b5	Witchfucker	y	t	\N
39ce458f2caa87bc7b759cd8cb16e62f	Witchhunter	m	t	\N
00a0d9697a08c1e5d4ba28d95da73292	Within Destruction	y	t	\N
d8d3a01ba7e5d44394b6f0a8533f4647	Wizard	m	t	\N
a2a607567311cb7a5a609146b977f4a9	Wolfheart	y	t	\N
913df019fed1f80dc49b38f02d8bae41	World of Tomorrow	m	t	\N
3cd94848f6ccb600295135e86f1b46a7	Xaon	y	t	\N
b00114f9fc38b48cc42a4972d7e07df6	Zebrahead	m	t	\N
a2761eea97ee9fe09464d5e70da6dd06	Zodiac	y	t	\N
9d514e6b301cfe7bdc270212d5565eaf	Zombi	m	t	\N
a2c31c455e3d0ea3f3bdbea294fe186b	Redgrin	y	t	\N
ffd2da11d45ed35a039951a8b462e7fb	Torment of Souls	y	t	\N
16c88f2a44ab7ecdccef28154f3a0109	Skelethal	y	t	\N
191bab5800bd381ecf16485f91e85bc3	Keitzer	y	t	\N
876eed60be80010455ff50a62ccf1256	Blodtåke	y	t	\N
f4e4ef312f9006d0ae6ca30c8a6a32ff	Souldevourer	y	t	\N
c311f3f7c84d1524104b369499bd582f	Fabulous Desaster	y	t	\N
1629fa6d4b8adb36b0e4a245b234b826	Satan Worship	y	t	\N
270fb708bd03433e554e0d7345630c8e	The Laws Kill Destroy (Fábio Jhasko's Sarcófago tribute)	y	t	\N
9d1e68b7debd0c8dc86d5d6500884ab4	Mortal Peril	y	t	\N
8987e9c300bc2fc5e5cf795616275539	Infected Inzestor	y	t	\N
ba5e6ab17c7e5769b11f98bfe8b692d0	Birdflesh	m	t	\N
eb0a191797624dd3a48fa681d3061212	Master	y	t	\N
13de0a41f18c0d71f5f6efff6080440f	Misanthropia	y	t	\N
5885f60f8c705921cf7411507b8cadc0	Severe Torture	y	t	\N
f31ba1d770aac9bc0dcee3fc15c60a46	Undying Lust for Cadaverous Molestation (UxLxCxM)	y	t	\N
0ae3b7f3ca9e9ddca932de0f0df00f8a	Lecks inc.	y	t	\N
0e609404e53b251f786b41b7be93cc19	Hate	y	t	\N
b1006928600959429230393369fe43b6	Belphegor	y	t	\N
478aedea838b8b4a0936b129a4c6e853	I am Morbid	y	t	\N
f2856ad30734c5f838185cc08f71b1e4	Baest	y	t	\N
410044b393ebe6a519fde1bdb26d95e8	Der rote Milan	y	t	\N
abca417a801cd10e57e54a3cb6c7444b	Äera	y	t	\N
867872f29491a6473dae8075c740993e	Jesajah	y	t	\N
c937fc1b6be0464ec9d17389913871e4	Balberskult	y	t	\N
e9648f919ee5adda834287bbdf6210fd	Hellburst	y	t	\N
1f86700588aed0390dd27c383b7fc963	Crypts	y	t	\N
faec47e96bfb066b7c4b8c502dc3f649	Wound	y	t	\N
16cf4474c5334c1d9194d003c9fb75c1	Venefixion	y	t	\N
8e38937886f365bb96aa1c189c63c5ea	Asagraum	y	t	\N
8ed55fda3382add32869157c5b41ed47	Possession	y	t	\N
4e9dfdbd352f73b74e5e51b12b20923e	Grave Miasma	m	t	\N
88059eaa73469bb47bd41c5c3cdd1b50	Sacramentum﻿	m	t	\N
56e8538c55d35a1c23286442b4bccd26	Impaled Nazarene	m	t	\N
375974f4fad5caae6175c121e38174d0	Bloodland	y	t	\N
f4b526ea92d3389d318a36e51480b4c8	LAWMÄNNER	n	t	\N
3929665297ca814b966cb254980262cb	Stagewar	m	t	\N
fbc2b3cebe54dd00b53967c5cf4b9192	The Fog	y	t	\N
644f6462ec9801cdc932e5c8698ee7f9	Goath	y	t	\N
dbf1b3eb1f030affb41473a8fa69bc0c	Velvet Viper	n	t	\N
61725742f52de502605eadeac19b837b	Elmsfire	m	t	\N
2fb81ca1d0a935be4cb49028268baa3f	Poisöned Speed	y	t	\N
b3626b52d8b98e9aebebaa91ea2a2c91	Nachtblut	y	t	\N
347fb42f546e982de2a1027a2544bfd0	Mister Misery	m	t	\N
97724184152a2620b76e2f93902ed679	Pyogenesis	n	t	\N
4bffc4178bd669b13ba0d91ea0522899	Schöngeist	y	t	\N
b084dc5276d0211fae267a279e2959f0	Enter Tragedy	y	t	\N
f66935eb80766ec0c3acee20d40db157	Erdling	y	t	\N
cd1c06e4da41121b7362540fbe8cd62c	Stahlmann	y	t	\N
9459200394693a7140196f07e6e717fd	Sabaton	y	t	\N
4e74055927fd771c2084c92ca2ae56a7	The Spirit	y	t	\N
a753c3945400cd54c7ffd35fc07fe031	Orca	y	t	\N
8af17e883671377a23e5b8262de11af4	Kryn	m	t	\N
d1fded22db9fc8872e86fff12d511207	V.I.D.A	y	t	\N
c526681b295049215e5f1c2066639f4a	Impartial	m	t	\N
3969716fc4acd0ec0c39c8a745e9459a	Lycanthrope	m	t	\N
b7b99e418cff42d14dbf2d63ecee12a8	Speedemon	y	t	\N
96b4b857b15ae915ce3aa5e406c99cb4	Almøst Human	y	t	\N
8b5a84ba35fa73f74df6f2d5a788e109	Moral Putrefaction	y	t	\N
57f622908a4d6c381241a1293d894c88	Cadaver	y	t	\N
48438b67b2ac4e5dc9df6f3723fd4ccd	Criminal	y	t	\N
56a5afe00fae48b02301860599898e63	Tranatopsy	y	t	\N
3e8d4b3893a9ebbbd86e648c90cbbe63	Ludicia	y	t	\N
c46e8abb68aae0bcdc68021a46f71a65	Komodo	m	t	\N
e4f74be13850fc65559a3ed855bf35a8	Typhus	m	t	\N
7b52c8c4a26e381408ee64ff6b98e231	Múr	y	t	\N
278af3c810bb9de0f355ce115b5a2f54	Fusion Bomb	y	t	\N
5c61f833c2fb87caab0a48e4c51fa629	Mork	y	t	\N
2859f0ed0630ecc1589b6868fd1dde41	Gaerea	y	t	\N
fc239fd89fd7c9edbf2bf27d1d894bc0	Implore	y	t	\N
24701da4bd9d3ae0e64d263b72ad20e8	Mythraeum	y	t	\N
031d6cc33621c51283322daf69e799f5	The Risen Dread	y	t	\N
a8ace0f003d8249d012c27fe27b258b5	Pestilence	y	t	\N
255661921f4ad57d02b1de9062eb6421	Onslaught	y	t	\N
5d53b2be2fe7e27daa27b94724c3b6de	Blood Incantation	y	t	\N
51cb62b41cd9deaaa2dd98c773a09ebb	Misanthropic	y	t	\N
cba8cb3c568de75a884eaacde9434443	Leng Tch'e	y	t	\N
19cbbb1b1e68c42f3415fb1654b2d390	Bloodtruth	y	t	\N
f44f1e343975f5157f3faf9184bc7ade	Organectomy	y	t	\N
1e986acf38de5f05edc2c42f4a49d37e	Gutslit	y	t	\N
10627ac0e35cfed4a0ca5b97a06b9d9f	Coffin Feeder	y	t	\N
b834eadeaf680f6ffcb13068245a1fed	Suffocation	y	t	\N
1ec58ca10ed8a67b1c7de3d353a2885b	Acéldama	y	t	\N
8f523603c24072fb8ccb547503ee4c0f	Gore Dimension	y	t	\N
43a4893e6200f462bb9fe406e68e71c0	Gutalax	y	t	\N
9c31bcca97bb68ec33c5a3ead4786f3e	Bound to Prevail	y	t	\N
c445544f1de39b071a4fca8bb33c2772	Basement Torture Killings	y	t	\N
29891bf2e4eff9763aef15dc862c373f	Kanine	y	t	\N
c8fbeead5c59de4e8f07ab39e7874213	Profanity	y	t	\N
8fa1a366d4f2e520bc9354658c4709f1	Hurakan	y	t	\N
812f48abd93f276576541ec5b79d48a2	Brutal Sphincter	y	t	\N
d29c61c11e6b7fb7df6d5135e5786ee1	Tortharry	y	t	\N
7013a75091bf79f04f07eecc248f8ee6	Human Prey	y	t	\N
58e42b779d54e174aad9a9fb79e7ebbc	Phrymerial	y	t	\N
67493f858802a478bfe539c8e30a7e44	Cumbeast	y	t	\N
f7910d943cc815a4a0081668ac2119b2	Monasteries	y	t	\N
955a5cfd6e05ed30eec7c79d2371ebcf	Côte D' Aver	y	t	\N
03201e85fc6aa56d2cb9374e84bf52ca	Vomit the Soul	y	t	\N
e7a227585002db9fee2f0ed56ee5a59f	Endseeker	y	t	\N
bc111d75a59fe7191a159fd4ee927981	Wormed	y	t	\N
017e06f9b9bccafa230a81b60ea34c46	Beheaded	y	t	\N
22c2fc8a3a81503d40d4e532ac0e22ab	Shores of Lunacy	y	t	\N
482818d4eb4ca4c709dcce4cc2ab413d	April in Flames	y	t	\N
ec788cc8478763d79a18160a99dbb618	Asinis	y	t	\N
d2f62cd276ef7cab5dcf9218d68f5bcf	Mike Litoris Complot	y	t	\N
e71bd61e28ae2a584cb17ed776075b55	Lesson in Violence	y	t	\N
49a41ffa9c91f7353ec37cda90966866	Urinal Tribunal	y	t	\N
1c13f340d154b44e41c996ec08d76749	Melodramatic Fools	y	t	\N
d5b95b21ce47502980eebfcf8d2913e0	Cypecore	y	t	\N
0b6bcec891d17cd7858525799c65da27	Shot Crew	y	t	\N
3cb077e20dabc945228ea58813672973	Impending Mindfuck	y	t	\N
8734f7ff367f59fc11ad736e63e818f9	Thron	y	t	\N
98aa80527e97026656ec54cdd0f94dff	Heretoir	m	t	\N
430a03604913a64c33f460ec6f854c36	Asphagor	y	t	\N
319480a02920dc261209240eed190360	Drill Star Autopsy	y	t	\N
4ca1c3ed413577a259e29dfa053f99db	Zero Degree	y	t	\N
2eed213e6871d0e43cc061b109b1abd4	Ferndal	y	t	\N
fdedcd75d695d1c0eb790a5ee3ba90b5	Avataria	y	t	\N
ed9b92eb1706415c42f88dc91284da8a	Graveworm	y	t	\N
fb1afbea5c0c2e23396ef429d0e42c52	Agathodaimon	y	t	\N
316a289ef71c950545271754abf583f1	Iron Savior	n	t	\N
33b3bfc86d7a57e42aa30e7d1c2517be	Saxorior	y	t	\N
8351282db025fc2222fc61ec8dd1df23	Empyreal	y	t	\N
60eb202340e8035af9e96707f85730e5	Eridu	y	t	\N
d2f79e6a931cd5b5acd5f3489dece82a	Jarl	y	t	\N
3189b8c5e007c634d7e28ef93be2b774	Torian	n	t	\N
a89af36e042b5aa91d6efea0cc283c02	Machine Head	y	t	\N
eb2743e9025319c014c9011acf1a1679	The Halo Effect	y	t	\N
c27297705354ef77feb349e949d2e19e	Credic	y	t	\N
3258eb5f24b395695f56eee13b690da6	Glemsel	y	t	\N
8f7939c28270f3187210641e96a98ba7	Naxen	y	t	\N
bcf744fa5f256d6c3051dd86943524f6	Horns of Domination	y	t	\N
3ba296bfb94ad521be221cf9140f8e10	Beltez	y	t	\N
18e21eae8f909cbb44b5982b44bbf02f	Ninkharsag	y	t	\N
3438d9050b2bf1e6dc0179818298bd41	Hemelbestormer	y	t	\N
384712ec65183407ac811fff2f4c4798	Algebra	y	t	\N
a76c5f98a56fc03100d6a7936980c563	Comaniac	y	t	\N
66cc7344291ae2a297bf2aa93d886e22	Cryptosis	y	t	\N
34ca5622469ad1951a3c4dc5603cea0f	Fatal Fire	n	t	\N
933c8182650ca4ae087544beff5bb52d	Viscera	y	t	\N
e3de2cf8ac892a0d8616eefc4a4f59bd	Oceano	y	t	\N
623c5a1c99aceaf0b07ae233d1888e0a	Distant	y	t	\N
34e927c45cf3ccebb09b006b00f4e02d	Crowbar	y	t	\N
c091e33f684c206b73b25417f6640b71	Sacred Reich	y	t	\N
bcc770bb6652b1b08643d98fd7167f5c	Guineapig	y	t	\N
73cb08d143f893e645292dd04967f526	Plasma	y	t	\N
eb3a9fb71b84790e50acd81cc1aa4862	The Hu	y	t	\N
13909e3013727a91ee750bfd8660d7bc	Volbeat	y	t	\N
74e8b6c4be8a0f5dd843e2d1d7385a36	Bad Wolves	m	t	\N
2dde74b7ec594b9bd78da66f1c5cafdc	Skindred	m	t	\N
5324a886a2667283dbfe7f7974ff6fc0	Diaroe	y	t	\N
28c5f9ffd175dcd53aa3e9da9b00dde7	Depression	y	t	\N
b798aa74946ce75baee5806352e96272	Placenta Powerfist	y	t	\N
6315887dd67ff4f91d51e956b06a3878	Fulci	y	t	\N
df99cee44099ff57acbf7932670614dd	Revocation	y	t	\N
6b141e284f88f656b776148cde8e019c	Goatwhore	y	t	\N
b84cdd396f01275b63bdaf7f61ed5a43	Alluvial	y	t	\N
9133f1146bbdd783f34025bf90a8e148	Escuela Grind	y	t	\N
9d74605e4b1d19d83992a991230e89ef	Necrotted	y	t	\N
ca54e4f7704e7b8374d0968143813fe6	Legal Hate	y	t	\N
c245b4779defd5c69ffebbfdd239dd1b	Deep Dirty	y	t	\N
6b157916b43b09df5a22f658ccb92b64	Blood	y	t	\N
67cd9b4b7b33511f30e85e21b2d3b204	Schirenc Plays Pungent Stench	y	t	\N
5c29c2e513aadfe372fd0af7553b5a6c	Mason	y	t	\N
e4b1d8cc71fd9c1fbc40fdc1a1a5d5b3	Antagonism	y	t	\N
b12daab6c83b1a45aa32cd9c2bc78360	Plagueborne	y	t	\N
9722f54adb556b548bb9ecce61a4d167	Orobas	y	t	\N
04d53bc45dc1343f266585b52dbe09b0	Kilminister	y	t	\N
0c31e51349871cfb59cfbfaaed82eb18	Vomit Spell	y	t	\N
41dabe0c59a3233e3691f3c893eb789e	Servant	y	t	\N
113ab4d243afc4114902d317ad41bb39	Shaârghot	y	t	\N
cc70416ca37c5b31e7609fcc68ca009e	Ragnarök Nordic & Viking Folk	y	t	\N
7b91dc9ecdfa3ea7d347588a63537bb9	Perchta	y	t	\N
55c63b0540793d537ed29f5c41eb9c3e	Estampie	y	t	\N
43bd0d50fe7d58d8fce10c6d4232ca1e	Rauhbein	y	t	\N
cf38e7d92bb08c96c50ddc723b624f9d	Apocalypse Orchestra	y	t	\N
5f449b146ce14c780eee323dfc5391e8	Elvenking	m	t	\N
eef7d6da9ba6d0bed2078a5f253f4cfc	HateSphere	y	t	\N
ad51cbe70d798b5aec08caf64ce66094	sign of death	y	t	\N
45e410efd11014464dd36fb707a5a9e1	Nervecell	y	t	\N
8fdc3e13751b8f525f259d27f2531e87	WeedWizard	y	t	\N
05e76572fb3d16ca990a91681758bbee	Human Waste	y	t	\N
cfc61472d8abd7c54b81924119983ed9	Braincasket	y	t	\N
1fe0175f73e5b381213057da98b8f5fb	5 Stabbed 4 Corpses	y	t	\N
d44be0e711c2711876734b330500e5b9	Pusboil	y	t	\N
c295bb30bf534e960a6acf7435f0e46a	Vibrio Cholera	y	t	\N
ab3ca496cbc01a5a9ed650c4d0e26168	Demorphed	y	t	\N
538eaaef4d029c255ad8416c01ab5719	OPS - Orphan Playground Sniper	y	t	\N
1de3f08835ab9d572e79ac0fca13c5c2	Vor die Hunde	y	t	\N
4c02510c3f16e13edc27eff1ef2e452c	Hereza	y	t	\N
7cbd455ff5af40e28a1eb97849f00723	Gorgatron	y	t	\N
3d4fe2107d6302760654b4217cf32f17	Rottenness	y	t	\N
3c8ce0379b610d36c3723b198b982197	Nuclear Vomit	y	t	\N
d0dae91314459033160dc47a79aa165e	Dead Man's Hand	y	t	\N
5878f5f2b1ca134da32312175d640134	The Gentlemen's Revenge	y	t	\N
7eeea2463ae5da9990cab53c014864fa	Gunnar	n	t	\N
b1c7516fef4a901df12871838f934cf6	The Hollywood Vampires	y	t	\N
4669569c9a870431c4896de37675a784	Sting	y	t	\N
9d36a42a36b62b3f665c7fa07f07563b	Shaggy	y	t	\N
087c643d95880c5a89fc13f3246bebae	Witchkrieg	y	t	\N
be553803806b8634990c2eb7351ed489	Harlott	y	t	\N
8bdd6b50b8ecca33e04837fde8ffe51e	Angstskíg	m	t	\N
18b751c8288c0fabe7b986963016884f	Tiamat	m	t	\N
30b8affc1afeb50c76ad57d7eda1f08f	Gorleben	m	t	\N
a8a43e21de5b4d83a6a7374112871079	Bitchhammer	m	t	\N
9614cbc86659974da853dee20280b8c4	Infest	y	t	\N
bc2f39d437ff13dff05f5cfda14327cc	Corrupt	y	t	\N
39530e3fe26ee7c557392d479cc9c93f	Incantation	y	t	\N
537e5aa87fcfb168be5c953d224015ff	Embryo	y	t	\N
80d331992feb02627ae8b30687c7bb78	Shampoon Killer	y	t	\N
f6eb4364ba53708b24a4141962feb82e	Boötes Void	y	t	\N
2cd225725d4811d813a5ea1b701db0db	Sněť	y	t	\N
2f6fc683428eb5f8b22cc5021dc9d40d	Kadaverficker	y	t	\N
2d5a306f74749cc6cbe9b6cd47e73162	Maceration	y	t	\N
dba84ece8f49717c47ab72acc3ed2965	Mephorash	y	t	\N
559314721edf178fa138534f7a1611b9	Haemorrhage	y	t	\N
d192d350b6eace21e325ecf9b0f1ebd1	Methane	y	t	\N
d6a020f7b50fb4512fd3c843af752809	Necrosy	y	t	\N
73f4b98d80efb8888a2b32073417e21e	Massacre	y	t	\N
711a7acac82d7522230e3c7d0efc3f89	Sirrush	y	t	\N
1506aeeb8c3a699b1e3c87db03156428	Midnight	y	t	\N
4f58423d9f925c8e8bd73409926730e8	Mystifier	y	t	\N
96390e27bc7e2980e044791420612545	Possessed	y	t	\N
d2c2b83008dce38013577ef83a101a1b	LIK	y	t	\N
c1e8b6d7a1c20870d5955bcdc04363e4	Ash Nazg Búrz	y	t	\N
480a0efd668e568595d42ac78340fe2a	Seth	y	t	\N
d25956f771b58b6b00f338a41ca05396	Demonical	y	t	\N
95a1f9b6006151e00b1a4cda721f469d	Arkona	y	t	\N
5159ae414608a804598452b279491c5c	Darkfall	y	t	\N
9bdbe50a5be5b9c92dccf2d1ef05eefd	Totensucht	y	t	\N
8c4e8003f8d708dc3b6d486d74d9a585	Saor	y	t	\N
b6eba7850fd20fa8dce81167f1a6edca	Home Reared Meat	y	t	\N
5f27f488f7c8b9e4b81f59c6d776e25c	Nyctopia	y	t	\N
1a5235c012c18789e81960333a76cd7a	Riot City	n	t	\N
7f950b15aa65a26e8500cfffd7f89de0	Defleshed	y	t	\N
77f94851e582202f940198a26728e71f	Resurrected	y	t	\N
baeb191b42ec09353b389f951d19b357	Phantom Corporation	y	t	\N
c21fe390daecee9e70b8f4b091ae316f	Bodyfarm	y	t	\N
8aeadeeff3e1a3e1c8a6a69d9312c530	Krisiun	y	t	\N
a4e0f3b7db0875f65bb3f55ab0aab7c6	Bloodbath	y	t	\N
37b43a655dec0e3504142003fce04a07	Deicide	y	t	\N
781734c0e9c01b14adc3a78a4c262d83	Matt Miller	y	t	\N
89b5ac8fb4c102c174adf2fed752a970	Groundville Bastards	y	t	\N
cc31970696ef00b4c6e28dba4252e45d	The Killer Apes	y	t	\N
92e1aca33d97fa75c1e81a9db61454bb	Pinch Black	y	t	\N
0ba2f4073dd8eff1f91650af5dc67db4	Putrid Pile	y	t	\N
bd555d95b1ccba75afca868636b1b931	Signs of the Swarm	y	t	\N
a93376e58f4c73737cf5ed7d88c2169c	Squash Bowels	y	t	\N
cd3faaaf1bebf8d009aa59f887d17ef2	VILE	y	t	\N
33538745a71fe2d30689cac96737e8f7	Suffocate Bastard	y	t	\N
586ac67e6180a1f16a4d3b81e33eaa94	Fleshless	y	t	\N
ca1720fd6350760c43139622c4753557	Anime Torment	y	t	\N
645b264cb978b22bb2d2c70433723ec0	Kraanium	y	t	\N
45816111a5b644493b68cfedfb1a0cc0	Viscera Trail	y	t	\N
5bb416e14ac19276a4b450d343e4e981	Holy Moses	m	f	\N
06c1680c65972c4332be73e726de9e74	Embrace your Punishment	y	t	\N
4671068076f66fb346c4f62cbfb7f9fe	Devangelic	y	t	\N
10407de3db48761373a403b8ddf09782	Monument of Misanthropy	y	t	\N
77ac561c759a27b7d660d7cf0534a9c3	Ruins of Perception	y	t	\N
3771036a0740658b11cf5eb73d9263b3	Vulvectomy	y	t	\N
6b37fe4703bd962004cdccda304cc18e	Torsofuck	y	t	\N
371d905385644b0ecb176fd73184239c	Crepitation	y	t	\N
d871ebaec65bbfa0b6b97aefae5d9150	Amputated	y	t	\N
28bb3f229ca1eeb05ef939248f7709ce	Colpocleisis	y	t	\N
861613f5a80abdf5a15ea283daa64be3	Kinski	y	t	\N
080d2dc6fa136fc49fc65eee1b556b46	Cephalic Carnage	m	t	\N
2df9857b999e21569c3fcce516f0f20e	Malignancy	m	t	\N
d5a5e9d2edeb2b2c685364461f1dfd46	Invoker	y	t	\N
1fcf2f2315b251ebe462da320491ea9f	Torturized	y	t	\N
7022f6b60d9642d91eebba98185cd9ba	Groza	y	t	\N
0d01b12a6783b4e60d2e09e16431f00a	Flammenaar	y	t	\N
9c81c8c060b39e7437b2d913f036776b	Asenblut	y	t	\N
4522c5141f18b2a408fc8c1b00827bc3	Obscurity	y	t	\N
5ec194adf19442544d8a94f4696f17dc	Aetherian	y	t	\N
31e2d1e0b364475375cb17ad76aa71f2	Convictive	y	t	\N
dff880ae9847f6fa8ed628ed4ee5741b	Nameless Death	y	t	\N
521c8a16cf07590faee5cf30bcfb98b6	Matricide	y	t	\N
a77c14ecd429dd5dedf3dc5ea8d44b99	Angelcrypt	y	t	\N
b8d794c48196d514010ce2c2269b4102	Macbeth	m	t	\N
a0abb504e661e34f5d269f113d39ea96	The Shit Shakers	y	t	\N
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	Jo Carley and the old dry skulls	y	t	\N
69a6a78ace079846a8f0d3f89beada2c	Skaphos	y	t	\N
43ff5aadca6d8a60dd3da21716358c7d	Warside	y	t	\N
95800513c555e1e95a430e312ddff817	Horrible Creatures	y	t	\N
42085fca2ddb606f4284e718074d5561	Magefa	y	t	\N
e2226498712065ccfca00ecb57b8ed2f	On every Page	y	t	\N
db732a1a9861777294f7dc54eeca2b3e	Mindreaper	y	t	\N
1ace9926ad3a6dab09d16602fd2fcccc	Infected Chaos	y	t	\N
05256decaa2ee2337533d95c7de3db9d	Maniacs Brainacts	y	t	\N
c664656f67e963f4c0f651195f818ce0	Isn't	y	t	\N
df800795b697445f2b7dc0096d75f4df	Lack of Senses	m	t	\N
810f28b77fa6c866fbcceb6c8aa7bac4	Disrooted	m	t	\N
7fcdd5f715be5fce835b68b9e63e1733	Guardians Gate	m	t	\N
5214513d882cf478e028201a0d9031c0	Arctic Winter	y	t	\N
0e4f0487408be5baf091b74ba765dce7	Epicedium	y	t	\N
8cd7fa96a5143f7105ca92de7ff0bac7	Crescent	y	t	\N
bdbafc49aa8c3e75e9bd1e0ee24411b4	Purgatory	y	t	\N
5863c78fb68ef1812a572e8f08a4e521	Torture Killer	y	t	\N
a822d5d4cdcb5d1b340a54798ac410b7	Ton Steine Scherben	y	t	\N
08e2440159e71c7020394db19541aabc	Are we used to it	y	t	\N
c8fd07f040a8f2dc85f5b2d3804ea3db	Contrast	y	t	\N
866208c5b4a74b32974bffb0f90311ca	Alteration	y	t	\N
fd3ab918dab082b1af1df5f9dbc0041f	Soulburner	y	t	\N
cb0785d67b1ea8952fae42efd82864a7	Hellgarden	y	t	\N
a0d3b444bd04cd165b4e076c9fc18bee	Destruction	y	t	\N
c846d80d826291f2a6a0d7a57e540307	Whiplash	y	t	\N
d0b02893ceb72d11a3471fe18d7089fd	Journey of D.C.	y	t	\N
6db22194a183d7da810dcc29ea360c17	Hellbent on Rocking	y	t	\N
ab5428d229c61532af41ec2ca258bf30	Lost on Airfield	y	t	\N
78a7bdfe7277f187e84b52dea7b75b0b	Defacing God	y	t	\N
f36fba9e93f6402ba551291e34242338	Triagone	y	t	\N
e6489b9cc39c95e53401cb601c4cae09	Losing my Grip	y	t	\N
4622209440a0ade57b18f21ae41963d9	LEYKA	y	t	\N
867e7f73257c5adf6a4696f252556431	Decreate	y	t	\N
f999abbe163f001f55134273441f35c0	Spreading Miasma	y	t	\N
9527fff55f2c38fa44281cd0e4d511ba	Root of all Evil	y	t	\N
04c8327cc71521b265f2dc7cbe996e13	No Face no Case	m	t	\N
f8b01df5282702329fcd1cae8877bb5f	Children of Bodom	y	f	\N
658a9bbd0e85d854a9e140672a46ce3a	Ctulu	y	f	\N
0925467e1cc53074a440dae7ae67e3e9	Slayer	y	f	\N
c18bdeb4f181c22f04555ea453111da1	Harvest their Bodies	y	t	\N
4338a835aa6e3198deba95c25dd9e3de	Call of Charon	y	t	\N
6829c770c1de2fd9bd88fe91f1d42f56	Trennjaeger	y	t	\N
b14521c0461b445a7ac2425e922c72df	Cavalera Conspiracy	y	t	\N
31da4ab7750e057e56224eff51bce705	Cliteater	y	f	\N
6fa204dccaff0ec60f96db5fb5e69b33	Uburen	y	t	\N
2587d892c1261be043d443d06bd5b220	Kanonenfieber	y	t	\N
b9fd9676338e36e6493489ec5dc041fe	Rats of Gomorrah (Divide)	y	t	Change name from Divide to Rats of Gomorrah
61a6502cfdff1a1668892f52c7a00669	Arkuum	y	t	\N
d69462bef6601bb8d6e3ffda067399d9	Gernotshagen	y	t	\N
04728a6272117e0dc4ec29b0f7202ad8	Soul Grinder	y	t	\N
0ada417f5b4361074360211e63449f34	Slamentation	y	t	\N
53c25598fe4f1f71a1c596bd4997245c	Blue Collar Punks	y	t	\N
8518eafd8feec0d8c056d396122a175a	Knife1	m	t	They play Hardcore
0d949e45a18d81db3491a7b451e99560	Imha Tarikat	y	t	\N
5c3278fb76fa2676984396d33ba90613	Spearhead	y	t	\N
dda8e0792843816587427399f34bd726	Bresslufd	y	t	\N
f1a37824dfc280b208e714bd80d5a294	NineUnderZero	y	t	\N
786a755c895da064ccd4f9e8eb7e484e	PushSeven12	n	t	\N
f68a3eafcc0bb036ee8fde7fc91cde13	Abbath	y	t	\N
78f5c568100eb61401870fa0fa4fd7cb	Toxic Holocaust	y	t	\N
ab42c2d958e2571ce5403391e9910c40	Liverless	y	t	\N
b86f86db61493cc2d757a5cefc5ef425	Rigorious	y	t	\N
98dd2a77f081989a185cb652662eea41	Abrasive	y	t	\N
c1a08f1ea753843e2b4f5f3d2cb41b7b	Necromorphic Despair	y	t	\N
807dbc2d5a3525045a4b7d882e3768ee	Chordotomy	y	t	\N
45d62f43d6f59291905d097790f74ade	Ascendancy	m	t	\N
2df0462e6f564f34f68866045b2a8a44	Screwed Death	m	t	\N
6ee6a213cb02554a63b1867143572e70	Mother	y	t	\N
496a6164d8bf65daf6ebd4616c95b4b7	Munich Fiends	y	t	\N
db1440c4bae3edf98e3dab7caf2e7fed	Fallujah	y	t	\N
bff322dbe273a1e2d1fe37f81acccbe4	Vulvodynia	y	t	\N
36b208182f04f44c80937e980c3c28fd	Mélancholia	y	t	\N
a1af2abbd036f0499296239b29b40a5f	South of Hessen	y	t	\N
89d60b9528242c8c53ecbfde131eba21	Putridarium	y	t	\N
e8d17786fed9fa5ddaf13881496106e4	Astral Wrath	y	t	Ukraine + Germany
0371892b7f65ffb9c1544ee35c6330ad	Rectal Depravity	y	t	\N
bf5c782ca6b0130372ac41ebd703463e	Satan's Revenge on Mankind	y	t	\N
f041991eb3263fd3e5d919026e772f57	Hour of Penance	y	t	\N
70409bc559ef6c8aabcf16941a29788b	Volière	y	t	\N
0ecef959ca1f43d538966f7eb9a7e2ec	Zementmord	y	t	\N
169c9d1bfabf9dec8f84e1f874d5e788	Lunatic Dictator	y	t	\N
01ffa9ce7c50b906e4f5b6a2516ba94b	These Days & Those Days	y	t	\N
d104b6ae44b0ac6649723bac21761d41	Napoli Violenta	y	t	\N
aaaad3022279d4afdb86ad02d5bde96b	Toter Fisch	y	t	\N
c5068f914571c27e04cd66a4ec5c1631	Kampfar	y	t	\N
fdcfaa5f48035ad96752731731ae941a	Severoth	y	t	\N
ca4038e41aaa675d65dc3f2ea92556e9	Endonomos	m	t	\N
7e0e2fabeced85b4b8bbbca59858d33d	Nervo Chaos	y	t	\N
f0f2e6b4ae39fe3ef81d807f641f54a9	Ultha	y	t	\N
841981e178ed25ef0f86f34ce0fb2904	Distaste	y	t	\N
fe4398ac7504e937c2ff97039aa66311	Putrid Defecation	y	t	\N
49d387abd142d76f4b38136257f56201	Frostshock	y	t	\N
0fa4e99a2451478f3870e930d263cfd4	Blakylle	y	t	\N
6c718d616702ff78522951d768552d6a	The Monolith Deathcult	y	t	\N
9efb345179e21314a38093da366e1f09	Morbus Dei	y	t	\N
b7f3ddec78883ff5a0af0d223f491db8	Scumtomy	y	t	\N
3472e72b1f52a7fda0d4340e563ea6c0	Pestifer	y	t	\N
f816407dd0b81a5baedb7695302855d9	Intrepid	y	t	\N
e2b16c5f5bad24525b8c700c5c3b3653	Persecutor	y	t	\N
ca3fecb0d12232d1dd99d0b0d83c39ec	Harakiri For The Sky	m	t	\N
b0353ada659e3848bd59dec631e71f9e	Entgeist	y	t	\N
f929c32e1184b9c0efdd60eb947bf06b	Orphaned Land	y	t	\N
25f02579d261655a79a54a1fc5c4baf5	Lone Survivors	y	t	\N
10dbb54312b010f3aeb9fde389fe6cf5	Science of Disorder	y	t	\N
de2290e4c7bfa39e594c2dcd6e4c09d6	Empyrium	n	t	\N
c256d34ab1f0bd3928525d18ddabe18e	The Vision Bleak	n	t	\N
49bb0f64fae1bd9abf59989d5a5adfaf	AHAB	n	t	\N
0035ac847bf9e371750cacbc98ad827b	Hexvessel	n	t	\N
e093d52bb2d4ff4973e72f6eb577714b	Chapel of Disease	m	t	\N
f0cd1b3734f01a46d31c5644e3216382	Immolation	y	t	\N
0182742917720e1b2cf59ff671738253	Municipal Waste	y	t	\N
2ef1ea5e4114637a2dc94110d4c3fc7a	Endezzma	y	t	\N
09fcf410c0bb418d24457d323a5c812a	Totenwache	y	t	\N
bd6d4ce8e8bd1f6494db102db5a06091	Lunar Spells	y	t	\N
f68e5e7b745ade835ef3029794b4b0b2	Svarttjern	y	t	\N
d4f9c39bf51444ae90cc8947534f20e4	Valosta Varjoon	y	t	\N
55edd327aec958934232e98d828fb56a	Tsjuder	y	t	\N
6435684be93c4a59a315999d3a3227f5	Order of Nosferat	y	t	\N
a6c37758f53101378a209921511369de	Dødsfall	y	t	\N
5b05784f3a259c7ebc2fffc1cf0c37b7	Czort	y	t	\N
baf938346589a5e047e2aa1afcc3d353	Whisky Ritual	m	t	\N
e340c1008146e56c9d6c7ad7aa5b8146	Autumn Nostalgie	m	t	\N
034c15ae2143eea36eec7292010568a1	Apocalyptica	y	t	\N
50437ed6fdec844c3d86bb6ac8a4a333	The Raven Age	m	t	\N
7df470ec0292985d8f0e37aa6c2b38d5	Soilwork	m	t	\N
bb7dcf6e8a0c1005d2be54f005e9ff8f	Craving	m	t	\N
05acc535cbe432a56e2c9cfb170ee635	Call of the Void	n	t	\N
7a78e9ce32da3202ac0ca91ec4247086	Rise of Kronos	y	t	Change name from Surface to Rise of Kronos
ba404ce5a29ba15a792583bbaa7969c6	Los Males del Mundo	y	t	\N
d8cddac7db3dedd7d96b81a31dc519b3	Necrowretch	y	t	\N
63dab0854b1002d4692bbdec90ddaecc	Septicflesh	y	t	\N
3e8f57ef55b9d3a8417963f343db1de2	Equilibrium	y	t	\N
7176be85b1a9e340db4a91d9f17c87b3	Oceans	y	t	\N
cc31f5f7ca2d13e95595d2d979d10223	Scar of the Sun	m	t	\N
dd15d5adf6349f5ca53e7a2641d41ab7	ADDICT	m	t	\N
739260d8cb379c357340977fe962d37a	At the Gates	m	t	\N
ea6fff7f9d00d218338531ab8fe4e98c	Jesus Piece	y	t	\N
00a616d5caaf94d82a47275101e3fa22	Obituary	y	t	\N
4bcbcb65040e0347a1ffb5858836c49c	Knife2	y	t	They play Speed Metal
708abbdc2eb4b62e6732c4c2a60c625a	Scars of Violence	y	t	\N
ffd6243282cdf77599e2abaf5d1a36e5	Gatecreeper	y	t	\N
d148b29cbc0092dc206f9217a1b3da73	200 Stab Wounds	y	t	\N
a70a003448c0c2d2a6d4974f60914d40	Enforced	y	t	\N
68f05e1c702a4218b7eb968ff9489744	Guerrilla Fist	y	t	\N
dba661bb8c2cd8edac359b22d3f9ddf3	Roots of Unrest	y	t	\N
b5067ff7f533848af0c9d1f3e6c5b204	Authorist	n	t	\N
553adf4c48f103e61a3ee7a94e7ea17b	Axit	y	t	\N
134a3bbedd12bc313d57aa4cc781ddf9	Violent Vortex	n	t	\N
576fea4a0c5425ba382fff5f593a33f1	Sepultura	y	f	\N
852c0b6d5b315c823cdf0382ca78e47f	Crisix	y	f	\N
ab9ca8ecf42a92840c674cde665fbdd3	Sunczar	y	t	\N
d4192d77ea0e14c40efe4dc9f08fdfb8	Denomination	y	t	\N
5fac4291bc9c25864604c4a6be9e0b4a	New World Depression	y	t	\N
ecd06281e276d8cc9a8b1b26d8c93f08	Chelsea Grin	y	t	\N
bf6cf2159f795fc867355ee94bca0dd5	Despised Icon	y	t	\N
3b0713ede16f6289afd699359dff90d4	Vitriol	y	t	\N
46148baa7f5229428d9b0950be68e6d7	Sworn Allegiance	y	t	\N
a909b944804141354049983d9c6cc236	Mariner	y	t	\N
16e54a9ce3fcedbadd0cdc18832266fd	Wolfbird Twins	y	t	\N
032d53a86540806303b4c81586308e58	Wotolom	y	f	\N
b08bdd1d40a38ab9848ff817294332ca	Texas Cornflake Massacre	m	t	\N
b06edc3ce52eb05a5a45ae58a7bb7adc	Häxenzijrkell	y	t	\N
9a83f3f2774bee96b8f2c8595fc174d7	Helleruin	y	t	\N
4124cc9a170709b345d3f68fd563ac33	Deathless Void	y	t	\N
a1e60d2ccea21edbaf84a12181d1e966	Morgarten	y	t	\N
94edec5dc10d059f05d513ce4a001c22	Opus Irae	y	t	\N
d1b8bfadad3a69dbd746217a500a4db5	Battle Tales	y	t	\N
28a6ebe1e170483c1695fca36880db98	Mystaken	y	t	\N
ce34dc9b3e210fd7a61d94df77bd8398	Evgeniy-Projekt	y	t	\N
57006f73c326669c8d52c47a3a9e2696	Greñas	m	t	\N
cdd21eba97ee010129f5d1e7a80494cb	Shadow of Intent	y	t	\N
57126705faf40e4b5227c8a0302d13b2	Cattle Decapitation	n	t	\N
ec29a7f3c6a4588ef5067ea12a19e4e1	Graceless	y	t	\N
23dad719c8a972b4f19a65c79a8550fe	Anasarca	y	t	\N
dac6032bdce48b416fa3cd1d93dc83b8	Dead Chasm	y	t	\N
73cff3ab45ec02453b639abccb5bd730	Terrible Sickness	y	t	\N
442ea4b6f50b4ae7dfde9350b3b6f664	Chasing Fear	y	t	\N
af8b7f5474d507a8e583c66ef1eed5a5	Unrast	y	t	\N
bf250243f776c4cc4a9c4a1f81f7e42f	Malnourished	y	t	\N
bc30e7b15744d2140e28e5b335605de5	Impaler	y	t	\N
8b174e2c4b00b9e0699967e812e97397	Dementia	y	t	\N
a68fbbd4507539f9f2579ad2e7f94902	Sharpened.lives	n	t	\N
2e572c8c809cfbabbe270b6ce7ce88dd	Failed Star	m	t	\N
bfaffe308a2e8368acb49b51814f2bfe	Crossbreaker	y	t	\N
6261b9de274cf2da37125d96ad21f1df	Gefrierbrand	y	t	\N
2918f3b4f699f80bcafb2607065451e1	Urne	y	t	\N
804d27f4798081681e71b2381697e58c	Kvelertak	n	t	\N
b760518e994aa7db99d91f1b6aa52679	Mein Kopf ist ein brutaler Ort	y	t	\N
0fe3db5cf9cff35143d6610797f91f7c	Human Entropy	y	t	\N
2304c368fd55bc45cb12f1589197e80d	XIV Dark Centuries	y	t	\N
6c3eceee73efa7af0d2f9f62daf63456	Kryss	y	t	\N
6a2367b68131111c0a9a53cd70c2efed	The Crown	y	t	\N
f2727091b6fe5656e68aa63d936c5dfd	AngelMaker	y	t	\N
ec41b630150c89b30041d46b03f1da42	Slaughterday	y	t	\N
cb3a240c27ebf12e17f9efe44fa4a7a8	Fuming Mouth	y	t	\N
cfe9861e2a347cc7b50506ea46fdaf4f	Greh	y	t	\N
926811886f475151c52dd365c90a7efc	Traitor	y	t	\N
e27728342f660d53bd12ab14e5005903	Disstorture	y	t	\N
afe4451c0c33641e67241bfe39f339ff	High Striker	m	t	\N
3e6141409efd871b4a87deacfbf31c28	Wilt	y	t	\N
e84900ed85812327945c9e72f173f8cc	Apallic Decay	y	t	\N
c3ce3cf87341cea762a1fb5d26d7d361	Gomorrha	y	t	\N
11ac50031c60fb29e5e1ee475be05412	Mercyless	y	t	\N
bd9b8bf7d35d3bd278b5c300bc011d86	Rotting Christ	y	t	\N
d39aa6fda7dc81d19cd21adbf8bd3479	Satyricon	y	t	\N
\.


--
-- Data for Name: bands_countries; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands_countries (id_band, id_country) FROM stdin;
58bbd6135961e3d837bacceb3338f082	FIN
5e13fedbc93d74e8d42eadee1def2ae6	DEU
0bc231190faa69e7545dfa084f2bed56	USA
f7a13e18c9c1e371b748facfef98a9a5	DEU
7359d3b2ff69eb4127c60756cc77faa9	NLD
e389ffc844004b963c3b832faeea873d	FRA
31b9bbcd5d3cb8e18af8f6ea59aea836	BEL
fe4398ac7504e937c2ff97039aa66311	FIN
fb8b0c4fbbd2bc0ab10fcf67a9f1d1ff	SWE
f986b00063e79f7c061f40e6cfbbd039	GBR
cbefc03cdd1940f37a7033620f8ff69f	GBR
2eb42b9c31ac030455e5a4a79bccf603	GBR
08f8c67c20c4ba43e8ba6fa771039c94	DEU
b4c5b422ab8969880d9f0f0e9124f0d7	DEU
01a9f3fdd96daef6bc85160bd21d35dc	DEU
2187711aeaa2944a707c9eabaa2df72a	DEU
6a4e8bab29666632262eb20c336e85e2	DEU
53199d92b173437f0207a916e8bcc23a	CUB
53a5da370321dac39033a5fe6af13e77	DEU
b0cc1a3a1aee13a213ee73e3d4a2ce70	FRA
c2ab38206dce633f15d66048ad744f03	DEU
630500eabc48c986552cb01798a31746	DEU
e5ea2ac2170d4f9c2bdbd74ab46523f7	NLD
ceffa7550e5d24a8c808d3516b5d6432	DEU
81200f74b5d831e3e206a66fe4158370	DEU
5e6ff2b64b4c0163ab83ab371abe910b	DEU
262a49b104426ba0d1559f8785931b9d	DEU
0add3cab2a932f085109a462423c3250	DEU
20a75b90511c108e3512189ccb72b0ac	GBR
7d6ede8454373d4ca5565436cbfeb5c0	DEU
aa98c9e445775e7c945661e91cf7e7aa	DEU
4e9b4bdef9478154fc3ac7f5ebfb6418	USA
198445c0bbe110ff65ac5ef88f026aff	DEU
abc73489d8f0d1586a2568211bdeb32f	DEU
458da4fc3da734a6853e26af3944bf75	ITA
26ad58455460d75558a595528825b672	DEU
8e1cfd3bf5a7f326107f82f8f28649be	DEU
c08567e9006dc768bdb72bb7b14e53a1	DEU
b99927de4e0ed554b381b920c01e0481	USA
6caa2c6d69ebdc30a3c4580979c3e630	NLD
ca7f6314915171b302f62946dcd9a369	USA
2e3163bc98304958ccafbb2810210714	TUR
5da7161758c4b9241330afb2e1503bbc	ITA
d0a0817c2cd33b0734f70fcf3240eb41	USA
0f9fb8452cc5754f83e084693d406721	SWE
0959583c7f421c0bb8adb20e8faeeea1	FIN
2f623623ce7eeb08c30868be121b268a	SWE
b66781a52770d78b260f15d125d1380b	SWE
739260d8cb379c357340977fe962d37a	SWE
8765cfbf81024c3bd45924fee9159982	NOR
28bc0abd0cf390a4472b1f60bd0cfe4a	FIN
298a577c621a7a1c365465f694e0bd13	SWE
fecc75d978ad94aaa4e17b3ff9ded487	FIN
333ca835f34af241fe46af8e7a037e17	NOR
be2c012d60e32fbf456cd8184a51973d	NOR
a0cdbd2af8f1ddbb2748a2eaddce55da	SWE
3b6d90f85e8dadcb3c02922e730e4a9d	SWE
3a7e46261a591b3e65d1e7d0b2439b20	NOR
9a6c0d8ea613c5b002ff958275318b08	FIN
3577f7160794aa4ba4d79d0381aefdb1	POL
02677b661c84417492e1c1cb0b0563b2	SWE
9d1ecaf46d6433f9dd224111440cfa3b	NOR
92ad5e8d66bac570a0611f2f1b3e43cc	NOR
90669320cd8e4a09bf655310bffdb9ba	DEU
20de83abafcb071d854ca5fd57dec0e8	HUN
2e6df049342acfb3012ac702ed93feb4	DEU
d86431a5bbb40ae41cad636c2ddbf746	DEU
85ed977a5fcd1ce0c970827078fdb7dd	CHL
1bebc288d8fce192365168e890c956c8	DEU
4ccc28be05a98375d9496dc2eba7006a	001
ccc9b8a517c7065d907e283040e6bc91	DNK
1ae6e4c42571b2d7275b5922ce3d5f39	ESP
f6f1f5df964a4620e88527d4e4ff84fc	DEU
370cde851ed429f1269f243dd714cce2	GRC
786d3481362b8dee6370dfb9b6df38a2	ITA
dab701a389943f0d407c6e583abef934	PRT
8ac49bad86eacffcea299416cd92c3b7	ESP
50737756bd539f702d8e6e75cf388a31	ESP
d2d67d63c28a15822569c5033f26b133	AUT
afb6e0f1e02be39880596a490c900775	GRC
9ff04a674682ece6ee93ca851db56387	AUT
4900e24b2d0a0c5e06cf3db8b0638800	DEU
b9ffbdbbe63789cc6fa9ee2548a1b2ed	DEU
cfe122252751e124bfae54a7323bf02d	DEU
7f3e5839689216583047809a7f6bd0ff	DEU
491801c872c67db465fda0f8f180569d	SWE
647dadd75e050b230269e43a4fe351e2	ITA
5fa07e5db79f9a1dccb28d65d6337aa6	NLD
0feeee5d5e0738c1929bf064b184409b	CZE
38734dcdff827db1dc3215e23b4e0890	DEU
3e28a735f3fc31a9c8c30b47872634bf	SWE
02fd1596536ea89e779d37ded52ac353	DEU
9d5c1f0c1b4d20a534fe35e4e699fb7b	GBR
f517a9dc937888bed2f3fbeb38648372	001
f114176afa9d9d44e8ef8ce2b586469d	FIN
14b33fbc65adcc1655f82c82d232f6e7	DEU
33b8199a303b059dfe3a3f9ace77c972	USA
f2576a80ee7893b24dd33a8af3911eac	FRA
d0932e0499b24d42233616e053d088ea	PRT
d0dc5a2eab283511301b75090afe11ab	DEU
dfb7069bfc6e0064a6c667626eca07b4	BEL
9436650a453053e775897ef5733e88fe	CHE
cf6a93131b0349f37afeb9319b802136	BEL
5629d465ed80efff6e25b8775b98c2d1	CHE
16fe483d0681e0c86177a33e22452e13	CHE
4db3435be88015c70683b4368d9b313b	LUX
bd9059497b4af2bb913a8522747af2de	CHE
25f5d73866a52be9d0e2e059955dfd56	BEL
272a23811844499845c6e33712c8ba6c	USA
8cd1cca18fb995d268006113a3d6e4bf	BLR
2b068ea64f42b2ccd841bb3127ab20af	DEU
979b5de4a280c434213dd8559cf51bc0	DEU
45d592ef3a8dc14dccc087e734582e82	DEU
71a520b6d0673d926d02651b269cf92c	DEU
22aaaebe901de8370917dcc53f53dbf6	DEU
6e064a31dc53ab956403ec3654c81f1f	DEU
dddfdb5f2d7991d93f0f97dce1ef0f45	DEU
56b07537df0c44402f5f87a8dcb8402c	SWE
e6793169497d66ac959a7beb35d6d497	NLD
0ab01e57304a70cf4f7f037bd8afbe49	FRA
fb3a67e400fde856689076418034cdf2	DEU
db572afa3dcc982995b5528acb350299	SWE
2a67e4bd1ef39d36123c84cad0b3f974	JPN
b9a0ad15427ab09cfd7b85dadf2c4487	DEU
513fc59781f0030dc6e7a7528a45b35b	USA
20db933d4ddd11d5eff99a441e081550	CHN
6e2f236ffef50c45058f6127b30ecece	DEU
3f7e7508d7af00ea2447bfffbbac2178	DEU
71144850f4fb4cc55fc0ee6935badddf	SWE
eed35187b83d0f2e0042cf221905163c	NLD
b615ea28d44d2e863a911ed76386b52a	NLD
bda66e37bf0bfbca66f8c78c5c8032b8	DEU
2799b4abf06a5ec5e262d81949e2d18c	DEU
a20050efc491a9784b5cced21116ba68	DEU
05fcf330d8fafb0a1f17ce30ff60b924	SWE
386a023bd38fab85cb531824bfe9a879	SWE
abe78132c8e446430297d08bd1ecdab0	FIN
7b3ab6743cf8f7ea8491211e3336e41d	ESP
bd4ca3a838ce3972af46b6e2d85985f2	DEU
6caa47f7b3472053b152f84ce72c182c	USA
a05a13286752cb6fc14f39f51cedd9ce	AUS
781c745a0d6b02cdecadf2e44d445d1a	DEU
71ac59780209b4c074690c44a3bba3b7	DEU
82f43cc1bda0b09efff9b356af97c7ab	DEU
d908b6b9019639bced6d1e31463eea85	DEU
1437c187d64f0ac45b6b077a989d5648	GBR
4be3e31b7598745d0e96c098bbf7a1d7	USA
d1e0bdb2b2227bdd5e47850eec61f9ea	USA
123131d2d4bd15a0db8f07090a383157	DEU
78bbff6bf39602a577c9d8a117116330	USA
2054decb2290dbaab1c813fd86cc5f8b	ITA
6adc39f4242fd1ca59f184e033514209	DEU
281eb11c857bbe8b6ad06dc1458e2751	UKR
dfa61d19b62369a37743b38215836df9	GBR
efe9ed664a375d10f96359977213d620	DEU
30a100fe6a043e64ed36abb039bc9130	DEU
c5f4e658dfe7b7af3376f06d7cd18a2a	ITA
dcab0d84960cda81718e38ee47688a75	DEU
3aa1c6d08d286053722d17291dc3f116	PRT
818ce28daba77cbd2c4235548400ffb2	DEU
6d25c7ad58121b3effe2c464b851c27a	AUS
8791e43a8287ccbc21f61be21e90ce43	AUT
5c59b6aa317b306a1312a67fe69bf512	GRC
cd004b87e2adfb72b28752a6ef6cd639	DEU
1b62f034014b1d242c84c6fe7e6470f0	SWE
b02ba5a5e65487122c2c1c67351c3ea0	DEU
ea3b6b67824411a4cfaa5c8789282f48	DEU
f2a863a08c3e22cc942264ac4bc606e3	SWE
eb39fa9323a6b3cbc8533cd3dadb9f76	DEU
768207c883fd6447d67f3d5bc09211bd	USA
61725742f52de502605eadeac19b837b	DEU
2fb81ca1d0a935be4cb49028268baa3f	DEU
3705bfe1d1b3b5630618b164716ae700	DEU
801c01707f48bfa8875d4a2ac613920d	BLR
d42e907e9c61d30d23ce9728d97aa862	CRI
3757709518b67fddd9ae5a368d219334	USA
a7eb281bcaab3446ece1381b190d34e0	ISL
14bbaec7f5e0eba98d90cd8353c2e79f	USA
1175d5b2a935b9f4daf6b39e5e74138c	DEU
4190210961bce8bf2ac072c878ee7902	AUS
2f090f093a2868dccca81a791bc4941f	AUS
8981b4a0834d2d59e1d0dceb6022caae	AUT
a7e071b3de48cec1dd24de6cbe6c7bf1	USA
f3ac75dfbf1ce980d70dc3dea1bf4636	DNK
de1e0ed5433f5e95c8f48e18e1c75ff6	DNK
e20976feda6d915a74c751cbf488a241	DEU
b3d0eb96687420dc4e5b10602ac42690	GBR
e4f13074d445d798488cb00fa0c5fbd4	DEU
5dd5b236a364c53feb6db53d1a6a5ab9	DEU
486bf23406dec9844b97f966f4636c9b	SWE
1fd7fc9c73539bee88e1ec137b5f9ad2	GBR
ef3c0bf190876fd31d5132848e99df61	FRA
2569a68a03a04a2cd73197d2cc546ff2	AUT
05c87189f6c230c90bb1693567233100	DEU
77bfe8d21f1ecc592062f91c9253d8ab	NOR
018b60f1dc74563ca02f0a14ee272e4d	DEU
40fcfb323cd116cf8199485c35012098	FRA
d68956b2b5557e8f1be27a4632045c1e	USA
ba9bfb4d7c1652a200d1d432f83c5fd1	SWE
4dde2c290e3ee11bd3bd1ecd27d7039a	UKR
34fd3085dc67c39bf1692938cf3dbdd9	NLD
fcf66a6d6cfbcb1d4a101213b8500445	DEU
d5ec808c760249f11fbcde2bf4977cc6	DEU
5637bae1665ae86050cb41fb1cdcc3ee	CAN
2d1ba9aa05ea4d94a0acb6b8dde29d6b	AUS
cd80c766840b7011fbf48355c0142431	CHE
7b675f4c76aed34cf2d5943d83198142	AUS
93025091752efa184fd034f285573afe	CHE
aaaad3022279d4afdb86ad02d5bde96b	FRA
ce8e1e23e9672f5bf43894879f89c17a	DEU
50bac8fb5d0c55efd23de4c216e440f1	BRA
e8ead85c87ecdab1738db48a10cae6da	DEU
7e0e2fabeced85b4b8bbbca59858d33d	BRA
eef1b009f602bb255fa81c0a7721373d	NLD
49d387abd142d76f4b38136257f56201	DEU
0cd2b45507cc7c4ead2aaa71c59af730	DEU
34ef35a77324b889aab18380ad34b51a	FIN
869bb972f8bef83979774fa123c56a4e	NLD
472e67129f0c7add77c7c907dac3351f	BEL
23f5e1973b5a048ffaaa0bd0183b5f87	DEU
08b84204877dce2a08abce50d9aeceed	DEU
309263122a445662099a3dabce2a4f17	NLD
c833c98be699cd7828a5106a37d12c2e	DEU
40a259aebdbb405d2dc1d25b05f04989	DEU
563fcbf5f44e03e0eeb9c8d6e4c8e127	FRA
f1022ae1bc6b46d51889e0bb5ea8b64f	FIN
ed783268eca01bff52c0f135643a9ef7	DEU
f49f851c639e639b295b45f0e00c4b4c	DEU
9b55ad92062221ec1bc80f950f667a6b	DEU
f6708813faedbf607111d83fdce91828	USA
f3b8f1a2417bdc483f4e2306ac6004b2	SWE
bf2c8729bf5c149067d8e978ea3dcd32	DEU
72b73895941b319645450521aad394e8	SWE
436f76ddf806e8c3cbdc9494867d0f79	DEU
4e7054dff89623f323332052d0c7ff6e	NOR
5cc06303f490f3c34a464dfdc1bfb120	DEU
cbf6de82cf77ca17d17d293d6d29a2b2	DEU
3c2234a7ce973bc1700e0c743d6a819c	USA
7cbd455ff5af40e28a1eb97849f00723	USA
3d4fe2107d6302760654b4217cf32f17	MEX
d0dae91314459033160dc47a79aa165e	DEU
5878f5f2b1ca134da32312175d640134	DEU
4669569c9a870431c4896de37675a784	GBR
9d36a42a36b62b3f665c7fa07f07563b	JAM
e21ad7a2093c42e374fee6ec3b31efd3	DNK
fdcfaa5f48035ad96752731731ae941a	UKR
b531de2f903d979f6a002d5a94b136aa	DEU
54ca3eeff0994926cb7944cca0797474	DNK
841981e178ed25ef0f86f34ce0fb2904	AUT
40eefb87bb24ed4efc3fc5eeeb7e5003	GBR
cd0bc2c8738b2fef2d78d197223b17d5	DEU
2c5705766131b389fa1d88088f1bb8a8	DEU
3e98ecfa6a4c765c5522f897a4a8de23	USA
db472eaf615920784c2b83fc90e8dcc5	USA
6772cdb774a6ce03a928d187def5453f	USA
f655d84d670525246ee7d57995f71c10	DNK
cb80a6a84ec46f085ea6b2ff30a88d80	MEX
6a13b854e05f5ba6d2a0d873546fc32d	DEU
24af2861df3c72c8f1b947333bd215fc	DEU
7bc374006774a2eda5288fea8f1872e3	DEU
846a0115f0214c93a5a126f0f9697228	PRT
0964b5218635a1c51ff24543ee242514	DEU
c52d5020aad50e03d48581ffb34cd1c3	DEU
dcdcd2f22b1d5f85fa5dd68fa89e3756	DEU
c82b23ed65bb8e8229c54e9e94ba1479	DEU
0182742917720e1b2cf59ff671738253	USA
91abd5e520ec0a40ce4360bfd7c5d573	DEU
e6624ef1aeab84f521056a142b5b2d12	GBR
3ddbf46000c2fbd44759f3b4672b64db	BEL
38b2886223461f15d65ff861921932b5	DEU
dfca36a68db327258a2b0d5e3abe86af	DEU
07d82d98170ab334bc66554bafa673cf	BRA
42f6dd3a6e21d6df71db509662d19ca4	SWE
118c9af69a42383387e8ce6ab22867d7	USA
07f467f03da5f904144b0ad3bc00a26d	DEU
e29470b6da77fb63e9b381fa58022c84	DEU
0a3a1f7ca8d6cf9b2313f69db9e97eb8	DEU
3fae5bf538a263e96ff12986bf06b13f	FRA
34a9067cace79f5ea8a6e137b7a1a5c8	DEU
a9ef9373c9051dc4a3e2f2118537bb2d	DEU
009f51181eb8c6bb5bb792af9a2fdd07	FIN
e63a014f1310b8c7cbe5e2b0fd66f638	CHE
55b6aa6562faa9381e43ea82a4991079	SWE
1dc7d7d977193974deaa993eb373e714	DEU
5ab944fac5f6a0d98dc248a879ec70ff	DEU
0a0f6b88354de7afe84b8a07dfadcc26	USA
240e556541427d81f4ed1eda86f33ad3	NOR
d162c87d4d4b2a8f6dda58d4fba5987f	USA
21077194453dcf49c2105fda6bb89c79	GBR
5bd15db3f3bb125cf3222745f4fe383f	GBR
1e71013b49bbd3b2aaa276623203453f	DEU
2e4e6a5f485b2c7e22f9974633c2b900	DEU
541fa0085b17ef712791151ca285f1a7	DEU
f2ba1f213e72388912791eb68adc3401	FRA
210e99a095e594f2547e1bb8a9ac6fa7	RUS
6cec93398cd662d79163b10a7b921a1b	DEU
6ca47c71d99f608d4773b95f9b859142	USA
024e91d84c3426913db8367f4df2ceb3	CHE
773b5037f85efc8cc0ff3fe0bddf2eb8	ROU
46ea4c445a9ff8e288258e3ec9cd1cf0	USA
c41b9ec75e920b610e8907e066074b30	AUT
a91887f44d8d9fdcaa401d1c719630d7	DEU
4f5b2e20e9b7e5cc3f53256583033752	NLD
1f56e4b8b8a0da3b8ec5b32970e4b0d8	DEU
0d01b12a6783b4e60d2e09e16431f00a	DEU
9c81c8c060b39e7437b2d913f036776b	DEU
0ab7d3a541204a9cab0d2d569c5b173f	DEU
76aebba2f63483b6184f06f0a2602643	BRA
96406d44fcf110be6a4b63fa6d26de3b	DEU
efb83e3ae12d8d95a5d01b6d762baa98	BEL
d7a97c2ff91f7aa07fa9e2f8265ceab6	FRA
9d919b88be43eb3a9056a54e57894f84	GBR
ef297890615f388057b6a2c0a2cbc7ab	USA
b7f0e9013f8bfb209f4f6b2258b6c9c8	USA
c827a8c6d72ff66b08f9e2ab64e21c01	USA
a985c9764e0e6d738ff20f2328a0644b	USA
573f13e31f1be6dea396ad9b08701c47	USA
748ac622dcfda98f59c3c99593226a75	USA
f00bbb7747929fafa9d1afd071dba78e	USA
9a8d3efa0c3389083df65f4383b155fb	USA
ac8eab98e370e2a8711bad327f5f7c55	USA
717ec52870493e8460d6aeddd9b7def8	USA
71f4e9782d5f2a5381f5cdf7c5a35d89	USA
05ee6afed8d828d4e7ed35b0483527f7	USA
9639834b69063b336bb744a537f80772	USA
fcc491ba532309d8942df543beaec67e	DEU
662d17c67dcabc738b8620d3076f7e46	USA
c349bc9795ba303aa49e44f64301290e	DEU
aa5808895fd2fca01d080618f08dca51	DEU
66597873e0974fb365454a5087291094	NLD
6ffa656be5ff3db085578f54a05d4ddb	DEU
891b302f7508f0772a8fdb71ccbf9868	BLR
dddbd203ace7db250884ded880ea7be4	DEU
a7eda23a9421a074fe5ec966810018d7	DEU
ddae1d7419331078626bc217b23ea8c7	DEU
c82a107cd7673a4368b7252aa57810fc	USA
1cc93e4af82b1b7e08bace9a92d1f762	DEU
fb80cd69a40a73fb3b9f22cf58fd4776	SRB
6d779916de27702814e4874dcf4f9e3a	USA
63a9f0ea7bb98050796b649e85481845	CZE
7d3618373e07c4ce8896006919bbb531	DEU
460bf623f241651a7527a63d32569dc0	GBR
ef75c0b43ae9ba972900e83c5ccf5cac	FIN
182a1e726ac1c8ae851194cea6df0393	BEL
0d8ef82742e1d5de19b5feb5ecb3aed3	GBR
90802bdf218986ffc70f8a086e1df172	DEU
d1ba47339d5eb2254dd3f2cc9f7e444f	DEU
7cb94a8039f617f505df305a1dc2cc61	AUT
a9afdc809b94392fb1c2e873dbb02781	DEU
576fea4a0c5425ba382fff5f593a33f1	BRA
55696bac6cdd14d47cbe7940665e21d3	PRT
34e927c45cf3ccebb09b006b00f4e02d	USA
f8b3eaefc682f8476cc28caf71cb2c73	DEU
3c6444d9a22c3287b8c483117188b3f4	DEU
35bde21520f1490f0333133a9ae5b4fc	DEU
4a9cd04fd04ab718420ee464645ccb8b	DEU
824f75181a2bbd69fb2698377ea8a952	DEU
d92ee81a401d93bb2a7eba395e181c04	DEU
ad759a3d4f679008ffdfb07cdbda2bb0	DEU
3480c10b83b05850ec18b6372e235139	DEU
c5d3d165539ddf2020f82c17a61f783d	DEU
b1d18f9e5399464bbe5dea0cca8fe064	DEU
7c7e63c9501a790a3134392e39c3012e	DEU
e3e9ccd75f789b9689913b30cb528be0	DEU
d02f33b44582e346050cefadce93eb95	DEU
707270d99f92250a07347773736df5cc	DEU
ee36fdf153967a0b99d3340aadeb4720	DEU
13291409351c97f8c187790ece4f5a97	DEU
647a73dd79f06cdf74e1fa7524700161	DEU
d9c849266ee3ac1463262df200b3aab8	DEU
8b22cf31089892b4c57361d261bd63f7	DEU
ab1d9c0bfcc2843b8ea371f48ed884bb	DEU
ea3f5f97f06167f4819498b4dd56508e	GBR
a99dca5593185c498b63a5eed917bd4f	GBR
a6c27c0fb9ef87788c1345041e840f95	DEU
f79485ffe5db7e276e1e625b0be0dbec	FRA
eb4558fa99c7f8d548cbcb32a14d469c	ITA
d76db99cdd16bd0e53d5e07bcf6225c8	RUS
4c576d921b99dad80e4bcf9b068c2377	USA
13c8bd3a0d92bd186fc5162eded4431d	USA
50026a2dff40e4194e184b756a7ed319	DEU
92edfbaa71b7361a3081991627b0e583	USA
062c44f03dce5bf39f81d0bf953926fc	DEU
79cbf009784a729575e50a3ef4a3b1cc	CAN
6f60a61fcc05cb4d42c81ade04392cfc	DEU
073f87af06b8d8bc561bb3f74e5f714f	LUX
f34c903e17cfeea18e499d4627eeb3ec	USA
03fec47975e0e1e2d0bc723af47281de	DEU
118b96dde2f8773b011dfb27e51b2f95	DEU
7df470ec0292985d8f0e37aa6c2b38d5	SWE
75241d56d63a68adcd51d828eb76ca80	ISL
381b834c6bf7b25b9b627c9eeb81dd8a	NLD
cabcfb35912d17067131f7d2634ac270	USA
60a105e79a86c8197cec9f973576874b	CZE
e6cbb2e0653a61e35d26df2bcb6bc4c7	FIN
e039d55ed63a723001867bc4eb842c00	DEU
010fb41a1a7714387391d5ea1ecdfaf7	DEU
3123e3df482127074cdd5f830072c898	DEU
849c829d658baaeff512d766b0db3cce	DEU
3b8d2a5ff1b16509377ce52a92255ffe	USA
2460cdf9598c810ac857d6ee9a84935a	DEU
50d48c9002eb08e248225c1d91732bbc	DEU
8cb8e8679062b574afcb78a983b75a9f	SWE
0aff394c56096d998916d2673d7ea0b6	MYS
974cd6e62ff1a4101db277d936b41058	DNK
cdd65383f4d356e459018c3b295d678b	DNK
99557f46ccef290d9d93c546f64fb7d6	DEU
454cce609b348a95fb627e5c02dddd1b	GRC
246e0913685e96004354b87cbab4ea78	HUN
4e9a84da92180e801263860bfbea79d6	SWE
5e8df9b073e86a3272282977d2c9dc85	ITA
44a468f083ac27ea7b6847fdaf515207	DEU
33f03dd57f667d41ac77c6baec352a81	DEU
a8fcba36c9e48e9e17ba381a34444dd0	CHE
8717871a38810cc883cce02ea54a7017	NOR
4a0ea81570ab9440e8899b9f5fb3a61a	DEU
c38529decc4815a9932f940af2a16d37	BEL
f0ae03df4fd08abd1f844fea2f4bbfb0	DEU
3f460e130f37e8974fbcdc4d0056b468	AUT
7bc230f440d5d70d2c573341342d9c81	FIN
6a826993d87c8fc0014c43edd8622b6c	DEU
d7e0c43c16a9f8385b49d23cd1178598	LTU
c61b8639de558fcc2ee0b1d11e120df9	SWE
14aedd89f13973e35f9ba63149a07768	DEU
359dda2e361814c0c8b7b358e654691d	USA
749b17536e08489cb3b2437715e89001	NLD
65f24dbd08671d51fda7de723afc41d9	DEU
01bcfac216d2a08cd25930234e59f1a1	GRC
c63b6261b8bb8145bc0fd094b9732c24	USA
5ef02a06b43b002e3bc195b3613b7022	DEU
5934340f46d5ab773394d7a8ac9e86d5	DEU
1c4af233da7b64071abf94d79c41a361	DEU
b36eb6a54154f7301f004e1e61c87ce8	CUB
bbbb086d59122dbb940740d6bac65976	USA
26c2bb18f3a9a0c6d1392dae296cfea7	DEU
6af2c726b2d705f08d05a7ee9509916e	NLD
3a232003be172b49eb64e4d3e9af1434	USA
e3c8afbeb0ec4736db977d18e7e37020	USA
f32badb09f6aacb398d3cd690d90a668	USA
99761fad57f035550a1ca48e47f35157	DEU
87bd9baf0b0d760d1f0ca9a8e9526161	DEU
f975b4517b002a52839c42e86b34dc96	DEU
5b5fc236828ee2239072fd8826553b0a	DEU
218ac7d899a995dc53cabe52da9ed678	DEU
364be07c2428493479a07dbefdacc11f	PRT
56bf60ca682b8f68e8843ad8a55c6b17	AUT
8ee257802fc6a4d44679ddee10bf24a9	DEU
94a62730604a985647986b509818efee	DEU
09c00610ca567a64c82da81cc92cb846	ISL
bc834c26e0c9279cd3139746ab2881f1	CHL
64a25557d4bf0102cd8f60206c460595	DEU
445a222489d55b5768ec2f17b1c3ea34	DEU
fd0a7850818a9a642a125b588d83e537	COL
93aa5f758ad31ae4b8ac40044ba6c110	DEU
99bdf8d95da8972f6979bead2f2e2090	FIN
123f90461d74091a96637955d14a1401	USA
60eb61670a5385e3150cd87f915b0967	DEU
b454fdfc910ad8f6b7509072cf0b4031	SWE
06c5c89047bfd6012e6fb3c2bd3cb24b	USA
156c19a6d9137e04b94500642d1cb8c2	DEU
827bf758c7ce2ac0f857379e9e933f77	DEU
e2afc3f96b4a23d451c171c5fc852d0f	ISL
cd3296ec8f7773892de22dfade4f1b04	DEU
05bea3ed3fcd45441c9c6af3a2d9952d	DEU
5f07809ecfce3af23ed5550c6adf0d78	SWE
baceebebc179d3cdb726f5cbfaa81dfe	DEU
2db1850a4fe292bd2706ffd78dbe44b9	POL
a30c1309e683fcf26c104b49227d2220	DEU
246d570b4e453d4cb6e370070c902755	USA
dd0e61ab23e212d958112dd06ad0bfd2	DEU
5a534330e31944ed43cb6d35f4ad23c7	DEU
96aa953534221db484e6ec75b64fcc4d	GBR
75fea12b82439420d1f400a4fcf3386b	DEU
951af0076709a6da6872f9cdf41c852b	SWE
5c19e1e0521f7b789a37a21c5cd5737b	NLD
863e7a3d6d4a74739bca7dd81db5d51f	USA
ce14eb923a380597f2aff8b65a742048	USA
a7111b594249d6a038281deb74ef0d04	DEU
02670bc3f496ce7b1393712f58033f6c	150
70492d5f3af58ace303d1c5dfc210088	BEL
26211992c1edc0ab3a6b6506cac8bb52	USA
384e94f762d3a408cd913c14b19ac5e0	DEU
3b544a6f1963395bd3ae0aeebdf1edd8	FIN
511ac85b55c0c400422462064d6c77ed	USA
f9ff0bcbb45bdf8a67395fa0ab3737b5	DEU
39ce458f2caa87bc7b759cd8cb16e62f	DEU
00a0d9697a08c1e5d4ba28d95da73292	SVN
d8d3a01ba7e5d44394b6f0a8533f4647	DEU
a2a607567311cb7a5a609146b977f4a9	FIN
913df019fed1f80dc49b38f02d8bae41	DEU
3cd94848f6ccb600295135e86f1b46a7	CHE
b00114f9fc38b48cc42a4972d7e07df6	USA
a2761eea97ee9fe09464d5e70da6dd06	DEU
9d514e6b301cfe7bdc270212d5565eaf	USA
852c0b6d5b315c823cdf0382ca78e47f	ESP
a2c31c455e3d0ea3f3bdbea294fe186b	DEU
ffd2da11d45ed35a039951a8b462e7fb	DEU
16c88f2a44ab7ecdccef28154f3a0109	FRA
191bab5800bd381ecf16485f91e85bc3	DEU
876eed60be80010455ff50a62ccf1256	DEU
f4e4ef312f9006d0ae6ca30c8a6a32ff	DEU
c311f3f7c84d1524104b369499bd582f	DEU
1629fa6d4b8adb36b0e4a245b234b826	001
270fb708bd03433e554e0d7345630c8e	BRA
9d1e68b7debd0c8dc86d5d6500884ab4	DEU
8987e9c300bc2fc5e5cf795616275539	DEU
ba5e6ab17c7e5769b11f98bfe8b692d0	SWE
eb0a191797624dd3a48fa681d3061212	CZE
13de0a41f18c0d71f5f6efff6080440f	NLD
5885f60f8c705921cf7411507b8cadc0	NLD
f31ba1d770aac9bc0dcee3fc15c60a46	DEU
0ae3b7f3ca9e9ddca932de0f0df00f8a	FRA
0e609404e53b251f786b41b7be93cc19	POL
b1006928600959429230393369fe43b6	AUT
478aedea838b8b4a0936b129a4c6e853	USA
f2856ad30734c5f838185cc08f71b1e4	DNK
410044b393ebe6a519fde1bdb26d95e8	DEU
abca417a801cd10e57e54a3cb6c7444b	DEU
867872f29491a6473dae8075c740993e	AUT
c937fc1b6be0464ec9d17389913871e4	DEU
e9648f919ee5adda834287bbdf6210fd	DEU
1f86700588aed0390dd27c383b7fc963	DEU
faec47e96bfb066b7c4b8c502dc3f649	DEU
16cf4474c5334c1d9194d003c9fb75c1	FRA
8e38937886f365bb96aa1c189c63c5ea	NLD
8ed55fda3382add32869157c5b41ed47	BEL
4e9dfdbd352f73b74e5e51b12b20923e	GBR
88059eaa73469bb47bd41c5c3cdd1b50	SWE
56e8538c55d35a1c23286442b4bccd26	FIN
375974f4fad5caae6175c121e38174d0	DEU
f4b526ea92d3389d318a36e51480b4c8	DEU
3929665297ca814b966cb254980262cb	DEU
fbc2b3cebe54dd00b53967c5cf4b9192	DEU
644f6462ec9801cdc932e5c8698ee7f9	DEU
dbf1b3eb1f030affb41473a8fa69bc0c	DEU
ca3fecb0d12232d1dd99d0b0d83c39ec	AUT
b3626b52d8b98e9aebebaa91ea2a2c91	DEU
347fb42f546e982de2a1027a2544bfd0	SWE
97724184152a2620b76e2f93902ed679	DEU
4bffc4178bd669b13ba0d91ea0522899	DEU
b084dc5276d0211fae267a279e2959f0	DEU
f66935eb80766ec0c3acee20d40db157	DEU
cd1c06e4da41121b7362540fbe8cd62c	DEU
9459200394693a7140196f07e6e717fd	SWE
4e74055927fd771c2084c92ca2ae56a7	DEU
a753c3945400cd54c7ffd35fc07fe031	PHL
8af17e883671377a23e5b8262de11af4	HRV
d1fded22db9fc8872e86fff12d511207	ARG
c526681b295049215e5f1c2066639f4a	FRO
3969716fc4acd0ec0c39c8a745e9459a	AUS
b7b99e418cff42d14dbf2d63ecee12a8	PRT
96b4b857b15ae915ce3aa5e406c99cb4	CHE
8b5a84ba35fa73f74df6f2d5a788e109	IND
57f622908a4d6c381241a1293d894c88	NOR
48438b67b2ac4e5dc9df6f3723fd4ccd	CHL
56a5afe00fae48b02301860599898e63	MEX
3e8d4b3893a9ebbbd86e648c90cbbe63	IDN
c46e8abb68aae0bcdc68021a46f71a65	PAN
e4f74be13850fc65559a3ed855bf35a8	GRC
7b52c8c4a26e381408ee64ff6b98e231	ISL
278af3c810bb9de0f355ce115b5a2f54	LUX
5c61f833c2fb87caab0a48e4c51fa629	NOR
2859f0ed0630ecc1589b6868fd1dde41	PRT
c5068f914571c27e04cd66a4ec5c1631	NOR
8b3f40e0243e2307a1818d3f456df153	BRA
8b0cfde05d166f42a11a01814ef7fa86	FIN
c0118be307a26886822e1194e8ae246d	GBR
a66394e41d764b4c5646446a8ba2028b	PRT
e9e0664816c35d64f26fc1382708617b	CAN
f29f7213d1c86c493ca7b4045e5255a9	ISL
65f889eb579641f6e5f58b5a48f3ec12	USA
fc239fd89fd7c9edbf2bf27d1d894bc0	DEU
24701da4bd9d3ae0e64d263b72ad20e8	USA
031d6cc33621c51283322daf69e799f5	IRL
a8ace0f003d8249d012c27fe27b258b5	NLD
255661921f4ad57d02b1de9062eb6421	GBR
5d53b2be2fe7e27daa27b94724c3b6de	USA
57126705faf40e4b5227c8a0302d13b2	USA
cba8cb3c568de75a884eaacde9434443	BEL
19cbbb1b1e68c42f3415fb1654b2d390	ITA
f44f1e343975f5157f3faf9184bc7ade	NZL
1e986acf38de5f05edc2c42f4a49d37e	IND
10627ac0e35cfed4a0ca5b97a06b9d9f	BEL
b834eadeaf680f6ffcb13068245a1fed	USA
1ec58ca10ed8a67b1c7de3d353a2885b	CRI
8f523603c24072fb8ccb547503ee4c0f	TUR
43a4893e6200f462bb9fe406e68e71c0	CZE
9c31bcca97bb68ec33c5a3ead4786f3e	MLT
c445544f1de39b071a4fca8bb33c2772	GBR
29891bf2e4eff9763aef15dc862c373f	FRA
c8fbeead5c59de4e8f07ab39e7874213	DEU
8fa1a366d4f2e520bc9354658c4709f1	FRA
812f48abd93f276576541ec5b79d48a2	BEL
d29c61c11e6b7fb7df6d5135e5786ee1	CZE
7013a75091bf79f04f07eecc248f8ee6	DEU
58e42b779d54e174aad9a9fb79e7ebbc	ESP
51cb62b41cd9deaaa2dd98c773a09ebb	DEU
67493f858802a478bfe539c8e30a7e44	FIN
f7910d943cc815a4a0081668ac2119b2	GBR
955a5cfd6e05ed30eec7c79d2371ebcf	NLD
03201e85fc6aa56d2cb9374e84bf52ca	ITA
e7a227585002db9fee2f0ed56ee5a59f	DEU
bc111d75a59fe7191a159fd4ee927981	ESP
017e06f9b9bccafa230a81b60ea34c46	MLT
22c2fc8a3a81503d40d4e532ac0e22ab	DEU
482818d4eb4ca4c709dcce4cc2ab413d	DEU
ec788cc8478763d79a18160a99dbb618	DEU
d2f62cd276ef7cab5dcf9218d68f5bcf	LUX
e71bd61e28ae2a584cb17ed776075b55	DEU
49a41ffa9c91f7353ec37cda90966866	DEU
1c13f340d154b44e41c996ec08d76749	DEU
d5b95b21ce47502980eebfcf8d2913e0	DEU
0b6bcec891d17cd7858525799c65da27	DEU
3cb077e20dabc945228ea58813672973	DEU
8734f7ff367f59fc11ad736e63e818f9	DEU
98aa80527e97026656ec54cdd0f94dff	DEU
430a03604913a64c33f460ec6f854c36	AUT
319480a02920dc261209240eed190360	DEU
4ca1c3ed413577a259e29dfa053f99db	DEU
2eed213e6871d0e43cc061b109b1abd4	DEU
fdedcd75d695d1c0eb790a5ee3ba90b5	DEU
ed9b92eb1706415c42f88dc91284da8a	ITA
fb1afbea5c0c2e23396ef429d0e42c52	DEU
316a289ef71c950545271754abf583f1	DEU
33b3bfc86d7a57e42aa30e7d1c2517be	DEU
8351282db025fc2222fc61ec8dd1df23	DEU
60eb202340e8035af9e96707f85730e5	DEU
d2f79e6a931cd5b5acd5f3489dece82a	DEU
3189b8c5e007c634d7e28ef93be2b774	DEU
a89af36e042b5aa91d6efea0cc283c02	USA
eb2743e9025319c014c9011acf1a1679	SWE
c27297705354ef77feb349e949d2e19e	DEU
3258eb5f24b395695f56eee13b690da6	DNK
8f7939c28270f3187210641e96a98ba7	DEU
bcf744fa5f256d6c3051dd86943524f6	DEU
3ba296bfb94ad521be221cf9140f8e10	DEU
18e21eae8f909cbb44b5982b44bbf02f	GBR
3438d9050b2bf1e6dc0179818298bd41	BEL
384712ec65183407ac811fff2f4c4798	CHE
a76c5f98a56fc03100d6a7936980c563	CHE
66cc7344291ae2a297bf2aa93d886e22	NLD
34ca5622469ad1951a3c4dc5603cea0f	DEU
933c8182650ca4ae087544beff5bb52d	GBR
e3de2cf8ac892a0d8616eefc4a4f59bd	USA
623c5a1c99aceaf0b07ae233d1888e0a	NLD
c091e33f684c206b73b25417f6640b71	USA
bcc770bb6652b1b08643d98fd7167f5c	ITA
73cb08d143f893e645292dd04967f526	DEU
4a27a1ef21d32d1b30d55f092af0d5a7	DEU
eb3a9fb71b84790e50acd81cc1aa4862	MNG
13909e3013727a91ee750bfd8660d7bc	DNK
74e8b6c4be8a0f5dd843e2d1d7385a36	USA
2dde74b7ec594b9bd78da66f1c5cafdc	GBR
5324a886a2667283dbfe7f7974ff6fc0	DEU
28c5f9ffd175dcd53aa3e9da9b00dde7	DEU
b798aa74946ce75baee5806352e96272	DEU
6315887dd67ff4f91d51e956b06a3878	ITA
df99cee44099ff57acbf7932670614dd	USA
6b141e284f88f656b776148cde8e019c	USA
b84cdd396f01275b63bdaf7f61ed5a43	USA
7a43dd4c2bb9bea14a95ff3acd4dfb18	USA
c8bc4f15477ea3131abb1a3f0649fac2	USA
9133f1146bbdd783f34025bf90a8e148	USA
9d74605e4b1d19d83992a991230e89ef	DEU
ca54e4f7704e7b8374d0968143813fe6	DEU
c245b4779defd5c69ffebbfdd239dd1b	DEU
6b157916b43b09df5a22f658ccb92b64	DEU
67cd9b4b7b33511f30e85e21b2d3b204	AUT
5c29c2e513aadfe372fd0af7553b5a6c	AUS
e4b1d8cc71fd9c1fbc40fdc1a1a5d5b3	FRA
b12daab6c83b1a45aa32cd9c2bc78360	DEU
9722f54adb556b548bb9ecce61a4d167	DNK
04d53bc45dc1343f266585b52dbe09b0	DEU
0c31e51349871cfb59cfbfaaed82eb18	DEU
41dabe0c59a3233e3691f3c893eb789e	DEU
113ab4d243afc4114902d317ad41bb39	FRA
cc70416ca37c5b31e7609fcc68ca009e	ITA
7b91dc9ecdfa3ea7d347588a63537bb9	AUT
55c63b0540793d537ed29f5c41eb9c3e	DEU
43bd0d50fe7d58d8fce10c6d4232ca1e	DEU
cf38e7d92bb08c96c50ddc723b624f9d	SWE
5f449b146ce14c780eee323dfc5391e8	ITA
eef7d6da9ba6d0bed2078a5f253f4cfc	DNK
ad51cbe70d798b5aec08caf64ce66094	DEU
45e410efd11014464dd36fb707a5a9e1	ARE
8fdc3e13751b8f525f259d27f2531e87	DEU
05e76572fb3d16ca990a91681758bbee	DEU
cfc61472d8abd7c54b81924119983ed9	NLD
1fe0175f73e5b381213057da98b8f5fb	DEU
d44be0e711c2711876734b330500e5b9	CHE
c295bb30bf534e960a6acf7435f0e46a	DEU
ab3ca496cbc01a5a9ed650c4d0e26168	DEU
538eaaef4d029c255ad8416c01ab5719	DEU
1de3f08835ab9d572e79ac0fca13c5c2	DEU
4c02510c3f16e13edc27eff1ef2e452c	HRV
3c8ce0379b610d36c3723b198b982197	POL
7eeea2463ae5da9990cab53c014864fa	USA
b1c7516fef4a901df12871838f934cf6	USA
087c643d95880c5a89fc13f3246bebae	DEU
be553803806b8634990c2eb7351ed489	AUS
8bdd6b50b8ecca33e04837fde8ffe51e	DNK
18b751c8288c0fabe7b986963016884f	SWE
30b8affc1afeb50c76ad57d7eda1f08f	DEU
a8a43e21de5b4d83a6a7374112871079	DEU
9614cbc86659974da853dee20280b8c4	SRB
bc2f39d437ff13dff05f5cfda14327cc	USA
39530e3fe26ee7c557392d479cc9c93f	USA
537e5aa87fcfb168be5c953d224015ff	ITA
80d331992feb02627ae8b30687c7bb78	CZE
f6eb4364ba53708b24a4141962feb82e	DEU
2cd225725d4811d813a5ea1b701db0db	CZE
2f6fc683428eb5f8b22cc5021dc9d40d	DEU
2d5a306f74749cc6cbe9b6cd47e73162	DNK
dba84ece8f49717c47ab72acc3ed2965	SWE
559314721edf178fa138534f7a1611b9	ESP
d192d350b6eace21e325ecf9b0f1ebd1	SWE
d6a020f7b50fb4512fd3c843af752809	ITA
73f4b98d80efb8888a2b32073417e21e	USA
711a7acac82d7522230e3c7d0efc3f89	ITA
1506aeeb8c3a699b1e3c87db03156428	USA
4f58423d9f925c8e8bd73409926730e8	BRA
96390e27bc7e2980e044791420612545	USA
d2c2b83008dce38013577ef83a101a1b	SWE
c1e8b6d7a1c20870d5955bcdc04363e4	MEX
480a0efd668e568595d42ac78340fe2a	FRA
d25956f771b58b6b00f338a41ca05396	SWE
95a1f9b6006151e00b1a4cda721f469d	POL
5159ae414608a804598452b279491c5c	AUT
9bdbe50a5be5b9c92dccf2d1ef05eefd	DEU
8c4e8003f8d708dc3b6d486d74d9a585	GBR
b6eba7850fd20fa8dce81167f1a6edca	DEU
5f27f488f7c8b9e4b81f59c6d776e25c	GBR
1a5235c012c18789e81960333a76cd7a	CAN
7f950b15aa65a26e8500cfffd7f89de0	SWE
77f94851e582202f940198a26728e71f	DEU
baeb191b42ec09353b389f951d19b357	DEU
c21fe390daecee9e70b8f4b091ae316f	NLD
8aeadeeff3e1a3e1c8a6a69d9312c530	BRA
a4e0f3b7db0875f65bb3f55ab0aab7c6	SWE
37b43a655dec0e3504142003fce04a07	USA
781734c0e9c01b14adc3a78a4c262d83	USA
89b5ac8fb4c102c174adf2fed752a970	DEU
cc31970696ef00b4c6e28dba4252e45d	DEU
92e1aca33d97fa75c1e81a9db61454bb	DEU
0ba2f4073dd8eff1f91650af5dc67db4	USA
bd555d95b1ccba75afca868636b1b931	USA
a93376e58f4c73737cf5ed7d88c2169c	POL
cd3faaaf1bebf8d009aa59f887d17ef2	USA
33538745a71fe2d30689cac96737e8f7	DEU
586ac67e6180a1f16a4d3b81e33eaa94	CZE
ca1720fd6350760c43139622c4753557	CZE
645b264cb978b22bb2d2c70433723ec0	NOR
45816111a5b644493b68cfedfb1a0cc0	ISR
5bb416e14ac19276a4b450d343e4e981	DEU
d0e551d6887e0657952b3c5beb7fed74	DEU
06c1680c65972c4332be73e726de9e74	FRA
4671068076f66fb346c4f62cbfb7f9fe	ITA
10407de3db48761373a403b8ddf09782	AUT
77ac561c759a27b7d660d7cf0534a9c3	DEU
3771036a0740658b11cf5eb73d9263b3	ITA
6b37fe4703bd962004cdccda304cc18e	FIN
371d905385644b0ecb176fd73184239c	GBR
d871ebaec65bbfa0b6b97aefae5d9150	GBR
28bb3f229ca1eeb05ef939248f7709ce	GBR
861613f5a80abdf5a15ea283daa64be3	DEU
080d2dc6fa136fc49fc65eee1b556b46	USA
2df9857b999e21569c3fcce516f0f20e	USA
d5a5e9d2edeb2b2c685364461f1dfd46	DEU
1fcf2f2315b251ebe462da320491ea9f	DEU
7022f6b60d9642d91eebba98185cd9ba	DEU
4522c5141f18b2a408fc8c1b00827bc3	DEU
5ec194adf19442544d8a94f4696f17dc	GRC
31e2d1e0b364475375cb17ad76aa71f2	DEU
dff880ae9847f6fa8ed628ed4ee5741b	DEU
521c8a16cf07590faee5cf30bcfb98b6	ISR
a77c14ecd429dd5dedf3dc5ea8d44b99	MLT
b8d794c48196d514010ce2c2269b4102	DEU
a0abb504e661e34f5d269f113d39ea96	DEU
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	GBR
69a6a78ace079846a8f0d3f89beada2c	FRA
43ff5aadca6d8a60dd3da21716358c7d	FRA
95800513c555e1e95a430e312ddff817	CZE
42085fca2ddb606f4284e718074d5561	DEU
e2226498712065ccfca00ecb57b8ed2f	DEU
db732a1a9861777294f7dc54eeca2b3e	DEU
1ace9926ad3a6dab09d16602fd2fcccc	AUT
05256decaa2ee2337533d95c7de3db9d	DEU
c664656f67e963f4c0f651195f818ce0	150
032d53a86540806303b4c81586308e58	DEU
df800795b697445f2b7dc0096d75f4df	DEU
810f28b77fa6c866fbcceb6c8aa7bac4	DEU
7fcdd5f715be5fce835b68b9e63e1733	DEU
5214513d882cf478e028201a0d9031c0	DEU
0e4f0487408be5baf091b74ba765dce7	DEU
8cd7fa96a5143f7105ca92de7ff0bac7	EGY
bdbafc49aa8c3e75e9bd1e0ee24411b4	DEU
5863c78fb68ef1812a572e8f08a4e521	FIN
a822d5d4cdcb5d1b340a54798ac410b7	DEU
08e2440159e71c7020394db19541aabc	DEU
c8fd07f040a8f2dc85f5b2d3804ea3db	DEU
866208c5b4a74b32974bffb0f90311ca	DEU
fd3ab918dab082b1af1df5f9dbc0041f	CHL
cb0785d67b1ea8952fae42efd82864a7	CHL
a0d3b444bd04cd165b4e076c9fc18bee	DEU
c846d80d826291f2a6a0d7a57e540307	USA
d0b02893ceb72d11a3471fe18d7089fd	DEU
6db22194a183d7da810dcc29ea360c17	DEU
ab5428d229c61532af41ec2ca258bf30	DEU
78a7bdfe7277f187e84b52dea7b75b0b	DNK
f36fba9e93f6402ba551291e34242338	BEL
e6489b9cc39c95e53401cb601c4cae09	DEU
4622209440a0ade57b18f21ae41963d9	DEU
867e7f73257c5adf6a4696f252556431	DEU
f999abbe163f001f55134273441f35c0	DEU
9527fff55f2c38fa44281cd0e4d511ba	DEU
04c8327cc71521b265f2dc7cbe996e13	CZE
f8b01df5282702329fcd1cae8877bb5f	FIN
658a9bbd0e85d854a9e140672a46ce3a	DEU
0925467e1cc53074a440dae7ae67e3e9	USA
c18bdeb4f181c22f04555ea453111da1	DEU
4338a835aa6e3198deba95c25dd9e3de	DEU
6829c770c1de2fd9bd88fe91f1d42f56	DEU
b14521c0461b445a7ac2425e922c72df	USA
31da4ab7750e057e56224eff51bce705	NLD
6fa204dccaff0ec60f96db5fb5e69b33	NOR
2587d892c1261be043d443d06bd5b220	DEU
b9fd9676338e36e6493489ec5dc041fe	DEU
61a6502cfdff1a1668892f52c7a00669	DEU
d69462bef6601bb8d6e3ffda067399d9	DEU
04728a6272117e0dc4ec29b0f7202ad8	DEU
0ada417f5b4361074360211e63449f34	150
53c25598fe4f1f71a1c596bd4997245c	DEU
8518eafd8feec0d8c056d396122a175a	DEU
4bcbcb65040e0347a1ffb5858836c49c	DEU
0d949e45a18d81db3491a7b451e99560	DEU
5c3278fb76fa2676984396d33ba90613	DEU
dda8e0792843816587427399f34bd726	DEU
f1a37824dfc280b208e714bd80d5a294	DEU
786a755c895da064ccd4f9e8eb7e484e	DEU
f68a3eafcc0bb036ee8fde7fc91cde13	NOR
78f5c568100eb61401870fa0fa4fd7cb	USA
ab42c2d958e2571ce5403391e9910c40	DEU
b86f86db61493cc2d757a5cefc5ef425	DEU
98dd2a77f081989a185cb652662eea41	DEU
c1a08f1ea753843e2b4f5f3d2cb41b7b	BEL
807dbc2d5a3525045a4b7d882e3768ee	DEU
45d62f43d6f59291905d097790f74ade	DEU
2df0462e6f564f34f68866045b2a8a44	DEU
6ee6a213cb02554a63b1867143572e70	DEU
496a6164d8bf65daf6ebd4616c95b4b7	DEU
15ba70625527d7bb48962e6ba1a465f7	DEU
a571d94b6ed1fa1e0cfff9c04bbeb94d	ISR
e37e9fd6bde7509157f864942572c267	GRC
5e62fc773369f140db419401204200e8	DEU
9592b3ad4d7f96bc644c7d6f34c06576	USA
fd1a5654154eed3c0a0820ab54fb90a7	GBR
2045b9a6609f6d5bca3374fd370e54ff	DEU
78b532c25e4a99287940b1706359d455	DEU
fc935f341286c735b575bd50196c904b	ITA
f159fc50b5af54fecf21d5ea6ec37bad	BEL
265dbcbd2bce07dfa721ed3daaa30912	NLD
ec4f407118924fdc6af3335c8d2961d9	DEU
11a7f956c37bf0459e9c80b16cc72107	DEU
41e744bdf3114b14f5873dfb46921dc4	DEU
e37015150c8944d90e306f19eaa98de8	DEU
ed795c86ba21438108f11843f7214c95	FIN
dbc940d02a217c923c52d3989be9b391	EST
8845da022807c76120b5b6f50c218d9a	FIN
f520f53edf44d466fb64269d5a67b69a	NOR
61e5d7cb15bd519ceddcf7ba9a22cbc6	DEU
9563a6fd049d7c1859196f614b04b959	POL
90fb95c00db3fde6b86e6accf2178fa7	GBR
b80aecda9ce9783dab49037eec5e4388	IRN
b81dd41873676af0f9533d413774fa8d	BEL
094655515b3991e73686f45e4fe352fe	DNK
fbe95242f85d4bbe067ddc781191afb5	DNK
fc46b0aa6469133caf668f87435bfd9f	USA
8872fbd923476b7cf96913260ec59e66	DEU
db1440c4bae3edf98e3dab7caf2e7fed	USA
bff322dbe273a1e2d1fe37f81acccbe4	ZAF
36b208182f04f44c80937e980c3c28fd	AUS
a1af2abbd036f0499296239b29b40a5f	DEU
89d60b9528242c8c53ecbfde131eba21	DEU
e8d17786fed9fa5ddaf13881496106e4	150
0371892b7f65ffb9c1544ee35c6330ad	CHE
bf5c782ca6b0130372ac41ebd703463e	DEU
f041991eb3263fd3e5d919026e772f57	ITA
70409bc559ef6c8aabcf16941a29788b	BEL
0ecef959ca1f43d538966f7eb9a7e2ec	DEU
169c9d1bfabf9dec8f84e1f874d5e788	DEU
01ffa9ce7c50b906e4f5b6a2516ba94b	CHE
d104b6ae44b0ac6649723bac21761d41	ITA
b12986f0a962c34c6669d59f40b1e9eb	BRA
f0f2e6b4ae39fe3ef81d807f641f54a9	DEU
a54196a4ae23c424c6c01a508f4c9dfb	DEU
e3c1fd64db1923585a22632681c95d35	SWE
0fa4e99a2451478f3870e930d263cfd4	DEU
6c718d616702ff78522951d768552d6a	NLD
9efb345179e21314a38093da366e1f09	DEU
b7f3ddec78883ff5a0af0d223f491db8	DEU
3472e72b1f52a7fda0d4340e563ea6c0	BEL
f816407dd0b81a5baedb7695302855d9	EST
b0353ada659e3848bd59dec631e71f9e	DEU
c256d34ab1f0bd3928525d18ddabe18e	DEU
0035ac847bf9e371750cacbc98ad827b	FIN
49bb0f64fae1bd9abf59989d5a5adfaf	DEU
de2290e4c7bfa39e594c2dcd6e4c09d6	DEU
f929c32e1184b9c0efdd60eb947bf06b	ISR
25f02579d261655a79a54a1fc5c4baf5	FRA
10dbb54312b010f3aeb9fde389fe6cf5	CHE
f0cd1b3734f01a46d31c5644e3216382	USA
2ef1ea5e4114637a2dc94110d4c3fc7a	NOR
09fcf410c0bb418d24457d323a5c812a	DEU
bd6d4ce8e8bd1f6494db102db5a06091	GRC
f68e5e7b745ade835ef3029794b4b0b2	NOR
d4f9c39bf51444ae90cc8947534f20e4	DEU
55edd327aec958934232e98d828fb56a	NOR
e340c1008146e56c9d6c7ad7aa5b8146	SVK
a6c37758f53101378a209921511369de	NOR
5b05784f3a259c7ebc2fffc1cf0c37b7	POL
e2b16c5f5bad24525b8c700c5c3b3653	DNK
baf938346589a5e047e2aa1afcc3d353	ITA
6435684be93c4a59a315999d3a3227f5	150
034c15ae2143eea36eec7292010568a1	FIN
50437ed6fdec844c3d86bb6ac8a4a333	GBR
bb7dcf6e8a0c1005d2be54f005e9ff8f	DEU
05acc535cbe432a56e2c9cfb170ee635	DEU
7a78e9ce32da3202ac0ca91ec4247086	DEU
ba404ce5a29ba15a792583bbaa7969c6	ARG
d8cddac7db3dedd7d96b81a31dc519b3	FRA
63dab0854b1002d4692bbdec90ddaecc	GRC
3e8f57ef55b9d3a8417963f343db1de2	DEU
7176be85b1a9e340db4a91d9f17c87b3	DEU
cc31f5f7ca2d13e95595d2d979d10223	GRC
ea6fff7f9d00d218338531ab8fe4e98c	USA
00a616d5caaf94d82a47275101e3fa22	USA
23dad719c8a972b4f19a65c79a8550fe	DEU
4545c676e400facbb87cbc7736d90e85	DEU
304d29d27816ec4f69c7b1ba5836c57a	USA
37e2e92ced5d525b3e79e389935cd669	150
3cb5ffaba5b396de828bc06683b5e058	USA
a35033c250bd9c577f20f2b253be0021	GBR
cfd7b6bdd92dbe51d1bdb8cb3b98cd58	USA
6dffdacffe80aad339051ef4fbbf3f29	DEU
7d067ef3bf74d1659b8fa9df3de1a047	USA
3cc1eb35683942bb5f7e30b187438c5e	DEU
35f3e8a1461c3ce965993e4eafccfa43	AUS
568afb74bcc1ce84f8562a4fbfdc31ba	USA
9a876908f511193b53ce983ab276bd73	GBR
3ec4a598041aa926d5f075e3d69dfc0a	HUN
6949c5ed6eda8cf7a40adb2981d4671d	DEU
6e610e4ff7101f3a1837544e9fb5d0bf	SWE
312793778e3248b6577e3882a77f68f3	DEU
dd3e531c469005b17115dbf611b01c88	DEU
dd15d5adf6349f5ca53e7a2641d41ab7	DEU
398af626887ad21cd66aeb272b8337be	DEU
eb999c99126a456f9db3c5d3b449fa7f	DEU
0da2e7fa0ba90f4ae031b0d232b8a57a	CUB
71b6971b6323b97f298af11ed5455e55	HUN
36233ed8c181dfacc945ad598fb4f1a1	DNK
221fa1624ee1e31376cb112dd2487953	GBR
5958cd5ce011ea83c06cb921b1c85bb3	NLD
844de407cd83ea1716f1ff57ea029285	POL
df24a5dd8a37d3d203952bb787069ea2	GBR
048d40092f9bd3c450e4bdeeff69e8c3	FRA
33b39f2721f79a6bb6bb5e1b2834b0bd	FRA
b145159df60e1549d1ba922fc8a92448	NLD
16a56d0941a310c3dc4f967041574300	CAN
e2be3c3c22484d1872c7b225339c0962	DEU
1fbd4bcce346fd2b2ffb41f6e767ea84	NLD
bca8f048f2c5ff787950eb1ba088c70e	DEU
e093d52bb2d4ff4973e72f6eb577714b	DEU
9777f12d27d48261acb756ca56ceea96	DEU
20aba645df0b3292c63f0f08b993966e	DEU
31897528a567059ed581f119a0e1e516	DEU
41f062d8603a9705974083360fb69892	DEU
ad7de486b34143f00a56127a95787e78	USA
ca4038e41aaa675d65dc3f2ea92556e9	AUT
16ff0968c682d98cb29b42c793066f29	SWE
d2556a1452bc878401a6cde5cb89264d	SWE
bccaee4d143d381c8c617dd98b9ee463	USA
1680c4ab3ce61ab3e1514fba8b99e3c5	MEX
03aa4e5b2b49a82eb798d33afe9e8523	AUT
649df53f8249bdb0aa26e52d6ee517bb	BEL
c9dc004fc3d039ad7fb49456e5902b01	GBR
67cc86339b2654a35fcc57da8fc9d33d	CAN
6916ed9292a811c895e259c542af0e8a	DEU
fd401865b6db200e5eb8a1ac1b1fbab1	DEU
218d618a041c057d0e05799670e7e2c8	DEU
a4bcd57d5cda816e4ffd1f83031a36ca	CAN
ec5c65bfe530446b696f04e51aa19201	DEU
14af57131cbbf57afb206c8707fdab6c	FRA
a45ff5de3a96b103a192f1f133d0b0cf	DEU
de3e4c12f56a35dc1ee6866b1ddd9d53	FRA
88726e1a911181e20cf8be52e1027f26	DEU
9b7d722b58370498cd39104b2d971978	DEU
ac61757d33fc8563eb2409ed08e21974	DEU
93299af7c9e3c63c7b3d9bb2242c9d6b	DEU
11a5f9f425fd6da2d010808e5bf759ab	GBR
bc5daaf162914ff1200789d069256d36	USA
98e8599d1486fadca0bf7aa171400dd8	DEU
66857d7c2810238438483356343ff26e	NLD
aa5e46574bdc6034f4d49540c0c2d1ad	POL
13d81f0ed06478714344fd0f1a6a81bb	DEU
eaacb8ee01500f18e370303be3d5c591	DEU
22ef651048289b302401afe2044c5c01	DEU
f3cb86dd6b6caf33a8a05571e195e7dc	GBR
708abbdc2eb4b62e6732c4c2a60c625a	DEU
ffd6243282cdf77599e2abaf5d1a36e5	USA
d148b29cbc0092dc206f9217a1b3da73	USA
a70a003448c0c2d2a6d4974f60914d40	USA
68f05e1c702a4218b7eb968ff9489744	DEU
b5067ff7f533848af0c9d1f3e6c5b204	DEU
dba661bb8c2cd8edac359b22d3f9ddf3	DEU
553adf4c48f103e61a3ee7a94e7ea17b	DEU
134a3bbedd12bc313d57aa4cc781ddf9	DEU
ab9ca8ecf42a92840c674cde665fbdd3	DEU
d4192d77ea0e14c40efe4dc9f08fdfb8	DEU
5fac4291bc9c25864604c4a6be9e0b4a	DEU
ecd06281e276d8cc9a8b1b26d8c93f08	USA
bf6cf2159f795fc867355ee94bca0dd5	CAN
3b0713ede16f6289afd699359dff90d4	USA
46148baa7f5229428d9b0950be68e6d7	DEU
a909b944804141354049983d9c6cc236	DEU
16e54a9ce3fcedbadd0cdc18832266fd	DEU
b08bdd1d40a38ab9848ff817294332ca	DEU
b06edc3ce52eb05a5a45ae58a7bb7adc	DEU
9a83f3f2774bee96b8f2c8595fc174d7	NLD
4124cc9a170709b345d3f68fd563ac33	NLD
a1e60d2ccea21edbaf84a12181d1e966	CHE
94edec5dc10d059f05d513ce4a001c22	DEU
d1b8bfadad3a69dbd746217a500a4db5	CHE
57006f73c326669c8d52c47a3a9e2696	DEU
28a6ebe1e170483c1695fca36880db98	DEU
ce34dc9b3e210fd7a61d94df77bd8398	150
cdd21eba97ee010129f5d1e7a80494cb	USA
ec29a7f3c6a4588ef5067ea12a19e4e1	NLD
dac6032bdce48b416fa3cd1d93dc83b8	ITA
73cff3ab45ec02453b639abccb5bd730	DEU
442ea4b6f50b4ae7dfde9350b3b6f664	DEU
af8b7f5474d507a8e583c66ef1eed5a5	DEU
bf250243f776c4cc4a9c4a1f81f7e42f	DEU
bc30e7b15744d2140e28e5b335605de5	DEU
8b174e2c4b00b9e0699967e812e97397	DEU
a68fbbd4507539f9f2579ad2e7f94902	DEU
2e572c8c809cfbabbe270b6ce7ce88dd	DEU
bfaffe308a2e8368acb49b51814f2bfe	DEU
6261b9de274cf2da37125d96ad21f1df	DEU
804d27f4798081681e71b2381697e58c	NOR
2918f3b4f699f80bcafb2607065451e1	GBR
b760518e994aa7db99d91f1b6aa52679	DEU
0fe3db5cf9cff35143d6610797f91f7c	DEU
2304c368fd55bc45cb12f1589197e80d	DEU
6c3eceee73efa7af0d2f9f62daf63456	DEU
6a2367b68131111c0a9a53cd70c2efed	SWE
f2727091b6fe5656e68aa63d936c5dfd	CAN
ec41b630150c89b30041d46b03f1da42	DEU
cb3a240c27ebf12e17f9efe44fa4a7a8	USA
cfe9861e2a347cc7b50506ea46fdaf4f	DEU
926811886f475151c52dd365c90a7efc	DEU
afe4451c0c33641e67241bfe39f339ff	DEU
e27728342f660d53bd12ab14e5005903	DEU
3e6141409efd871b4a87deacfbf31c28	DEU
e84900ed85812327945c9e72f173f8cc	DEU
c3ce3cf87341cea762a1fb5d26d7d361	DEU
11ac50031c60fb29e5e1ee475be05412	FRA
bd9b8bf7d35d3bd278b5c300bc011d86	GRC
d39aa6fda7dc81d19cd21adbf8bd3479	NOR
\.


--
-- Data for Name: bands_events; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands_events (id_band, id_event) FROM stdin;
576fea4a0c5425ba382fff5f593a33f1	70ba638a78552630591ba5c7ff92b93a
852c0b6d5b315c823cdf0382ca78e47f	70ba638a78552630591ba5c7ff92b93a
bca8f048f2c5ff787950eb1ba088c70e	8ad5ac467b3776d28a12742decf00657
d908b6b9019639bced6d1e31463eea85	8ad5ac467b3776d28a12742decf00657
1dc7d7d977193974deaa993eb373e714	8ad5ac467b3776d28a12742decf00657
445a222489d55b5768ec2f17b1c3ea34	8ad5ac467b3776d28a12742decf00657
d9c849266ee3ac1463262df200b3aab8	3fe511194113f53322ccac8a75e6b4ab
5bd15db3f3bb125cf3222745f4fe383f	3fe511194113f53322ccac8a75e6b4ab
73cb08d143f893e645292dd04967f526	3fe511194113f53322ccac8a75e6b4ab
6caa47f7b3472053b152f84ce72c182c	f56f7353a648997c6f5bc4a952cd1bd2
a7e071b3de48cec1dd24de6cbe6c7bf1	f56f7353a648997c6f5bc4a952cd1bd2
d68956b2b5557e8f1be27a4632045c1e	f56f7353a648997c6f5bc4a952cd1bd2
1cc93e4af82b1b7e08bace9a92d1f762	f56f7353a648997c6f5bc4a952cd1bd2
3a232003be172b49eb64e4d3e9af1434	f56f7353a648997c6f5bc4a952cd1bd2
06c5c89047bfd6012e6fb3c2bd3cb24b	f56f7353a648997c6f5bc4a952cd1bd2
511ac85b55c0c400422462064d6c77ed	f56f7353a648997c6f5bc4a952cd1bd2
75fea12b82439420d1f400a4fcf3386b	75fea12b82439420d1f400a4fcf3386b
1fd7fc9c73539bee88e1ec137b5f9ad2	08a5c6dec5d631fe995935fd38f389be
9639834b69063b336bb744a537f80772	99e73f7baf95258d1a2f27df6c67294f
07d82d98170ab334bc66554bafa673cf	99e73f7baf95258d1a2f27df6c67294f
01bcfac216d2a08cd25930234e59f1a1	791a234c3e78612495c07d7d49defc4c
278af3c810bb9de0f355ce115b5a2f54	791a234c3e78612495c07d7d49defc4c
df99cee44099ff57acbf7932670614dd	0a7d68cf2a103e1c99f7e6d04f1940da
a7111b594249d6a038281deb74ef0d04	fb57c18df776961bb734a1fa3db6a6d1
c311f3f7c84d1524104b369499bd582f	fb57c18df776961bb734a1fa3db6a6d1
a7111b594249d6a038281deb74ef0d04	2d5e1a99b20d1be28ef40573c37eb0a0
78b532c25e4a99287940b1706359d455	2d5e1a99b20d1be28ef40573c37eb0a0
ec4f407118924fdc6af3335c8d2961d9	2d5e1a99b20d1be28ef40573c37eb0a0
11a7f956c37bf0459e9c80b16cc72107	2d5e1a99b20d1be28ef40573c37eb0a0
b02ba5a5e65487122c2c1c67351c3ea0	2c6ed5b74b30541da64fdbbda4a8bbe3
41e744bdf3114b14f5873dfb46921dc4	2c6ed5b74b30541da64fdbbda4a8bbe3
fcc491ba532309d8942df543beaec67e	a3c7a40013e778dc1ce7d4ae7cdcfa6d
e37015150c8944d90e306f19eaa98de8	a3c7a40013e778dc1ce7d4ae7cdcfa6d
ed795c86ba21438108f11843f7214c95	6c7cfe3af936c1590949350fc7d912d3
dbc940d02a217c923c52d3989be9b391	6c7cfe3af936c1590949350fc7d912d3
8845da022807c76120b5b6f50c218d9a	6c7cfe3af936c1590949350fc7d912d3
662d17c67dcabc738b8620d3076f7e46	0601414fd50328355d256db5037bc430
ea3b6b67824411a4cfaa5c8789282f48	71de5246c2f4ac4766041831e93f001a
381b834c6bf7b25b9b627c9eeb81dd8a	71de5246c2f4ac4766041831e93f001a
25f5d73866a52be9d0e2e059955dfd56	57e44259dc61f23bef42517695d645f1
182a1e726ac1c8ae851194cea6df0393	57e44259dc61f23bef42517695d645f1
ce14eb923a380597f2aff8b65a742048	57e44259dc61f23bef42517695d645f1
5c29c2e513aadfe372fd0af7553b5a6c	57e44259dc61f23bef42517695d645f1
61e5d7cb15bd519ceddcf7ba9a22cbc6	e723d4328c7df53576419235b92f4a13
9563a6fd049d7c1859196f614b04b959	e723d4328c7df53576419235b92f4a13
90fb95c00db3fde6b86e6accf2178fa7	e723d4328c7df53576419235b92f4a13
b80aecda9ce9783dab49037eec5e4388	e723d4328c7df53576419235b92f4a13
b81dd41873676af0f9533d413774fa8d	e723d4328c7df53576419235b92f4a13
8b3f40e0243e2307a1818d3f456df153	8b3c931e31a2c5dbb3155dab7dade775
094655515b3991e73686f45e4fe352fe	8b3c931e31a2c5dbb3155dab7dade775
fbe95242f85d4bbe067ddc781191afb5	8b3c931e31a2c5dbb3155dab7dade775
5c3278fb76fa2676984396d33ba90613	1f711336d1c518a68db9e2b4dd631e81
a1af2abbd036f0499296239b29b40a5f	1f711336d1c518a68db9e2b4dd631e81
abc73489d8f0d1586a2568211bdeb32f	b098c76b1d5ba70577a0c0ba30d2170a
26ad58455460d75558a595528825b672	b098c76b1d5ba70577a0c0ba30d2170a
ffd2da11d45ed35a039951a8b462e7fb	b098c76b1d5ba70577a0c0ba30d2170a
f655d84d670525246ee7d57995f71c10	79b4deb2eac122cc633196f32cf65670
55b6aa6562faa9381e43ea82a4991079	79b4deb2eac122cc633196f32cf65670
6d779916de27702814e4874dcf4f9e3a	79b4deb2eac122cc633196f32cf65670
08f8c67c20c4ba43e8ba6fa771039c94	3479db140a88fa19295f4346b1d84380
90669320cd8e4a09bf655310bffdb9ba	3479db140a88fa19295f4346b1d84380
cfe122252751e124bfae54a7323bf02d	3479db140a88fa19295f4346b1d84380
3e28a735f3fc31a9c8c30b47872634bf	3479db140a88fa19295f4346b1d84380
efe9ed664a375d10f96359977213d620	3479db140a88fa19295f4346b1d84380
77bfe8d21f1ecc592062f91c9253d8ab	3479db140a88fa19295f4346b1d84380
ba9bfb4d7c1652a200d1d432f83c5fd1	3479db140a88fa19295f4346b1d84380
bf2c8729bf5c149067d8e978ea3dcd32	3479db140a88fa19295f4346b1d84380
cd0bc2c8738b2fef2d78d197223b17d5	3479db140a88fa19295f4346b1d84380
0964b5218635a1c51ff24543ee242514	3479db140a88fa19295f4346b1d84380
eb4558fa99c7f8d548cbcb32a14d469c	3479db140a88fa19295f4346b1d84380
5934340f46d5ab773394d7a8ac9e86d5	3479db140a88fa19295f4346b1d84380
0e609404e53b251f786b41b7be93cc19	2dac37a155782e0b3d86fc00d42b53d0
f520f53edf44d466fb64269d5a67b69a	2dac37a155782e0b3d86fc00d42b53d0
a0cdbd2af8f1ddbb2748a2eaddce55da	8a48b001d26cf3023ac469d68bfba185
0add3cab2a932f085109a462423c3250	8a48b001d26cf3023ac469d68bfba185
45d592ef3a8dc14dccc087e734582e82	8a48b001d26cf3023ac469d68bfba185
78bbff6bf39602a577c9d8a117116330	8a48b001d26cf3023ac469d68bfba185
1b62f034014b1d242c84c6fe7e6470f0	8a48b001d26cf3023ac469d68bfba185
8e38937886f365bb96aa1c189c63c5ea	1fef5be89b79c6e282d1af946a3bd662
9d74605e4b1d19d83992a991230e89ef	b8f41d89b2d67b4b86379d236b2492aa
8981b4a0834d2d59e1d0dceb6022caae	8a48b001d26cf3023ac469d68bfba185
a7e071b3de48cec1dd24de6cbe6c7bf1	8a48b001d26cf3023ac469d68bfba185
f3ac75dfbf1ce980d70dc3dea1bf4636	8a48b001d26cf3023ac469d68bfba185
3ddbf46000c2fbd44759f3b4672b64db	8a48b001d26cf3023ac469d68bfba185
07f467f03da5f904144b0ad3bc00a26d	8a48b001d26cf3023ac469d68bfba185
21077194453dcf49c2105fda6bb89c79	8a48b001d26cf3023ac469d68bfba185
7df470ec0292985d8f0e37aa6c2b38d5	8a48b001d26cf3023ac469d68bfba185
75241d56d63a68adcd51d828eb76ca80	8a48b001d26cf3023ac469d68bfba185
34e927c45cf3ccebb09b006b00f4e02d	8a48b001d26cf3023ac469d68bfba185
647a73dd79f06cdf74e1fa7524700161	e669a39d1453acd6aefc84913a985f51
4e9b4bdef9478154fc3ac7f5ebfb6418	e669a39d1453acd6aefc84913a985f51
d162c87d4d4b2a8f6dda58d4fba5987f	e669a39d1453acd6aefc84913a985f51
c63b6261b8bb8145bc0fd094b9732c24	e669a39d1453acd6aefc84913a985f51
0925467e1cc53074a440dae7ae67e3e9	e669a39d1453acd6aefc84913a985f51
9a8d3efa0c3389083df65f4383b155fb	9952e1e08fb8f493c66f5cf386ba7e06
c091e33f684c206b73b25417f6640b71	9952e1e08fb8f493c66f5cf386ba7e06
98e8599d1486fadca0bf7aa171400dd8	8de89ad5eef951fd87bd3e013c63a6c4
cd004b87e2adfb72b28752a6ef6cd639	8de89ad5eef951fd87bd3e013c63a6c4
e039d55ed63a723001867bc4eb842c00	8de89ad5eef951fd87bd3e013c63a6c4
58e42b779d54e174aad9a9fb79e7ebbc	8de89ad5eef951fd87bd3e013c63a6c4
67493f858802a478bfe539c8e30a7e44	8de89ad5eef951fd87bd3e013c63a6c4
22c2fc8a3a81503d40d4e532ac0e22ab	8de89ad5eef951fd87bd3e013c63a6c4
d0e551d6887e0657952b3c5beb7fed74	8de89ad5eef951fd87bd3e013c63a6c4
77ac561c759a27b7d660d7cf0534a9c3	8de89ad5eef951fd87bd3e013c63a6c4
e6489b9cc39c95e53401cb601c4cae09	8de89ad5eef951fd87bd3e013c63a6c4
4622209440a0ade57b18f21ae41963d9	8de89ad5eef951fd87bd3e013c63a6c4
867e7f73257c5adf6a4696f252556431	8de89ad5eef951fd87bd3e013c63a6c4
f999abbe163f001f55134273441f35c0	8de89ad5eef951fd87bd3e013c63a6c4
9527fff55f2c38fa44281cd0e4d511ba	8de89ad5eef951fd87bd3e013c63a6c4
04c8327cc71521b265f2dc7cbe996e13	8de89ad5eef951fd87bd3e013c63a6c4
812f48abd93f276576541ec5b79d48a2	9d0ac9b8cb657a5f09f81d6bea3e1798
d2f62cd276ef7cab5dcf9218d68f5bcf	9d0ac9b8cb657a5f09f81d6bea3e1798
c245b4779defd5c69ffebbfdd239dd1b	9d0ac9b8cb657a5f09f81d6bea3e1798
0ada417f5b4361074360211e63449f34	9d0ac9b8cb657a5f09f81d6bea3e1798
979b5de4a280c434213dd8559cf51bc0	2ac99a5ffc2764063bc246f9fa174a71
75fea12b82439420d1f400a4fcf3386b	a4ef4e4104ed8bdd818771ca2ea34127
a6c27c0fb9ef87788c1345041e840f95	cbe2729e13ce90825f88f2fc3a0bce55
8cd1cca18fb995d268006113a3d6e4bf	cbe2729e13ce90825f88f2fc3a0bce55
5c59b6aa317b306a1312a67fe69bf512	cbe2729e13ce90825f88f2fc3a0bce55
869bb972f8bef83979774fa123c56a4e	cbe2729e13ce90825f88f2fc3a0bce55
13d81f0ed06478714344fd0f1a6a81bb	08f8c67c20c4ba43e8ba6fa771039c94
08f8c67c20c4ba43e8ba6fa771039c94	08f8c67c20c4ba43e8ba6fa771039c94
ea3b6b67824411a4cfaa5c8789282f48	08f8c67c20c4ba43e8ba6fa771039c94
cd004b87e2adfb72b28752a6ef6cd639	c0f93075617b7dd9db214f46876fb39d
70492d5f3af58ace303d1c5dfc210088	c0f93075617b7dd9db214f46876fb39d
913df019fed1f80dc49b38f02d8bae41	c0f93075617b7dd9db214f46876fb39d
8518eafd8feec0d8c056d396122a175a	c0f93075617b7dd9db214f46876fb39d
afb6e0f1e02be39880596a490c900775	87d1f3bfe03274952aa29304eb82d9d9
630500eabc48c986552cb01798a31746	87d1f3bfe03274952aa29304eb82d9d9
472e67129f0c7add77c7c907dac3351f	87d1f3bfe03274952aa29304eb82d9d9
38b2886223461f15d65ff861921932b5	87d1f3bfe03274952aa29304eb82d9d9
22ef651048289b302401afe2044c5c01	bd4a5e87854fd4d729983f3ac9bc7268
2187711aeaa2944a707c9eabaa2df72a	bd4a5e87854fd4d729983f3ac9bc7268
b02ba5a5e65487122c2c1c67351c3ea0	bd4a5e87854fd4d729983f3ac9bc7268
9b55ad92062221ec1bc80f950f667a6b	bd4a5e87854fd4d729983f3ac9bc7268
34a9067cace79f5ea8a6e137b7a1a5c8	bd4a5e87854fd4d729983f3ac9bc7268
d2c2b83008dce38013577ef83a101a1b	bd4a5e87854fd4d729983f3ac9bc7268
a4bcd57d5cda816e4ffd1f83031a36ca	11a728ed9e3a6aac1b46277a7302b15f
ec5c65bfe530446b696f04e51aa19201	11a728ed9e3a6aac1b46277a7302b15f
22ef651048289b302401afe2044c5c01	5fd9b4c8df6e69c50106703b7d050a3d
25f5d73866a52be9d0e2e059955dfd56	5fd9b4c8df6e69c50106703b7d050a3d
bf2c8729bf5c149067d8e978ea3dcd32	5fd9b4c8df6e69c50106703b7d050a3d
92edfbaa71b7361a3081991627b0e583	5fd9b4c8df6e69c50106703b7d050a3d
d9c849266ee3ac1463262df200b3aab8	eeba68f0a1003dce9bd66066b82dc1b6
13d81f0ed06478714344fd0f1a6a81bb	eeba68f0a1003dce9bd66066b82dc1b6
eaacb8ee01500f18e370303be3d5c591	eeba68f0a1003dce9bd66066b82dc1b6
53a5da370321dac39033a5fe6af13e77	eeba68f0a1003dce9bd66066b82dc1b6
bd4ca3a838ce3972af46b6e2d85985f2	eeba68f0a1003dce9bd66066b82dc1b6
cd0bc2c8738b2fef2d78d197223b17d5	eeba68f0a1003dce9bd66066b82dc1b6
6cec93398cd662d79163b10a7b921a1b	eeba68f0a1003dce9bd66066b82dc1b6
a7eda23a9421a074fe5ec966810018d7	eeba68f0a1003dce9bd66066b82dc1b6
062c44f03dce5bf39f81d0bf953926fc	eeba68f0a1003dce9bd66066b82dc1b6
43a4893e6200f462bb9fe406e68e71c0	eeba68f0a1003dce9bd66066b82dc1b6
cb80a6a84ec46f085ea6b2ff30a88d80	cb80a6a84ec46f085ea6b2ff30a88d80
ef297890615f388057b6a2c0a2cbc7ab	921e9baf14e4134100c7b7a475b1bb06
a985c9764e0e6d738ff20f2328a0644b	921e9baf14e4134100c7b7a475b1bb06
71f4e9782d5f2a5381f5cdf7c5a35d89	921e9baf14e4134100c7b7a475b1bb06
6772cdb774a6ce03a928d187def5453f	921e9baf14e4134100c7b7a475b1bb06
0182742917720e1b2cf59ff671738253	921e9baf14e4134100c7b7a475b1bb06
c63b6261b8bb8145bc0fd094b9732c24	921e9baf14e4134100c7b7a475b1bb06
863e7a3d6d4a74739bca7dd81db5d51f	921e9baf14e4134100c7b7a475b1bb06
486bf23406dec9844b97f966f4636c9b	486bf23406dec9844b97f966f4636c9b
f2a863a08c3e22cc942264ac4bc606e3	07da0c8ead421197cc73463cf5a5eefc
5637bae1665ae86050cb41fb1cdcc3ee	07da0c8ead421197cc73463cf5a5eefc
4e74055927fd771c2084c92ca2ae56a7	07da0c8ead421197cc73463cf5a5eefc
dfb7069bfc6e0064a6c667626eca07b4	133416b949a72009242c85d5af911b93
23f5e1973b5a048ffaaa0bd0183b5f87	133416b949a72009242c85d5af911b93
576fea4a0c5425ba382fff5f593a33f1	133416b949a72009242c85d5af911b93
7df470ec0292985d8f0e37aa6c2b38d5	133416b949a72009242c85d5af911b93
71144850f4fb4cc55fc0ee6935badddf	20b32a6bbc813658d242a65c08bc8140
9d514e6b301cfe7bdc270212d5565eaf	20b32a6bbc813658d242a65c08bc8140
3aa1c6d08d286053722d17291dc3f116	50e128ce6587bfcaedf317f6deb69695
846a0115f0214c93a5a126f0f9697228	50e128ce6587bfcaedf317f6deb69695
cd80c766840b7011fbf48355c0142431	50e128ce6587bfcaedf317f6deb69695
c9dc004fc3d039ad7fb49456e5902b01	c9dc004fc3d039ad7fb49456e5902b01
5e6ff2b64b4c0163ab83ab371abe910b	c9dc004fc3d039ad7fb49456e5902b01
1437c187d64f0ac45b6b077a989d5648	c9dc004fc3d039ad7fb49456e5902b01
dcab0d84960cda81718e38ee47688a75	c9dc004fc3d039ad7fb49456e5902b01
9a8d3efa0c3389083df65f4383b155fb	1e144cd25de2ab5d9153d38c674c1f4b
272a23811844499845c6e33712c8ba6c	1e144cd25de2ab5d9153d38c674c1f4b
118b96dde2f8773b011dfb27e51b2f95	1e144cd25de2ab5d9153d38c674c1f4b
01bcfac216d2a08cd25930234e59f1a1	1e144cd25de2ab5d9153d38c674c1f4b
dddbd203ace7db250884ded880ea7be4	332be9c531b1ec341c13e5a676962820
a9afdc809b94392fb1c2e873dbb02781	332be9c531b1ec341c13e5a676962820
60eb61670a5385e3150cd87f915b0967	332be9c531b1ec341c13e5a676962820
a7111b594249d6a038281deb74ef0d04	332be9c531b1ec341c13e5a676962820
fcc491ba532309d8942df543beaec67e	fbae6c1da1deba5dd51f5d07007ec5ab
03fec47975e0e1e2d0bc723af47281de	fbae6c1da1deba5dd51f5d07007ec5ab
a7111b594249d6a038281deb74ef0d04	fbae6c1da1deba5dd51f5d07007ec5ab
3c2234a7ce973bc1700e0c743d6a819c	90445b62432a3d8e1f7b3640029e6fed
05fcf330d8fafb0a1f17ce30ff60b924	759144a13dee6936c81d0fce2eaaba06
e3c8afbeb0ec4736db977d18e7e37020	759144a13dee6936c81d0fce2eaaba06
38734dcdff827db1dc3215e23b4e0890	da4794bdc2159737a4c338392a856359
fcc491ba532309d8942df543beaec67e	da4794bdc2159737a4c338392a856359
460bf623f241651a7527a63d32569dc0	f015a601161f02a451557258793a96a1
b00114f9fc38b48cc42a4972d7e07df6	f015a601161f02a451557258793a96a1
2dde74b7ec594b9bd78da66f1c5cafdc	f015a601161f02a451557258793a96a1
f00bbb7747929fafa9d1afd071dba78e	3e98ecfa6a4c765c5522f897a4a8de23
abe78132c8e446430297d08bd1ecdab0	3e98ecfa6a4c765c5522f897a4a8de23
3e98ecfa6a4c765c5522f897a4a8de23	3e98ecfa6a4c765c5522f897a4a8de23
ed783268eca01bff52c0f135643a9ef7	e5847f38992d20bb78aafd080c5226d4
b66781a52770d78b260f15d125d1380b	2b6e496456bb2be5444c941692fa5d17
4dde2c290e3ee11bd3bd1ecd27d7039a	2b6e496456bb2be5444c941692fa5d17
b454fdfc910ad8f6b7509072cf0b4031	2b6e496456bb2be5444c941692fa5d17
3b544a6f1963395bd3ae0aeebdf1edd8	2b6e496456bb2be5444c941692fa5d17
b145159df60e1549d1ba922fc8a92448	603ef2d9ef2057c8719d0715a7de32d1
2eb42b9c31ac030455e5a4a79bccf603	603ef2d9ef2057c8719d0715a7de32d1
4be3e31b7598745d0e96c098bbf7a1d7	603ef2d9ef2057c8719d0715a7de32d1
2569a68a03a04a2cd73197d2cc546ff2	603ef2d9ef2057c8719d0715a7de32d1
f6708813faedbf607111d83fdce91828	603ef2d9ef2057c8719d0715a7de32d1
46ea4c445a9ff8e288258e3ec9cd1cf0	603ef2d9ef2057c8719d0715a7de32d1
3a232003be172b49eb64e4d3e9af1434	603ef2d9ef2057c8719d0715a7de32d1
ed783268eca01bff52c0f135643a9ef7	6e18512149a51931a4faa1f51d69a61f
312793778e3248b6577e3882a77f68f3	65302b172b9b95b0f8f692caef2e19e8
66857d7c2810238438483356343ff26e	65302b172b9b95b0f8f692caef2e19e8
e5ea2ac2170d4f9c2bdbd74ab46523f7	65302b172b9b95b0f8f692caef2e19e8
4e7054dff89623f323332052d0c7ff6e	65302b172b9b95b0f8f692caef2e19e8
6ca47c71d99f608d4773b95f9b859142	65302b172b9b95b0f8f692caef2e19e8
a7eda23a9421a074fe5ec966810018d7	65302b172b9b95b0f8f692caef2e19e8
13c8bd3a0d92bd186fc5162eded4431d	65302b172b9b95b0f8f692caef2e19e8
99bdf8d95da8972f6979bead2f2e2090	65302b172b9b95b0f8f692caef2e19e8
d92ee81a401d93bb2a7eba395e181c04	24756eb800986d0cb679e4c78d8a06c2
6adc39f4242fd1ca59f184e033514209	24756eb800986d0cb679e4c78d8a06c2
5cc06303f490f3c34a464dfdc1bfb120	24756eb800986d0cb679e4c78d8a06c2
c5d3d165539ddf2020f82c17a61f783d	91f86c2abd4b3c5f884c3947c424f70a
573f13e31f1be6dea396ad9b08701c47	91f86c2abd4b3c5f884c3947c424f70a
b1d18f9e5399464bbe5dea0cca8fe064	3fd69863958a8c69582d9f5bd6c82681
6f60a61fcc05cb4d42c81ade04392cfc	3fd69863958a8c69582d9f5bd6c82681
849c829d658baaeff512d766b0db3cce	3fd69863958a8c69582d9f5bd6c82681
218d618a041c057d0e05799670e7e2c8	87ba4cfe4768f0efa1a69dacb770810c
fcc491ba532309d8942df543beaec67e	87ba4cfe4768f0efa1a69dacb770810c
6a4e8bab29666632262eb20c336e85e2	e70608c5455336dfc61d221e145f51cd
dfca36a68db327258a2b0d5e3abe86af	e70608c5455336dfc61d221e145f51cd
2b068ea64f42b2ccd841bb3127ab20af	21913ca002c17ce3cf8a0331b2dad1c8
a91887f44d8d9fdcaa401d1c719630d7	21913ca002c17ce3cf8a0331b2dad1c8
aa5808895fd2fca01d080618f08dca51	21913ca002c17ce3cf8a0331b2dad1c8
156c19a6d9137e04b94500642d1cb8c2	21913ca002c17ce3cf8a0331b2dad1c8
5b5fc236828ee2239072fd8826553b0a	91e2010dfd20c93ee84ffd12694b0f24
a7111b594249d6a038281deb74ef0d04	1b76db5ef5f13c3451dcc06344fae248
fcc491ba532309d8942df543beaec67e	e6273b4e07720dbd6ed7870371b86d24
9777f12d27d48261acb756ca56ceea96	1fef5be89b79c6e282d1af946a3bd662
852c0b6d5b315c823cdf0382ca78e47f	e6273b4e07720dbd6ed7870371b86d24
852c0b6d5b315c823cdf0382ca78e47f	943f6abbf24d69a145fbac5cc30c1a5c
c311f3f7c84d1524104b369499bd582f	943f6abbf24d69a145fbac5cc30c1a5c
2569a68a03a04a2cd73197d2cc546ff2	d3bda1e9de8bc6d585f37b739264d649
852c0b6d5b315c823cdf0382ca78e47f	d3bda1e9de8bc6d585f37b739264d649
fd401865b6db200e5eb8a1ac1b1fbab1	40512bf59a621ffaaea463f137f395ec
d908b6b9019639bced6d1e31463eea85	40512bf59a621ffaaea463f137f395ec
01a9f3fdd96daef6bc85160bd21d35dc	c4968fa5ec8f129c7fd49ffa5cb64d6e
c2ab38206dce633f15d66048ad744f03	c4968fa5ec8f129c7fd49ffa5cb64d6e
7f3e5839689216583047809a7f6bd0ff	c4968fa5ec8f129c7fd49ffa5cb64d6e
e29470b6da77fb63e9b381fa58022c84	c4968fa5ec8f129c7fd49ffa5cb64d6e
c349bc9795ba303aa49e44f64301290e	c4968fa5ec8f129c7fd49ffa5cb64d6e
a7eda23a9421a074fe5ec966810018d7	c4968fa5ec8f129c7fd49ffa5cb64d6e
827bf758c7ce2ac0f857379e9e933f77	c4968fa5ec8f129c7fd49ffa5cb64d6e
39ce458f2caa87bc7b759cd8cb16e62f	c4968fa5ec8f129c7fd49ffa5cb64d6e
9d74605e4b1d19d83992a991230e89ef	c4968fa5ec8f129c7fd49ffa5cb64d6e
8ac49bad86eacffcea299416cd92c3b7	cb14876022caa93cf2a4a934fad74fe9
25f5d73866a52be9d0e2e059955dfd56	cb14876022caa93cf2a4a934fad74fe9
182a1e726ac1c8ae851194cea6df0393	cb14876022caa93cf2a4a934fad74fe9
16a56d0941a310c3dc4f967041574300	c4c0e84be1600267ea2bd626c25dc626
05ee6afed8d828d4e7ed35b0483527f7	c4c0e84be1600267ea2bd626c25dc626
c82a107cd7673a4368b7252aa57810fc	c4c0e84be1600267ea2bd626c25dc626
123f90461d74091a96637955d14a1401	c4c0e84be1600267ea2bd626c25dc626
a9ef9373c9051dc4a3e2f2118537bb2d	d4dafcc2060475c01e6b4f6f3cb5c488
c63b6261b8bb8145bc0fd094b9732c24	d4dafcc2060475c01e6b4f6f3cb5c488
f975b4517b002a52839c42e86b34dc96	d4dafcc2060475c01e6b4f6f3cb5c488
afb6e0f1e02be39880596a490c900775	f4e988e1e599ea5ff2d9519e59511757
2f090f093a2868dccca81a791bc4941f	f4e988e1e599ea5ff2d9519e59511757
b3d0eb96687420dc4e5b10602ac42690	f4e988e1e599ea5ff2d9519e59511757
2d1ba9aa05ea4d94a0acb6b8dde29d6b	f4e988e1e599ea5ff2d9519e59511757
93299af7c9e3c63c7b3d9bb2242c9d6b	a01b8b09fc0dea9192cb02b077bfae9f
92ad5e8d66bac570a0611f2f1b3e43cc	a01b8b09fc0dea9192cb02b077bfae9f
f3b8f1a2417bdc483f4e2306ac6004b2	a01b8b09fc0dea9192cb02b077bfae9f
dfb7069bfc6e0064a6c667626eca07b4	ec29ea3adb2b584841d5d185e5f9135b
3577f7160794aa4ba4d79d0381aefdb1	ec29ea3adb2b584841d5d185e5f9135b
1fd7fc9c73539bee88e1ec137b5f9ad2	ec29ea3adb2b584841d5d185e5f9135b
e2afc3f96b4a23d451c171c5fc852d0f	ec29ea3adb2b584841d5d185e5f9135b
28bc0abd0cf390a4472b1f60bd0cfe4a	6fa3e357c27d47966023568346d51a09
d02f33b44582e346050cefadce93eb95	6fa3e357c27d47966023568346d51a09
298a577c621a7a1c365465f694e0bd13	6fa3e357c27d47966023568346d51a09
93299af7c9e3c63c7b3d9bb2242c9d6b	6fa3e357c27d47966023568346d51a09
81200f74b5d831e3e206a66fe4158370	6fa3e357c27d47966023568346d51a09
02fd1596536ea89e779d37ded52ac353	6fa3e357c27d47966023568346d51a09
781c745a0d6b02cdecadf2e44d445d1a	6fa3e357c27d47966023568346d51a09
82f43cc1bda0b09efff9b356af97c7ab	6fa3e357c27d47966023568346d51a09
d5ec808c760249f11fbcde2bf4977cc6	6fa3e357c27d47966023568346d51a09
91abd5e520ec0a40ce4360bfd7c5d573	6fa3e357c27d47966023568346d51a09
50026a2dff40e4194e184b756a7ed319	6fa3e357c27d47966023568346d51a09
073f87af06b8d8bc561bb3f74e5f714f	6fa3e357c27d47966023568346d51a09
8ee257802fc6a4d44679ddee10bf24a9	6fa3e357c27d47966023568346d51a09
cd3296ec8f7773892de22dfade4f1b04	6fa3e357c27d47966023568346d51a09
a7111b594249d6a038281deb74ef0d04	6fa3e357c27d47966023568346d51a09
d8d3a01ba7e5d44394b6f0a8533f4647	6fa3e357c27d47966023568346d51a09
dd3e531c469005b17115dbf611b01c88	f6fecea2db8afd44e1ad77f699d38fe9
ad759a3d4f679008ffdfb07cdbda2bb0	f6fecea2db8afd44e1ad77f699d38fe9
abc73489d8f0d1586a2568211bdeb32f	f6fecea2db8afd44e1ad77f699d38fe9
de1e0ed5433f5e95c8f48e18e1c75ff6	f6fecea2db8afd44e1ad77f699d38fe9
db472eaf615920784c2b83fc90e8dcc5	f6fecea2db8afd44e1ad77f699d38fe9
4f5b2e20e9b7e5cc3f53256583033752	f6fecea2db8afd44e1ad77f699d38fe9
66597873e0974fb365454a5087291094	f6fecea2db8afd44e1ad77f699d38fe9
60a105e79a86c8197cec9f973576874b	f6fecea2db8afd44e1ad77f699d38fe9
5f07809ecfce3af23ed5550c6adf0d78	f6fecea2db8afd44e1ad77f699d38fe9
951af0076709a6da6872f9cdf41c852b	f6fecea2db8afd44e1ad77f699d38fe9
786d3481362b8dee6370dfb9b6df38a2	9946f5f348ac677113592c05b1b3905b
3c6444d9a22c3287b8c483117188b3f4	9946f5f348ac677113592c05b1b3905b
218d618a041c057d0e05799670e7e2c8	9946f5f348ac677113592c05b1b3905b
9b7d722b58370498cd39104b2d971978	9946f5f348ac677113592c05b1b3905b
262a49b104426ba0d1559f8785931b9d	9946f5f348ac677113592c05b1b3905b
bd9059497b4af2bb913a8522747af2de	9946f5f348ac677113592c05b1b3905b
0ab01e57304a70cf4f7f037bd8afbe49	9946f5f348ac677113592c05b1b3905b
dfa61d19b62369a37743b38215836df9	9946f5f348ac677113592c05b1b3905b
2569a68a03a04a2cd73197d2cc546ff2	9946f5f348ac677113592c05b1b3905b
05c87189f6c230c90bb1693567233100	9946f5f348ac677113592c05b1b3905b
563fcbf5f44e03e0eeb9c8d6e4c8e127	9946f5f348ac677113592c05b1b3905b
f49f851c639e639b295b45f0e00c4b4c	9946f5f348ac677113592c05b1b3905b
24af2861df3c72c8f1b947333bd215fc	9946f5f348ac677113592c05b1b3905b
1e71013b49bbd3b2aaa276623203453f	9946f5f348ac677113592c05b1b3905b
c41b9ec75e920b610e8907e066074b30	9946f5f348ac677113592c05b1b3905b
fb80cd69a40a73fb3b9f22cf58fd4776	9946f5f348ac677113592c05b1b3905b
63a9f0ea7bb98050796b649e85481845	9946f5f348ac677113592c05b1b3905b
d69462bef6601bb8d6e3ffda067399d9	1fef5be89b79c6e282d1af946a3bd662
398af626887ad21cd66aeb272b8337be	3479db140a88fa19295f4346b1d84380
0f9fb8452cc5754f83e084693d406721	759144a13dee6936c81d0fce2eaaba06
ef75c0b43ae9ba972900e83c5ccf5cac	9946f5f348ac677113592c05b1b3905b
5c19e1e0521f7b789a37a21c5cd5737b	9946f5f348ac677113592c05b1b3905b
748ac622dcfda98f59c3c99593226a75	be5ea4556ea2b3db3607b8e2887c9dd3
de3e4c12f56a35dc1ee6866b1ddd9d53	be5ea4556ea2b3db3607b8e2887c9dd3
eaacb8ee01500f18e370303be3d5c591	be5ea4556ea2b3db3607b8e2887c9dd3
b4c5b422ab8969880d9f0f0e9124f0d7	be5ea4556ea2b3db3607b8e2887c9dd3
ac8eab98e370e2a8711bad327f5f7c55	be5ea4556ea2b3db3607b8e2887c9dd3
26ad58455460d75558a595528825b672	be5ea4556ea2b3db3607b8e2887c9dd3
6adc39f4242fd1ca59f184e033514209	be5ea4556ea2b3db3607b8e2887c9dd3
541fa0085b17ef712791151ca285f1a7	be5ea4556ea2b3db3607b8e2887c9dd3
891b302f7508f0772a8fdb71ccbf9868	be5ea4556ea2b3db3607b8e2887c9dd3
a7eda23a9421a074fe5ec966810018d7	be5ea4556ea2b3db3607b8e2887c9dd3
218d618a041c057d0e05799670e7e2c8	2bc0eb6a40bd1e2409b2722039152679
7d6ede8454373d4ca5565436cbfeb5c0	2bc0eb6a40bd1e2409b2722039152679
445a222489d55b5768ec2f17b1c3ea34	2bc0eb6a40bd1e2409b2722039152679
4190210961bce8bf2ac072c878ee7902	9b4752b144d294fc6799532a413fd54e
a05a13286752cb6fc14f39f51cedd9ce	9b4752b144d294fc6799532a413fd54e
6d25c7ad58121b3effe2c464b851c27a	9b4752b144d294fc6799532a413fd54e
7b675f4c76aed34cf2d5943d83198142	9b4752b144d294fc6799532a413fd54e
00a0d9697a08c1e5d4ba28d95da73292	9b4752b144d294fc6799532a413fd54e
be2c012d60e32fbf456cd8184a51973d	3e8d7d577a332fc33e2f332ad7311e1e
71144850f4fb4cc55fc0ee6935badddf	3e8d7d577a332fc33e2f332ad7311e1e
3c2234a7ce973bc1700e0c743d6a819c	3e8d7d577a332fc33e2f332ad7311e1e
dd3e531c469005b17115dbf611b01c88	e6513a2614231773cfe00d0bb6178806
ec5c65bfe530446b696f04e51aa19201	e6513a2614231773cfe00d0bb6178806
768207c883fd6447d67f3d5bc09211bd	e6513a2614231773cfe00d0bb6178806
9d74605e4b1d19d83992a991230e89ef	e6513a2614231773cfe00d0bb6178806
bda66e37bf0bfbca66f8c78c5c8032b8	8b0e6056132f11cfb7968cf303ff0154
fcc491ba532309d8942df543beaec67e	8b0e6056132f11cfb7968cf303ff0154
20a75b90511c108e3512189ccb72b0ac	d988ef331f5b477753be3bae8b18412f
458da4fc3da734a6853e26af3944bf75	d988ef331f5b477753be3bae8b18412f
5637bae1665ae86050cb41fb1cdcc3ee	d988ef331f5b477753be3bae8b18412f
26211992c1edc0ab3a6b6506cac8bb52	d988ef331f5b477753be3bae8b18412f
ee36fdf153967a0b99d3340aadeb4720	0add3cab2a932f085109a462423c3250
0add3cab2a932f085109a462423c3250	0add3cab2a932f085109a462423c3250
94a62730604a985647986b509818efee	0add3cab2a932f085109a462423c3250
739260d8cb379c357340977fe962d37a	52bb7665f1523ba2bb7481ee085ce6ec
53a5da370321dac39033a5fe6af13e77	52bb7665f1523ba2bb7481ee085ce6ec
42f6dd3a6e21d6df71db509662d19ca4	52bb7665f1523ba2bb7481ee085ce6ec
abc73489d8f0d1586a2568211bdeb32f	f2da218ba072addd567741ba722037e4
b02ba5a5e65487122c2c1c67351c3ea0	f2da218ba072addd567741ba722037e4
16c88f2a44ab7ecdccef28154f3a0109	f2da218ba072addd567741ba722037e4
191bab5800bd381ecf16485f91e85bc3	f2da218ba072addd567741ba722037e4
876eed60be80010455ff50a62ccf1256	f2da218ba072addd567741ba722037e4
f4e4ef312f9006d0ae6ca30c8a6a32ff	f2da218ba072addd567741ba722037e4
d9c849266ee3ac1463262df200b3aab8	b17a925acc0a591c2be6f84376007717
93299af7c9e3c63c7b3d9bb2242c9d6b	b17a925acc0a591c2be6f84376007717
e6793169497d66ac959a7beb35d6d497	b17a925acc0a591c2be6f84376007717
eb39fa9323a6b3cbc8533cd3dadb9f76	b17a925acc0a591c2be6f84376007717
1c4af233da7b64071abf94d79c41a361	b17a925acc0a591c2be6f84376007717
364be07c2428493479a07dbefdacc11f	b17a925acc0a591c2be6f84376007717
a7111b594249d6a038281deb74ef0d04	8287859246dae330eef7b3a2a8c71390
a2c31c455e3d0ea3f3bdbea294fe186b	8287859246dae330eef7b3a2a8c71390
ffd2da11d45ed35a039951a8b462e7fb	8287859246dae330eef7b3a2a8c71390
cbefc03cdd1940f37a7033620f8ff69f	cb091aafa00685c4b29954ca13e93bad
a7e071b3de48cec1dd24de6cbe6c7bf1	cb091aafa00685c4b29954ca13e93bad
0182742917720e1b2cf59ff671738253	cb091aafa00685c4b29954ca13e93bad
d76db99cdd16bd0e53d5e07bcf6225c8	cb091aafa00685c4b29954ca13e93bad
4c576d921b99dad80e4bcf9b068c2377	cb091aafa00685c4b29954ca13e93bad
bbbb086d59122dbb940740d6bac65976	cb091aafa00685c4b29954ca13e93bad
863e7a3d6d4a74739bca7dd81db5d51f	cb091aafa00685c4b29954ca13e93bad
cf6a93131b0349f37afeb9319b802136	b04e875801af3b7b787cde914be2aaed
53a5da370321dac39033a5fe6af13e77	b04e875801af3b7b787cde914be2aaed
c5f4e658dfe7b7af3376f06d7cd18a2a	b04e875801af3b7b787cde914be2aaed
0959583c7f421c0bb8adb20e8faeeea1	e1e5ca54159d43c9400d33fdff6ac193
4dde2c290e3ee11bd3bd1ecd27d7039a	e1e5ca54159d43c9400d33fdff6ac193
91abd5e520ec0a40ce4360bfd7c5d573	e1e5ca54159d43c9400d33fdff6ac193
7df470ec0292985d8f0e37aa6c2b38d5	e1e5ca54159d43c9400d33fdff6ac193
e3e9ccd75f789b9689913b30cb528be0	cc02ce2d003fd86ba60f8688e6c40b97
d908b6b9019639bced6d1e31463eea85	cc02ce2d003fd86ba60f8688e6c40b97
240e556541427d81f4ed1eda86f33ad3	cc02ce2d003fd86ba60f8688e6c40b97
707270d99f92250a07347773736df5cc	de64d3821b97e63cf8800dda1e32ee53
6916ed9292a811c895e259c542af0e8a	de64d3821b97e63cf8800dda1e32ee53
a45ff5de3a96b103a192f1f133d0b0cf	de64d3821b97e63cf8800dda1e32ee53
ceffa7550e5d24a8c808d3516b5d6432	de64d3821b97e63cf8800dda1e32ee53
58bbd6135961e3d837bacceb3338f082	1fef5be89b79c6e282d1af946a3bd662
304d29d27816ec4f69c7b1ba5836c57a	b8f41d89b2d67b4b86379d236b2492aa
fdcfaa5f48035ad96752731731ae941a	9fe5ff8e93ce19ca4b27d5267ad7bfb3
dd15d5adf6349f5ca53e7a2641d41ab7	9946f5f348ac677113592c05b1b3905b
b9ffbdbbe63789cc6fa9ee2548a1b2ed	de64d3821b97e63cf8800dda1e32ee53
198445c0bbe110ff65ac5ef88f026aff	de64d3821b97e63cf8800dda1e32ee53
b615ea28d44d2e863a911ed76386b52a	de64d3821b97e63cf8800dda1e32ee53
a20050efc491a9784b5cced21116ba68	de64d3821b97e63cf8800dda1e32ee53
8791e43a8287ccbc21f61be21e90ce43	de64d3821b97e63cf8800dda1e32ee53
3fae5bf538a263e96ff12986bf06b13f	de64d3821b97e63cf8800dda1e32ee53
210e99a095e594f2547e1bb8a9ac6fa7	de64d3821b97e63cf8800dda1e32ee53
024e91d84c3426913db8367f4df2ceb3	de64d3821b97e63cf8800dda1e32ee53
6ffa656be5ff3db085578f54a05d4ddb	de64d3821b97e63cf8800dda1e32ee53
073f87af06b8d8bc561bb3f74e5f714f	de64d3821b97e63cf8800dda1e32ee53
64a25557d4bf0102cd8f60206c460595	de64d3821b97e63cf8800dda1e32ee53
07d82d98170ab334bc66554bafa673cf	2917a0b7da3498cad2a82a57e509346e
ddae1d7419331078626bc217b23ea8c7	2917a0b7da3498cad2a82a57e509346e
71b6971b6323b97f298af11ed5455e55	74b2dd70f761e31a1e0860fe18f8cb55
5629d465ed80efff6e25b8775b98c2d1	74b2dd70f761e31a1e0860fe18f8cb55
20de83abafcb071d854ca5fd57dec0e8	74b2dd70f761e31a1e0860fe18f8cb55
56bf60ca682b8f68e8843ad8a55c6b17	74b2dd70f761e31a1e0860fe18f8cb55
aa98c9e445775e7c945661e91cf7e7aa	3b23d8e33c40737f5ca4b3a0fbb54542
efe9ed664a375d10f96359977213d620	3b23d8e33c40737f5ca4b3a0fbb54542
e20976feda6d915a74c751cbf488a241	3b23d8e33c40737f5ca4b3a0fbb54542
a30c1309e683fcf26c104b49227d2220	3b23d8e33c40737f5ca4b3a0fbb54542
7c7e63c9501a790a3134392e39c3012e	3d3cf571367952ee016599bba2ef18cb
7bc374006774a2eda5288fea8f1872e3	3d3cf571367952ee016599bba2ef18cb
2e4e6a5f485b2c7e22f9974633c2b900	3d3cf571367952ee016599bba2ef18cb
baceebebc179d3cdb726f5cbfaa81dfe	3d3cf571367952ee016599bba2ef18cb
f986b00063e79f7c061f40e6cfbbd039	aac480b69f1fe6472ffe7880c8ead350
d908b6b9019639bced6d1e31463eea85	aac480b69f1fe6472ffe7880c8ead350
384e94f762d3a408cd913c14b19ac5e0	aac480b69f1fe6472ffe7880c8ead350
4900e24b2d0a0c5e06cf3db8b0638800	f8bb8ae77ca110cf00ebb5af1d495203
fcc491ba532309d8942df543beaec67e	f8bb8ae77ca110cf00ebb5af1d495203
c833c98be699cd7828a5106a37d12c2e	c61c9363d160c5f94193056388d9ced9
6f60a61fcc05cb4d42c81ade04392cfc	c61c9363d160c5f94193056388d9ced9
98e8599d1486fadca0bf7aa171400dd8	9bbe76536451d9ad44018b24d51c58aa
5dd5b236a364c53feb6db53d1a6a5ab9	9bbe76536451d9ad44018b24d51c58aa
010fb41a1a7714387391d5ea1ecdfaf7	9bbe76536451d9ad44018b24d51c58aa
05bea3ed3fcd45441c9c6af3a2d9952d	9bbe76536451d9ad44018b24d51c58aa
6f60a61fcc05cb4d42c81ade04392cfc	220352d001b221b28a0dff0fbd20f77c
ac61757d33fc8563eb2409ed08e21974	e87aa14aa70c2745548e891915c77ab4
9d1e68b7debd0c8dc86d5d6500884ab4	e87aa14aa70c2745548e891915c77ab4
218d618a041c057d0e05799670e7e2c8	75560c8161a6cccdfbd7a8b59332b792
fcc491ba532309d8942df543beaec67e	75560c8161a6cccdfbd7a8b59332b792
0da2e7fa0ba90f4ae031b0d232b8a57a	87c20c746bae110cc55c3d32414037df
53199d92b173437f0207a916e8bcc23a	87c20c746bae110cc55c3d32414037df
b36eb6a54154f7301f004e1e61c87ce8	87c20c746bae110cc55c3d32414037df
1629fa6d4b8adb36b0e4a245b234b826	74480c2ba717722022d58038ab1bcd44
270fb708bd03433e554e0d7345630c8e	74480c2ba717722022d58038ab1bcd44
e039d55ed63a723001867bc4eb842c00	ebaeb9fa7d6d4de00d7573942a9f9e78
f44f1e343975f5157f3faf9184bc7ade	ebaeb9fa7d6d4de00d7573942a9f9e78
1e986acf38de5f05edc2c42f4a49d37e	ebaeb9fa7d6d4de00d7573942a9f9e78
3cb077e20dabc945228ea58813672973	ebaeb9fa7d6d4de00d7573942a9f9e78
13d81f0ed06478714344fd0f1a6a81bb	7459412d1907ec1a87e7a5246b27cd00
b615ea28d44d2e863a911ed76386b52a	7459412d1907ec1a87e7a5246b27cd00
05c87189f6c230c90bb1693567233100	7459412d1907ec1a87e7a5246b27cd00
f4b526ea92d3389d318a36e51480b4c8	7459412d1907ec1a87e7a5246b27cd00
3929665297ca814b966cb254980262cb	7459412d1907ec1a87e7a5246b27cd00
fbc2b3cebe54dd00b53967c5cf4b9192	7459412d1907ec1a87e7a5246b27cd00
644f6462ec9801cdc932e5c8698ee7f9	7459412d1907ec1a87e7a5246b27cd00
dbf1b3eb1f030affb41473a8fa69bc0c	7459412d1907ec1a87e7a5246b27cd00
61725742f52de502605eadeac19b837b	7459412d1907ec1a87e7a5246b27cd00
2fb81ca1d0a935be4cb49028268baa3f	7459412d1907ec1a87e7a5246b27cd00
8734f7ff367f59fc11ad736e63e818f9	9f07b2ac339c32524557ba186f68b2ef
98aa80527e97026656ec54cdd0f94dff	9f07b2ac339c32524557ba186f68b2ef
430a03604913a64c33f460ec6f854c36	9f07b2ac339c32524557ba186f68b2ef
319480a02920dc261209240eed190360	9f07b2ac339c32524557ba186f68b2ef
4ca1c3ed413577a259e29dfa053f99db	9f07b2ac339c32524557ba186f68b2ef
2eed213e6871d0e43cc061b109b1abd4	9f07b2ac339c32524557ba186f68b2ef
fdedcd75d695d1c0eb790a5ee3ba90b5	9f07b2ac339c32524557ba186f68b2ef
ed9b92eb1706415c42f88dc91284da8a	9f07b2ac339c32524557ba186f68b2ef
fb1afbea5c0c2e23396ef429d0e42c52	9f07b2ac339c32524557ba186f68b2ef
316a289ef71c950545271754abf583f1	9f07b2ac339c32524557ba186f68b2ef
33b3bfc86d7a57e42aa30e7d1c2517be	9f07b2ac339c32524557ba186f68b2ef
8351282db025fc2222fc61ec8dd1df23	9f07b2ac339c32524557ba186f68b2ef
60eb202340e8035af9e96707f85730e5	9f07b2ac339c32524557ba186f68b2ef
d2f79e6a931cd5b5acd5f3489dece82a	9f07b2ac339c32524557ba186f68b2ef
3189b8c5e007c634d7e28ef93be2b774	9f07b2ac339c32524557ba186f68b2ef
1dc7d7d977193974deaa993eb373e714	d7010a272554c22fa8d53efc81046bce
51cb62b41cd9deaaa2dd98c773a09ebb	d7010a272554c22fa8d53efc81046bce
b12daab6c83b1a45aa32cd9c2bc78360	d7010a272554c22fa8d53efc81046bce
9722f54adb556b548bb9ecce61a4d167	d7010a272554c22fa8d53efc81046bce
8e1cfd3bf5a7f326107f82f8f28649be	1fef5be89b79c6e282d1af946a3bd662
33f03dd57f667d41ac77c6baec352a81	c4968fa5ec8f129c7fd49ffa5cb64d6e
eb999c99126a456f9db3c5d3b449fa7f	c61c9363d160c5f94193056388d9ced9
bc5daaf162914ff1200789d069256d36	a17fea2a7b6cf4685417132ff574fd0a
9a8d3efa0c3389083df65f4383b155fb	a17fea2a7b6cf4685417132ff574fd0a
f2a863a08c3e22cc942264ac4bc606e3	a17fea2a7b6cf4685417132ff574fd0a
2569a68a03a04a2cd73197d2cc546ff2	a17fea2a7b6cf4685417132ff574fd0a
bf2c8729bf5c149067d8e978ea3dcd32	a17fea2a7b6cf4685417132ff574fd0a
5ab944fac5f6a0d98dc248a879ec70ff	a17fea2a7b6cf4685417132ff574fd0a
66597873e0974fb365454a5087291094	a17fea2a7b6cf4685417132ff574fd0a
01bcfac216d2a08cd25930234e59f1a1	a17fea2a7b6cf4685417132ff574fd0a
b454fdfc910ad8f6b7509072cf0b4031	a17fea2a7b6cf4685417132ff574fd0a
951af0076709a6da6872f9cdf41c852b	a17fea2a7b6cf4685417132ff574fd0a
0e609404e53b251f786b41b7be93cc19	a17fea2a7b6cf4685417132ff574fd0a
b1006928600959429230393369fe43b6	a17fea2a7b6cf4685417132ff574fd0a
4e74055927fd771c2084c92ca2ae56a7	a17fea2a7b6cf4685417132ff574fd0a
a753c3945400cd54c7ffd35fc07fe031	a17fea2a7b6cf4685417132ff574fd0a
8af17e883671377a23e5b8262de11af4	a17fea2a7b6cf4685417132ff574fd0a
d1fded22db9fc8872e86fff12d511207	a17fea2a7b6cf4685417132ff574fd0a
c526681b295049215e5f1c2066639f4a	a17fea2a7b6cf4685417132ff574fd0a
3969716fc4acd0ec0c39c8a745e9459a	a17fea2a7b6cf4685417132ff574fd0a
b7b99e418cff42d14dbf2d63ecee12a8	a17fea2a7b6cf4685417132ff574fd0a
96b4b857b15ae915ce3aa5e406c99cb4	a17fea2a7b6cf4685417132ff574fd0a
8b5a84ba35fa73f74df6f2d5a788e109	a17fea2a7b6cf4685417132ff574fd0a
57f622908a4d6c381241a1293d894c88	a17fea2a7b6cf4685417132ff574fd0a
48438b67b2ac4e5dc9df6f3723fd4ccd	a17fea2a7b6cf4685417132ff574fd0a
56a5afe00fae48b02301860599898e63	a17fea2a7b6cf4685417132ff574fd0a
3e8d4b3893a9ebbbd86e648c90cbbe63	a17fea2a7b6cf4685417132ff574fd0a
c46e8abb68aae0bcdc68021a46f71a65	a17fea2a7b6cf4685417132ff574fd0a
e4f74be13850fc65559a3ed855bf35a8	a17fea2a7b6cf4685417132ff574fd0a
7b52c8c4a26e381408ee64ff6b98e231	a17fea2a7b6cf4685417132ff574fd0a
278af3c810bb9de0f355ce115b5a2f54	a17fea2a7b6cf4685417132ff574fd0a
5c61f833c2fb87caab0a48e4c51fa629	a17fea2a7b6cf4685417132ff574fd0a
2859f0ed0630ecc1589b6868fd1dde41	a17fea2a7b6cf4685417132ff574fd0a
c5068f914571c27e04cd66a4ec5c1631	a17fea2a7b6cf4685417132ff574fd0a
8b3f40e0243e2307a1818d3f456df153	a17fea2a7b6cf4685417132ff574fd0a
8b0cfde05d166f42a11a01814ef7fa86	a17fea2a7b6cf4685417132ff574fd0a
c0118be307a26886822e1194e8ae246d	a17fea2a7b6cf4685417132ff574fd0a
a66394e41d764b4c5646446a8ba2028b	a17fea2a7b6cf4685417132ff574fd0a
e9e0664816c35d64f26fc1382708617b	a17fea2a7b6cf4685417132ff574fd0a
f29f7213d1c86c493ca7b4045e5255a9	a17fea2a7b6cf4685417132ff574fd0a
65f889eb579641f6e5f58b5a48f3ec12	a17fea2a7b6cf4685417132ff574fd0a
fc239fd89fd7c9edbf2bf27d1d894bc0	a17fea2a7b6cf4685417132ff574fd0a
24701da4bd9d3ae0e64d263b72ad20e8	a17fea2a7b6cf4685417132ff574fd0a
031d6cc33621c51283322daf69e799f5	a17fea2a7b6cf4685417132ff574fd0a
a8ace0f003d8249d012c27fe27b258b5	a17fea2a7b6cf4685417132ff574fd0a
255661921f4ad57d02b1de9062eb6421	a17fea2a7b6cf4685417132ff574fd0a
5d53b2be2fe7e27daa27b94724c3b6de	a17fea2a7b6cf4685417132ff574fd0a
57126705faf40e4b5227c8a0302d13b2	a17fea2a7b6cf4685417132ff574fd0a
b9fd9676338e36e6493489ec5dc041fe	a17fea2a7b6cf4685417132ff574fd0a
df99cee44099ff57acbf7932670614dd	5379b1daf8079521f6c7de205e37f878
6b141e284f88f656b776148cde8e019c	5379b1daf8079521f6c7de205e37f878
b84cdd396f01275b63bdaf7f61ed5a43	5379b1daf8079521f6c7de205e37f878
7a43dd4c2bb9bea14a95ff3acd4dfb18	5379b1daf8079521f6c7de205e37f878
2db1850a4fe292bd2706ffd78dbe44b9	1fef5be89b79c6e282d1af946a3bd662
5958cd5ce011ea83c06cb921b1c85bb3	568359348ea05d7114e3d796d7df55f2
df24a5dd8a37d3d203952bb787069ea2	568359348ea05d7114e3d796d7df55f2
cf6a93131b0349f37afeb9319b802136	568359348ea05d7114e3d796d7df55f2
ec5c65bfe530446b696f04e51aa19201	568359348ea05d7114e3d796d7df55f2
a7eda23a9421a074fe5ec966810018d7	568359348ea05d7114e3d796d7df55f2
ffd2da11d45ed35a039951a8b462e7fb	568359348ea05d7114e3d796d7df55f2
191bab5800bd381ecf16485f91e85bc3	568359348ea05d7114e3d796d7df55f2
9d74605e4b1d19d83992a991230e89ef	568359348ea05d7114e3d796d7df55f2
ca54e4f7704e7b8374d0968143813fe6	568359348ea05d7114e3d796d7df55f2
c245b4779defd5c69ffebbfdd239dd1b	568359348ea05d7114e3d796d7df55f2
6b157916b43b09df5a22f658ccb92b64	568359348ea05d7114e3d796d7df55f2
67cd9b4b7b33511f30e85e21b2d3b204	568359348ea05d7114e3d796d7df55f2
fcc491ba532309d8942df543beaec67e	7b5a790fbc109d0dadb7418b17bf24e8
01bcfac216d2a08cd25930234e59f1a1	7b5a790fbc109d0dadb7418b17bf24e8
eef7d6da9ba6d0bed2078a5f253f4cfc	5e6a61fa17bf86a738024508581f11d4
ad51cbe70d798b5aec08caf64ce66094	5e6a61fa17bf86a738024508581f11d4
3480c10b83b05850ec18b6372e235139	fe36a187902de9cf1aa5f42477fa1318
6a4e8bab29666632262eb20c336e85e2	fe36a187902de9cf1aa5f42477fa1318
3480c10b83b05850ec18b6372e235139	208af572d4212c8b20492f11ca9b8b54
13291409351c97f8c187790ece4f5a97	208af572d4212c8b20492f11ca9b8b54
218d618a041c057d0e05799670e7e2c8	208af572d4212c8b20492f11ca9b8b54
4900e24b2d0a0c5e06cf3db8b0638800	208af572d4212c8b20492f11ca9b8b54
dddfdb5f2d7991d93f0f97dce1ef0f45	208af572d4212c8b20492f11ca9b8b54
818ce28daba77cbd2c4235548400ffb2	208af572d4212c8b20492f11ca9b8b54
37e2e92ced5d525b3e79e389935cd669	f8aec5c8465f9b8649a99873c0a44443
76aebba2f63483b6184f06f0a2602643	9fe5ff8e93ce19ca4b27d5267ad7bfb3
fcc491ba532309d8942df543beaec67e	208af572d4212c8b20492f11ca9b8b54
3123e3df482127074cdd5f830072c898	208af572d4212c8b20492f11ca9b8b54
bca8f048f2c5ff787950eb1ba088c70e	0704b2bfdcfaed5225554f023a7fbf48
d908b6b9019639bced6d1e31463eea85	0704b2bfdcfaed5225554f023a7fbf48
51cb62b41cd9deaaa2dd98c773a09ebb	0704b2bfdcfaed5225554f023a7fbf48
c27297705354ef77feb349e949d2e19e	5e38483d273e5a8b6f777f8017bedf62
e6624ef1aeab84f521056a142b5b2d12	d3c946cf8862b847404204ab7d0cfc39
d76db99cdd16bd0e53d5e07bcf6225c8	d3c946cf8862b847404204ab7d0cfc39
c8bc4f15477ea3131abb1a3f0649fac2	d3c946cf8862b847404204ab7d0cfc39
9133f1146bbdd783f34025bf90a8e148	d3c946cf8862b847404204ab7d0cfc39
cd0bc2c8738b2fef2d78d197223b17d5	183863a44c8750e908c83bd2d1c194f8
e039d55ed63a723001867bc4eb842c00	183863a44c8750e908c83bd2d1c194f8
73cb08d143f893e645292dd04967f526	183863a44c8750e908c83bd2d1c194f8
5324a886a2667283dbfe7f7974ff6fc0	183863a44c8750e908c83bd2d1c194f8
28c5f9ffd175dcd53aa3e9da9b00dde7	183863a44c8750e908c83bd2d1c194f8
b798aa74946ce75baee5806352e96272	183863a44c8750e908c83bd2d1c194f8
6315887dd67ff4f91d51e956b06a3878	183863a44c8750e908c83bd2d1c194f8
eb3a9fb71b84790e50acd81cc1aa4862	bc1f2650c6129b22a2cc63f2a90b5597
53a5da370321dac39033a5fe6af13e77	57c286b274d23dc513ddfd16dd21281e
cfe122252751e124bfae54a7323bf02d	57c286b274d23dc513ddfd16dd21281e
3577f7160794aa4ba4d79d0381aefdb1	8be553b6dfad10eac5fed512ef6c2c95
933c8182650ca4ae087544beff5bb52d	8be553b6dfad10eac5fed512ef6c2c95
e3de2cf8ac892a0d8616eefc4a4f59bd	8be553b6dfad10eac5fed512ef6c2c95
623c5a1c99aceaf0b07ae233d1888e0a	8be553b6dfad10eac5fed512ef6c2c95
c2ab38206dce633f15d66048ad744f03	10c5ac379805443742025d6cf619891e
20de83abafcb071d854ca5fd57dec0e8	10c5ac379805443742025d6cf619891e
cfe122252751e124bfae54a7323bf02d	10c5ac379805443742025d6cf619891e
e039d55ed63a723001867bc4eb842c00	10c5ac379805443742025d6cf619891e
852c0b6d5b315c823cdf0382ca78e47f	10c5ac379805443742025d6cf619891e
22c2fc8a3a81503d40d4e532ac0e22ab	10c5ac379805443742025d6cf619891e
482818d4eb4ca4c709dcce4cc2ab413d	10c5ac379805443742025d6cf619891e
ec788cc8478763d79a18160a99dbb618	10c5ac379805443742025d6cf619891e
d2f62cd276ef7cab5dcf9218d68f5bcf	10c5ac379805443742025d6cf619891e
e71bd61e28ae2a584cb17ed776075b55	10c5ac379805443742025d6cf619891e
49a41ffa9c91f7353ec37cda90966866	10c5ac379805443742025d6cf619891e
1c13f340d154b44e41c996ec08d76749	10c5ac379805443742025d6cf619891e
d5b95b21ce47502980eebfcf8d2913e0	10c5ac379805443742025d6cf619891e
0b6bcec891d17cd7858525799c65da27	10c5ac379805443742025d6cf619891e
0feeee5d5e0738c1929bf064b184409b	ef925858ea6d5d91b5ca4b3440fa1ad1
8cd1cca18fb995d268006113a3d6e4bf	ef925858ea6d5d91b5ca4b3440fa1ad1
1fd7fc9c73539bee88e1ec137b5f9ad2	ef925858ea6d5d91b5ca4b3440fa1ad1
869bb972f8bef83979774fa123c56a4e	ef925858ea6d5d91b5ca4b3440fa1ad1
e039d55ed63a723001867bc4eb842c00	ef925858ea6d5d91b5ca4b3440fa1ad1
cba8cb3c568de75a884eaacde9434443	ef925858ea6d5d91b5ca4b3440fa1ad1
19cbbb1b1e68c42f3415fb1654b2d390	ef925858ea6d5d91b5ca4b3440fa1ad1
f44f1e343975f5157f3faf9184bc7ade	ef925858ea6d5d91b5ca4b3440fa1ad1
1e986acf38de5f05edc2c42f4a49d37e	ef925858ea6d5d91b5ca4b3440fa1ad1
10627ac0e35cfed4a0ca5b97a06b9d9f	ef925858ea6d5d91b5ca4b3440fa1ad1
b834eadeaf680f6ffcb13068245a1fed	ef925858ea6d5d91b5ca4b3440fa1ad1
1ec58ca10ed8a67b1c7de3d353a2885b	ef925858ea6d5d91b5ca4b3440fa1ad1
8f523603c24072fb8ccb547503ee4c0f	ef925858ea6d5d91b5ca4b3440fa1ad1
43a4893e6200f462bb9fe406e68e71c0	ef925858ea6d5d91b5ca4b3440fa1ad1
9c31bcca97bb68ec33c5a3ead4786f3e	ef925858ea6d5d91b5ca4b3440fa1ad1
c445544f1de39b071a4fca8bb33c2772	ef925858ea6d5d91b5ca4b3440fa1ad1
29891bf2e4eff9763aef15dc862c373f	ef925858ea6d5d91b5ca4b3440fa1ad1
c8fbeead5c59de4e8f07ab39e7874213	ef925858ea6d5d91b5ca4b3440fa1ad1
8fa1a366d4f2e520bc9354658c4709f1	ef925858ea6d5d91b5ca4b3440fa1ad1
812f48abd93f276576541ec5b79d48a2	ef925858ea6d5d91b5ca4b3440fa1ad1
d29c61c11e6b7fb7df6d5135e5786ee1	ef925858ea6d5d91b5ca4b3440fa1ad1
7013a75091bf79f04f07eecc248f8ee6	ef925858ea6d5d91b5ca4b3440fa1ad1
58e42b779d54e174aad9a9fb79e7ebbc	ef925858ea6d5d91b5ca4b3440fa1ad1
67493f858802a478bfe539c8e30a7e44	ef925858ea6d5d91b5ca4b3440fa1ad1
f7910d943cc815a4a0081668ac2119b2	ef925858ea6d5d91b5ca4b3440fa1ad1
955a5cfd6e05ed30eec7c79d2371ebcf	ef925858ea6d5d91b5ca4b3440fa1ad1
03201e85fc6aa56d2cb9374e84bf52ca	ef925858ea6d5d91b5ca4b3440fa1ad1
e7a227585002db9fee2f0ed56ee5a59f	ef925858ea6d5d91b5ca4b3440fa1ad1
bc111d75a59fe7191a159fd4ee927981	ef925858ea6d5d91b5ca4b3440fa1ad1
017e06f9b9bccafa230a81b60ea34c46	ef925858ea6d5d91b5ca4b3440fa1ad1
844de407cd83ea1716f1ff57ea029285	3e55fe6e09f2f7eaacd4052a76bcfb01
4e9b4bdef9478154fc3ac7f5ebfb6418	3e55fe6e09f2f7eaacd4052a76bcfb01
3c2234a7ce973bc1700e0c743d6a819c	3e55fe6e09f2f7eaacd4052a76bcfb01
9459200394693a7140196f07e6e717fd	3e55fe6e09f2f7eaacd4052a76bcfb01
ee36fdf153967a0b99d3340aadeb4720	e692c8859fbcd0611cde731120ba09ad
f2856ad30734c5f838185cc08f71b1e4	e692c8859fbcd0611cde731120ba09ad
53a5da370321dac39033a5fe6af13e77	eb5b5cec91e306a1428f52f89ef1c2ab
781c745a0d6b02cdecadf2e44d445d1a	eb5b5cec91e306a1428f52f89ef1c2ab
b02ba5a5e65487122c2c1c67351c3ea0	eb5b5cec91e306a1428f52f89ef1c2ab
0ae3b7f3ca9e9ddca932de0f0df00f8a	45e481facaabaefb537716312cbb9f67
2e6df049342acfb3012ac702ed93feb4	1fef5be89b79c6e282d1af946a3bd662
048d40092f9bd3c450e4bdeeff69e8c3	ef925858ea6d5d91b5ca4b3440fa1ad1
0e609404e53b251f786b41b7be93cc19	45e481facaabaefb537716312cbb9f67
b1006928600959429230393369fe43b6	45e481facaabaefb537716312cbb9f67
478aedea838b8b4a0936b129a4c6e853	45e481facaabaefb537716312cbb9f67
0f9fb8452cc5754f83e084693d406721	e58b815b0e0ab96b035629ec796eb579
b66781a52770d78b260f15d125d1380b	e58b815b0e0ab96b035629ec796eb579
f2a863a08c3e22cc942264ac4bc606e3	e58b815b0e0ab96b035629ec796eb579
35bde21520f1490f0333133a9ae5b4fc	dc741cac8e46d127f4ce2524e5dbefa0
c2ab38206dce633f15d66048ad744f03	dc741cac8e46d127f4ce2524e5dbefa0
b02ba5a5e65487122c2c1c67351c3ea0	dc741cac8e46d127f4ce2524e5dbefa0
60a105e79a86c8197cec9f973576874b	dc741cac8e46d127f4ce2524e5dbefa0
8987e9c300bc2fc5e5cf795616275539	dc741cac8e46d127f4ce2524e5dbefa0
ba5e6ab17c7e5769b11f98bfe8b692d0	dc741cac8e46d127f4ce2524e5dbefa0
eb0a191797624dd3a48fa681d3061212	dc741cac8e46d127f4ce2524e5dbefa0
13de0a41f18c0d71f5f6efff6080440f	dc741cac8e46d127f4ce2524e5dbefa0
5885f60f8c705921cf7411507b8cadc0	dc741cac8e46d127f4ce2524e5dbefa0
f31ba1d770aac9bc0dcee3fc15c60a46	dc741cac8e46d127f4ce2524e5dbefa0
a8ace0f003d8249d012c27fe27b258b5	dc741cac8e46d127f4ce2524e5dbefa0
ad759a3d4f679008ffdfb07cdbda2bb0	89733d277fcf6ee00cb571b2e1d72019
02677b661c84417492e1c1cb0b0563b2	89733d277fcf6ee00cb571b2e1d72019
0feeee5d5e0738c1929bf064b184409b	89733d277fcf6ee00cb571b2e1d72019
123131d2d4bd15a0db8f07090a383157	89733d277fcf6ee00cb571b2e1d72019
34fd3085dc67c39bf1692938cf3dbdd9	89733d277fcf6ee00cb571b2e1d72019
436f76ddf806e8c3cbdc9494867d0f79	89733d277fcf6ee00cb571b2e1d72019
2c5705766131b389fa1d88088f1bb8a8	89733d277fcf6ee00cb571b2e1d72019
e63a014f1310b8c7cbe5e2b0fd66f638	89733d277fcf6ee00cb571b2e1d72019
541fa0085b17ef712791151ca285f1a7	89733d277fcf6ee00cb571b2e1d72019
0d8ef82742e1d5de19b5feb5ecb3aed3	89733d277fcf6ee00cb571b2e1d72019
7cb94a8039f617f505df305a1dc2cc61	89733d277fcf6ee00cb571b2e1d72019
55696bac6cdd14d47cbe7940665e21d3	89733d277fcf6ee00cb571b2e1d72019
e039d55ed63a723001867bc4eb842c00	89733d277fcf6ee00cb571b2e1d72019
26c2bb18f3a9a0c6d1392dae296cfea7	89733d277fcf6ee00cb571b2e1d72019
6af2c726b2d705f08d05a7ee9509916e	89733d277fcf6ee00cb571b2e1d72019
99761fad57f035550a1ca48e47f35157	89733d277fcf6ee00cb571b2e1d72019
93aa5f758ad31ae4b8ac40044ba6c110	89733d277fcf6ee00cb571b2e1d72019
96aa953534221db484e6ec75b64fcc4d	89733d277fcf6ee00cb571b2e1d72019
f9ff0bcbb45bdf8a67395fa0ab3737b5	89733d277fcf6ee00cb571b2e1d72019
36233ed8c181dfacc945ad598fb4f1a1	7dc88a28ee5d7dbd7a1011fd098cd6ab
a99dca5593185c498b63a5eed917bd4f	7dc88a28ee5d7dbd7a1011fd098cd6ab
e093d52bb2d4ff4973e72f6eb577714b	7dc88a28ee5d7dbd7a1011fd098cd6ab
9a6c0d8ea613c5b002ff958275318b08	7dc88a28ee5d7dbd7a1011fd098cd6ab
88726e1a911181e20cf8be52e1027f26	7dc88a28ee5d7dbd7a1011fd098cd6ab
9b7d722b58370498cd39104b2d971978	7dc88a28ee5d7dbd7a1011fd098cd6ab
93299af7c9e3c63c7b3d9bb2242c9d6b	7dc88a28ee5d7dbd7a1011fd098cd6ab
9ff04a674682ece6ee93ca851db56387	7dc88a28ee5d7dbd7a1011fd098cd6ab
53a5da370321dac39033a5fe6af13e77	7dc88a28ee5d7dbd7a1011fd098cd6ab
9639834b69063b336bb744a537f80772	7dc88a28ee5d7dbd7a1011fd098cd6ab
6e064a31dc53ab956403ec3654c81f1f	7dc88a28ee5d7dbd7a1011fd098cd6ab
7b3ab6743cf8f7ea8491211e3336e41d	7dc88a28ee5d7dbd7a1011fd098cd6ab
d1e0bdb2b2227bdd5e47850eec61f9ea	7dc88a28ee5d7dbd7a1011fd098cd6ab
281eb11c857bbe8b6ad06dc1458e2751	7dc88a28ee5d7dbd7a1011fd098cd6ab
de1e0ed5433f5e95c8f48e18e1c75ff6	7dc88a28ee5d7dbd7a1011fd098cd6ab
e4f13074d445d798488cb00fa0c5fbd4	7dc88a28ee5d7dbd7a1011fd098cd6ab
72b73895941b319645450521aad394e8	7dc88a28ee5d7dbd7a1011fd098cd6ab
cbf6de82cf77ca17d17d293d6d29a2b2	7dc88a28ee5d7dbd7a1011fd098cd6ab
118c9af69a42383387e8ce6ab22867d7	7dc88a28ee5d7dbd7a1011fd098cd6ab
a91887f44d8d9fdcaa401d1c719630d7	7dc88a28ee5d7dbd7a1011fd098cd6ab
5ef02a06b43b002e3bc195b3613b7022	7dc88a28ee5d7dbd7a1011fd098cd6ab
824f75181a2bbd69fb2698377ea8a952	1a2f8d593b063eccd9b1dc3431e01081
ac61757d33fc8563eb2409ed08e21974	1a2f8d593b063eccd9b1dc3431e01081
4db3435be88015c70683b4368d9b313b	1a2f8d593b063eccd9b1dc3431e01081
b0cc1a3a1aee13a213ee73e3d4a2ce70	1a2f8d593b063eccd9b1dc3431e01081
647dadd75e050b230269e43a4fe351e2	1a2f8d593b063eccd9b1dc3431e01081
22aaaebe901de8370917dcc53f53dbf6	1a2f8d593b063eccd9b1dc3431e01081
2799b4abf06a5ec5e262d81949e2d18c	1a2f8d593b063eccd9b1dc3431e01081
efe9ed664a375d10f96359977213d620	1a2f8d593b063eccd9b1dc3431e01081
30a100fe6a043e64ed36abb039bc9130	1a2f8d593b063eccd9b1dc3431e01081
de1e0ed5433f5e95c8f48e18e1c75ff6	1a2f8d593b063eccd9b1dc3431e01081
90802bdf218986ffc70f8a086e1df172	1a2f8d593b063eccd9b1dc3431e01081
bc834c26e0c9279cd3139746ab2881f1	1a2f8d593b063eccd9b1dc3431e01081
dd0e61ab23e212d958112dd06ad0bfd2	1a2f8d593b063eccd9b1dc3431e01081
3cd94848f6ccb600295135e86f1b46a7	1a2f8d593b063eccd9b1dc3431e01081
658a9bbd0e85d854a9e140672a46ce3a	1a2f8d593b063eccd9b1dc3431e01081
a89af36e042b5aa91d6efea0cc283c02	e6adc3e990efe83510bc9e7a483bec1a
eb2743e9025319c014c9011acf1a1679	e6adc3e990efe83510bc9e7a483bec1a
13909e3013727a91ee750bfd8660d7bc	b66fc7effb62197b91e1dacbd7b60f0f
74e8b6c4be8a0f5dd843e2d1d7385a36	b66fc7effb62197b91e1dacbd7b60f0f
2dde74b7ec594b9bd78da66f1c5cafdc	b66fc7effb62197b91e1dacbd7b60f0f
576fea4a0c5425ba382fff5f593a33f1	9295494c6983f977a609c9db84ce25e6
34e927c45cf3ccebb09b006b00f4e02d	9295494c6983f977a609c9db84ce25e6
4545c676e400facbb87cbc7736d90e85	1fef5be89b79c6e282d1af946a3bd662
08f8c67c20c4ba43e8ba6fa771039c94	5e38483d273e5a8b6f777f8017bedf62
08f8c67c20c4ba43e8ba6fa771039c94	10c5ac379805443742025d6cf619891e
dab701a389943f0d407c6e583abef934	ef925858ea6d5d91b5ca4b3440fa1ad1
0f9fb8452cc5754f83e084693d406721	e6adc3e990efe83510bc9e7a483bec1a
c091e33f684c206b73b25417f6640b71	9295494c6983f977a609c9db84ce25e6
0add3cab2a932f085109a462423c3250	aeead547d2a5b453d09a3efdf052c4cf
2569a68a03a04a2cd73197d2cc546ff2	aeead547d2a5b453d09a3efdf052c4cf
852c0b6d5b315c823cdf0382ca78e47f	aeead547d2a5b453d09a3efdf052c4cf
e4b1d8cc71fd9c1fbc40fdc1a1a5d5b3	aeead547d2a5b453d09a3efdf052c4cf
3258eb5f24b395695f56eee13b690da6	5165e8c183dbda4c319239e9f631b6f9
8f7939c28270f3187210641e96a98ba7	5165e8c183dbda4c319239e9f631b6f9
bcf744fa5f256d6c3051dd86943524f6	5165e8c183dbda4c319239e9f631b6f9
3ba296bfb94ad521be221cf9140f8e10	5165e8c183dbda4c319239e9f631b6f9
18e21eae8f909cbb44b5982b44bbf02f	5165e8c183dbda4c319239e9f631b6f9
3438d9050b2bf1e6dc0179818298bd41	5165e8c183dbda4c319239e9f631b6f9
08b84204877dce2a08abce50d9aeceed	dc19b6ddc47a55bc9401384b0ff66260
ca3fecb0d12232d1dd99d0b0d83c39ec	dc19b6ddc47a55bc9401384b0ff66260
b3626b52d8b98e9aebebaa91ea2a2c91	dc19b6ddc47a55bc9401384b0ff66260
347fb42f546e982de2a1027a2544bfd0	dc19b6ddc47a55bc9401384b0ff66260
97724184152a2620b76e2f93902ed679	dc19b6ddc47a55bc9401384b0ff66260
4bffc4178bd669b13ba0d91ea0522899	dc19b6ddc47a55bc9401384b0ff66260
b084dc5276d0211fae267a279e2959f0	dc19b6ddc47a55bc9401384b0ff66260
f66935eb80766ec0c3acee20d40db157	dc19b6ddc47a55bc9401384b0ff66260
cd1c06e4da41121b7362540fbe8cd62c	dc19b6ddc47a55bc9401384b0ff66260
0f9fb8452cc5754f83e084693d406721	f64440cda54890f13a4506f88aa21cd2
fecc75d978ad94aaa4e17b3ff9ded487	f64440cda54890f13a4506f88aa21cd2
e2be3c3c22484d1872c7b225339c0962	f64440cda54890f13a4506f88aa21cd2
3a7e46261a591b3e65d1e7d0b2439b20	f64440cda54890f13a4506f88aa21cd2
11a5f9f425fd6da2d010808e5bf759ab	f64440cda54890f13a4506f88aa21cd2
9d1ecaf46d6433f9dd224111440cfa3b	f64440cda54890f13a4506f88aa21cd2
5fa07e5db79f9a1dccb28d65d6337aa6	f64440cda54890f13a4506f88aa21cd2
71a520b6d0673d926d02651b269cf92c	f64440cda54890f13a4506f88aa21cd2
56b07537df0c44402f5f87a8dcb8402c	f64440cda54890f13a4506f88aa21cd2
05fcf330d8fafb0a1f17ce30ff60b924	f64440cda54890f13a4506f88aa21cd2
386a023bd38fab85cb531824bfe9a879	f64440cda54890f13a4506f88aa21cd2
71ac59780209b4c074690c44a3bba3b7	f64440cda54890f13a4506f88aa21cd2
2054decb2290dbaab1c813fd86cc5f8b	f64440cda54890f13a4506f88aa21cd2
f2a863a08c3e22cc942264ac4bc606e3	f64440cda54890f13a4506f88aa21cd2
34ef35a77324b889aab18380ad34b51a	f64440cda54890f13a4506f88aa21cd2
08b84204877dce2a08abce50d9aeceed	f64440cda54890f13a4506f88aa21cd2
309263122a445662099a3dabce2a4f17	f64440cda54890f13a4506f88aa21cd2
f1022ae1bc6b46d51889e0bb5ea8b64f	f64440cda54890f13a4506f88aa21cd2
cd0bc2c8738b2fef2d78d197223b17d5	f64440cda54890f13a4506f88aa21cd2
6a13b854e05f5ba6d2a0d873546fc32d	f64440cda54890f13a4506f88aa21cd2
c82b23ed65bb8e8229c54e9e94ba1479	f64440cda54890f13a4506f88aa21cd2
91abd5e520ec0a40ce4360bfd7c5d573	f64440cda54890f13a4506f88aa21cd2
07d82d98170ab334bc66554bafa673cf	f64440cda54890f13a4506f88aa21cd2
009f51181eb8c6bb5bb792af9a2fdd07	f64440cda54890f13a4506f88aa21cd2
0a0f6b88354de7afe84b8a07dfadcc26	f64440cda54890f13a4506f88aa21cd2
7d3618373e07c4ce8896006919bbb531	f64440cda54890f13a4506f88aa21cd2
e6cbb2e0653a61e35d26df2bcb6bc4c7	f64440cda54890f13a4506f88aa21cd2
2db1850a4fe292bd2706ffd78dbe44b9	f64440cda54890f13a4506f88aa21cd2
02670bc3f496ce7b1393712f58033f6c	f64440cda54890f13a4506f88aa21cd2
3b544a6f1963395bd3ae0aeebdf1edd8	f64440cda54890f13a4506f88aa21cd2
5f449b146ce14c780eee323dfc5391e8	f64440cda54890f13a4506f88aa21cd2
f8b01df5282702329fcd1cae8877bb5f	f64440cda54890f13a4506f88aa21cd2
1fbd4bcce346fd2b2ffb41f6e767ea84	55446132347a3c2e38997d77b7641eff
11a5f9f425fd6da2d010808e5bf759ab	55446132347a3c2e38997d77b7641eff
aa5e46574bdc6034f4d49540c0c2d1ad	55446132347a3c2e38997d77b7641eff
fd0a7850818a9a642a125b588d83e537	55446132347a3c2e38997d77b7641eff
a2a607567311cb7a5a609146b977f4a9	55446132347a3c2e38997d77b7641eff
2f623623ce7eeb08c30868be121b268a	b0bc16cc4e9fefb213434d718724ec3a
50737756bd539f702d8e6e75cf388a31	b0bc16cc4e9fefb213434d718724ec3a
d2d67d63c28a15822569c5033f26b133	b0bc16cc4e9fefb213434d718724ec3a
333ca835f34af241fe46af8e7a037e17	b0bc16cc4e9fefb213434d718724ec3a
d9c849266ee3ac1463262df200b3aab8	b0bc16cc4e9fefb213434d718724ec3a
8b22cf31089892b4c57361d261bd63f7	b0bc16cc4e9fefb213434d718724ec3a
9436650a453053e775897ef5733e88fe	b0bc16cc4e9fefb213434d718724ec3a
a6c27c0fb9ef87788c1345041e840f95	b0bc16cc4e9fefb213434d718724ec3a
16fe483d0681e0c86177a33e22452e13	b0bc16cc4e9fefb213434d718724ec3a
ef3c0bf190876fd31d5132848e99df61	b0bc16cc4e9fefb213434d718724ec3a
018b60f1dc74563ca02f0a14ee272e4d	b0bc16cc4e9fefb213434d718724ec3a
0cd2b45507cc7c4ead2aaa71c59af730	b0bc16cc4e9fefb213434d718724ec3a
40a259aebdbb405d2dc1d25b05f04989	b0bc16cc4e9fefb213434d718724ec3a
5bd15db3f3bb125cf3222745f4fe383f	b0bc16cc4e9fefb213434d718724ec3a
6cec93398cd662d79163b10a7b921a1b	b0bc16cc4e9fefb213434d718724ec3a
773b5037f85efc8cc0ff3fe0bddf2eb8	b0bc16cc4e9fefb213434d718724ec3a
50d48c9002eb08e248225c1d91732bbc	1fef5be89b79c6e282d1af946a3bd662
e7a227585002db9fee2f0ed56ee5a59f	f8aec5c8465f9b8649a99873c0a44443
8cb8e8679062b574afcb78a983b75a9f	9fe5ff8e93ce19ca4b27d5267ad7bfb3
e8ead85c87ecdab1738db48a10cae6da	9fe5ff8e93ce19ca4b27d5267ad7bfb3
1f56e4b8b8a0da3b8ec5b32970e4b0d8	b0bc16cc4e9fefb213434d718724ec3a
d1ba47339d5eb2254dd3f2cc9f7e444f	b0bc16cc4e9fefb213434d718724ec3a
2460cdf9598c810ac857d6ee9a84935a	b0bc16cc4e9fefb213434d718724ec3a
218ac7d899a995dc53cabe52da9ed678	b0bc16cc4e9fefb213434d718724ec3a
ef297890615f388057b6a2c0a2cbc7ab	1edc35fdd229698b0eeaaa43e7a9c7c5
b66781a52770d78b260f15d125d1380b	1edc35fdd229698b0eeaaa43e7a9c7c5
33b39f2721f79a6bb6bb5e1b2834b0bd	1edc35fdd229698b0eeaaa43e7a9c7c5
ab1d9c0bfcc2843b8ea371f48ed884bb	1edc35fdd229698b0eeaaa43e7a9c7c5
eed35187b83d0f2e0042cf221905163c	1edc35fdd229698b0eeaaa43e7a9c7c5
40fcfb323cd116cf8199485c35012098	1edc35fdd229698b0eeaaa43e7a9c7c5
bf2c8729bf5c149067d8e978ea3dcd32	1edc35fdd229698b0eeaaa43e7a9c7c5
f79485ffe5db7e276e1e625b0be0dbec	1edc35fdd229698b0eeaaa43e7a9c7c5
cabcfb35912d17067131f7d2634ac270	1edc35fdd229698b0eeaaa43e7a9c7c5
3123e3df482127074cdd5f830072c898	1edc35fdd229698b0eeaaa43e7a9c7c5
09c00610ca567a64c82da81cc92cb846	1edc35fdd229698b0eeaaa43e7a9c7c5
246d570b4e453d4cb6e370070c902755	1edc35fdd229698b0eeaaa43e7a9c7c5
5a534330e31944ed43cb6d35f4ad23c7	1edc35fdd229698b0eeaaa43e7a9c7c5
eb999c99126a456f9db3c5d3b449fa7f	b3622323dbe3bef2319de978869871ad
8765cfbf81024c3bd45924fee9159982	b3622323dbe3bef2319de978869871ad
67cc86339b2654a35fcc57da8fc9d33d	b3622323dbe3bef2319de978869871ad
6a4e8bab29666632262eb20c336e85e2	b3622323dbe3bef2319de978869871ad
717ec52870493e8460d6aeddd9b7def8	b3622323dbe3bef2319de978869871ad
fcf66a6d6cfbcb1d4a101213b8500445	b3622323dbe3bef2319de978869871ad
cbf6de82cf77ca17d17d293d6d29a2b2	b3622323dbe3bef2319de978869871ad
5ab944fac5f6a0d98dc248a879ec70ff	b3622323dbe3bef2319de978869871ad
f2ba1f213e72388912791eb68adc3401	b3622323dbe3bef2319de978869871ad
93025091752efa184fd034f285573afe	b3622323dbe3bef2319de978869871ad
4c576d921b99dad80e4bcf9b068c2377	b3622323dbe3bef2319de978869871ad
3b8d2a5ff1b16509377ce52a92255ffe	b3622323dbe3bef2319de978869871ad
f32badb09f6aacb398d3cd690d90a668	b3622323dbe3bef2319de978869871ad
ce14eb923a380597f2aff8b65a742048	b3622323dbe3bef2319de978869871ad
662d17c67dcabc738b8620d3076f7e46	e2a3e66f68255ed0b2a09a64a8ae55fd
b02ba5a5e65487122c2c1c67351c3ea0	06ed605b83d95d5a8488293416ceb999
410044b393ebe6a519fde1bdb26d95e8	06ed605b83d95d5a8488293416ceb999
abca417a801cd10e57e54a3cb6c7444b	06ed605b83d95d5a8488293416ceb999
844de407cd83ea1716f1ff57ea029285	a565f20390f97f9d86df144e14fe83af
f34c903e17cfeea18e499d4627eeb3ec	a565f20390f97f9d86df144e14fe83af
370cde851ed429f1269f243dd714cce2	cfd1317abaf4002e4a091746008541cc
0959583c7f421c0bb8adb20e8faeeea1	cfd1317abaf4002e4a091746008541cc
221fa1624ee1e31376cb112dd2487953	cfd1317abaf4002e4a091746008541cc
df24a5dd8a37d3d203952bb787069ea2	cfd1317abaf4002e4a091746008541cc
ea3f5f97f06167f4819498b4dd56508e	cfd1317abaf4002e4a091746008541cc
14af57131cbbf57afb206c8707fdab6c	cfd1317abaf4002e4a091746008541cc
491801c872c67db465fda0f8f180569d	cfd1317abaf4002e4a091746008541cc
2799b4abf06a5ec5e262d81949e2d18c	cfd1317abaf4002e4a091746008541cc
4be3e31b7598745d0e96c098bbf7a1d7	cfd1317abaf4002e4a091746008541cc
dcdcd2f22b1d5f85fa5dd68fa89e3756	cfd1317abaf4002e4a091746008541cc
0a3a1f7ca8d6cf9b2313f69db9e97eb8	cfd1317abaf4002e4a091746008541cc
79cbf009784a729575e50a3ef4a3b1cc	cfd1317abaf4002e4a091746008541cc
87bd9baf0b0d760d1f0ca9a8e9526161	cfd1317abaf4002e4a091746008541cc
cd3296ec8f7773892de22dfade4f1b04	cfd1317abaf4002e4a091746008541cc
05bea3ed3fcd45441c9c6af3a2d9952d	cfd1317abaf4002e4a091746008541cc
a7eda23a9421a074fe5ec966810018d7	edccf96997e63c09109beba94633a44c
ffd2da11d45ed35a039951a8b462e7fb	edccf96997e63c09109beba94633a44c
60a105e79a86c8197cec9f973576874b	85935a51fb2aec086917a4eeeaef066b
43a4893e6200f462bb9fe406e68e71c0	85935a51fb2aec086917a4eeeaef066b
bcc770bb6652b1b08643d98fd7167f5c	85935a51fb2aec086917a4eeeaef066b
73cb08d143f893e645292dd04967f526	85935a51fb2aec086917a4eeeaef066b
ed783268eca01bff52c0f135643a9ef7	6c6621659485878b572ac37db7d14947
38734dcdff827db1dc3215e23b4e0890	d283cb5c455d03f1f4f0ff7f82c93af6
fcc491ba532309d8942df543beaec67e	d283cb5c455d03f1f4f0ff7f82c93af6
246d570b4e453d4cb6e370070c902755	1bbb8052b10792e8a86d64245d543d7a
384712ec65183407ac811fff2f4c4798	1bbb8052b10792e8a86d64245d543d7a
a76c5f98a56fc03100d6a7936980c563	1bbb8052b10792e8a86d64245d543d7a
66cc7344291ae2a297bf2aa93d886e22	1bbb8052b10792e8a86d64245d543d7a
b615ea28d44d2e863a911ed76386b52a	94154f6cf17963a299f6902ae9c7f3d5
a7eda23a9421a074fe5ec966810018d7	94154f6cf17963a299f6902ae9c7f3d5
867872f29491a6473dae8075c740993e	94154f6cf17963a299f6902ae9c7f3d5
c937fc1b6be0464ec9d17389913871e4	94154f6cf17963a299f6902ae9c7f3d5
e9648f919ee5adda834287bbdf6210fd	94154f6cf17963a299f6902ae9c7f3d5
1f86700588aed0390dd27c383b7fc963	94154f6cf17963a299f6902ae9c7f3d5
faec47e96bfb066b7c4b8c502dc3f649	94154f6cf17963a299f6902ae9c7f3d5
16cf4474c5334c1d9194d003c9fb75c1	94154f6cf17963a299f6902ae9c7f3d5
8e38937886f365bb96aa1c189c63c5ea	94154f6cf17963a299f6902ae9c7f3d5
8ed55fda3382add32869157c5b41ed47	94154f6cf17963a299f6902ae9c7f3d5
4e9dfdbd352f73b74e5e51b12b20923e	94154f6cf17963a299f6902ae9c7f3d5
88059eaa73469bb47bd41c5c3cdd1b50	94154f6cf17963a299f6902ae9c7f3d5
9d5c1f0c1b4d20a534fe35e4e699fb7b	1fef5be89b79c6e282d1af946a3bd662
56e8538c55d35a1c23286442b4bccd26	94154f6cf17963a299f6902ae9c7f3d5
375974f4fad5caae6175c121e38174d0	94154f6cf17963a299f6902ae9c7f3d5
8734f7ff367f59fc11ad736e63e818f9	94154f6cf17963a299f6902ae9c7f3d5
bcf744fa5f256d6c3051dd86943524f6	94154f6cf17963a299f6902ae9c7f3d5
c5f4e658dfe7b7af3376f06d7cd18a2a	c724b600052083fae4765a6a7702ee5f
2187711aeaa2944a707c9eabaa2df72a	c724b600052083fae4765a6a7702ee5f
8791e43a8287ccbc21f61be21e90ce43	c724b600052083fae4765a6a7702ee5f
cd3296ec8f7773892de22dfade4f1b04	c724b600052083fae4765a6a7702ee5f
5f07809ecfce3af23ed5550c6adf0d78	c724b600052083fae4765a6a7702ee5f
5c61f833c2fb87caab0a48e4c51fa629	c724b600052083fae4765a6a7702ee5f
8b3f40e0243e2307a1818d3f456df153	c724b600052083fae4765a6a7702ee5f
c8fbeead5c59de4e8f07ab39e7874213	c724b600052083fae4765a6a7702ee5f
98aa80527e97026656ec54cdd0f94dff	c724b600052083fae4765a6a7702ee5f
8bdd6b50b8ecca33e04837fde8ffe51e	c724b600052083fae4765a6a7702ee5f
18b751c8288c0fabe7b986963016884f	c724b600052083fae4765a6a7702ee5f
30b8affc1afeb50c76ad57d7eda1f08f	c724b600052083fae4765a6a7702ee5f
a8a43e21de5b4d83a6a7374112871079	c724b600052083fae4765a6a7702ee5f
9614cbc86659974da853dee20280b8c4	c724b600052083fae4765a6a7702ee5f
bc2f39d437ff13dff05f5cfda14327cc	c724b600052083fae4765a6a7702ee5f
39530e3fe26ee7c557392d479cc9c93f	c724b600052083fae4765a6a7702ee5f
537e5aa87fcfb168be5c953d224015ff	c724b600052083fae4765a6a7702ee5f
80d331992feb02627ae8b30687c7bb78	c724b600052083fae4765a6a7702ee5f
f6eb4364ba53708b24a4141962feb82e	c724b600052083fae4765a6a7702ee5f
2cd225725d4811d813a5ea1b701db0db	c724b600052083fae4765a6a7702ee5f
2f6fc683428eb5f8b22cc5021dc9d40d	c724b600052083fae4765a6a7702ee5f
2d5a306f74749cc6cbe9b6cd47e73162	c724b600052083fae4765a6a7702ee5f
dba84ece8f49717c47ab72acc3ed2965	c724b600052083fae4765a6a7702ee5f
559314721edf178fa138534f7a1611b9	c724b600052083fae4765a6a7702ee5f
d192d350b6eace21e325ecf9b0f1ebd1	c724b600052083fae4765a6a7702ee5f
d6a020f7b50fb4512fd3c843af752809	c724b600052083fae4765a6a7702ee5f
73f4b98d80efb8888a2b32073417e21e	c724b600052083fae4765a6a7702ee5f
711a7acac82d7522230e3c7d0efc3f89	c724b600052083fae4765a6a7702ee5f
1506aeeb8c3a699b1e3c87db03156428	c724b600052083fae4765a6a7702ee5f
4f58423d9f925c8e8bd73409926730e8	c724b600052083fae4765a6a7702ee5f
96390e27bc7e2980e044791420612545	c724b600052083fae4765a6a7702ee5f
c1e8b6d7a1c20870d5955bcdc04363e4	c724b600052083fae4765a6a7702ee5f
5bb416e14ac19276a4b450d343e4e981	c724b600052083fae4765a6a7702ee5f
b9fd9676338e36e6493489ec5dc041fe	c724b600052083fae4765a6a7702ee5f
faec47e96bfb066b7c4b8c502dc3f649	cb4c2743c35bb374ab32d475ce8cfafe
0c31e51349871cfb59cfbfaaed82eb18	cb4c2743c35bb374ab32d475ce8cfafe
41dabe0c59a3233e3691f3c893eb789e	cb4c2743c35bb374ab32d475ce8cfafe
96390e27bc7e2980e044791420612545	1845ce3f5f191d7265d512beb6be1708
781734c0e9c01b14adc3a78a4c262d83	1845ce3f5f191d7265d512beb6be1708
d908b6b9019639bced6d1e31463eea85	e6af11cd729e7b81d4f40453fff9c7f2
6db22194a183d7da810dcc29ea360c17	e6af11cd729e7b81d4f40453fff9c7f2
6ca47c71d99f608d4773b95f9b859142	22be8d2b712105db37cc765fae61323e
b14521c0461b445a7ac2425e922c72df	22be8d2b712105db37cc765fae61323e
191bab5800bd381ecf16485f91e85bc3	84565434746de9ae0cd3baf57fcfd87d
645b264cb978b22bb2d2c70433723ec0	84565434746de9ae0cd3baf57fcfd87d
98dd2a77f081989a185cb652662eea41	84565434746de9ae0cd3baf57fcfd87d
c1a08f1ea753843e2b4f5f3d2cb41b7b	84565434746de9ae0cd3baf57fcfd87d
807dbc2d5a3525045a4b7d882e3768ee	84565434746de9ae0cd3baf57fcfd87d
458da4fc3da734a6853e26af3944bf75	b39ff9f6960957839c401d45abdc3cae
5ef02a06b43b002e3bc195b3613b7022	b39ff9f6960957839c401d45abdc3cae
ed9b92eb1706415c42f88dc91284da8a	b39ff9f6960957839c401d45abdc3cae
fb1afbea5c0c2e23396ef429d0e42c52	b39ff9f6960957839c401d45abdc3cae
9d74605e4b1d19d83992a991230e89ef	b39ff9f6960957839c401d45abdc3cae
41dabe0c59a3233e3691f3c893eb789e	b39ff9f6960957839c401d45abdc3cae
c1e8b6d7a1c20870d5955bcdc04363e4	b39ff9f6960957839c401d45abdc3cae
480a0efd668e568595d42ac78340fe2a	b39ff9f6960957839c401d45abdc3cae
d25956f771b58b6b00f338a41ca05396	b39ff9f6960957839c401d45abdc3cae
95a1f9b6006151e00b1a4cda721f469d	b39ff9f6960957839c401d45abdc3cae
5159ae414608a804598452b279491c5c	b39ff9f6960957839c401d45abdc3cae
9bdbe50a5be5b9c92dccf2d1ef05eefd	b39ff9f6960957839c401d45abdc3cae
8c4e8003f8d708dc3b6d486d74d9a585	b39ff9f6960957839c401d45abdc3cae
b6eba7850fd20fa8dce81167f1a6edca	b39ff9f6960957839c401d45abdc3cae
5f27f488f7c8b9e4b81f59c6d776e25c	b39ff9f6960957839c401d45abdc3cae
491801c872c67db465fda0f8f180569d	90710b6a9bf6fbbdea99a274ca058668
852c0b6d5b315c823cdf0382ca78e47f	90710b6a9bf6fbbdea99a274ca058668
a0d3b444bd04cd165b4e076c9fc18bee	90710b6a9bf6fbbdea99a274ca058668
fb3a67e400fde856689076418034cdf2	1fef5be89b79c6e282d1af946a3bd662
20aba645df0b3292c63f0f08b993966e	ddf663d64f6daaeb9c8eb11fe3396ffb
3cb5ffaba5b396de828bc06683b5e058	a685e40a5c47edcf3a7c9c9f38155fc8
246e0913685e96004354b87cbab4ea78	9fe5ff8e93ce19ca4b27d5267ad7bfb3
b531de2f903d979f6a002d5a94b136aa	9fe5ff8e93ce19ca4b27d5267ad7bfb3
4522c5141f18b2a408fc8c1b00827bc3	d5bd359a19abc00f202bb19255675651
c846d80d826291f2a6a0d7a57e540307	90710b6a9bf6fbbdea99a274ca058668
f2856ad30734c5f838185cc08f71b1e4	de9415f38659fd6225ddf8734a7b0ff7
8aeadeeff3e1a3e1c8a6a69d9312c530	de9415f38659fd6225ddf8734a7b0ff7
78a7bdfe7277f187e84b52dea7b75b0b	de9415f38659fd6225ddf8734a7b0ff7
f36fba9e93f6402ba551291e34242338	de9415f38659fd6225ddf8734a7b0ff7
95800513c555e1e95a430e312ddff817	4ba1c22d76444426b678b142977aa084
e2226498712065ccfca00ecb57b8ed2f	4ba1c22d76444426b678b142977aa084
db732a1a9861777294f7dc54eeca2b3e	4ba1c22d76444426b678b142977aa084
1ace9926ad3a6dab09d16602fd2fcccc	4ba1c22d76444426b678b142977aa084
05256decaa2ee2337533d95c7de3db9d	4ba1c22d76444426b678b142977aa084
c664656f67e963f4c0f651195f818ce0	4ba1c22d76444426b678b142977aa084
810f28b77fa6c866fbcceb6c8aa7bac4	4ba1c22d76444426b678b142977aa084
7fcdd5f715be5fce835b68b9e63e1733	4ba1c22d76444426b678b142977aa084
5214513d882cf478e028201a0d9031c0	4ba1c22d76444426b678b142977aa084
b1c7516fef4a901df12871838f934cf6	69d2999875a1e6d7c09bbf157d18a27e
a7111b594249d6a038281deb74ef0d04	dcad795c824cf4d6337fc9f745e5645f
45d62f43d6f59291905d097790f74ade	dcad795c824cf4d6337fc9f745e5645f
2df0462e6f564f34f68866045b2a8a44	dcad795c824cf4d6337fc9f745e5645f
eb3a9fb71b84790e50acd81cc1aa4862	86615675838b48d2003175dd7665fba3
7eeea2463ae5da9990cab53c014864fa	86615675838b48d2003175dd7665fba3
dd3e531c469005b17115dbf611b01c88	95e6dc1125e477e58c9f5bdb1bdd53ac
d2d67d63c28a15822569c5033f26b133	95e6dc1125e477e58c9f5bdb1bdd53ac
0cd2b45507cc7c4ead2aaa71c59af730	95e6dc1125e477e58c9f5bdb1bdd53ac
541fa0085b17ef712791151ca285f1a7	95e6dc1125e477e58c9f5bdb1bdd53ac
a7eda23a9421a074fe5ec966810018d7	95e6dc1125e477e58c9f5bdb1bdd53ac
ad51cbe70d798b5aec08caf64ce66094	95e6dc1125e477e58c9f5bdb1bdd53ac
45e410efd11014464dd36fb707a5a9e1	95e6dc1125e477e58c9f5bdb1bdd53ac
8fdc3e13751b8f525f259d27f2531e87	95e6dc1125e477e58c9f5bdb1bdd53ac
05e76572fb3d16ca990a91681758bbee	95e6dc1125e477e58c9f5bdb1bdd53ac
cfc61472d8abd7c54b81924119983ed9	95e6dc1125e477e58c9f5bdb1bdd53ac
1fe0175f73e5b381213057da98b8f5fb	95e6dc1125e477e58c9f5bdb1bdd53ac
d44be0e711c2711876734b330500e5b9	95e6dc1125e477e58c9f5bdb1bdd53ac
c295bb30bf534e960a6acf7435f0e46a	95e6dc1125e477e58c9f5bdb1bdd53ac
ab3ca496cbc01a5a9ed650c4d0e26168	95e6dc1125e477e58c9f5bdb1bdd53ac
538eaaef4d029c255ad8416c01ab5719	95e6dc1125e477e58c9f5bdb1bdd53ac
1de3f08835ab9d572e79ac0fca13c5c2	95e6dc1125e477e58c9f5bdb1bdd53ac
4c02510c3f16e13edc27eff1ef2e452c	95e6dc1125e477e58c9f5bdb1bdd53ac
7cbd455ff5af40e28a1eb97849f00723	95e6dc1125e477e58c9f5bdb1bdd53ac
3d4fe2107d6302760654b4217cf32f17	95e6dc1125e477e58c9f5bdb1bdd53ac
3c8ce0379b610d36c3723b198b982197	95e6dc1125e477e58c9f5bdb1bdd53ac
ee36fdf153967a0b99d3340aadeb4720	f5cd4263f2cbb5e459306b35cef72e9d
087c643d95880c5a89fc13f3246bebae	f5cd4263f2cbb5e459306b35cef72e9d
be553803806b8634990c2eb7351ed489	f5cd4263f2cbb5e459306b35cef72e9d
dfa61d19b62369a37743b38215836df9	69882c9d3cc383cd271732b068979a98
1a5235c012c18789e81960333a76cd7a	69882c9d3cc383cd271732b068979a98
2db1850a4fe292bd2706ffd78dbe44b9	39603f44a0fea370f2f6ced327e9b38b
951af0076709a6da6872f9cdf41c852b	39603f44a0fea370f2f6ced327e9b38b
69a6a78ace079846a8f0d3f89beada2c	39603f44a0fea370f2f6ced327e9b38b
43ff5aadca6d8a60dd3da21716358c7d	39603f44a0fea370f2f6ced327e9b38b
95800513c555e1e95a430e312ddff817	a420ecf82bd099f63cf26c8cbc4cdf05
42085fca2ddb606f4284e718074d5561	a420ecf82bd099f63cf26c8cbc4cdf05
5214513d882cf478e028201a0d9031c0	a420ecf82bd099f63cf26c8cbc4cdf05
92e1aca33d97fa75c1e81a9db61454bb	be31669251922949ee5efe5447a119d1
c8fd07f040a8f2dc85f5b2d3804ea3db	be31669251922949ee5efe5447a119d1
866208c5b4a74b32974bffb0f90311ca	be31669251922949ee5efe5447a119d1
fd3ab918dab082b1af1df5f9dbc0041f	be31669251922949ee5efe5447a119d1
cb0785d67b1ea8952fae42efd82864a7	be31669251922949ee5efe5447a119d1
aa5e46574bdc6034f4d49540c0c2d1ad	f7995b1a1bf9683848dd37ab294cfa3f
6fa204dccaff0ec60f96db5fb5e69b33	f7995b1a1bf9683848dd37ab294cfa3f
2587d892c1261be043d443d06bd5b220	f7995b1a1bf9683848dd37ab294cfa3f
fcc491ba532309d8942df543beaec67e	169be8981eff6a53b1bcae79e2f06a05
51cb62b41cd9deaaa2dd98c773a09ebb	169be8981eff6a53b1bcae79e2f06a05
89b5ac8fb4c102c174adf2fed752a970	169be8981eff6a53b1bcae79e2f06a05
cc31970696ef00b4c6e28dba4252e45d	169be8981eff6a53b1bcae79e2f06a05
92e1aca33d97fa75c1e81a9db61454bb	169be8981eff6a53b1bcae79e2f06a05
4669569c9a870431c4896de37675a784	42a2eedac863bd01b14540a71331ec65
9d36a42a36b62b3f665c7fa07f07563b	42a2eedac863bd01b14540a71331ec65
118b96dde2f8773b011dfb27e51b2f95	a1127140db632705cffe06456b478fa8
381b834c6bf7b25b9b627c9eeb81dd8a	a1127140db632705cffe06456b478fa8
4bcbcb65040e0347a1ffb5858836c49c	a1127140db632705cffe06456b478fa8
0d949e45a18d81db3491a7b451e99560	a1127140db632705cffe06456b478fa8
c52d5020aad50e03d48581ffb34cd1c3	83bd23b786ae4d9b16f52ed2661611e9
c2ab38206dce633f15d66048ad744f03	26c07de9d3c6e80d7fdaefec9a7dcdc5
26ad58455460d75558a595528825b672	26c07de9d3c6e80d7fdaefec9a7dcdc5
5c3278fb76fa2676984396d33ba90613	26c07de9d3c6e80d7fdaefec9a7dcdc5
dda8e0792843816587427399f34bd726	26c07de9d3c6e80d7fdaefec9a7dcdc5
dfa61d19b62369a37743b38215836df9	c4133d7e05b0f42aedd762785de80b70
f68a3eafcc0bb036ee8fde7fc91cde13	c4133d7e05b0f42aedd762785de80b70
78f5c568100eb61401870fa0fa4fd7cb	c4133d7e05b0f42aedd762785de80b70
73cb08d143f893e645292dd04967f526	db92681077141614e2ee9a01df968334
d0b02893ceb72d11a3471fe18d7089fd	db92681077141614e2ee9a01df968334
fcc491ba532309d8942df543beaec67e	e26bcb0f8a28cd2229ce77a95d0baf9e
ab42c2d958e2571ce5403391e9910c40	e26bcb0f8a28cd2229ce77a95d0baf9e
b86f86db61493cc2d757a5cefc5ef425	e26bcb0f8a28cd2229ce77a95d0baf9e
c52d5020aad50e03d48581ffb34cd1c3	d84c3f96813116b09480c0572fa45636
22aaaebe901de8370917dcc53f53dbf6	d1b30328ab686d050b6c107154d6aef8
9c81c8c060b39e7437b2d913f036776b	d1b30328ab686d050b6c107154d6aef8
61a6502cfdff1a1668892f52c7a00669	d1b30328ab686d050b6c107154d6aef8
d69462bef6601bb8d6e3ffda067399d9	d1b30328ab686d050b6c107154d6aef8
630500eabc48c986552cb01798a31746	4e22c7f7fe57d94f85bf89a469627ba1
abc73489d8f0d1586a2568211bdeb32f	4e22c7f7fe57d94f85bf89a469627ba1
c21fe390daecee9e70b8f4b091ae316f	4e22c7f7fe57d94f85bf89a469627ba1
b9fd9676338e36e6493489ec5dc041fe	4e22c7f7fe57d94f85bf89a469627ba1
04728a6272117e0dc4ec29b0f7202ad8	4e22c7f7fe57d94f85bf89a469627ba1
113ab4d243afc4114902d317ad41bb39	33314b620ad609dc87d035654068d01e
cc70416ca37c5b31e7609fcc68ca009e	33314b620ad609dc87d035654068d01e
7b91dc9ecdfa3ea7d347588a63537bb9	33314b620ad609dc87d035654068d01e
55c63b0540793d537ed29f5c41eb9c3e	33314b620ad609dc87d035654068d01e
43bd0d50fe7d58d8fce10c6d4232ca1e	33314b620ad609dc87d035654068d01e
cf38e7d92bb08c96c50ddc723b624f9d	33314b620ad609dc87d035654068d01e
5f449b146ce14c780eee323dfc5391e8	33314b620ad609dc87d035654068d01e
d9c849266ee3ac1463262df200b3aab8	cac02becf783662df9a61439ed515d75
5ef02a06b43b002e3bc195b3613b7022	cac02becf783662df9a61439ed515d75
191bab5800bd381ecf16485f91e85bc3	cac02becf783662df9a61439ed515d75
0e4f0487408be5baf091b74ba765dce7	cac02becf783662df9a61439ed515d75
8cd7fa96a5143f7105ca92de7ff0bac7	cac02becf783662df9a61439ed515d75
bdbafc49aa8c3e75e9bd1e0ee24411b4	cac02becf783662df9a61439ed515d75
5863c78fb68ef1812a572e8f08a4e521	cac02becf783662df9a61439ed515d75
08f8c67c20c4ba43e8ba6fa771039c94	b4435108ce3cef02600464daf3cb5f7f
c2ab38206dce633f15d66048ad744f03	b4435108ce3cef02600464daf3cb5f7f
aa98c9e445775e7c945661e91cf7e7aa	b4435108ce3cef02600464daf3cb5f7f
b615ea28d44d2e863a911ed76386b52a	b4435108ce3cef02600464daf3cb5f7f
d5a5e9d2edeb2b2c685364461f1dfd46	b4435108ce3cef02600464daf3cb5f7f
1fcf2f2315b251ebe462da320491ea9f	b4435108ce3cef02600464daf3cb5f7f
7022f6b60d9642d91eebba98185cd9ba	b4435108ce3cef02600464daf3cb5f7f
0d01b12a6783b4e60d2e09e16431f00a	b4435108ce3cef02600464daf3cb5f7f
9c81c8c060b39e7437b2d913f036776b	b4435108ce3cef02600464daf3cb5f7f
4522c5141f18b2a408fc8c1b00827bc3	b4435108ce3cef02600464daf3cb5f7f
5ec194adf19442544d8a94f4696f17dc	b4435108ce3cef02600464daf3cb5f7f
31e2d1e0b364475375cb17ad76aa71f2	b4435108ce3cef02600464daf3cb5f7f
dff880ae9847f6fa8ed628ed4ee5741b	b4435108ce3cef02600464daf3cb5f7f
521c8a16cf07590faee5cf30bcfb98b6	b4435108ce3cef02600464daf3cb5f7f
a77c14ecd429dd5dedf3dc5ea8d44b99	b4435108ce3cef02600464daf3cb5f7f
b8d794c48196d514010ce2c2269b4102	b4435108ce3cef02600464daf3cb5f7f
087c643d95880c5a89fc13f3246bebae	f0c7879002501eddcb68564fe19b77fc
032d53a86540806303b4c81586308e58	f0c7879002501eddcb68564fe19b77fc
df800795b697445f2b7dc0096d75f4df	f0c7879002501eddcb68564fe19b77fc
f1a37824dfc280b208e714bd80d5a294	efdb143af86d5a0af148b7847e721e55
786a755c895da064ccd4f9e8eb7e484e	efdb143af86d5a0af148b7847e721e55
5958cd5ce011ea83c06cb921b1c85bb3	586a67dc71b225f23047ff369fce7451
c5d3d165539ddf2020f82c17a61f783d	586a67dc71b225f23047ff369fce7451
de1e0ed5433f5e95c8f48e18e1c75ff6	586a67dc71b225f23047ff369fce7451
a7eda23a9421a074fe5ec966810018d7	586a67dc71b225f23047ff369fce7451
6a4e8bab29666632262eb20c336e85e2	ec83b315e34cecd0b3e8323e22ee38bf
53c25598fe4f1f71a1c596bd4997245c	ec83b315e34cecd0b3e8323e22ee38bf
dd3e531c469005b17115dbf611b01c88	e184d243eb553fcba592ae848963c1e8
a6c27c0fb9ef87788c1345041e840f95	e184d243eb553fcba592ae848963c1e8
5c59b6aa317b306a1312a67fe69bf512	e184d243eb553fcba592ae848963c1e8
cd0bc2c8738b2fef2d78d197223b17d5	e184d243eb553fcba592ae848963c1e8
6af2c726b2d705f08d05a7ee9509916e	e184d243eb553fcba592ae848963c1e8
fc239fd89fd7c9edbf2bf27d1d894bc0	e184d243eb553fcba592ae848963c1e8
29891bf2e4eff9763aef15dc862c373f	e184d243eb553fcba592ae848963c1e8
9d74605e4b1d19d83992a991230e89ef	e184d243eb553fcba592ae848963c1e8
67cd9b4b7b33511f30e85e21b2d3b204	e184d243eb553fcba592ae848963c1e8
b12daab6c83b1a45aa32cd9c2bc78360	e184d243eb553fcba592ae848963c1e8
0ba2f4073dd8eff1f91650af5dc67db4	e184d243eb553fcba592ae848963c1e8
bd555d95b1ccba75afca868636b1b931	e184d243eb553fcba592ae848963c1e8
a93376e58f4c73737cf5ed7d88c2169c	e184d243eb553fcba592ae848963c1e8
cd3faaaf1bebf8d009aa59f887d17ef2	e184d243eb553fcba592ae848963c1e8
33538745a71fe2d30689cac96737e8f7	e184d243eb553fcba592ae848963c1e8
586ac67e6180a1f16a4d3b81e33eaa94	e184d243eb553fcba592ae848963c1e8
ca1720fd6350760c43139622c4753557	e184d243eb553fcba592ae848963c1e8
645b264cb978b22bb2d2c70433723ec0	e184d243eb553fcba592ae848963c1e8
45816111a5b644493b68cfedfb1a0cc0	e184d243eb553fcba592ae848963c1e8
d0e551d6887e0657952b3c5beb7fed74	e184d243eb553fcba592ae848963c1e8
06c1680c65972c4332be73e726de9e74	e184d243eb553fcba592ae848963c1e8
4671068076f66fb346c4f62cbfb7f9fe	e184d243eb553fcba592ae848963c1e8
10407de3db48761373a403b8ddf09782	e184d243eb553fcba592ae848963c1e8
77ac561c759a27b7d660d7cf0534a9c3	e184d243eb553fcba592ae848963c1e8
3771036a0740658b11cf5eb73d9263b3	e184d243eb553fcba592ae848963c1e8
6b37fe4703bd962004cdccda304cc18e	e184d243eb553fcba592ae848963c1e8
371d905385644b0ecb176fd73184239c	e184d243eb553fcba592ae848963c1e8
d871ebaec65bbfa0b6b97aefae5d9150	e184d243eb553fcba592ae848963c1e8
28bb3f229ca1eeb05ef939248f7709ce	e184d243eb553fcba592ae848963c1e8
861613f5a80abdf5a15ea283daa64be3	e184d243eb553fcba592ae848963c1e8
080d2dc6fa136fc49fc65eee1b556b46	e184d243eb553fcba592ae848963c1e8
2df9857b999e21569c3fcce516f0f20e	e184d243eb553fcba592ae848963c1e8
31da4ab7750e057e56224eff51bce705	e184d243eb553fcba592ae848963c1e8
3b6d90f85e8dadcb3c02922e730e4a9d	20a697b57317f75ad33eb50f166d6b00
20de83abafcb071d854ca5fd57dec0e8	20a697b57317f75ad33eb50f166d6b00
e6624ef1aeab84f521056a142b5b2d12	20a697b57317f75ad33eb50f166d6b00
a2761eea97ee9fe09464d5e70da6dd06	20a697b57317f75ad33eb50f166d6b00
a822d5d4cdcb5d1b340a54798ac410b7	88ad18798356c6caa8fe161432d88920
cd004b87e2adfb72b28752a6ef6cd639	c4e2844bff82087c924ad104bdfb6580
c18bdeb4f181c22f04555ea453111da1	c4e2844bff82087c924ad104bdfb6580
4338a835aa6e3198deba95c25dd9e3de	c4e2844bff82087c924ad104bdfb6580
6829c770c1de2fd9bd88fe91f1d42f56	c4e2844bff82087c924ad104bdfb6580
d0dae91314459033160dc47a79aa165e	57a334acb665ebc52057791d107149f4
5878f5f2b1ca134da32312175d640134	57a334acb665ebc52057791d107149f4
333ca835f34af241fe46af8e7a037e17	6439e93ac57a8784706d3155d0fe651f
a99dca5593185c498b63a5eed917bd4f	6439e93ac57a8784706d3155d0fe651f
16a56d0941a310c3dc4f967041574300	6439e93ac57a8784706d3155d0fe651f
5637bae1665ae86050cb41fb1cdcc3ee	6439e93ac57a8784706d3155d0fe651f
182a1e726ac1c8ae851194cea6df0393	6439e93ac57a8784706d3155d0fe651f
e039d55ed63a723001867bc4eb842c00	6439e93ac57a8784706d3155d0fe651f
478aedea838b8b4a0936b129a4c6e853	6439e93ac57a8784706d3155d0fe651f
f2856ad30734c5f838185cc08f71b1e4	6439e93ac57a8784706d3155d0fe651f
10627ac0e35cfed4a0ca5b97a06b9d9f	6439e93ac57a8784706d3155d0fe651f
43a4893e6200f462bb9fe406e68e71c0	6439e93ac57a8784706d3155d0fe651f
29891bf2e4eff9763aef15dc862c373f	6439e93ac57a8784706d3155d0fe651f
03201e85fc6aa56d2cb9374e84bf52ca	6439e93ac57a8784706d3155d0fe651f
e7a227585002db9fee2f0ed56ee5a59f	6439e93ac57a8784706d3155d0fe651f
2f6fc683428eb5f8b22cc5021dc9d40d	6439e93ac57a8784706d3155d0fe651f
7f950b15aa65a26e8500cfffd7f89de0	6439e93ac57a8784706d3155d0fe651f
77f94851e582202f940198a26728e71f	6439e93ac57a8784706d3155d0fe651f
baeb191b42ec09353b389f951d19b357	6439e93ac57a8784706d3155d0fe651f
c21fe390daecee9e70b8f4b091ae316f	6439e93ac57a8784706d3155d0fe651f
8aeadeeff3e1a3e1c8a6a69d9312c530	6439e93ac57a8784706d3155d0fe651f
a4e0f3b7db0875f65bb3f55ab0aab7c6	6439e93ac57a8784706d3155d0fe651f
37b43a655dec0e3504142003fce04a07	6439e93ac57a8784706d3155d0fe651f
644f6462ec9801cdc932e5c8698ee7f9	cf1c6716920400a1d8ade1584c726f0c
61a6502cfdff1a1668892f52c7a00669	cf1c6716920400a1d8ade1584c726f0c
89d60b9528242c8c53ecbfde131eba21	cf1c6716920400a1d8ade1584c726f0c
087c643d95880c5a89fc13f3246bebae	c0e1ed6923fbe4194174ad87f11179cd
e8d17786fed9fa5ddaf13881496106e4	c0e1ed6923fbe4194174ad87f11179cd
d9c849266ee3ac1463262df200b3aab8	078ac0cacb2c674f16940ebd9befedd9
a6c27c0fb9ef87788c1345041e840f95	078ac0cacb2c674f16940ebd9befedd9
26ad58455460d75558a595528825b672	078ac0cacb2c674f16940ebd9befedd9
123131d2d4bd15a0db8f07090a383157	078ac0cacb2c674f16940ebd9befedd9
6adc39f4242fd1ca59f184e033514209	078ac0cacb2c674f16940ebd9befedd9
1f56e4b8b8a0da3b8ec5b32970e4b0d8	078ac0cacb2c674f16940ebd9befedd9
f31ba1d770aac9bc0dcee3fc15c60a46	078ac0cacb2c674f16940ebd9befedd9
c21fe390daecee9e70b8f4b091ae316f	078ac0cacb2c674f16940ebd9befedd9
06c1680c65972c4332be73e726de9e74	078ac0cacb2c674f16940ebd9befedd9
0371892b7f65ffb9c1544ee35c6330ad	078ac0cacb2c674f16940ebd9befedd9
bf5c782ca6b0130372ac41ebd703463e	078ac0cacb2c674f16940ebd9befedd9
f041991eb3263fd3e5d919026e772f57	078ac0cacb2c674f16940ebd9befedd9
70409bc559ef6c8aabcf16941a29788b	078ac0cacb2c674f16940ebd9befedd9
0ecef959ca1f43d538966f7eb9a7e2ec	078ac0cacb2c674f16940ebd9befedd9
169c9d1bfabf9dec8f84e1f874d5e788	078ac0cacb2c674f16940ebd9befedd9
01ffa9ce7c50b906e4f5b6a2516ba94b	078ac0cacb2c674f16940ebd9befedd9
d104b6ae44b0ac6649723bac21761d41	078ac0cacb2c674f16940ebd9befedd9
3f460e130f37e8974fbcdc4d0056b468	1fef5be89b79c6e282d1af946a3bd662
31e2d1e0b364475375cb17ad76aa71f2	ddf663d64f6daaeb9c8eb11fe3396ffb
31897528a567059ed581f119a0e1e516	a685e40a5c47edcf3a7c9c9f38155fc8
8717871a38810cc883cce02ea54a7017	9fe5ff8e93ce19ca4b27d5267ad7bfb3
96406d44fcf110be6a4b63fa6d26de3b	9fe5ff8e93ce19ca4b27d5267ad7bfb3
efb83e3ae12d8d95a5d01b6d762baa98	d5bd359a19abc00f202bb19255675651
6a826993d87c8fc0014c43edd8622b6c	d5bd359a19abc00f202bb19255675651
a7eb281bcaab3446ece1381b190d34e0	2c5cad7b6d76825edcfbd5d077e7a5ee
5da7161758c4b9241330afb2e1503bbc	2c5cad7b6d76825edcfbd5d077e7a5ee
f6f1f5df964a4620e88527d4e4ff84fc	05ffebda2d583b6081ffaa8dd7ba0788
dfb7069bfc6e0064a6c667626eca07b4	0a7d68cf2a103e1c99f7e6d04f1940da
398af626887ad21cd66aeb272b8337be	2c6ed5b74b30541da64fdbbda4a8bbe3
8ac49bad86eacffcea299416cd92c3b7	bf65ac5101f339e8c8d756e99c49a829
c827a8c6d72ff66b08f9e2ab64e21c01	79b4deb2eac122cc633196f32cf65670
35bde21520f1490f0333133a9ae5b4fc	3479db140a88fa19295f4346b1d84380
b7f0e9013f8bfb209f4f6b2258b6c9c8	e669a39d1453acd6aefc84913a985f51
8ac49bad86eacffcea299416cd92c3b7	9952e1e08fb8f493c66f5cf386ba7e06
dab701a389943f0d407c6e583abef934	cbe2729e13ce90825f88f2fc3a0bce55
4a27a1ef21d32d1b30d55f092af0d5a7	87d1f3bfe03274952aa29304eb82d9d9
4a9cd04fd04ab718420ee464645ccb8b	87d1f3bfe03274952aa29304eb82d9d9
dfb7069bfc6e0064a6c667626eca07b4	11a728ed9e3a6aac1b46277a7302b15f
048d40092f9bd3c450e4bdeeff69e8c3	11a728ed9e3a6aac1b46277a7302b15f
5958cd5ce011ea83c06cb921b1c85bb3	eeba68f0a1003dce9bd66066b82dc1b6
048d40092f9bd3c450e4bdeeff69e8c3	eeba68f0a1003dce9bd66066b82dc1b6
a0abb504e661e34f5d269f113d39ea96	a53dce25b80bd1caf2f1aa7ea602ed63
aaaad3022279d4afdb86ad02d5bde96b	1fef5be89b79c6e282d1af946a3bd662
5e13fedbc93d74e8d42eadee1def2ae6	ddf663d64f6daaeb9c8eb11fe3396ffb
a7111b594249d6a038281deb74ef0d04	f4ab1c6777711952be2adceed22d7fc5
56e8538c55d35a1c23286442b4bccd26	9fe5ff8e93ce19ca4b27d5267ad7bfb3
7bc230f440d5d70d2c573341342d9c81	9fe5ff8e93ce19ca4b27d5267ad7bfb3
dfa61d19b62369a37743b38215836df9	31702e4b76bb69f9630a227d403c4ca0
37b43a655dec0e3504142003fce04a07	abe69e5488f1be295baa8bbf1995c657
35f3e8a1461c3ce965993e4eafccfa43	d5bd359a19abc00f202bb19255675651
974cd6e62ff1a4101db277d936b41058	d5bd359a19abc00f202bb19255675651
5ef02a06b43b002e3bc195b3613b7022	d5bd359a19abc00f202bb19255675651
5324a886a2667283dbfe7f7974ff6fc0	2c5cad7b6d76825edcfbd5d077e7a5ee
29891bf2e4eff9763aef15dc862c373f	2c5cad7b6d76825edcfbd5d077e7a5ee
66cc7344291ae2a297bf2aa93d886e22	05ffebda2d583b6081ffaa8dd7ba0788
e21ad7a2093c42e374fee6ec3b31efd3	1fef5be89b79c6e282d1af946a3bd662
c08567e9006dc768bdb72bb7b14e53a1	ddf663d64f6daaeb9c8eb11fe3396ffb
a35033c250bd9c577f20f2b253be0021	f4ab1c6777711952be2adceed22d7fc5
e6624ef1aeab84f521056a142b5b2d12	9fe5ff8e93ce19ca4b27d5267ad7bfb3
14aedd89f13973e35f9ba63149a07768	9fe5ff8e93ce19ca4b27d5267ad7bfb3
7d067ef3bf74d1659b8fa9df3de1a047	31702e4b76bb69f9630a227d403c4ca0
fcc491ba532309d8942df543beaec67e	abe69e5488f1be295baa8bbf1995c657
e039d55ed63a723001867bc4eb842c00	d5bd359a19abc00f202bb19255675651
4e9a84da92180e801263860bfbea79d6	d5bd359a19abc00f202bb19255675651
359dda2e361814c0c8b7b358e654691d	d5bd359a19abc00f202bb19255675651
eef1b009f602bb255fa81c0a7721373d	2c5cad7b6d76825edcfbd5d077e7a5ee
e039d55ed63a723001867bc4eb842c00	2c5cad7b6d76825edcfbd5d077e7a5ee
d0dc5a2eab283511301b75090afe11ab	05ffebda2d583b6081ffaa8dd7ba0788
0ab7d3a541204a9cab0d2d569c5b173f	1fef5be89b79c6e282d1af946a3bd662
d86431a5bbb40ae41cad636c2ddbf746	ddf663d64f6daaeb9c8eb11fe3396ffb
41f062d8603a9705974083360fb69892	f4ab1c6777711952be2adceed22d7fc5
df24a5dd8a37d3d203952bb787069ea2	9fe5ff8e93ce19ca4b27d5267ad7bfb3
b12986f0a962c34c6669d59f40b1e9eb	9fe5ff8e93ce19ca4b27d5267ad7bfb3
221fa1624ee1e31376cb112dd2487953	f7787eb77e709474505db860a00edd2d
16ff0968c682d98cb29b42c793066f29	31702e4b76bb69f9630a227d403c4ca0
b02ba5a5e65487122c2c1c67351c3ea0	d5bd359a19abc00f202bb19255675651
645b264cb978b22bb2d2c70433723ec0	d5bd359a19abc00f202bb19255675651
0e609404e53b251f786b41b7be93cc19	d5bd359a19abc00f202bb19255675651
35f3e8a1461c3ce965993e4eafccfa43	2c5cad7b6d76825edcfbd5d077e7a5ee
1ae6e4c42571b2d7275b5922ce3d5f39	2c5cad7b6d76825edcfbd5d077e7a5ee
3f7e7508d7af00ea2447bfffbbac2178	05ffebda2d583b6081ffaa8dd7ba0788
454cce609b348a95fb627e5c02dddd1b	1fef5be89b79c6e282d1af946a3bd662
c5f4e658dfe7b7af3376f06d7cd18a2a	ddf663d64f6daaeb9c8eb11fe3396ffb
2db1850a4fe292bd2706ffd78dbe44b9	b3d8150933aa73cc2b3ba1fc39b1651c
454cce609b348a95fb627e5c02dddd1b	b3d8150933aa73cc2b3ba1fc39b1651c
43ff5aadca6d8a60dd3da21716358c7d	b3d8150933aa73cc2b3ba1fc39b1651c
8aeadeeff3e1a3e1c8a6a69d9312c530	9fe5ff8e93ce19ca4b27d5267ad7bfb3
6dffdacffe80aad339051ef4fbbf3f29	9fe5ff8e93ce19ca4b27d5267ad7bfb3
a7111b594249d6a038281deb74ef0d04	f7787eb77e709474505db860a00edd2d
d2556a1452bc878401a6cde5cb89264d	d5bd359a19abc00f202bb19255675651
39530e3fe26ee7c557392d479cc9c93f	d5bd359a19abc00f202bb19255675651
f0f2e6b4ae39fe3ef81d807f641f54a9	d5bd359a19abc00f202bb19255675651
841981e178ed25ef0f86f34ce0fb2904	2c5cad7b6d76825edcfbd5d077e7a5ee
d0932e0499b24d42233616e053d088ea	2c5cad7b6d76825edcfbd5d077e7a5ee
1175d5b2a935b9f4daf6b39e5e74138c	05ffebda2d583b6081ffaa8dd7ba0788
a8fcba36c9e48e9e17ba381a34444dd0	1fef5be89b79c6e282d1af946a3bd662
b6eba7850fd20fa8dce81167f1a6edca	ddf663d64f6daaeb9c8eb11fe3396ffb
cfd7b6bdd92dbe51d1bdb8cb3b98cd58	9fe5ff8e93ce19ca4b27d5267ad7bfb3
0aff394c56096d998916d2673d7ea0b6	9fe5ff8e93ce19ca4b27d5267ad7bfb3
7359d3b2ff69eb4127c60756cc77faa9	d5bd359a19abc00f202bb19255675651
aa5e46574bdc6034f4d49540c0c2d1ad	d5bd359a19abc00f202bb19255675651
568afb74bcc1ce84f8562a4fbfdc31ba	d5bd359a19abc00f202bb19255675651
d7a97c2ff91f7aa07fa9e2f8265ceab6	2c5cad7b6d76825edcfbd5d077e7a5ee
6e2f236ffef50c45058f6127b30ecece	2c5cad7b6d76825edcfbd5d077e7a5ee
49d387abd142d76f4b38136257f56201	05ffebda2d583b6081ffaa8dd7ba0788
c5068f914571c27e04cd66a4ec5c1631	ddf663d64f6daaeb9c8eb11fe3396ffb
c08567e9006dc768bdb72bb7b14e53a1	9fe5ff8e93ce19ca4b27d5267ad7bfb3
aa98c9e445775e7c945661e91cf7e7aa	9fe5ff8e93ce19ca4b27d5267ad7bfb3
ca7f6314915171b302f62946dcd9a369	d5bd359a19abc00f202bb19255675651
75241d56d63a68adcd51d828eb76ca80	d5bd359a19abc00f202bb19255675651
bccaee4d143d381c8c617dd98b9ee463	d5bd359a19abc00f202bb19255675651
cdd65383f4d356e459018c3b295d678b	2c5cad7b6d76825edcfbd5d077e7a5ee
14bbaec7f5e0eba98d90cd8353c2e79f	2c5cad7b6d76825edcfbd5d077e7a5ee
40eefb87bb24ed4efc3fc5eeeb7e5003	05ffebda2d583b6081ffaa8dd7ba0788
f517a9dc937888bed2f3fbeb38648372	ddf663d64f6daaeb9c8eb11fe3396ffb
ad7de486b34143f00a56127a95787e78	9fe5ff8e93ce19ca4b27d5267ad7bfb3
ca4038e41aaa675d65dc3f2ea92556e9	9fe5ff8e93ce19ca4b27d5267ad7bfb3
4ccc28be05a98375d9496dc2eba7006a	d5bd359a19abc00f202bb19255675651
844de407cd83ea1716f1ff57ea029285	d5bd359a19abc00f202bb19255675651
e389ffc844004b963c3b832faeea873d	d5bd359a19abc00f202bb19255675651
5e8df9b073e86a3272282977d2c9dc85	2c5cad7b6d76825edcfbd5d077e7a5ee
9d919b88be43eb3a9056a54e57894f84	05ffebda2d583b6081ffaa8dd7ba0788
db572afa3dcc982995b5528acb350299	ddf663d64f6daaeb9c8eb11fe3396ffb
0bc231190faa69e7545dfa084f2bed56	9fe5ff8e93ce19ca4b27d5267ad7bfb3
f7a13e18c9c1e371b748facfef98a9a5	9fe5ff8e93ce19ca4b27d5267ad7bfb3
33b8199a303b059dfe3a3f9ace77c972	d5bd359a19abc00f202bb19255675651
96406d44fcf110be6a4b63fa6d26de3b	d5bd359a19abc00f202bb19255675651
f32badb09f6aacb398d3cd690d90a668	d5bd359a19abc00f202bb19255675651
88059eaa73469bb47bd41c5c3cdd1b50	d5bd359a19abc00f202bb19255675651
9a876908f511193b53ce983ab276bd73	2c5cad7b6d76825edcfbd5d077e7a5ee
c38529decc4815a9932f940af2a16d37	2c5cad7b6d76825edcfbd5d077e7a5ee
99557f46ccef290d9d93c546f64fb7d6	05ffebda2d583b6081ffaa8dd7ba0788
cd0bc2c8738b2fef2d78d197223b17d5	ddf663d64f6daaeb9c8eb11fe3396ffb
b99927de4e0ed554b381b920c01e0481	9fe5ff8e93ce19ca4b27d5267ad7bfb3
6caa2c6d69ebdc30a3c4580979c3e630	9fe5ff8e93ce19ca4b27d5267ad7bfb3
513fc59781f0030dc6e7a7528a45b35b	d5bd359a19abc00f202bb19255675651
2e4e6a5f485b2c7e22f9974633c2b900	d5bd359a19abc00f202bb19255675651
1680c4ab3ce61ab3e1514fba8b99e3c5	2c5cad7b6d76825edcfbd5d077e7a5ee
d7e0c43c16a9f8385b49d23cd1178598	2c5cad7b6d76825edcfbd5d077e7a5ee
f2856ad30734c5f838185cc08f71b1e4	01e90040938d8415a8b98f0d80fceb06
44a468f083ac27ea7b6847fdaf515207	05ffebda2d583b6081ffaa8dd7ba0788
3705bfe1d1b3b5630618b164716ae700	ddf663d64f6daaeb9c8eb11fe3396ffb
85ed977a5fcd1ce0c970827078fdb7dd	9fe5ff8e93ce19ca4b27d5267ad7bfb3
1bebc288d8fce192365168e890c956c8	9fe5ff8e93ce19ca4b27d5267ad7bfb3
88726e1a911181e20cf8be52e1027f26	d5bd359a19abc00f202bb19255675651
4a0ea81570ab9440e8899b9f5fb3a61a	d5bd359a19abc00f202bb19255675651
31b9bbcd5d3cb8e18af8f6ea59aea836	2c5cad7b6d76825edcfbd5d077e7a5ee
749b17536e08489cb3b2437715e89001	2c5cad7b6d76825edcfbd5d077e7a5ee
e7a227585002db9fee2f0ed56ee5a59f	01e90040938d8415a8b98f0d80fceb06
f0ae03df4fd08abd1f844fea2f4bbfb0	05ffebda2d583b6081ffaa8dd7ba0788
3f460e130f37e8974fbcdc4d0056b468	ddf663d64f6daaeb9c8eb11fe3396ffb
f114176afa9d9d44e8ef8ce2b586469d	9fe5ff8e93ce19ca4b27d5267ad7bfb3
14b33fbc65adcc1655f82c82d232f6e7	9fe5ff8e93ce19ca4b27d5267ad7bfb3
3757709518b67fddd9ae5a368d219334	d5bd359a19abc00f202bb19255675651
dfa61d19b62369a37743b38215836df9	d5bd359a19abc00f202bb19255675651
23f5e1973b5a048ffaaa0bd0183b5f87	a20ba10650527a8e646bd528e4f2428e
2e3163bc98304958ccafbb2810210714	2c5cad7b6d76825edcfbd5d077e7a5ee
869bb972f8bef83979774fa123c56a4e	2c5cad7b6d76825edcfbd5d077e7a5ee
6e610e4ff7101f3a1837544e9fb5d0bf	01e90040938d8415a8b98f0d80fceb06
4e74055927fd771c2084c92ca2ae56a7	05ffebda2d583b6081ffaa8dd7ba0788
ce8e1e23e9672f5bf43894879f89c17a	ddf663d64f6daaeb9c8eb11fe3396ffb
2a67e4bd1ef39d36123c84cad0b3f974	9fe5ff8e93ce19ca4b27d5267ad7bfb3
812f48abd93f276576541ec5b79d48a2	9fe5ff8e93ce19ca4b27d5267ad7bfb3
f68a3eafcc0bb036ee8fde7fc91cde13	d5bd359a19abc00f202bb19255675651
118b96dde2f8773b011dfb27e51b2f95	d5bd359a19abc00f202bb19255675651
78bbff6bf39602a577c9d8a117116330	a20ba10650527a8e646bd528e4f2428e
807dbc2d5a3525045a4b7d882e3768ee	2c5cad7b6d76825edcfbd5d077e7a5ee
a54196a4ae23c424c6c01a508f4c9dfb	2c5cad7b6d76825edcfbd5d077e7a5ee
649df53f8249bdb0aa26e52d6ee517bb	01e90040938d8415a8b98f0d80fceb06
c61b8639de558fcc2ee0b1d11e120df9	05ffebda2d583b6081ffaa8dd7ba0788
53a5da370321dac39033a5fe6af13e77	9fe5ff8e93ce19ca4b27d5267ad7bfb3
9133f1146bbdd783f34025bf90a8e148	9fe5ff8e93ce19ca4b27d5267ad7bfb3
7d067ef3bf74d1659b8fa9df3de1a047	d5bd359a19abc00f202bb19255675651
852c0b6d5b315c823cdf0382ca78e47f	a20ba10650527a8e646bd528e4f2428e
ccc9b8a517c7065d907e283040e6bc91	2c5cad7b6d76825edcfbd5d077e7a5ee
3ec4a598041aa926d5f075e3d69dfc0a	2c5cad7b6d76825edcfbd5d077e7a5ee
623c5a1c99aceaf0b07ae233d1888e0a	01e90040938d8415a8b98f0d80fceb06
65f24dbd08671d51fda7de723afc41d9	05ffebda2d583b6081ffaa8dd7ba0788
801c01707f48bfa8875d4a2ac613920d	9fe5ff8e93ce19ca4b27d5267ad7bfb3
b9a0ad15427ab09cfd7b85dadf2c4487	9fe5ff8e93ce19ca4b27d5267ad7bfb3
7e0e2fabeced85b4b8bbbca59858d33d	d5bd359a19abc00f202bb19255675651
21077194453dcf49c2105fda6bb89c79	d5bd359a19abc00f202bb19255675651
f2576a80ee7893b24dd33a8af3911eac	2c5cad7b6d76825edcfbd5d077e7a5ee
03aa4e5b2b49a82eb798d33afe9e8523	2c5cad7b6d76825edcfbd5d077e7a5ee
fb8b0c4fbbd2bc0ab10fcf67a9f1d1ff	01e90040938d8415a8b98f0d80fceb06
50bac8fb5d0c55efd23de4c216e440f1	9fe5ff8e93ce19ca4b27d5267ad7bfb3
d42e907e9c61d30d23ce9728d97aa862	9fe5ff8e93ce19ca4b27d5267ad7bfb3
54ca3eeff0994926cb7944cca0797474	d5bd359a19abc00f202bb19255675651
309263122a445662099a3dabce2a4f17	d5bd359a19abc00f202bb19255675651
0ab7d3a541204a9cab0d2d569c5b173f	05ffebda2d583b6081ffaa8dd7ba0788
f3cb86dd6b6caf33a8a05571e195e7dc	d5bd359a19abc00f202bb19255675651
20db933d4ddd11d5eff99a441e081550	2c5cad7b6d76825edcfbd5d077e7a5ee
fe4398ac7504e937c2ff97039aa66311	2c5cad7b6d76825edcfbd5d077e7a5ee
d0a0817c2cd33b0734f70fcf3240eb41	01e90040938d8415a8b98f0d80fceb06
e3c1fd64db1923585a22632681c95d35	05ffebda2d583b6081ffaa8dd7ba0788
fc46b0aa6469133caf668f87435bfd9f	3fe511194113f53322ccac8a75e6b4ab
8872fbd923476b7cf96913260ec59e66	3fe511194113f53322ccac8a75e6b4ab
f8b3eaefc682f8476cc28caf71cb2c73	e4ee5ac5d137718d0eeb4d310b97d837
db1440c4bae3edf98e3dab7caf2e7fed	08a5c6dec5d631fe995935fd38f389be
bff322dbe273a1e2d1fe37f81acccbe4	08a5c6dec5d631fe995935fd38f389be
36b208182f04f44c80937e980c3c28fd	08a5c6dec5d631fe995935fd38f389be
15ba70625527d7bb48962e6ba1a465f7	16a83f971efce095272378a2a594e49f
a571d94b6ed1fa1e0cfff9c04bbeb94d	16a83f971efce095272378a2a594e49f
e37e9fd6bde7509157f864942572c267	791a234c3e78612495c07d7d49defc4c
9592b3ad4d7f96bc644c7d6f34c06576	0a7d68cf2a103e1c99f7e6d04f1940da
fd1a5654154eed3c0a0820ab54fb90a7	0a7d68cf2a103e1c99f7e6d04f1940da
2045b9a6609f6d5bca3374fd370e54ff	fb57c18df776961bb734a1fa3db6a6d1
78b532c25e4a99287940b1706359d455	fb57c18df776961bb734a1fa3db6a6d1
fc935f341286c735b575bd50196c904b	fb57c18df776961bb734a1fa3db6a6d1
f159fc50b5af54fecf21d5ea6ec37bad	fb57c18df776961bb734a1fa3db6a6d1
265dbcbd2bce07dfa721ed3daaa30912	fb57c18df776961bb734a1fa3db6a6d1
0cd2b45507cc7c4ead2aaa71c59af730	c6b227c4855621d0654142f2a3cad0ee
0fa4e99a2451478f3870e930d263cfd4	c6b227c4855621d0654142f2a3cad0ee
6c718d616702ff78522951d768552d6a	c6b227c4855621d0654142f2a3cad0ee
9efb345179e21314a38093da366e1f09	c6b227c4855621d0654142f2a3cad0ee
b7f3ddec78883ff5a0af0d223f491db8	c6b227c4855621d0654142f2a3cad0ee
118c9af69a42383387e8ce6ab22867d7	099346085ef9364171db5f639475194e
5e8df9b073e86a3272282977d2c9dc85	099346085ef9364171db5f639475194e
3472e72b1f52a7fda0d4340e563ea6c0	099346085ef9364171db5f639475194e
f816407dd0b81a5baedb7695302855d9	099346085ef9364171db5f639475194e
de1e0ed5433f5e95c8f48e18e1c75ff6	5d7e58efe4f97f6abc7174574843abbc
78a7bdfe7277f187e84b52dea7b75b0b	5d7e58efe4f97f6abc7174574843abbc
e2b16c5f5bad24525b8c700c5c3b3653	5d7e58efe4f97f6abc7174574843abbc
b0353ada659e3848bd59dec631e71f9e	99467125829a5b728cfe913f88f19db8
7b91dc9ecdfa3ea7d347588a63537bb9	99467125829a5b728cfe913f88f19db8
7022f6b60d9642d91eebba98185cd9ba	99467125829a5b728cfe913f88f19db8
e093d52bb2d4ff4973e72f6eb577714b	99467125829a5b728cfe913f88f19db8
8791e43a8287ccbc21f61be21e90ce43	99467125829a5b728cfe913f88f19db8
c256d34ab1f0bd3928525d18ddabe18e	99467125829a5b728cfe913f88f19db8
0035ac847bf9e371750cacbc98ad827b	99467125829a5b728cfe913f88f19db8
49bb0f64fae1bd9abf59989d5a5adfaf	99467125829a5b728cfe913f88f19db8
de2290e4c7bfa39e594c2dcd6e4c09d6	99467125829a5b728cfe913f88f19db8
f929c32e1184b9c0efdd60eb947bf06b	8e625852da508feb3e973eedd98b3a6e
25f02579d261655a79a54a1fc5c4baf5	8e625852da508feb3e973eedd98b3a6e
10dbb54312b010f3aeb9fde389fe6cf5	8e625852da508feb3e973eedd98b3a6e
51cb62b41cd9deaaa2dd98c773a09ebb	ff9a901a93946ada59ef15661fd395e1
92e1aca33d97fa75c1e81a9db61454bb	ff9a901a93946ada59ef15661fd395e1
ab5428d229c61532af41ec2ca258bf30	ff9a901a93946ada59ef15661fd395e1
573f13e31f1be6dea396ad9b08701c47	94c9c5cc90aa696fcef2944a63f182e9
0182742917720e1b2cf59ff671738253	94c9c5cc90aa696fcef2944a63f182e9
182a1e726ac1c8ae851194cea6df0393	94c9c5cc90aa696fcef2944a63f182e9
f0cd1b3734f01a46d31c5644e3216382	94c9c5cc90aa696fcef2944a63f182e9
dba84ece8f49717c47ab72acc3ed2965	a601420442e567507a31586d3508e901
b1006928600959429230393369fe43b6	a601420442e567507a31586d3508e901
baf938346589a5e047e2aa1afcc3d353	a601420442e567507a31586d3508e901
2ef1ea5e4114637a2dc94110d4c3fc7a	a601420442e567507a31586d3508e901
09fcf410c0bb418d24457d323a5c812a	a601420442e567507a31586d3508e901
bd6d4ce8e8bd1f6494db102db5a06091	a601420442e567507a31586d3508e901
f68e5e7b745ade835ef3029794b4b0b2	a601420442e567507a31586d3508e901
d4f9c39bf51444ae90cc8947534f20e4	a601420442e567507a31586d3508e901
55edd327aec958934232e98d828fb56a	a601420442e567507a31586d3508e901
6435684be93c4a59a315999d3a3227f5	a601420442e567507a31586d3508e901
e340c1008146e56c9d6c7ad7aa5b8146	a601420442e567507a31586d3508e901
a6c37758f53101378a209921511369de	a601420442e567507a31586d3508e901
5b05784f3a259c7ebc2fffc1cf0c37b7	a601420442e567507a31586d3508e901
034c15ae2143eea36eec7292010568a1	e2cc1ec7e3f092bf9acff95c49b4601f
50437ed6fdec844c3d86bb6ac8a4a333	e2cc1ec7e3f092bf9acff95c49b4601f
b66781a52770d78b260f15d125d1380b	f91e581750aef0db0551fafb15367bd9
486bf23406dec9844b97f966f4636c9b	f91e581750aef0db0551fafb15367bd9
7df470ec0292985d8f0e37aa6c2b38d5	f91e581750aef0db0551fafb15367bd9
cd0bc2c8738b2fef2d78d197223b17d5	0b050e993c77bc785f1a5ee9dd0c0cca
bb7dcf6e8a0c1005d2be54f005e9ff8f	0b050e993c77bc785f1a5ee9dd0c0cca
05acc535cbe432a56e2c9cfb170ee635	0b050e993c77bc785f1a5ee9dd0c0cca
7a78e9ce32da3202ac0ca91ec4247086	3479db140a88fa19295f4346b1d84380
7a78e9ce32da3202ac0ca91ec4247086	08f8c67c20c4ba43e8ba6fa771039c94
7a78e9ce32da3202ac0ca91ec4247086	8b0e6056132f11cfb7968cf303ff0154
7a78e9ce32da3202ac0ca91ec4247086	5e38483d273e5a8b6f777f8017bedf62
7a78e9ce32da3202ac0ca91ec4247086	6439e93ac57a8784706d3155d0fe651f
7a78e9ce32da3202ac0ca91ec4247086	01e90040938d8415a8b98f0d80fceb06
cd0bc2c8738b2fef2d78d197223b17d5	aa32f037a3d1ff9264faa5c3f0f65079
7a78e9ce32da3202ac0ca91ec4247086	aa32f037a3d1ff9264faa5c3f0f65079
35bde21520f1490f0333133a9ae5b4fc	0b3f22fe9047dc47a984a062c17d5777
abca417a801cd10e57e54a3cb6c7444b	0b3f22fe9047dc47a984a062c17d5777
8f7939c28270f3187210641e96a98ba7	0b3f22fe9047dc47a984a062c17d5777
ba404ce5a29ba15a792583bbaa7969c6	0b3f22fe9047dc47a984a062c17d5777
0a3a1f7ca8d6cf9b2313f69db9e97eb8	0b3f22fe9047dc47a984a062c17d5777
d8cddac7db3dedd7d96b81a31dc519b3	0b3f22fe9047dc47a984a062c17d5777
63dab0854b1002d4692bbdec90ddaecc	f311f7681e474c2937481923ae6a0445
3e8f57ef55b9d3a8417963f343db1de2	f311f7681e474c2937481923ae6a0445
7176be85b1a9e340db4a91d9f17c87b3	f311f7681e474c2937481923ae6a0445
cc31f5f7ca2d13e95595d2d979d10223	f311f7681e474c2937481923ae6a0445
576fea4a0c5425ba382fff5f593a33f1	701771f4cfec0fee38bf370d6af6f8cc
4dde2c290e3ee11bd3bd1ecd27d7039a	701771f4cfec0fee38bf370d6af6f8cc
ea6fff7f9d00d218338531ab8fe4e98c	701771f4cfec0fee38bf370d6af6f8cc
00a616d5caaf94d82a47275101e3fa22	701771f4cfec0fee38bf370d6af6f8cc
f3cb86dd6b6caf33a8a05571e195e7dc	ddf663d64f6daaeb9c8eb11fe3396ffb
88726e1a911181e20cf8be52e1027f26	a601420442e567507a31586d3508e901
53a5da370321dac39033a5fe6af13e77	ec1c30e91a0ca3f4d0a786488e6ad70f
708abbdc2eb4b62e6732c4c2a60c625a	ec1c30e91a0ca3f4d0a786488e6ad70f
92e1aca33d97fa75c1e81a9db61454bb	43a5261d50cad6c92b073e23d789dc68
51cb62b41cd9deaaa2dd98c773a09ebb	43a5261d50cad6c92b073e23d789dc68
1dc7d7d977193974deaa993eb373e714	43a5261d50cad6c92b073e23d789dc68
ffd6243282cdf77599e2abaf5d1a36e5	98fbe07eebe68a529f12602e94d37b62
d148b29cbc0092dc206f9217a1b3da73	98fbe07eebe68a529f12602e94d37b62
a70a003448c0c2d2a6d4974f60914d40	98fbe07eebe68a529f12602e94d37b62
b12daab6c83b1a45aa32cd9c2bc78360	9317da510080ab43b1cf8e89f890554b
0cd2b45507cc7c4ead2aaa71c59af730	9317da510080ab43b1cf8e89f890554b
0e4f0487408be5baf091b74ba765dce7	9317da510080ab43b1cf8e89f890554b
68f05e1c702a4218b7eb968ff9489744	9317da510080ab43b1cf8e89f890554b
b5067ff7f533848af0c9d1f3e6c5b204	9317da510080ab43b1cf8e89f890554b
dba661bb8c2cd8edac359b22d3f9ddf3	9317da510080ab43b1cf8e89f890554b
7a78e9ce32da3202ac0ca91ec4247086	7bf774533c7117c4e139f1cb58cbedbe
553adf4c48f103e61a3ee7a94e7ea17b	7bf774533c7117c4e139f1cb58cbedbe
134a3bbedd12bc313d57aa4cc781ddf9	7bf774533c7117c4e139f1cb58cbedbe
f2856ad30734c5f838185cc08f71b1e4	5a1a238b946013e16ff5db077b9f5ae6
10627ac0e35cfed4a0ca5b97a06b9d9f	5a1a238b946013e16ff5db077b9f5ae6
048d40092f9bd3c450e4bdeeff69e8c3	5a1a238b946013e16ff5db077b9f5ae6
5958cd5ce011ea83c06cb921b1c85bb3	f9b4f5ba6cb5f7721ce1e55d68a918b8
ab9ca8ecf42a92840c674cde665fbdd3	f9b4f5ba6cb5f7721ce1e55d68a918b8
cd0bc2c8738b2fef2d78d197223b17d5	f9b4f5ba6cb5f7721ce1e55d68a918b8
d4192d77ea0e14c40efe4dc9f08fdfb8	f9b4f5ba6cb5f7721ce1e55d68a918b8
d0b02893ceb72d11a3471fe18d7089fd	f9b4f5ba6cb5f7721ce1e55d68a918b8
5fac4291bc9c25864604c4a6be9e0b4a	f9b4f5ba6cb5f7721ce1e55d68a918b8
3cb5ffaba5b396de828bc06683b5e058	95fea685e14cf598f5a22e82371ebaac
ecd06281e276d8cc9a8b1b26d8c93f08	95fea685e14cf598f5a22e82371ebaac
bf6cf2159f795fc867355ee94bca0dd5	95fea685e14cf598f5a22e82371ebaac
3b0713ede16f6289afd699359dff90d4	95fea685e14cf598f5a22e82371ebaac
087c643d95880c5a89fc13f3246bebae	9cfee73dcb4ebeba48366c0fd1d4fe3a
032d53a86540806303b4c81586308e58	9cfee73dcb4ebeba48366c0fd1d4fe3a
46148baa7f5229428d9b0950be68e6d7	9cfee73dcb4ebeba48366c0fd1d4fe3a
707270d99f92250a07347773736df5cc	48b3e4e082a150ee45ac1229b6c556bc
5e62fc773369f140db419401204200e8	48b3e4e082a150ee45ac1229b6c556bc
13291409351c97f8c187790ece4f5a97	1e33e72fc8ecaa5f931f8f9cda7a38ed
34ca5622469ad1951a3c4dc5603cea0f	1e33e72fc8ecaa5f931f8f9cda7a38ed
6ee6a213cb02554a63b1867143572e70	b66b04a94d60074d595fd3acfeb73973
496a6164d8bf65daf6ebd4616c95b4b7	b66b04a94d60074d595fd3acfeb73973
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	a53dce25b80bd1caf2f1aa7ea602ed63
a909b944804141354049983d9c6cc236	ca3f4984b3956024054e62665febcc6a
16e54a9ce3fcedbadd0cdc18832266fd	ca3f4984b3956024054e62665febcc6a
04d53bc45dc1343f266585b52dbe09b0	2baafaeeb079bb06df7cc0531aa81ccb
3cc1eb35683942bb5f7e30b187438c5e	dabaf9fe7459d022af9bf8afc729631a
6949c5ed6eda8cf7a40adb2981d4671d	fa92cfeec372b54d5551e5fb9aaa55af
92e1aca33d97fa75c1e81a9db61454bb	fa92cfeec372b54d5551e5fb9aaa55af
087c643d95880c5a89fc13f3246bebae	f6fbabd4858c55fea0dce0d32db9dcf5
08e2440159e71c7020394db19541aabc	f6fbabd4858c55fea0dce0d32db9dcf5
e039d55ed63a723001867bc4eb842c00	c65ee59c92bf87259bb6081ac1066701
b08bdd1d40a38ab9848ff817294332ca	c65ee59c92bf87259bb6081ac1066701
087c643d95880c5a89fc13f3246bebae	2b23c45d7b18dfccde35439462716807
b06edc3ce52eb05a5a45ae58a7bb7adc	2b23c45d7b18dfccde35439462716807
61a6502cfdff1a1668892f52c7a00669	2b23c45d7b18dfccde35439462716807
8e38937886f365bb96aa1c189c63c5ea	27eb08ae0128e38418359de5030cba15
9a83f3f2774bee96b8f2c8595fc174d7	27eb08ae0128e38418359de5030cba15
4124cc9a170709b345d3f68fd563ac33	27eb08ae0128e38418359de5030cba15
a1e60d2ccea21edbaf84a12181d1e966	dc3e783425dbba6bb13a0b09e3d8a473
94edec5dc10d059f05d513ce4a001c22	dc3e783425dbba6bb13a0b09e3d8a473
d1b8bfadad3a69dbd746217a500a4db5	dc3e783425dbba6bb13a0b09e3d8a473
087c643d95880c5a89fc13f3246bebae	33fc414b35e2153721f8e19b5b2aa1eb
57006f73c326669c8d52c47a3a9e2696	33fc414b35e2153721f8e19b5b2aa1eb
28a6ebe1e170483c1695fca36880db98	33fc414b35e2153721f8e19b5b2aa1eb
ce34dc9b3e210fd7a61d94df77bd8398	33fc414b35e2153721f8e19b5b2aa1eb
57126705faf40e4b5227c8a0302d13b2	50870ec5cfc0a18f40002a123c288af6
cdd21eba97ee010129f5d1e7a80494cb	50870ec5cfc0a18f40002a123c288af6
df99cee44099ff57acbf7932670614dd	50870ec5cfc0a18f40002a123c288af6
bff322dbe273a1e2d1fe37f81acccbe4	50870ec5cfc0a18f40002a123c288af6
182a1e726ac1c8ae851194cea6df0393	f869730b71701b478d8d44e485d96b96
ec29a7f3c6a4588ef5067ea12a19e4e1	f869730b71701b478d8d44e485d96b96
98dd2a77f081989a185cb652662eea41	f869730b71701b478d8d44e485d96b96
23dad719c8a972b4f19a65c79a8550fe	f869730b71701b478d8d44e485d96b96
dac6032bdce48b416fa3cd1d93dc83b8	f869730b71701b478d8d44e485d96b96
73cff3ab45ec02453b639abccb5bd730	f869730b71701b478d8d44e485d96b96
442ea4b6f50b4ae7dfde9350b3b6f664	f869730b71701b478d8d44e485d96b96
af8b7f5474d507a8e583c66ef1eed5a5	f869730b71701b478d8d44e485d96b96
bf250243f776c4cc4a9c4a1f81f7e42f	f869730b71701b478d8d44e485d96b96
bc30e7b15744d2140e28e5b335605de5	f869730b71701b478d8d44e485d96b96
8b174e2c4b00b9e0699967e812e97397	f869730b71701b478d8d44e485d96b96
8872fbd923476b7cf96913260ec59e66	f869730b71701b478d8d44e485d96b96
df800795b697445f2b7dc0096d75f4df	87e221b0a60c5938389dcc7d10b93bdb
a68fbbd4507539f9f2579ad2e7f94902	87e221b0a60c5938389dcc7d10b93bdb
2e572c8c809cfbabbe270b6ce7ce88dd	87e221b0a60c5938389dcc7d10b93bdb
bfaffe308a2e8368acb49b51814f2bfe	011099caab06f3d2db53743ae5957c7a
42085fca2ddb606f4284e718074d5561	011099caab06f3d2db53743ae5957c7a
6261b9de274cf2da37125d96ad21f1df	011099caab06f3d2db53743ae5957c7a
b08bdd1d40a38ab9848ff817294332ca	011099caab06f3d2db53743ae5957c7a
804d27f4798081681e71b2381697e58c	90445b62432a3d8e1f7b3640029e6fed
bf2c8729bf5c149067d8e978ea3dcd32	aa8eed75496c33d578cfad09e49bc803
804d27f4798081681e71b2381697e58c	aa8eed75496c33d578cfad09e49bc803
2918f3b4f699f80bcafb2607065451e1	aa8eed75496c33d578cfad09e49bc803
51cb62b41cd9deaaa2dd98c773a09ebb	85da33004945be2270c841e38d7d7be4
b760518e994aa7db99d91f1b6aa52679	85da33004945be2270c841e38d7d7be4
0fe3db5cf9cff35143d6610797f91f7c	85da33004945be2270c841e38d7d7be4
2304c368fd55bc45cb12f1589197e80d	792b6818a251bf73eba4fa85d61ede60
707270d99f92250a07347773736df5cc	792b6818a251bf73eba4fa85d61ede60
5e62fc773369f140db419401204200e8	792b6818a251bf73eba4fa85d61ede60
6c3eceee73efa7af0d2f9f62daf63456	792b6818a251bf73eba4fa85d61ede60
bf6cf2159f795fc867355ee94bca0dd5	8be553b6dfad10eac5fed512ef6c2c95
b834eadeaf680f6ffcb13068245a1fed	72281605945dfd768083800bc06c5946
6a2367b68131111c0a9a53cd70c2efed	72281605945dfd768083800bc06c5946
f2727091b6fe5656e68aa63d936c5dfd	72281605945dfd768083800bc06c5946
abc73489d8f0d1586a2568211bdeb32f	72281605945dfd768083800bc06c5946
60a105e79a86c8197cec9f973576874b	72281605945dfd768083800bc06c5946
c21fe390daecee9e70b8f4b091ae316f	72281605945dfd768083800bc06c5946
66597873e0974fb365454a5087291094	72281605945dfd768083800bc06c5946
ec41b630150c89b30041d46b03f1da42	72281605945dfd768083800bc06c5946
cb3a240c27ebf12e17f9efe44fa4a7a8	72281605945dfd768083800bc06c5946
6adc39f4242fd1ca59f184e033514209	72281605945dfd768083800bc06c5946
bf5c782ca6b0130372ac41ebd703463e	72281605945dfd768083800bc06c5946
eb999c99126a456f9db3c5d3b449fa7f	c6a597721969cadfa790ad9ad3ed0864
4db3435be88015c70683b4368d9b313b	c6a597721969cadfa790ad9ad3ed0864
2e572c8c809cfbabbe270b6ce7ce88dd	c6a597721969cadfa790ad9ad3ed0864
92e1aca33d97fa75c1e81a9db61454bb	3aef806ce4cb250c0043ec647bcf564f
cfe9861e2a347cc7b50506ea46fdaf4f	3aef806ce4cb250c0043ec647bcf564f
a7111b594249d6a038281deb74ef0d04	d869f28f4e7a04e5f9254884229d8321
926811886f475151c52dd365c90a7efc	d869f28f4e7a04e5f9254884229d8321
afe4451c0c33641e67241bfe39f339ff	d869f28f4e7a04e5f9254884229d8321
e27728342f660d53bd12ab14e5005903	d869f28f4e7a04e5f9254884229d8321
3e6141409efd871b4a87deacfbf31c28	0d833b14e1535c06601ef6a143deec65
841981e178ed25ef0f86f34ce0fb2904	0d833b14e1535c06601ef6a143deec65
34a9067cace79f5ea8a6e137b7a1a5c8	0d833b14e1535c06601ef6a143deec65
6b157916b43b09df5a22f658ccb92b64	0d833b14e1535c06601ef6a143deec65
e84900ed85812327945c9e72f173f8cc	0d833b14e1535c06601ef6a143deec65
c3ce3cf87341cea762a1fb5d26d7d361	0d833b14e1535c06601ef6a143deec65
5885f60f8c705921cf7411507b8cadc0	0d833b14e1535c06601ef6a143deec65
11ac50031c60fb29e5e1ee475be05412	0d833b14e1535c06601ef6a143deec65
844de407cd83ea1716f1ff57ea029285	a8a45074ca24548875765e3388541cb5
bd9b8bf7d35d3bd278b5c300bc011d86	a8a45074ca24548875765e3388541cb5
d39aa6fda7dc81d19cd21adbf8bd3479	a8a45074ca24548875765e3388541cb5
\.


--
-- Data for Name: bands_genres; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands_genres (id_band, id_genre) FROM stdin;
4545c676e400facbb87cbc7736d90e85	5148c20f58db929fe77e3cb0611dc1c4
304d29d27816ec4f69c7b1ba5836c57a	3593526a5f465ed766bafb4fb45748a2
37e2e92ced5d525b3e79e389935cd669	3593526a5f465ed766bafb4fb45748a2
f3cb86dd6b6caf33a8a05571e195e7dc	d25334037d936d3257f794a10bb3030f
3cb5ffaba5b396de828bc06683b5e058	7b4b7e3375c9f7424a57a2d9d7bccde5
a35033c250bd9c577f20f2b253be0021	0c454d6b55ed1860a5b4329cea3a6cb0
cfd7b6bdd92dbe51d1bdb8cb3b98cd58	8dbf2602d350002b61aeb50d7b1f5823
1bebc288d8fce192365168e890c956c8	2db87892408abd4d82eb39b78c50c27b
7d067ef3bf74d1659b8fa9df3de1a047	73d0749820562452b33d4e0f4891efcd
3cc1eb35683942bb5f7e30b187438c5e	1f7254694408508be3dde29c3105bdbe
35f3e8a1461c3ce965993e4eafccfa43	7b4b7e3375c9f7424a57a2d9d7bccde5
9a876908f511193b53ce983ab276bd73	7b4b7e3375c9f7424a57a2d9d7bccde5
3ec4a598041aa926d5f075e3d69dfc0a	680f65454234c43a1c1e4e72febc93b2
6949c5ed6eda8cf7a40adb2981d4671d	57974b0a845d1d72601a3a49433e01a1
6e610e4ff7101f3a1837544e9fb5d0bf	6fa675606729b1ccf2c9f118afab1a78
4545c676e400facbb87cbc7736d90e85	f54c3ccedc098d37a4e7f7a455f5731e
20aba645df0b3292c63f0f08b993966e	8dbf2602d350002b61aeb50d7b1f5823
3cb5ffaba5b396de828bc06683b5e058	d25334037d936d3257f794a10bb3030f
a35033c250bd9c577f20f2b253be0021	c7fb67368c25c29b9c10ca91b2d97488
ad7de486b34143f00a56127a95787e78	3593526a5f465ed766bafb4fb45748a2
14b33fbc65adcc1655f82c82d232f6e7	9e7315413ae31a070ccae5c580dd1b19
7d067ef3bf74d1659b8fa9df3de1a047	2db87892408abd4d82eb39b78c50c27b
3cc1eb35683942bb5f7e30b187438c5e	ea678a9205735898d39982a6854e4be0
d2556a1452bc878401a6cde5cb89264d	3593526a5f465ed766bafb4fb45748a2
9a876908f511193b53ce983ab276bd73	680f65454234c43a1c1e4e72febc93b2
03aa4e5b2b49a82eb798d33afe9e8523	8bb92c3b9b1b949524aac3b578a052b6
6949c5ed6eda8cf7a40adb2981d4671d	d30be26d66f0448359f54d923aab2bb9
6e610e4ff7101f3a1837544e9fb5d0bf	8bb92c3b9b1b949524aac3b578a052b6
4545c676e400facbb87cbc7736d90e85	5739305712ce3c5e565bc2da4cd389f4
5e13fedbc93d74e8d42eadee1def2ae6	2db87892408abd4d82eb39b78c50c27b
31897528a567059ed581f119a0e1e516	b54875674f7d2d5be9737b0d4c021a21
a35033c250bd9c577f20f2b253be0021	4bc6884ff3b54bf84c2970cf8cb57a35
0bc231190faa69e7545dfa084f2bed56	3593526a5f465ed766bafb4fb45748a2
14b33fbc65adcc1655f82c82d232f6e7	3593526a5f465ed766bafb4fb45748a2
16ff0968c682d98cb29b42c793066f29	76536e0dcee9328df87ca18835071948
7359d3b2ff69eb4127c60756cc77faa9	3593526a5f465ed766bafb4fb45748a2
1680c4ab3ce61ab3e1514fba8b99e3c5	8bb92c3b9b1b949524aac3b578a052b6
03aa4e5b2b49a82eb798d33afe9e8523	3593526a5f465ed766bafb4fb45748a2
6e610e4ff7101f3a1837544e9fb5d0bf	8a1cece259499b3705bc5b42ddcd9169
9777f12d27d48261acb756ca56ceea96	2db87892408abd4d82eb39b78c50c27b
c08567e9006dc768bdb72bb7b14e53a1	9e7315413ae31a070ccae5c580dd1b19
a35033c250bd9c577f20f2b253be0021	a2e63ee01401aaeca78be023dfbb8c59
b99927de4e0ed554b381b920c01e0481	a88070859e86a8fb44267f7c6d91d381
14b33fbc65adcc1655f82c82d232f6e7	2db87892408abd4d82eb39b78c50c27b
ca7f6314915171b302f62946dcd9a369	9d90cd61df8dbf35d395a0e225e3639c
1680c4ab3ce61ab3e1514fba8b99e3c5	3593526a5f465ed766bafb4fb45748a2
fe4398ac7504e937c2ff97039aa66311	7b4b7e3375c9f7424a57a2d9d7bccde5
6e610e4ff7101f3a1837544e9fb5d0bf	0c5544f60e058b8cbf571044aaa6115f
dfb7069bfc6e0064a6c667626eca07b4	3593526a5f465ed766bafb4fb45748a2
58bbd6135961e3d837bacceb3338f082	d725d2ec3a5cfa9f6384d9870df72400
c08567e9006dc768bdb72bb7b14e53a1	2db87892408abd4d82eb39b78c50c27b
41f062d8603a9705974083360fb69892	c875de527ea22b45018e7468fb0ef4a5
b99927de4e0ed554b381b920c01e0481	9e7315413ae31a070ccae5c580dd1b19
b9a0ad15427ab09cfd7b85dadf2c4487	3593526a5f465ed766bafb4fb45748a2
4ccc28be05a98375d9496dc2eba7006a	afb45735b54991094a6734f53c375faf
31b9bbcd5d3cb8e18af8f6ea59aea836	3b8f2fd29146bee84451b55c0d80e880
fe4398ac7504e937c2ff97039aa66311	680f65454234c43a1c1e4e72febc93b2
649df53f8249bdb0aa26e52d6ee517bb	d179815f808c4c1c6964c094e87ac6e9
8e1cfd3bf5a7f326107f82f8f28649be	e31bcdc3311e00fe13a85ee759b65391
d86431a5bbb40ae41cad636c2ddbf746	2db87892408abd4d82eb39b78c50c27b
b99927de4e0ed554b381b920c01e0481	c7fb67368c25c29b9c10ca91b2d97488
d42e907e9c61d30d23ce9728d97aa862	9e7315413ae31a070ccae5c580dd1b19
4ccc28be05a98375d9496dc2eba7006a	9e7315413ae31a070ccae5c580dd1b19
31b9bbcd5d3cb8e18af8f6ea59aea836	3593526a5f465ed766bafb4fb45748a2
5da7161758c4b9241330afb2e1503bbc	7b4b7e3375c9f7424a57a2d9d7bccde5
fb8b0c4fbbd2bc0ab10fcf67a9f1d1ff	3593526a5f465ed766bafb4fb45748a2
2e6df049342acfb3012ac702ed93feb4	f54c3ccedc098d37a4e7f7a455f5731e
f517a9dc937888bed2f3fbeb38648372	3593526a5f465ed766bafb4fb45748a2
85ed977a5fcd1ce0c970827078fdb7dd	9e7315413ae31a070ccae5c580dd1b19
e8ead85c87ecdab1738db48a10cae6da	2db87892408abd4d82eb39b78c50c27b
33b8199a303b059dfe3a3f9ace77c972	3593526a5f465ed766bafb4fb45748a2
31b9bbcd5d3cb8e18af8f6ea59aea836	d25334037d936d3257f794a10bb3030f
1ae6e4c42571b2d7275b5922ce3d5f39	d25334037d936d3257f794a10bb3030f
d0a0817c2cd33b0734f70fcf3240eb41	39bb71ab4328d2d97bd4710252ca0e16
ad759a3d4f679008ffdfb07cdbda2bb0	3593526a5f465ed766bafb4fb45748a2
844de407cd83ea1716f1ff57ea029285	3593526a5f465ed766bafb4fb45748a2
9d5c1f0c1b4d20a534fe35e4e699fb7b	b54875674f7d2d5be9737b0d4c021a21
db572afa3dcc982995b5528acb350299	2db87892408abd4d82eb39b78c50c27b
85ed977a5fcd1ce0c970827078fdb7dd	3593526a5f465ed766bafb4fb45748a2
b531de2f903d979f6a002d5a94b136aa	2db87892408abd4d82eb39b78c50c27b
33b8199a303b059dfe3a3f9ace77c972	9e7315413ae31a070ccae5c580dd1b19
2e3163bc98304958ccafbb2810210714	7b4b7e3375c9f7424a57a2d9d7bccde5
d0932e0499b24d42233616e053d088ea	70accb11df7fea2ee734e5849044f3c8
d0a0817c2cd33b0734f70fcf3240eb41	8a1cece259499b3705bc5b42ddcd9169
4a27a1ef21d32d1b30d55f092af0d5a7	3593526a5f465ed766bafb4fb45748a2
dd15d5adf6349f5ca53e7a2641d41ab7	9e7315413ae31a070ccae5c580dd1b19
fb3a67e400fde856689076418034cdf2	6fa675606729b1ccf2c9f118afab1a78
db572afa3dcc982995b5528acb350299	5739305712ce3c5e565bc2da4cd389f4
f114176afa9d9d44e8ef8ce2b586469d	2d6b9e1989416f7c6e9600897f410bdf
96406d44fcf110be6a4b63fa6d26de3b	0c7fde545c06c2bc7383c0430c95fb78
33b8199a303b059dfe3a3f9ace77c972	42b75d86a3de2519bbc8c2264fc424af
ccc9b8a517c7065d907e283040e6bc91	3593526a5f465ed766bafb4fb45748a2
6e2f236ffef50c45058f6127b30ecece	7b4b7e3375c9f7424a57a2d9d7bccde5
d0a0817c2cd33b0734f70fcf3240eb41	8bb92c3b9b1b949524aac3b578a052b6
eb999c99126a456f9db3c5d3b449fa7f	b54875674f7d2d5be9737b0d4c021a21
eb999c99126a456f9db3c5d3b449fa7f	d30be26d66f0448359f54d923aab2bb9
33f03dd57f667d41ac77c6baec352a81	917d78ef1f9ba5451bcd9735606e9215
fb3a67e400fde856689076418034cdf2	fae1e7176fb2384eaf7a2438c3055593
db572afa3dcc982995b5528acb350299	e31bcdc3311e00fe13a85ee759b65391
f114176afa9d9d44e8ef8ce2b586469d	22bbb483dcba75fc2df016dc284d293b
96406d44fcf110be6a4b63fa6d26de3b	5446a9fcc158ea011aeb9892ba2dfb15
513fc59781f0030dc6e7a7528a45b35b	3593526a5f465ed766bafb4fb45748a2
ccc9b8a517c7065d907e283040e6bc91	915b6f3ce60339b1afbae84a3c14a9d3
6e2f236ffef50c45058f6127b30ecece	8bb92c3b9b1b949524aac3b578a052b6
f6f1f5df964a4620e88527d4e4ff84fc	9e7315413ae31a070ccae5c580dd1b19
7f3e5839689216583047809a7f6bd0ff	0c7fde545c06c2bc7383c0430c95fb78
fd401865b6db200e5eb8a1ac1b1fbab1	86094b61cb9f63b77f982ceae03e95f0
fd401865b6db200e5eb8a1ac1b1fbab1	3e29d9d93ad04d5bc71d4cdc5a8ad820
fb3a67e400fde856689076418034cdf2	c7f5b70ac03ff1120e353c6faed8ea39
3705bfe1d1b3b5630618b164716ae700	3593526a5f465ed766bafb4fb45748a2
2a67e4bd1ef39d36123c84cad0b3f974	2db87892408abd4d82eb39b78c50c27b
3757709518b67fddd9ae5a368d219334	3593526a5f465ed766bafb4fb45748a2
f2576a80ee7893b24dd33a8af3911eac	0e8f5257b57c38f5c625be7bd55b3bca
14bbaec7f5e0eba98d90cd8353c2e79f	7b4b7e3375c9f7424a57a2d9d7bccde5
d0dc5a2eab283511301b75090afe11ab	b54875674f7d2d5be9737b0d4c021a21
bc5daaf162914ff1200789d069256d36	16875aa2b5eed3e388dcceaa36f56214
fb3a67e400fde856689076418034cdf2	c4ba898ee9eeb44ad4c2647e8ebe930a
3705bfe1d1b3b5630618b164716ae700	d25334037d936d3257f794a10bb3030f
2a67e4bd1ef39d36123c84cad0b3f974	9e7315413ae31a070ccae5c580dd1b19
3757709518b67fddd9ae5a368d219334	d25334037d936d3257f794a10bb3030f
f2576a80ee7893b24dd33a8af3911eac	9e7315413ae31a070ccae5c580dd1b19
14bbaec7f5e0eba98d90cd8353c2e79f	8bb92c3b9b1b949524aac3b578a052b6
3f7e7508d7af00ea2447bfffbbac2178	2db87892408abd4d82eb39b78c50c27b
c445544f1de39b071a4fca8bb33c2772	d25334037d936d3257f794a10bb3030f
29891bf2e4eff9763aef15dc862c373f	8de7ee0c42a9acb04ac0ba7e466ef5fc
3f460e130f37e8974fbcdc4d0056b468	3593526a5f465ed766bafb4fb45748a2
ce8e1e23e9672f5bf43894879f89c17a	e31bcdc3311e00fe13a85ee759b65391
801c01707f48bfa8875d4a2ac613920d	2db87892408abd4d82eb39b78c50c27b
7e0e2fabeced85b4b8bbbca59858d33d	3593526a5f465ed766bafb4fb45748a2
20db933d4ddd11d5eff99a441e081550	7b4b7e3375c9f7424a57a2d9d7bccde5
14bbaec7f5e0eba98d90cd8353c2e79f	3593526a5f465ed766bafb4fb45748a2
1175d5b2a935b9f4daf6b39e5e74138c	3593526a5f465ed766bafb4fb45748a2
3f460e130f37e8974fbcdc4d0056b468	2db87892408abd4d82eb39b78c50c27b
ce8e1e23e9672f5bf43894879f89c17a	2db87892408abd4d82eb39b78c50c27b
50bac8fb5d0c55efd23de4c216e440f1	f3dcdca4cd0c83a5e855c5434ce98673
54ca3eeff0994926cb7944cca0797474	3593526a5f465ed766bafb4fb45748a2
20db933d4ddd11d5eff99a441e081550	680f65454234c43a1c1e4e72febc93b2
14bbaec7f5e0eba98d90cd8353c2e79f	fe81a4f28e6bd176efc8184d58544e66
49d387abd142d76f4b38136257f56201	b54875674f7d2d5be9737b0d4c021a21
aaaad3022279d4afdb86ad02d5bde96b	b54875674f7d2d5be9737b0d4c021a21
50bac8fb5d0c55efd23de4c216e440f1	9e7315413ae31a070ccae5c580dd1b19
54ca3eeff0994926cb7944cca0797474	0c7fde545c06c2bc7383c0430c95fb78
a7eb281bcaab3446ece1381b190d34e0	8bb92c3b9b1b949524aac3b578a052b6
14bbaec7f5e0eba98d90cd8353c2e79f	680f65454234c43a1c1e4e72febc93b2
49d387abd142d76f4b38136257f56201	a9fa565c9ff23612cb5b522c340b09d1
7f950b15aa65a26e8500cfffd7f89de0	3593526a5f465ed766bafb4fb45748a2
7f950b15aa65a26e8500cfffd7f89de0	9e7315413ae31a070ccae5c580dd1b19
5c59b6aa317b306a1312a67fe69bf512	7b4b7e3375c9f7424a57a2d9d7bccde5
5c59b6aa317b306a1312a67fe69bf512	27a7e9871142d8ed01ed795f9906c2fe
aaaad3022279d4afdb86ad02d5bde96b	f54c3ccedc098d37a4e7f7a455f5731e
50bac8fb5d0c55efd23de4c216e440f1	c7fb67368c25c29b9c10ca91b2d97488
efb83e3ae12d8d95a5d01b6d762baa98	2db87892408abd4d82eb39b78c50c27b
a7eb281bcaab3446ece1381b190d34e0	3593526a5f465ed766bafb4fb45748a2
40eefb87bb24ed4efc3fc5eeeb7e5003	8dbf2602d350002b61aeb50d7b1f5823
10407de3db48761373a403b8ddf09782	7b4b7e3375c9f7424a57a2d9d7bccde5
16a56d0941a310c3dc4f967041574300	8bb92c3b9b1b949524aac3b578a052b6
a0abb504e661e34f5d269f113d39ea96	a4ce5a98a8950c04a3d34a2e2cb8c89f
58e42b779d54e174aad9a9fb79e7ebbc	371d339c866b69b5ac58127389069fe5
e21ad7a2093c42e374fee6ec3b31efd3	f54c3ccedc098d37a4e7f7a455f5731e
fdcfaa5f48035ad96752731731ae941a	220355a36d5ccded72a44119a42eaa7d
974cd6e62ff1a4101db277d936b41058	2db87892408abd4d82eb39b78c50c27b
eef1b009f602bb255fa81c0a7721373d	7b4b7e3375c9f7424a57a2d9d7bccde5
9d919b88be43eb3a9056a54e57894f84	3593526a5f465ed766bafb4fb45748a2
032d53a86540806303b4c81586308e58	3593526a5f465ed766bafb4fb45748a2
032d53a86540806303b4c81586308e58	2db87892408abd4d82eb39b78c50c27b
0ada417f5b4361074360211e63449f34	7b4b7e3375c9f7424a57a2d9d7bccde5
8518eafd8feec0d8c056d396122a175a	fe81a4f28e6bd176efc8184d58544e66
df800795b697445f2b7dc0096d75f4df	9a1f30943126974075dbd4d13c8018ac
df800795b697445f2b7dc0096d75f4df	86094b61cb9f63b77f982ceae03e95f0
4bcbcb65040e0347a1ffb5858836c49c	f72e9105795af04cd4da64414d9968ad
8518eafd8feec0d8c056d396122a175a	f47e2dc1975f8d3fb8639e4dd2fff7c0
53c25598fe4f1f71a1c596bd4997245c	9de74271aea8fca48a4b30e94e71a6b2
4bcbcb65040e0347a1ffb5858836c49c	c47182e94615627f857515b0a2bc6ee3
0ab7d3a541204a9cab0d2d569c5b173f	e31bcdc3311e00fe13a85ee759b65391
fdcfaa5f48035ad96752731731ae941a	0bb2ac8dea4da36597a8d9dc88f0ed64
4e9a84da92180e801263860bfbea79d6	2db87892408abd4d82eb39b78c50c27b
841981e178ed25ef0f86f34ce0fb2904	7b4b7e3375c9f7424a57a2d9d7bccde5
99557f46ccef290d9d93c546f64fb7d6	a94bc9e378c8007c95406059d09bb4f3
0959583c7f421c0bb8adb20e8faeeea1	3593526a5f465ed766bafb4fb45748a2
35bde21520f1490f0333133a9ae5b4fc	3593526a5f465ed766bafb4fb45748a2
5958cd5ce011ea83c06cb921b1c85bb3	3593526a5f465ed766bafb4fb45748a2
4a9cd04fd04ab718420ee464645ccb8b	3593526a5f465ed766bafb4fb45748a2
4190210961bce8bf2ac072c878ee7902	3593526a5f465ed766bafb4fb45748a2
50737756bd539f702d8e6e75cf388a31	3593526a5f465ed766bafb4fb45748a2
094655515b3991e73686f45e4fe352fe	3593526a5f465ed766bafb4fb45748a2
fbe95242f85d4bbe067ddc781191afb5	3593526a5f465ed766bafb4fb45748a2
8ac49bad86eacffcea299416cd92c3b7	9e7315413ae31a070ccae5c580dd1b19
b7f0e9013f8bfb209f4f6b2258b6c9c8	9e7315413ae31a070ccae5c580dd1b19
3c6444d9a22c3287b8c483117188b3f4	9e7315413ae31a070ccae5c580dd1b19
36233ed8c181dfacc945ad598fb4f1a1	9e7315413ae31a070ccae5c580dd1b19
b81dd41873676af0f9533d413774fa8d	9e7315413ae31a070ccae5c580dd1b19
35bde21520f1490f0333133a9ae5b4fc	2db87892408abd4d82eb39b78c50c27b
4190210961bce8bf2ac072c878ee7902	2db87892408abd4d82eb39b78c50c27b
d92ee81a401d93bb2a7eba395e181c04	2db87892408abd4d82eb39b78c50c27b
786d3481362b8dee6370dfb9b6df38a2	d725d2ec3a5cfa9f6384d9870df72400
221fa1624ee1e31376cb112dd2487953	d725d2ec3a5cfa9f6384d9870df72400
dd3e531c469005b17115dbf611b01c88	7b4b7e3375c9f7424a57a2d9d7bccde5
2f623623ce7eeb08c30868be121b268a	7b4b7e3375c9f7424a57a2d9d7bccde5
8872fbd923476b7cf96913260ec59e66	7b4b7e3375c9f7424a57a2d9d7bccde5
312793778e3248b6577e3882a77f68f3	b54875674f7d2d5be9737b0d4c021a21
0f9fb8452cc5754f83e084693d406721	b54875674f7d2d5be9737b0d4c021a21
b66781a52770d78b260f15d125d1380b	b54875674f7d2d5be9737b0d4c021a21
739260d8cb379c357340977fe962d37a	b54875674f7d2d5be9737b0d4c021a21
2f623623ce7eeb08c30868be121b268a	d25334037d936d3257f794a10bb3030f
0959583c7f421c0bb8adb20e8faeeea1	0c7fde545c06c2bc7383c0430c95fb78
5958cd5ce011ea83c06cb921b1c85bb3	0c7fde545c06c2bc7383c0430c95fb78
8765cfbf81024c3bd45924fee9159982	2af415a2174b122c80e901297f2d114e
50d48c9002eb08e248225c1d91732bbc	3a9ee0dca39438793417d3cda903c50f
76aebba2f63483b6184f06f0a2602643	3593526a5f465ed766bafb4fb45748a2
4e9a84da92180e801263860bfbea79d6	9e7315413ae31a070ccae5c580dd1b19
841981e178ed25ef0f86f34ce0fb2904	d25334037d936d3257f794a10bb3030f
44a468f083ac27ea7b6847fdaf515207	2db87892408abd4d82eb39b78c50c27b
454cce609b348a95fb627e5c02dddd1b	9e7315413ae31a070ccae5c580dd1b19
8cb8e8679062b574afcb78a983b75a9f	9e7315413ae31a070ccae5c580dd1b19
4e9a84da92180e801263860bfbea79d6	be2f0af59429129793d751e4316ec81c
d7a97c2ff91f7aa07fa9e2f8265ceab6	6fa675606729b1ccf2c9f118afab1a78
f0ae03df4fd08abd1f844fea2f4bbfb0	b54875674f7d2d5be9737b0d4c021a21
a8fcba36c9e48e9e17ba381a34444dd0	b54875674f7d2d5be9737b0d4c021a21
246e0913685e96004354b87cbab4ea78	0bb2ac8dea4da36597a8d9dc88f0ed64
4a0ea81570ab9440e8899b9f5fb3a61a	6fa675606729b1ccf2c9f118afab1a78
d7a97c2ff91f7aa07fa9e2f8265ceab6	0c5544f60e058b8cbf571044aaa6115f
c61b8639de558fcc2ee0b1d11e120df9	b54875674f7d2d5be9737b0d4c021a21
8717871a38810cc883cce02ea54a7017	8dbf2602d350002b61aeb50d7b1f5823
6a826993d87c8fc0014c43edd8622b6c	6fa675606729b1ccf2c9f118afab1a78
cdd65383f4d356e459018c3b295d678b	7b4b7e3375c9f7424a57a2d9d7bccde5
65f24dbd08671d51fda7de723afc41d9	2db87892408abd4d82eb39b78c50c27b
8717871a38810cc883cce02ea54a7017	9a1f30943126974075dbd4d13c8018ac
6a826993d87c8fc0014c43edd8622b6c	0c5544f60e058b8cbf571044aaa6115f
cdd65383f4d356e459018c3b295d678b	680f65454234c43a1c1e4e72febc93b2
e3c1fd64db1923585a22632681c95d35	b54875674f7d2d5be9737b0d4c021a21
7bc230f440d5d70d2c573341342d9c81	2db87892408abd4d82eb39b78c50c27b
359dda2e361814c0c8b7b358e654691d	d725d2ec3a5cfa9f6384d9870df72400
5e8df9b073e86a3272282977d2c9dc85	7b4b7e3375c9f7424a57a2d9d7bccde5
14aedd89f13973e35f9ba63149a07768	9e7315413ae31a070ccae5c580dd1b19
359dda2e361814c0c8b7b358e654691d	7382b86831977a414e676d2b29c73788
5e8df9b073e86a3272282977d2c9dc85	0c5544f60e058b8cbf571044aaa6115f
b12986f0a962c34c6669d59f40b1e9eb	3593526a5f465ed766bafb4fb45748a2
f0f2e6b4ae39fe3ef81d807f641f54a9	2db87892408abd4d82eb39b78c50c27b
c38529decc4815a9932f940af2a16d37	7b4b7e3375c9f7424a57a2d9d7bccde5
6dffdacffe80aad339051ef4fbbf3f29	3593526a5f465ed766bafb4fb45748a2
568afb74bcc1ce84f8562a4fbfdc31ba	2db87892408abd4d82eb39b78c50c27b
d7e0c43c16a9f8385b49d23cd1178598	7b4b7e3375c9f7424a57a2d9d7bccde5
6dffdacffe80aad339051ef4fbbf3f29	f72e9105795af04cd4da64414d9968ad
568afb74bcc1ce84f8562a4fbfdc31ba	3593526a5f465ed766bafb4fb45748a2
d7e0c43c16a9f8385b49d23cd1178598	ae85ec0052dafef13ff2f2cbcb540b53
6dffdacffe80aad339051ef4fbbf3f29	d25334037d936d3257f794a10bb3030f
bccaee4d143d381c8c617dd98b9ee463	3593526a5f465ed766bafb4fb45748a2
d7e0c43c16a9f8385b49d23cd1178598	680f65454234c43a1c1e4e72febc93b2
0aff394c56096d998916d2673d7ea0b6	2db87892408abd4d82eb39b78c50c27b
e389ffc844004b963c3b832faeea873d	5446a9fcc158ea011aeb9892ba2dfb15
749b17536e08489cb3b2437715e89001	7b4b7e3375c9f7424a57a2d9d7bccde5
ca4038e41aaa675d65dc3f2ea92556e9	0c7fde545c06c2bc7383c0430c95fb78
e389ffc844004b963c3b832faeea873d	a94bc9e378c8007c95406059d09bb4f3
749b17536e08489cb3b2437715e89001	d25334037d936d3257f794a10bb3030f
ca4038e41aaa675d65dc3f2ea92556e9	3593526a5f465ed766bafb4fb45748a2
a54196a4ae23c424c6c01a508f4c9dfb	680f65454234c43a1c1e4e72febc93b2
f7a13e18c9c1e371b748facfef98a9a5	a88070859e86a8fb44267f7c6d91d381
a54196a4ae23c424c6c01a508f4c9dfb	7b4b7e3375c9f7424a57a2d9d7bccde5
f7a13e18c9c1e371b748facfef98a9a5	9e7315413ae31a070ccae5c580dd1b19
3ec4a598041aa926d5f075e3d69dfc0a	7b4b7e3375c9f7424a57a2d9d7bccde5
df24a5dd8a37d3d203952bb787069ea2	3593526a5f465ed766bafb4fb45748a2
c5d3d165539ddf2020f82c17a61f783d	3593526a5f465ed766bafb4fb45748a2
d2d67d63c28a15822569c5033f26b133	3593526a5f465ed766bafb4fb45748a2
333ca835f34af241fe46af8e7a037e17	3593526a5f465ed766bafb4fb45748a2
ee36fdf153967a0b99d3340aadeb4720	3593526a5f465ed766bafb4fb45748a2
a99dca5593185c498b63a5eed917bd4f	3593526a5f465ed766bafb4fb45748a2
573f13e31f1be6dea396ad9b08701c47	3593526a5f465ed766bafb4fb45748a2
9436650a453053e775897ef5733e88fe	3593526a5f465ed766bafb4fb45748a2
cf6a93131b0349f37afeb9319b802136	3593526a5f465ed766bafb4fb45748a2
e093d52bb2d4ff4973e72f6eb577714b	3593526a5f465ed766bafb4fb45748a2
9a6c0d8ea613c5b002ff958275318b08	3593526a5f465ed766bafb4fb45748a2
6916ed9292a811c895e259c542af0e8a	3593526a5f465ed766bafb4fb45748a2
ac61757d33fc8563eb2409ed08e21974	3593526a5f465ed766bafb4fb45748a2
afb6e0f1e02be39880596a490c900775	3593526a5f465ed766bafb4fb45748a2
66857d7c2810238438483356343ff26e	3593526a5f465ed766bafb4fb45748a2
eaacb8ee01500f18e370303be3d5c591	3593526a5f465ed766bafb4fb45748a2
22ef651048289b302401afe2044c5c01	3593526a5f465ed766bafb4fb45748a2
08f8c67c20c4ba43e8ba6fa771039c94	3593526a5f465ed766bafb4fb45748a2
3577f7160794aa4ba4d79d0381aefdb1	3593526a5f465ed766bafb4fb45748a2
16fe483d0681e0c86177a33e22452e13	3593526a5f465ed766bafb4fb45748a2
2187711aeaa2944a707c9eabaa2df72a	3593526a5f465ed766bafb4fb45748a2
4db3435be88015c70683b4368d9b313b	3593526a5f465ed766bafb4fb45748a2
53a5da370321dac39033a5fe6af13e77	3593526a5f465ed766bafb4fb45748a2
b0cc1a3a1aee13a213ee73e3d4a2ce70	3593526a5f465ed766bafb4fb45748a2
c2ab38206dce633f15d66048ad744f03	3593526a5f465ed766bafb4fb45748a2
630500eabc48c986552cb01798a31746	3593526a5f465ed766bafb4fb45748a2
ceffa7550e5d24a8c808d3516b5d6432	3593526a5f465ed766bafb4fb45748a2
20a75b90511c108e3512189ccb72b0ac	3593526a5f465ed766bafb4fb45748a2
90669320cd8e4a09bf655310bffdb9ba	3593526a5f465ed766bafb4fb45748a2
b9ffbdbbe63789cc6fa9ee2548a1b2ed	3593526a5f465ed766bafb4fb45748a2
cfe122252751e124bfae54a7323bf02d	3593526a5f465ed766bafb4fb45748a2
abc73489d8f0d1586a2568211bdeb32f	3593526a5f465ed766bafb4fb45748a2
26ad58455460d75558a595528825b672	3593526a5f465ed766bafb4fb45748a2
6e064a31dc53ab956403ec3654c81f1f	3593526a5f465ed766bafb4fb45748a2
e6793169497d66ac959a7beb35d6d497	3593526a5f465ed766bafb4fb45748a2
bda66e37bf0bfbca66f8c78c5c8032b8	3593526a5f465ed766bafb4fb45748a2
386a023bd38fab85cb531824bfe9a879	3593526a5f465ed766bafb4fb45748a2
7b3ab6743cf8f7ea8491211e3336e41d	3593526a5f465ed766bafb4fb45748a2
d1e0bdb2b2227bdd5e47850eec61f9ea	3593526a5f465ed766bafb4fb45748a2
123131d2d4bd15a0db8f07090a383157	3593526a5f465ed766bafb4fb45748a2
281eb11c857bbe8b6ad06dc1458e2751	3593526a5f465ed766bafb4fb45748a2
c5f4e658dfe7b7af3376f06d7cd18a2a	3593526a5f465ed766bafb4fb45748a2
ea3b6b67824411a4cfaa5c8789282f48	3593526a5f465ed766bafb4fb45748a2
eb39fa9323a6b3cbc8533cd3dadb9f76	3593526a5f465ed766bafb4fb45748a2
ef3c0bf190876fd31d5132848e99df61	3593526a5f465ed766bafb4fb45748a2
05c87189f6c230c90bb1693567233100	3593526a5f465ed766bafb4fb45748a2
018b60f1dc74563ca02f0a14ee272e4d	3593526a5f465ed766bafb4fb45748a2
34fd3085dc67c39bf1692938cf3dbdd9	3593526a5f465ed766bafb4fb45748a2
309263122a445662099a3dabce2a4f17	3593526a5f465ed766bafb4fb45748a2
9b55ad92062221ec1bc80f950f667a6b	3593526a5f465ed766bafb4fb45748a2
cd0bc2c8738b2fef2d78d197223b17d5	3593526a5f465ed766bafb4fb45748a2
db472eaf615920784c2b83fc90e8dcc5	3593526a5f465ed766bafb4fb45748a2
91abd5e520ec0a40ce4360bfd7c5d573	3593526a5f465ed766bafb4fb45748a2
e6624ef1aeab84f521056a142b5b2d12	3593526a5f465ed766bafb4fb45748a2
38b2886223461f15d65ff861921932b5	3593526a5f465ed766bafb4fb45748a2
3fae5bf538a263e96ff12986bf06b13f	3593526a5f465ed766bafb4fb45748a2
34a9067cace79f5ea8a6e137b7a1a5c8	3593526a5f465ed766bafb4fb45748a2
e63a014f1310b8c7cbe5e2b0fd66f638	3593526a5f465ed766bafb4fb45748a2
21077194453dcf49c2105fda6bb89c79	3593526a5f465ed766bafb4fb45748a2
6cec93398cd662d79163b10a7b921a1b	3593526a5f465ed766bafb4fb45748a2
1f56e4b8b8a0da3b8ec5b32970e4b0d8	3593526a5f465ed766bafb4fb45748a2
a7eda23a9421a074fe5ec966810018d7	3593526a5f465ed766bafb4fb45748a2
182a1e726ac1c8ae851194cea6df0393	3593526a5f465ed766bafb4fb45748a2
55696bac6cdd14d47cbe7940665e21d3	3593526a5f465ed766bafb4fb45748a2
13c8bd3a0d92bd186fc5162eded4431d	3593526a5f465ed766bafb4fb45748a2
062c44f03dce5bf39f81d0bf953926fc	3593526a5f465ed766bafb4fb45748a2
6f60a61fcc05cb4d42c81ade04392cfc	3593526a5f465ed766bafb4fb45748a2
381b834c6bf7b25b9b627c9eeb81dd8a	3593526a5f465ed766bafb4fb45748a2
cabcfb35912d17067131f7d2634ac270	3593526a5f465ed766bafb4fb45748a2
1c4af233da7b64071abf94d79c41a361	3593526a5f465ed766bafb4fb45748a2
26c2bb18f3a9a0c6d1392dae296cfea7	3593526a5f465ed766bafb4fb45748a2
6af2c726b2d705f08d05a7ee9509916e	3593526a5f465ed766bafb4fb45748a2
218ac7d899a995dc53cabe52da9ed678	3593526a5f465ed766bafb4fb45748a2
364be07c2428493479a07dbefdacc11f	3593526a5f465ed766bafb4fb45748a2
56bf60ca682b8f68e8843ad8a55c6b17	3593526a5f465ed766bafb4fb45748a2
bc834c26e0c9279cd3139746ab2881f1	3593526a5f465ed766bafb4fb45748a2
5f07809ecfce3af23ed5550c6adf0d78	3593526a5f465ed766bafb4fb45748a2
2db1850a4fe292bd2706ffd78dbe44b9	3593526a5f465ed766bafb4fb45748a2
951af0076709a6da6872f9cdf41c852b	3593526a5f465ed766bafb4fb45748a2
a2c31c455e3d0ea3f3bdbea294fe186b	3593526a5f465ed766bafb4fb45748a2
ffd2da11d45ed35a039951a8b462e7fb	3593526a5f465ed766bafb4fb45748a2
16c88f2a44ab7ecdccef28154f3a0109	3593526a5f465ed766bafb4fb45748a2
191bab5800bd381ecf16485f91e85bc3	3593526a5f465ed766bafb4fb45748a2
876eed60be80010455ff50a62ccf1256	3593526a5f465ed766bafb4fb45748a2
f4e4ef312f9006d0ae6ca30c8a6a32ff	3593526a5f465ed766bafb4fb45748a2
270fb708bd03433e554e0d7345630c8e	3593526a5f465ed766bafb4fb45748a2
eb0a191797624dd3a48fa681d3061212	3593526a5f465ed766bafb4fb45748a2
5885f60f8c705921cf7411507b8cadc0	3593526a5f465ed766bafb4fb45748a2
0e609404e53b251f786b41b7be93cc19	3593526a5f465ed766bafb4fb45748a2
b1006928600959429230393369fe43b6	3593526a5f465ed766bafb4fb45748a2
478aedea838b8b4a0936b129a4c6e853	3593526a5f465ed766bafb4fb45748a2
f2856ad30734c5f838185cc08f71b1e4	3593526a5f465ed766bafb4fb45748a2
1f86700588aed0390dd27c383b7fc963	3593526a5f465ed766bafb4fb45748a2
faec47e96bfb066b7c4b8c502dc3f649	3593526a5f465ed766bafb4fb45748a2
16cf4474c5334c1d9194d003c9fb75c1	3593526a5f465ed766bafb4fb45748a2
8ed55fda3382add32869157c5b41ed47	3593526a5f465ed766bafb4fb45748a2
4e9dfdbd352f73b74e5e51b12b20923e	3593526a5f465ed766bafb4fb45748a2
88059eaa73469bb47bd41c5c3cdd1b50	3593526a5f465ed766bafb4fb45748a2
375974f4fad5caae6175c121e38174d0	3593526a5f465ed766bafb4fb45748a2
fbc2b3cebe54dd00b53967c5cf4b9192	3593526a5f465ed766bafb4fb45748a2
644f6462ec9801cdc932e5c8698ee7f9	3593526a5f465ed766bafb4fb45748a2
97724184152a2620b76e2f93902ed679	3593526a5f465ed766bafb4fb45748a2
4e74055927fd771c2084c92ca2ae56a7	3593526a5f465ed766bafb4fb45748a2
8b5a84ba35fa73f74df6f2d5a788e109	3593526a5f465ed766bafb4fb45748a2
57f622908a4d6c381241a1293d894c88	3593526a5f465ed766bafb4fb45748a2
48438b67b2ac4e5dc9df6f3723fd4ccd	3593526a5f465ed766bafb4fb45748a2
56a5afe00fae48b02301860599898e63	3593526a5f465ed766bafb4fb45748a2
3e8d4b3893a9ebbbd86e648c90cbbe63	3593526a5f465ed766bafb4fb45748a2
8b3f40e0243e2307a1818d3f456df153	3593526a5f465ed766bafb4fb45748a2
a8ace0f003d8249d012c27fe27b258b5	3593526a5f465ed766bafb4fb45748a2
5d53b2be2fe7e27daa27b94724c3b6de	3593526a5f465ed766bafb4fb45748a2
51cb62b41cd9deaaa2dd98c773a09ebb	3593526a5f465ed766bafb4fb45748a2
1ec58ca10ed8a67b1c7de3d353a2885b	3593526a5f465ed766bafb4fb45748a2
9c31bcca97bb68ec33c5a3ead4786f3e	3593526a5f465ed766bafb4fb45748a2
c445544f1de39b071a4fca8bb33c2772	3593526a5f465ed766bafb4fb45748a2
c8fbeead5c59de4e8f07ab39e7874213	3593526a5f465ed766bafb4fb45748a2
d29c61c11e6b7fb7df6d5135e5786ee1	3593526a5f465ed766bafb4fb45748a2
58e42b779d54e174aad9a9fb79e7ebbc	3593526a5f465ed766bafb4fb45748a2
955a5cfd6e05ed30eec7c79d2371ebcf	3593526a5f465ed766bafb4fb45748a2
e7a227585002db9fee2f0ed56ee5a59f	3593526a5f465ed766bafb4fb45748a2
319480a02920dc261209240eed190360	3593526a5f465ed766bafb4fb45748a2
ed9b92eb1706415c42f88dc91284da8a	3593526a5f465ed766bafb4fb45748a2
8351282db025fc2222fc61ec8dd1df23	3593526a5f465ed766bafb4fb45748a2
60eb202340e8035af9e96707f85730e5	3593526a5f465ed766bafb4fb45748a2
bcf744fa5f256d6c3051dd86943524f6	3593526a5f465ed766bafb4fb45748a2
73cb08d143f893e645292dd04967f526	3593526a5f465ed766bafb4fb45748a2
5324a886a2667283dbfe7f7974ff6fc0	3593526a5f465ed766bafb4fb45748a2
28c5f9ffd175dcd53aa3e9da9b00dde7	3593526a5f465ed766bafb4fb45748a2
6b141e284f88f656b776148cde8e019c	3593526a5f465ed766bafb4fb45748a2
7a43dd4c2bb9bea14a95ff3acd4dfb18	3593526a5f465ed766bafb4fb45748a2
9d74605e4b1d19d83992a991230e89ef	3593526a5f465ed766bafb4fb45748a2
ca54e4f7704e7b8374d0968143813fe6	3593526a5f465ed766bafb4fb45748a2
6b157916b43b09df5a22f658ccb92b64	3593526a5f465ed766bafb4fb45748a2
67cd9b4b7b33511f30e85e21b2d3b204	3593526a5f465ed766bafb4fb45748a2
b12daab6c83b1a45aa32cd9c2bc78360	3593526a5f465ed766bafb4fb45748a2
0c31e51349871cfb59cfbfaaed82eb18	3593526a5f465ed766bafb4fb45748a2
eef7d6da9ba6d0bed2078a5f253f4cfc	3593526a5f465ed766bafb4fb45748a2
45e410efd11014464dd36fb707a5a9e1	3593526a5f465ed766bafb4fb45748a2
c295bb30bf534e960a6acf7435f0e46a	3593526a5f465ed766bafb4fb45748a2
ab3ca496cbc01a5a9ed650c4d0e26168	3593526a5f465ed766bafb4fb45748a2
1de3f08835ab9d572e79ac0fca13c5c2	3593526a5f465ed766bafb4fb45748a2
4c02510c3f16e13edc27eff1ef2e452c	3593526a5f465ed766bafb4fb45748a2
7cbd455ff5af40e28a1eb97849f00723	3593526a5f465ed766bafb4fb45748a2
3c8ce0379b610d36c3723b198b982197	3593526a5f465ed766bafb4fb45748a2
18b751c8288c0fabe7b986963016884f	3593526a5f465ed766bafb4fb45748a2
30b8affc1afeb50c76ad57d7eda1f08f	3593526a5f465ed766bafb4fb45748a2
9614cbc86659974da853dee20280b8c4	3593526a5f465ed766bafb4fb45748a2
bc2f39d437ff13dff05f5cfda14327cc	3593526a5f465ed766bafb4fb45748a2
39530e3fe26ee7c557392d479cc9c93f	3593526a5f465ed766bafb4fb45748a2
2cd225725d4811d813a5ea1b701db0db	3593526a5f465ed766bafb4fb45748a2
2f6fc683428eb5f8b22cc5021dc9d40d	3593526a5f465ed766bafb4fb45748a2
2d5a306f74749cc6cbe9b6cd47e73162	3593526a5f465ed766bafb4fb45748a2
73f4b98d80efb8888a2b32073417e21e	3593526a5f465ed766bafb4fb45748a2
711a7acac82d7522230e3c7d0efc3f89	3593526a5f465ed766bafb4fb45748a2
4f58423d9f925c8e8bd73409926730e8	3593526a5f465ed766bafb4fb45748a2
96390e27bc7e2980e044791420612545	3593526a5f465ed766bafb4fb45748a2
d2c2b83008dce38013577ef83a101a1b	3593526a5f465ed766bafb4fb45748a2
d25956f771b58b6b00f338a41ca05396	3593526a5f465ed766bafb4fb45748a2
b6eba7850fd20fa8dce81167f1a6edca	3593526a5f465ed766bafb4fb45748a2
baeb191b42ec09353b389f951d19b357	3593526a5f465ed766bafb4fb45748a2
c21fe390daecee9e70b8f4b091ae316f	3593526a5f465ed766bafb4fb45748a2
8aeadeeff3e1a3e1c8a6a69d9312c530	3593526a5f465ed766bafb4fb45748a2
a4e0f3b7db0875f65bb3f55ab0aab7c6	3593526a5f465ed766bafb4fb45748a2
37b43a655dec0e3504142003fce04a07	3593526a5f465ed766bafb4fb45748a2
92e1aca33d97fa75c1e81a9db61454bb	3593526a5f465ed766bafb4fb45748a2
586ac67e6180a1f16a4d3b81e33eaa94	3593526a5f465ed766bafb4fb45748a2
080d2dc6fa136fc49fc65eee1b556b46	3593526a5f465ed766bafb4fb45748a2
1fcf2f2315b251ebe462da320491ea9f	3593526a5f465ed766bafb4fb45748a2
9c81c8c060b39e7437b2d913f036776b	3593526a5f465ed766bafb4fb45748a2
a77c14ecd429dd5dedf3dc5ea8d44b99	3593526a5f465ed766bafb4fb45748a2
69a6a78ace079846a8f0d3f89beada2c	3593526a5f465ed766bafb4fb45748a2
43ff5aadca6d8a60dd3da21716358c7d	3593526a5f465ed766bafb4fb45748a2
95800513c555e1e95a430e312ddff817	3593526a5f465ed766bafb4fb45748a2
42085fca2ddb606f4284e718074d5561	3593526a5f465ed766bafb4fb45748a2
1ace9926ad3a6dab09d16602fd2fcccc	3593526a5f465ed766bafb4fb45748a2
bdbafc49aa8c3e75e9bd1e0ee24411b4	3593526a5f465ed766bafb4fb45748a2
5863c78fb68ef1812a572e8f08a4e521	3593526a5f465ed766bafb4fb45748a2
866208c5b4a74b32974bffb0f90311ca	3593526a5f465ed766bafb4fb45748a2
d0b02893ceb72d11a3471fe18d7089fd	3593526a5f465ed766bafb4fb45748a2
b14521c0461b445a7ac2425e922c72df	3593526a5f465ed766bafb4fb45748a2
2587d892c1261be043d443d06bd5b220	3593526a5f465ed766bafb4fb45748a2
b9fd9676338e36e6493489ec5dc041fe	3593526a5f465ed766bafb4fb45748a2
04728a6272117e0dc4ec29b0f7202ad8	3593526a5f465ed766bafb4fb45748a2
c1a08f1ea753843e2b4f5f3d2cb41b7b	3593526a5f465ed766bafb4fb45748a2
2df0462e6f564f34f68866045b2a8a44	3593526a5f465ed766bafb4fb45748a2
b81dd41873676af0f9533d413774fa8d	3593526a5f465ed766bafb4fb45748a2
89d60b9528242c8c53ecbfde131eba21	3593526a5f465ed766bafb4fb45748a2
e8d17786fed9fa5ddaf13881496106e4	3593526a5f465ed766bafb4fb45748a2
0371892b7f65ffb9c1544ee35c6330ad	3593526a5f465ed766bafb4fb45748a2
169c9d1bfabf9dec8f84e1f874d5e788	3593526a5f465ed766bafb4fb45748a2
fecc75d978ad94aaa4e17b3ff9ded487	9e7315413ae31a070ccae5c580dd1b19
ee36fdf153967a0b99d3340aadeb4720	9e7315413ae31a070ccae5c580dd1b19
a99dca5593185c498b63a5eed917bd4f	9e7315413ae31a070ccae5c580dd1b19
218d618a041c057d0e05799670e7e2c8	9e7315413ae31a070ccae5c580dd1b19
a45ff5de3a96b103a192f1f133d0b0cf	9e7315413ae31a070ccae5c580dd1b19
9b7d722b58370498cd39104b2d971978	9e7315413ae31a070ccae5c580dd1b19
ac61757d33fc8563eb2409ed08e21974	9e7315413ae31a070ccae5c580dd1b19
9a8d3efa0c3389083df65f4383b155fb	9e7315413ae31a070ccae5c580dd1b19
9ff04a674682ece6ee93ca851db56387	9e7315413ae31a070ccae5c580dd1b19
b0cc1a3a1aee13a213ee73e3d4a2ce70	9e7315413ae31a070ccae5c580dd1b19
2f090f093a2868dccca81a791bc4941f	9e7315413ae31a070ccae5c580dd1b19
c2ab38206dce633f15d66048ad744f03	9e7315413ae31a070ccae5c580dd1b19
0add3cab2a932f085109a462423c3250	9e7315413ae31a070ccae5c580dd1b19
20de83abafcb071d854ca5fd57dec0e8	9e7315413ae31a070ccae5c580dd1b19
cfe122252751e124bfae54a7323bf02d	9e7315413ae31a070ccae5c580dd1b19
38734dcdff827db1dc3215e23b4e0890	9e7315413ae31a070ccae5c580dd1b19
9639834b69063b336bb744a537f80772	9e7315413ae31a070ccae5c580dd1b19
272a23811844499845c6e33712c8ba6c	9e7315413ae31a070ccae5c580dd1b19
2b068ea64f42b2ccd841bb3127ab20af	9e7315413ae31a070ccae5c580dd1b19
979b5de4a280c434213dd8559cf51bc0	9e7315413ae31a070ccae5c580dd1b19
4e9b4bdef9478154fc3ac7f5ebfb6418	9e7315413ae31a070ccae5c580dd1b19
6e064a31dc53ab956403ec3654c81f1f	9e7315413ae31a070ccae5c580dd1b19
2799b4abf06a5ec5e262d81949e2d18c	9e7315413ae31a070ccae5c580dd1b19
78bbff6bf39602a577c9d8a117116330	9e7315413ae31a070ccae5c580dd1b19
281eb11c857bbe8b6ad06dc1458e2751	9e7315413ae31a070ccae5c580dd1b19
30a100fe6a043e64ed36abb039bc9130	9e7315413ae31a070ccae5c580dd1b19
818ce28daba77cbd2c4235548400ffb2	9e7315413ae31a070ccae5c580dd1b19
2569a68a03a04a2cd73197d2cc546ff2	9e7315413ae31a070ccae5c580dd1b19
05c87189f6c230c90bb1693567233100	9e7315413ae31a070ccae5c580dd1b19
23f5e1973b5a048ffaaa0bd0183b5f87	9e7315413ae31a070ccae5c580dd1b19
309263122a445662099a3dabce2a4f17	9e7315413ae31a070ccae5c580dd1b19
3c2234a7ce973bc1700e0c743d6a819c	9e7315413ae31a070ccae5c580dd1b19
0182742917720e1b2cf59ff671738253	9e7315413ae31a070ccae5c580dd1b19
07d82d98170ab334bc66554bafa673cf	9e7315413ae31a070ccae5c580dd1b19
42f6dd3a6e21d6df71db509662d19ca4	9e7315413ae31a070ccae5c580dd1b19
3fae5bf538a263e96ff12986bf06b13f	9e7315413ae31a070ccae5c580dd1b19
0a0f6b88354de7afe84b8a07dfadcc26	9e7315413ae31a070ccae5c580dd1b19
1e71013b49bbd3b2aaa276623203453f	9e7315413ae31a070ccae5c580dd1b19
210e99a095e594f2547e1bb8a9ac6fa7	9e7315413ae31a070ccae5c580dd1b19
6ca47c71d99f608d4773b95f9b859142	9e7315413ae31a070ccae5c580dd1b19
024e91d84c3426913db8367f4df2ceb3	9e7315413ae31a070ccae5c580dd1b19
46ea4c445a9ff8e288258e3ec9cd1cf0	9e7315413ae31a070ccae5c580dd1b19
c41b9ec75e920b610e8907e066074b30	9e7315413ae31a070ccae5c580dd1b19
a91887f44d8d9fdcaa401d1c719630d7	9e7315413ae31a070ccae5c580dd1b19
fcc491ba532309d8942df543beaec67e	9e7315413ae31a070ccae5c580dd1b19
c349bc9795ba303aa49e44f64301290e	9e7315413ae31a070ccae5c580dd1b19
aa5808895fd2fca01d080618f08dca51	9e7315413ae31a070ccae5c580dd1b19
ddae1d7419331078626bc217b23ea8c7	9e7315413ae31a070ccae5c580dd1b19
fb80cd69a40a73fb3b9f22cf58fd4776	9e7315413ae31a070ccae5c580dd1b19
182a1e726ac1c8ae851194cea6df0393	9e7315413ae31a070ccae5c580dd1b19
576fea4a0c5425ba382fff5f593a33f1	9e7315413ae31a070ccae5c580dd1b19
d76db99cdd16bd0e53d5e07bcf6225c8	9e7315413ae31a070ccae5c580dd1b19
50026a2dff40e4194e184b756a7ed319	9e7315413ae31a070ccae5c580dd1b19
92edfbaa71b7361a3081991627b0e583	9e7315413ae31a070ccae5c580dd1b19
6f60a61fcc05cb4d42c81ade04392cfc	9e7315413ae31a070ccae5c580dd1b19
03fec47975e0e1e2d0bc723af47281de	9e7315413ae31a070ccae5c580dd1b19
118b96dde2f8773b011dfb27e51b2f95	9e7315413ae31a070ccae5c580dd1b19
cabcfb35912d17067131f7d2634ac270	9e7315413ae31a070ccae5c580dd1b19
e6cbb2e0653a61e35d26df2bcb6bc4c7	9e7315413ae31a070ccae5c580dd1b19
01bcfac216d2a08cd25930234e59f1a1	9e7315413ae31a070ccae5c580dd1b19
c63b6261b8bb8145bc0fd094b9732c24	9e7315413ae31a070ccae5c580dd1b19
bbbb086d59122dbb940740d6bac65976	9e7315413ae31a070ccae5c580dd1b19
e3c8afbeb0ec4736db977d18e7e37020	9e7315413ae31a070ccae5c580dd1b19
94a62730604a985647986b509818efee	9e7315413ae31a070ccae5c580dd1b19
99bdf8d95da8972f6979bead2f2e2090	9e7315413ae31a070ccae5c580dd1b19
156c19a6d9137e04b94500642d1cb8c2	9e7315413ae31a070ccae5c580dd1b19
cd3296ec8f7773892de22dfade4f1b04	9e7315413ae31a070ccae5c580dd1b19
2db1850a4fe292bd2706ffd78dbe44b9	9e7315413ae31a070ccae5c580dd1b19
ce14eb923a380597f2aff8b65a742048	9e7315413ae31a070ccae5c580dd1b19
a7111b594249d6a038281deb74ef0d04	9e7315413ae31a070ccae5c580dd1b19
852c0b6d5b315c823cdf0382ca78e47f	9e7315413ae31a070ccae5c580dd1b19
c311f3f7c84d1524104b369499bd582f	9e7315413ae31a070ccae5c580dd1b19
1629fa6d4b8adb36b0e4a245b234b826	9e7315413ae31a070ccae5c580dd1b19
270fb708bd03433e554e0d7345630c8e	9e7315413ae31a070ccae5c580dd1b19
9d1e68b7debd0c8dc86d5d6500884ab4	9e7315413ae31a070ccae5c580dd1b19
eb0a191797624dd3a48fa681d3061212	9e7315413ae31a070ccae5c580dd1b19
e9648f919ee5adda834287bbdf6210fd	9e7315413ae31a070ccae5c580dd1b19
3929665297ca814b966cb254980262cb	9e7315413ae31a070ccae5c580dd1b19
d1fded22db9fc8872e86fff12d511207	9e7315413ae31a070ccae5c580dd1b19
b7b99e418cff42d14dbf2d63ecee12a8	9e7315413ae31a070ccae5c580dd1b19
57f622908a4d6c381241a1293d894c88	9e7315413ae31a070ccae5c580dd1b19
48438b67b2ac4e5dc9df6f3723fd4ccd	9e7315413ae31a070ccae5c580dd1b19
c46e8abb68aae0bcdc68021a46f71a65	9e7315413ae31a070ccae5c580dd1b19
e4f74be13850fc65559a3ed855bf35a8	9e7315413ae31a070ccae5c580dd1b19
278af3c810bb9de0f355ce115b5a2f54	9e7315413ae31a070ccae5c580dd1b19
8b0cfde05d166f42a11a01814ef7fa86	9e7315413ae31a070ccae5c580dd1b19
a8ace0f003d8249d012c27fe27b258b5	9e7315413ae31a070ccae5c580dd1b19
255661921f4ad57d02b1de9062eb6421	9e7315413ae31a070ccae5c580dd1b19
e71bd61e28ae2a584cb17ed776075b55	9e7315413ae31a070ccae5c580dd1b19
1c13f340d154b44e41c996ec08d76749	9e7315413ae31a070ccae5c580dd1b19
a89af36e042b5aa91d6efea0cc283c02	9e7315413ae31a070ccae5c580dd1b19
384712ec65183407ac811fff2f4c4798	9e7315413ae31a070ccae5c580dd1b19
a76c5f98a56fc03100d6a7936980c563	9e7315413ae31a070ccae5c580dd1b19
c091e33f684c206b73b25417f6640b71	9e7315413ae31a070ccae5c580dd1b19
df99cee44099ff57acbf7932670614dd	9e7315413ae31a070ccae5c580dd1b19
6b141e284f88f656b776148cde8e019c	9e7315413ae31a070ccae5c580dd1b19
ca54e4f7704e7b8374d0968143813fe6	9e7315413ae31a070ccae5c580dd1b19
5c29c2e513aadfe372fd0af7553b5a6c	9e7315413ae31a070ccae5c580dd1b19
e4b1d8cc71fd9c1fbc40fdc1a1a5d5b3	9e7315413ae31a070ccae5c580dd1b19
eef7d6da9ba6d0bed2078a5f253f4cfc	9e7315413ae31a070ccae5c580dd1b19
ad51cbe70d798b5aec08caf64ce66094	9e7315413ae31a070ccae5c580dd1b19
45e410efd11014464dd36fb707a5a9e1	9e7315413ae31a070ccae5c580dd1b19
4c02510c3f16e13edc27eff1ef2e452c	9e7315413ae31a070ccae5c580dd1b19
087c643d95880c5a89fc13f3246bebae	9e7315413ae31a070ccae5c580dd1b19
be553803806b8634990c2eb7351ed489	9e7315413ae31a070ccae5c580dd1b19
a8a43e21de5b4d83a6a7374112871079	9e7315413ae31a070ccae5c580dd1b19
9614cbc86659974da853dee20280b8c4	9e7315413ae31a070ccae5c580dd1b19
bc2f39d437ff13dff05f5cfda14327cc	9e7315413ae31a070ccae5c580dd1b19
d192d350b6eace21e325ecf9b0f1ebd1	9e7315413ae31a070ccae5c580dd1b19
96390e27bc7e2980e044791420612545	9e7315413ae31a070ccae5c580dd1b19
5159ae414608a804598452b279491c5c	9e7315413ae31a070ccae5c580dd1b19
5bb416e14ac19276a4b450d343e4e981	9e7315413ae31a070ccae5c580dd1b19
9c81c8c060b39e7437b2d913f036776b	9e7315413ae31a070ccae5c580dd1b19
a77c14ecd429dd5dedf3dc5ea8d44b99	9e7315413ae31a070ccae5c580dd1b19
95800513c555e1e95a430e312ddff817	9e7315413ae31a070ccae5c580dd1b19
05256decaa2ee2337533d95c7de3db9d	9e7315413ae31a070ccae5c580dd1b19
a0d3b444bd04cd165b4e076c9fc18bee	9e7315413ae31a070ccae5c580dd1b19
c846d80d826291f2a6a0d7a57e540307	9e7315413ae31a070ccae5c580dd1b19
0925467e1cc53074a440dae7ae67e3e9	9e7315413ae31a070ccae5c580dd1b19
b14521c0461b445a7ac2425e922c72df	9e7315413ae31a070ccae5c580dd1b19
78f5c568100eb61401870fa0fa4fd7cb	9e7315413ae31a070ccae5c580dd1b19
2df0462e6f564f34f68866045b2a8a44	9e7315413ae31a070ccae5c580dd1b19
2045b9a6609f6d5bca3374fd370e54ff	9e7315413ae31a070ccae5c580dd1b19
11a7f956c37bf0459e9c80b16cc72107	9e7315413ae31a070ccae5c580dd1b19
e37015150c8944d90e306f19eaa98de8	9e7315413ae31a070ccae5c580dd1b19
90fb95c00db3fde6b86e6accf2178fa7	9e7315413ae31a070ccae5c580dd1b19
169c9d1bfabf9dec8f84e1f874d5e788	9e7315413ae31a070ccae5c580dd1b19
844de407cd83ea1716f1ff57ea029285	2db87892408abd4d82eb39b78c50c27b
88726e1a911181e20cf8be52e1027f26	2db87892408abd4d82eb39b78c50c27b
aa5e46574bdc6034f4d49540c0c2d1ad	2db87892408abd4d82eb39b78c50c27b
2f090f093a2868dccca81a791bc4941f	2db87892408abd4d82eb39b78c50c27b
90669320cd8e4a09bf655310bffdb9ba	2db87892408abd4d82eb39b78c50c27b
b9ffbdbbe63789cc6fa9ee2548a1b2ed	2db87892408abd4d82eb39b78c50c27b
647dadd75e050b230269e43a4fe351e2	2db87892408abd4d82eb39b78c50c27b
3e28a735f3fc31a9c8c30b47872634bf	2db87892408abd4d82eb39b78c50c27b
aa98c9e445775e7c945661e91cf7e7aa	2db87892408abd4d82eb39b78c50c27b
a20050efc491a9784b5cced21116ba68	2db87892408abd4d82eb39b78c50c27b
781c745a0d6b02cdecadf2e44d445d1a	2db87892408abd4d82eb39b78c50c27b
dfa61d19b62369a37743b38215836df9	2db87892408abd4d82eb39b78c50c27b
c5f4e658dfe7b7af3376f06d7cd18a2a	2db87892408abd4d82eb39b78c50c27b
e20976feda6d915a74c751cbf488a241	2db87892408abd4d82eb39b78c50c27b
b3d0eb96687420dc4e5b10602ac42690	2db87892408abd4d82eb39b78c50c27b
05c87189f6c230c90bb1693567233100	2db87892408abd4d82eb39b78c50c27b
77bfe8d21f1ecc592062f91c9253d8ab	2db87892408abd4d82eb39b78c50c27b
472e67129f0c7add77c7c907dac3351f	2db87892408abd4d82eb39b78c50c27b
f3b8f1a2417bdc483f4e2306ac6004b2	2db87892408abd4d82eb39b78c50c27b
bf2c8729bf5c149067d8e978ea3dcd32	2db87892408abd4d82eb39b78c50c27b
72b73895941b319645450521aad394e8	2db87892408abd4d82eb39b78c50c27b
5cc06303f490f3c34a464dfdc1bfb120	2db87892408abd4d82eb39b78c50c27b
0964b5218635a1c51ff24543ee242514	2db87892408abd4d82eb39b78c50c27b
42f6dd3a6e21d6df71db509662d19ca4	2db87892408abd4d82eb39b78c50c27b
1dc7d7d977193974deaa993eb373e714	2db87892408abd4d82eb39b78c50c27b
c41b9ec75e920b610e8907e066074b30	2db87892408abd4d82eb39b78c50c27b
63a9f0ea7bb98050796b649e85481845	2db87892408abd4d82eb39b78c50c27b
381b834c6bf7b25b9b627c9eeb81dd8a	2db87892408abd4d82eb39b78c50c27b
5934340f46d5ab773394d7a8ac9e86d5	2db87892408abd4d82eb39b78c50c27b
6af2c726b2d705f08d05a7ee9509916e	2db87892408abd4d82eb39b78c50c27b
218ac7d899a995dc53cabe52da9ed678	2db87892408abd4d82eb39b78c50c27b
364be07c2428493479a07dbefdacc11f	2db87892408abd4d82eb39b78c50c27b
fd0a7850818a9a642a125b588d83e537	2db87892408abd4d82eb39b78c50c27b
a30c1309e683fcf26c104b49227d2220	2db87892408abd4d82eb39b78c50c27b
f9ff0bcbb45bdf8a67395fa0ab3737b5	2db87892408abd4d82eb39b78c50c27b
876eed60be80010455ff50a62ccf1256	2db87892408abd4d82eb39b78c50c27b
1629fa6d4b8adb36b0e4a245b234b826	2db87892408abd4d82eb39b78c50c27b
270fb708bd03433e554e0d7345630c8e	2db87892408abd4d82eb39b78c50c27b
b1006928600959429230393369fe43b6	2db87892408abd4d82eb39b78c50c27b
410044b393ebe6a519fde1bdb26d95e8	2db87892408abd4d82eb39b78c50c27b
867872f29491a6473dae8075c740993e	2db87892408abd4d82eb39b78c50c27b
c937fc1b6be0464ec9d17389913871e4	2db87892408abd4d82eb39b78c50c27b
e9648f919ee5adda834287bbdf6210fd	2db87892408abd4d82eb39b78c50c27b
faec47e96bfb066b7c4b8c502dc3f649	2db87892408abd4d82eb39b78c50c27b
8e38937886f365bb96aa1c189c63c5ea	2db87892408abd4d82eb39b78c50c27b
8ed55fda3382add32869157c5b41ed47	2db87892408abd4d82eb39b78c50c27b
4e9dfdbd352f73b74e5e51b12b20923e	2db87892408abd4d82eb39b78c50c27b
56e8538c55d35a1c23286442b4bccd26	2db87892408abd4d82eb39b78c50c27b
644f6462ec9801cdc932e5c8698ee7f9	2db87892408abd4d82eb39b78c50c27b
b3626b52d8b98e9aebebaa91ea2a2c91	2db87892408abd4d82eb39b78c50c27b
4e74055927fd771c2084c92ca2ae56a7	2db87892408abd4d82eb39b78c50c27b
57f622908a4d6c381241a1293d894c88	2db87892408abd4d82eb39b78c50c27b
5c61f833c2fb87caab0a48e4c51fa629	2db87892408abd4d82eb39b78c50c27b
2859f0ed0630ecc1589b6868fd1dde41	2db87892408abd4d82eb39b78c50c27b
c0118be307a26886822e1194e8ae246d	2db87892408abd4d82eb39b78c50c27b
a66394e41d764b4c5646446a8ba2028b	2db87892408abd4d82eb39b78c50c27b
24701da4bd9d3ae0e64d263b72ad20e8	2db87892408abd4d82eb39b78c50c27b
8734f7ff367f59fc11ad736e63e818f9	2db87892408abd4d82eb39b78c50c27b
430a03604913a64c33f460ec6f854c36	2db87892408abd4d82eb39b78c50c27b
fb1afbea5c0c2e23396ef429d0e42c52	2db87892408abd4d82eb39b78c50c27b
d2f79e6a931cd5b5acd5f3489dece82a	2db87892408abd4d82eb39b78c50c27b
3258eb5f24b395695f56eee13b690da6	2db87892408abd4d82eb39b78c50c27b
8f7939c28270f3187210641e96a98ba7	2db87892408abd4d82eb39b78c50c27b
bcf744fa5f256d6c3051dd86943524f6	2db87892408abd4d82eb39b78c50c27b
3ba296bfb94ad521be221cf9140f8e10	2db87892408abd4d82eb39b78c50c27b
18e21eae8f909cbb44b5982b44bbf02f	2db87892408abd4d82eb39b78c50c27b
6b141e284f88f656b776148cde8e019c	2db87892408abd4d82eb39b78c50c27b
41dabe0c59a3233e3691f3c893eb789e	2db87892408abd4d82eb39b78c50c27b
7b91dc9ecdfa3ea7d347588a63537bb9	2db87892408abd4d82eb39b78c50c27b
8bdd6b50b8ecca33e04837fde8ffe51e	2db87892408abd4d82eb39b78c50c27b
a8a43e21de5b4d83a6a7374112871079	2db87892408abd4d82eb39b78c50c27b
f6eb4364ba53708b24a4141962feb82e	2db87892408abd4d82eb39b78c50c27b
dba84ece8f49717c47ab72acc3ed2965	2db87892408abd4d82eb39b78c50c27b
711a7acac82d7522230e3c7d0efc3f89	2db87892408abd4d82eb39b78c50c27b
1506aeeb8c3a699b1e3c87db03156428	2db87892408abd4d82eb39b78c50c27b
4f58423d9f925c8e8bd73409926730e8	2db87892408abd4d82eb39b78c50c27b
c1e8b6d7a1c20870d5955bcdc04363e4	2db87892408abd4d82eb39b78c50c27b
480a0efd668e568595d42ac78340fe2a	2db87892408abd4d82eb39b78c50c27b
95a1f9b6006151e00b1a4cda721f469d	2db87892408abd4d82eb39b78c50c27b
9bdbe50a5be5b9c92dccf2d1ef05eefd	2db87892408abd4d82eb39b78c50c27b
8c4e8003f8d708dc3b6d486d74d9a585	2db87892408abd4d82eb39b78c50c27b
5f27f488f7c8b9e4b81f59c6d776e25c	2db87892408abd4d82eb39b78c50c27b
92e1aca33d97fa75c1e81a9db61454bb	2db87892408abd4d82eb39b78c50c27b
7022f6b60d9642d91eebba98185cd9ba	2db87892408abd4d82eb39b78c50c27b
0d01b12a6783b4e60d2e09e16431f00a	2db87892408abd4d82eb39b78c50c27b
31e2d1e0b364475375cb17ad76aa71f2	2db87892408abd4d82eb39b78c50c27b
69a6a78ace079846a8f0d3f89beada2c	2db87892408abd4d82eb39b78c50c27b
cb0785d67b1ea8952fae42efd82864a7	2db87892408abd4d82eb39b78c50c27b
658a9bbd0e85d854a9e140672a46ce3a	2db87892408abd4d82eb39b78c50c27b
6fa204dccaff0ec60f96db5fb5e69b33	2db87892408abd4d82eb39b78c50c27b
0d949e45a18d81db3491a7b451e99560	2db87892408abd4d82eb39b78c50c27b
f68a3eafcc0bb036ee8fde7fc91cde13	2db87892408abd4d82eb39b78c50c27b
78f5c568100eb61401870fa0fa4fd7cb	2db87892408abd4d82eb39b78c50c27b
f159fc50b5af54fecf21d5ea6ec37bad	2db87892408abd4d82eb39b78c50c27b
f520f53edf44d466fb64269d5a67b69a	2db87892408abd4d82eb39b78c50c27b
61e5d7cb15bd519ceddcf7ba9a22cbc6	2db87892408abd4d82eb39b78c50c27b
9563a6fd049d7c1859196f614b04b959	2db87892408abd4d82eb39b78c50c27b
90fb95c00db3fde6b86e6accf2178fa7	2db87892408abd4d82eb39b78c50c27b
b80aecda9ce9783dab49037eec5e4388	2db87892408abd4d82eb39b78c50c27b
b81dd41873676af0f9533d413774fa8d	2db87892408abd4d82eb39b78c50c27b
28bc0abd0cf390a4472b1f60bd0cfe4a	d725d2ec3a5cfa9f6384d9870df72400
d02f33b44582e346050cefadce93eb95	d725d2ec3a5cfa9f6384d9870df72400
298a577c621a7a1c365465f694e0bd13	d725d2ec3a5cfa9f6384d9870df72400
647a73dd79f06cdf74e1fa7524700161	d725d2ec3a5cfa9f6384d9870df72400
a0cdbd2af8f1ddbb2748a2eaddce55da	d725d2ec3a5cfa9f6384d9870df72400
a985c9764e0e6d738ff20f2328a0644b	d725d2ec3a5cfa9f6384d9870df72400
a45ff5de3a96b103a192f1f133d0b0cf	d725d2ec3a5cfa9f6384d9870df72400
bd9059497b4af2bb913a8522747af2de	d725d2ec3a5cfa9f6384d9870df72400
491801c872c67db465fda0f8f180569d	d725d2ec3a5cfa9f6384d9870df72400
4e9b4bdef9478154fc3ac7f5ebfb6418	d725d2ec3a5cfa9f6384d9870df72400
6e064a31dc53ab956403ec3654c81f1f	d725d2ec3a5cfa9f6384d9870df72400
0ab01e57304a70cf4f7f037bd8afbe49	d725d2ec3a5cfa9f6384d9870df72400
71144850f4fb4cc55fc0ee6935badddf	d725d2ec3a5cfa9f6384d9870df72400
05fcf330d8fafb0a1f17ce30ff60b924	d725d2ec3a5cfa9f6384d9870df72400
82f43cc1bda0b09efff9b356af97c7ab	d725d2ec3a5cfa9f6384d9870df72400
d908b6b9019639bced6d1e31463eea85	d725d2ec3a5cfa9f6384d9870df72400
e4f13074d445d798488cb00fa0c5fbd4	d725d2ec3a5cfa9f6384d9870df72400
563fcbf5f44e03e0eeb9c8d6e4c8e127	d725d2ec3a5cfa9f6384d9870df72400
f1022ae1bc6b46d51889e0bb5ea8b64f	d725d2ec3a5cfa9f6384d9870df72400
cbf6de82cf77ca17d17d293d6d29a2b2	d725d2ec3a5cfa9f6384d9870df72400
3c2234a7ce973bc1700e0c743d6a819c	d725d2ec3a5cfa9f6384d9870df72400
24af2861df3c72c8f1b947333bd215fc	d725d2ec3a5cfa9f6384d9870df72400
dcdcd2f22b1d5f85fa5dd68fa89e3756	d725d2ec3a5cfa9f6384d9870df72400
240e556541427d81f4ed1eda86f33ad3	d725d2ec3a5cfa9f6384d9870df72400
6ffa656be5ff3db085578f54a05d4ddb	d725d2ec3a5cfa9f6384d9870df72400
dddbd203ace7db250884ded880ea7be4	d725d2ec3a5cfa9f6384d9870df72400
ef75c0b43ae9ba972900e83c5ccf5cac	d725d2ec3a5cfa9f6384d9870df72400
79cbf009784a729575e50a3ef4a3b1cc	d725d2ec3a5cfa9f6384d9870df72400
e6cbb2e0653a61e35d26df2bcb6bc4c7	d725d2ec3a5cfa9f6384d9870df72400
445a222489d55b5768ec2f17b1c3ea34	d725d2ec3a5cfa9f6384d9870df72400
60eb61670a5385e3150cd87f915b0967	d725d2ec3a5cfa9f6384d9870df72400
5c19e1e0521f7b789a37a21c5cd5737b	d725d2ec3a5cfa9f6384d9870df72400
f4b526ea92d3389d318a36e51480b4c8	d725d2ec3a5cfa9f6384d9870df72400
dbf1b3eb1f030affb41473a8fa69bc0c	d725d2ec3a5cfa9f6384d9870df72400
2fb81ca1d0a935be4cb49028268baa3f	d725d2ec3a5cfa9f6384d9870df72400
3969716fc4acd0ec0c39c8a745e9459a	d725d2ec3a5cfa9f6384d9870df72400
c46e8abb68aae0bcdc68021a46f71a65	d725d2ec3a5cfa9f6384d9870df72400
e9e0664816c35d64f26fc1382708617b	d725d2ec3a5cfa9f6384d9870df72400
1c13f340d154b44e41c996ec08d76749	d725d2ec3a5cfa9f6384d9870df72400
13909e3013727a91ee750bfd8660d7bc	d725d2ec3a5cfa9f6384d9870df72400
74e8b6c4be8a0f5dd843e2d1d7385a36	d725d2ec3a5cfa9f6384d9870df72400
1a5235c012c18789e81960333a76cd7a	d725d2ec3a5cfa9f6384d9870df72400
b8d794c48196d514010ce2c2269b4102	d725d2ec3a5cfa9f6384d9870df72400
7fcdd5f715be5fce835b68b9e63e1733	d725d2ec3a5cfa9f6384d9870df72400
5214513d882cf478e028201a0d9031c0	d725d2ec3a5cfa9f6384d9870df72400
ab42c2d958e2571ce5403391e9910c40	d725d2ec3a5cfa9f6384d9870df72400
45d62f43d6f59291905d097790f74ade	d725d2ec3a5cfa9f6384d9870df72400
e37e9fd6bde7509157f864942572c267	d725d2ec3a5cfa9f6384d9870df72400
2045b9a6609f6d5bca3374fd370e54ff	d725d2ec3a5cfa9f6384d9870df72400
265dbcbd2bce07dfa721ed3daaa30912	d725d2ec3a5cfa9f6384d9870df72400
048d40092f9bd3c450e4bdeeff69e8c3	7b4b7e3375c9f7424a57a2d9d7bccde5
d9c849266ee3ac1463262df200b3aab8	7b4b7e3375c9f7424a57a2d9d7bccde5
16a56d0941a310c3dc4f967041574300	7b4b7e3375c9f7424a57a2d9d7bccde5
748ac622dcfda98f59c3c99593226a75	7b4b7e3375c9f7424a57a2d9d7bccde5
a4bcd57d5cda816e4ffd1f83031a36ca	7b4b7e3375c9f7424a57a2d9d7bccde5
ec5c65bfe530446b696f04e51aa19201	7b4b7e3375c9f7424a57a2d9d7bccde5
de3e4c12f56a35dc1ee6866b1ddd9d53	7b4b7e3375c9f7424a57a2d9d7bccde5
13d81f0ed06478714344fd0f1a6a81bb	7b4b7e3375c9f7424a57a2d9d7bccde5
ac8eab98e370e2a8711bad327f5f7c55	7b4b7e3375c9f7424a57a2d9d7bccde5
02677b661c84417492e1c1cb0b0563b2	7b4b7e3375c9f7424a57a2d9d7bccde5
05ee6afed8d828d4e7ed35b0483527f7	7b4b7e3375c9f7424a57a2d9d7bccde5
0feeee5d5e0738c1929bf064b184409b	7b4b7e3375c9f7424a57a2d9d7bccde5
1fd7fc9c73539bee88e1ec137b5f9ad2	7b4b7e3375c9f7424a57a2d9d7bccde5
436f76ddf806e8c3cbdc9494867d0f79	7b4b7e3375c9f7424a57a2d9d7bccde5
118c9af69a42383387e8ce6ab22867d7	7b4b7e3375c9f7424a57a2d9d7bccde5
541fa0085b17ef712791151ca285f1a7	7b4b7e3375c9f7424a57a2d9d7bccde5
4f5b2e20e9b7e5cc3f53256583033752	7b4b7e3375c9f7424a57a2d9d7bccde5
66597873e0974fb365454a5087291094	7b4b7e3375c9f7424a57a2d9d7bccde5
891b302f7508f0772a8fdb71ccbf9868	7b4b7e3375c9f7424a57a2d9d7bccde5
0d8ef82742e1d5de19b5feb5ecb3aed3	7b4b7e3375c9f7424a57a2d9d7bccde5
e039d55ed63a723001867bc4eb842c00	7b4b7e3375c9f7424a57a2d9d7bccde5
99761fad57f035550a1ca48e47f35157	7b4b7e3375c9f7424a57a2d9d7bccde5
123f90461d74091a96637955d14a1401	7b4b7e3375c9f7424a57a2d9d7bccde5
96aa953534221db484e6ec75b64fcc4d	7b4b7e3375c9f7424a57a2d9d7bccde5
f44f1e343975f5157f3faf9184bc7ade	7b4b7e3375c9f7424a57a2d9d7bccde5
1e986acf38de5f05edc2c42f4a49d37e	7b4b7e3375c9f7424a57a2d9d7bccde5
b834eadeaf680f6ffcb13068245a1fed	7b4b7e3375c9f7424a57a2d9d7bccde5
1ec58ca10ed8a67b1c7de3d353a2885b	7b4b7e3375c9f7424a57a2d9d7bccde5
8f523603c24072fb8ccb547503ee4c0f	7b4b7e3375c9f7424a57a2d9d7bccde5
8fa1a366d4f2e520bc9354658c4709f1	7b4b7e3375c9f7424a57a2d9d7bccde5
812f48abd93f276576541ec5b79d48a2	7b4b7e3375c9f7424a57a2d9d7bccde5
7013a75091bf79f04f07eecc248f8ee6	7b4b7e3375c9f7424a57a2d9d7bccde5
67493f858802a478bfe539c8e30a7e44	7b4b7e3375c9f7424a57a2d9d7bccde5
03201e85fc6aa56d2cb9374e84bf52ca	7b4b7e3375c9f7424a57a2d9d7bccde5
bc111d75a59fe7191a159fd4ee927981	7b4b7e3375c9f7424a57a2d9d7bccde5
017e06f9b9bccafa230a81b60ea34c46	7b4b7e3375c9f7424a57a2d9d7bccde5
d2f62cd276ef7cab5dcf9218d68f5bcf	7b4b7e3375c9f7424a57a2d9d7bccde5
b798aa74946ce75baee5806352e96272	7b4b7e3375c9f7424a57a2d9d7bccde5
6315887dd67ff4f91d51e956b06a3878	7b4b7e3375c9f7424a57a2d9d7bccde5
05e76572fb3d16ca990a91681758bbee	7b4b7e3375c9f7424a57a2d9d7bccde5
cfc61472d8abd7c54b81924119983ed9	7b4b7e3375c9f7424a57a2d9d7bccde5
1fe0175f73e5b381213057da98b8f5fb	7b4b7e3375c9f7424a57a2d9d7bccde5
d44be0e711c2711876734b330500e5b9	7b4b7e3375c9f7424a57a2d9d7bccde5
538eaaef4d029c255ad8416c01ab5719	7b4b7e3375c9f7424a57a2d9d7bccde5
3d4fe2107d6302760654b4217cf32f17	7b4b7e3375c9f7424a57a2d9d7bccde5
80d331992feb02627ae8b30687c7bb78	7b4b7e3375c9f7424a57a2d9d7bccde5
77f94851e582202f940198a26728e71f	7b4b7e3375c9f7424a57a2d9d7bccde5
0ba2f4073dd8eff1f91650af5dc67db4	7b4b7e3375c9f7424a57a2d9d7bccde5
cd3faaaf1bebf8d009aa59f887d17ef2	7b4b7e3375c9f7424a57a2d9d7bccde5
33538745a71fe2d30689cac96737e8f7	7b4b7e3375c9f7424a57a2d9d7bccde5
586ac67e6180a1f16a4d3b81e33eaa94	7b4b7e3375c9f7424a57a2d9d7bccde5
645b264cb978b22bb2d2c70433723ec0	7b4b7e3375c9f7424a57a2d9d7bccde5
45816111a5b644493b68cfedfb1a0cc0	7b4b7e3375c9f7424a57a2d9d7bccde5
d0e551d6887e0657952b3c5beb7fed74	7b4b7e3375c9f7424a57a2d9d7bccde5
06c1680c65972c4332be73e726de9e74	7b4b7e3375c9f7424a57a2d9d7bccde5
4671068076f66fb346c4f62cbfb7f9fe	7b4b7e3375c9f7424a57a2d9d7bccde5
3771036a0740658b11cf5eb73d9263b3	7b4b7e3375c9f7424a57a2d9d7bccde5
6b37fe4703bd962004cdccda304cc18e	7b4b7e3375c9f7424a57a2d9d7bccde5
371d905385644b0ecb176fd73184239c	7b4b7e3375c9f7424a57a2d9d7bccde5
d871ebaec65bbfa0b6b97aefae5d9150	7b4b7e3375c9f7424a57a2d9d7bccde5
28bb3f229ca1eeb05ef939248f7709ce	7b4b7e3375c9f7424a57a2d9d7bccde5
0e4f0487408be5baf091b74ba765dce7	7b4b7e3375c9f7424a57a2d9d7bccde5
6829c770c1de2fd9bd88fe91f1d42f56	7b4b7e3375c9f7424a57a2d9d7bccde5
98dd2a77f081989a185cb652662eea41	7b4b7e3375c9f7424a57a2d9d7bccde5
807dbc2d5a3525045a4b7d882e3768ee	7b4b7e3375c9f7424a57a2d9d7bccde5
bff322dbe273a1e2d1fe37f81acccbe4	7b4b7e3375c9f7424a57a2d9d7bccde5
f041991eb3263fd3e5d919026e772f57	7b4b7e3375c9f7424a57a2d9d7bccde5
70409bc559ef6c8aabcf16941a29788b	7b4b7e3375c9f7424a57a2d9d7bccde5
fecc75d978ad94aaa4e17b3ff9ded487	b54875674f7d2d5be9737b0d4c021a21
93299af7c9e3c63c7b3d9bb2242c9d6b	b54875674f7d2d5be9737b0d4c021a21
b4c5b422ab8969880d9f0f0e9124f0d7	b54875674f7d2d5be9737b0d4c021a21
717ec52870493e8460d6aeddd9b7def8	b54875674f7d2d5be9737b0d4c021a21
781c745a0d6b02cdecadf2e44d445d1a	b54875674f7d2d5be9737b0d4c021a21
6d25c7ad58121b3effe2c464b851c27a	b54875674f7d2d5be9737b0d4c021a21
f2a863a08c3e22cc942264ac4bc606e3	b54875674f7d2d5be9737b0d4c021a21
de1e0ed5433f5e95c8f48e18e1c75ff6	b54875674f7d2d5be9737b0d4c021a21
d5ec808c760249f11fbcde2bf4977cc6	b54875674f7d2d5be9737b0d4c021a21
5637bae1665ae86050cb41fb1cdcc3ee	b54875674f7d2d5be9737b0d4c021a21
4e7054dff89623f323332052d0c7ff6e	b54875674f7d2d5be9737b0d4c021a21
009f51181eb8c6bb5bb792af9a2fdd07	b54875674f7d2d5be9737b0d4c021a21
55b6aa6562faa9381e43ea82a4991079	b54875674f7d2d5be9737b0d4c021a21
cd80c766840b7011fbf48355c0142431	b54875674f7d2d5be9737b0d4c021a21
92edfbaa71b7361a3081991627b0e583	b54875674f7d2d5be9737b0d4c021a21
073f87af06b8d8bc561bb3f74e5f714f	b54875674f7d2d5be9737b0d4c021a21
f32badb09f6aacb398d3cd690d90a668	b54875674f7d2d5be9737b0d4c021a21
a2a607567311cb7a5a609146b977f4a9	b54875674f7d2d5be9737b0d4c021a21
faec47e96bfb066b7c4b8c502dc3f649	b54875674f7d2d5be9737b0d4c021a21
d1fded22db9fc8872e86fff12d511207	b54875674f7d2d5be9737b0d4c021a21
4ca1c3ed413577a259e29dfa053f99db	b54875674f7d2d5be9737b0d4c021a21
eb2743e9025319c014c9011acf1a1679	b54875674f7d2d5be9737b0d4c021a21
c27297705354ef77feb349e949d2e19e	b54875674f7d2d5be9737b0d4c021a21
537e5aa87fcfb168be5c953d224015ff	b54875674f7d2d5be9737b0d4c021a21
5159ae414608a804598452b279491c5c	b54875674f7d2d5be9737b0d4c021a21
cd3faaaf1bebf8d009aa59f887d17ef2	b54875674f7d2d5be9737b0d4c021a21
586ac67e6180a1f16a4d3b81e33eaa94	b54875674f7d2d5be9737b0d4c021a21
d5a5e9d2edeb2b2c685364461f1dfd46	b54875674f7d2d5be9737b0d4c021a21
4522c5141f18b2a408fc8c1b00827bc3	b54875674f7d2d5be9737b0d4c021a21
5ec194adf19442544d8a94f4696f17dc	b54875674f7d2d5be9737b0d4c021a21
dff880ae9847f6fa8ed628ed4ee5741b	b54875674f7d2d5be9737b0d4c021a21
a77c14ecd429dd5dedf3dc5ea8d44b99	b54875674f7d2d5be9737b0d4c021a21
db732a1a9861777294f7dc54eeca2b3e	b54875674f7d2d5be9737b0d4c021a21
c664656f67e963f4c0f651195f818ce0	b54875674f7d2d5be9737b0d4c021a21
810f28b77fa6c866fbcceb6c8aa7bac4	b54875674f7d2d5be9737b0d4c021a21
c8fd07f040a8f2dc85f5b2d3804ea3db	b54875674f7d2d5be9737b0d4c021a21
fd3ab918dab082b1af1df5f9dbc0041f	b54875674f7d2d5be9737b0d4c021a21
867e7f73257c5adf6a4696f252556431	b54875674f7d2d5be9737b0d4c021a21
f8b01df5282702329fcd1cae8877bb5f	b54875674f7d2d5be9737b0d4c021a21
8845da022807c76120b5b6f50c218d9a	b54875674f7d2d5be9737b0d4c021a21
f520f53edf44d466fb64269d5a67b69a	b54875674f7d2d5be9737b0d4c021a21
e3e9ccd75f789b9689913b30cb528be0	0a8a13bf87abe8696fbae4efe2b7f874
9436650a453053e775897ef5733e88fe	0a8a13bf87abe8696fbae4efe2b7f874
14af57131cbbf57afb206c8707fdab6c	0a8a13bf87abe8696fbae4efe2b7f874
3577f7160794aa4ba4d79d0381aefdb1	0a8a13bf87abe8696fbae4efe2b7f874
717ec52870493e8460d6aeddd9b7def8	0a8a13bf87abe8696fbae4efe2b7f874
20de83abafcb071d854ca5fd57dec0e8	0a8a13bf87abe8696fbae4efe2b7f874
9639834b69063b336bb744a537f80772	0a8a13bf87abe8696fbae4efe2b7f874
4e9b4bdef9478154fc3ac7f5ebfb6418	0a8a13bf87abe8696fbae4efe2b7f874
71ac59780209b4c074690c44a3bba3b7	0a8a13bf87abe8696fbae4efe2b7f874
818ce28daba77cbd2c4235548400ffb2	0a8a13bf87abe8696fbae4efe2b7f874
de1e0ed5433f5e95c8f48e18e1c75ff6	0a8a13bf87abe8696fbae4efe2b7f874
4dde2c290e3ee11bd3bd1ecd27d7039a	0a8a13bf87abe8696fbae4efe2b7f874
4e7054dff89623f323332052d0c7ff6e	0a8a13bf87abe8696fbae4efe2b7f874
55b6aa6562faa9381e43ea82a4991079	0a8a13bf87abe8696fbae4efe2b7f874
0a0f6b88354de7afe84b8a07dfadcc26	0a8a13bf87abe8696fbae4efe2b7f874
6ca47c71d99f608d4773b95f9b859142	0a8a13bf87abe8696fbae4efe2b7f874
576fea4a0c5425ba382fff5f593a33f1	0a8a13bf87abe8696fbae4efe2b7f874
13c8bd3a0d92bd186fc5162eded4431d	0a8a13bf87abe8696fbae4efe2b7f874
03fec47975e0e1e2d0bc723af47281de	0a8a13bf87abe8696fbae4efe2b7f874
cabcfb35912d17067131f7d2634ac270	0a8a13bf87abe8696fbae4efe2b7f874
3123e3df482127074cdd5f830072c898	0a8a13bf87abe8696fbae4efe2b7f874
26c2bb18f3a9a0c6d1392dae296cfea7	0a8a13bf87abe8696fbae4efe2b7f874
56bf60ca682b8f68e8843ad8a55c6b17	0a8a13bf87abe8696fbae4efe2b7f874
827bf758c7ce2ac0f857379e9e933f77	0a8a13bf87abe8696fbae4efe2b7f874
48438b67b2ac4e5dc9df6f3723fd4ccd	0a8a13bf87abe8696fbae4efe2b7f874
8b0cfde05d166f42a11a01814ef7fa86	0a8a13bf87abe8696fbae4efe2b7f874
031d6cc33621c51283322daf69e799f5	0a8a13bf87abe8696fbae4efe2b7f874
482818d4eb4ca4c709dcce4cc2ab413d	0a8a13bf87abe8696fbae4efe2b7f874
319480a02920dc261209240eed190360	0a8a13bf87abe8696fbae4efe2b7f874
a89af36e042b5aa91d6efea0cc283c02	0a8a13bf87abe8696fbae4efe2b7f874
13909e3013727a91ee750bfd8660d7bc	0a8a13bf87abe8696fbae4efe2b7f874
74e8b6c4be8a0f5dd843e2d1d7385a36	0a8a13bf87abe8696fbae4efe2b7f874
5c29c2e513aadfe372fd0af7553b5a6c	0a8a13bf87abe8696fbae4efe2b7f874
eef7d6da9ba6d0bed2078a5f253f4cfc	0a8a13bf87abe8696fbae4efe2b7f874
d192d350b6eace21e325ecf9b0f1ebd1	0a8a13bf87abe8696fbae4efe2b7f874
05256decaa2ee2337533d95c7de3db9d	0a8a13bf87abe8696fbae4efe2b7f874
b14521c0461b445a7ac2425e922c72df	0a8a13bf87abe8696fbae4efe2b7f874
33b39f2721f79a6bb6bb5e1b2834b0bd	d30be26d66f0448359f54d923aab2bb9
b145159df60e1549d1ba922fc8a92448	d30be26d66f0448359f54d923aab2bb9
ea3f5f97f06167f4819498b4dd56508e	d30be26d66f0448359f54d923aab2bb9
e2be3c3c22484d1872c7b225339c0962	d30be26d66f0448359f54d923aab2bb9
5629d465ed80efff6e25b8775b98c2d1	d30be26d66f0448359f54d923aab2bb9
f00bbb7747929fafa9d1afd071dba78e	d30be26d66f0448359f54d923aab2bb9
67cc86339b2654a35fcc57da8fc9d33d	d30be26d66f0448359f54d923aab2bb9
01a9f3fdd96daef6bc85160bd21d35dc	d30be26d66f0448359f54d923aab2bb9
6a4e8bab29666632262eb20c336e85e2	d30be26d66f0448359f54d923aab2bb9
4be3e31b7598745d0e96c098bbf7a1d7	d30be26d66f0448359f54d923aab2bb9
3aa1c6d08d286053722d17291dc3f116	d30be26d66f0448359f54d923aab2bb9
486bf23406dec9844b97f966f4636c9b	d30be26d66f0448359f54d923aab2bb9
4dde2c290e3ee11bd3bd1ecd27d7039a	d30be26d66f0448359f54d923aab2bb9
c833c98be699cd7828a5106a37d12c2e	d30be26d66f0448359f54d923aab2bb9
846a0115f0214c93a5a126f0f9697228	d30be26d66f0448359f54d923aab2bb9
07f467f03da5f904144b0ad3bc00a26d	d30be26d66f0448359f54d923aab2bb9
cd80c766840b7011fbf48355c0142431	d30be26d66f0448359f54d923aab2bb9
6f60a61fcc05cb4d42c81ade04392cfc	d30be26d66f0448359f54d923aab2bb9
7df470ec0292985d8f0e37aa6c2b38d5	d30be26d66f0448359f54d923aab2bb9
3a232003be172b49eb64e4d3e9af1434	d30be26d66f0448359f54d923aab2bb9
e2afc3f96b4a23d451c171c5fc852d0f	d30be26d66f0448359f54d923aab2bb9
863e7a3d6d4a74739bca7dd81db5d51f	d30be26d66f0448359f54d923aab2bb9
d1fded22db9fc8872e86fff12d511207	d30be26d66f0448359f54d923aab2bb9
c526681b295049215e5f1c2066639f4a	d30be26d66f0448359f54d923aab2bb9
8b0cfde05d166f42a11a01814ef7fa86	d30be26d66f0448359f54d923aab2bb9
65f889eb579641f6e5f58b5a48f3ec12	d30be26d66f0448359f54d923aab2bb9
031d6cc33621c51283322daf69e799f5	d30be26d66f0448359f54d923aab2bb9
ec788cc8478763d79a18160a99dbb618	d30be26d66f0448359f54d923aab2bb9
d5b95b21ce47502980eebfcf8d2913e0	d30be26d66f0448359f54d923aab2bb9
537e5aa87fcfb168be5c953d224015ff	d30be26d66f0448359f54d923aab2bb9
521c8a16cf07590faee5cf30bcfb98b6	d30be26d66f0448359f54d923aab2bb9
e2226498712065ccfca00ecb57b8ed2f	d30be26d66f0448359f54d923aab2bb9
810f28b77fa6c866fbcceb6c8aa7bac4	d30be26d66f0448359f54d923aab2bb9
08e2440159e71c7020394db19541aabc	d30be26d66f0448359f54d923aab2bb9
e6489b9cc39c95e53401cb601c4cae09	d30be26d66f0448359f54d923aab2bb9
4622209440a0ade57b18f21ae41963d9	d30be26d66f0448359f54d923aab2bb9
4338a835aa6e3198deba95c25dd9e3de	d30be26d66f0448359f54d923aab2bb9
048d40092f9bd3c450e4bdeeff69e8c3	d25334037d936d3257f794a10bb3030f
d2d67d63c28a15822569c5033f26b133	d25334037d936d3257f794a10bb3030f
22ef651048289b302401afe2044c5c01	d25334037d936d3257f794a10bb3030f
53199d92b173437f0207a916e8bcc23a	d25334037d936d3257f794a10bb3030f
bd4ca3a838ce3972af46b6e2d85985f2	d25334037d936d3257f794a10bb3030f
ef3c0bf190876fd31d5132848e99df61	d25334037d936d3257f794a10bb3030f
34fd3085dc67c39bf1692938cf3dbdd9	d25334037d936d3257f794a10bb3030f
cd0bc2c8738b2fef2d78d197223b17d5	d25334037d936d3257f794a10bb3030f
2c5705766131b389fa1d88088f1bb8a8	d25334037d936d3257f794a10bb3030f
db472eaf615920784c2b83fc90e8dcc5	d25334037d936d3257f794a10bb3030f
e6624ef1aeab84f521056a142b5b2d12	d25334037d936d3257f794a10bb3030f
7cb94a8039f617f505df305a1dc2cc61	d25334037d936d3257f794a10bb3030f
55696bac6cdd14d47cbe7940665e21d3	d25334037d936d3257f794a10bb3030f
2460cdf9598c810ac857d6ee9a84935a	d25334037d936d3257f794a10bb3030f
26c2bb18f3a9a0c6d1392dae296cfea7	d25334037d936d3257f794a10bb3030f
6af2c726b2d705f08d05a7ee9509916e	d25334037d936d3257f794a10bb3030f
93aa5f758ad31ae4b8ac40044ba6c110	d25334037d936d3257f794a10bb3030f
191bab5800bd381ecf16485f91e85bc3	d25334037d936d3257f794a10bb3030f
ba5e6ab17c7e5769b11f98bfe8b692d0	d25334037d936d3257f794a10bb3030f
fc239fd89fd7c9edbf2bf27d1d894bc0	d25334037d936d3257f794a10bb3030f
57126705faf40e4b5227c8a0302d13b2	d25334037d936d3257f794a10bb3030f
cba8cb3c568de75a884eaacde9434443	d25334037d936d3257f794a10bb3030f
955a5cfd6e05ed30eec7c79d2371ebcf	d25334037d936d3257f794a10bb3030f
d2f62cd276ef7cab5dcf9218d68f5bcf	d25334037d936d3257f794a10bb3030f
49a41ffa9c91f7353ec37cda90966866	d25334037d936d3257f794a10bb3030f
73cb08d143f893e645292dd04967f526	d25334037d936d3257f794a10bb3030f
5324a886a2667283dbfe7f7974ff6fc0	d25334037d936d3257f794a10bb3030f
28c5f9ffd175dcd53aa3e9da9b00dde7	d25334037d936d3257f794a10bb3030f
6b157916b43b09df5a22f658ccb92b64	d25334037d936d3257f794a10bb3030f
0c31e51349871cfb59cfbfaaed82eb18	d25334037d936d3257f794a10bb3030f
1de3f08835ab9d572e79ac0fca13c5c2	d25334037d936d3257f794a10bb3030f
7cbd455ff5af40e28a1eb97849f00723	d25334037d936d3257f794a10bb3030f
3d4fe2107d6302760654b4217cf32f17	d25334037d936d3257f794a10bb3030f
3c8ce0379b610d36c3723b198b982197	d25334037d936d3257f794a10bb3030f
2f6fc683428eb5f8b22cc5021dc9d40d	d25334037d936d3257f794a10bb3030f
77f94851e582202f940198a26728e71f	d25334037d936d3257f794a10bb3030f
586ac67e6180a1f16a4d3b81e33eaa94	d25334037d936d3257f794a10bb3030f
45816111a5b644493b68cfedfb1a0cc0	d25334037d936d3257f794a10bb3030f
861613f5a80abdf5a15ea283daa64be3	d25334037d936d3257f794a10bb3030f
0ecef959ca1f43d538966f7eb9a7e2ec	d25334037d936d3257f794a10bb3030f
d104b6ae44b0ac6649723bac21761d41	d25334037d936d3257f794a10bb3030f
7c7e63c9501a790a3134392e39c3012e	0c7fde545c06c2bc7383c0430c95fb78
c9dc004fc3d039ad7fb49456e5902b01	0c7fde545c06c2bc7383c0430c95fb78
b4c5b422ab8969880d9f0f0e9124f0d7	0c7fde545c06c2bc7383c0430c95fb78
05fcf330d8fafb0a1f17ce30ff60b924	0c7fde545c06c2bc7383c0430c95fb78
7bc374006774a2eda5288fea8f1872e3	0c7fde545c06c2bc7383c0430c95fb78
dcdcd2f22b1d5f85fa5dd68fa89e3756	0c7fde545c06c2bc7383c0430c95fb78
21077194453dcf49c2105fda6bb89c79	0c7fde545c06c2bc7383c0430c95fb78
90802bdf218986ffc70f8a086e1df172	0c7fde545c06c2bc7383c0430c95fb78
eb4558fa99c7f8d548cbcb32a14d469c	0c7fde545c06c2bc7383c0430c95fb78
381b834c6bf7b25b9b627c9eeb81dd8a	0c7fde545c06c2bc7383c0430c95fb78
849c829d658baaeff512d766b0db3cce	0c7fde545c06c2bc7383c0430c95fb78
827bf758c7ce2ac0f857379e9e933f77	0c7fde545c06c2bc7383c0430c95fb78
baceebebc179d3cdb726f5cbfaa81dfe	0c7fde545c06c2bc7383c0430c95fb78
f9ff0bcbb45bdf8a67395fa0ab3737b5	0c7fde545c06c2bc7383c0430c95fb78
876eed60be80010455ff50a62ccf1256	0c7fde545c06c2bc7383c0430c95fb78
fbc2b3cebe54dd00b53967c5cf4b9192	0c7fde545c06c2bc7383c0430c95fb78
97724184152a2620b76e2f93902ed679	0c7fde545c06c2bc7383c0430c95fb78
bcf744fa5f256d6c3051dd86943524f6	0c7fde545c06c2bc7383c0430c95fb78
cf38e7d92bb08c96c50ddc723b624f9d	0c7fde545c06c2bc7383c0430c95fb78
8fdc3e13751b8f525f259d27f2531e87	0c7fde545c06c2bc7383c0430c95fb78
18b751c8288c0fabe7b986963016884f	0c7fde545c06c2bc7383c0430c95fb78
30b8affc1afeb50c76ad57d7eda1f08f	0c7fde545c06c2bc7383c0430c95fb78
89d60b9528242c8c53ecbfde131eba21	0c7fde545c06c2bc7383c0430c95fb78
647a73dd79f06cdf74e1fa7524700161	2af415a2174b122c80e901297f2d114e
08f8c67c20c4ba43e8ba6fa771039c94	2af415a2174b122c80e901297f2d114e
4e9b4bdef9478154fc3ac7f5ebfb6418	2af415a2174b122c80e901297f2d114e
0ab01e57304a70cf4f7f037bd8afbe49	2af415a2174b122c80e901297f2d114e
1b62f034014b1d242c84c6fe7e6470f0	2af415a2174b122c80e901297f2d114e
fcf66a6d6cfbcb1d4a101213b8500445	2af415a2174b122c80e901297f2d114e
f1022ae1bc6b46d51889e0bb5ea8b64f	2af415a2174b122c80e901297f2d114e
240e556541427d81f4ed1eda86f33ad3	2af415a2174b122c80e901297f2d114e
d162c87d4d4b2a8f6dda58d4fba5987f	2af415a2174b122c80e901297f2d114e
09c00610ca567a64c82da81cc92cb846	2af415a2174b122c80e901297f2d114e
445a222489d55b5768ec2f17b1c3ea34	2af415a2174b122c80e901297f2d114e
5a534330e31944ed43cb6d35f4ad23c7	2af415a2174b122c80e901297f2d114e
a2761eea97ee9fe09464d5e70da6dd06	2af415a2174b122c80e901297f2d114e
1c13f340d154b44e41c996ec08d76749	2af415a2174b122c80e901297f2d114e
74e8b6c4be8a0f5dd843e2d1d7385a36	2af415a2174b122c80e901297f2d114e
b1c7516fef4a901df12871838f934cf6	2af415a2174b122c80e901297f2d114e
ab5428d229c61532af41ec2ca258bf30	2af415a2174b122c80e901297f2d114e
fc46b0aa6469133caf668f87435bfd9f	8bb92c3b9b1b949524aac3b578a052b6
33b39f2721f79a6bb6bb5e1b2834b0bd	8bb92c3b9b1b949524aac3b578a052b6
9436650a453053e775897ef5733e88fe	8bb92c3b9b1b949524aac3b578a052b6
a4bcd57d5cda816e4ffd1f83031a36ca	8bb92c3b9b1b949524aac3b578a052b6
bda66e37bf0bfbca66f8c78c5c8032b8	8bb92c3b9b1b949524aac3b578a052b6
cd004b87e2adfb72b28752a6ef6cd639	8bb92c3b9b1b949524aac3b578a052b6
eb39fa9323a6b3cbc8533cd3dadb9f76	8bb92c3b9b1b949524aac3b578a052b6
768207c883fd6447d67f3d5bc09211bd	8bb92c3b9b1b949524aac3b578a052b6
1fd7fc9c73539bee88e1ec137b5f9ad2	8bb92c3b9b1b949524aac3b578a052b6
e039d55ed63a723001867bc4eb842c00	8bb92c3b9b1b949524aac3b578a052b6
70492d5f3af58ace303d1c5dfc210088	8bb92c3b9b1b949524aac3b578a052b6
26211992c1edc0ab3a6b6506cac8bb52	8bb92c3b9b1b949524aac3b578a052b6
00a0d9697a08c1e5d4ba28d95da73292	8bb92c3b9b1b949524aac3b578a052b6
3e8d4b3893a9ebbbd86e648c90cbbe63	8bb92c3b9b1b949524aac3b578a052b6
10627ac0e35cfed4a0ca5b97a06b9d9f	8bb92c3b9b1b949524aac3b578a052b6
8fa1a366d4f2e520bc9354658c4709f1	8bb92c3b9b1b949524aac3b578a052b6
f7910d943cc815a4a0081668ac2119b2	8bb92c3b9b1b949524aac3b578a052b6
22c2fc8a3a81503d40d4e532ac0e22ab	8bb92c3b9b1b949524aac3b578a052b6
933c8182650ca4ae087544beff5bb52d	8bb92c3b9b1b949524aac3b578a052b6
e3de2cf8ac892a0d8616eefc4a4f59bd	8bb92c3b9b1b949524aac3b578a052b6
623c5a1c99aceaf0b07ae233d1888e0a	8bb92c3b9b1b949524aac3b578a052b6
b84cdd396f01275b63bdaf7f61ed5a43	8bb92c3b9b1b949524aac3b578a052b6
9d74605e4b1d19d83992a991230e89ef	8bb92c3b9b1b949524aac3b578a052b6
b6eba7850fd20fa8dce81167f1a6edca	8bb92c3b9b1b949524aac3b578a052b6
bd555d95b1ccba75afca868636b1b931	8bb92c3b9b1b949524aac3b578a052b6
ca1720fd6350760c43139622c4753557	8bb92c3b9b1b949524aac3b578a052b6
06c1680c65972c4332be73e726de9e74	8bb92c3b9b1b949524aac3b578a052b6
77ac561c759a27b7d660d7cf0534a9c3	8bb92c3b9b1b949524aac3b578a052b6
e6489b9cc39c95e53401cb601c4cae09	8bb92c3b9b1b949524aac3b578a052b6
c18bdeb4f181c22f04555ea453111da1	8bb92c3b9b1b949524aac3b578a052b6
4338a835aa6e3198deba95c25dd9e3de	8bb92c3b9b1b949524aac3b578a052b6
9592b3ad4d7f96bc644c7d6f34c06576	8bb92c3b9b1b949524aac3b578a052b6
db1440c4bae3edf98e3dab7caf2e7fed	8bb92c3b9b1b949524aac3b578a052b6
bff322dbe273a1e2d1fe37f81acccbe4	8bb92c3b9b1b949524aac3b578a052b6
36b208182f04f44c80937e980c3c28fd	8bb92c3b9b1b949524aac3b578a052b6
b7f0e9013f8bfb209f4f6b2258b6c9c8	a88070859e86a8fb44267f7c6d91d381
d02f33b44582e346050cefadce93eb95	a88070859e86a8fb44267f7c6d91d381
491801c872c67db465fda0f8f180569d	a88070859e86a8fb44267f7c6d91d381
25f5d73866a52be9d0e2e059955dfd56	a88070859e86a8fb44267f7c6d91d381
dfa61d19b62369a37743b38215836df9	a88070859e86a8fb44267f7c6d91d381
30a100fe6a043e64ed36abb039bc9130	a88070859e86a8fb44267f7c6d91d381
e4f13074d445d798488cb00fa0c5fbd4	a88070859e86a8fb44267f7c6d91d381
563fcbf5f44e03e0eeb9c8d6e4c8e127	a88070859e86a8fb44267f7c6d91d381
a91887f44d8d9fdcaa401d1c719630d7	a88070859e86a8fb44267f7c6d91d381
6ffa656be5ff3db085578f54a05d4ddb	a88070859e86a8fb44267f7c6d91d381
ef75c0b43ae9ba972900e83c5ccf5cac	a88070859e86a8fb44267f7c6d91d381
79cbf009784a729575e50a3ef4a3b1cc	a88070859e86a8fb44267f7c6d91d381
2fb81ca1d0a935be4cb49028268baa3f	a88070859e86a8fb44267f7c6d91d381
b7b99e418cff42d14dbf2d63ecee12a8	a88070859e86a8fb44267f7c6d91d381
e4f74be13850fc65559a3ed855bf35a8	a88070859e86a8fb44267f7c6d91d381
c0118be307a26886822e1194e8ae246d	a88070859e86a8fb44267f7c6d91d381
316a289ef71c950545271754abf583f1	a88070859e86a8fb44267f7c6d91d381
1506aeeb8c3a699b1e3c87db03156428	a88070859e86a8fb44267f7c6d91d381
1a5235c012c18789e81960333a76cd7a	a88070859e86a8fb44267f7c6d91d381
5bb416e14ac19276a4b450d343e4e981	a88070859e86a8fb44267f7c6d91d381
c846d80d826291f2a6a0d7a57e540307	a88070859e86a8fb44267f7c6d91d381
78f5c568100eb61401870fa0fa4fd7cb	a88070859e86a8fb44267f7c6d91d381
78b532c25e4a99287940b1706359d455	a88070859e86a8fb44267f7c6d91d381
fc935f341286c735b575bd50196c904b	a88070859e86a8fb44267f7c6d91d381
f159fc50b5af54fecf21d5ea6ec37bad	a88070859e86a8fb44267f7c6d91d381
265dbcbd2bce07dfa721ed3daaa30912	a88070859e86a8fb44267f7c6d91d381
11a7f956c37bf0459e9c80b16cc72107	a88070859e86a8fb44267f7c6d91d381
786d3481362b8dee6370dfb9b6df38a2	be2f0af59429129793d751e4316ec81c
298a577c621a7a1c365465f694e0bd13	be2f0af59429129793d751e4316ec81c
ab1d9c0bfcc2843b8ea371f48ed884bb	be2f0af59429129793d751e4316ec81c
5fa07e5db79f9a1dccb28d65d6337aa6	be2f0af59429129793d751e4316ec81c
02fd1596536ea89e779d37ded52ac353	be2f0af59429129793d751e4316ec81c
dddfdb5f2d7991d93f0f97dce1ef0f45	be2f0af59429129793d751e4316ec81c
5ab944fac5f6a0d98dc248a879ec70ff	be2f0af59429129793d751e4316ec81c
6ffa656be5ff3db085578f54a05d4ddb	be2f0af59429129793d751e4316ec81c
8ee257802fc6a4d44679ddee10bf24a9	be2f0af59429129793d751e4316ec81c
dd0e61ab23e212d958112dd06ad0bfd2	be2f0af59429129793d751e4316ec81c
02670bc3f496ce7b1393712f58033f6c	be2f0af59429129793d751e4316ec81c
dbf1b3eb1f030affb41473a8fa69bc0c	be2f0af59429129793d751e4316ec81c
9459200394693a7140196f07e6e717fd	be2f0af59429129793d751e4316ec81c
e9e0664816c35d64f26fc1382708617b	be2f0af59429129793d751e4316ec81c
316a289ef71c950545271754abf583f1	be2f0af59429129793d751e4316ec81c
3189b8c5e007c634d7e28ef93be2b774	be2f0af59429129793d751e4316ec81c
f8b01df5282702329fcd1cae8877bb5f	be2f0af59429129793d751e4316ec81c
b86f86db61493cc2d757a5cefc5ef425	be2f0af59429129793d751e4316ec81c
fc935f341286c735b575bd50196c904b	be2f0af59429129793d751e4316ec81c
265dbcbd2bce07dfa721ed3daaa30912	be2f0af59429129793d751e4316ec81c
8845da022807c76120b5b6f50c218d9a	be2f0af59429129793d751e4316ec81c
ef297890615f388057b6a2c0a2cbc7ab	f3dcdca4cd0c83a5e855c5434ce98673
be2c012d60e32fbf456cd8184a51973d	f3dcdca4cd0c83a5e855c5434ce98673
f00bbb7747929fafa9d1afd071dba78e	f3dcdca4cd0c83a5e855c5434ce98673
67cc86339b2654a35fcc57da8fc9d33d	f3dcdca4cd0c83a5e855c5434ce98673
71f4e9782d5f2a5381f5cdf7c5a35d89	f3dcdca4cd0c83a5e855c5434ce98673
6caa47f7b3472053b152f84ce72c182c	f3dcdca4cd0c83a5e855c5434ce98673
d68956b2b5557e8f1be27a4632045c1e	f3dcdca4cd0c83a5e855c5434ce98673
4c576d921b99dad80e4bcf9b068c2377	f3dcdca4cd0c83a5e855c5434ce98673
c63b6261b8bb8145bc0fd094b9732c24	f3dcdca4cd0c83a5e855c5434ce98673
156c19a6d9137e04b94500642d1cb8c2	f3dcdca4cd0c83a5e855c5434ce98673
511ac85b55c0c400422462064d6c77ed	f3dcdca4cd0c83a5e855c5434ce98673
255661921f4ad57d02b1de9062eb6421	f3dcdca4cd0c83a5e855c5434ce98673
c8bc4f15477ea3131abb1a3f0649fac2	f3dcdca4cd0c83a5e855c5434ce98673
b145159df60e1549d1ba922fc8a92448	fe81a4f28e6bd176efc8184d58544e66
2eb42b9c31ac030455e5a4a79bccf603	fe81a4f28e6bd176efc8184d58544e66
6a4e8bab29666632262eb20c336e85e2	fe81a4f28e6bd176efc8184d58544e66
53199d92b173437f0207a916e8bcc23a	fe81a4f28e6bd176efc8184d58544e66
d908b6b9019639bced6d1e31463eea85	fe81a4f28e6bd176efc8184d58544e66
6772cdb774a6ce03a928d187def5453f	fe81a4f28e6bd176efc8184d58544e66
1cc93e4af82b1b7e08bace9a92d1f762	fe81a4f28e6bd176efc8184d58544e66
b36eb6a54154f7301f004e1e61c87ce8	fe81a4f28e6bd176efc8184d58544e66
f975b4517b002a52839c42e86b34dc96	fe81a4f28e6bd176efc8184d58544e66
06c5c89047bfd6012e6fb3c2bd3cb24b	fe81a4f28e6bd176efc8184d58544e66
7a43dd4c2bb9bea14a95ff3acd4dfb18	fe81a4f28e6bd176efc8184d58544e66
c295bb30bf534e960a6acf7435f0e46a	fe81a4f28e6bd176efc8184d58544e66
30b8affc1afeb50c76ad57d7eda1f08f	fe81a4f28e6bd176efc8184d58544e66
06c1680c65972c4332be73e726de9e74	fe81a4f28e6bd176efc8184d58544e66
d104b6ae44b0ac6649723bac21761d41	fe81a4f28e6bd176efc8184d58544e66
71b6971b6323b97f298af11ed5455e55	5446a9fcc158ea011aeb9892ba2dfb15
7c7e63c9501a790a3134392e39c3012e	5446a9fcc158ea011aeb9892ba2dfb15
c2ab38206dce633f15d66048ad744f03	5446a9fcc158ea011aeb9892ba2dfb15
1437c187d64f0ac45b6b077a989d5648	5446a9fcc158ea011aeb9892ba2dfb15
dcab0d84960cda81718e38ee47688a75	5446a9fcc158ea011aeb9892ba2dfb15
bf2c8729bf5c149067d8e978ea3dcd32	5446a9fcc158ea011aeb9892ba2dfb15
2e4e6a5f485b2c7e22f9974633c2b900	5446a9fcc158ea011aeb9892ba2dfb15
6af2c726b2d705f08d05a7ee9509916e	5446a9fcc158ea011aeb9892ba2dfb15
baceebebc179d3cdb726f5cbfaa81dfe	5446a9fcc158ea011aeb9892ba2dfb15
f9ff0bcbb45bdf8a67395fa0ab3737b5	5446a9fcc158ea011aeb9892ba2dfb15
34e927c45cf3ccebb09b006b00f4e02d	5446a9fcc158ea011aeb9892ba2dfb15
8fdc3e13751b8f525f259d27f2531e87	5446a9fcc158ea011aeb9892ba2dfb15
2f6fc683428eb5f8b22cc5021dc9d40d	5446a9fcc158ea011aeb9892ba2dfb15
ef297890615f388057b6a2c0a2cbc7ab	c7fb67368c25c29b9c10ca91b2d97488
bca8f048f2c5ff787950eb1ba088c70e	c7fb67368c25c29b9c10ca91b2d97488
2569a68a03a04a2cd73197d2cc546ff2	c7fb67368c25c29b9c10ca91b2d97488
d68956b2b5557e8f1be27a4632045c1e	c7fb67368c25c29b9c10ca91b2d97488
0182742917720e1b2cf59ff671738253	c7fb67368c25c29b9c10ca91b2d97488
46ea4c445a9ff8e288258e3ec9cd1cf0	c7fb67368c25c29b9c10ca91b2d97488
d76db99cdd16bd0e53d5e07bcf6225c8	c7fb67368c25c29b9c10ca91b2d97488
c63b6261b8bb8145bc0fd094b9732c24	c7fb67368c25c29b9c10ca91b2d97488
bbbb086d59122dbb940740d6bac65976	c7fb67368c25c29b9c10ca91b2d97488
f975b4517b002a52839c42e86b34dc96	c7fb67368c25c29b9c10ca91b2d97488
156c19a6d9137e04b94500642d1cb8c2	c7fb67368c25c29b9c10ca91b2d97488
05256decaa2ee2337533d95c7de3db9d	c7fb67368c25c29b9c10ca91b2d97488
fc46b0aa6469133caf668f87435bfd9f	0c5544f60e058b8cbf571044aaa6115f
16a56d0941a310c3dc4f967041574300	0c5544f60e058b8cbf571044aaa6115f
a4bcd57d5cda816e4ffd1f83031a36ca	0c5544f60e058b8cbf571044aaa6115f
ec5c65bfe530446b696f04e51aa19201	0c5544f60e058b8cbf571044aaa6115f
3577f7160794aa4ba4d79d0381aefdb1	0c5544f60e058b8cbf571044aaa6115f
05ee6afed8d828d4e7ed35b0483527f7	0c5544f60e058b8cbf571044aaa6115f
458da4fc3da734a6853e26af3944bf75	0c5544f60e058b8cbf571044aaa6115f
a05a13286752cb6fc14f39f51cedd9ce	0c5544f60e058b8cbf571044aaa6115f
118c9af69a42383387e8ce6ab22867d7	0c5544f60e058b8cbf571044aaa6115f
7b675f4c76aed34cf2d5943d83198142	0c5544f60e058b8cbf571044aaa6115f
6d779916de27702814e4874dcf4f9e3a	0c5544f60e058b8cbf571044aaa6115f
123f90461d74091a96637955d14a1401	0c5544f60e058b8cbf571044aaa6115f
b834eadeaf680f6ffcb13068245a1fed	0c5544f60e058b8cbf571044aaa6115f
c8fbeead5c59de4e8f07ab39e7874213	0c5544f60e058b8cbf571044aaa6115f
58e42b779d54e174aad9a9fb79e7ebbc	0c5544f60e058b8cbf571044aaa6115f
bc111d75a59fe7191a159fd4ee927981	0c5544f60e058b8cbf571044aaa6115f
df99cee44099ff57acbf7932670614dd	0c5544f60e058b8cbf571044aaa6115f
d6a020f7b50fb4512fd3c843af752809	0c5544f60e058b8cbf571044aaa6115f
f36fba9e93f6402ba551291e34242338	0c5544f60e058b8cbf571044aaa6115f
f999abbe163f001f55134273441f35c0	0c5544f60e058b8cbf571044aaa6115f
db1440c4bae3edf98e3dab7caf2e7fed	0c5544f60e058b8cbf571044aaa6115f
f041991eb3263fd3e5d919026e772f57	0c5544f60e058b8cbf571044aaa6115f
4e9b4bdef9478154fc3ac7f5ebfb6418	917d78ef1f9ba5451bcd9735606e9215
846a0115f0214c93a5a126f0f9697228	917d78ef1f9ba5451bcd9735606e9215
d162c87d4d4b2a8f6dda58d4fba5987f	917d78ef1f9ba5451bcd9735606e9215
460bf623f241651a7527a63d32569dc0	917d78ef1f9ba5451bcd9735606e9215
f34c903e17cfeea18e499d4627eeb3ec	917d78ef1f9ba5451bcd9735606e9215
3123e3df482127074cdd5f830072c898	917d78ef1f9ba5451bcd9735606e9215
511ac85b55c0c400422462064d6c77ed	917d78ef1f9ba5451bcd9735606e9215
347fb42f546e982de2a1027a2544bfd0	917d78ef1f9ba5451bcd9735606e9215
65f889eb579641f6e5f58b5a48f3ec12	917d78ef1f9ba5451bcd9735606e9215
2dde74b7ec594b9bd78da66f1c5cafdc	917d78ef1f9ba5451bcd9735606e9215
05256decaa2ee2337533d95c7de3db9d	917d78ef1f9ba5451bcd9735606e9215
fd1a5654154eed3c0a0820ab54fb90a7	917d78ef1f9ba5451bcd9735606e9215
53199d92b173437f0207a916e8bcc23a	8f8351209253e5c5d8ff147b02d3b117
cb80a6a84ec46f085ea6b2ff30a88d80	8f8351209253e5c5d8ff147b02d3b117
07f467f03da5f904144b0ad3bc00a26d	8f8351209253e5c5d8ff147b02d3b117
d162c87d4d4b2a8f6dda58d4fba5987f	8f8351209253e5c5d8ff147b02d3b117
576fea4a0c5425ba382fff5f593a33f1	8f8351209253e5c5d8ff147b02d3b117
f34c903e17cfeea18e499d4627eeb3ec	8f8351209253e5c5d8ff147b02d3b117
3123e3df482127074cdd5f830072c898	8f8351209253e5c5d8ff147b02d3b117
8b0cfde05d166f42a11a01814ef7fa86	8f8351209253e5c5d8ff147b02d3b117
65f889eb579641f6e5f58b5a48f3ec12	8f8351209253e5c5d8ff147b02d3b117
a89af36e042b5aa91d6efea0cc283c02	8f8351209253e5c5d8ff147b02d3b117
2dde74b7ec594b9bd78da66f1c5cafdc	8f8351209253e5c5d8ff147b02d3b117
71144850f4fb4cc55fc0ee6935badddf	9a1f30943126974075dbd4d13c8018ac
eed35187b83d0f2e0042cf221905163c	9a1f30943126974075dbd4d13c8018ac
1437c187d64f0ac45b6b077a989d5648	9a1f30943126974075dbd4d13c8018ac
8981b4a0834d2d59e1d0dceb6022caae	9a1f30943126974075dbd4d13c8018ac
240e556541427d81f4ed1eda86f33ad3	9a1f30943126974075dbd4d13c8018ac
21077194453dcf49c2105fda6bb89c79	9a1f30943126974075dbd4d13c8018ac
75241d56d63a68adcd51d828eb76ca80	9a1f30943126974075dbd4d13c8018ac
0b6bcec891d17cd7858525799c65da27	9a1f30943126974075dbd4d13c8018ac
fdedcd75d695d1c0eb790a5ee3ba90b5	9a1f30943126974075dbd4d13c8018ac
13909e3013727a91ee750bfd8660d7bc	9a1f30943126974075dbd4d13c8018ac
4669569c9a870431c4896de37675a784	9a1f30943126974075dbd4d13c8018ac
cc31970696ef00b4c6e28dba4252e45d	9a1f30943126974075dbd4d13c8018ac
dda8e0792843816587427399f34bd726	9a1f30943126974075dbd4d13c8018ac
f1a37824dfc280b208e714bd80d5a294	9a1f30943126974075dbd4d13c8018ac
786a755c895da064ccd4f9e8eb7e484e	9a1f30943126974075dbd4d13c8018ac
15ba70625527d7bb48962e6ba1a465f7	9a1f30943126974075dbd4d13c8018ac
0da2e7fa0ba90f4ae031b0d232b8a57a	86094b61cb9f63b77f982ceae03e95f0
b1d18f9e5399464bbe5dea0cca8fe064	86094b61cb9f63b77f982ceae03e95f0
0cd2b45507cc7c4ead2aaa71c59af730	86094b61cb9f63b77f982ceae03e95f0
40a259aebdbb405d2dc1d25b05f04989	86094b61cb9f63b77f982ceae03e95f0
e29470b6da77fb63e9b381fa58022c84	86094b61cb9f63b77f982ceae03e95f0
d1ba47339d5eb2254dd3f2cc9f7e444f	86094b61cb9f63b77f982ceae03e95f0
0b6bcec891d17cd7858525799c65da27	86094b61cb9f63b77f982ceae03e95f0
34ca5622469ad1951a3c4dc5603cea0f	86094b61cb9f63b77f982ceae03e95f0
45d592ef3a8dc14dccc087e734582e82	d9df3b71eebfa8e6aaf5c72ee758a14d
486bf23406dec9844b97f966f4636c9b	d9df3b71eebfa8e6aaf5c72ee758a14d
cb80a6a84ec46f085ea6b2ff30a88d80	d9df3b71eebfa8e6aaf5c72ee758a14d
6a13b854e05f5ba6d2a0d873546fc32d	d9df3b71eebfa8e6aaf5c72ee758a14d
d162c87d4d4b2a8f6dda58d4fba5987f	d9df3b71eebfa8e6aaf5c72ee758a14d
97724184152a2620b76e2f93902ed679	d9df3b71eebfa8e6aaf5c72ee758a14d
08e2440159e71c7020394db19541aabc	d9df3b71eebfa8e6aaf5c72ee758a14d
dab701a389943f0d407c6e583abef934	594dec72ea580a8565277a387893e992
a6c27c0fb9ef87788c1345041e840f95	594dec72ea580a8565277a387893e992
8cd1cca18fb995d268006113a3d6e4bf	594dec72ea580a8565277a387893e992
5c59b6aa317b306a1312a67fe69bf512	594dec72ea580a8565277a387893e992
869bb972f8bef83979774fa123c56a4e	594dec72ea580a8565277a387893e992
5bd15db3f3bb125cf3222745f4fe383f	594dec72ea580a8565277a387893e992
3cb077e20dabc945228ea58813672973	594dec72ea580a8565277a387893e992
22aaaebe901de8370917dcc53f53dbf6	f54c3ccedc098d37a4e7f7a455f5731e
56b07537df0c44402f5f87a8dcb8402c	f54c3ccedc098d37a4e7f7a455f5731e
34ef35a77324b889aab18380ad34b51a	f54c3ccedc098d37a4e7f7a455f5731e
f3b8f1a2417bdc483f4e2306ac6004b2	f54c3ccedc098d37a4e7f7a455f5731e
8ee257802fc6a4d44679ddee10bf24a9	f54c3ccedc098d37a4e7f7a455f5731e
eb3a9fb71b84790e50acd81cc1aa4862	f54c3ccedc098d37a4e7f7a455f5731e
7b91dc9ecdfa3ea7d347588a63537bb9	f54c3ccedc098d37a4e7f7a455f5731e
43bd0d50fe7d58d8fce10c6d4232ca1e	f54c3ccedc098d37a4e7f7a455f5731e
5f449b146ce14c780eee323dfc5391e8	f54c3ccedc098d37a4e7f7a455f5731e
d69462bef6601bb8d6e3ffda067399d9	f54c3ccedc098d37a4e7f7a455f5731e
dbc940d02a217c923c52d3989be9b391	f54c3ccedc098d37a4e7f7a455f5731e
a985c9764e0e6d738ff20f2328a0644b	5c63347e836e5543344d9e366e3efff8
ea3f5f97f06167f4819498b4dd56508e	5c63347e836e5543344d9e366e3efff8
f00bbb7747929fafa9d1afd071dba78e	5c63347e836e5543344d9e366e3efff8
98e8599d1486fadca0bf7aa171400dd8	5c63347e836e5543344d9e366e3efff8
846a0115f0214c93a5a126f0f9697228	5c63347e836e5543344d9e366e3efff8
f79485ffe5db7e276e1e625b0be0dbec	5c63347e836e5543344d9e366e3efff8
e2226498712065ccfca00ecb57b8ed2f	5c63347e836e5543344d9e366e3efff8
90669320cd8e4a09bf655310bffdb9ba	73d0749820562452b33d4e0f4891efcd
08b84204877dce2a08abce50d9aeceed	73d0749820562452b33d4e0f4891efcd
6a13b854e05f5ba6d2a0d873546fc32d	73d0749820562452b33d4e0f4891efcd
21077194453dcf49c2105fda6bb89c79	73d0749820562452b33d4e0f4891efcd
b454fdfc910ad8f6b7509072cf0b4031	73d0749820562452b33d4e0f4891efcd
827bf758c7ce2ac0f857379e9e933f77	73d0749820562452b33d4e0f4891efcd
97724184152a2620b76e2f93902ed679	73d0749820562452b33d4e0f4891efcd
b084dc5276d0211fae267a279e2959f0	73d0749820562452b33d4e0f4891efcd
a66394e41d764b4c5646446a8ba2028b	73d0749820562452b33d4e0f4891efcd
fdedcd75d695d1c0eb790a5ee3ba90b5	73d0749820562452b33d4e0f4891efcd
ed9b92eb1706415c42f88dc91284da8a	73d0749820562452b33d4e0f4891efcd
fb1afbea5c0c2e23396ef429d0e42c52	73d0749820562452b33d4e0f4891efcd
18b751c8288c0fabe7b986963016884f	73d0749820562452b33d4e0f4891efcd
78a7bdfe7277f187e84b52dea7b75b0b	73d0749820562452b33d4e0f4891efcd
398af626887ad21cd66aeb272b8337be	bd1340d19723308d52dcf7c3a6b1ea87
0959583c7f421c0bb8adb20e8faeeea1	bd1340d19723308d52dcf7c3a6b1ea87
77bfe8d21f1ecc592062f91c9253d8ab	bd1340d19723308d52dcf7c3a6b1ea87
4dde2c290e3ee11bd3bd1ecd27d7039a	bd1340d19723308d52dcf7c3a6b1ea87
e6cbb2e0653a61e35d26df2bcb6bc4c7	bd1340d19723308d52dcf7c3a6b1ea87
56bf60ca682b8f68e8843ad8a55c6b17	bd1340d19723308d52dcf7c3a6b1ea87
a753c3945400cd54c7ffd35fc07fe031	bd1340d19723308d52dcf7c3a6b1ea87
08e2440159e71c7020394db19541aabc	bd1340d19723308d52dcf7c3a6b1ea87
773b5037f85efc8cc0ff3fe0bddf2eb8	ae85ec0052dafef13ff2f2cbcb540b53
66597873e0974fb365454a5087291094	ae85ec0052dafef13ff2f2cbcb540b53
60a105e79a86c8197cec9f973576874b	ae85ec0052dafef13ff2f2cbcb540b53
99761fad57f035550a1ca48e47f35157	ae85ec0052dafef13ff2f2cbcb540b53
f31ba1d770aac9bc0dcee3fc15c60a46	ae85ec0052dafef13ff2f2cbcb540b53
43a4893e6200f462bb9fe406e68e71c0	ae85ec0052dafef13ff2f2cbcb540b53
812f48abd93f276576541ec5b79d48a2	ae85ec0052dafef13ff2f2cbcb540b53
bcc770bb6652b1b08643d98fd7167f5c	ae85ec0052dafef13ff2f2cbcb540b53
73cb08d143f893e645292dd04967f526	ae85ec0052dafef13ff2f2cbcb540b53
c245b4779defd5c69ffebbfdd239dd1b	ae85ec0052dafef13ff2f2cbcb540b53
1fe0175f73e5b381213057da98b8f5fb	ae85ec0052dafef13ff2f2cbcb540b53
559314721edf178fa138534f7a1611b9	ae85ec0052dafef13ff2f2cbcb540b53
a93376e58f4c73737cf5ed7d88c2169c	ae85ec0052dafef13ff2f2cbcb540b53
6b37fe4703bd962004cdccda304cc18e	ae85ec0052dafef13ff2f2cbcb540b53
31da4ab7750e057e56224eff51bce705	ae85ec0052dafef13ff2f2cbcb540b53
0371892b7f65ffb9c1544ee35c6330ad	ae85ec0052dafef13ff2f2cbcb540b53
70409bc559ef6c8aabcf16941a29788b	ae85ec0052dafef13ff2f2cbcb540b53
7c7e63c9501a790a3134392e39c3012e	8a743590316d1519ab5ecc8d142415a2
f655d84d670525246ee7d57995f71c10	8a743590316d1519ab5ecc8d142415a2
7bc374006774a2eda5288fea8f1872e3	8a743590316d1519ab5ecc8d142415a2
75241d56d63a68adcd51d828eb76ca80	8a743590316d1519ab5ecc8d142415a2
baceebebc179d3cdb726f5cbfaa81dfe	8a743590316d1519ab5ecc8d142415a2
3438d9050b2bf1e6dc0179818298bd41	8a743590316d1519ab5ecc8d142415a2
ef297890615f388057b6a2c0a2cbc7ab	a2e63ee01401aaeca78be023dfbb8c59
cbefc03cdd1940f37a7033620f8ff69f	a2e63ee01401aaeca78be023dfbb8c59
3b8d2a5ff1b16509377ce52a92255ffe	a2e63ee01401aaeca78be023dfbb8c59
f975b4517b002a52839c42e86b34dc96	a2e63ee01401aaeca78be023dfbb8c59
511ac85b55c0c400422462064d6c77ed	a2e63ee01401aaeca78be023dfbb8c59
6caa47f7b3472053b152f84ce72c182c	c875de527ea22b45018e7468fb0ef4a5
3b8d2a5ff1b16509377ce52a92255ffe	c875de527ea22b45018e7468fb0ef4a5
87bd9baf0b0d760d1f0ca9a8e9526161	c875de527ea22b45018e7468fb0ef4a5
511ac85b55c0c400422462064d6c77ed	c875de527ea22b45018e7468fb0ef4a5
b00114f9fc38b48cc42a4972d7e07df6	c875de527ea22b45018e7468fb0ef4a5
6db22194a183d7da810dcc29ea360c17	c875de527ea22b45018e7468fb0ef4a5
3a7e46261a591b3e65d1e7d0b2439b20	abcd9ee1861e1b9a2a5d4d187cf3708e
14af57131cbbf57afb206c8707fdab6c	abcd9ee1861e1b9a2a5d4d187cf3708e
3e98ecfa6a4c765c5522f897a4a8de23	abcd9ee1861e1b9a2a5d4d187cf3708e
6a13b854e05f5ba6d2a0d873546fc32d	abcd9ee1861e1b9a2a5d4d187cf3708e
93025091752efa184fd034f285573afe	abcd9ee1861e1b9a2a5d4d187cf3708e
d5b95b21ce47502980eebfcf8d2913e0	abcd9ee1861e1b9a2a5d4d187cf3708e
113ab4d243afc4114902d317ad41bb39	abcd9ee1861e1b9a2a5d4d187cf3708e
647a73dd79f06cdf74e1fa7524700161	f72e9105795af04cd4da64414d9968ad
b145159df60e1549d1ba922fc8a92448	f72e9105795af04cd4da64414d9968ad
6a4e8bab29666632262eb20c336e85e2	f72e9105795af04cd4da64414d9968ad
53199d92b173437f0207a916e8bcc23a	f72e9105795af04cd4da64414d9968ad
e4f13074d445d798488cb00fa0c5fbd4	f72e9105795af04cd4da64414d9968ad
97724184152a2620b76e2f93902ed679	f72e9105795af04cd4da64414d9968ad
41e744bdf3114b14f5873dfb46921dc4	f72e9105795af04cd4da64414d9968ad
7f3e5839689216583047809a7f6bd0ff	7382b86831977a414e676d2b29c73788
abe78132c8e446430297d08bd1ecdab0	7382b86831977a414e676d2b29c73788
08b84204877dce2a08abce50d9aeceed	7382b86831977a414e676d2b29c73788
010fb41a1a7714387391d5ea1ecdfaf7	7382b86831977a414e676d2b29c73788
18b751c8288c0fabe7b986963016884f	7382b86831977a414e676d2b29c73788
92ad5e8d66bac570a0611f2f1b3e43cc	5739305712ce3c5e565bc2da4cd389f4
3e28a735f3fc31a9c8c30b47872634bf	5739305712ce3c5e565bc2da4cd389f4
56b07537df0c44402f5f87a8dcb8402c	5739305712ce3c5e565bc2da4cd389f4
f3b8f1a2417bdc483f4e2306ac6004b2	5739305712ce3c5e565bc2da4cd389f4
6fa204dccaff0ec60f96db5fb5e69b33	5739305712ce3c5e565bc2da4cd389f4
1b62f034014b1d242c84c6fe7e6470f0	19e9429d9a22a95b78047320098cbf5b
dcdcd2f22b1d5f85fa5dd68fa89e3756	19e9429d9a22a95b78047320098cbf5b
09c00610ca567a64c82da81cc92cb846	19e9429d9a22a95b78047320098cbf5b
9d514e6b301cfe7bdc270212d5565eaf	19e9429d9a22a95b78047320098cbf5b
0959583c7f421c0bb8adb20e8faeeea1	4396490d79c407ec3313bc29ede9f7c8
262a49b104426ba0d1559f8785931b9d	4396490d79c407ec3313bc29ede9f7c8
dddfdb5f2d7991d93f0f97dce1ef0f45	4396490d79c407ec3313bc29ede9f7c8
f49f851c639e639b295b45f0e00c4b4c	4396490d79c407ec3313bc29ede9f7c8
61725742f52de502605eadeac19b837b	4396490d79c407ec3313bc29ede9f7c8
370cde851ed429f1269f243dd714cce2	4607ea6bfb05f395d12f6959cf48aaca
fcf66a6d6cfbcb1d4a101213b8500445	4607ea6bfb05f395d12f6959cf48aaca
dcdcd2f22b1d5f85fa5dd68fa89e3756	4607ea6bfb05f395d12f6959cf48aaca
09c00610ca567a64c82da81cc92cb846	4607ea6bfb05f395d12f6959cf48aaca
a822d5d4cdcb5d1b340a54798ac410b7	4607ea6bfb05f395d12f6959cf48aaca
a571d94b6ed1fa1e0cfff9c04bbeb94d	4607ea6bfb05f395d12f6959cf48aaca
370cde851ed429f1269f243dd714cce2	88ff69ec6aa54fb228d85b92f3b12945
be2c012d60e32fbf456cd8184a51973d	88ff69ec6aa54fb228d85b92f3b12945
fcf66a6d6cfbcb1d4a101213b8500445	88ff69ec6aa54fb228d85b92f3b12945
09c00610ca567a64c82da81cc92cb846	88ff69ec6aa54fb228d85b92f3b12945
458da4fc3da734a6853e26af3944bf75	93cf908c24c1663d03d67facc359acc2
dfca36a68db327258a2b0d5e3abe86af	93cf908c24c1663d03d67facc359acc2
3cd94848f6ccb600295135e86f1b46a7	93cf908c24c1663d03d67facc359acc2
1fbd4bcce346fd2b2ffb41f6e767ea84	5148c20f58db929fe77e3cb0611dc1c4
11a5f9f425fd6da2d010808e5bf759ab	5148c20f58db929fe77e3cb0611dc1c4
9d1ecaf46d6433f9dd224111440cfa3b	5148c20f58db929fe77e3cb0611dc1c4
fb1afbea5c0c2e23396ef429d0e42c52	5148c20f58db929fe77e3cb0611dc1c4
78a7bdfe7277f187e84b52dea7b75b0b	5148c20f58db929fe77e3cb0611dc1c4
81200f74b5d831e3e206a66fe4158370	3e29d9d93ad04d5bc71d4cdc5a8ad820
f3ac75dfbf1ce980d70dc3dea1bf4636	3e29d9d93ad04d5bc71d4cdc5a8ad820
384e94f762d3a408cd913c14b19ac5e0	3e29d9d93ad04d5bc71d4cdc5a8ad820
5878f5f2b1ca134da32312175d640134	3e29d9d93ad04d5bc71d4cdc5a8ad820
a0abb504e661e34f5d269f113d39ea96	3e29d9d93ad04d5bc71d4cdc5a8ad820
f8b3eaefc682f8476cc28caf71cb2c73	3e29d9d93ad04d5bc71d4cdc5a8ad820
398af626887ad21cd66aeb272b8337be	a94bc9e378c8007c95406059d09bb4f3
824f75181a2bbd69fb2698377ea8a952	a94bc9e378c8007c95406059d09bb4f3
5e6ff2b64b4c0163ab83ab371abe910b	a94bc9e378c8007c95406059d09bb4f3
ca3fecb0d12232d1dd99d0b0d83c39ec	a94bc9e378c8007c95406059d09bb4f3
98aa80527e97026656ec54cdd0f94dff	a94bc9e378c8007c95406059d09bb4f3
f6708813faedbf607111d83fdce91828	eacaec4715e2e6194f0b148b2c4edd02
4c576d921b99dad80e4bcf9b068c2377	eacaec4715e2e6194f0b148b2c4edd02
3a232003be172b49eb64e4d3e9af1434	eacaec4715e2e6194f0b148b2c4edd02
3b6d90f85e8dadcb3c02922e730e4a9d	1545b040d61dc2d236ca4dea7e2cff46
3e28a735f3fc31a9c8c30b47872634bf	1545b040d61dc2d236ca4dea7e2cff46
ba9bfb4d7c1652a200d1d432f83c5fd1	1545b040d61dc2d236ca4dea7e2cff46
5e6ff2b64b4c0163ab83ab371abe910b	ecf31cb1a268dfd8be55cb3dff9ad09d
6adc39f4242fd1ca59f184e033514209	ecf31cb1a268dfd8be55cb3dff9ad09d
6af2c726b2d705f08d05a7ee9509916e	ecf31cb1a268dfd8be55cb3dff9ad09d
fc239fd89fd7c9edbf2bf27d1d894bc0	ecf31cb1a268dfd8be55cb3dff9ad09d
647dadd75e050b230269e43a4fe351e2	fff66a4d00c8ed7bb7814ff29d0faca2
7bc374006774a2eda5288fea8f1872e3	fff66a4d00c8ed7bb7814ff29d0faca2
5934340f46d5ab773394d7a8ac9e86d5	fff66a4d00c8ed7bb7814ff29d0faca2
71b6971b6323b97f298af11ed5455e55	4690ec139849f88f1c10347d0cc7d1b5
1437c187d64f0ac45b6b077a989d5648	4690ec139849f88f1c10347d0cc7d1b5
dcab0d84960cda81718e38ee47688a75	4690ec139849f88f1c10347d0cc7d1b5
8fdc3e13751b8f525f259d27f2531e87	4690ec139849f88f1c10347d0cc7d1b5
09c00610ca567a64c82da81cc92cb846	80a26219c468afbb3a762d5e3cb56f39
5a534330e31944ed43cb6d35f4ad23c7	80a26219c468afbb3a762d5e3cb56f39
a2761eea97ee9fe09464d5e70da6dd06	80a26219c468afbb3a762d5e3cb56f39
b615ea28d44d2e863a911ed76386b52a	afb45735b54991094a6734f53c375faf
b02ba5a5e65487122c2c1c67351c3ea0	afb45735b54991094a6734f53c375faf
5ef02a06b43b002e3bc195b3613b7022	afb45735b54991094a6734f53c375faf
0e609404e53b251f786b41b7be93cc19	afb45735b54991094a6734f53c375faf
fc239fd89fd7c9edbf2bf27d1d894bc0	afb45735b54991094a6734f53c375faf
9722f54adb556b548bb9ecce61a4d167	afb45735b54991094a6734f53c375faf
8cd7fa96a5143f7105ca92de7ff0bac7	afb45735b54991094a6734f53c375faf
67cc86339b2654a35fcc57da8fc9d33d	e9b9ca12c93fad258ac0360aba14c7bc
6caa47f7b3472053b152f84ce72c182c	e9b9ca12c93fad258ac0360aba14c7bc
a7e071b3de48cec1dd24de6cbe6c7bf1	e9b9ca12c93fad258ac0360aba14c7bc
e3e9ccd75f789b9689913b30cb528be0	53ed714383288793db977e8f7326eb61
849c829d658baaeff512d766b0db3cce	53ed714383288793db977e8f7326eb61
d192d350b6eace21e325ecf9b0f1ebd1	53ed714383288793db977e8f7326eb61
198445c0bbe110ff65ac5ef88f026aff	e66156cc95b698d8f4d04ec6dfbb5ab7
0a3a1f7ca8d6cf9b2313f69db9e97eb8	e66156cc95b698d8f4d04ec6dfbb5ab7
cb80a6a84ec46f085ea6b2ff30a88d80	3545b02c56a2568e2bff21a5c410374a
b00114f9fc38b48cc42a4972d7e07df6	3545b02c56a2568e2bff21a5c410374a
8b22cf31089892b4c57361d261bd63f7	2634ef92ca50d68809edba7cb6052bd2
bd4ca3a838ce3972af46b6e2d85985f2	2634ef92ca50d68809edba7cb6052bd2
913df019fed1f80dc49b38f02d8bae41	f47e2dc1975f8d3fb8639e4dd2fff7c0
04c8327cc71521b265f2dc7cbe996e13	f47e2dc1975f8d3fb8639e4dd2fff7c0
e5ea2ac2170d4f9c2bdbd74ab46523f7	a9fa565c9ff23612cb5b522c340b09d1
a9afdc809b94392fb1c2e873dbb02781	a9fa565c9ff23612cb5b522c340b09d1
6caa47f7b3472053b152f84ce72c182c	9de74271aea8fca48a4b30e94e71a6b2
b00114f9fc38b48cc42a4972d7e07df6	9de74271aea8fca48a4b30e94e71a6b2
1b62f034014b1d242c84c6fe7e6470f0	bcfac7bf0f09d47c614d62c4a88a2771
9d514e6b301cfe7bdc270212d5565eaf	bcfac7bf0f09d47c614d62c4a88a2771
d162c87d4d4b2a8f6dda58d4fba5987f	db4560bb40a4c4309950c9bc94a5880c
b00114f9fc38b48cc42a4972d7e07df6	db4560bb40a4c4309950c9bc94a5880c
6a13b854e05f5ba6d2a0d873546fc32d	8591e5f94f6bc6bbce534233d5a429b8
010fb41a1a7714387391d5ea1ecdfaf7	8591e5f94f6bc6bbce534233d5a429b8
4bffc4178bd669b13ba0d91ea0522899	8591e5f94f6bc6bbce534233d5a429b8
f66935eb80766ec0c3acee20d40db157	8591e5f94f6bc6bbce534233d5a429b8
cd1c06e4da41121b7362540fbe8cd62c	8591e5f94f6bc6bbce534233d5a429b8
8765cfbf81024c3bd45924fee9159982	2633fb17d46136a100ff0e04babcf90b
05bea3ed3fcd45441c9c6af3a2d9952d	2633fb17d46136a100ff0e04babcf90b
f2ba1f213e72388912791eb68adc3401	dbcd911ed4e19311c6fdd54423bac8ff
b00114f9fc38b48cc42a4972d7e07df6	dbcd911ed4e19311c6fdd54423bac8ff
cb80a6a84ec46f085ea6b2ff30a88d80	aa437deed9ab735d4bd2e5721270fe1a
39ce458f2caa87bc7b759cd8cb16e62f	710a89d5cb9f3ceb3e6934254a8696e4
eb4558fa99c7f8d548cbcb32a14d469c	8dbf2602d350002b61aeb50d7b1f5823
13de0a41f18c0d71f5f6efff6080440f	8dbf2602d350002b61aeb50d7b1f5823
88059eaa73469bb47bd41c5c3cdd1b50	8dbf2602d350002b61aeb50d7b1f5823
2eed213e6871d0e43cc061b109b1abd4	8dbf2602d350002b61aeb50d7b1f5823
ed9b92eb1706415c42f88dc91284da8a	8dbf2602d350002b61aeb50d7b1f5823
33b3bfc86d7a57e42aa30e7d1c2517be	8dbf2602d350002b61aeb50d7b1f5823
8351282db025fc2222fc61ec8dd1df23	8dbf2602d350002b61aeb50d7b1f5823
60eb202340e8035af9e96707f85730e5	8dbf2602d350002b61aeb50d7b1f5823
d5a5e9d2edeb2b2c685364461f1dfd46	8dbf2602d350002b61aeb50d7b1f5823
4522c5141f18b2a408fc8c1b00827bc3	8dbf2602d350002b61aeb50d7b1f5823
2587d892c1261be043d443d06bd5b220	8dbf2602d350002b61aeb50d7b1f5823
5e62fc773369f140db419401204200e8	8dbf2602d350002b61aeb50d7b1f5823
f520f53edf44d466fb64269d5a67b69a	8dbf2602d350002b61aeb50d7b1f5823
71a520b6d0673d926d02651b269cf92c	f5950ade448acc14014ac65eff80d13e
11a5f9f425fd6da2d010808e5bf759ab	d9394bc9b31837f373476bdde3cb4555
f00bbb7747929fafa9d1afd071dba78e	4863b843abbe1696e3656c13aa67af90
f975b4517b002a52839c42e86b34dc96	52a9361c8d305f2a227161a44bcfd37e
370cde851ed429f1269f243dd714cce2	2fe3f1db170aa816123f28e9875167ab
5e6ff2b64b4c0163ab83ab371abe910b	c69d790bf21dedfe84a9fb4719e93bd8
a9ef9373c9051dc4a3e2f2118537bb2d	488d66856880e32fb94d0e791471e015
8af17e883671377a23e5b8262de11af4	488d66856880e32fb94d0e791471e015
cb80a6a84ec46f085ea6b2ff30a88d80	c06a06a848c3e27a6fc8e7203ec2b746
75fea12b82439420d1f400a4fcf3386b	73c823a8a18bd3e6e0de48741791df2e
64a25557d4bf0102cd8f60206c460595	c70fac279516f5b04a129d64eff982e8
dcdcd2f22b1d5f85fa5dd68fa89e3756	f28bf03afc0802c0bc6eb584b4003e89
abe78132c8e446430297d08bd1ecdab0	9d26ef0f0b7d75ea30b8cdaad29f3c08
d8d3a01ba7e5d44394b6f0a8533f4647	d8cb73495a9e354d9c21b2a91383df69
c827a8c6d72ff66b08f9e2ab64e21c01	6fa675606729b1ccf2c9f118afab1a78
a8ace0f003d8249d012c27fe27b258b5	6fa675606729b1ccf2c9f118afab1a78
57126705faf40e4b5227c8a0302d13b2	6fa675606729b1ccf2c9f118afab1a78
b84cdd396f01275b63bdaf7f61ed5a43	6fa675606729b1ccf2c9f118afab1a78
781734c0e9c01b14adc3a78a4c262d83	6fa675606729b1ccf2c9f118afab1a78
db1440c4bae3edf98e3dab7caf2e7fed	6fa675606729b1ccf2c9f118afab1a78
efe9ed664a375d10f96359977213d620	3a9ee0dca39438793417d3cda903c50f
c5068f914571c27e04cd66a4ec5c1631	3a9ee0dca39438793417d3cda903c50f
d69462bef6601bb8d6e3ffda067399d9	3a9ee0dca39438793417d3cda903c50f
f655d84d670525246ee7d57995f71c10	3834ca66ed31bf867405bae4cffe4462
c82b23ed65bb8e8229c54e9e94ba1479	1d1fe01580e2014b5b4d05532937b08d
7df470ec0292985d8f0e37aa6c2b38d5	6af1540af240e4518095bf9c350e6592
d5b95b21ce47502980eebfcf8d2913e0	6af1540af240e4518095bf9c350e6592
8791e43a8287ccbc21f61be21e90ce43	8987193624cb1569dbea7ccbdef6da9d
3480c10b83b05850ec18b6372e235139	f5ccf3e5aaff8573d851e3db037f78c4
3b8d2a5ff1b16509377ce52a92255ffe	4bc6884ff3b54bf84c2970cf8cb57a35
c82a107cd7673a4368b7252aa57810fc	70accb11df7fea2ee734e5849044f3c8
7d3618373e07c4ce8896006919bbb531	100694588d8a8f56e87fe60639138889
93025091752efa184fd034f285573afe	3e8f76b0649ca67ad8e74983a81967dd
a30c1309e683fcf26c104b49227d2220	b9d93d1a014743df713103a89d6dfab5
41e744bdf3114b14f5873dfb46921dc4	b9d93d1a014743df713103a89d6dfab5
c52d5020aad50e03d48581ffb34cd1c3	1351b0fdf73876875879089319d8ac18
04d53bc45dc1343f266585b52dbe09b0	1351b0fdf73876875879089319d8ac18
3ddbf46000c2fbd44759f3b4672b64db	6bbdbb8ffb00d3c84d0e41be08b52d74
662d17c67dcabc738b8620d3076f7e46	48cd76244ec92de22070746c3e51903c
87bd9baf0b0d760d1f0ca9a8e9526161	ea678a9205735898d39982a6854e4be0
55c63b0540793d537ed29f5c41eb9c3e	ea678a9205735898d39982a6854e4be0
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	ea678a9205735898d39982a6854e4be0
fcf66a6d6cfbcb1d4a101213b8500445	db187442033cf1a7b36b4f4864cb3e2d
c9dc004fc3d039ad7fb49456e5902b01	5d8ac336bc2495c7cc4da26ee697f6db
abe78132c8e446430297d08bd1ecdab0	74395b327e2c89e506e5fb24cdf28d86
3a7e46261a591b3e65d1e7d0b2439b20	7711321c6e440423ac48fa14fe13662d
b00114f9fc38b48cc42a4972d7e07df6	f7947636b65c4e40dd72ac4977fba81e
05bea3ed3fcd45441c9c6af3a2d9952d	716c8362b9535c67f7a3d8bba41e495c
cb80a6a84ec46f085ea6b2ff30a88d80	091194d34dc129972848b1a6507d3db5
3e98ecfa6a4c765c5522f897a4a8de23	582ac46d71d166a2ea996507406eb2ef
5dd5b236a364c53feb6db53d1a6a5ab9	7a62d4197e468e9dc15c90c04a00c9d8
5b5fc236828ee2239072fd8826553b0a	3b4b6f12576b1161eb56ef870c91cfd2
40fcfb323cd116cf8199485c35012098	e51d880916bc83c61e116bd2c9007d08
aa98c9e445775e7c945661e91cf7e7aa	e31bcdc3311e00fe13a85ee759b65391
9c81c8c060b39e7437b2d913f036776b	e31bcdc3311e00fe13a85ee759b65391
4900e24b2d0a0c5e06cf3db8b0638800	0f9047d3e34cffa3f65d1c63ed09c7aa
96b4b857b15ae915ce3aa5e406c99cb4	0f9047d3e34cffa3f65d1c63ed09c7aa
7b52c8c4a26e381408ee64ff6b98e231	0f9047d3e34cffa3f65d1c63ed09c7aa
f79485ffe5db7e276e1e625b0be0dbec	01c97e93bae9f24e53f18b9ab33a09bf
246d570b4e453d4cb6e370070c902755	3d656f422f1599e545bddbd4a00b0ad1
66cc7344291ae2a297bf2aa93d886e22	3d656f422f1599e545bddbd4a00b0ad1
3b544a6f1963395bd3ae0aeebdf1edd8	70298a157c0bf97858f6190eae969607
d5ec808c760249f11fbcde2bf4977cc6	d967887a45ca999480ae3aec9fd17530
77bfe8d21f1ecc592062f91c9253d8ab	595fe5f4c408660a17d44e1801c232f2
1fd7fc9c73539bee88e1ec137b5f9ad2	196c7e704b6f026b852b24771bf71ddd
f44f1e343975f5157f3faf9184bc7ade	196c7e704b6f026b852b24771bf71ddd
03201e85fc6aa56d2cb9374e84bf52ca	196c7e704b6f026b852b24771bf71ddd
d44be0e711c2711876734b330500e5b9	196c7e704b6f026b852b24771bf71ddd
0ada417f5b4361074360211e63449f34	196c7e704b6f026b852b24771bf71ddd
807dbc2d5a3525045a4b7d882e3768ee	196c7e704b6f026b852b24771bf71ddd
cb80a6a84ec46f085ea6b2ff30a88d80	f4e72bc32f2c636059d5f3ba44323921
2054decb2290dbaab1c813fd86cc5f8b	eb8416f378010a87c0bb7b3dcf803c65
a985c9764e0e6d738ff20f2328a0644b	873cdb7bb058e91ccdbd703bf2c85268
1b62f034014b1d242c84c6fe7e6470f0	4c0bd4b8244a1199bf0ff9a9e7ea9f97
707270d99f92250a07347773736df5cc	e7d141392548a9459e0e6e7584c1c80f
f986b00063e79f7c061f40e6cfbbd039	024837b88bb23cb8a1f0bba69f809c93
2dde74b7ec594b9bd78da66f1c5cafdc	329f0752061992d0b466b8a2a8760c34
2d1ba9aa05ea4d94a0acb6b8dde29d6b	0a96c0f13cf38b7e26172c335ce7933c
13291409351c97f8c187790ece4f5a97	83689c87f9463b158622ef712a5e8751
89b5ac8fb4c102c174adf2fed752a970	83689c87f9463b158622ef712a5e8751
7d6ede8454373d4ca5565436cbfeb5c0	b80e8e613789267c95b6b1ef44e48423
7bc374006774a2eda5288fea8f1872e3	030e39a1278a18828389b194b93211aa
e2afc3f96b4a23d451c171c5fc852d0f	2e8dbdc23b3287569d32c2bf5fe26e06
ed783268eca01bff52c0f135643a9ef7	b5c548a4d670c490bbc7e20e74417003
98e8599d1486fadca0bf7aa171400dd8	39bb71ab4328d2d97bd4710252ca0e16
13c8bd3a0d92bd186fc5162eded4431d	c8ae0bc02385186afd062503fa77a1bc
ea3f5f97f06167f4819498b4dd56508e	e1d8dfba59d6e8fe67883a5ff3fdabe4
198445c0bbe110ff65ac5ef88f026aff	4ac132d03b25a67f35c159e952b9951e
5fa07e5db79f9a1dccb28d65d6337aa6	c4ba898ee9eeb44ad4c2647e8ebe930a
63a9f0ea7bb98050796b649e85481845	9d90cd61df8dbf35d395a0e225e3639c
8987e9c300bc2fc5e5cf795616275539	972855f17f9fffa2f73ced39e72c706e
0ae3b7f3ca9e9ddca932de0f0df00f8a	fbe6bca8488a519965b8d63d5d7270c5
abca417a801cd10e57e54a3cb6c7444b	0bb2ac8dea4da36597a8d9dc88f0ed64
f29f7213d1c86c493ca7b4045e5255a9	0bb2ac8dea4da36597a8d9dc88f0ed64
b3626b52d8b98e9aebebaa91ea2a2c91	c960a78b4d3e0ce6a4a67f9094ffb446
f66935eb80766ec0c3acee20d40db157	a8feea8bc8e568f5829eeec3fba8fc29
cd1c06e4da41121b7362540fbe8cd62c	a8feea8bc8e568f5829eeec3fba8fc29
f66935eb80766ec0c3acee20d40db157	5c3ed018832788fa9d1111b57da7fba6
65f889eb579641f6e5f58b5a48f3ec12	880318f1ad9a84c6c58e46899781dca3
c0118be307a26886822e1194e8ae246d	73c5e4259f031aa3b934d3dfe4128433
19cbbb1b1e68c42f3415fb1654b2d390	6072e357ce0ffc85924d07f3f59fde6d
cd004b87e2adfb72b28752a6ef6cd639	8de7ee0c42a9acb04ac0ba7e466ef5fc
58e42b779d54e174aad9a9fb79e7ebbc	9e9cce9be25a7f0972590e519d967b9c
eb3a9fb71b84790e50acd81cc1aa4862	c364e34b3108a2a1051940f5f6d389dd
74e8b6c4be8a0f5dd843e2d1d7385a36	8a1cece259499b3705bc5b42ddcd9169
b84cdd396f01275b63bdaf7f61ed5a43	8a1cece259499b3705bc5b42ddcd9169
9133f1146bbdd783f34025bf90a8e148	d0ff6355a52e022c45ae8d7951520142
113ab4d243afc4114902d317ad41bb39	e845a7698a158850fada750bf0ce091f
cc70416ca37c5b31e7609fcc68ca009e	853553f865f9bf21df0911e6ce54c7d0
cf38e7d92bb08c96c50ddc723b624f9d	bc401be0ed7c2f7ce03dfab7faa76466
1de3f08835ab9d572e79ac0fca13c5c2	3b8f2fd29146bee84451b55c0d80e880
5878f5f2b1ca134da32312175d640134	75bab3d672e799f6790e8b068d6461e1
d0dae91314459033160dc47a79aa165e	637fec0bdd87d25870885872fb1c4474
7eeea2463ae5da9990cab53c014864fa	b21afc54fb48d153c19101658f4a2a48
4669569c9a870431c4896de37675a784	b21afc54fb48d153c19101658f4a2a48
786a755c895da064ccd4f9e8eb7e484e	b21afc54fb48d153c19101658f4a2a48
4669569c9a870431c4896de37675a784	2b21d9d8f81c6e564c84ef0bfa94aa5c
a0abb504e661e34f5d269f113d39ea96	2b21d9d8f81c6e564c84ef0bfa94aa5c
9d36a42a36b62b3f665c7fa07f07563b	c2b17b8cb332d071d4ac81167b2a6219
8c4e8003f8d708dc3b6d486d74d9a585	2f8566ec213384ffa50ef40b2125b657
baeb191b42ec09353b389f951d19b357	ba08853dd62a1b1d7cbf6ca8a1b4a14b
2df9857b999e21569c3fcce516f0f20e	6dff21106c4ac0fd7d0251575f4348ab
645b264cb978b22bb2d2c70433723ec0	27a7e9871142d8ed01ed795f9906c2fe
d0e551d6887e0657952b3c5beb7fed74	27a7e9871142d8ed01ed795f9906c2fe
3771036a0740658b11cf5eb73d9263b3	27a7e9871142d8ed01ed795f9906c2fe
6b37fe4703bd962004cdccda304cc18e	27a7e9871142d8ed01ed795f9906c2fe
28bb3f229ca1eeb05ef939248f7709ce	27a7e9871142d8ed01ed795f9906c2fe
080d2dc6fa136fc49fc65eee1b556b46	03677e82c7b8cd3989c8a6cb4e2426fa
4522c5141f18b2a408fc8c1b00827bc3	9826e03298104619700dc6e7b69ba1b0
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	3a61b71b271203a633e10c5b3fa9f258
a822d5d4cdcb5d1b340a54798ac410b7	3a61b71b271203a633e10c5b3fa9f258
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	95f292773550fc8d39aaa8ddc9f3cfac
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	e909c2d7067ea37437cf97fe11d91bd0
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	a3e345c35eed0ed54daf356c68904785
b9cb3bb4bbbe4cd2afa9c78fe66ad1e9	498059d42123bacbded45916a8636d8c
a822d5d4cdcb5d1b340a54798ac410b7	6a1f771fc024994f9c170ab5dc6c5bb0
a822d5d4cdcb5d1b340a54798ac410b7	525f9a6e460f7ea2c6f932a2dc42ef67
a822d5d4cdcb5d1b340a54798ac410b7	7bd49e2e64f65e2ee987be9709a176bd
6db22194a183d7da810dcc29ea360c17	2da31ada27f1ba5acc3403440650870a
ab5428d229c61532af41ec2ca258bf30	ead88b8beaa93bbd5041a88383609ac6
9527fff55f2c38fa44281cd0e4d511ba	81946bb5619fab717be3cc147b88dec0
61a6502cfdff1a1668892f52c7a00669	558a32df12c25cc4ffbef306adb35511
5c3278fb76fa2676984396d33ba90613	4246bdb500b31cb6f2786206dacf8589
6ee6a213cb02554a63b1867143572e70	f89557d3db6e6413df4955c8d247e89c
496a6164d8bf65daf6ebd4616c95b4b7	c5e0ef077394352c5f1fef29365e5841
a571d94b6ed1fa1e0cfff9c04bbeb94d	16518154fcc12cb9c715478443414867
ec4f407118924fdc6af3335c8d2961d9	6b240b0fbb47884b8ecca1d1b7574b24
ed795c86ba21438108f11843f7214c95	1daa2df0fcb1df14e6f600785631b964
b80aecda9ce9783dab49037eec5e4388	f155b26f32e07effd2474272637c4b22
b80aecda9ce9783dab49037eec5e4388	22bbb483dcba75fc2df016dc284d293b
a1af2abbd036f0499296239b29b40a5f	1a37b66179fd5fac40dc3c09b0da2f12
bf5c782ca6b0130372ac41ebd703463e	b13bb1f32f0106bf78a65fd98b522515
01ffa9ce7c50b906e4f5b6a2516ba94b	8e47a4c0304670944a03089849f42e07
6caa2c6d69ebdc30a3c4580979c3e630	2db87892408abd4d82eb39b78c50c27b
3ec4a598041aa926d5f075e3d69dfc0a	d25334037d936d3257f794a10bb3030f
0fa4e99a2451478f3870e930d263cfd4	3a9ee0dca39438793417d3cda903c50f
6c718d616702ff78522951d768552d6a	7b4b7e3375c9f7424a57a2d9d7bccde5
6c718d616702ff78522951d768552d6a	93cf908c24c1663d03d67facc359acc2
6c718d616702ff78522951d768552d6a	b80e9df4d9b290518ee42ad01df931f9
9efb345179e21314a38093da366e1f09	2db87892408abd4d82eb39b78c50c27b
b7f3ddec78883ff5a0af0d223f491db8	7b4b7e3375c9f7424a57a2d9d7bccde5
3472e72b1f52a7fda0d4340e563ea6c0	0c5544f60e058b8cbf571044aaa6115f
f816407dd0b81a5baedb7695302855d9	3593526a5f465ed766bafb4fb45748a2
e2b16c5f5bad24525b8c700c5c3b3653	d30be26d66f0448359f54d923aab2bb9
e2b16c5f5bad24525b8c700c5c3b3653	9e7315413ae31a070ccae5c580dd1b19
b0353ada659e3848bd59dec631e71f9e	afb45735b54991094a6734f53c375faf
c256d34ab1f0bd3928525d18ddabe18e	73d0749820562452b33d4e0f4891efcd
0035ac847bf9e371750cacbc98ad827b	eff28181bc16f9980300231c2831cfed
0035ac847bf9e371750cacbc98ad827b	646b7096ac40bf3b76f46527bf50607a
0035ac847bf9e371750cacbc98ad827b	a94bc9e378c8007c95406059d09bb4f3
49bb0f64fae1bd9abf59989d5a5adfaf	22bbb483dcba75fc2df016dc284d293b
de2290e4c7bfa39e594c2dcd6e4c09d6	423c4aac42f2b97e03b0b351b62b88bf
de2290e4c7bfa39e594c2dcd6e4c09d6	0c7fde545c06c2bc7383c0430c95fb78
de2290e4c7bfa39e594c2dcd6e4c09d6	7f464b34be2c37650003a770ce74d876
f929c32e1184b9c0efdd60eb947bf06b	0c7fde545c06c2bc7383c0430c95fb78
f929c32e1184b9c0efdd60eb947bf06b	3593526a5f465ed766bafb4fb45748a2
f929c32e1184b9c0efdd60eb947bf06b	d97cb00c4880b250daae88ad9c0f29bb
f929c32e1184b9c0efdd60eb947bf06b	bd1340d19723308d52dcf7c3a6b1ea87
25f02579d261655a79a54a1fc5c4baf5	39bb71ab4328d2d97bd4710252ca0e16
10dbb54312b010f3aeb9fde389fe6cf5	3593526a5f465ed766bafb4fb45748a2
10dbb54312b010f3aeb9fde389fe6cf5	d30be26d66f0448359f54d923aab2bb9
f0cd1b3734f01a46d31c5644e3216382	3593526a5f465ed766bafb4fb45748a2
2ef1ea5e4114637a2dc94110d4c3fc7a	2db87892408abd4d82eb39b78c50c27b
09fcf410c0bb418d24457d323a5c812a	2db87892408abd4d82eb39b78c50c27b
bd6d4ce8e8bd1f6494db102db5a06091	13413382593041359bf0de3827dcf8d5
f68e5e7b745ade835ef3029794b4b0b2	2db87892408abd4d82eb39b78c50c27b
d4f9c39bf51444ae90cc8947534f20e4	2db87892408abd4d82eb39b78c50c27b
55edd327aec958934232e98d828fb56a	2db87892408abd4d82eb39b78c50c27b
6435684be93c4a59a315999d3a3227f5	2db87892408abd4d82eb39b78c50c27b
6435684be93c4a59a315999d3a3227f5	7d3969ae3630f4bf306152ed36280f48
e340c1008146e56c9d6c7ad7aa5b8146	a94bc9e378c8007c95406059d09bb4f3
e340c1008146e56c9d6c7ad7aa5b8146	fff66a4d00c8ed7bb7814ff29d0faca2
a6c37758f53101378a209921511369de	2db87892408abd4d82eb39b78c50c27b
5b05784f3a259c7ebc2fffc1cf0c37b7	2db87892408abd4d82eb39b78c50c27b
baf938346589a5e047e2aa1afcc3d353	b9d93d1a014743df713103a89d6dfab5
034c15ae2143eea36eec7292010568a1	bcfc9877823bc82005f8062436e3d81e
034c15ae2143eea36eec7292010568a1	0403a39b82e1ef52bb4dfd3682a42c73
50437ed6fdec844c3d86bb6ac8a4a333	6af1540af240e4518095bf9c350e6592
50437ed6fdec844c3d86bb6ac8a4a333	d30be26d66f0448359f54d923aab2bb9
bb7dcf6e8a0c1005d2be54f005e9ff8f	b54875674f7d2d5be9737b0d4c021a21
05acc535cbe432a56e2c9cfb170ee635	b54875674f7d2d5be9737b0d4c021a21
7a78e9ce32da3202ac0ca91ec4247086	3593526a5f465ed766bafb4fb45748a2
7a78e9ce32da3202ac0ca91ec4247086	9e7315413ae31a070ccae5c580dd1b19
ba404ce5a29ba15a792583bbaa7969c6	2db87892408abd4d82eb39b78c50c27b
d8cddac7db3dedd7d96b81a31dc519b3	3593526a5f465ed766bafb4fb45748a2
d8cddac7db3dedd7d96b81a31dc519b3	2db87892408abd4d82eb39b78c50c27b
63dab0854b1002d4692bbdec90ddaecc	5fefa04e0919aa751cff36fe3a94f833
63dab0854b1002d4692bbdec90ddaecc	93cf908c24c1663d03d67facc359acc2
3e8f57ef55b9d3a8417963f343db1de2	fedf6851863c5847bc0bf5de7c3c758e
3e8f57ef55b9d3a8417963f343db1de2	d30be26d66f0448359f54d923aab2bb9
7176be85b1a9e340db4a91d9f17c87b3	8a743590316d1519ab5ecc8d142415a2
7176be85b1a9e340db4a91d9f17c87b3	d30be26d66f0448359f54d923aab2bb9
cc31f5f7ca2d13e95595d2d979d10223	73d0749820562452b33d4e0f4891efcd
cc31f5f7ca2d13e95595d2d979d10223	6af1540af240e4518095bf9c350e6592
ea6fff7f9d00d218338531ab8fe4e98c	d30be26d66f0448359f54d923aab2bb9
00a616d5caaf94d82a47275101e3fa22	3593526a5f465ed766bafb4fb45748a2
708abbdc2eb4b62e6732c4c2a60c625a	b54875674f7d2d5be9737b0d4c021a21
ffd6243282cdf77599e2abaf5d1a36e5	3593526a5f465ed766bafb4fb45748a2
d148b29cbc0092dc206f9217a1b3da73	3593526a5f465ed766bafb4fb45748a2
a70a003448c0c2d2a6d4974f60914d40	9e7315413ae31a070ccae5c580dd1b19
a70a003448c0c2d2a6d4974f60914d40	c7fb67368c25c29b9c10ca91b2d97488
68f05e1c702a4218b7eb968ff9489744	9e7315413ae31a070ccae5c580dd1b19
68f05e1c702a4218b7eb968ff9489744	0a8a13bf87abe8696fbae4efe2b7f874
b5067ff7f533848af0c9d1f3e6c5b204	d30be26d66f0448359f54d923aab2bb9
dba661bb8c2cd8edac359b22d3f9ddf3	3593526a5f465ed766bafb4fb45748a2
553adf4c48f103e61a3ee7a94e7ea17b	3593526a5f465ed766bafb4fb45748a2
134a3bbedd12bc313d57aa4cc781ddf9	9e7315413ae31a070ccae5c580dd1b19
ab9ca8ecf42a92840c674cde665fbdd3	4690ec139849f88f1c10347d0cc7d1b5
d4192d77ea0e14c40efe4dc9f08fdfb8	3593526a5f465ed766bafb4fb45748a2
5fac4291bc9c25864604c4a6be9e0b4a	3593526a5f465ed766bafb4fb45748a2
5fac4291bc9c25864604c4a6be9e0b4a	c8ae0bc02385186afd062503fa77a1bc
ecd06281e276d8cc9a8b1b26d8c93f08	8bb92c3b9b1b949524aac3b578a052b6
bf6cf2159f795fc867355ee94bca0dd5	8bb92c3b9b1b949524aac3b578a052b6
3b0713ede16f6289afd699359dff90d4	3593526a5f465ed766bafb4fb45748a2
46148baa7f5229428d9b0950be68e6d7	0a96c0f13cf38b7e26172c335ce7933c
a909b944804141354049983d9c6cc236	88ff69ec6aa54fb228d85b92f3b12945
a909b944804141354049983d9c6cc236	b81acdb05aef5596bb72fe68d03cfaa2
16e54a9ce3fcedbadd0cdc18832266fd	19ceec79dad9529ea3d0ea15b5781312
16e54a9ce3fcedbadd0cdc18832266fd	2cfb794ae8db38d488dbd27f0f3a8b14
16e54a9ce3fcedbadd0cdc18832266fd	88ff69ec6aa54fb228d85b92f3b12945
b08bdd1d40a38ab9848ff817294332ca	b54875674f7d2d5be9737b0d4c021a21
b08bdd1d40a38ab9848ff817294332ca	488d66856880e32fb94d0e791471e015
b06edc3ce52eb05a5a45ae58a7bb7adc	2db87892408abd4d82eb39b78c50c27b
9a83f3f2774bee96b8f2c8595fc174d7	2db87892408abd4d82eb39b78c50c27b
4124cc9a170709b345d3f68fd563ac33	3593526a5f465ed766bafb4fb45748a2
4124cc9a170709b345d3f68fd563ac33	2db87892408abd4d82eb39b78c50c27b
a1e60d2ccea21edbaf84a12181d1e966	2db87892408abd4d82eb39b78c50c27b
a1e60d2ccea21edbaf84a12181d1e966	f54c3ccedc098d37a4e7f7a455f5731e
94edec5dc10d059f05d513ce4a001c22	5148c20f58db929fe77e3cb0611dc1c4
d1b8bfadad3a69dbd746217a500a4db5	f54c3ccedc098d37a4e7f7a455f5731e
57006f73c326669c8d52c47a3a9e2696	02a506ada599434029efcb78921153af
28a6ebe1e170483c1695fca36880db98	8f8351209253e5c5d8ff147b02d3b117
28a6ebe1e170483c1695fca36880db98	db4560bb40a4c4309950c9bc94a5880c
ce34dc9b3e210fd7a61d94df77bd8398	9e7315413ae31a070ccae5c580dd1b19
cdd21eba97ee010129f5d1e7a80494cb	5e57b61f8223fb8b54685a6a063ad3cc
cdd21eba97ee010129f5d1e7a80494cb	283a2e526241b2c01f4928afda6a2e0a
ec29a7f3c6a4588ef5067ea12a19e4e1	3593526a5f465ed766bafb4fb45748a2
ec29a7f3c6a4588ef5067ea12a19e4e1	0c7fde545c06c2bc7383c0430c95fb78
23dad719c8a972b4f19a65c79a8550fe	3593526a5f465ed766bafb4fb45748a2
dac6032bdce48b416fa3cd1d93dc83b8	3593526a5f465ed766bafb4fb45748a2
73cff3ab45ec02453b639abccb5bd730	7b4b7e3375c9f7424a57a2d9d7bccde5
73cff3ab45ec02453b639abccb5bd730	d25334037d936d3257f794a10bb3030f
442ea4b6f50b4ae7dfde9350b3b6f664	9e7315413ae31a070ccae5c580dd1b19
442ea4b6f50b4ae7dfde9350b3b6f664	0a8a13bf87abe8696fbae4efe2b7f874
442ea4b6f50b4ae7dfde9350b3b6f664	d30be26d66f0448359f54d923aab2bb9
af8b7f5474d507a8e583c66ef1eed5a5	ecf31cb1a268dfd8be55cb3dff9ad09d
af8b7f5474d507a8e583c66ef1eed5a5	fe81a4f28e6bd176efc8184d58544e66
bf250243f776c4cc4a9c4a1f81f7e42f	3593526a5f465ed766bafb4fb45748a2
bc30e7b15744d2140e28e5b335605de5	3593526a5f465ed766bafb4fb45748a2
8b174e2c4b00b9e0699967e812e97397	102289ea390e6d00463584fe50b1d87b
a68fbbd4507539f9f2579ad2e7f94902	c7fb67368c25c29b9c10ca91b2d97488
a68fbbd4507539f9f2579ad2e7f94902	f72e9105795af04cd4da64414d9968ad
a68fbbd4507539f9f2579ad2e7f94902	fe81a4f28e6bd176efc8184d58544e66
2e572c8c809cfbabbe270b6ce7ce88dd	e1d8dfba59d6e8fe67883a5ff3fdabe4
bfaffe308a2e8368acb49b51814f2bfe	2db87892408abd4d82eb39b78c50c27b
bfaffe308a2e8368acb49b51814f2bfe	9e7315413ae31a070ccae5c580dd1b19
6261b9de274cf2da37125d96ad21f1df	3593526a5f465ed766bafb4fb45748a2
6261b9de274cf2da37125d96ad21f1df	b3412a542c856d851d554e29aa16d4b6
804d27f4798081681e71b2381697e58c	2db87892408abd4d82eb39b78c50c27b
804d27f4798081681e71b2381697e58c	f3dcdca4cd0c83a5e855c5434ce98673
2918f3b4f699f80bcafb2607065451e1	4690ec139849f88f1c10347d0cc7d1b5
2918f3b4f699f80bcafb2607065451e1	5446a9fcc158ea011aeb9892ba2dfb15
2918f3b4f699f80bcafb2607065451e1	d30be26d66f0448359f54d923aab2bb9
b760518e994aa7db99d91f1b6aa52679	0a8a13bf87abe8696fbae4efe2b7f874
b760518e994aa7db99d91f1b6aa52679	d30be26d66f0448359f54d923aab2bb9
0fe3db5cf9cff35143d6610797f91f7c	d30be26d66f0448359f54d923aab2bb9
2304c368fd55bc45cb12f1589197e80d	e31bcdc3311e00fe13a85ee759b65391
6c3eceee73efa7af0d2f9f62daf63456	0bb2ac8dea4da36597a8d9dc88f0ed64
6a2367b68131111c0a9a53cd70c2efed	b54875674f7d2d5be9737b0d4c021a21
6a2367b68131111c0a9a53cd70c2efed	9e7315413ae31a070ccae5c580dd1b19
f2727091b6fe5656e68aa63d936c5dfd	8bb92c3b9b1b949524aac3b578a052b6
ec41b630150c89b30041d46b03f1da42	3593526a5f465ed766bafb4fb45748a2
cb3a240c27ebf12e17f9efe44fa4a7a8	3593526a5f465ed766bafb4fb45748a2
cb3a240c27ebf12e17f9efe44fa4a7a8	ba08853dd62a1b1d7cbf6ca8a1b4a14b
cfe9861e2a347cc7b50506ea46fdaf4f	5446a9fcc158ea011aeb9892ba2dfb15
926811886f475151c52dd365c90a7efc	9e7315413ae31a070ccae5c580dd1b19
afe4451c0c33641e67241bfe39f339ff	9e7315413ae31a070ccae5c580dd1b19
e27728342f660d53bd12ab14e5005903	9e7315413ae31a070ccae5c580dd1b19
e27728342f660d53bd12ab14e5005903	c7fb67368c25c29b9c10ca91b2d97488
3e6141409efd871b4a87deacfbf31c28	3593526a5f465ed766bafb4fb45748a2
e84900ed85812327945c9e72f173f8cc	3593526a5f465ed766bafb4fb45748a2
c3ce3cf87341cea762a1fb5d26d7d361	3593526a5f465ed766bafb4fb45748a2
c3ce3cf87341cea762a1fb5d26d7d361	b3412a542c856d851d554e29aa16d4b6
11ac50031c60fb29e5e1ee475be05412	3593526a5f465ed766bafb4fb45748a2
11ac50031c60fb29e5e1ee475be05412	9e7315413ae31a070ccae5c580dd1b19
bd9b8bf7d35d3bd278b5c300bc011d86	8dbf2602d350002b61aeb50d7b1f5823
bd9b8bf7d35d3bd278b5c300bc011d86	73d0749820562452b33d4e0f4891efcd
d39aa6fda7dc81d19cd21adbf8bd3479	2db87892408abd4d82eb39b78c50c27b
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.events (id_event, event, date_event, id_place, duration, price, persons, note) FROM stdin;
da4794bdc2159737a4c338392a856359	Guido's Super Sweet 16 (30. jubilee)	2018-04-27	17648f3308a5acb119d9aee1b5eafceb	0	9.00	2	\N
8b0e6056132f11cfb7968cf303ff0154	Guido's sassy 17 (30th edition)	2019-04-26	17648f3308a5acb119d9aee1b5eafceb	0	11.00	2	\N
cc02ce2d003fd86ba60f8688e6c40b97	Halloween Party 2019	2019-10-31	17648f3308a5acb119d9aee1b5eafceb	0	11.00	2	\N
f8bb8ae77ca110cf00ebb5af1d495203	Heavy metal gegen Mikroplastik	2019-10-19	17648f3308a5acb119d9aee1b5eafceb	0	10.0	2	\N
759144a13dee6936c81d0fce2eaaba06	Jomsviking European Tour 2016	2016-11-17	76f9a958c2ebbd2f42456523d749fb5e	0	40.40	2	\N
6c7cfe3af936c1590949350fc7d912d3	Fintroll + Metsatöll + Suotana Tour 2024	2024-04-22	eca8fc96e027328005753be360587de2	0	34.00	2	\N
9952e1e08fb8f493c66f5cf386ba7e06	Night on the Living Thrash Tour 2023	2023-11-09	eca8fc96e027328005753be360587de2	0	39.50	2	\N
91f86c2abd4b3c5f884c3947c424f70a	Cannibal Corpse, European Summer Tour 2019	2019-06-30	eca8fc96e027328005753be360587de2	0	30.00	2	\N
d4dafcc2060475c01e6b4f6f3cb5c488	"Still Cyco Punk" World Wide Tour 2018	2018-11-04	eca8fc96e027328005753be360587de2	0	34.00	2	\N
de64d3821b97e63cf8800dda1e32ee53	Metal Embrace Festival XII	2018-09-07	05be609ce9831967baa4f12664dc4d73	1	25.00	2	\N
1a2f8d593b063eccd9b1dc3431e01081	Metal Embrace Festival XIII	2019-09-06	05be609ce9831967baa4f12664dc4d73	1	25.0	2	\N
0601414fd50328355d256db5037bc430	Celebrating the music of Jimi Hendrix	2024-05-01	f3a90318abb3e16166d96055fd6f9096	0	24.20	2	\N
8b3c931e31a2c5dbb3155dab7dade775	Shades of Sorrow European Tour 2024	2024-05-04	f3a90318abb3e16166d96055fd6f9096	0	27.30	2	\N
bf65ac5101f339e8c8d756e99c49a829	Angelus Apatrida - Tour 2022	2022-07-28	f3a90318abb3e16166d96055fd6f9096	0	16.50	2	\N
2dac37a155782e0b3d86fc00d42b53d0	Hate, Keep of Kalessin	2024-05-02	f3a90318abb3e16166d96055fd6f9096	0	25.30	2	\N
cbe2729e13ce90825f88f2fc3a0bce55	Slamming Annihilation European Tour 2018	2018-05-21	f3a90318abb3e16166d96055fd6f9096	0	18.00	2	\N
08f8c67c20c4ba43e8ba6fa771039c94	Debauchery's Balgeroth	2018-11-03	f3a90318abb3e16166d96055fd6f9096	0	18.00	2	\N
11a728ed9e3a6aac1b46277a7302b15f	Hell over Europe II	2018-11-24	f3a90318abb3e16166d96055fd6f9096	0	24.00	2	\N
1b76db5ef5f13c3451dcc06344fae248	Warfield - Café Central	2022-02-05	f3a90318abb3e16166d96055fd6f9096	0	0.00	2	\N
d3bda1e9de8bc6d585f37b739264d649	Crisix, Insanity Alert	2021-09-16	f3a90318abb3e16166d96055fd6f9096	0	19.70	2	\N
a01b8b09fc0dea9192cb02b077bfae9f	Pagan Metal Festival	2019-11-03	f3a90318abb3e16166d96055fd6f9096	0	26.30	2	\N
74b2dd70f761e31a1e0860fe18f8cb55	Ektomorf - The legion of fury tour 2019	2019-04-25	f3a90318abb3e16166d96055fd6f9096	0	26.40	2	\N
3b23d8e33c40737f5ca4b3a0fbb54542	Eis und Nacht Tour 2020	2020-01-24	f3a90318abb3e16166d96055fd6f9096	0	24.10	2	\N
74480c2ba717722022d58038ab1bcd44	SARCOFAGO TRIBUTE (Fabio Jhasko)	2021-11-25	f3a90318abb3e16166d96055fd6f9096	0	20	2	\N
5e6a61fa17bf86a738024508581f11d4	HateSphere, sign of death	2023-06-03	f3a90318abb3e16166d96055fd6f9096	0	18.70	2	\N
45e481facaabaefb537716312cbb9f67	Morbidfest	2022-04-19	f3a90318abb3e16166d96055fd6f9096	0	33.00	2	\N
1845ce3f5f191d7265d512beb6be1708	Oblivion European Tour 2023	2023-08-10	f3a90318abb3e16166d96055fd6f9096	0	30.00	2	\N
84565434746de9ae0cd3baf57fcfd87d	Heidelberg Deathfest Warm-Up-Show 2024	2024-02-24	f3a90318abb3e16166d96055fd6f9096	0	30.70	2	\N
87d1f3bfe03274952aa29304eb82d9d9	The Path of Death 7	2018-10-20	a91bcaf7db7d174ee2966d9c293fd575	0	15.00	2	\N
bd4a5e87854fd4d729983f3ac9bc7268	The Path of Death 6	2017-10-14	a91bcaf7db7d174ee2966d9c293fd575	0	14.00	2	\N
e70608c5455336dfc61d221e145f51cd	Rock-N-Pop Youngsters 2019	2019-03-15	a91bcaf7db7d174ee2966d9c293fd575	0	0.00	2	\N
2bc0eb6a40bd1e2409b2722039152679	1. Mainzer Rock & Metal Fastnachts-Party	2019-03-02	a91bcaf7db7d174ee2966d9c293fd575	0	5.00	2	\N
f2da218ba072addd567741ba722037e4	The Path of Death 9	2021-11-13	a91bcaf7db7d174ee2966d9c293fd575	0	25.00	2	\N
b17a925acc0a591c2be6f84376007717	The Path of Death 8	2019-10-26	a91bcaf7db7d174ee2966d9c293fd575	0	14.00	2	\N
3d3cf571367952ee016599bba2ef18cb	Doom over Mainz	2019-09-21	a91bcaf7db7d174ee2966d9c293fd575	0	10.0	2	\N
c61c9363d160c5f94193056388d9ced9	Light to the blind, Slaughterra, All its Grace	2019-03-29	a91bcaf7db7d174ee2966d9c293fd575	0	10	2	\N
5165e8c183dbda4c319239e9f631b6f9	The Blackest Path	2022-10-08	a91bcaf7db7d174ee2966d9c293fd575	0	30.00	2	\N
06ed605b83d95d5a8488293416ceb999	Horresque & Guests	2022-05-13	a91bcaf7db7d174ee2966d9c293fd575	0	10.00	2	\N
cb4c2743c35bb374ab32d475ce8cfafe	Morbide Klänge II	2023-05-12	a91bcaf7db7d174ee2966d9c293fd575	0	15	2	\N
fbae6c1da1deba5dd51f5d07007ec5ab	Warfield / Purify / Sober Truth	2018-02-17	fc9917fb6f46c0eb12f1e429a33ba66b	0	10	2	\N
eeba68f0a1003dce9bd66066b82dc1b6	Heidelberg Deathfest III	2018-03-24	c72b4173a6a7131bf31a711212305fd3	0	35.00	2	\N
f6fecea2db8afd44e1ad77f699d38fe9	Heidelberg Deathfest IV	2019-03-23	c72b4173a6a7131bf31a711212305fd3	0	40.00	2	\N
568359348ea05d7114e3d796d7df55f2	Heidelberg Deathfest VI	2023-03-18	c72b4173a6a7131bf31a711212305fd3	0	55.21	2	\N
d3c946cf8862b847404204ab7d0cfc39	Campaing for musical destruction	2023-03-03	c72b4173a6a7131bf31a711212305fd3	0	34.00	2	\N
dc741cac8e46d127f4ce2524e5dbefa0	Heidelberg Deathfest V	2022-03-19	c72b4173a6a7131bf31a711212305fd3	0	42.00	2	\N
a4ef4e4104ed8bdd818771ca2ea34127	Völkerball in Mainz	2018-07-27	1b90e6739989e49dd0c81f338b61c134	0	0.00	2	\N
3fd69863958a8c69582d9f5bd6c82681	Südpfalz Metalfest	2020-09-25	6dde0719f779b373e62a7283e717d384	0	13.00	2	\N
24756eb800986d0cb679e4c78d8a06c2	Darkness approaching	2019-05-10	a91bcaf7db7d174ee2966d9c293fd575	0	7.00	2	\N
d7010a272554c22fa8d53efc81046bce	Death Over Mainz 2023	2023-04-21	a91bcaf7db7d174ee2966d9c293fd575	0	11.00	2	\N
9f07b2ac339c32524557ba186f68b2ef	Metal Embrace Festival XIV	2022-09-09	05be609ce9831967baa4f12664dc4d73	1	37.50	2	\N
ff9a901a93946ada59ef15661fd395e1	Death Metal night - 11.2023	2023-11-04	a91bcaf7db7d174ee2966d9c293fd575	0	9.80	2	\N
7dc88a28ee5d7dbd7a1011fd098cd6ab	Way of Darkness 2019	2019-10-04	a04166db1f1c6d75ab79b04756750bf5	1	62.00	2	\N
2917a0b7da3498cad2a82a57e509346e	Downfall of Mankind Tour 2019	2019-05-07	5208c9de2f1b498a350984d55bcbc314	0	18.0	2	\N
1e33e72fc8ecaa5f931f8f9cda7a38ed	Live on Stage - 22.10.2022	2022-10-22	17648f3308a5acb119d9aee1b5eafceb	0	14	2	\N
b66b04a94d60074d595fd3acfeb73973	Live on Stage - 09.03.2024	2024-03-09	17648f3308a5acb119d9aee1b5eafceb	0	14.0	2	\N
2baafaeeb079bb06df7cc0531aa81ccb	Live on Stage - 06.05.2023	2023-05-06	17648f3308a5acb119d9aee1b5eafceb	0	11.00	2	\N
2ac99a5ffc2764063bc246f9fa174a71	Grill' Em All 2017	2017-09-23	3a98149817a5aafba14c1b822db056fa	0	0.00	2	\N
fe36a187902de9cf1aa5f42477fa1318	Grill' Em All 2022	2022-07-02	3a98149817a5aafba14c1b822db056fa	0	0.00	2	\N
fb57c18df776961bb734a1fa3db6a6d1	Taunus Metal Festival XIV	2024-04-05	990c04bd6b40c3ca7352a838e2208dac	0	30.00	2	\N
9946f5f348ac677113592c05b1b3905b	Taunus Metal Festival XI	2019-04-12	990c04bd6b40c3ca7352a838e2208dac	1	25.00	2	\N
486bf23406dec9844b97f966f4636c9b	In Flames	2017-03-24	f7f2bc012754bd5d77de32e5c2674553	0	57.45	2	\N
c0f93075617b7dd9db214f46876fb39d	Knife, Exorcised Gods, World of Tomorrow, When Plages Collide	2018-09-15	6e763e01d71c71e3b53502c35bfbb98c	0	7.60	2	\N
e669a39d1453acd6aefc84913a985f51	Matapaloz Festival 2017	2017-06-16	0dbca791a775eab280cc7766794627cb	1	170.99	2	\N
3e55fe6e09f2f7eaacd4052a76bcfb01	Download Germany	2022-06-24	0dbca791a775eab280cc7766794627cb	0	139.00	2	\N
89733d277fcf6ee00cb571b2e1d72019	Grabbenacht Festival 2018	2018-06-01	010c9e9e86100e63919a6051b399d662	1	23.00	2	\N
b0bc16cc4e9fefb213434d718724ec3a	Grabbenacht Festival 2019	2019-05-30	010c9e9e86100e63919a6051b399d662	1	28.00	2	\N
078ac0cacb2c674f16940ebd9befedd9	Grabbenacht Festival 2024	2024-05-31	010c9e9e86100e63919a6051b399d662	1	49.0	2	\N
791a234c3e78612495c07d7d49defc4c	Profanation over Europe 2024	2024-03-20	588671317bf1864e5a95445ec51aac65	0	29.20	2	\N
79b4deb2eac122cc633196f32cf65670	Where Owls know my name EU|UK Tour 2019	2019-09-22	588671317bf1864e5a95445ec51aac65	0	24.70	2	\N
5fd9b4c8df6e69c50106703b7d050a3d	The modern art of setting ablaze tour	2018-12-08	588671317bf1864e5a95445ec51aac65	0	23.20	2	\N
cb80a6a84ec46f085ea6b2ff30a88d80	Molotov	2016-07-25	588671317bf1864e5a95445ec51aac65	0	24.50	2	\N
921e9baf14e4134100c7b7a475b1bb06	EMP Persistence Tour 2017	2017-01-24	588671317bf1864e5a95445ec51aac65	0	32.30	2	\N
07da0c8ead421197cc73463cf5a5eefc	Death is just the beginning	2018-10-18	588671317bf1864e5a95445ec51aac65	0	32.10	2	\N
133416b949a72009242c85d5af911b93	Kreator, Sepultura, Soilwork, Aborted	2017-02-17	588671317bf1864e5a95445ec51aac65	0	42.00	2	\N
20b32a6bbc813658d242a65c08bc8140	The Popestar Tour 2017	2017-04-09	588671317bf1864e5a95445ec51aac65	0	33.50	2	\N
50e128ce6587bfcaedf317f6deb69695	Before we go Farewell Tour 2016	2016-02-11	588671317bf1864e5a95445ec51aac65	0	17.45	2	\N
c9dc004fc3d039ad7fb49456e5902b01	Conan	2017-03-08	588671317bf1864e5a95445ec51aac65	0	18.00	2	\N
1e144cd25de2ab5d9153d38c674c1f4b	MTV's Headbangers Ball Tour 2018	2018-12-11	588671317bf1864e5a95445ec51aac65	0	39.80	1	\N
f015a601161f02a451557258793a96a1	Skindred, Zebrahead	2016-12-09	588671317bf1864e5a95445ec51aac65	0	25.70	2	\N
3e98ecfa6a4c765c5522f897a4a8de23	Ministry	2018-08-06	588671317bf1864e5a95445ec51aac65	0	35.80	2	\N
e5847f38992d20bb78aafd080c5226d4	Dia de los muertos Roadshow 2016	2016-11-11	588671317bf1864e5a95445ec51aac65	0	14.70	2	\N
2b6e496456bb2be5444c941692fa5d17	Will to power tour 2018	2018-02-06	588671317bf1864e5a95445ec51aac65	0	36.70	2	\N
603ef2d9ef2057c8719d0715a7de32d1	EMP Persistence Tour 2018	2018-01-23	588671317bf1864e5a95445ec51aac65	0	33.40	2	\N
6e18512149a51931a4faa1f51d69a61f	Dia de los muertos Roadshow 2018	2018-11-02	588671317bf1864e5a95445ec51aac65	0	14.5	2	\N
21913ca002c17ce3cf8a0331b2dad1c8	Winter Hostilities 2019-Tour	2019-12-04	588671317bf1864e5a95445ec51aac65	0	23.70	2	\N
e6273b4e07720dbd6ed7870371b86d24	World needs mosh (Wiesbaden)	2021-11-19	588671317bf1864e5a95445ec51aac65	0	14.90	2	\N
cb14876022caa93cf2a4a934fad74fe9	Descend into Madness Tour 2020	2020-03-11	588671317bf1864e5a95445ec51aac65	0	19.20	1	\N
c4c0e84be1600267ea2bd626c25dc626	The Gidim European Tour 2020	2020-03-05	588671317bf1864e5a95445ec51aac65	0	25.90	2	\N
ec29ea3adb2b584841d5d185e5f9135b	European Tour Summer 2019	2019-08-13	588671317bf1864e5a95445ec51aac65	0	23.70	2	\N
9b4752b144d294fc6799532a413fd54e	Aversions Crown | Psycroptic	2019-02-21	588671317bf1864e5a95445ec51aac65	0	23.70	2	\N
d988ef331f5b477753be3bae8b18412f	MTV's Headbangers Ball Tour 2019	2019-12-14	588671317bf1864e5a95445ec51aac65	0	40.75	2	\N
0add3cab2a932f085109a462423c3250	Dust Bolt	2019-03-07	588671317bf1864e5a95445ec51aac65	0	19.30	2	\N
52bb7665f1523ba2bb7481ee085ce6ec	To Drink from the Night Itself, Europe 2019	2019-12-15	588671317bf1864e5a95445ec51aac65	0	38.50	2	\N
cb091aafa00685c4b29954ca13e93bad	EMP Persistence Tour 2019	2019-01-24	588671317bf1864e5a95445ec51aac65	0	33.60	2	\N
b04e875801af3b7b787cde914be2aaed	Deserted Fear / Carnation / Hierophant	2019-03-22	588671317bf1864e5a95445ec51aac65	0	19.30	2	\N
e1e5ca54159d43c9400d33fdff6ac193	Amorphis & Soilwork	2019-02-13	588671317bf1864e5a95445ec51aac65	0	36.90	2	\N
aac480b69f1fe6472ffe7880c8ead350	The Inmost Light Tatoo 2019	2019-02-01	588671317bf1864e5a95445ec51aac65	0	10.0	2	\N
5379b1daf8079521f6c7de205e37f878	Netherheaven Europe 2023	2023-01-19	588671317bf1864e5a95445ec51aac65	0	30.50	2	\N
7b5a790fbc109d0dadb7418b17bf24e8	Post Covid European Summer Madness 2022	2022-07-19	588671317bf1864e5a95445ec51aac65	0	26.00	2	\N
8be553b6dfad10eac5fed512ef6c2c95	Europe 2022	2022-10-30	588671317bf1864e5a95445ec51aac65	0	36.00	2	\N
e692c8859fbcd0611cde731120ba09ad	Necro Sapiens Tour 2022	2022-05-05	588671317bf1864e5a95445ec51aac65	0	19.65	2	\N
eb5b5cec91e306a1428f52f89ef1c2ab	Doomsday Album Release Tour	2022-04-28	588671317bf1864e5a95445ec51aac65	0	23.80	2	\N
9295494c6983f977a609c9db84ce25e6	Sepultura - Quadra Tour Europe 2022	2022-11-21	588671317bf1864e5a95445ec51aac65	0	37.80	2	\N
6c6621659485878b572ac37db7d14947	Dia de los muertos Roadshow 2015	2015-11-27	588671317bf1864e5a95445ec51aac65	0	12.25	2	\N
1bbb8052b10792e8a86d64245d543d7a	Activate Europe 2022	2022-10-09	588671317bf1864e5a95445ec51aac65	0	23	2	\N
90710b6a9bf6fbbdea99a274ca058668	40 Years of Destruction Europe Tour 2023	2023-10-27	588671317bf1864e5a95445ec51aac65	0	40.30	2	\N
88ad18798356c6caa8fe161432d88920	Ton Steine Scherben - 2015	2015-10-01	588671317bf1864e5a95445ec51aac65	0	25	2	\N
40512bf59a621ffaaea463f137f395ec	Crossplane & Hängerbänd	2021-08-06	99b522e44d05813118dcf562022b4a2a	0	18.60	2	\N
3479db140a88fa19295f4346b1d84380	15 Years New Evil Music, Festival	2019-10-12	49d6cee27482319877690f7d0409abbd	0	44.0	2	\N
65302b172b9b95b0f8f692caef2e19e8	X-Mass in Hell Festival West Edition 2018	2018-12-15	49d6cee27482319877690f7d0409abbd	0	39	2	\N
f4e988e1e599ea5ff2d9519e59511757	Sons of Rebellion Tour 2019	2019-11-01	49d6cee27482319877690f7d0409abbd	0	26.40	2	\N
e6513a2614231773cfe00d0bb6178806	Prayer Of Annihilation Tour 2019	2019-10-24	49d6cee27482319877690f7d0409abbd	0	23.10	2	\N
aeead547d2a5b453d09a3efdf052c4cf	Easter Mosh	2023-04-12	49d6cee27482319877690f7d0409abbd	0	28.60	2	\N
6fa3e357c27d47966023568346d51a09	Metallergrillen 2017	2017-09-01	3264a9d4fedca758f18391ecca28f0e5	1	33.0	2	\N
91e2010dfd20c93ee84ffd12694b0f24	A Tribute to ACDC 2020	2020-03-07	539960fca282c1966cfa15e15aca1d84	0	15.00	1	\N
f64440cda54890f13a4506f88aa21cd2	Rockharz Open Air 2019	2019-07-03	ed2c8a76cc01eeb645011e8154737a49	2	112.75	2	\N
87ba4cfe4768f0efa1a69dacb770810c	Rockfield Open Air 2017	2017-08-18	d5a4559236ce011e72312e02aafc05d0	2	0.00	2	\N
208af572d4212c8b20492f11ca9b8b54	Rockfield Open Air 2019	2019-08-09	d5a4559236ce011e72312e02aafc05d0	2	0.00	2	\N
0704b2bfdcfaed5225554f023a7fbf48	Rockfield Open Air 2022	2022-08-13	d5a4559236ce011e72312e02aafc05d0	2	0.00	2	\N
169be8981eff6a53b1bcae79e2f06a05	Rockfield Open Air 2023	2023-08-11	d5a4559236ce011e72312e02aafc05d0	2	0.00	2	\N
8a48b001d26cf3023ac469d68bfba185	NOAF XIII	2017-08-25	6c33b0a7db1a4982d74edfe98239cec5	1	38.00	2	\N
9bbe76536451d9ad44018b24d51c58aa	Rockbahnhof 2019	2019-05-18	6c33b0a7db1a4982d74edfe98239cec5	0	0	2	\N
1edc35fdd229698b0eeaaa43e7a9c7c5	NOAF XII	2016-08-26	6c33b0a7db1a4982d74edfe98239cec5	1	35.00	2	\N
b3622323dbe3bef2319de978869871ad	NOAF XIV	2018-08-24	6c33b0a7db1a4982d74edfe98239cec5	1	42.00	2	\N
cfd1317abaf4002e4a091746008541cc	NOAF XV	2019-08-23	6c33b0a7db1a4982d74edfe98239cec5	1	42.0	2	\N
3e8d7d577a332fc33e2f332ad7311e1e	Worldwired Tour 2019	2019-08-25	f17fc1362e3637ae8ede170a2a5d6bea	0	98.65	2	\N
be5ea4556ea2b3db3607b8e2887c9dd3	Metal Club Odinwald meets Ultimate Ruination Tour	2019-04-27	29935ed69008b59e8758afcf7eeb7d7b	0	9.00	2	\N
90445b62432a3d8e1f7b3640029e6fed	Worldwired Tour 2018	2018-02-16	840b0d06d6be5d714e2228a4be26cbcc	0	115.15	2	\N
87c20c746bae110cc55c3d32414037df	Friendship & Love Metal Fest	2020-02-15	406b32caecad16e87606fa84a77f4e35	0	3.00	2	\N
c4968fa5ec8f129c7fd49ffa5cb64d6e	Jubiläumswoche 25 Jahre Hexenhaus	2021-07-31	d61cb6460de2df9d1d64dc35cb293f6a	0	41.90	2	\N
a3c7a40013e778dc1ce7d4ae7cdcfa6d	Super Sweet 16 (Edition 36)	2024-04-20	6c55ed753e5b2355307bf2b494f2384a	0	0	2	\N
75560c8161a6cccdfbd7a8b59332b792	Alexander the Great in Exil	2021-09-11	6c55ed753e5b2355307bf2b494f2384a	0	11	2	\N
d283cb5c455d03f1f4f0ff7f82c93af6	50 Jahre Doktor Holzbein	2022-04-23	6c55ed753e5b2355307bf2b494f2384a	0	0	2	\N
ec83b315e34cecd0b3e8323e22ee38bf	Bands am Montag - 12.2023	2023-12-18	6c55ed753e5b2355307bf2b494f2384a	0	0.0	2	\N
8287859246dae330eef7b3a2a8c71390	Warfield/Torment of Souls/Redgrin	2021-10-02	44ab9f5977e8956f9dd15003efc8743b	0	10.00	2	\N
943f6abbf24d69a145fbac5cc30c1a5c	World needs mosh (Bonn)	2021-11-21	eb83e6da9292e995b44f789c42bb7e65	0	14.90	2	\N
220352d001b221b28a0dff0fbd20f77c	Slaughterra - Darmstadt	2022-03-05	6ddb911ae1e79899c2d90067b761d6b4	0	15	2	\N
e87aa14aa70c2745548e891915c77ab4	Dark Zodiak + Mortal Peril	2021-11-27	6ddb911ae1e79899c2d90067b761d6b4	0	15	2	\N
94154f6cf17963a299f6902ae9c7f3d5	Braincrusher in Hell 2020	2022-05-20	ca7fb13a9cd0887dfabbb573c070fb2e	1	70.40	2	\N
a17fea2a7b6cf4685417132ff574fd0a	Wacken Open Air 2022	2022-08-03	481c1aef68fb3531c92c85ccf1e8643d	3	238.00	2	\N
ef925858ea6d5d91b5ca4b3440fa1ad1	Death Feast Open Air 2022	2022-08-25	6a21939c14c8f6030de787b05d66c3ef	2	66.50	2	\N
e184d243eb553fcba592ae848963c1e8	Death Feast Open Air 2023	2023-08-24	6a21939c14c8f6030de787b05d66c3ef	2	85.50	2	\N
10c5ac379805443742025d6cf619891e	Infernum meets Porkcore Festevil 2022	2022-09-02	4806febaa9c494fdd030ee4163e33c8c	1	67.35	2	\N
a420ecf82bd099f63cf26c8cbc4cdf05	Horrible Death Tour 2023	2023-09-29	0280c9c3b98763f5a8d2ce7e97ce1b05	0	13.00	2	\N
e2a3e66f68255ed0b2a09a64a8ae55fd	Randy Hansen live in Frankfurt	2016-04-26	83b0fe992121ae7d39f6bcc58a48160c	0	22.00	2	\N
e6adc3e990efe83510bc9e7a483bec1a	Vikings and Lionhearts Tour 2022	2022-09-28	50eb9f93583f844e0684af399dc7fc3c	0	74.70	2	\N
b66fc7effb62197b91e1dacbd7b60f0f	Servant of the Road World Tour	2022-11-29	50eb9f93583f844e0684af399dc7fc3c	0	86.20	2	\N
a565f20390f97f9d86df144e14fe83af	We Are Not Your Kind World Tour	2020-01-29	50eb9f93583f844e0684af399dc7fc3c	0	80.40	2	\N
e58b815b0e0ab96b035629ec796eb579	Berserker World Tour 2019	2019-12-03	400c46fc5f22decc791a97c27363df40	0	53.95	2	\N
1f711336d1c518a68db9e2b4dd631e81	Back to the Roots Tour - 05.2024	2024-05-17	09ddc8804dd5908fef3c8c0c474ad238	0	23.20	2	\N
b098c76b1d5ba70577a0c0ba30d2170a	Fleshcrawl + Fleshsphere + Torment of Souls	2024-05-18	09ddc8804dd5908fef3c8c0c474ad238	0	28.70	2	\N
5e38483d273e5a8b6f777f8017bedf62	BLUTFEST 2022	2022-10-01	09ddc8804dd5908fef3c8c0c474ad238	0	23.2	2	\N
85935a51fb2aec086917a4eeeaef066b	Gorecrusher European Tour 2022	2022-11-19	09ddc8804dd5908fef3c8c0c474ad238	0	25.2	2	\N
69882c9d3cc383cd271732b068979a98	A Goat Vomit Summer	2023-07-25	09ddc8804dd5908fef3c8c0c474ad238	0	23.20	2	\N
39603f44a0fea370f2f6ced327e9b38b	40 Years of the Apocalypse Anniversary Tour 2023	2023-09-26	09ddc8804dd5908fef3c8c0c474ad238	0	32.90	2	\N
f7995b1a1bf9683848dd37ab294cfa3f	European Fall 2023 Tour	2023-11-19	09ddc8804dd5908fef3c8c0c474ad238	0	37.30	2	\N
26c07de9d3c6e80d7fdaefec9a7dcdc5	50 Jahre Geisler of Hell Festival	2024-01-12	09ddc8804dd5908fef3c8c0c474ad238	0	28.70	2	\N
57c286b274d23dc513ddfd16dd21281e	Laud as Fuck Fest	2022-11-04	9f629f2265000ff7abf380b363b2de49	0	21.69	2	\N
edccf96997e63c09109beba94633a44c	REVEL IN FLESH support: TORMENT OF SOULS	2022-11-18	9f629f2265000ff7abf380b363b2de49	0	18.02	2	\N
bc1f2650c6129b22a2cc63f2a90b5597	Black Thunder Tour	2022-11-24	69e2a1bbdd4b334d3da05ae012836b18	0	36.85	2	\N
183863a44c8750e908c83bd2d1c194f8	Slice Me Nice 2022	2022-12-03	69bdcf616a03acef49e3697d73adcbb3	0	37.22	2	\N
dc19b6ddc47a55bc9401384b0ff66260	29. Wave-Gotik-Treffen	2022-06-05	efeaa516107a31ce2d1217e055b767f7	1	130.00	2	\N
55446132347a3c2e38997d77b7641eff	28. Wave-Gotik-Treffen	2019-06-08	efeaa516107a31ce2d1217e055b767f7	1	130.00	2	\N
33314b620ad609dc87d035654068d01e	30. Wave-Gotik-Treffen	2023-05-26	efeaa516107a31ce2d1217e055b767f7	3	170.00	2	\N
57a334acb665ebc52057791d107149f4	57. Wernigeröder Rathausfest	2023-06-16	a7f15733dd688dee75571597f8636ba7	1	0	2	\N
86615675838b48d2003175dd7665fba3	Rumble of thunder	2023-06-27	779076573cef469faf694cd40d92f40a	0	38.85	2	\N
99e73f7baf95258d1a2f27df6c67294f	Thrash Metal Fest - 05.2024	2024-05-16	f3a90318abb3e16166d96055fd6f9096	0	30.0	2	\N
7459412d1907ec1a87e7a5246b27cd00	Wild Boar Wars III	2021-08-28	83b0fe992121ae7d39f6bcc58a48160c	1	30.00	2	\N
f56f7353a648997c6f5bc4a952cd1bd2	EMP Persistence Tour 2016	2016-01-22	588671317bf1864e5a95445ec51aac65	0	31.20	2	\N
08a5c6dec5d631fe995935fd38f389be	"The Tide of Death and fractured Dreams" European Tour 2024	2024-05-15	588671317bf1864e5a95445ec51aac65	0	36.0	2	\N
8ad5ac467b3776d28a12742decf00657	Rockfield Open Air 2018	2018-08-17	d5a4559236ce011e72312e02aafc05d0	2	0.00	2	\N
75fea12b82439420d1f400a4fcf3386b	Völkerball	2016-05-05	15f10194f67b967b0f0b5a22561a7c95	0	23.50	2	\N
70ba638a78552630591ba5c7ff92b93a	Sepultura - Quadra Summer Tour - Europe 2022	2022-07-05	968e5509ddd33538eec4fff752bda4ff	0	37.31	2	\N
69d2999875a1e6d7c09bbf157d18a27e	Summer in the City 2023	2023-06-30	692fc1deabc4b9afa9387af15c02b19a	0	0.00	2	\N
42a2eedac863bd01b14540a71331ec65	Summer in the City 2018	2018-07-08	692fc1deabc4b9afa9387af15c02b19a	0	0.00	2	\N
c724b600052083fae4765a6a7702ee5f	In Flammen Open Air 2023	2023-07-13	cb6036cdf8009fc4b41eb0e56eab553d	2	86.90	2	\N
b39ff9f6960957839c401d45abdc3cae	Boarstream Open Air 2023	2023-07-21	cf1c12d42f59db3667fc162556aab169	1	66.60	2	\N
6439e93ac57a8784706d3155d0fe651f	Dortmund Deathfest 2023	2023-08-04	85683aa688e302e1de7ec78dc4440dff	1	79	2	\N
4ba1c22d76444426b678b142977aa084	Breakdown4Tolerance Vol.1 Festival	2023-09-30	10effefa9cc583f38ff0518dcaa72ef5	0	25.00	2	\N
db92681077141614e2ee9a01df968334	Death and Gore over Frankfurt	2023-10-28	fc36c84b02e473bec246e5d2cfc513ef	0	9.00	2	\N
f5cd4263f2cbb5e459306b35cef72e9d	European Miserere 2023	2023-07-03	5948b7ac21c1697473de19197df1f172	0	15.00	2	\N
8de89ad5eef951fd87bd3e013c63a6c4	Slaugther Feast 2023	2023-11-10	6032938ceb573d952fdae1a40ef39837	1	29.00	2	\N
d1b30328ab686d050b6c107154d6aef8	Paganische Nacht - 2023	2023-11-24	b13f71a1a5f7e89c2603d5241c2aca25	0	29.00	2	\N
4e22c7f7fe57d94f85bf89a469627ba1	Hell over Aschaffenburg - 2023	2023-11-25	b13f71a1a5f7e89c2603d5241c2aca25	0	35.00	2	\N
9d0ac9b8cb657a5f09f81d6bea3e1798	Slice Me Nice 2023	2023-12-02	817974aa11f84c9ebc640d3de92737f5	0	33.91	2	\N
efdb143af86d5a0af148b7847e721e55	15 Jahre live im GMZ Georg-Buch-Haus Wiesbaden	2014-10-04	738af31c1a528baa30e7df31384e550b	0	9.00	2	\N
e26bcb0f8a28cd2229ce77a95d0baf9e	Eskalation im Oberhaus 2024	2024-02-03	b00bae5a5f8ff8830d486747e78d7d8d	0	22.00	2	\N
dcad795c824cf4d6337fc9f745e5645f	The young meatal attack	2024-03-02	9ca0396f7fce5729940fcef7383728b3	0	12.00	2	\N
e4ee5ac5d137718d0eeb4d310b97d837	Noche de los Muertos - 2017	2017-10-31	f0f0e638999829b846be6e20b5591898	0	15	2	\N
16a83f971efce095272378a2a594e49f	Open air Hamm 47.	2017-07-07	7590124802ade834dbe9e7c0d2c1a897	1	25	2	\N
0a7d68cf2a103e1c99f7e6d04f1940da	Necromanteum EU/UK Tour 2024	2024-03-30	051fa36efd99a2ae24d56b198e7b1992	0	43.55	2	\N
2d5e1a99b20d1be28ef40573c37eb0a0	Thrash Attack - 06.04.2024	2024-04-06	5515ceaeca4b8b62ee5275de54ea77ad	0	16.52	2	\N
2c6ed5b74b30541da64fdbbda4a8bbe3	Agrypnie 20 Jahre Jubiläums Set & Horresque Album Release Show	2024-04-12	cccce7f0011bc27dee7c60945cd5f962	0	22.0	2	\N
71de5246c2f4ac4766041831e93f001a	New live rituals a COVID proof celebration of audial darkness	2021-07-23	e248bb7c1164a44fa358593e28769a23	0	23.20	2	\N
57e44259dc61f23bef42517695d645f1	Ravaging Europe 2023	2023-03-29	e248bb7c1164a44fa358593e28769a23	0	28.70	2	\N
e723d4328c7df53576419235b92f4a13	Heretic Hordes I	2024-05-03	e248bb7c1164a44fa358593e28769a23	0	35.00	2	\N
3fe511194113f53322ccac8a75e6b4ab	Gutcity Deathfest 2024	2024-05-11	2dd00779b7dd00b6cbbc574779ba1f40	0	30.60	2	\N
1fef5be89b79c6e282d1af946a3bd662	Mahlstrom Open Air 2024	2024-06-14	b77734e4928596fac1db05cab7b39710	1	78.99	2	\N
b8f41d89b2d67b4b86379d236b2492aa	Europe Summer 2024	2024-06-17	588671317bf1864e5a95445ec51aac65	0	29.30	2	\N
f8aec5c8465f9b8649a99873c0a44443	Asinhell Live 2024	2024-06-19	62a758afc72d2e3f7933fa4b917944c8	0	33.45	2	\N
ddf663d64f6daaeb9c8eb11fe3396ffb	Boarstream Open Air 2024	2024-06-21	cf1c12d42f59db3667fc162556aab169	1	75.00	2	\N
a685e40a5c47edcf3a7c9c9f38155fc8	Throw them in the Van European Summer Tour 2024	2024-06-27	f3a90318abb3e16166d96055fd6f9096	0	34	2	\N
f4ab1c6777711952be2adceed22d7fc5	The Exloited - Das Bett - 2024	2024-06-29	83b0fe992121ae7d39f6bcc58a48160c	0	0	2	\N
9fe5ff8e93ce19ca4b27d5267ad7bfb3	In Flammen Open Air 2024	2024-07-11	cb6036cdf8009fc4b41eb0e56eab553d	2	86.9	2	\N
31702e4b76bb69f9630a227d403c4ca0	Hellripper + Cloak + Sarcator	2024-07-26	67bac16ced3de0e99516cf21505718a1	0	24.80	2	\N
abe69e5488f1be295baa8bbf1995c657	Deicide - European Tour 2024	2024-07-29	e248bb7c1164a44fa358593e28769a23	0	34.20	2	\N
d5bd359a19abc00f202bb19255675651	Party San Open Air 2024	2024-08-08	b27e07993299ee0b2ecd26dabd77eaf8	2	0.0	2	\N
2c5cad7b6d76825edcfbd5d077e7a5ee	Death Feast Open Air 2024	2024-08-22	6a21939c14c8f6030de787b05d66c3ef	2	82.5	2	\N
01e90040938d8415a8b98f0d80fceb06	Tattoo Titans in Hamburg 2024	2024-08-31	625d260d98326f7dfffd0dd49ebbfc8e	1	110.0	2	\N
332be9c531b1ec341c13e5a676962820	Rock for Hille Benefiz	2018-10-27	6dde0719f779b373e62a7283e717d384	0	25.00	2	\N
b3d8150933aa73cc2b3ba1fc39b1651c	Vader - 40 Years of the Apocalypse Tour 2024	2024-06-28	49d6cee27482319877690f7d0409abbd	0	28.60	2	\N
f7787eb77e709474505db860a00edd2d	Asomvel, Warfield	2024-07-18	f3a90318abb3e16166d96055fd6f9096	0	0.0	2	\N
a20ba10650527a8e646bd528e4f2428e	Kreator + Havok + Crisix	2024-08-17	968e5509ddd33538eec4fff752bda4ff	0	50.55	2	\N
05ffebda2d583b6081ffaa8dd7ba0788	Metal Embrace Festival XVI	2024-09-06	05be609ce9831967baa4f12664dc4d73	1	55.5	2	\N
c0e1ed6923fbe4194174ad87f11179cd	Open Stage - 23.05.2024	2024-05-23	17648f3308a5acb119d9aee1b5eafceb	0	15.0	2	\N
83bd23b786ae4d9b16f52ed2661611e9	Motörblast Play Motörhead - 2023	2023-12-27	eca8fc96e027328005753be360587de2	0	18.60	2	\N
d84c3f96813116b09480c0572fa45636	Motörblast Play Motörhead - 2018	2018-12-27	eca8fc96e027328005753be360587de2	0	16.40	2	\N
b4435108ce3cef02600464daf3cb5f7f	Metal Embrace Festival XV	2023-09-08	05be609ce9831967baa4f12664dc4d73	1	48.50	2	\N
de9415f38659fd6225ddf8734a7b0ff7	Swords into Flesh Europe Tour 2023	2023-11-07	f3a90318abb3e16166d96055fd6f9096	0	27.50	2	\N
be31669251922949ee5efe5447a119d1	Latin American Massacre	2023-10-20	a91bcaf7db7d174ee2966d9c293fd575	0	9.60	2	\N
cac02becf783662df9a61439ed515d75	The Path of Death 10	2023-10-14	a91bcaf7db7d174ee2966d9c293fd575	0	39.00	2	\N
f0c7879002501eddcb68564fe19b77fc	Metal im M8 - 12.2023	2023-12-09	a91bcaf7db7d174ee2966d9c293fd575	0	8.00	2	\N
dabaf9fe7459d022af9bf8afc729631a	Hutkonzert - 01.08.2024	2024-08-01	17648f3308a5acb119d9aee1b5eafceb	0	7.5	2	\N
fa92cfeec372b54d5551e5fb9aaa55af	Hutkonzert - 29.08.2024	2024-08-29	17648f3308a5acb119d9aee1b5eafceb	0	10.0	2	\N
f6fbabd4858c55fea0dce0d32db9dcf5	Hutkonzert - 19.10.2023	2023-10-19	17648f3308a5acb119d9aee1b5eafceb	0	10.0	2	\N
ce017dda4d3b82cf8e75f648a7b9b390	Open air Hamm 43.	2013-06-14	7590124802ade834dbe9e7c0d2c1a897	1	22.0	2	\N
000869859299617fd93133d3f65fd85b	Open air Hamm 45.	2015-06-12	7590124802ade834dbe9e7c0d2c1a897	1	22.0	2	\N
c4e2844bff82087c924ad104bdfb6580	Exorcised Gods/Harvest their Bodies/Call of Charon/Trennjaeger	2019-11-15	a91bcaf7db7d174ee2966d9c293fd575	0	9	2	\N
cf1c6716920400a1d8ade1584c726f0c	Morbide Klänge III	2024-05-24	a91bcaf7db7d174ee2966d9c293fd575	0	15.0	2	\N
a1127140db632705cffe06456b478fa8	Evil Obsession 2023	2023-12-28	c72b4173a6a7131bf31a711212305fd3	0	48.50	2	\N
c4133d7e05b0f42aedd762785de80b70	Dread Reaver Europe 2024	2024-01-20	c72b4173a6a7131bf31a711212305fd3	0	39.50	2	\N
586a67dc71b225f23047ff369fce7451	Hell over Aschaffenburg - 2019	2019-11-30	b10506e85b6bf48eace09359fb36d5e0	0	30.00	2	\N
95e6dc1125e477e58c9f5bdb1bdd53ac	Grabbenacht Festival 2023	2023-06-09	010c9e9e86100e63919a6051b399d662	1	45.00	2	\N
20a697b57317f75ad33eb50f166d6b00	NOAF XI	2015-08-28	6c33b0a7db1a4982d74edfe98239cec5	1	15.0	2	\N
c6b227c4855621d0654142f2a3cad0ee	Hessian Underground Brutality 2024	2024-09-14	c792b3f05ce40f0ff54fcf79573c89b4	0	15.0	2	\N
099346085ef9364171db5f639475194e	Underworld Europe Tour 2024	2024-09-15	49d6cee27482319877690f7d0409abbd	0	34.0	2	\N
5d7e58efe4f97f6abc7174574843abbc	In Chambers of Europe 2024	2024-09-20	f3a90318abb3e16166d96055fd6f9096	0	26.0	2	\N
99467125829a5b728cfe913f88f19db8	20 Years New Evil Music Festival	2024-09-28	c72b4173a6a7131bf31a711212305fd3	0	66.60	2	\N
8e625852da508feb3e973eedd98b3a6e	A Heaven you may create. European Tour 2024 - Part 1	2024-09-29	f3a90318abb3e16166d96055fd6f9096	0	30.80	2	\N
e6af11cd729e7b81d4f40453fff9c7f2	Halloween mit Hängerbänd und Hellbent on Rocking	2023-10-31	17648f3308a5acb119d9aee1b5eafceb	0	11.00	2	\N
ebaeb9fa7d6d4de00d7573942a9f9e78	Brutality Unleashed Tour 2022	2022-09-05	0280c9c3b98763f5a8d2ce7e97ce1b05	0	15.00	2	\N
22be8d2b712105db37cc765fae61323e	"Morbid Devastation"-Tour	2023-11-17	588671317bf1864e5a95445ec51aac65	0	39.80	2	\N
94c9c5cc90aa696fcef2944a63f182e9	European Tour 2024	2024-10-01	c72b4173a6a7131bf31a711212305fd3	0	48.95	2	\N
a601420442e567507a31586d3508e901	Black Hole Fest Germania II	2024-10-04	4dac5916befa9f4e29989cd5f717beb4	1	148.12	2	\N
e2cc1ec7e3f092bf9acff95c49b4601f	Apocalyptica Plays Metallica Vol. 2 Tour 2024	2024-10-07	588671317bf1864e5a95445ec51aac65	0	55.40	2	\N
f91e581750aef0db0551fafb15367bd9	Rising from the North Tour 2024	2024-10-09	c8f566954fe846be7d35f707901d7bf5	0	69.0	1	\N
0b050e993c77bc785f1a5ee9dd0c0cca	Milking the Goatmachine + Craving + Call of the Void	2024-10-12	9891ba35bb7474ae750bdbf62a4eee4f	0	25.73	1	\N
aa32f037a3d1ff9264faa5c3f0f65079	Feed the Goat Tour 2024	2024-10-25	b9a697f7f6fe15cad76add1dd64b688f	0	20.0	2	\N
0b3f22fe9047dc47a984a062c17d5777	The Blackest Path II	2024-10-26	a91bcaf7db7d174ee2966d9c293fd575	0	35.0	2	\N
f311f7681e474c2937481923ae6a0445	Modern primitive Tour 2024	2024-10-29	c72b4173a6a7131bf31a711212305fd3	0	31.50	2	\N
701771f4cfec0fee38bf370d6af6f8cc	40 Years Farewell Tour	2024-10-31	76f9a958c2ebbd2f42456523d749fb5e	0	58.45	2	\N
ec1c30e91a0ca3f4d0a786488e6ad70f	Unleash the Gr*n Tour 2024	2024-11-01	09ddc8804dd5908fef3c8c0c474ad238	0	33.10	2	\N
43a5261d50cad6c92b073e23d789dc68	Last Blast - 02.11.24	2024-11-02	a91bcaf7db7d174ee2966d9c293fd575	0	9.0	2	\N
98fbe07eebe68a529f12602e94d37b62	Dark Superstition European Tour 2024	2024-11-04	588671317bf1864e5a95445ec51aac65	0	31.50	2	\N
9317da510080ab43b1cf8e89f890554b	Burning Burrito Fest Vol.8 - The Burn is Real	2024-11-09	fa5218c9167a20e6b9f6bf2a139433ce	0	22.0	2	\N
7bf774533c7117c4e139f1cb58cbedbe	The Imperium Tour	2024-11-16	d90ac22c4f2291b68cb07746d0472dbf	0	0.0	2	\N
5a1a238b946013e16ff5db077b9f5ae6	Beast agaist Beast European Tour 2024	2024-11-22	09ddc8804dd5908fef3c8c0c474ad238	0	30.9	2	\N
f9b4f5ba6cb5f7721ce1e55d68a918b8	Hell over Aschaffenburg - 2024	2024-11-23	b13f71a1a5f7e89c2603d5241c2aca25	0	32.5	2	\N
95fea685e14cf598f5a22e82371ebaac	European Tour Fall 2024	2024-11-25	051fa36efd99a2ae24d56b198e7b1992	0	40.70	2	\N
9cfee73dcb4ebeba48366c0fd1d4fe3a	Metal Mainz III	2024-12-20	a91bcaf7db7d174ee2966d9c293fd575	0	11.0	2	\N
aa8eed75496c33d578cfad09e49bc803	Krøterverg til Europa 2024	2025-02-27	588671317bf1864e5a95445ec51aac65	0	42.1	2	\N
48b3e4e082a150ee45ac1229b6c556bc	Live on Stage - 23.03.2024	2024-03-23	17648f3308a5acb119d9aee1b5eafceb	0	15	2	\N
a53dce25b80bd1caf2f1aa7ea602ed63	Live on Stage - 16.09.2023	2023-09-16	17648f3308a5acb119d9aee1b5eafceb	0	14	2	\N
ca3f4984b3956024054e62665febcc6a	Live on Stage - 21.12.2024	2024-12-21	17648f3308a5acb119d9aee1b5eafceb	0	12.0	2	\N
85da33004945be2270c841e38d7d7be4	The Ides of March	2025-03-07	a91bcaf7db7d174ee2966d9c293fd575	0	12.0	2	\N
c65ee59c92bf87259bb6081ac1066701	Rocken im Winter Festival 2024	2024-12-28	2dd00779b7dd00b6cbbc574779ba1f40	0	23.20	2	\N
2b23c45d7b18dfccde35439462716807	Hier ist kein Licht Tour	2025-01-11	a91bcaf7db7d174ee2966d9c293fd575	0	14.45	2	\N
27eb08ae0128e38418359de5030cba15	Asagraum & Helleruin	2025-01-17	09ddc8804dd5908fef3c8c0c474ad238	0	28.50	2	\N
dc3e783425dbba6bb13a0b09e3d8a473	Pagan Metal Matinee	2025-01-19	f3a90318abb3e16166d96055fd6f9096	0	16.5	2	\N
33fc414b35e2153721f8e19b5b2aa1eb	Die letzte Open Stage im ATG	2025-01-18	17648f3308a5acb119d9aee1b5eafceb	0	0.0	2	\N
50870ec5cfc0a18f40002a123c288af6	The Terrasitic Reconquest Tour 2025	2025-01-26	588671317bf1864e5a95445ec51aac65	0	42.0	2	\N
f869730b71701b478d8d44e485d96b96	Exhume the Metal Festival VIII	2025-01-31	4e1c34ddafa9b33187fb34b43ceb2010	1	30.0	2	\N
87e221b0a60c5938389dcc7d10b93bdb	Contest 2025	2025-02-07	9c26f60f17bb584dff3b85695fd2b284	0	5.0	2	\N
011099caab06f3d2db53743ae5957c7a	Texas Cornflake Massacre + Magefa + Gefrierbrand + Crossbreaker	2025-02-15	5948b7ac21c1697473de19197df1f172	0	16.0	2	\N
792b6818a251bf73eba4fa85d61ede60	XIV Dark Centuries + Blood Fire Death + Apostasie + Kryss	2025-03-08	09ddc8804dd5908fef3c8c0c474ad238	0	28.70	2	\N
ca5f18706516d234e9451661a60dfc42	Motörhead Tribute Night - ATG Mainz	2024-12-27	17648f3308a5acb119d9aee1b5eafceb	0	3.0	2	DJ Serkan
ae82bb9482568660cddc425beb03eff5	The Art of Destruction	2025-03-12	de64de56f43ca599fc450a9e0dc4ff25	0	14.3	2	Kinoabend - Destruction Film
72281605945dfd768083800bc06c5946	Heidelberg Deathfest VIII	2025-03-15	c72b4173a6a7131bf31a711212305fd3	0	63.0	2	\N
c6a597721969cadfa790ad9ad3ed0864	All its Grace + Desdemonia + Failed Star	2025-03-14	a91bcaf7db7d174ee2966d9c293fd575	0	14.0	2	\N
3aef806ce4cb250c0043ec647bcf564f	Pinch Black + Greh	2025-03-22	0280c9c3b98763f5a8d2ce7e97ce1b05	0	16.32	2	\N
d869f28f4e7a04e5f9254884229d8321	WARFIELD "With The Old Breed" Album-Release-Show	2025-03-28	09ddc8804dd5908fef3c8c0c474ad238	0	20.8	2	\N
0d833b14e1535c06601ef6a143deec65	Pälzer Hell Version 6.66	2025-04-12	b5c6ef76dd3784cc976d507c890973c3	0	40.0	2	\N
a8a45074ca24548875765e3388541cb5	The Unholy Trinity Tour 2025	2025-04-16	588671317bf1864e5a95445ec51aac65	0	66.6	2	\N
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.genres (id_genre, genre) FROM stdin;
8bb92c3b9b1b949524aac3b578a052b6	Deathcore
a88070859e86a8fb44267f7c6d91d381	Speed Metal
be2f0af59429129793d751e4316ec81c	Power Metal
f3dcdca4cd0c83a5e855c5434ce98673	Hardcore Punk
fe81a4f28e6bd176efc8184d58544e66	Hardcore
5446a9fcc158ea011aeb9892ba2dfb15	Sludge Metal
c7fb67368c25c29b9c10ca91b2d97488	Crossover
0c5544f60e058b8cbf571044aaa6115f	Technical Death Metal
917d78ef1f9ba5451bcd9735606e9215	Alternative Metal
8f8351209253e5c5d8ff147b02d3b117	Nu Metal
9a1f30943126974075dbd4d13c8018ac	Rock
86094b61cb9f63b77f982ceae03e95f0	Metal
d9df3b71eebfa8e6aaf5c72ee758a14d	Alternative Rock
594dec72ea580a8565277a387893e992	Slamming Brutal Death Metal
f54c3ccedc098d37a4e7f7a455f5731e	Folk Metal
5c63347e836e5543344d9e366e3efff8	Post-Hardcore
73d0749820562452b33d4e0f4891efcd	Gothic Metal
bd1340d19723308d52dcf7c3a6b1ea87	Progressive Metal
ae85ec0052dafef13ff2f2cbcb540b53	Goregrind
8a743590316d1519ab5ecc8d142415a2	Post-Metal
a2e63ee01401aaeca78be023dfbb8c59	Oi!
c875de527ea22b45018e7468fb0ef4a5	Punk Rock
abcd9ee1861e1b9a2a5d4d187cf3708e	Industrial Metal
f72e9105795af04cd4da64414d9968ad	Punk
7382b86831977a414e676d2b29c73788	Gothic Rock
5739305712ce3c5e565bc2da4cd389f4	Viking Metal
19e9429d9a22a95b78047320098cbf5b	Progressive Rock
4396490d79c407ec3313bc29ede9f7c8	Melodic Heavy Metal
4607ea6bfb05f395d12f6959cf48aaca	Psychedelic Rock
88ff69ec6aa54fb228d85b92f3b12945	Stoner Rock
93cf908c24c1663d03d67facc359acc2	Symphonic Death Metal
5148c20f58db929fe77e3cb0611dc1c4	Symphonic Black Metal
3e29d9d93ad04d5bc71d4cdc5a8ad820	Rock'n'Roll
a94bc9e378c8007c95406059d09bb4f3	Post-Black Metal
eacaec4715e2e6194f0b148b2c4edd02	Heavy Hardcore
1545b040d61dc2d236ca4dea7e2cff46	Epic Doom Metal
ecf31cb1a268dfd8be55cb3dff9ad09d	Crust Metal
fff66a4d00c8ed7bb7814ff29d0faca2	Ambient
4690ec139849f88f1c10347d0cc7d1b5	Stoner Metal
80a26219c468afbb3a762d5e3cb56f39	Blues Rock
afb45735b54991094a6734f53c375faf	Blackened Death Metal
e9b9ca12c93fad258ac0360aba14c7bc	Melodic Hardcore
53ed714383288793db977e8f7326eb61	Southern Metal
e66156cc95b698d8f4d04ec6dfbb5ab7	Avant-garde Black Metal
3545b02c56a2568e2bff21a5c410374a	Rap Rock
2634ef92ca50d68809edba7cb6052bd2	Pornogrind
f47e2dc1975f8d3fb8639e4dd2fff7c0	Beatdown
a9fa565c9ff23612cb5b522c340b09d1	Melodic Thrash Metal
9de74271aea8fca48a4b30e94e71a6b2	Pop Punk
bcfac7bf0f09d47c614d62c4a88a2771	Space Rock
db4560bb40a4c4309950c9bc94a5880c	Rap Metal
8591e5f94f6bc6bbce534233d5a429b8	Dark Rock
2633fb17d46136a100ff0e04babcf90b	Post-Grunge
dbcd911ed4e19311c6fdd54423bac8ff	Ska Punk
aa437deed9ab735d4bd2e5721270fe1a	Funk Rock
710a89d5cb9f3ceb3e6934254a8696e4	Melodic Power Metal
8dbf2602d350002b61aeb50d7b1f5823	Melodic Black Metal
f5950ade448acc14014ac65eff80d13e	Medieval Rock
d9394bc9b31837f373476bdde3cb4555	Extreme Gothic Metal
4863b843abbe1696e3656c13aa67af90	Mathcore
52a9361c8d305f2a227161a44bcfd37e	German Punk
2fe3f1db170aa816123f28e9875167ab	Stoner Doom
c69d790bf21dedfe84a9fb4719e93bd8	Atmospheric Sludge Metal
488d66856880e32fb94d0e791471e015	Modern Metal
c06a06a848c3e27a6fc8e7203ec2b746	Comedy Rap
73c823a8a18bd3e6e0de48741791df2e	Tribute to Rammstein
c70fac279516f5b04a129d64eff982e8	Viking Black Metal
f28bf03afc0802c0bc6eb584b4003e89	Post-Rock
9d26ef0f0b7d75ea30b8cdaad29f3c08	Post-Punk
d8cb73495a9e354d9c21b2a91383df69	Epic Power Metal
6fa675606729b1ccf2c9f118afab1a78	Progressive Death Metal
3a9ee0dca39438793417d3cda903c50f	Pagan Black Metal
3834ca66ed31bf867405bae4cffe4462	Shoegaze
1d1fe01580e2014b5b4d05532937b08d	Irish Folk Punk
6af1540af240e4518095bf9c350e6592	Melodic Groove Metal
8987193624cb1569dbea7ccbdef6da9d	Ambient Post-Black Metal
f5ccf3e5aaff8573d851e3db037f78c4	Tribute to Rage against the Machine
4bc6884ff3b54bf84c2970cf8cb57a35	Street Punk
70accb11df7fea2ee734e5849044f3c8	Technical Deathcore
100694588d8a8f56e87fe60639138889	Medieval Metal
3e8f76b0649ca67ad8e74983a81967dd	Electronic Metal
b9d93d1a014743df713103a89d6dfab5	Black'n'Roll
1351b0fdf73876875879089319d8ac18	Tribute to Motörhead
6bbdbb8ffb00d3c84d0e41be08b52d74	Beatdown Hardcore
48cd76244ec92de22070746c3e51903c	Tribute to Jimi Hendrix
ea678a9205735898d39982a6854e4be0	Folk
db187442033cf1a7b36b4f4864cb3e2d	Occult Rock
5d8ac336bc2495c7cc4da26ee697f6db	Stoner
74395b327e2c89e506e5fb24cdf28d86	Horror Punk
7711321c6e440423ac48fa14fe13662d	Electronic Body Music
f7947636b65c4e40dd72ac4977fba81e	Rapcore
716c8362b9535c67f7a3d8bba41e495c	Alternativ Grunge
582ac46d71d166a2ea996507406eb2ef	Industrial Rock
3b4b6f12576b1161eb56ef870c91cfd2	Tribute to ACDC
e51d880916bc83c61e116bd2c9007d08	Fast Rock'n'Roll
e31bcdc3311e00fe13a85ee759b65391	Pagan Metal
0f9047d3e34cffa3f65d1c63ed09c7aa	Extreme Metal
01c97e93bae9f24e53f18b9ab33a09bf	Trancecore
3d656f422f1599e545bddbd4a00b0ad1	Progressive Thrash Metal
70298a157c0bf97858f6190eae969607	Symphonic Melodic Death Metal
d967887a45ca999480ae3aec9fd17530	Symphonic Power Metal
595fe5f4c408660a17d44e1801c232f2	Avant-garde Metal
3593526a5f465ed766bafb4fb45748a2	Death Metal
9e7315413ae31a070ccae5c580dd1b19	Thrash Metal
2db87892408abd4d82eb39b78c50c27b	Black Metal
d725d2ec3a5cfa9f6384d9870df72400	Heavy Metal
7b4b7e3375c9f7424a57a2d9d7bccde5	Brutal Death Metal
b54875674f7d2d5be9737b0d4c021a21	Melodic Death Metal
0a8a13bf87abe8696fbae4efe2b7f874	Groove Metal
d30be26d66f0448359f54d923aab2bb9	Metalcore
d25334037d936d3257f794a10bb3030f	Grindcore
0c7fde545c06c2bc7383c0430c95fb78	Doom Metal
2af415a2174b122c80e901297f2d114e	Hard Rock
091194d34dc129972848b1a6507d3db5	Comedy Rock
7a62d4197e468e9dc15c90c04a00c9d8	Pop(p)core
5c3ed018832788fa9d1111b57da7fba6	Dark Metal
880318f1ad9a84c6c58e46899781dca3	Latin Metal
73c5e4259f031aa3b934d3dfe4128433	New Wave of British Heavy Metal
16875aa2b5eed3e388dcceaa36f56214	Various
6072e357ce0ffc85924d07f3f59fde6d	Technical Brutal Death Metal
8de7ee0c42a9acb04ac0ba7e466ef5fc	Slamming Deathcore
9e9cce9be25a7f0972590e519d967b9c	Brutal Deathcore
c364e34b3108a2a1051940f5f6d389dd	Hunnu Rock
8a1cece259499b3705bc5b42ddcd9169	Djent
d0ff6355a52e022c45ae8d7951520142	Death-Gind
e845a7698a158850fada750bf0ce091f	Electro Punk
853553f865f9bf21df0911e6ce54c7d0	Viking Nordic Folk
bc401be0ed7c2f7ce03dfab7faa76466	Medieval Folk Metal
3b8f2fd29146bee84451b55c0d80e880	Crust Punk
75bab3d672e799f6790e8b068d6461e1	Dark Country
637fec0bdd87d25870885872fb1c4474	Irish Folk
b21afc54fb48d153c19101658f4a2a48	Pop
2b21d9d8f81c6e564c84ef0bfa94aa5c	Jazz
c2b17b8cb332d071d4ac81167b2a6219	Reggae
2f8566ec213384ffa50ef40b2125b657	Atmospheric Folk Metal
ba08853dd62a1b1d7cbf6ca8a1b4a14b	Crust
6dff21106c4ac0fd7d0251575f4348ab	Brutal Technical Death Metal
27a7e9871142d8ed01ed795f9906c2fe	Slam
03677e82c7b8cd3989c8a6cb4e2426fa	Technical Grindcore
9826e03298104619700dc6e7b69ba1b0	Melodic Viking Metal
3a61b71b271203a633e10c5b3fa9f258	Blues
95f292773550fc8d39aaa8ddc9f3cfac	Calypso
e909c2d7067ea37437cf97fe11d91bd0	Country
a3e345c35eed0ed54daf356c68904785	Vaudeville
498059d42123bacbded45916a8636d8c	Skiffle
a4ce5a98a8950c04a3d34a2e2cb8c89f	Ska
6a1f771fc024994f9c170ab5dc6c5bb0	Folkrock
525f9a6e460f7ea2c6f932a2dc42ef67	Plitrock
7bd49e2e64f65e2ee987be9709a176bd	Protopunk
2da31ada27f1ba5acc3403440650870a	Punk'n'Roll
ead88b8beaa93bbd5041a88383609ac6	Heavy Rock
371d339c866b69b5ac58127389069fe5	Technical Brutal Deathcore
81946bb5619fab717be3cc147b88dec0	Slamdown
558a32df12c25cc4ffbef306adb35511	Atmospheric Post-Black Metal
c47182e94615627f857515b0a2bc6ee3	Blackened Speed Metal
4246bdb500b31cb6f2786206dacf8589	Tribute to Bolt Thrower
f89557d3db6e6413df4955c8d247e89c	Tribute to Danzig
c5e0ef077394352c5f1fef29365e5841	Tribute to Misfits
16518154fcc12cb9c715478443414867	Electronic
6b240b0fbb47884b8ecca1d1b7574b24	Tribute to Megadeth
1daa2df0fcb1df14e6f600785631b964	Blackened Folk Metal
f155b26f32e07effd2474272637c4b22	Middle Eastern Doom Metal
22bbb483dcba75fc2df016dc284d293b	Funeral Doom Metal
1a37b66179fd5fac40dc3c09b0da2f12	Tribute to Slayer
b13bb1f32f0106bf78a65fd98b522515	Porno Gore Grind
8e47a4c0304670944a03089849f42e07	Slamming Hardcore Death
fae1e7176fb2384eaf7a2438c3055593	Classical Metal
0c454d6b55ed1860a5b4329cea3a6cb0	Harcore Punk
2d6b9e1989416f7c6e9600897f410bdf	Atmostpheric Doom Metal
76536e0dcee9328df87ca18835071948	Blackend Thrash Metal
1f7254694408508be3dde29c3105bdbe	Gothic
42b75d86a3de2519bbc8c2264fc424af	Technical Thrash Metal
680f65454234c43a1c1e4e72febc93b2	Slam Death Metal
57974b0a845d1d72601a3a49433e01a1	Progressive Groove Metal
d179815f808c4c1c6964c094e87ac6e9	Nu-Metalcore
c7f5b70ac03ff1120e353c6faed8ea39	Orchestral Metal
220355a36d5ccded72a44119a42eaa7d	Ambient Black Metal
915b6f3ce60339b1afbae84a3c14a9d3	Groovy Metal
0e8f5257b57c38f5c625be7bd55b3bca	Deathcore;Death Metal
196c7e704b6f026b852b24771bf71ddd	Slam Metal
f4e72bc32f2c636059d5f3ba44323921	Hip Hop
eb8416f378010a87c0bb7b3dcf803c65	Goth'n'Roll
873cdb7bb058e91ccdbd703bf2c85268	Agressive Rock
4c0bd4b8244a1199bf0ff9a9e7ea9f97	Proto Metal
e7d141392548a9459e0e6e7584c1c80f	Tribute to Bathory
024837b88bb23cb8a1f0bba69f809c93	Tribute to Black Sabbath
329f0752061992d0b466b8a2a8760c34	Reggae Rock
0a96c0f13cf38b7e26172c335ce7933c	Blackened Thrash Metal
83689c87f9463b158622ef712a5e8751	Metal Covers
b80e8e613789267c95b6b1ef44e48423	Hard Pop
030e39a1278a18828389b194b93211aa	Drone
2e8dbdc23b3287569d32c2bf5fe26e06	Atmospheric Post-Hardcore
b5c548a4d670c490bbc7e20e74417003	Mariachi Punk
39bb71ab4328d2d97bd4710252ca0e16	Progressive Metalcore
c8ae0bc02385186afd062503fa77a1bc	Death'n'Roll
e1d8dfba59d6e8fe67883a5ff3fdabe4	Melodic Metalcore
4ac132d03b25a67f35c159e952b9951e	Epic Metal
c4ba898ee9eeb44ad4c2647e8ebe930a	Symphonic Metal
9d90cd61df8dbf35d395a0e225e3639c	Epic Heavy Metal
972855f17f9fffa2f73ced39e72c706e	Thrashing Deathgrind
fbe6bca8488a519965b8d63d5d7270c5	Experimental Metal
0bb2ac8dea4da36597a8d9dc88f0ed64	Atmospheric Black Metal
c960a78b4d3e0ce6a4a67f9094ffb446	Melodic Gothic Metal
a8feea8bc8e568f5829eeec3fba8fc29	Neue Deutsche Härte
b80e9df4d9b290518ee42ad01df931f9	Metal with Electronic influences
eff28181bc16f9980300231c2831cfed	Psychedelic Folk Rock
646b7096ac40bf3b76f46527bf50607a	Atmospheric Doom Metal
423c4aac42f2b97e03b0b351b62b88bf	Symphonic Folk Metal
7f464b34be2c37650003a770ce74d876	Neofolk
d97cb00c4880b250daae88ad9c0f29bb	Middle Eastern Folk Metal
13413382593041359bf0de3827dcf8d5	Raw Black Metal
7d3969ae3630f4bf306152ed36280f48	Dungeon Synth
bcfc9877823bc82005f8062436e3d81e	Symphonic Heavy Metal
0403a39b82e1ef52bb4dfd3682a42c73	Symphonic Rock
5fefa04e0919aa751cff36fe3a94f833	Atmospheric Death Metal
fedf6851863c5847bc0bf5de7c3c758e	Epic Folk Metal
b81acdb05aef5596bb72fe68d03cfaa2	Psychadelic Rock
19ceec79dad9529ea3d0ea15b5781312	Sludge Rock
2cfb794ae8db38d488dbd27f0f3a8b14	Doom Rock
02a506ada599434029efcb78921153af	Garagerock
5e57b61f8223fb8b54685a6a063ad3cc	Symphonic Deathcore
283a2e526241b2c01f4928afda6a2e0a	Melodic Deathcore
102289ea390e6d00463584fe50b1d87b	Progressive Melodic Death Metal
b3412a542c856d851d554e29aa16d4b6	Thras Metal
\.


--
-- Data for Name: next_events_with_tickets; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.next_events_with_tickets (id_event, event, date_event, id_place, duration, price, persons) FROM stdin;
72281605945dfd768083800bc06c5946	Heidelberg Deathfest VIII	2025-03-15	c72b4173a6a7131bf31a711212305fd3	0	63.0	2
c56598c23355f774b43e42e55fe94cb8	Pinch Black + Greh + Roots of Unrest	2025-03-22	0280c9c3b98763f5a8d2ce7e97ce1b05	0	16.0	2
02bf8e0e12d25be045c3c12355af1664	"With the old Breed" - Album Release-Show	2025-03-28	09ddc8804dd5908fef3c8c0c474ad238	0	20.80	2
872789acfd93b013e7120139be311a9b	Circle Pitournium Tour 2025	2025-04-21	f3a90318abb3e16166d96055fd6f9096	0	28.5	2
45741da54cd02bf8b9c209acbf2ff2ae	Veins of Fire Tour 2025	2025-05-01	588671317bf1864e5a95445ec51aac65	0	29.35	2
7320993a151875af6faf0e958b1d77db	Grabbenacht Festival 2025	2025-05-01	010c9e9e86100e63919a6051b399d662	1	59.0	2
74b195b8a5febdcaca93bb4d7a20b0ce	Slashing Europe	2025-04-24	67bac16ced3de0e99516cf21505718a1	0	25.0	2
28630f95cb7c87f6ba4f40bd5094ae7f	Infernal Bloodshed over Europe	2025-06-25	83b0fe992121ae7d39f6bcc58a48160c	0	39.75	2
ce5649089736affc844695973913e736	Boarstresm Open Air 2025	2025-07-18	cf1c12d42f59db3667fc162556aab169	1	75.0	2
d500fda7a1f356d4e44f27a37a95aab0	March of the Unbending - Europe 2025	2025-04-15	f3a90318abb3e16166d96055fd6f9096	0	33.4	2
\.


--
-- Data for Name: test_country; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.test_country (id_country, country, flag) FROM stdin;
NLD                             	Netherlands	nl
RUS                             	Russian Federation	ru
IRN                             	Iran	ir
ARE                             	United Arab Emirates	ae
CZE                             	Czechia	cz
001                             	International	un
LTU                             	Lithuania	lt
MYS                             	Malaysia	my
150                             	Europe	eu
EGY                             	Egypt	eg
ZAF                             	South Africa	za
CUB                             	Cuba	cu
JAM                             	Jamaica	jm
CRI                             	Costa Rica	cr
MEX                             	Mexico	mx
PAN                             	Panama	pa
ARG                             	Argentina	ar
BRA                             	Brazil	br
CHL                             	Chile	cl
COL                             	Colombia	co
CAN                             	Canada	ca
USA                             	United States of America	us
CHN                             	China	cn
JPN                             	Japan	jp
MNG                             	Mongolia	mn
IDN                             	Indonesia	id
PHL                             	Philippines	ph
IND                             	India	in
ISR                             	Israel	il
TUR                             	Türkiye	tr
BLR                             	Belarus	by
HUN                             	Hungary	hu
POL                             	Poland	pl
ROU                             	Romania	ro
UKR                             	Ukraine	ua
DNK                             	Denmark	dk
EST                             	Estonia	ee
FRO                             	Faroe Islands	fo
FIN                             	Finland	fi
ISL                             	Iceland	is
IRL                             	Ireland	ie
NOR                             	Norway	no
SWE                             	Sweden	se
HRV                             	Croatia	hr
GBR                             	United Kingdom of Great Britain and Northern Ireland	gb
GRC                             	Greece	gr
ITA                             	Italy	it
MLT                             	Malta	mt
PRT                             	Portugal	pt
SRB                             	Serbia	rs
SVN                             	Slovenia	si
ESP                             	Spain	es
AUT                             	Austria	at
BEL                             	Belgium	be
FRA                             	France	fr
DEU                             	Germany	de
LUX                             	Luxembourg	lu
CHE                             	Switzerland	ch
AUS                             	Australia	au
NZL                             	New Zealand	nz
SVK                             	Slovakia	sk
\.


--
-- Name: continents continents_continent_key; Type: CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.continents
    ADD CONSTRAINT continents_continent_key UNIQUE (continent);


--
-- Name: continents continents_pkey; Type: CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.continents
    ADD CONSTRAINT continents_pkey PRIMARY KEY (id_continent);


--
-- Name: countries_continents countries_continents_pkey; Type: CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.countries_continents
    ADD CONSTRAINT countries_continents_pkey PRIMARY KEY (id_country, id_continent);


--
-- Name: countries countries_country_key; Type: CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.countries
    ADD CONSTRAINT countries_country_key UNIQUE (country);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id_country);


--
-- Name: places places_pkey; Type: CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id_place);


--
-- Name: places places_place_key; Type: CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.places
    ADD CONSTRAINT places_place_key UNIQUE (place);


--
-- Name: bands bands_band_key; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands
    ADD CONSTRAINT bands_band_key UNIQUE (band);


--
-- Name: bands_countries bands_countries_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_countries
    ADD CONSTRAINT bands_countries_pkey PRIMARY KEY (id_band, id_country);


--
-- Name: bands_events bands_events_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_events
    ADD CONSTRAINT bands_events_pkey PRIMARY KEY (id_band, id_event);


--
-- Name: bands_genres bands_generes_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_genres
    ADD CONSTRAINT bands_generes_pkey PRIMARY KEY (id_band, id_genre);


--
-- Name: bands bands_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands
    ADD CONSTRAINT bands_pkey PRIMARY KEY (id_band);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id_event);


--
-- Name: genres generes_genere_key; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.genres
    ADD CONSTRAINT generes_genere_key UNIQUE (genre);


--
-- Name: genres generes_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.genres
    ADD CONSTRAINT generes_pkey PRIMARY KEY (id_genre);


--
-- Name: next_events_with_tickets next_events_with_tickets_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.next_events_with_tickets
    ADD CONSTRAINT next_events_with_tickets_pkey PRIMARY KEY (id_event);


--
-- Name: v_events _RETURN; Type: RULE; Schema: music; Owner: -
--

CREATE OR REPLACE VIEW music.v_events AS
 SELECT e.id_event,
    date_part('year'::text, e.date_event) AS year,
    to_char((e.date_event)::timestamp with time zone, 'DD.MM.YYYY'::text) AS date,
    e.event,
    p.place,
    count(DISTINCT be.id_band) AS bands,
    (e.duration + 1) AS days
   FROM ((music.events e
     JOIN geo.places p ON ((p.id_place = e.id_place)))
     JOIN music.bands_events be ON ((be.id_event = e.id_event)))
  GROUP BY e.id_event, e.event, p.place, e.date_event
  ORDER BY e.date_event;


--
-- Name: countries_continents countries_continents_id_continent_fkey; Type: FK CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.countries_continents
    ADD CONSTRAINT countries_continents_id_continent_fkey FOREIGN KEY (id_continent) REFERENCES geo.continents(id_continent) ON UPDATE CASCADE;


--
-- Name: countries_continents countries_continents_id_country_fkey; Type: FK CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.countries_continents
    ADD CONSTRAINT countries_continents_id_country_fkey FOREIGN KEY (id_country) REFERENCES geo.countries(id_country) ON UPDATE CASCADE;


--
-- Name: bands_countries bands_countries_id_band_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_countries
    ADD CONSTRAINT bands_countries_id_band_fkey FOREIGN KEY (id_band) REFERENCES music.bands(id_band) ON UPDATE CASCADE;


--
-- Name: bands_countries bands_countries_id_country_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_countries
    ADD CONSTRAINT bands_countries_id_country_fkey FOREIGN KEY (id_country) REFERENCES geo.countries(id_country) ON UPDATE CASCADE;


--
-- Name: bands_events bands_events_id_band_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_events
    ADD CONSTRAINT bands_events_id_band_fkey FOREIGN KEY (id_band) REFERENCES music.bands(id_band) ON UPDATE CASCADE;


--
-- Name: bands_events bands_events_id_event_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_events
    ADD CONSTRAINT bands_events_id_event_fkey FOREIGN KEY (id_event) REFERENCES music.events(id_event) ON UPDATE CASCADE;


--
-- Name: bands_genres bands_generes_id_band_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_genres
    ADD CONSTRAINT bands_generes_id_band_fkey FOREIGN KEY (id_band) REFERENCES music.bands(id_band) ON UPDATE CASCADE;


--
-- Name: bands_genres bands_generes_id_genere_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_genres
    ADD CONSTRAINT bands_generes_id_genere_fkey FOREIGN KEY (id_genre) REFERENCES music.genres(id_genre) ON UPDATE CASCADE;


--
-- Name: events events_id_place_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.events
    ADD CONSTRAINT events_id_place_fkey FOREIGN KEY (id_place) REFERENCES geo.places(id_place) ON UPDATE CASCADE;


--
-- Name: mv_musical_info; Type: MATERIALIZED VIEW DATA; Schema: music; Owner: -
--

REFRESH MATERIALIZED VIEW music.mv_musical_info;


--
-- PostgreSQL database dump complete
--

