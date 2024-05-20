--
-- PostgreSQL database dump
--

-- Dumped from database version 15.7 (Ubuntu 15.7-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.7 (Ubuntu 15.7-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: languages; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA languages;


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
  where id_band = md5(ban) and id_country = countr for update;
 
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
  	  values (md5(ban), ban, 'y');
    end if; 
  
    insert into music.bands_countries
    values(md5(ban), countr);
    return 'Band - County added'; 
   
  end if;
	  
end;
$$;


--
-- Name: insert_bands_on_countries_old(character varying, character varying); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_bands_on_countries_old(ban character varying, countr character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
declare 
  i_band varchar;
  i_countr varchar;
begin 
	
  select id_band, id_country into i_band, i_countr
  from music.bands_countries bc
  where id_band = md5(ban) and id_country = md5(countr) for update;
 
  if found then
    return 'This combination of band and country exist';
  else
	 
    select id_country into i_countr 
    from geo.countries c  
    where country = countr for update;
 
    if not found then    
      return 'Please insert this country first';
    end if;
   
    select id_band into i_band
    from music.bands
    where band = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(ban), ban, 'y');
    end if; 
  
    insert into music.bands_countries
    values(md5(ban), md5(countr));
    return 'Band - County added'; 
   
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
  where id_band = md5(ban) and id_event = md5(eve) for update;
 
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
  	  values (md5(ban), ban, 'y');
    end if;
  
    insert into music.bands_events
    values (md5(ban), md5(eve));
    return 'Band - Event inserted';
  end if;
  
end;
$$;


--
-- Name: insert_bands_to_genres(character varying, character varying); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_bands_to_genres(ban character varying, gene character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
declare 
  i_band varchar;
  i_gene varchar;
begin 
	
  select id_genere, id_band into i_gene, i_band
  from music.bands_generes bg 
  where id_band = md5(ban) and id_genere = md5(gene) for update;
  
  if found then
    return 'This combination of band and genere exist';
  else
  
    select id_genere into i_gene 
    from music.generes g
    where genere = gene for update;
 
    if not found then    
      insert into music.generes
  	  values (md5(gene), gene);
    end if;
	
    select id_band into i_band
    from music.bands
    where band = ban for update ;
 
    if not found then
  	  insert into music.bands
  	  values (md5(ban), ban, 'y');
    end if;
  
    insert into music.bands_generes
    values(md5(ban), md5(gene));
    return 'Band - Genere added';
    
  end if;  
end;
$$;


--
-- Name: insert_events(character varying, date, character varying, smallint, numeric, smallint); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_events(eve character varying, dat date, plac character varying, dur smallint, pri numeric, per smallint) RETURNS text
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
  	  values (md5(plac), plac);
  	end if;
  
  	insert into music.events
    values (md5(eve), eve, dat, md5(plac), dur, pri, per);
    return 'Added event';  
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
    id_country character(32) NOT NULL,
    country character varying(100) NOT NULL,
    flag character(2)
);


--
-- Name: countries_continents; Type: TABLE; Schema: geo; Owner: -
--

CREATE TABLE geo.countries_continents (
    id_country character varying NOT NULL,
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
-- Name: unm49_iso3166; Type: TABLE; Schema: geo; Owner: -
--

CREATE TABLE geo.unm49_iso3166 (
    global_code character varying(3),
    global_name character varying(50),
    region_code character varying(3),
    region_name character varying(50),
    sub_region_code character varying(3),
    sub_region_name character varying(50),
    intermediate_region_code character varying(3),
    intermediate_region_name character varying(50),
    country_or_area character varying(70),
    m49_code character varying(3),
    iso_alpha2_code character varying(2),
    iso_alpha3_code character varying(3)
);


--
-- Name: iso_639_3; Type: TABLE; Schema: languages; Owner: -
--

CREATE TABLE languages.iso_639_3 (
    iso639_3_id character(3) NOT NULL,
    iso639_3_b character(3),
    iso639_3_t character(3),
    iso639_1 character(2),
    iso_scope character(1) NOT NULL,
    iso_type character(1) NOT NULL,
    ref_name character varying(150) NOT NULL,
    iso_comment character varying(150),
    CONSTRAINT iso_639_3_iso_scope_check CHECK ((iso_scope = ANY (ARRAY['I'::bpchar, 'M'::bpchar, 'S'::bpchar]))),
    CONSTRAINT iso_639_3_iso_type_check CHECK ((iso_type = ANY (ARRAY['A'::bpchar, 'H'::bpchar, 'L'::bpchar, 'S'::bpchar, 'E'::bpchar, 'C'::bpchar])))
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
    id_country character(32) NOT NULL
);


--
-- Name: bands_events; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.bands_events (
    id_band character(32) NOT NULL,
    id_event character(32) NOT NULL
);


--
-- Name: bands_generes; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.bands_generes (
    id_band character(32) NOT NULL,
    id_genere character(32) NOT NULL
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
    persons smallint DEFAULT 1
);


--
-- Name: generes; Type: TABLE; Schema: music; Owner: -
--

CREATE TABLE music.generes (
    id_genere character(32) NOT NULL,
    genere character varying(100) NOT NULL
);


--
-- Name: mv_musical_info; Type: MATERIALIZED VIEW; Schema: music; Owner: -
--

CREATE MATERIALIZED VIEW music.mv_musical_info AS
 SELECT b.band,
    b.likes,
    c.country,
    c.flag,
    g.genere,
    e.event,
    e.date_event,
    p.place
   FROM (((((((music.bands b
     JOIN music.bands_countries bc ON ((b.id_band = bc.id_band)))
     JOIN geo.countries c ON ((c.id_country = bc.id_country)))
     JOIN music.bands_generes bg ON ((b.id_band = bg.id_band)))
     JOIN music.generes g ON ((g.id_genere = bg.id_genere)))
     JOIN music.bands_events be ON ((be.id_band = b.id_band)))
     JOIN music.events e ON ((e.id_event = be.id_event)))
     JOIN geo.places p ON ((p.id_place = e.id_place)))
  ORDER BY b.band
  WITH NO DATA;


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
    count(DISTINCT bg.id_genere) AS generes,
    count(DISTINCT be.id_event) AS events
   FROM ((((music.bands b
     JOIN music.bands_countries bc ON ((b.id_band = bc.id_band)))
     JOIN geo.countries c ON ((c.id_country = bc.id_country)))
     JOIN music.bands_generes bg ON ((bg.id_band = b.id_band)))
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
    g.genere
   FROM ((music.bands b
     JOIN music.bands_generes bg ON ((b.id_band = bg.id_band)))
     JOIN music.generes g ON ((bg.id_genere = g.id_genere)))
  ORDER BY b.band, g.genere;


--
-- Name: v_bands_likes; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_bands_likes AS
 SELECT bands.likes,
    count(bands.id_band) AS bands
   FROM music.bands
  GROUP BY bands.likes
  ORDER BY (count(bands.id_band)) DESC;


--
-- Name: v_bands_to_tex; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_bands_to_tex AS
 SELECT
        CASE
            WHEN ((vb.band)::text ~* '\&'::text) THEN (regexp_replace((vb.band)::text, '\&'::text, '\\&'::text))::character varying
            WHEN ((vb.band)::text ~* 'ð'::text) THEN (regexp_replace((vb.band)::text, 'ð'::text, '\\dh '::text))::character varying
            ELSE vb.band
        END AS "Gruppe",
    ((' & \includegraphics[width=1cm]{../4x3/'::text || (vb.flag)::text) || '} & '::text) AS "Land",
    ((('\includegraphics[width=1cm]{'::text || '../likes/'::text) || (vb.likes)::text) || '} \\ \hline'::text) AS "Farbe"
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
     JOIN music.bands_countries bc ON ((c.id_country = bc.id_country)))
  GROUP BY c.country, c.flag, c.id_country
  ORDER BY (count(DISTINCT bc.id_band)) DESC, c.country;


--
-- Name: v_events; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_events AS
 SELECT e.id_event,
    date_part('year'::text, e.date_event) AS year,
    to_char((e.date_event)::timestamp with time zone, 'DD.MM.YYYY'::text) AS date,
    e.event,
    p.place,
    count(DISTINCT be.id_band) AS bands
   FROM ((music.events e
     JOIN geo.places p ON ((p.id_place = e.id_place)))
     JOIN music.bands_events be ON ((be.id_event = e.id_event)))
  GROUP BY e.event, p.place, e.date_event, e.id_event
  ORDER BY e.date_event;


--
-- Name: v_events_mod; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_events_mod AS
SELECT
    NULL::double precision AS year,
    NULL::text AS date,
    NULL::character varying(255) AS event,
    NULL::character varying(100) AS place,
    NULL::bigint AS bands,
    NULL::integer AS days;


--
-- Name: v_events_years; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_events_years AS
 SELECT date_part('year'::text, events.date_event) AS years,
    count(events.id_event) AS events
   FROM music.events
  GROUP BY (date_part('year'::text, events.date_event))
  ORDER BY (date_part('year'::text, events.date_event));


--
-- Name: v_generes; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_generes AS
 SELECT g.id_genere,
    g.genere,
    count(bg.id_band) AS bands
   FROM ((music.generes g
     JOIN music.bands_generes bg ON ((g.id_genere = bg.id_genere)))
     JOIN music.bands b ON ((b.id_band = bg.id_band)))
  WHERE (b.likes = 'y'::bpchar)
  GROUP BY g.genere, g.id_genere
  ORDER BY (count(bg.id_band)) DESC, g.genere;


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
 SELECT 'generes'::text AS entities,
    count(*) AS quantity
   FROM music.generes;


--
-- Data for Name: continents; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.continents (id_continent, continent) FROM stdin;
5ffec2d87ab548202f8b549af380913a	North America
aab422acb3d2334a6deca0e1495745c2	South America
c9d402d0280088a8c803e108bf31449b	Antartica
150	Europe
002	Africa
142	Asia
009	Oceania
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.countries (id_country, country, flag) FROM stdin;
NLD                             	Netherlands	nl
RUS                             	Russian Federation	ru
IRN                             	Iran	ir
ARE                             	United Arab Emirates	ae
CZE                             	Czechia	cz
001                             	International	un
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
GBR                             	United Kingdom of Great Britain and Northern Ireland	gb
HRV                             	Croatia	hr
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
JAM	5ffec2d87ab548202f8b549af380913a
CRI	5ffec2d87ab548202f8b549af380913a
MEX	5ffec2d87ab548202f8b549af380913a
PAN	5ffec2d87ab548202f8b549af380913a
ARG	aab422acb3d2334a6deca0e1495745c2
BRA	aab422acb3d2334a6deca0e1495745c2
CHL	aab422acb3d2334a6deca0e1495745c2
CAN	5ffec2d87ab548202f8b549af380913a
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
DNK	150
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
COL	aab422acb3d2334a6deca0e1495745c2
CUB	5ffec2d87ab548202f8b549af380913a
USA	5ffec2d87ab548202f8b549af380913a
DEU	150
FRA	150
ARE	142
001	002
001	142
001	5ffec2d87ab548202f8b549af380913a
001	aab422acb3d2334a6deca0e1495745c2
EGY	002
ZAF	002
001	150
EST	150
001	009
GBR	150
IRL	150
HRV	150
MLT	150
\.


--
-- Data for Name: places; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.places (id_place, place) FROM stdin;
875ec5037fe25fad96113c57da62f9fe	Landau (Gloria Kulturpalast)
8bb89006a86a427f89e49efe7f1635c1	Mainz (Alexander the Great)
2a8f2b9aef561f19faad529d927dba17	Offenbach (Stadthalle)
c6e9ff60da2342ba2a0ce4d9b6fc6ff1	Aschaffenburg (Colos-Saal)
741ae9098af4e50aecf13b0ef08ecc47	Barleben
beeb45e34fe94369bed94ce75eb1e841	Lichtenfels (Stadhalle)
0b186d7eb0143e60ced4af3380f5faa8	Weinheim (Café Central)
620f9da22d73cc8d5680539a4c87402b	Mainz (M8 im Haus der Jugend)
4e637199a58a4ff2ec4b956d06e472e8	Worms (Schwarzer Bär)
828d35ecd5412f7bc1ba369d5d657f9f	Heidelberg (halle 02)
858d53d9bd193393481e4e8b24d10bba	Aschaffenburg (JUKUZ)
19a1767aab9e93163ad90f2dfe82ec71	Mainz (Rheinhufer)
4e592038a4c7b6cdc3e7b92d98867506	Frankfurt am Main (Nachtleben)
29ae00a7e41558eb2ed8c0995a702d7a	Mainz (Alte Ziegelei)
1e9e26a0456c1694d069e119dae54240	Oberursel
38085fa2d02ff7710a42a0c61ab311e2	Offenbach (Capitol)
d1ad016a5b257743ef75594c67c52935	Rüsselsheim (Das Rind)
d379f693135eefa77bc9732f97fcaaf1	Hockenheim (Hockenheim-Ring)
7adc966f52e671b15ea54075581c862b	Schriesheim
427a371fadd4cce654dd30c27a36acb0	Wiesbaden (Schlachthof)
f3c1ffc50f4f8d0a857533164e8da867	Mainz (KUZ - Kulturzentrum)
4751a5b2d9992dca6e462e3b14695284	Mannheim (MS Connexion Complex)
d5c76ce146e0b3f46e69e870e9d48181	Rockenhausen
59c2a4862605f1128b334896c17cab7b	Magdeburg (Factory)
3b0409f1b5830369aac22e3c5b9b9815	Ballenstedt
55ff4adc7d421cf9e05b68d25ee22341	Mainz-Kastel (Reduit)
bb1bac023b4f02a5507f1047970d1aca	Neuborn
21760b1bbe36b4dae8fa9e0c274f76bf	Mannheim (Maimarkt)
50bd324043e0b113bea1b5aa0422806f	Neckargemünd (Metal Club Odinwald)
7786a0fc094d859eb469868003b142db	Mannheim (SAP Arena)
657d564cc1dbaf58e2f2135b57d02d99	Bad Kreuznach (Jakob-Kiefer-Halle)
41b6f7fdc3453cc5f989c347d9b4b674	Havana (Sala Maxim Rock)
012d8da36e8518d229988fe061f3c376	Ulm (Hexenhaus)
14b82c93c42422209e5b5aad5b7b772e	Mainz (Kulturcafé auf dem Campus)
3611a0c17388412df8e42cf1858d5e99	Kaiserslautern (Irish House)
99d75d9948711c04161016c0d2280dd9	Bonn (Bla)
2898437c2420ae271ae3310552ad6d70	Darmstadt (Goldene Krone)
871568e58a911610979cadc2c1e94122	Hirschaid
6d998a5f2c8b461a654f7f9e34ab4368	Lindau (Club Vaudeville)
fbde8601308ae84be23d6de78e10d14c	Wacken
0643057438c69f0c17bf84c9495d2b7e	Andernach
e16b7534e6149fb73a7c2d9b02b61a7d	Büchold
93a57b9586b3285867e6b87031559aea	Frankfurt am Main (Ponyhof Club)
927ba3593d3a4597eac931a25b53a137	Frankfurt am Main (Das Bett)
c2e2354512feb29acf171d655a159dd0	Frankfurt am Main (Festhalle)
a93597b8b03e112e11f4cda2c1587b6f	Frankfurt am Main (Jahrhunderthalle)
a247cd14d4d2259d6f2bc87dcb3fdfb6	Mörlenbach (LIVE MUSIC HALL Weiher)
d8634af954a0d50828522b6c6a6053c2	Kusel (Kinett)
67eb541ae5d82ae8606697eba4119bf2	Köln (Live Music Hall)
fa788dff4144faf1179fc82d60ccd571	Frankfurt am Main (Haus Sindlingen)
4a887b8a68acf9b04d9d027bddedb06b	Leipzig
e1d73a013c55de0ebff0e36b7c07ee77	Wernigerode
5ef87fb605db6ba57e23c29fed883ac7	Frankfurt am Main (Batschkapp)
f9b213d4a497239d3969131d12cb900d	Mainz (Volkspark)
245dd888dae44ef00b3aa74214912f40	Turgau/Entenfang
b26918c7403ba9006251abb5aed9b568	Buchenbach
581032b233cfa02398169948de14c2dd	Dotmund (JunkYard)
28b01417bfa80ac2a9d3521137485589	Weilburg-Kubach (Bürgerhalle)
d7925427b71cf5c69dea1361e790154e	Frankfurt am Main (Schöppche-Keller)
d6a89e194d2558258305d49f06856e57	Frankfurt am Main (ELFER Club)
94707aea9e845e5e0ec91cd63f5982d6	Bechtheim (Gasthaus Bechtheimer Hof)
46103b15f2a58bf3c7d03c4d9a954779	Weibersbrunn (Mehrzweckhalle)
e5fe851ccb28deccc27178ac003727e2	Hofheim (Jazzkeller)
5a90e8cdd17fb102f309e2bbd460e289	Wiesbaden (GMZ Georg-Buch-Haus)
f0a8e858b19385f9c627d8b752c81a6c	Alzey (Oberhaus)
e2b11d2fc694a779d25220b9e5cb88ad	Ludwigshafen am Rhein (Bon Scott Rock Cafe)
c5159d0425e9c5737c8884eb38d70dd9	Mainz (Zitadelle - Die Kulturei)
ea72b9f0db73025c8aaedae0f7b874f8	Hamm
89c0549ca41bb77ccdf081193ca1e45f	Karlsruhe (Alter Schlachthof - Substage)
6db34279cf6070892349b478135302e7	Ludwigshafen (Kulturzentrum dasHaus)
446c20c5e383ff30350166d5ab741efb	Mainz (Kulturclub schon schön)
6d488d592421aa8391ff259ef1c8b744	Mannheim (7er Club)
ca838f25ade35ddc0337a6f0ea710f4b	Mühltal (Steinbruch Theater)
\.


--
-- Data for Name: unm49_iso3166; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.unm49_iso3166 (global_code, global_name, region_code, region_name, sub_region_code, sub_region_name, intermediate_region_code, intermediate_region_name, country_or_area, m49_code, iso_alpha2_code, iso_alpha3_code) FROM stdin;
001	World	002	Africa	015	Northern Africa			Algeria	012	DZ	DZA
001	World	002	Africa	015	Northern Africa			Egypt	818	EG	EGY
001	World	002	Africa	015	Northern Africa			Libya	434	LY	LBY
001	World	002	Africa	015	Northern Africa			Morocco	504	MA	MAR
001	World	002	Africa	015	Northern Africa			Sudan	729	SD	SDN
001	World	002	Africa	015	Northern Africa			Tunisia	788	TN	TUN
001	World	002	Africa	015	Northern Africa			Western Sahara	732	EH	ESH
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	British Indian Ocean Territory	086	IO	IOT
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Burundi	108	BI	BDI
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Comoros	174	KM	COM
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Djibouti	262	DJ	DJI
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Eritrea	232	ER	ERI
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Ethiopia	231	ET	ETH
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	French Southern Territories	260	TF	ATF
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Kenya	404	KE	KEN
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Madagascar	450	MG	MDG
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Malawi	454	MW	MWI
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Mauritius	480	MU	MUS
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Mayotte	175	YT	MYT
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Mozambique	508	MZ	MOZ
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Réunion	638	RE	REU
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Rwanda	646	RW	RWA
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Seychelles	690	SC	SYC
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Somalia	706	SO	SOM
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	South Sudan	728	SS	SSD
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Uganda	800	UG	UGA
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	United Republic of Tanzania	834	TZ	TZA
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Zambia	894	ZM	ZMB
001	World	002	Africa	202	Sub-Saharan Africa	014	Eastern Africa	Zimbabwe	716	ZW	ZWE
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Angola	024	AO	AGO
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Cameroon	120	CM	CMR
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Central African Republic	140	CF	CAF
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Chad	148	TD	TCD
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Congo	178	CG	COG
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Democratic Republic of the Congo	180	CD	COD
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Equatorial Guinea	226	GQ	GNQ
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Gabon	266	GA	GAB
001	World	002	Africa	202	Sub-Saharan Africa	017	Middle Africa	Sao Tome and Principe	678	ST	STP
001	World	002	Africa	202	Sub-Saharan Africa	018	Southern Africa	Botswana	072	BW	BWA
001	World	002	Africa	202	Sub-Saharan Africa	018	Southern Africa	Eswatini	748	SZ	SWZ
001	World	002	Africa	202	Sub-Saharan Africa	018	Southern Africa	Lesotho	426	LS	LSO
001	World	002	Africa	202	Sub-Saharan Africa	018	Southern Africa	Namibia	516	NA	NAM
001	World	002	Africa	202	Sub-Saharan Africa	018	Southern Africa	South Africa	710	ZA	ZAF
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Benin	204	BJ	BEN
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Burkina Faso	854	BF	BFA
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Cabo Verde	132	CV	CPV
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Côte d’Ivoire	384	CI	CIV
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Gambia	270	GM	GMB
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Ghana	288	GH	GHA
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Guinea	324	GN	GIN
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Guinea-Bissau	624	GW	GNB
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Liberia	430	LR	LBR
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Mali	466	ML	MLI
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Mauritania	478	MR	MRT
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Niger	562	NE	NER
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Nigeria	566	NG	NGA
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Saint Helena	654	SH	SHN
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Senegal	686	SN	SEN
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Sierra Leone	694	SL	SLE
001	World	002	Africa	202	Sub-Saharan Africa	011	Western Africa	Togo	768	TG	TGO
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Anguilla	660	AI	AIA
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Antigua and Barbuda	028	AG	ATG
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Aruba	533	AW	ABW
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Bahamas	044	BS	BHS
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Barbados	052	BB	BRB
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Bonaire, Sint Eustatius and Saba	535	BQ	BES
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	British Virgin Islands	092	VG	VGB
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Cayman Islands	136	KY	CYM
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Cuba	192	CU	CUB
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Curaçao	531	CW	CUW
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Dominica	212	DM	DMA
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Dominican Republic	214	DO	DOM
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Grenada	308	GD	GRD
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Guadeloupe	312	GP	GLP
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Haiti	332	HT	HTI
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Jamaica	388	JM	JAM
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Martinique	474	MQ	MTQ
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Montserrat	500	MS	MSR
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Puerto Rico	630	PR	PRI
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Saint Barthélemy	652	BL	BLM
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Saint Kitts and Nevis	659	KN	KNA
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Saint Lucia	662	LC	LCA
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Saint Martin (French Part)	663	MF	MAF
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Saint Vincent and the Grenadines	670	VC	VCT
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Sint Maarten (Dutch part)	534	SX	SXM
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Trinidad and Tobago	780	TT	TTO
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	Turks and Caicos Islands	796	TC	TCA
001	World	019	Americas	419	Latin America and the Caribbean	029	Caribbean	United States Virgin Islands	850	VI	VIR
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	Belize	084	BZ	BLZ
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	Costa Rica	188	CR	CRI
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	El Salvador	222	SV	SLV
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	Guatemala	320	GT	GTM
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	Honduras	340	HN	HND
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	Mexico	484	MX	MEX
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	Nicaragua	558	NI	NIC
001	World	019	Americas	419	Latin America and the Caribbean	013	Central America	Panama	591	PA	PAN
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Argentina	032	AR	ARG
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Bolivia (Plurinational State of)	068	BO	BOL
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Bouvet Island	074	BV	BVT
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Brazil	076	BR	BRA
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Chile	152	CL	CHL
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Colombia	170	CO	COL
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Ecuador	218	EC	ECU
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Falkland Islands (Malvinas)	238	FK	FLK
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	French Guiana	254	GF	GUF
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Guyana	328	GY	GUY
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Paraguay	600	PY	PRY
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Peru	604	PE	PER
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	South Georgia and the South Sandwich Islands	239	GS	SGS
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Suriname	740	SR	SUR
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Uruguay	858	UY	URY
001	World	019	Americas	419	Latin America and the Caribbean	005	South America	Venezuela (Bolivarian Republic of)	862	VE	VEN
001	World	019	Americas	021	Northern America			Bermuda	060	BM	BMU
001	World	019	Americas	021	Northern America			Canada	124	CA	CAN
001	World	019	Americas	021	Northern America			Greenland	304	GL	GRL
001	World	019	Americas	021	Northern America			Saint Pierre and Miquelon	666	PM	SPM
001	World	019	Americas	021	Northern America			United States of America	840	US	USA
001	World							Antarctica	010	AQ	ATA
001	World	142	Asia	143	Central Asia			Kazakhstan	398	KZ	KAZ
001	World	142	Asia	143	Central Asia			Kyrgyzstan	417	KG	KGZ
001	World	142	Asia	143	Central Asia			Tajikistan	762	TJ	TJK
001	World	142	Asia	143	Central Asia			Turkmenistan	795	TM	TKM
001	World	142	Asia	143	Central Asia			Uzbekistan	860	UZ	UZB
001	World	142	Asia	030	Eastern Asia			China	156	CN	CHN
001	World	142	Asia	030	Eastern Asia			China, Hong Kong Special Administrative Region	344	HK	HKG
001	World	142	Asia	030	Eastern Asia			China, Macao Special Administrative Region	446	MO	MAC
001	World	142	Asia	030	Eastern Asia			Democratic People's Republic of Korea	408	KP	PRK
001	World	142	Asia	030	Eastern Asia			Japan	392	JP	JPN
001	World	142	Asia	030	Eastern Asia			Mongolia	496	MN	MNG
001	World	142	Asia	030	Eastern Asia			Republic of Korea	410	KR	KOR
001	World	142	Asia	035	South-eastern Asia			Brunei Darussalam	096	BN	BRN
001	World	142	Asia	035	South-eastern Asia			Cambodia	116	KH	KHM
001	World	142	Asia	035	South-eastern Asia			Indonesia	360	ID	IDN
001	World	142	Asia	035	South-eastern Asia			Lao People's Democratic Republic	418	LA	LAO
001	World	142	Asia	035	South-eastern Asia			Malaysia	458	MY	MYS
001	World	142	Asia	035	South-eastern Asia			Myanmar	104	MM	MMR
001	World	142	Asia	035	South-eastern Asia			Philippines	608	PH	PHL
001	World	142	Asia	035	South-eastern Asia			Singapore	702	SG	SGP
001	World	142	Asia	035	South-eastern Asia			Thailand	764	TH	THA
001	World	142	Asia	035	South-eastern Asia			Timor-Leste	626	TL	TLS
001	World	142	Asia	035	South-eastern Asia			Viet Nam	704	VN	VNM
001	World	142	Asia	034	Southern Asia			Afghanistan	004	AF	AFG
001	World	142	Asia	034	Southern Asia			Bangladesh	050	BD	BGD
001	World	142	Asia	034	Southern Asia			Bhutan	064	BT	BTN
001	World	142	Asia	034	Southern Asia			India	356	IN	IND
001	World	142	Asia	034	Southern Asia			Iran (Islamic Republic of)	364	IR	IRN
001	World	142	Asia	034	Southern Asia			Maldives	462	MV	MDV
001	World	142	Asia	034	Southern Asia			Nepal	524	NP	NPL
001	World	142	Asia	034	Southern Asia			Pakistan	586	PK	PAK
001	World	142	Asia	034	Southern Asia			Sri Lanka	144	LK	LKA
001	World	142	Asia	145	Western Asia			Armenia	051	AM	ARM
001	World	142	Asia	145	Western Asia			Azerbaijan	031	AZ	AZE
001	World	142	Asia	145	Western Asia			Bahrain	048	BH	BHR
001	World	142	Asia	145	Western Asia			Cyprus	196	CY	CYP
001	World	142	Asia	145	Western Asia			Georgia	268	GE	GEO
001	World	142	Asia	145	Western Asia			Iraq	368	IQ	IRQ
001	World	142	Asia	145	Western Asia			Israel	376	IL	ISR
001	World	142	Asia	145	Western Asia			Jordan	400	JO	JOR
001	World	142	Asia	145	Western Asia			Kuwait	414	KW	KWT
001	World	142	Asia	145	Western Asia			Lebanon	422	LB	LBN
001	World	142	Asia	145	Western Asia			Oman	512	OM	OMN
001	World	142	Asia	145	Western Asia			Qatar	634	QA	QAT
001	World	142	Asia	145	Western Asia			Saudi Arabia	682	SA	SAU
001	World	142	Asia	145	Western Asia			State of Palestine	275	PS	PSE
001	World	142	Asia	145	Western Asia			Syrian Arab Republic	760	SY	SYR
001	World	142	Asia	145	Western Asia			Türkiye	792	TR	TUR
001	World	142	Asia	145	Western Asia			United Arab Emirates	784	AE	ARE
001	World	142	Asia	145	Western Asia			Yemen	887	YE	YEM
001	World	150	Europe	151	Eastern Europe			Belarus	112	BY	BLR
001	World	150	Europe	151	Eastern Europe			Bulgaria	100	BG	BGR
001	World	150	Europe	151	Eastern Europe			Czechia	203	CZ	CZE
001	World	150	Europe	151	Eastern Europe			Hungary	348	HU	HUN
001	World	150	Europe	151	Eastern Europe			Poland	616	PL	POL
001	World	150	Europe	151	Eastern Europe			Republic of Moldova	498	MD	MDA
001	World	150	Europe	151	Eastern Europe			Romania	642	RO	ROU
001	World	150	Europe	151	Eastern Europe			Russian Federation	643	RU	RUS
001	World	150	Europe	151	Eastern Europe			Slovakia	703	SK	SVK
001	World	150	Europe	151	Eastern Europe			Ukraine	804	UA	UKR
001	World	150	Europe	154	Northern Europe			Åland Islands	248	AX	ALA
001	World	150	Europe	154	Northern Europe			Denmark	208	DK	DNK
001	World	150	Europe	154	Northern Europe			Estonia	233	EE	EST
001	World	150	Europe	154	Northern Europe			Faroe Islands	234	FO	FRO
001	World	150	Europe	154	Northern Europe			Finland	246	FI	FIN
001	World	150	Europe	154	Northern Europe			Guernsey	831	GG	GGY
001	World	150	Europe	154	Northern Europe			Iceland	352	IS	ISL
001	World	150	Europe	154	Northern Europe			Ireland	372	IE	IRL
001	World	150	Europe	154	Northern Europe			Isle of Man	833	IM	IMN
001	World	150	Europe	154	Northern Europe			Jersey	832	JE	JEY
001	World	150	Europe	154	Northern Europe			Latvia	428	LV	LVA
001	World	150	Europe	154	Northern Europe			Lithuania	440	LT	LTU
001	World	150	Europe	154	Northern Europe			Norway	578	NO	NOR
001	World	150	Europe	154	Northern Europe			Svalbard and Jan Mayen Islands	744	SJ	SJM
001	World	150	Europe	154	Northern Europe			Sweden	752	SE	SWE
001	World	150	Europe	154	Northern Europe			United Kingdom of Great Britain and Northern Ireland	826	GB	GBR
001	World	150	Europe	039	Southern Europe			Albania	008	AL	ALB
001	World	150	Europe	039	Southern Europe			Andorra	020	AD	AND
001	World	150	Europe	039	Southern Europe			Bosnia and Herzegovina	070	BA	BIH
001	World	150	Europe	039	Southern Europe			Croatia	191	HR	HRV
001	World	150	Europe	039	Southern Europe			Gibraltar	292	GI	GIB
001	World	150	Europe	039	Southern Europe			Greece	300	GR	GRC
001	World	150	Europe	039	Southern Europe			Holy See	336	VA	VAT
001	World	150	Europe	039	Southern Europe			Italy	380	IT	ITA
001	World	150	Europe	039	Southern Europe			Malta	470	MT	MLT
001	World	150	Europe	039	Southern Europe			Montenegro	499	ME	MNE
001	World	150	Europe	039	Southern Europe			North Macedonia	807	MK	MKD
001	World	150	Europe	039	Southern Europe			Portugal	620	PT	PRT
001	World	150	Europe	039	Southern Europe			San Marino	674	SM	SMR
001	World	150	Europe	039	Southern Europe			Serbia	688	RS	SRB
001	World	150	Europe	039	Southern Europe			Slovenia	705	SI	SVN
001	World	150	Europe	039	Southern Europe			Spain	724	ES	ESP
001	World	150	Europe	155	Western Europe			Austria	040	AT	AUT
001	World	150	Europe	155	Western Europe			Belgium	056	BE	BEL
001	World	150	Europe	155	Western Europe			France	250	FR	FRA
001	World	150	Europe	155	Western Europe			Germany	276	DE	DEU
001	World	150	Europe	155	Western Europe			Liechtenstein	438	LI	LIE
001	World	150	Europe	155	Western Europe			Luxembourg	442	LU	LUX
001	World	150	Europe	155	Western Europe			Monaco	492	MC	MCO
001	World	150	Europe	155	Western Europe			Netherlands (Kingdom of the)	528	NL	NLD
001	World	150	Europe	155	Western Europe			Switzerland	756	CH	CHE
001	World	009	Oceania	053	Australia and New Zealand			Australia	036	AU	AUS
001	World	009	Oceania	053	Australia and New Zealand			Christmas Island	162	CX	CXR
001	World	009	Oceania	053	Australia and New Zealand			Cocos (Keeling) Islands	166	CC	CCK
001	World	009	Oceania	053	Australia and New Zealand			Heard Island and McDonald Islands	334	HM	HMD
001	World	009	Oceania	053	Australia and New Zealand			New Zealand	554	NZ	NZL
001	World	009	Oceania	053	Australia and New Zealand			Norfolk Island	574	NF	NFK
001	World	009	Oceania	054	Melanesia			Fiji	242	FJ	FJI
001	World	009	Oceania	054	Melanesia			New Caledonia	540	NC	NCL
001	World	009	Oceania	054	Melanesia			Papua New Guinea	598	PG	PNG
001	World	009	Oceania	054	Melanesia			Solomon Islands	090	SB	SLB
001	World	009	Oceania	054	Melanesia			Vanuatu	548	VU	VUT
001	World	009	Oceania	057	Micronesia			Guam	316	GU	GUM
001	World	009	Oceania	057	Micronesia			Kiribati	296	KI	KIR
001	World	009	Oceania	057	Micronesia			Marshall Islands	584	MH	MHL
001	World	009	Oceania	057	Micronesia			Micronesia (Federated States of)	583	FM	FSM
001	World	009	Oceania	057	Micronesia			Nauru	520	NR	NRU
001	World	009	Oceania	057	Micronesia			Northern Mariana Islands	580	MP	MNP
001	World	009	Oceania	057	Micronesia			Palau	585	PW	PLW
001	World	009	Oceania	057	Micronesia			United States Minor Outlying Islands	581	UM	UMI
001	World	009	Oceania	061	Polynesia			American Samoa	016	AS	ASM
001	World	009	Oceania	061	Polynesia			Cook Islands	184	CK	COK
001	World	009	Oceania	061	Polynesia			French Polynesia	258	PF	PYF
001	World	009	Oceania	061	Polynesia			Niue	570	NU	NIU
001	World	009	Oceania	061	Polynesia			Pitcairn	612	PN	PCN
001	World	009	Oceania	061	Polynesia			Samoa	882	WS	WSM
001	World	009	Oceania	061	Polynesia			Tokelau	772	TK	TKL
001	World	009	Oceania	061	Polynesia			Tonga	776	TO	TON
001	World	009	Oceania	061	Polynesia			Tuvalu	798	TV	TUV
001	World	009	Oceania	061	Polynesia			Wallis and Futuna Islands	876	WF	WLF
\.


--
-- Data for Name: iso_639_3; Type: TABLE DATA; Schema: languages; Owner: -
--

COPY languages.iso_639_3 (iso639_3_id, iso639_3_b, iso639_3_t, iso639_1, iso_scope, iso_type, ref_name, iso_comment) FROM stdin;
aaa	\N	\N	\N	I	L	Ghotuo	\N
aab	\N	\N	\N	I	L	Alumu-Tesu	\N
aac	\N	\N	\N	I	L	Ari	\N
aad	\N	\N	\N	I	L	Amal	\N
aae	\N	\N	\N	I	L	Arbëreshë Albanian	\N
aaf	\N	\N	\N	I	L	Aranadan	\N
aag	\N	\N	\N	I	L	Ambrak	\N
aah	\N	\N	\N	I	L	Abu' Arapesh	\N
aai	\N	\N	\N	I	L	Arifama-Miniafia	\N
aak	\N	\N	\N	I	L	Ankave	\N
aal	\N	\N	\N	I	L	Afade	\N
aan	\N	\N	\N	I	L	Anambé	\N
aao	\N	\N	\N	I	L	Algerian Saharan Arabic	\N
aap	\N	\N	\N	I	L	Pará Arára	\N
aaq	\N	\N	\N	I	E	Eastern Abnaki	\N
aar	aar	aar	aa	I	L	Afar	\N
aas	\N	\N	\N	I	L	Aasáx	\N
aat	\N	\N	\N	I	L	Arvanitika Albanian	\N
aau	\N	\N	\N	I	L	Abau	\N
aaw	\N	\N	\N	I	L	Solong	\N
aax	\N	\N	\N	I	L	Mandobo Atas	\N
aaz	\N	\N	\N	I	L	Amarasi	\N
aba	\N	\N	\N	I	L	Abé	\N
abb	\N	\N	\N	I	L	Bankon	\N
abc	\N	\N	\N	I	L	Ambala Ayta	\N
abd	\N	\N	\N	I	L	Manide	\N
abe	\N	\N	\N	I	L	Western Abnaki	\N
abf	\N	\N	\N	I	L	Abai Sungai	\N
abg	\N	\N	\N	I	L	Abaga	\N
abh	\N	\N	\N	I	L	Tajiki Arabic	\N
abi	\N	\N	\N	I	L	Abidji	\N
abj	\N	\N	\N	I	E	Aka-Bea	\N
abk	abk	abk	ab	I	L	Abkhazian	\N
abl	\N	\N	\N	I	L	Lampung Nyo	\N
abm	\N	\N	\N	I	L	Abanyom	\N
abn	\N	\N	\N	I	L	Abua	\N
abo	\N	\N	\N	I	L	Abon	\N
abp	\N	\N	\N	I	L	Abellen Ayta	\N
abq	\N	\N	\N	I	L	Abaza	\N
abr	\N	\N	\N	I	L	Abron	\N
abs	\N	\N	\N	I	L	Ambonese Malay	\N
abt	\N	\N	\N	I	L	Ambulas	\N
abu	\N	\N	\N	I	L	Abure	\N
abv	\N	\N	\N	I	L	Baharna Arabic	\N
abw	\N	\N	\N	I	L	Pal	\N
abx	\N	\N	\N	I	L	Inabaknon	\N
aby	\N	\N	\N	I	L	Aneme Wake	\N
abz	\N	\N	\N	I	L	Abui	\N
aca	\N	\N	\N	I	L	Achagua	\N
acb	\N	\N	\N	I	L	Áncá	\N
acd	\N	\N	\N	I	L	Gikyode	\N
ace	ace	ace	\N	I	L	Achinese	\N
acf	\N	\N	\N	I	L	Saint Lucian Creole French	\N
ach	ach	ach	\N	I	L	Acoli	\N
aci	\N	\N	\N	I	E	Aka-Cari	\N
ack	\N	\N	\N	I	E	Aka-Kora	\N
acl	\N	\N	\N	I	E	Akar-Bale	\N
acm	\N	\N	\N	I	L	Mesopotamian Arabic	\N
acn	\N	\N	\N	I	L	Achang	\N
acp	\N	\N	\N	I	L	Eastern Acipa	\N
acq	\N	\N	\N	I	L	Ta'izzi-Adeni Arabic	\N
acr	\N	\N	\N	I	L	Achi	\N
acs	\N	\N	\N	I	E	Acroá	\N
act	\N	\N	\N	I	L	Achterhoeks	\N
acu	\N	\N	\N	I	L	Achuar-Shiwiar	\N
acv	\N	\N	\N	I	L	Achumawi	\N
acw	\N	\N	\N	I	L	Hijazi Arabic	\N
acx	\N	\N	\N	I	L	Omani Arabic	\N
acy	\N	\N	\N	I	L	Cypriot Arabic	\N
acz	\N	\N	\N	I	L	Acheron	\N
ada	ada	ada	\N	I	L	Adangme	\N
adb	\N	\N	\N	I	L	Atauran	\N
add	\N	\N	\N	I	L	Lidzonka	\N
ade	\N	\N	\N	I	L	Adele	\N
adf	\N	\N	\N	I	L	Dhofari Arabic	\N
adg	\N	\N	\N	I	L	Andegerebinha	\N
adh	\N	\N	\N	I	L	Adhola	\N
adi	\N	\N	\N	I	L	Adi	\N
adj	\N	\N	\N	I	L	Adioukrou	\N
adl	\N	\N	\N	I	L	Galo	\N
adn	\N	\N	\N	I	L	Adang	\N
ado	\N	\N	\N	I	L	Abu	\N
adq	\N	\N	\N	I	L	Adangbe	\N
adr	\N	\N	\N	I	L	Adonara	\N
ads	\N	\N	\N	I	L	Adamorobe Sign Language	\N
adt	\N	\N	\N	I	L	Adnyamathanha	\N
adu	\N	\N	\N	I	L	Aduge	\N
adw	\N	\N	\N	I	L	Amundava	\N
adx	\N	\N	\N	I	L	Amdo Tibetan	\N
ady	ady	ady	\N	I	L	Adyghe	\N
adz	\N	\N	\N	I	L	Adzera	\N
aea	\N	\N	\N	I	E	Areba	\N
aeb	\N	\N	\N	I	L	Tunisian Arabic	\N
aec	\N	\N	\N	I	L	Saidi Arabic	\N
aed	\N	\N	\N	I	L	Argentine Sign Language	\N
aee	\N	\N	\N	I	L	Northeast Pashai	\N
aek	\N	\N	\N	I	L	Haeke	\N
ael	\N	\N	\N	I	L	Ambele	\N
aem	\N	\N	\N	I	L	Arem	\N
aen	\N	\N	\N	I	L	Armenian Sign Language	\N
aeq	\N	\N	\N	I	L	Aer	\N
aer	\N	\N	\N	I	L	Eastern Arrernte	\N
aes	\N	\N	\N	I	E	Alsea	\N
aeu	\N	\N	\N	I	L	Akeu	\N
aew	\N	\N	\N	I	L	Ambakich	\N
aey	\N	\N	\N	I	L	Amele	\N
aez	\N	\N	\N	I	L	Aeka	\N
afb	\N	\N	\N	I	L	Gulf Arabic	\N
afd	\N	\N	\N	I	L	Andai	\N
afe	\N	\N	\N	I	L	Putukwam	\N
afg	\N	\N	\N	I	L	Afghan Sign Language	\N
afh	afh	afh	\N	I	C	Afrihili	\N
afi	\N	\N	\N	I	L	Akrukay	\N
afk	\N	\N	\N	I	L	Nanubae	\N
afn	\N	\N	\N	I	L	Defaka	\N
afo	\N	\N	\N	I	L	Eloyi	\N
afp	\N	\N	\N	I	L	Tapei	\N
afr	afr	afr	af	I	L	Afrikaans	\N
afs	\N	\N	\N	I	L	Afro-Seminole Creole	\N
aft	\N	\N	\N	I	L	Afitti	\N
afu	\N	\N	\N	I	L	Awutu	\N
afz	\N	\N	\N	I	L	Obokuitai	\N
aga	\N	\N	\N	I	E	Aguano	\N
agb	\N	\N	\N	I	L	Legbo	\N
agc	\N	\N	\N	I	L	Agatu	\N
agd	\N	\N	\N	I	L	Agarabi	\N
age	\N	\N	\N	I	L	Angal	\N
agf	\N	\N	\N	I	L	Arguni	\N
agg	\N	\N	\N	I	L	Angor	\N
agh	\N	\N	\N	I	L	Ngelima	\N
agi	\N	\N	\N	I	L	Agariya	\N
agj	\N	\N	\N	I	L	Argobba	\N
agk	\N	\N	\N	I	L	Isarog Agta	\N
agl	\N	\N	\N	I	L	Fembe	\N
agm	\N	\N	\N	I	L	Angaataha	\N
agn	\N	\N	\N	I	L	Agutaynen	\N
ago	\N	\N	\N	I	L	Tainae	\N
agq	\N	\N	\N	I	L	Aghem	\N
agr	\N	\N	\N	I	L	Aguaruna	\N
ags	\N	\N	\N	I	L	Esimbi	\N
agt	\N	\N	\N	I	L	Central Cagayan Agta	\N
agu	\N	\N	\N	I	L	Aguacateco	\N
agv	\N	\N	\N	I	L	Remontado Dumagat	\N
agw	\N	\N	\N	I	L	Kahua	\N
agx	\N	\N	\N	I	L	Aghul	\N
agy	\N	\N	\N	I	L	Southern Alta	\N
agz	\N	\N	\N	I	L	Mt. Iriga Agta	\N
aha	\N	\N	\N	I	L	Ahanta	\N
ahb	\N	\N	\N	I	L	Axamb	\N
ahg	\N	\N	\N	I	L	Qimant	\N
ahh	\N	\N	\N	I	L	Aghu	\N
ahi	\N	\N	\N	I	L	Tiagbamrin Aizi	\N
ahk	\N	\N	\N	I	L	Akha	\N
ahl	\N	\N	\N	I	L	Igo	\N
ahm	\N	\N	\N	I	L	Mobumrin Aizi	\N
ahn	\N	\N	\N	I	L	Àhàn	\N
aho	\N	\N	\N	I	E	Ahom	\N
ahp	\N	\N	\N	I	L	Aproumu Aizi	\N
ahr	\N	\N	\N	I	L	Ahirani	\N
ahs	\N	\N	\N	I	L	Ashe	\N
aht	\N	\N	\N	I	L	Ahtena	\N
aia	\N	\N	\N	I	L	Arosi	\N
aib	\N	\N	\N	I	L	Ainu (China)	\N
aic	\N	\N	\N	I	L	Ainbai	\N
aid	\N	\N	\N	I	E	Alngith	\N
aie	\N	\N	\N	I	L	Amara	\N
aif	\N	\N	\N	I	L	Agi	\N
aig	\N	\N	\N	I	L	Antigua and Barbuda Creole English	\N
aih	\N	\N	\N	I	L	Ai-Cham	\N
aii	\N	\N	\N	I	L	Assyrian Neo-Aramaic	\N
aij	\N	\N	\N	I	L	Lishanid Noshan	\N
aik	\N	\N	\N	I	L	Ake	\N
ail	\N	\N	\N	I	L	Aimele	\N
aim	\N	\N	\N	I	L	Aimol	\N
ain	ain	ain	\N	I	L	Ainu (Japan)	\N
aio	\N	\N	\N	I	L	Aiton	\N
aip	\N	\N	\N	I	L	Burumakok	\N
aiq	\N	\N	\N	I	L	Aimaq	\N
air	\N	\N	\N	I	L	Airoran	\N
ait	\N	\N	\N	I	E	Arikem	\N
aiw	\N	\N	\N	I	L	Aari	\N
aix	\N	\N	\N	I	L	Aighon	\N
aiy	\N	\N	\N	I	L	Ali	\N
aja	\N	\N	\N	I	L	Aja (South Sudan)	\N
ajg	\N	\N	\N	I	L	Aja (Benin)	\N
aji	\N	\N	\N	I	L	Ajië	\N
ajn	\N	\N	\N	I	L	Andajin	\N
ajs	\N	\N	\N	I	L	Algerian Jewish Sign Language	\N
aju	\N	\N	\N	I	L	Judeo-Moroccan Arabic	\N
ajw	\N	\N	\N	I	E	Ajawa	\N
ajz	\N	\N	\N	I	L	Amri Karbi	\N
aka	aka	aka	ak	M	L	Akan	\N
akb	\N	\N	\N	I	L	Batak Angkola	\N
akc	\N	\N	\N	I	L	Mpur	\N
akd	\N	\N	\N	I	L	Ukpet-Ehom	\N
ake	\N	\N	\N	I	L	Akawaio	\N
akf	\N	\N	\N	I	L	Akpa	\N
akg	\N	\N	\N	I	L	Anakalangu	\N
akh	\N	\N	\N	I	L	Angal Heneng	\N
aki	\N	\N	\N	I	L	Aiome	\N
akj	\N	\N	\N	I	E	Aka-Jeru	\N
akk	akk	akk	\N	I	H	Akkadian	\N
akl	\N	\N	\N	I	L	Aklanon	\N
akm	\N	\N	\N	I	E	Aka-Bo	\N
ako	\N	\N	\N	I	L	Akurio	\N
akp	\N	\N	\N	I	L	Siwu	\N
akq	\N	\N	\N	I	L	Ak	\N
akr	\N	\N	\N	I	L	Araki	\N
aks	\N	\N	\N	I	L	Akaselem	\N
akt	\N	\N	\N	I	L	Akolet	\N
aku	\N	\N	\N	I	L	Akum	\N
akv	\N	\N	\N	I	L	Akhvakh	\N
akw	\N	\N	\N	I	L	Akwa	\N
akx	\N	\N	\N	I	E	Aka-Kede	\N
aky	\N	\N	\N	I	E	Aka-Kol	\N
akz	\N	\N	\N	I	L	Alabama	\N
ala	\N	\N	\N	I	L	Alago	\N
alc	\N	\N	\N	I	L	Qawasqar	\N
ald	\N	\N	\N	I	L	Alladian	\N
ale	ale	ale	\N	I	L	Aleut	\N
alf	\N	\N	\N	I	L	Alege	\N
alh	\N	\N	\N	I	L	Alawa	\N
ali	\N	\N	\N	I	L	Amaimon	\N
alj	\N	\N	\N	I	L	Alangan	\N
alk	\N	\N	\N	I	L	Alak	\N
all	\N	\N	\N	I	L	Allar	\N
alm	\N	\N	\N	I	L	Amblong	\N
aln	\N	\N	\N	I	L	Gheg Albanian	\N
alo	\N	\N	\N	I	L	Larike-Wakasihu	\N
alp	\N	\N	\N	I	L	Alune	\N
alq	\N	\N	\N	I	L	Algonquin	\N
alr	\N	\N	\N	I	L	Alutor	\N
als	\N	\N	\N	I	L	Tosk Albanian	\N
alt	alt	alt	\N	I	L	Southern Altai	\N
alu	\N	\N	\N	I	L	'Are'are	\N
alw	\N	\N	\N	I	L	Alaba-K’abeena	\N
alx	\N	\N	\N	I	L	Amol	\N
aly	\N	\N	\N	I	L	Alyawarr	\N
alz	\N	\N	\N	I	L	Alur	\N
ama	\N	\N	\N	I	E	Amanayé	\N
amb	\N	\N	\N	I	L	Ambo	\N
amc	\N	\N	\N	I	L	Amahuaca	\N
ame	\N	\N	\N	I	L	Yanesha'	\N
amf	\N	\N	\N	I	L	Hamer-Banna	\N
amg	\N	\N	\N	I	L	Amurdak	\N
amh	amh	amh	am	I	L	Amharic	\N
ami	\N	\N	\N	I	L	Amis	\N
amj	\N	\N	\N	I	L	Amdang	\N
amk	\N	\N	\N	I	L	Ambai	\N
aml	\N	\N	\N	I	L	War-Jaintia	\N
amm	\N	\N	\N	I	L	Ama (Papua New Guinea)	\N
amn	\N	\N	\N	I	L	Amanab	\N
amo	\N	\N	\N	I	L	Amo	\N
amp	\N	\N	\N	I	L	Alamblak	\N
amq	\N	\N	\N	I	L	Amahai	\N
amr	\N	\N	\N	I	L	Amarakaeri	\N
ams	\N	\N	\N	I	L	Southern Amami-Oshima	\N
amt	\N	\N	\N	I	L	Amto	\N
amu	\N	\N	\N	I	L	Guerrero Amuzgo	\N
amv	\N	\N	\N	I	L	Ambelau	\N
amw	\N	\N	\N	I	L	Western Neo-Aramaic	\N
amx	\N	\N	\N	I	L	Anmatyerre	\N
amy	\N	\N	\N	I	L	Ami	\N
amz	\N	\N	\N	I	E	Atampaya	\N
ana	\N	\N	\N	I	E	Andaqui	\N
anb	\N	\N	\N	I	E	Andoa	\N
anc	\N	\N	\N	I	L	Ngas	\N
and	\N	\N	\N	I	L	Ansus	\N
ane	\N	\N	\N	I	L	Xârâcùù	\N
anf	\N	\N	\N	I	L	Animere	\N
ang	ang	ang	\N	I	H	Old English (ca. 450-1100)	\N
anh	\N	\N	\N	I	L	Nend	\N
ani	\N	\N	\N	I	L	Andi	\N
anj	\N	\N	\N	I	L	Anor	\N
ank	\N	\N	\N	I	L	Goemai	\N
anl	\N	\N	\N	I	L	Anu-Hkongso Chin	\N
anm	\N	\N	\N	I	L	Anal	\N
ann	\N	\N	\N	I	L	Obolo	\N
ano	\N	\N	\N	I	L	Andoque	\N
anp	anp	anp	\N	I	L	Angika	\N
anq	\N	\N	\N	I	L	Jarawa (India)	\N
anr	\N	\N	\N	I	L	Andh	\N
ans	\N	\N	\N	I	E	Anserma	\N
ant	\N	\N	\N	I	L	Antakarinya	\N
anu	\N	\N	\N	I	L	Anuak	\N
anv	\N	\N	\N	I	L	Denya	\N
anw	\N	\N	\N	I	L	Anaang	\N
anx	\N	\N	\N	I	L	Andra-Hus	\N
any	\N	\N	\N	I	L	Anyin	\N
anz	\N	\N	\N	I	L	Anem	\N
aoa	\N	\N	\N	I	L	Angolar	\N
aob	\N	\N	\N	I	L	Abom	\N
aoc	\N	\N	\N	I	L	Pemon	\N
aod	\N	\N	\N	I	L	Andarum	\N
aoe	\N	\N	\N	I	L	Angal Enen	\N
aof	\N	\N	\N	I	L	Bragat	\N
aog	\N	\N	\N	I	L	Angoram	\N
aoi	\N	\N	\N	I	L	Anindilyakwa	\N
aoj	\N	\N	\N	I	L	Mufian	\N
aok	\N	\N	\N	I	L	Arhö	\N
aol	\N	\N	\N	I	L	Alor	\N
aom	\N	\N	\N	I	L	Ömie	\N
aon	\N	\N	\N	I	L	Bumbita Arapesh	\N
aor	\N	\N	\N	I	E	Aore	\N
aos	\N	\N	\N	I	L	Taikat	\N
aot	\N	\N	\N	I	L	Atong (India)	\N
aou	\N	\N	\N	I	L	A'ou	\N
aox	\N	\N	\N	I	L	Atorada	\N
aoz	\N	\N	\N	I	L	Uab Meto	\N
apb	\N	\N	\N	I	L	Sa'a	\N
apc	\N	\N	\N	I	L	Levantine Arabic	\N
apd	\N	\N	\N	I	L	Sudanese Arabic	\N
ape	\N	\N	\N	I	L	Bukiyip	\N
apf	\N	\N	\N	I	L	Pahanan Agta	\N
apg	\N	\N	\N	I	L	Ampanang	\N
aph	\N	\N	\N	I	L	Athpariya	\N
api	\N	\N	\N	I	L	Apiaká	\N
apj	\N	\N	\N	I	L	Jicarilla Apache	\N
apk	\N	\N	\N	I	L	Kiowa Apache	\N
apl	\N	\N	\N	I	L	Lipan Apache	\N
apm	\N	\N	\N	I	L	Mescalero-Chiricahua Apache	\N
apn	\N	\N	\N	I	L	Apinayé	\N
apo	\N	\N	\N	I	L	Ambul	\N
app	\N	\N	\N	I	L	Apma	\N
apq	\N	\N	\N	I	L	A-Pucikwar	\N
apr	\N	\N	\N	I	L	Arop-Lokep	\N
aps	\N	\N	\N	I	L	Arop-Sissano	\N
apt	\N	\N	\N	I	L	Apatani	\N
apu	\N	\N	\N	I	L	Apurinã	\N
apv	\N	\N	\N	I	E	Alapmunte	\N
apw	\N	\N	\N	I	L	Western Apache	\N
apx	\N	\N	\N	I	L	Aputai	\N
apy	\N	\N	\N	I	L	Apalaí	\N
apz	\N	\N	\N	I	L	Safeyoka	\N
aqc	\N	\N	\N	I	L	Archi	\N
aqd	\N	\N	\N	I	L	Ampari Dogon	\N
aqg	\N	\N	\N	I	L	Arigidi	\N
aqk	\N	\N	\N	I	L	Aninka	\N
aqm	\N	\N	\N	I	L	Atohwaim	\N
aqn	\N	\N	\N	I	L	Northern Alta	\N
aqp	\N	\N	\N	I	E	Atakapa	\N
aqr	\N	\N	\N	I	L	Arhâ	\N
aqt	\N	\N	\N	I	L	Angaité	\N
aqz	\N	\N	\N	I	L	Akuntsu	\N
ara	ara	ara	ar	M	L	Arabic	\N
arb	\N	\N	\N	I	L	Standard Arabic	\N
arc	arc	arc	\N	I	H	Official Aramaic (700-300 BCE)	\N
ard	\N	\N	\N	I	E	Arabana	\N
are	\N	\N	\N	I	L	Western Arrarnta	\N
arg	arg	arg	an	I	L	Aragonese	\N
arh	\N	\N	\N	I	L	Arhuaco	\N
ari	\N	\N	\N	I	L	Arikara	\N
arj	\N	\N	\N	I	E	Arapaso	\N
ark	\N	\N	\N	I	L	Arikapú	\N
arl	\N	\N	\N	I	L	Arabela	\N
arn	arn	arn	\N	I	L	Mapudungun	\N
aro	\N	\N	\N	I	L	Araona	\N
arp	arp	arp	\N	I	L	Arapaho	\N
arq	\N	\N	\N	I	L	Algerian Arabic	\N
arr	\N	\N	\N	I	L	Karo (Brazil)	\N
ars	\N	\N	\N	I	L	Najdi Arabic	\N
aru	\N	\N	\N	I	E	Aruá (Amazonas State)	\N
arv	\N	\N	\N	I	L	Arbore	\N
arw	arw	arw	\N	I	L	Arawak	\N
arx	\N	\N	\N	I	L	Aruá (Rodonia State)	\N
ary	\N	\N	\N	I	L	Moroccan Arabic	\N
arz	\N	\N	\N	I	L	Egyptian Arabic	\N
asa	\N	\N	\N	I	L	Asu (Tanzania)	\N
asb	\N	\N	\N	I	L	Assiniboine	\N
asc	\N	\N	\N	I	L	Casuarina Coast Asmat	\N
ase	\N	\N	\N	I	L	American Sign Language	\N
asf	\N	\N	\N	I	L	Auslan	\N
asg	\N	\N	\N	I	L	Cishingini	\N
ash	\N	\N	\N	I	E	Abishira	\N
asi	\N	\N	\N	I	L	Buruwai	\N
asj	\N	\N	\N	I	L	Sari	\N
ask	\N	\N	\N	I	L	Ashkun	\N
asl	\N	\N	\N	I	L	Asilulu	\N
asm	asm	asm	as	I	L	Assamese	\N
asn	\N	\N	\N	I	L	Xingú Asuriní	\N
aso	\N	\N	\N	I	L	Dano	\N
asp	\N	\N	\N	I	L	Algerian Sign Language	\N
asq	\N	\N	\N	I	L	Austrian Sign Language	\N
asr	\N	\N	\N	I	L	Asuri	\N
ass	\N	\N	\N	I	L	Ipulo	\N
ast	ast	ast	\N	I	L	Asturian	\N
asu	\N	\N	\N	I	L	Tocantins Asurini	\N
asv	\N	\N	\N	I	L	Asoa	\N
asw	\N	\N	\N	I	L	Australian Aborigines Sign Language	\N
asx	\N	\N	\N	I	L	Muratayak	\N
asy	\N	\N	\N	I	L	Yaosakor Asmat	\N
asz	\N	\N	\N	I	L	As	\N
ata	\N	\N	\N	I	L	Pele-Ata	\N
atb	\N	\N	\N	I	L	Zaiwa	\N
atc	\N	\N	\N	I	E	Atsahuaca	\N
atd	\N	\N	\N	I	L	Ata Manobo	\N
ate	\N	\N	\N	I	L	Atemble	\N
atg	\N	\N	\N	I	L	Ivbie North-Okpela-Arhe	\N
ati	\N	\N	\N	I	L	Attié	\N
atj	\N	\N	\N	I	L	Atikamekw	\N
atk	\N	\N	\N	I	L	Ati	\N
atl	\N	\N	\N	I	L	Mt. Iraya Agta	\N
atm	\N	\N	\N	I	L	Ata	\N
atn	\N	\N	\N	I	L	Ashtiani	\N
ato	\N	\N	\N	I	L	Atong (Cameroon)	\N
atp	\N	\N	\N	I	L	Pudtol Atta	\N
atq	\N	\N	\N	I	L	Aralle-Tabulahan	\N
atr	\N	\N	\N	I	L	Waimiri-Atroari	\N
ats	\N	\N	\N	I	L	Gros Ventre	\N
att	\N	\N	\N	I	L	Pamplona Atta	\N
atu	\N	\N	\N	I	L	Reel	\N
atv	\N	\N	\N	I	L	Northern Altai	\N
atw	\N	\N	\N	I	L	Atsugewi	\N
atx	\N	\N	\N	I	L	Arutani	\N
aty	\N	\N	\N	I	L	Aneityum	\N
atz	\N	\N	\N	I	L	Arta	\N
aua	\N	\N	\N	I	L	Asumboa	\N
aub	\N	\N	\N	I	L	Alugu	\N
auc	\N	\N	\N	I	L	Waorani	\N
aud	\N	\N	\N	I	L	Anuta	\N
aug	\N	\N	\N	I	L	Aguna	\N
auh	\N	\N	\N	I	L	Aushi	\N
aui	\N	\N	\N	I	L	Anuki	\N
auj	\N	\N	\N	I	L	Awjilah	\N
auk	\N	\N	\N	I	L	Heyo	\N
aul	\N	\N	\N	I	L	Aulua	\N
aum	\N	\N	\N	I	L	Asu (Nigeria)	\N
aun	\N	\N	\N	I	L	Molmo One	\N
auo	\N	\N	\N	I	E	Auyokawa	\N
aup	\N	\N	\N	I	L	Makayam	\N
auq	\N	\N	\N	I	L	Anus	\N
aur	\N	\N	\N	I	L	Aruek	\N
aut	\N	\N	\N	I	L	Austral	\N
auu	\N	\N	\N	I	L	Auye	\N
auw	\N	\N	\N	I	L	Awyi	\N
aux	\N	\N	\N	I	E	Aurá	\N
auy	\N	\N	\N	I	L	Awiyaana	\N
auz	\N	\N	\N	I	L	Uzbeki Arabic	\N
ava	ava	ava	av	I	L	Avaric	\N
avb	\N	\N	\N	I	L	Avau	\N
avd	\N	\N	\N	I	L	Alviri-Vidari	\N
ave	ave	ave	ae	I	H	Avestan	\N
avi	\N	\N	\N	I	L	Avikam	\N
avk	\N	\N	\N	I	C	Kotava	\N
avl	\N	\N	\N	I	L	Eastern Egyptian Bedawi Arabic	\N
avm	\N	\N	\N	I	E	Angkamuthi	\N
avn	\N	\N	\N	I	L	Avatime	\N
avo	\N	\N	\N	I	E	Agavotaguerra	\N
avs	\N	\N	\N	I	E	Aushiri	\N
avt	\N	\N	\N	I	L	Au	\N
avu	\N	\N	\N	I	L	Avokaya	\N
avv	\N	\N	\N	I	L	Avá-Canoeiro	\N
awa	awa	awa	\N	I	L	Awadhi	\N
awb	\N	\N	\N	I	L	Awa (Papua New Guinea)	\N
awc	\N	\N	\N	I	L	Cicipu	\N
awe	\N	\N	\N	I	L	Awetí	\N
awg	\N	\N	\N	I	E	Anguthimri	\N
awh	\N	\N	\N	I	L	Awbono	\N
awi	\N	\N	\N	I	L	Aekyom	\N
awk	\N	\N	\N	I	E	Awabakal	\N
awm	\N	\N	\N	I	L	Arawum	\N
awn	\N	\N	\N	I	L	Awngi	\N
awo	\N	\N	\N	I	L	Awak	\N
awr	\N	\N	\N	I	L	Awera	\N
aws	\N	\N	\N	I	L	South Awyu	\N
awt	\N	\N	\N	I	L	Araweté	\N
awu	\N	\N	\N	I	L	Central Awyu	\N
awv	\N	\N	\N	I	L	Jair Awyu	\N
aww	\N	\N	\N	I	L	Awun	\N
awx	\N	\N	\N	I	L	Awara	\N
awy	\N	\N	\N	I	L	Edera Awyu	\N
axb	\N	\N	\N	I	E	Abipon	\N
axe	\N	\N	\N	I	E	Ayerrerenge	\N
axg	\N	\N	\N	I	E	Mato Grosso Arára	\N
axk	\N	\N	\N	I	L	Yaka (Central African Republic)	\N
axl	\N	\N	\N	I	E	Lower Southern Aranda	\N
axm	\N	\N	\N	I	H	Middle Armenian	\N
axx	\N	\N	\N	I	L	Xârâgurè	\N
aya	\N	\N	\N	I	L	Awar	\N
ayb	\N	\N	\N	I	L	Ayizo Gbe	\N
ayc	\N	\N	\N	I	L	Southern Aymara	\N
ayd	\N	\N	\N	I	E	Ayabadhu	\N
aye	\N	\N	\N	I	L	Ayere	\N
ayg	\N	\N	\N	I	L	Ginyanga	\N
ayh	\N	\N	\N	I	L	Hadrami Arabic	\N
ayi	\N	\N	\N	I	L	Leyigha	\N
ayk	\N	\N	\N	I	L	Akuku	\N
ayl	\N	\N	\N	I	L	Libyan Arabic	\N
aym	aym	aym	ay	M	L	Aymara	\N
ayn	\N	\N	\N	I	L	Sanaani Arabic	\N
ayo	\N	\N	\N	I	L	Ayoreo	\N
ayp	\N	\N	\N	I	L	North Mesopotamian Arabic	\N
ayq	\N	\N	\N	I	L	Ayi (Papua New Guinea)	\N
ayr	\N	\N	\N	I	L	Central Aymara	\N
ays	\N	\N	\N	I	L	Sorsogon Ayta	\N
ayt	\N	\N	\N	I	L	Magbukun Ayta	\N
ayu	\N	\N	\N	I	L	Ayu	\N
ayz	\N	\N	\N	I	L	Mai Brat	\N
aza	\N	\N	\N	I	L	Azha	\N
azb	\N	\N	\N	I	L	South Azerbaijani	\N
azd	\N	\N	\N	I	L	Eastern Durango Nahuatl	\N
aze	aze	aze	az	M	L	Azerbaijani	\N
azg	\N	\N	\N	I	L	San Pedro Amuzgos Amuzgo	\N
azj	\N	\N	\N	I	L	North Azerbaijani	\N
azm	\N	\N	\N	I	L	Ipalapa Amuzgo	\N
azn	\N	\N	\N	I	L	Western Durango Nahuatl	\N
azo	\N	\N	\N	I	L	Awing	\N
azt	\N	\N	\N	I	L	Faire Atta	\N
azz	\N	\N	\N	I	L	Highland Puebla Nahuatl	\N
baa	\N	\N	\N	I	L	Babatana	\N
bab	\N	\N	\N	I	L	Bainouk-Gunyuño	\N
bac	\N	\N	\N	I	L	Badui	\N
bae	\N	\N	\N	I	E	Baré	\N
baf	\N	\N	\N	I	L	Nubaca	\N
bag	\N	\N	\N	I	L	Tuki	\N
bah	\N	\N	\N	I	L	Bahamas Creole English	\N
baj	\N	\N	\N	I	L	Barakai	\N
bak	bak	bak	ba	I	L	Bashkir	\N
bal	bal	bal	\N	M	L	Baluchi	\N
bam	bam	bam	bm	I	L	Bambara	\N
ban	ban	ban	\N	I	L	Balinese	\N
bao	\N	\N	\N	I	L	Waimaha	\N
bap	\N	\N	\N	I	L	Bantawa	\N
bar	\N	\N	\N	I	L	Bavarian	\N
bas	bas	bas	\N	I	L	Basa (Cameroon)	\N
bau	\N	\N	\N	I	L	Bada (Nigeria)	\N
bav	\N	\N	\N	I	L	Vengo	\N
baw	\N	\N	\N	I	L	Bambili-Bambui	\N
bax	\N	\N	\N	I	L	Bamun	\N
bay	\N	\N	\N	I	L	Batuley	\N
bba	\N	\N	\N	I	L	Baatonum	\N
bbb	\N	\N	\N	I	L	Barai	\N
bbc	\N	\N	\N	I	L	Batak Toba	\N
bbd	\N	\N	\N	I	L	Bau	\N
bbe	\N	\N	\N	I	L	Bangba	\N
bbf	\N	\N	\N	I	L	Baibai	\N
bbg	\N	\N	\N	I	L	Barama	\N
bbh	\N	\N	\N	I	L	Bugan	\N
bbi	\N	\N	\N	I	L	Barombi	\N
bbj	\N	\N	\N	I	L	Ghomálá'	\N
bbk	\N	\N	\N	I	L	Babanki	\N
bbl	\N	\N	\N	I	L	Bats	\N
bbm	\N	\N	\N	I	L	Babango	\N
bbn	\N	\N	\N	I	L	Uneapa	\N
bbo	\N	\N	\N	I	L	Northern Bobo Madaré	\N
bbp	\N	\N	\N	I	L	West Central Banda	\N
bbq	\N	\N	\N	I	L	Bamali	\N
bbr	\N	\N	\N	I	L	Girawa	\N
bbs	\N	\N	\N	I	L	Bakpinka	\N
bbt	\N	\N	\N	I	L	Mburku	\N
bbu	\N	\N	\N	I	L	Kulung (Nigeria)	\N
bbv	\N	\N	\N	I	L	Karnai	\N
bbw	\N	\N	\N	I	L	Baba	\N
bbx	\N	\N	\N	I	L	Bubia	\N
bby	\N	\N	\N	I	L	Befang	\N
bca	\N	\N	\N	I	L	Central Bai	\N
bcb	\N	\N	\N	I	L	Bainouk-Samik	\N
bcc	\N	\N	\N	I	L	Southern Balochi	\N
bcd	\N	\N	\N	I	L	North Babar	\N
bce	\N	\N	\N	I	L	Bamenyam	\N
bcf	\N	\N	\N	I	L	Bamu	\N
bcg	\N	\N	\N	I	L	Baga Pokur	\N
bch	\N	\N	\N	I	L	Bariai	\N
bci	\N	\N	\N	I	L	Baoulé	\N
bcj	\N	\N	\N	I	L	Bardi	\N
bck	\N	\N	\N	I	L	Bunuba	\N
bcl	\N	\N	\N	I	L	Central Bikol	\N
bcm	\N	\N	\N	I	L	Bannoni	\N
bcn	\N	\N	\N	I	L	Bali (Nigeria)	\N
bco	\N	\N	\N	I	L	Kaluli	\N
bcp	\N	\N	\N	I	L	Bali (Democratic Republic of Congo)	\N
bcq	\N	\N	\N	I	L	Bench	\N
bcr	\N	\N	\N	I	L	Babine	\N
bcs	\N	\N	\N	I	L	Kohumono	\N
bct	\N	\N	\N	I	L	Bendi	\N
bcu	\N	\N	\N	I	L	Awad Bing	\N
bcv	\N	\N	\N	I	L	Shoo-Minda-Nye	\N
bcw	\N	\N	\N	I	L	Bana	\N
bcy	\N	\N	\N	I	L	Bacama	\N
bcz	\N	\N	\N	I	L	Bainouk-Gunyaamolo	\N
bda	\N	\N	\N	I	L	Bayot	\N
bdb	\N	\N	\N	I	L	Basap	\N
bdc	\N	\N	\N	I	L	Emberá-Baudó	\N
bdd	\N	\N	\N	I	L	Bunama	\N
bde	\N	\N	\N	I	L	Bade	\N
bdf	\N	\N	\N	I	L	Biage	\N
bdg	\N	\N	\N	I	L	Bonggi	\N
bdh	\N	\N	\N	I	L	Baka (South Sudan)	\N
bdi	\N	\N	\N	I	L	Burun	\N
bdj	\N	\N	\N	I	L	Bai (South Sudan)	\N
bdk	\N	\N	\N	I	L	Budukh	\N
bdl	\N	\N	\N	I	L	Indonesian Bajau	\N
bdm	\N	\N	\N	I	L	Buduma	\N
bdn	\N	\N	\N	I	L	Baldemu	\N
bdo	\N	\N	\N	I	L	Morom	\N
bdp	\N	\N	\N	I	L	Bende	\N
bdq	\N	\N	\N	I	L	Bahnar	\N
bdr	\N	\N	\N	I	L	West Coast Bajau	\N
bds	\N	\N	\N	I	L	Burunge	\N
bdt	\N	\N	\N	I	L	Bokoto	\N
bdu	\N	\N	\N	I	L	Oroko	\N
bdv	\N	\N	\N	I	L	Bodo Parja	\N
bdw	\N	\N	\N	I	L	Baham	\N
bdx	\N	\N	\N	I	L	Budong-Budong	\N
bdy	\N	\N	\N	I	L	Bandjalang	\N
bdz	\N	\N	\N	I	L	Badeshi	\N
bea	\N	\N	\N	I	L	Beaver	\N
beb	\N	\N	\N	I	L	Bebele	\N
bec	\N	\N	\N	I	L	Iceve-Maci	\N
bed	\N	\N	\N	I	L	Bedoanas	\N
bee	\N	\N	\N	I	L	Byangsi	\N
bef	\N	\N	\N	I	L	Benabena	\N
beg	\N	\N	\N	I	L	Belait	\N
beh	\N	\N	\N	I	L	Biali	\N
bei	\N	\N	\N	I	L	Bekati'	\N
bej	bej	bej	\N	I	L	Beja	\N
bek	\N	\N	\N	I	L	Bebeli	\N
bel	bel	bel	be	I	L	Belarusian	\N
bem	bem	bem	\N	I	L	Bemba (Zambia)	\N
ben	ben	ben	bn	I	L	Bengali	\N
beo	\N	\N	\N	I	L	Beami	\N
bep	\N	\N	\N	I	L	Besoa	\N
beq	\N	\N	\N	I	L	Beembe	\N
bes	\N	\N	\N	I	L	Besme	\N
bet	\N	\N	\N	I	L	Guiberoua Béte	\N
beu	\N	\N	\N	I	L	Blagar	\N
bev	\N	\N	\N	I	L	Daloa Bété	\N
bew	\N	\N	\N	I	L	Betawi	\N
bex	\N	\N	\N	I	L	Jur Modo	\N
bey	\N	\N	\N	I	L	Beli (Papua New Guinea)	\N
bez	\N	\N	\N	I	L	Bena (Tanzania)	\N
bfa	\N	\N	\N	I	L	Bari	\N
bfb	\N	\N	\N	I	L	Pauri Bareli	\N
bfc	\N	\N	\N	I	L	Panyi Bai	\N
bfd	\N	\N	\N	I	L	Bafut	\N
bfe	\N	\N	\N	I	L	Betaf	\N
bff	\N	\N	\N	I	L	Bofi	\N
bfg	\N	\N	\N	I	L	Busang Kayan	\N
bfh	\N	\N	\N	I	L	Blafe	\N
bfi	\N	\N	\N	I	L	British Sign Language	\N
bfj	\N	\N	\N	I	L	Bafanji	\N
bfk	\N	\N	\N	I	L	Ban Khor Sign Language	\N
bfl	\N	\N	\N	I	L	Banda-Ndélé	\N
bfm	\N	\N	\N	I	L	Mmen	\N
bfn	\N	\N	\N	I	L	Bunak	\N
bfo	\N	\N	\N	I	L	Malba Birifor	\N
bfp	\N	\N	\N	I	L	Beba	\N
bfq	\N	\N	\N	I	L	Badaga	\N
bfr	\N	\N	\N	I	L	Bazigar	\N
bfs	\N	\N	\N	I	L	Southern Bai	\N
bft	\N	\N	\N	I	L	Balti	\N
bfu	\N	\N	\N	I	L	Gahri	\N
bfw	\N	\N	\N	I	L	Bondo	\N
bfx	\N	\N	\N	I	L	Bantayanon	\N
bfy	\N	\N	\N	I	L	Bagheli	\N
bfz	\N	\N	\N	I	L	Mahasu Pahari	\N
bga	\N	\N	\N	I	L	Gwamhi-Wuri	\N
bgb	\N	\N	\N	I	L	Bobongko	\N
bgc	\N	\N	\N	I	L	Haryanvi	\N
bgd	\N	\N	\N	I	L	Rathwi Bareli	\N
bge	\N	\N	\N	I	L	Bauria	\N
bgf	\N	\N	\N	I	L	Bangandu	\N
bgg	\N	\N	\N	I	L	Bugun	\N
bgi	\N	\N	\N	I	L	Giangan	\N
bgj	\N	\N	\N	I	L	Bangolan	\N
bgk	\N	\N	\N	I	L	Bit	\N
bgl	\N	\N	\N	I	L	Bo (Laos)	\N
bgn	\N	\N	\N	I	L	Western Balochi	\N
bgo	\N	\N	\N	I	L	Baga Koga	\N
bgp	\N	\N	\N	I	L	Eastern Balochi	\N
bgq	\N	\N	\N	I	L	Bagri	\N
bgr	\N	\N	\N	I	L	Bawm Chin	\N
bgs	\N	\N	\N	I	L	Tagabawa	\N
bgt	\N	\N	\N	I	L	Bughotu	\N
bgu	\N	\N	\N	I	L	Mbongno	\N
bgv	\N	\N	\N	I	L	Warkay-Bipim	\N
bgw	\N	\N	\N	I	L	Bhatri	\N
bgx	\N	\N	\N	I	L	Balkan Gagauz Turkish	\N
bgy	\N	\N	\N	I	L	Benggoi	\N
bgz	\N	\N	\N	I	L	Banggai	\N
bha	\N	\N	\N	I	L	Bharia	\N
bhb	\N	\N	\N	I	L	Bhili	\N
bhc	\N	\N	\N	I	L	Biga	\N
bhd	\N	\N	\N	I	L	Bhadrawahi	\N
bhe	\N	\N	\N	I	L	Bhaya	\N
bhf	\N	\N	\N	I	L	Odiai	\N
bhg	\N	\N	\N	I	L	Binandere	\N
bhh	\N	\N	\N	I	L	Bukharic	\N
bhi	\N	\N	\N	I	L	Bhilali	\N
bhj	\N	\N	\N	I	L	Bahing	\N
bhl	\N	\N	\N	I	L	Bimin	\N
bhm	\N	\N	\N	I	L	Bathari	\N
bhn	\N	\N	\N	I	L	Bohtan Neo-Aramaic	\N
bho	bho	bho	\N	I	L	Bhojpuri	\N
bhp	\N	\N	\N	I	L	Bima	\N
bhq	\N	\N	\N	I	L	Tukang Besi South	\N
bhr	\N	\N	\N	I	L	Bara Malagasy	\N
bhs	\N	\N	\N	I	L	Buwal	\N
bht	\N	\N	\N	I	L	Bhattiyali	\N
bhu	\N	\N	\N	I	L	Bhunjia	\N
bhv	\N	\N	\N	I	L	Bahau	\N
bhw	\N	\N	\N	I	L	Biak	\N
bhx	\N	\N	\N	I	L	Bhalay	\N
bhy	\N	\N	\N	I	L	Bhele	\N
bhz	\N	\N	\N	I	L	Bada (Indonesia)	\N
bia	\N	\N	\N	I	L	Badimaya	\N
bib	\N	\N	\N	I	L	Bissa	\N
bid	\N	\N	\N	I	L	Bidiyo	\N
bie	\N	\N	\N	I	L	Bepour	\N
bif	\N	\N	\N	I	L	Biafada	\N
big	\N	\N	\N	I	L	Biangai	\N
bik	bik	bik	\N	M	L	Bikol	\N
bil	\N	\N	\N	I	L	Bile	\N
bim	\N	\N	\N	I	L	Bimoba	\N
bin	bin	bin	\N	I	L	Bini	\N
bio	\N	\N	\N	I	L	Nai	\N
bip	\N	\N	\N	I	L	Bila	\N
biq	\N	\N	\N	I	L	Bipi	\N
bir	\N	\N	\N	I	L	Bisorio	\N
bis	bis	bis	bi	I	L	Bislama	\N
bit	\N	\N	\N	I	L	Berinomo	\N
biu	\N	\N	\N	I	L	Biete	\N
biv	\N	\N	\N	I	L	Southern Birifor	\N
biw	\N	\N	\N	I	L	Kol (Cameroon)	\N
bix	\N	\N	\N	I	L	Bijori	\N
biy	\N	\N	\N	I	L	Birhor	\N
biz	\N	\N	\N	I	L	Baloi	\N
bja	\N	\N	\N	I	L	Budza	\N
bjb	\N	\N	\N	I	E	Banggarla	\N
bjc	\N	\N	\N	I	L	Bariji	\N
bje	\N	\N	\N	I	L	Biao-Jiao Mien	\N
bjf	\N	\N	\N	I	L	Barzani Jewish Neo-Aramaic	\N
bjg	\N	\N	\N	I	L	Bidyogo	\N
bjh	\N	\N	\N	I	L	Bahinemo	\N
bji	\N	\N	\N	I	L	Burji	\N
bjj	\N	\N	\N	I	L	Kanauji	\N
bjk	\N	\N	\N	I	L	Barok	\N
bjl	\N	\N	\N	I	L	Bulu (Papua New Guinea)	\N
bjm	\N	\N	\N	I	L	Bajelani	\N
bjn	\N	\N	\N	I	L	Banjar	\N
bjo	\N	\N	\N	I	L	Mid-Southern Banda	\N
bjp	\N	\N	\N	I	L	Fanamaket	\N
bjr	\N	\N	\N	I	L	Binumarien	\N
bjs	\N	\N	\N	I	L	Bajan	\N
bjt	\N	\N	\N	I	L	Balanta-Ganja	\N
bju	\N	\N	\N	I	L	Busuu	\N
bjv	\N	\N	\N	I	L	Bedjond	\N
bjw	\N	\N	\N	I	L	Bakwé	\N
bjx	\N	\N	\N	I	L	Banao Itneg	\N
bjy	\N	\N	\N	I	E	Bayali	\N
bjz	\N	\N	\N	I	L	Baruga	\N
bka	\N	\N	\N	I	L	Kyak	\N
bkc	\N	\N	\N	I	L	Baka (Cameroon)	\N
bkd	\N	\N	\N	I	L	Binukid	\N
bkf	\N	\N	\N	I	L	Beeke	\N
bkg	\N	\N	\N	I	L	Buraka	\N
bkh	\N	\N	\N	I	L	Bakoko	\N
bki	\N	\N	\N	I	L	Baki	\N
bkj	\N	\N	\N	I	L	Pande	\N
bkk	\N	\N	\N	I	L	Brokskat	\N
bkl	\N	\N	\N	I	L	Berik	\N
bkm	\N	\N	\N	I	L	Kom (Cameroon)	\N
bkn	\N	\N	\N	I	L	Bukitan	\N
bko	\N	\N	\N	I	L	Kwa'	\N
bkp	\N	\N	\N	I	L	Boko (Democratic Republic of Congo)	\N
bkq	\N	\N	\N	I	L	Bakairí	\N
bkr	\N	\N	\N	I	L	Bakumpai	\N
bks	\N	\N	\N	I	L	Northern Sorsoganon	\N
bkt	\N	\N	\N	I	L	Boloki	\N
bku	\N	\N	\N	I	L	Buhid	\N
bkv	\N	\N	\N	I	L	Bekwarra	\N
bkw	\N	\N	\N	I	L	Bekwel	\N
bkx	\N	\N	\N	I	L	Baikeno	\N
bky	\N	\N	\N	I	L	Bokyi	\N
bkz	\N	\N	\N	I	L	Bungku	\N
bla	bla	bla	\N	I	L	Siksika	\N
blb	\N	\N	\N	I	L	Bilua	\N
blc	\N	\N	\N	I	L	Bella Coola	\N
bld	\N	\N	\N	I	L	Bolango	\N
ble	\N	\N	\N	I	L	Balanta-Kentohe	\N
blf	\N	\N	\N	I	L	Buol	\N
blh	\N	\N	\N	I	L	Kuwaa	\N
bli	\N	\N	\N	I	L	Bolia	\N
blj	\N	\N	\N	I	L	Bolongan	\N
blk	\N	\N	\N	I	L	Pa'o Karen	\N
bll	\N	\N	\N	I	E	Biloxi	\N
blm	\N	\N	\N	I	L	Beli (South Sudan)	\N
bln	\N	\N	\N	I	L	Southern Catanduanes Bikol	\N
blo	\N	\N	\N	I	L	Anii	\N
blp	\N	\N	\N	I	L	Blablanga	\N
blq	\N	\N	\N	I	L	Baluan-Pam	\N
blr	\N	\N	\N	I	L	Blang	\N
bls	\N	\N	\N	I	L	Balaesang	\N
blt	\N	\N	\N	I	L	Tai Dam	\N
blv	\N	\N	\N	I	L	Kibala	\N
blw	\N	\N	\N	I	L	Balangao	\N
blx	\N	\N	\N	I	L	Mag-Indi Ayta	\N
bly	\N	\N	\N	I	L	Notre	\N
blz	\N	\N	\N	I	L	Balantak	\N
bma	\N	\N	\N	I	L	Lame	\N
bmb	\N	\N	\N	I	L	Bembe	\N
bmc	\N	\N	\N	I	L	Biem	\N
bmd	\N	\N	\N	I	L	Baga Manduri	\N
bme	\N	\N	\N	I	L	Limassa	\N
bmf	\N	\N	\N	I	L	Bom-Kim	\N
bmg	\N	\N	\N	I	L	Bamwe	\N
bmh	\N	\N	\N	I	L	Kein	\N
bmi	\N	\N	\N	I	L	Bagirmi	\N
bmj	\N	\N	\N	I	L	Bote-Majhi	\N
bmk	\N	\N	\N	I	L	Ghayavi	\N
bml	\N	\N	\N	I	L	Bomboli	\N
bmm	\N	\N	\N	I	L	Northern Betsimisaraka Malagasy	\N
bmn	\N	\N	\N	I	E	Bina (Papua New Guinea)	\N
bmo	\N	\N	\N	I	L	Bambalang	\N
bmp	\N	\N	\N	I	L	Bulgebi	\N
bmq	\N	\N	\N	I	L	Bomu	\N
bmr	\N	\N	\N	I	L	Muinane	\N
bms	\N	\N	\N	I	L	Bilma Kanuri	\N
bmt	\N	\N	\N	I	L	Biao Mon	\N
bmu	\N	\N	\N	I	L	Somba-Siawari	\N
bmv	\N	\N	\N	I	L	Bum	\N
bmw	\N	\N	\N	I	L	Bomwali	\N
bmx	\N	\N	\N	I	L	Baimak	\N
bmz	\N	\N	\N	I	L	Baramu	\N
bna	\N	\N	\N	I	L	Bonerate	\N
bnb	\N	\N	\N	I	L	Bookan	\N
bnc	\N	\N	\N	M	L	Bontok	\N
bnd	\N	\N	\N	I	L	Banda (Indonesia)	\N
bne	\N	\N	\N	I	L	Bintauna	\N
bnf	\N	\N	\N	I	L	Masiwang	\N
bng	\N	\N	\N	I	L	Benga	\N
bni	\N	\N	\N	I	L	Bangi	\N
bnj	\N	\N	\N	I	L	Eastern Tawbuid	\N
bnk	\N	\N	\N	I	L	Bierebo	\N
bnl	\N	\N	\N	I	L	Boon	\N
bnm	\N	\N	\N	I	L	Batanga	\N
bnn	\N	\N	\N	I	L	Bunun	\N
bno	\N	\N	\N	I	L	Bantoanon	\N
bnp	\N	\N	\N	I	L	Bola	\N
bnq	\N	\N	\N	I	L	Bantik	\N
bnr	\N	\N	\N	I	L	Butmas-Tur	\N
bns	\N	\N	\N	I	L	Bundeli	\N
bnu	\N	\N	\N	I	L	Bentong	\N
bnv	\N	\N	\N	I	L	Bonerif	\N
bnw	\N	\N	\N	I	L	Bisis	\N
bnx	\N	\N	\N	I	L	Bangubangu	\N
bny	\N	\N	\N	I	L	Bintulu	\N
bnz	\N	\N	\N	I	L	Beezen	\N
boa	\N	\N	\N	I	L	Bora	\N
bob	\N	\N	\N	I	L	Aweer	\N
bod	tib	bod	bo	I	L	Tibetan	\N
boe	\N	\N	\N	I	L	Mundabli	\N
bof	\N	\N	\N	I	L	Bolon	\N
bog	\N	\N	\N	I	L	Bamako Sign Language	\N
boh	\N	\N	\N	I	L	Boma	\N
boi	\N	\N	\N	I	E	Barbareño	\N
boj	\N	\N	\N	I	L	Anjam	\N
bok	\N	\N	\N	I	L	Bonjo	\N
bol	\N	\N	\N	I	L	Bole	\N
bom	\N	\N	\N	I	L	Berom	\N
bon	\N	\N	\N	I	L	Bine	\N
boo	\N	\N	\N	I	L	Tiemacèwè Bozo	\N
bop	\N	\N	\N	I	L	Bonkiman	\N
boq	\N	\N	\N	I	L	Bogaya	\N
bor	\N	\N	\N	I	L	Borôro	\N
bos	bos	bos	bs	I	L	Bosnian	\N
bot	\N	\N	\N	I	L	Bongo	\N
bou	\N	\N	\N	I	L	Bondei	\N
bov	\N	\N	\N	I	L	Tuwuli	\N
bow	\N	\N	\N	I	E	Rema	\N
box	\N	\N	\N	I	L	Buamu	\N
boy	\N	\N	\N	I	L	Bodo (Central African Republic)	\N
boz	\N	\N	\N	I	L	Tiéyaxo Bozo	\N
bpa	\N	\N	\N	I	L	Daakaka	\N
bpc	\N	\N	\N	I	L	Mbuk	\N
bpd	\N	\N	\N	I	L	Banda-Banda	\N
bpe	\N	\N	\N	I	L	Bauni	\N
bpg	\N	\N	\N	I	L	Bonggo	\N
bph	\N	\N	\N	I	L	Botlikh	\N
bpi	\N	\N	\N	I	L	Bagupi	\N
bpj	\N	\N	\N	I	L	Binji	\N
bpk	\N	\N	\N	I	L	Orowe	\N
bpl	\N	\N	\N	I	L	Broome Pearling Lugger Pidgin	\N
bpm	\N	\N	\N	I	L	Biyom	\N
bpn	\N	\N	\N	I	L	Dzao Min	\N
bpo	\N	\N	\N	I	L	Anasi	\N
bpp	\N	\N	\N	I	L	Kaure	\N
bpq	\N	\N	\N	I	L	Banda Malay	\N
bpr	\N	\N	\N	I	L	Koronadal Blaan	\N
bps	\N	\N	\N	I	L	Sarangani Blaan	\N
bpt	\N	\N	\N	I	E	Barrow Point	\N
bpu	\N	\N	\N	I	L	Bongu	\N
bpv	\N	\N	\N	I	L	Bian Marind	\N
bpw	\N	\N	\N	I	L	Bo (Papua New Guinea)	\N
bpx	\N	\N	\N	I	L	Palya Bareli	\N
bpy	\N	\N	\N	I	L	Bishnupriya	\N
bpz	\N	\N	\N	I	L	Bilba	\N
bqa	\N	\N	\N	I	L	Tchumbuli	\N
bqb	\N	\N	\N	I	L	Bagusa	\N
bqc	\N	\N	\N	I	L	Boko (Benin)	\N
bqd	\N	\N	\N	I	L	Bung	\N
bqf	\N	\N	\N	I	E	Baga Kaloum	\N
bqg	\N	\N	\N	I	L	Bago-Kusuntu	\N
bqh	\N	\N	\N	I	L	Baima	\N
bqi	\N	\N	\N	I	L	Bakhtiari	\N
bqj	\N	\N	\N	I	L	Bandial	\N
bqk	\N	\N	\N	I	L	Banda-Mbrès	\N
bql	\N	\N	\N	I	L	Bilakura	\N
bqm	\N	\N	\N	I	L	Wumboko	\N
bqn	\N	\N	\N	I	L	Bulgarian Sign Language	\N
bqo	\N	\N	\N	I	L	Balo	\N
bqp	\N	\N	\N	I	L	Busa	\N
bqq	\N	\N	\N	I	L	Biritai	\N
bqr	\N	\N	\N	I	L	Burusu	\N
bqs	\N	\N	\N	I	L	Bosngun	\N
bqt	\N	\N	\N	I	L	Bamukumbit	\N
bqu	\N	\N	\N	I	L	Boguru	\N
bqv	\N	\N	\N	I	L	Koro Wachi	\N
bqw	\N	\N	\N	I	L	Buru (Nigeria)	\N
bqx	\N	\N	\N	I	L	Baangi	\N
bqy	\N	\N	\N	I	L	Bengkala Sign Language	\N
bqz	\N	\N	\N	I	L	Bakaka	\N
bra	bra	bra	\N	I	L	Braj	\N
brb	\N	\N	\N	I	L	Brao	\N
brc	\N	\N	\N	I	E	Berbice Creole Dutch	\N
brd	\N	\N	\N	I	L	Baraamu	\N
bre	bre	bre	br	I	L	Breton	\N
brf	\N	\N	\N	I	L	Bira	\N
brg	\N	\N	\N	I	L	Baure	\N
brh	\N	\N	\N	I	L	Brahui	\N
bri	\N	\N	\N	I	L	Mokpwe	\N
brj	\N	\N	\N	I	L	Bieria	\N
brk	\N	\N	\N	I	E	Birked	\N
brl	\N	\N	\N	I	L	Birwa	\N
brm	\N	\N	\N	I	L	Barambu	\N
brn	\N	\N	\N	I	L	Boruca	\N
bro	\N	\N	\N	I	L	Brokkat	\N
brp	\N	\N	\N	I	L	Barapasi	\N
brq	\N	\N	\N	I	L	Breri	\N
brr	\N	\N	\N	I	L	Birao	\N
brs	\N	\N	\N	I	L	Baras	\N
brt	\N	\N	\N	I	L	Bitare	\N
bru	\N	\N	\N	I	L	Eastern Bru	\N
brv	\N	\N	\N	I	L	Western Bru	\N
brw	\N	\N	\N	I	L	Bellari	\N
brx	\N	\N	\N	I	L	Bodo (India)	\N
bry	\N	\N	\N	I	L	Burui	\N
brz	\N	\N	\N	I	L	Bilbil	\N
bsa	\N	\N	\N	I	L	Abinomn	\N
bsb	\N	\N	\N	I	L	Brunei Bisaya	\N
bsc	\N	\N	\N	I	L	Bassari	\N
bse	\N	\N	\N	I	L	Wushi	\N
bsf	\N	\N	\N	I	L	Bauchi	\N
bsg	\N	\N	\N	I	L	Bashkardi	\N
bsh	\N	\N	\N	I	L	Kati	\N
bsi	\N	\N	\N	I	L	Bassossi	\N
bsj	\N	\N	\N	I	L	Bangwinji	\N
bsk	\N	\N	\N	I	L	Burushaski	\N
bsl	\N	\N	\N	I	E	Basa-Gumna	\N
bsm	\N	\N	\N	I	L	Busami	\N
bsn	\N	\N	\N	I	L	Barasana-Eduria	\N
bso	\N	\N	\N	I	L	Buso	\N
bsp	\N	\N	\N	I	L	Baga Sitemu	\N
bsq	\N	\N	\N	I	L	Bassa	\N
bsr	\N	\N	\N	I	L	Bassa-Kontagora	\N
bss	\N	\N	\N	I	L	Akoose	\N
bst	\N	\N	\N	I	L	Basketo	\N
bsu	\N	\N	\N	I	L	Bahonsuai	\N
bsv	\N	\N	\N	I	E	Baga Sobané	\N
bsw	\N	\N	\N	I	L	Baiso	\N
bsx	\N	\N	\N	I	L	Yangkam	\N
bsy	\N	\N	\N	I	L	Sabah Bisaya	\N
bta	\N	\N	\N	I	L	Bata	\N
btc	\N	\N	\N	I	L	Bati (Cameroon)	\N
btd	\N	\N	\N	I	L	Batak Dairi	\N
bte	\N	\N	\N	I	E	Gamo-Ningi	\N
btf	\N	\N	\N	I	L	Birgit	\N
btg	\N	\N	\N	I	L	Gagnoa Bété	\N
bth	\N	\N	\N	I	L	Biatah Bidayuh	\N
bti	\N	\N	\N	I	L	Burate	\N
btj	\N	\N	\N	I	L	Bacanese Malay	\N
btm	\N	\N	\N	I	L	Batak Mandailing	\N
btn	\N	\N	\N	I	L	Ratagnon	\N
bto	\N	\N	\N	I	L	Rinconada Bikol	\N
btp	\N	\N	\N	I	L	Budibud	\N
btq	\N	\N	\N	I	L	Batek	\N
btr	\N	\N	\N	I	L	Baetora	\N
bts	\N	\N	\N	I	L	Batak Simalungun	\N
btt	\N	\N	\N	I	L	Bete-Bendi	\N
btu	\N	\N	\N	I	L	Batu	\N
btv	\N	\N	\N	I	L	Bateri	\N
btw	\N	\N	\N	I	L	Butuanon	\N
btx	\N	\N	\N	I	L	Batak Karo	\N
bty	\N	\N	\N	I	L	Bobot	\N
btz	\N	\N	\N	I	L	Batak Alas-Kluet	\N
bua	bua	bua	\N	M	L	Buriat	\N
bub	\N	\N	\N	I	L	Bua	\N
buc	\N	\N	\N	I	L	Bushi	\N
bud	\N	\N	\N	I	L	Ntcham	\N
bue	\N	\N	\N	I	E	Beothuk	\N
buf	\N	\N	\N	I	L	Bushoong	\N
bug	bug	bug	\N	I	L	Buginese	\N
buh	\N	\N	\N	I	L	Younuo Bunu	\N
bui	\N	\N	\N	I	L	Bongili	\N
buj	\N	\N	\N	I	L	Basa-Gurmana	\N
buk	\N	\N	\N	I	L	Bugawac	\N
bul	bul	bul	bg	I	L	Bulgarian	\N
bum	\N	\N	\N	I	L	Bulu (Cameroon)	\N
bun	\N	\N	\N	I	L	Sherbro	\N
buo	\N	\N	\N	I	L	Terei	\N
bup	\N	\N	\N	I	L	Busoa	\N
buq	\N	\N	\N	I	L	Brem	\N
bus	\N	\N	\N	I	L	Bokobaru	\N
but	\N	\N	\N	I	L	Bungain	\N
buu	\N	\N	\N	I	L	Budu	\N
buv	\N	\N	\N	I	L	Bun	\N
buw	\N	\N	\N	I	L	Bubi	\N
bux	\N	\N	\N	I	L	Boghom	\N
buy	\N	\N	\N	I	L	Bullom So	\N
buz	\N	\N	\N	I	L	Bukwen	\N
bva	\N	\N	\N	I	L	Barein	\N
bvb	\N	\N	\N	I	L	Bube	\N
bvc	\N	\N	\N	I	L	Baelelea	\N
bvd	\N	\N	\N	I	L	Baeggu	\N
bve	\N	\N	\N	I	L	Berau Malay	\N
bvf	\N	\N	\N	I	L	Boor	\N
bvg	\N	\N	\N	I	L	Bonkeng	\N
bvh	\N	\N	\N	I	L	Bure	\N
bvi	\N	\N	\N	I	L	Belanda Viri	\N
bvj	\N	\N	\N	I	L	Baan	\N
bvk	\N	\N	\N	I	L	Bukat	\N
bvl	\N	\N	\N	I	L	Bolivian Sign Language	\N
bvm	\N	\N	\N	I	L	Bamunka	\N
bvn	\N	\N	\N	I	L	Buna	\N
bvo	\N	\N	\N	I	L	Bolgo	\N
bvp	\N	\N	\N	I	L	Bumang	\N
bvq	\N	\N	\N	I	L	Birri	\N
bvr	\N	\N	\N	I	L	Burarra	\N
bvt	\N	\N	\N	I	L	Bati (Indonesia)	\N
bvu	\N	\N	\N	I	L	Bukit Malay	\N
bvv	\N	\N	\N	I	E	Baniva	\N
bvw	\N	\N	\N	I	L	Boga	\N
bvx	\N	\N	\N	I	L	Dibole	\N
bvy	\N	\N	\N	I	L	Baybayanon	\N
bvz	\N	\N	\N	I	L	Bauzi	\N
bwa	\N	\N	\N	I	L	Bwatoo	\N
bwb	\N	\N	\N	I	L	Namosi-Naitasiri-Serua	\N
bwc	\N	\N	\N	I	L	Bwile	\N
bwd	\N	\N	\N	I	L	Bwaidoka	\N
bwe	\N	\N	\N	I	L	Bwe Karen	\N
bwf	\N	\N	\N	I	L	Boselewa	\N
bwg	\N	\N	\N	I	L	Barwe	\N
bwh	\N	\N	\N	I	L	Bishuo	\N
bwi	\N	\N	\N	I	L	Baniwa	\N
bwj	\N	\N	\N	I	L	Láá Láá Bwamu	\N
bwk	\N	\N	\N	I	L	Bauwaki	\N
bwl	\N	\N	\N	I	L	Bwela	\N
bwm	\N	\N	\N	I	L	Biwat	\N
bwn	\N	\N	\N	I	L	Wunai Bunu	\N
bwo	\N	\N	\N	I	L	Boro (Ethiopia)	\N
bwp	\N	\N	\N	I	L	Mandobo Bawah	\N
bwq	\N	\N	\N	I	L	Southern Bobo Madaré	\N
bwr	\N	\N	\N	I	L	Bura-Pabir	\N
bws	\N	\N	\N	I	L	Bomboma	\N
bwt	\N	\N	\N	I	L	Bafaw-Balong	\N
bwu	\N	\N	\N	I	L	Buli (Ghana)	\N
bww	\N	\N	\N	I	L	Bwa	\N
bwx	\N	\N	\N	I	L	Bu-Nao Bunu	\N
bwy	\N	\N	\N	I	L	Cwi Bwamu	\N
bwz	\N	\N	\N	I	L	Bwisi	\N
bxa	\N	\N	\N	I	L	Tairaha	\N
bxb	\N	\N	\N	I	L	Belanda Bor	\N
bxc	\N	\N	\N	I	L	Molengue	\N
bxd	\N	\N	\N	I	L	Pela	\N
bxe	\N	\N	\N	I	L	Birale	\N
bxf	\N	\N	\N	I	L	Bilur	\N
bxg	\N	\N	\N	I	L	Bangala	\N
bxh	\N	\N	\N	I	L	Buhutu	\N
bxi	\N	\N	\N	I	E	Pirlatapa	\N
bxj	\N	\N	\N	I	L	Bayungu	\N
bxk	\N	\N	\N	I	L	Bukusu	\N
bxl	\N	\N	\N	I	L	Jalkunan	\N
bxm	\N	\N	\N	I	L	Mongolia Buriat	\N
bxn	\N	\N	\N	I	L	Burduna	\N
bxo	\N	\N	\N	I	L	Barikanchi	\N
bxp	\N	\N	\N	I	L	Bebil	\N
bxq	\N	\N	\N	I	L	Beele	\N
bxr	\N	\N	\N	I	L	Russia Buriat	\N
bxs	\N	\N	\N	I	L	Busam	\N
bxu	\N	\N	\N	I	L	China Buriat	\N
bxv	\N	\N	\N	I	L	Berakou	\N
bxw	\N	\N	\N	I	L	Bankagooma	\N
bxz	\N	\N	\N	I	L	Binahari	\N
bya	\N	\N	\N	I	L	Batak	\N
byb	\N	\N	\N	I	L	Bikya	\N
byc	\N	\N	\N	I	L	Ubaghara	\N
byd	\N	\N	\N	I	L	Benyadu'	\N
bye	\N	\N	\N	I	L	Pouye	\N
byf	\N	\N	\N	I	L	Bete	\N
byg	\N	\N	\N	I	E	Baygo	\N
byh	\N	\N	\N	I	L	Bhujel	\N
byi	\N	\N	\N	I	L	Buyu	\N
byj	\N	\N	\N	I	L	Bina (Nigeria)	\N
byk	\N	\N	\N	I	L	Biao	\N
byl	\N	\N	\N	I	L	Bayono	\N
bym	\N	\N	\N	I	L	Bidjara	\N
byn	byn	byn	\N	I	L	Bilin	\N
byo	\N	\N	\N	I	L	Biyo	\N
byp	\N	\N	\N	I	L	Bumaji	\N
byq	\N	\N	\N	I	E	Basay	\N
byr	\N	\N	\N	I	L	Baruya	\N
bys	\N	\N	\N	I	L	Burak	\N
byt	\N	\N	\N	I	E	Berti	\N
byv	\N	\N	\N	I	L	Medumba	\N
byw	\N	\N	\N	I	L	Belhariya	\N
byx	\N	\N	\N	I	L	Qaqet	\N
byz	\N	\N	\N	I	L	Banaro	\N
bza	\N	\N	\N	I	L	Bandi	\N
bzb	\N	\N	\N	I	L	Andio	\N
bzc	\N	\N	\N	I	L	Southern Betsimisaraka Malagasy	\N
bzd	\N	\N	\N	I	L	Bribri	\N
bze	\N	\N	\N	I	L	Jenaama Bozo	\N
bzf	\N	\N	\N	I	L	Boikin	\N
bzg	\N	\N	\N	I	L	Babuza	\N
bzh	\N	\N	\N	I	L	Mapos Buang	\N
bzi	\N	\N	\N	I	L	Bisu	\N
bzj	\N	\N	\N	I	L	Belize Kriol English	\N
bzk	\N	\N	\N	I	L	Nicaragua Creole English	\N
bzl	\N	\N	\N	I	L	Boano (Sulawesi)	\N
bzm	\N	\N	\N	I	L	Bolondo	\N
bzn	\N	\N	\N	I	L	Boano (Maluku)	\N
bzo	\N	\N	\N	I	L	Bozaba	\N
bzp	\N	\N	\N	I	L	Kemberano	\N
bzq	\N	\N	\N	I	L	Buli (Indonesia)	\N
bzr	\N	\N	\N	I	E	Biri	\N
bzs	\N	\N	\N	I	L	Brazilian Sign Language	\N
bzt	\N	\N	\N	I	C	Brithenig	\N
bzu	\N	\N	\N	I	L	Burmeso	\N
bzv	\N	\N	\N	I	L	Naami	\N
bzw	\N	\N	\N	I	L	Basa (Nigeria)	\N
bzx	\N	\N	\N	I	L	Kɛlɛngaxo Bozo	\N
bzy	\N	\N	\N	I	L	Obanliku	\N
bzz	\N	\N	\N	I	L	Evant	\N
caa	\N	\N	\N	I	L	Chortí	\N
cab	\N	\N	\N	I	L	Garifuna	\N
cac	\N	\N	\N	I	L	Chuj	\N
cad	cad	cad	\N	I	L	Caddo	\N
cae	\N	\N	\N	I	L	Lehar	\N
caf	\N	\N	\N	I	L	Southern Carrier	\N
cag	\N	\N	\N	I	L	Nivaclé	\N
cah	\N	\N	\N	I	L	Cahuarano	\N
caj	\N	\N	\N	I	E	Chané	\N
cak	\N	\N	\N	I	L	Kaqchikel	\N
cal	\N	\N	\N	I	L	Carolinian	\N
cam	\N	\N	\N	I	L	Cemuhî	\N
can	\N	\N	\N	I	L	Chambri	\N
cao	\N	\N	\N	I	L	Chácobo	\N
cap	\N	\N	\N	I	L	Chipaya	\N
caq	\N	\N	\N	I	L	Car Nicobarese	\N
car	car	car	\N	I	L	Galibi Carib	\N
cas	\N	\N	\N	I	L	Tsimané	\N
cat	cat	cat	ca	I	L	Catalan	\N
cav	\N	\N	\N	I	L	Cavineña	\N
caw	\N	\N	\N	I	L	Callawalla	\N
cax	\N	\N	\N	I	L	Chiquitano	\N
cay	\N	\N	\N	I	L	Cayuga	\N
caz	\N	\N	\N	I	E	Canichana	\N
cbb	\N	\N	\N	I	L	Cabiyarí	\N
cbc	\N	\N	\N	I	L	Carapana	\N
cbd	\N	\N	\N	I	L	Carijona	\N
cbg	\N	\N	\N	I	L	Chimila	\N
cbi	\N	\N	\N	I	L	Chachi	\N
cbj	\N	\N	\N	I	L	Ede Cabe	\N
cbk	\N	\N	\N	I	L	Chavacano	\N
cbl	\N	\N	\N	I	L	Bualkhaw Chin	\N
cbn	\N	\N	\N	I	L	Nyahkur	\N
cbo	\N	\N	\N	I	L	Izora	\N
cbq	\N	\N	\N	I	L	Tsucuba	\N
cbr	\N	\N	\N	I	L	Cashibo-Cacataibo	\N
cbs	\N	\N	\N	I	L	Cashinahua	\N
cbt	\N	\N	\N	I	L	Chayahuita	\N
cbu	\N	\N	\N	I	L	Candoshi-Shapra	\N
cbv	\N	\N	\N	I	L	Cacua	\N
cbw	\N	\N	\N	I	L	Kinabalian	\N
cby	\N	\N	\N	I	L	Carabayo	\N
ccc	\N	\N	\N	I	L	Chamicuro	\N
ccd	\N	\N	\N	I	L	Cafundo Creole	\N
cce	\N	\N	\N	I	L	Chopi	\N
ccg	\N	\N	\N	I	L	Samba Daka	\N
cch	\N	\N	\N	I	L	Atsam	\N
ccj	\N	\N	\N	I	L	Kasanga	\N
ccl	\N	\N	\N	I	L	Cutchi-Swahili	\N
ccm	\N	\N	\N	I	L	Malaccan Creole Malay	\N
cco	\N	\N	\N	I	L	Comaltepec Chinantec	\N
ccp	\N	\N	\N	I	L	Chakma	\N
ccr	\N	\N	\N	I	E	Cacaopera	\N
cda	\N	\N	\N	I	L	Choni	\N
cde	\N	\N	\N	I	L	Chenchu	\N
cdf	\N	\N	\N	I	L	Chiru	\N
cdh	\N	\N	\N	I	L	Chambeali	\N
cdi	\N	\N	\N	I	L	Chodri	\N
cdj	\N	\N	\N	I	L	Churahi	\N
cdm	\N	\N	\N	I	L	Chepang	\N
cdn	\N	\N	\N	I	L	Chaudangsi	\N
cdo	\N	\N	\N	I	L	Min Dong Chinese	\N
cdr	\N	\N	\N	I	L	Cinda-Regi-Tiyal	\N
cds	\N	\N	\N	I	L	Chadian Sign Language	\N
cdy	\N	\N	\N	I	L	Chadong	\N
cdz	\N	\N	\N	I	L	Koda	\N
cea	\N	\N	\N	I	E	Lower Chehalis	\N
ceb	ceb	ceb	\N	I	L	Cebuano	\N
ceg	\N	\N	\N	I	L	Chamacoco	\N
cek	\N	\N	\N	I	L	Eastern Khumi Chin	\N
cen	\N	\N	\N	I	L	Cen	\N
ces	cze	ces	cs	I	L	Czech	\N
cet	\N	\N	\N	I	L	Centúúm	\N
cey	\N	\N	\N	I	L	Ekai Chin	\N
cfa	\N	\N	\N	I	L	Dijim-Bwilim	\N
cfd	\N	\N	\N	I	L	Cara	\N
cfg	\N	\N	\N	I	L	Como Karim	\N
cfm	\N	\N	\N	I	L	Falam Chin	\N
cga	\N	\N	\N	I	L	Changriwa	\N
cgc	\N	\N	\N	I	L	Kagayanen	\N
cgg	\N	\N	\N	I	L	Chiga	\N
cgk	\N	\N	\N	I	L	Chocangacakha	\N
cha	cha	cha	ch	I	L	Chamorro	\N
chb	chb	chb	\N	I	E	Chibcha	\N
chc	\N	\N	\N	I	E	Catawba	\N
chd	\N	\N	\N	I	L	Highland Oaxaca Chontal	\N
che	che	che	ce	I	L	Chechen	\N
chf	\N	\N	\N	I	L	Tabasco Chontal	\N
chg	chg	chg	\N	I	E	Chagatai	\N
chh	\N	\N	\N	I	E	Chinook	\N
chj	\N	\N	\N	I	L	Ojitlán Chinantec	\N
chk	chk	chk	\N	I	L	Chuukese	\N
chl	\N	\N	\N	I	L	Cahuilla	\N
chm	chm	chm	\N	M	L	Mari (Russia)	\N
chn	chn	chn	\N	I	L	Chinook jargon	\N
cho	cho	cho	\N	I	L	Choctaw	\N
chp	chp	chp	\N	I	L	Chipewyan	\N
chq	\N	\N	\N	I	L	Quiotepec Chinantec	\N
chr	chr	chr	\N	I	L	Cherokee	\N
cht	\N	\N	\N	I	E	Cholón	\N
chu	chu	chu	cu	I	H	Church Slavic	\N
chv	chv	chv	cv	I	L	Chuvash	\N
chw	\N	\N	\N	I	L	Chuwabu	\N
chx	\N	\N	\N	I	L	Chantyal	\N
chy	chy	chy	\N	I	L	Cheyenne	\N
chz	\N	\N	\N	I	L	Ozumacín Chinantec	\N
cia	\N	\N	\N	I	L	Cia-Cia	\N
cib	\N	\N	\N	I	L	Ci Gbe	\N
cic	\N	\N	\N	I	L	Chickasaw	\N
cid	\N	\N	\N	I	E	Chimariko	\N
cie	\N	\N	\N	I	L	Cineni	\N
cih	\N	\N	\N	I	L	Chinali	\N
cik	\N	\N	\N	I	L	Chitkuli Kinnauri	\N
cim	\N	\N	\N	I	L	Cimbrian	\N
cin	\N	\N	\N	I	L	Cinta Larga	\N
cip	\N	\N	\N	I	L	Chiapanec	\N
cir	\N	\N	\N	I	L	Tiri	\N
ciw	\N	\N	\N	I	L	Chippewa	\N
ciy	\N	\N	\N	I	L	Chaima	\N
cja	\N	\N	\N	I	L	Western Cham	\N
cje	\N	\N	\N	I	L	Chru	\N
cjh	\N	\N	\N	I	E	Upper Chehalis	\N
cji	\N	\N	\N	I	L	Chamalal	\N
cjk	\N	\N	\N	I	L	Chokwe	\N
cjm	\N	\N	\N	I	L	Eastern Cham	\N
cjn	\N	\N	\N	I	L	Chenapian	\N
cjo	\N	\N	\N	I	L	Ashéninka Pajonal	\N
cjp	\N	\N	\N	I	L	Cabécar	\N
cjs	\N	\N	\N	I	L	Shor	\N
cjv	\N	\N	\N	I	L	Chuave	\N
cjy	\N	\N	\N	I	L	Jinyu Chinese	\N
ckb	\N	\N	\N	I	L	Central Kurdish	\N
ckh	\N	\N	\N	I	L	Chak	\N
ckl	\N	\N	\N	I	L	Cibak	\N
ckm	\N	\N	\N	I	L	Chakavian	\N
ckn	\N	\N	\N	I	L	Kaang Chin	\N
cko	\N	\N	\N	I	L	Anufo	\N
ckq	\N	\N	\N	I	L	Kajakse	\N
ckr	\N	\N	\N	I	L	Kairak	\N
cks	\N	\N	\N	I	L	Tayo	\N
ckt	\N	\N	\N	I	L	Chukot	\N
cku	\N	\N	\N	I	L	Koasati	\N
ckv	\N	\N	\N	I	L	Kavalan	\N
ckx	\N	\N	\N	I	L	Caka	\N
cky	\N	\N	\N	I	L	Cakfem-Mushere	\N
ckz	\N	\N	\N	I	L	Cakchiquel-Quiché Mixed Language	\N
cla	\N	\N	\N	I	L	Ron	\N
clc	\N	\N	\N	I	L	Chilcotin	\N
cld	\N	\N	\N	I	L	Chaldean Neo-Aramaic	\N
cle	\N	\N	\N	I	L	Lealao Chinantec	\N
clh	\N	\N	\N	I	L	Chilisso	\N
cli	\N	\N	\N	I	L	Chakali	\N
clj	\N	\N	\N	I	L	Laitu Chin	\N
clk	\N	\N	\N	I	L	Idu-Mishmi	\N
cll	\N	\N	\N	I	L	Chala	\N
clm	\N	\N	\N	I	L	Clallam	\N
clo	\N	\N	\N	I	L	Lowland Oaxaca Chontal	\N
cls	\N	\N	\N	I	H	Classical Sanskrit	\N
clt	\N	\N	\N	I	L	Lautu Chin	\N
clu	\N	\N	\N	I	L	Caluyanun	\N
clw	\N	\N	\N	I	L	Chulym	\N
cly	\N	\N	\N	I	L	Eastern Highland Chatino	\N
cma	\N	\N	\N	I	L	Maa	\N
cme	\N	\N	\N	I	L	Cerma	\N
cmg	\N	\N	\N	I	H	Classical Mongolian	\N
cmi	\N	\N	\N	I	L	Emberá-Chamí	\N
cml	\N	\N	\N	I	L	Campalagian	\N
cmm	\N	\N	\N	I	E	Michigamea	\N
cmn	\N	\N	\N	I	L	Mandarin Chinese	\N
cmo	\N	\N	\N	I	L	Central Mnong	\N
cmr	\N	\N	\N	I	L	Mro-Khimi Chin	\N
cms	\N	\N	\N	I	H	Messapic	\N
cmt	\N	\N	\N	I	L	Camtho	\N
cna	\N	\N	\N	I	L	Changthang	\N
cnb	\N	\N	\N	I	L	Chinbon Chin	\N
cnc	\N	\N	\N	I	L	Côông	\N
cng	\N	\N	\N	I	L	Northern Qiang	\N
cnh	\N	\N	\N	I	L	Hakha Chin	\N
cni	\N	\N	\N	I	L	Asháninka	\N
cnk	\N	\N	\N	I	L	Khumi Chin	\N
cnl	\N	\N	\N	I	L	Lalana Chinantec	\N
cno	\N	\N	\N	I	L	Con	\N
cnp	\N	\N	\N	I	L	Northern Ping Chinese	\N
cnq	\N	\N	\N	I	L	Chung	\N
cnr	cnr	cnr	\N	I	L	Montenegrin	\N
cns	\N	\N	\N	I	L	Central Asmat	\N
cnt	\N	\N	\N	I	L	Tepetotutla Chinantec	\N
cnu	\N	\N	\N	I	L	Chenoua	\N
cnw	\N	\N	\N	I	L	Ngawn Chin	\N
cnx	\N	\N	\N	I	H	Middle Cornish	\N
coa	\N	\N	\N	I	L	Cocos Islands Malay	\N
cob	\N	\N	\N	I	E	Chicomuceltec	\N
coc	\N	\N	\N	I	L	Cocopa	\N
cod	\N	\N	\N	I	L	Cocama-Cocamilla	\N
coe	\N	\N	\N	I	L	Koreguaje	\N
cof	\N	\N	\N	I	L	Colorado	\N
cog	\N	\N	\N	I	L	Chong	\N
coh	\N	\N	\N	I	L	Chonyi-Dzihana-Kauma	\N
coj	\N	\N	\N	I	E	Cochimi	\N
cok	\N	\N	\N	I	L	Santa Teresa Cora	\N
col	\N	\N	\N	I	L	Columbia-Wenatchi	\N
com	\N	\N	\N	I	L	Comanche	\N
con	\N	\N	\N	I	L	Cofán	\N
coo	\N	\N	\N	I	L	Comox	\N
cop	cop	cop	\N	I	E	Coptic	\N
coq	\N	\N	\N	I	E	Coquille	\N
cor	cor	cor	kw	I	L	Cornish	\N
cos	cos	cos	co	I	L	Corsican	\N
cot	\N	\N	\N	I	L	Caquinte	\N
cou	\N	\N	\N	I	L	Wamey	\N
cov	\N	\N	\N	I	L	Cao Miao	\N
cow	\N	\N	\N	I	E	Cowlitz	\N
cox	\N	\N	\N	I	L	Nanti	\N
coz	\N	\N	\N	I	L	Chochotec	\N
cpa	\N	\N	\N	I	L	Palantla Chinantec	\N
cpb	\N	\N	\N	I	L	Ucayali-Yurúa Ashéninka	\N
cpc	\N	\N	\N	I	L	Ajyíninka Apurucayali	\N
cpg	\N	\N	\N	I	E	Cappadocian Greek	\N
cpi	\N	\N	\N	I	L	Chinese Pidgin English	\N
cpn	\N	\N	\N	I	L	Cherepon	\N
cpo	\N	\N	\N	I	L	Kpeego	\N
cps	\N	\N	\N	I	L	Capiznon	\N
cpu	\N	\N	\N	I	L	Pichis Ashéninka	\N
cpx	\N	\N	\N	I	L	Pu-Xian Chinese	\N
cpy	\N	\N	\N	I	L	South Ucayali Ashéninka	\N
cqd	\N	\N	\N	I	L	Chuanqiandian Cluster Miao	\N
cra	\N	\N	\N	I	L	Chara	\N
crb	\N	\N	\N	I	E	Island Carib	\N
crc	\N	\N	\N	I	L	Lonwolwol	\N
crd	\N	\N	\N	I	L	Coeur d'Alene	\N
cre	cre	cre	cr	M	L	Cree	\N
crf	\N	\N	\N	I	E	Caramanta	\N
crg	\N	\N	\N	I	L	Michif	\N
crh	crh	crh	\N	I	L	Crimean Tatar	\N
cri	\N	\N	\N	I	L	Sãotomense	\N
crj	\N	\N	\N	I	L	Southern East Cree	\N
crk	\N	\N	\N	I	L	Plains Cree	\N
crl	\N	\N	\N	I	L	Northern East Cree	\N
crm	\N	\N	\N	I	L	Moose Cree	\N
crn	\N	\N	\N	I	L	El Nayar Cora	\N
cro	\N	\N	\N	I	L	Crow	\N
crq	\N	\N	\N	I	L	Iyo'wujwa Chorote	\N
crr	\N	\N	\N	I	E	Carolina Algonquian	\N
crs	\N	\N	\N	I	L	Seselwa Creole French	\N
crt	\N	\N	\N	I	L	Iyojwa'ja Chorote	\N
crv	\N	\N	\N	I	L	Chaura	\N
crw	\N	\N	\N	I	L	Chrau	\N
crx	\N	\N	\N	I	L	Carrier	\N
cry	\N	\N	\N	I	L	Cori	\N
crz	\N	\N	\N	I	E	Cruzeño	\N
csa	\N	\N	\N	I	L	Chiltepec Chinantec	\N
csb	csb	csb	\N	I	L	Kashubian	\N
csc	\N	\N	\N	I	L	Catalan Sign Language	\N
csd	\N	\N	\N	I	L	Chiangmai Sign Language	\N
cse	\N	\N	\N	I	L	Czech Sign Language	\N
csf	\N	\N	\N	I	L	Cuba Sign Language	\N
csg	\N	\N	\N	I	L	Chilean Sign Language	\N
csh	\N	\N	\N	I	L	Asho Chin	\N
csi	\N	\N	\N	I	E	Coast Miwok	\N
csj	\N	\N	\N	I	L	Songlai Chin	\N
csk	\N	\N	\N	I	L	Jola-Kasa	\N
csl	\N	\N	\N	I	L	Chinese Sign Language	\N
csm	\N	\N	\N	I	L	Central Sierra Miwok	\N
csn	\N	\N	\N	I	L	Colombian Sign Language	\N
cso	\N	\N	\N	I	L	Sochiapam Chinantec	\N
csp	\N	\N	\N	I	L	Southern Ping Chinese	\N
csq	\N	\N	\N	I	L	Croatia Sign Language	\N
csr	\N	\N	\N	I	L	Costa Rican Sign Language	\N
css	\N	\N	\N	I	E	Southern Ohlone	\N
cst	\N	\N	\N	I	L	Northern Ohlone	\N
csv	\N	\N	\N	I	L	Sumtu Chin	\N
csw	\N	\N	\N	I	L	Swampy Cree	\N
csx	\N	\N	\N	I	L	Cambodian Sign Language	\N
csy	\N	\N	\N	I	L	Siyin Chin	\N
csz	\N	\N	\N	I	L	Coos	\N
cta	\N	\N	\N	I	L	Tataltepec Chatino	\N
ctc	\N	\N	\N	I	E	Chetco	\N
ctd	\N	\N	\N	I	L	Tedim Chin	\N
cte	\N	\N	\N	I	L	Tepinapa Chinantec	\N
ctg	\N	\N	\N	I	L	Chittagonian	\N
cth	\N	\N	\N	I	L	Thaiphum Chin	\N
ctl	\N	\N	\N	I	L	Tlacoatzintepec Chinantec	\N
ctm	\N	\N	\N	I	E	Chitimacha	\N
ctn	\N	\N	\N	I	L	Chhintange	\N
cto	\N	\N	\N	I	L	Emberá-Catío	\N
ctp	\N	\N	\N	I	L	Western Highland Chatino	\N
cts	\N	\N	\N	I	L	Northern Catanduanes Bikol	\N
ctt	\N	\N	\N	I	L	Wayanad Chetti	\N
ctu	\N	\N	\N	I	L	Chol	\N
cty	\N	\N	\N	I	L	Moundadan Chetty	\N
ctz	\N	\N	\N	I	L	Zacatepec Chatino	\N
cua	\N	\N	\N	I	L	Cua	\N
cub	\N	\N	\N	I	L	Cubeo	\N
cuc	\N	\N	\N	I	L	Usila Chinantec	\N
cuh	\N	\N	\N	I	L	Chuka	\N
cui	\N	\N	\N	I	L	Cuiba	\N
cuj	\N	\N	\N	I	L	Mashco Piro	\N
cuk	\N	\N	\N	I	L	San Blas Kuna	\N
cul	\N	\N	\N	I	L	Culina	\N
cuo	\N	\N	\N	I	E	Cumanagoto	\N
cup	\N	\N	\N	I	E	Cupeño	\N
cuq	\N	\N	\N	I	L	Cun	\N
cur	\N	\N	\N	I	L	Chhulung	\N
cut	\N	\N	\N	I	L	Teutila Cuicatec	\N
cuu	\N	\N	\N	I	L	Tai Ya	\N
cuv	\N	\N	\N	I	L	Cuvok	\N
cuw	\N	\N	\N	I	L	Chukwa	\N
cux	\N	\N	\N	I	L	Tepeuxila Cuicatec	\N
cuy	\N	\N	\N	I	L	Cuitlatec	\N
cvg	\N	\N	\N	I	L	Chug	\N
cvn	\N	\N	\N	I	L	Valle Nacional Chinantec	\N
cwa	\N	\N	\N	I	L	Kabwa	\N
cwb	\N	\N	\N	I	L	Maindo	\N
cwd	\N	\N	\N	I	L	Woods Cree	\N
cwe	\N	\N	\N	I	L	Kwere	\N
cwg	\N	\N	\N	I	L	Chewong	\N
cwt	\N	\N	\N	I	L	Kuwaataay	\N
cxh	\N	\N	\N	I	L	Cha'ari	\N
cya	\N	\N	\N	I	L	Nopala Chatino	\N
cyb	\N	\N	\N	I	E	Cayubaba	\N
cym	wel	cym	cy	I	L	Welsh	\N
cyo	\N	\N	\N	I	L	Cuyonon	\N
czh	\N	\N	\N	I	L	Huizhou Chinese	\N
czk	\N	\N	\N	I	E	Knaanic	\N
czn	\N	\N	\N	I	L	Zenzontepec Chatino	\N
czo	\N	\N	\N	I	L	Min Zhong Chinese	\N
czt	\N	\N	\N	I	L	Zotung Chin	\N
daa	\N	\N	\N	I	L	Dangaléat	\N
dac	\N	\N	\N	I	L	Dambi	\N
dad	\N	\N	\N	I	L	Marik	\N
dae	\N	\N	\N	I	L	Duupa	\N
dag	\N	\N	\N	I	L	Dagbani	\N
dah	\N	\N	\N	I	L	Gwahatike	\N
dai	\N	\N	\N	I	L	Day	\N
daj	\N	\N	\N	I	L	Dar Fur Daju	\N
dak	dak	dak	\N	I	L	Dakota	\N
dal	\N	\N	\N	I	L	Dahalo	\N
dam	\N	\N	\N	I	L	Damakawa	\N
dan	dan	dan	da	I	L	Danish	\N
dao	\N	\N	\N	I	L	Daai Chin	\N
daq	\N	\N	\N	I	L	Dandami Maria	\N
dar	dar	dar	\N	I	L	Dargwa	\N
das	\N	\N	\N	I	L	Daho-Doo	\N
dau	\N	\N	\N	I	L	Dar Sila Daju	\N
dav	\N	\N	\N	I	L	Taita	\N
daw	\N	\N	\N	I	L	Davawenyo	\N
dax	\N	\N	\N	I	L	Dayi	\N
daz	\N	\N	\N	I	L	Dao	\N
dba	\N	\N	\N	I	L	Bangime	\N
dbb	\N	\N	\N	I	L	Deno	\N
dbd	\N	\N	\N	I	L	Dadiya	\N
dbe	\N	\N	\N	I	L	Dabe	\N
dbf	\N	\N	\N	I	L	Edopi	\N
dbg	\N	\N	\N	I	L	Dogul Dom Dogon	\N
dbi	\N	\N	\N	I	L	Doka	\N
dbj	\N	\N	\N	I	L	Ida'an	\N
dbl	\N	\N	\N	I	L	Dyirbal	\N
dbm	\N	\N	\N	I	L	Duguri	\N
dbn	\N	\N	\N	I	L	Duriankere	\N
dbo	\N	\N	\N	I	L	Dulbu	\N
dbp	\N	\N	\N	I	L	Duwai	\N
dbq	\N	\N	\N	I	L	Daba	\N
dbr	\N	\N	\N	I	L	Dabarre	\N
dbt	\N	\N	\N	I	L	Ben Tey Dogon	\N
dbu	\N	\N	\N	I	L	Bondum Dom Dogon	\N
dbv	\N	\N	\N	I	L	Dungu	\N
dbw	\N	\N	\N	I	L	Bankan Tey Dogon	\N
dby	\N	\N	\N	I	L	Dibiyaso	\N
dcc	\N	\N	\N	I	L	Deccan	\N
dcr	\N	\N	\N	I	E	Negerhollands	\N
dda	\N	\N	\N	I	E	Dadi Dadi	\N
ddd	\N	\N	\N	I	L	Dongotono	\N
dde	\N	\N	\N	I	L	Doondo	\N
ddg	\N	\N	\N	I	L	Fataluku	\N
ddi	\N	\N	\N	I	L	West Goodenough	\N
ddj	\N	\N	\N	I	L	Jaru	\N
ddn	\N	\N	\N	I	L	Dendi (Benin)	\N
ddo	\N	\N	\N	I	L	Dido	\N
ddr	\N	\N	\N	I	E	Dhudhuroa	\N
dds	\N	\N	\N	I	L	Donno So Dogon	\N
ddw	\N	\N	\N	I	L	Dawera-Daweloor	\N
dec	\N	\N	\N	I	L	Dagik	\N
ded	\N	\N	\N	I	L	Dedua	\N
dee	\N	\N	\N	I	L	Dewoin	\N
def	\N	\N	\N	I	L	Dezfuli	\N
deg	\N	\N	\N	I	L	Degema	\N
deh	\N	\N	\N	I	L	Dehwari	\N
dei	\N	\N	\N	I	L	Demisa	\N
dek	\N	\N	\N	I	L	Dek	\N
del	del	del	\N	M	L	Delaware	\N
dem	\N	\N	\N	I	L	Dem	\N
den	den	den	\N	M	L	Slave (Athapascan)	\N
dep	\N	\N	\N	I	E	Pidgin Delaware	\N
deq	\N	\N	\N	I	L	Dendi (Central African Republic)	\N
der	\N	\N	\N	I	L	Deori	\N
des	\N	\N	\N	I	L	Desano	\N
deu	ger	deu	de	I	L	German	\N
dev	\N	\N	\N	I	L	Domung	\N
dez	\N	\N	\N	I	L	Dengese	\N
dga	\N	\N	\N	I	L	Southern Dagaare	\N
dgb	\N	\N	\N	I	L	Bunoge Dogon	\N
dgc	\N	\N	\N	I	L	Casiguran Dumagat Agta	\N
dgd	\N	\N	\N	I	L	Dagaari Dioula	\N
dge	\N	\N	\N	I	L	Degenan	\N
dgg	\N	\N	\N	I	L	Doga	\N
dgh	\N	\N	\N	I	L	Dghwede	\N
dgi	\N	\N	\N	I	L	Northern Dagara	\N
dgk	\N	\N	\N	I	L	Dagba	\N
dgl	\N	\N	\N	I	L	Andaandi	\N
dgn	\N	\N	\N	I	E	Dagoman	\N
dgo	\N	\N	\N	I	L	Dogri (individual language)	\N
dgr	dgr	dgr	\N	I	L	Tlicho	\N
dgs	\N	\N	\N	I	L	Dogoso	\N
dgt	\N	\N	\N	I	E	Ndra'ngith	\N
dgw	\N	\N	\N	I	E	Daungwurrung	\N
dgx	\N	\N	\N	I	L	Doghoro	\N
dgz	\N	\N	\N	I	L	Daga	\N
dhd	\N	\N	\N	I	L	Dhundari	\N
dhg	\N	\N	\N	I	L	Dhangu-Djangu	\N
dhi	\N	\N	\N	I	L	Dhimal	\N
dhl	\N	\N	\N	I	L	Dhalandji	\N
dhm	\N	\N	\N	I	L	Zemba	\N
dhn	\N	\N	\N	I	L	Dhanki	\N
dho	\N	\N	\N	I	L	Dhodia	\N
dhr	\N	\N	\N	I	L	Dhargari	\N
dhs	\N	\N	\N	I	L	Dhaiso	\N
dhu	\N	\N	\N	I	E	Dhurga	\N
dhv	\N	\N	\N	I	L	Dehu	\N
dhw	\N	\N	\N	I	L	Dhanwar (Nepal)	\N
dhx	\N	\N	\N	I	L	Dhungaloo	\N
dia	\N	\N	\N	I	L	Dia	\N
dib	\N	\N	\N	I	L	South Central Dinka	\N
dic	\N	\N	\N	I	L	Lakota Dida	\N
did	\N	\N	\N	I	L	Didinga	\N
dif	\N	\N	\N	I	E	Dieri	\N
dig	\N	\N	\N	I	L	Digo	\N
dih	\N	\N	\N	I	L	Kumiai	\N
dii	\N	\N	\N	I	L	Dimbong	\N
dij	\N	\N	\N	I	L	Dai	\N
dik	\N	\N	\N	I	L	Southwestern Dinka	\N
dil	\N	\N	\N	I	L	Dilling	\N
dim	\N	\N	\N	I	L	Dime	\N
din	din	din	\N	M	L	Dinka	\N
dio	\N	\N	\N	I	L	Dibo	\N
dip	\N	\N	\N	I	L	Northeastern Dinka	\N
diq	\N	\N	\N	I	L	Dimli (individual language)	\N
dir	\N	\N	\N	I	L	Dirim	\N
dis	\N	\N	\N	I	L	Dimasa	\N
diu	\N	\N	\N	I	L	Diriku	\N
div	div	div	dv	I	L	Dhivehi	\N
diw	\N	\N	\N	I	L	Northwestern Dinka	\N
dix	\N	\N	\N	I	L	Dixon Reef	\N
diy	\N	\N	\N	I	L	Diuwe	\N
diz	\N	\N	\N	I	L	Ding	\N
dja	\N	\N	\N	I	E	Djadjawurrung	\N
djb	\N	\N	\N	I	L	Djinba	\N
djc	\N	\N	\N	I	L	Dar Daju Daju	\N
djd	\N	\N	\N	I	L	Djamindjung	\N
dje	\N	\N	\N	I	L	Zarma	\N
djf	\N	\N	\N	I	E	Djangun	\N
dji	\N	\N	\N	I	L	Djinang	\N
djj	\N	\N	\N	I	L	Djeebbana	\N
djk	\N	\N	\N	I	L	Eastern Maroon Creole	\N
djm	\N	\N	\N	I	L	Jamsay Dogon	\N
djn	\N	\N	\N	I	L	Jawoyn	\N
djo	\N	\N	\N	I	L	Jangkang	\N
djr	\N	\N	\N	I	L	Djambarrpuyngu	\N
dju	\N	\N	\N	I	L	Kapriman	\N
djw	\N	\N	\N	I	E	Djawi	\N
dka	\N	\N	\N	I	L	Dakpakha	\N
dkg	\N	\N	\N	I	L	Kadung	\N
dkk	\N	\N	\N	I	L	Dakka	\N
dkr	\N	\N	\N	I	L	Kuijau	\N
dks	\N	\N	\N	I	L	Southeastern Dinka	\N
dkx	\N	\N	\N	I	L	Mazagway	\N
dlg	\N	\N	\N	I	L	Dolgan	\N
dlk	\N	\N	\N	I	L	Dahalik	\N
dlm	\N	\N	\N	I	E	Dalmatian	\N
dln	\N	\N	\N	I	L	Darlong	\N
dma	\N	\N	\N	I	L	Duma	\N
dmb	\N	\N	\N	I	L	Mombo Dogon	\N
dmc	\N	\N	\N	I	L	Gavak	\N
dmd	\N	\N	\N	I	E	Madhi Madhi	\N
dme	\N	\N	\N	I	L	Dugwor	\N
dmf	\N	\N	\N	I	E	Medefaidrin	\N
dmg	\N	\N	\N	I	L	Upper Kinabatangan	\N
dmk	\N	\N	\N	I	L	Domaaki	\N
dml	\N	\N	\N	I	L	Dameli	\N
dmm	\N	\N	\N	I	L	Dama	\N
dmo	\N	\N	\N	I	L	Kemedzung	\N
dmr	\N	\N	\N	I	L	East Damar	\N
dms	\N	\N	\N	I	L	Dampelas	\N
dmu	\N	\N	\N	I	L	Dubu	\N
dmv	\N	\N	\N	I	L	Dumpas	\N
dmw	\N	\N	\N	I	L	Mudburra	\N
dmx	\N	\N	\N	I	L	Dema	\N
dmy	\N	\N	\N	I	L	Demta	\N
dna	\N	\N	\N	I	L	Upper Grand Valley Dani	\N
dnd	\N	\N	\N	I	L	Daonda	\N
dne	\N	\N	\N	I	L	Ndendeule	\N
dng	\N	\N	\N	I	L	Dungan	\N
dni	\N	\N	\N	I	L	Lower Grand Valley Dani	\N
dnj	\N	\N	\N	I	L	Dan	\N
dnk	\N	\N	\N	I	L	Dengka	\N
dnn	\N	\N	\N	I	L	Dzùùngoo	\N
dno	\N	\N	\N	I	L	Ndrulo	\N
dnr	\N	\N	\N	I	L	Danaru	\N
dnt	\N	\N	\N	I	L	Mid Grand Valley Dani	\N
dnu	\N	\N	\N	I	L	Danau	\N
dnv	\N	\N	\N	I	L	Danu	\N
dnw	\N	\N	\N	I	L	Western Dani	\N
dny	\N	\N	\N	I	L	Dení	\N
doa	\N	\N	\N	I	L	Dom	\N
dob	\N	\N	\N	I	L	Dobu	\N
doc	\N	\N	\N	I	L	Northern Dong	\N
doe	\N	\N	\N	I	L	Doe	\N
dof	\N	\N	\N	I	L	Domu	\N
doh	\N	\N	\N	I	L	Dong	\N
doi	doi	doi	\N	M	L	Dogri (macrolanguage)	\N
dok	\N	\N	\N	I	L	Dondo	\N
dol	\N	\N	\N	I	L	Doso	\N
don	\N	\N	\N	I	L	Toura (Papua New Guinea)	\N
doo	\N	\N	\N	I	L	Dongo	\N
dop	\N	\N	\N	I	L	Lukpa	\N
doq	\N	\N	\N	I	L	Dominican Sign Language	\N
dor	\N	\N	\N	I	L	Dori'o	\N
dos	\N	\N	\N	I	L	Dogosé	\N
dot	\N	\N	\N	I	L	Dass	\N
dov	\N	\N	\N	I	L	Dombe	\N
dow	\N	\N	\N	I	L	Doyayo	\N
dox	\N	\N	\N	I	L	Bussa	\N
doy	\N	\N	\N	I	L	Dompo	\N
doz	\N	\N	\N	I	L	Dorze	\N
dpp	\N	\N	\N	I	L	Papar	\N
drb	\N	\N	\N	I	L	Dair	\N
drc	\N	\N	\N	I	L	Minderico	\N
drd	\N	\N	\N	I	L	Darmiya	\N
dre	\N	\N	\N	I	L	Dolpo	\N
drg	\N	\N	\N	I	L	Rungus	\N
dri	\N	\N	\N	I	L	C'Lela	\N
drl	\N	\N	\N	I	L	Paakantyi	\N
drn	\N	\N	\N	I	L	West Damar	\N
dro	\N	\N	\N	I	L	Daro-Matu Melanau	\N
drq	\N	\N	\N	I	E	Dura	\N
drs	\N	\N	\N	I	L	Gedeo	\N
drt	\N	\N	\N	I	L	Drents	\N
dru	\N	\N	\N	I	L	Rukai	\N
dry	\N	\N	\N	I	L	Darai	\N
dsb	dsb	dsb	\N	I	L	Lower Sorbian	\N
dse	\N	\N	\N	I	L	Dutch Sign Language	\N
dsh	\N	\N	\N	I	L	Daasanach	\N
dsi	\N	\N	\N	I	L	Disa	\N
dsk	\N	\N	\N	I	L	Dokshi	\N
dsl	\N	\N	\N	I	L	Danish Sign Language	\N
dsn	\N	\N	\N	I	E	Dusner	\N
dso	\N	\N	\N	I	L	Desiya	\N
dsq	\N	\N	\N	I	L	Tadaksahak	\N
dsz	\N	\N	\N	I	L	Mardin Sign Language	\N
dta	\N	\N	\N	I	L	Daur	\N
dtb	\N	\N	\N	I	L	Labuk-Kinabatangan Kadazan	\N
dtd	\N	\N	\N	I	L	Ditidaht	\N
dth	\N	\N	\N	I	E	Adithinngithigh	\N
dti	\N	\N	\N	I	L	Ana Tinga Dogon	\N
dtk	\N	\N	\N	I	L	Tene Kan Dogon	\N
dtm	\N	\N	\N	I	L	Tomo Kan Dogon	\N
dtn	\N	\N	\N	I	L	Daatsʼíin	\N
dto	\N	\N	\N	I	L	Tommo So Dogon	\N
dtp	\N	\N	\N	I	L	Kadazan Dusun	\N
dtr	\N	\N	\N	I	L	Lotud	\N
dts	\N	\N	\N	I	L	Toro So Dogon	\N
dtt	\N	\N	\N	I	L	Toro Tegu Dogon	\N
dtu	\N	\N	\N	I	L	Tebul Ure Dogon	\N
dty	\N	\N	\N	I	L	Dotyali	\N
dua	dua	dua	\N	I	L	Duala	\N
dub	\N	\N	\N	I	L	Dubli	\N
duc	\N	\N	\N	I	L	Duna	\N
due	\N	\N	\N	I	L	Umiray Dumaget Agta	\N
duf	\N	\N	\N	I	L	Dumbea	\N
dug	\N	\N	\N	I	L	Duruma	\N
duh	\N	\N	\N	I	L	Dungra Bhil	\N
dui	\N	\N	\N	I	L	Dumun	\N
duk	\N	\N	\N	I	L	Uyajitaya	\N
dul	\N	\N	\N	I	L	Alabat Island Agta	\N
dum	dum	dum	\N	I	H	Middle Dutch (ca. 1050-1350)	\N
dun	\N	\N	\N	I	L	Dusun Deyah	\N
duo	\N	\N	\N	I	L	Dupaninan Agta	\N
dup	\N	\N	\N	I	L	Duano	\N
duq	\N	\N	\N	I	L	Dusun Malang	\N
dur	\N	\N	\N	I	L	Dii	\N
dus	\N	\N	\N	I	L	Dumi	\N
duu	\N	\N	\N	I	L	Drung	\N
duv	\N	\N	\N	I	L	Duvle	\N
duw	\N	\N	\N	I	L	Dusun Witu	\N
dux	\N	\N	\N	I	L	Duungooma	\N
duy	\N	\N	\N	I	E	Dicamay Agta	\N
duz	\N	\N	\N	I	E	Duli-Gey	\N
dva	\N	\N	\N	I	L	Duau	\N
dwa	\N	\N	\N	I	L	Diri	\N
dwk	\N	\N	\N	I	L	Dawik Kui	\N
dwr	\N	\N	\N	I	L	Dawro	\N
dws	\N	\N	\N	I	C	Dutton World Speedwords	\N
dwu	\N	\N	\N	I	L	Dhuwal	\N
dww	\N	\N	\N	I	L	Dawawa	\N
dwy	\N	\N	\N	I	L	Dhuwaya	\N
dwz	\N	\N	\N	I	L	Dewas Rai	\N
dya	\N	\N	\N	I	L	Dyan	\N
dyb	\N	\N	\N	I	E	Dyaberdyaber	\N
dyd	\N	\N	\N	I	E	Dyugun	\N
dyg	\N	\N	\N	I	E	Villa Viciosa Agta	\N
dyi	\N	\N	\N	I	L	Djimini Senoufo	\N
dym	\N	\N	\N	I	L	Yanda Dom Dogon	\N
dyn	\N	\N	\N	I	L	Dyangadi	\N
dyo	\N	\N	\N	I	L	Jola-Fonyi	\N
dyr	\N	\N	\N	I	L	Dyarim	\N
dyu	dyu	dyu	\N	I	L	Dyula	\N
dyy	\N	\N	\N	I	L	Djabugay	\N
dza	\N	\N	\N	I	L	Tunzu	\N
dzd	\N	\N	\N	I	L	Daza	\N
dze	\N	\N	\N	I	E	Djiwarli	\N
dzg	\N	\N	\N	I	L	Dazaga	\N
dzl	\N	\N	\N	I	L	Dzalakha	\N
dzn	\N	\N	\N	I	L	Dzando	\N
dzo	dzo	dzo	dz	I	L	Dzongkha	\N
eaa	\N	\N	\N	I	E	Karenggapa	\N
ebc	\N	\N	\N	I	L	Beginci	\N
ebg	\N	\N	\N	I	L	Ebughu	\N
ebk	\N	\N	\N	I	L	Eastern Bontok	\N
ebo	\N	\N	\N	I	L	Teke-Ebo	\N
ebr	\N	\N	\N	I	L	Ebrié	\N
ebu	\N	\N	\N	I	L	Embu	\N
ecr	\N	\N	\N	I	H	Eteocretan	\N
ecs	\N	\N	\N	I	L	Ecuadorian Sign Language	\N
ecy	\N	\N	\N	I	H	Eteocypriot	\N
eee	\N	\N	\N	I	L	E	\N
efa	\N	\N	\N	I	L	Efai	\N
efe	\N	\N	\N	I	L	Efe	\N
efi	efi	efi	\N	I	L	Efik	\N
ega	\N	\N	\N	I	L	Ega	\N
egl	\N	\N	\N	I	L	Emilian	\N
egm	\N	\N	\N	I	L	Benamanga	\N
ego	\N	\N	\N	I	L	Eggon	\N
egy	egy	egy	\N	I	H	Egyptian (Ancient)	\N
ehs	\N	\N	\N	I	L	Miyakubo Sign Language	\N
ehu	\N	\N	\N	I	L	Ehueun	\N
eip	\N	\N	\N	I	L	Eipomek	\N
eit	\N	\N	\N	I	L	Eitiep	\N
eiv	\N	\N	\N	I	L	Askopan	\N
eja	\N	\N	\N	I	L	Ejamat	\N
eka	eka	eka	\N	I	L	Ekajuk	\N
eke	\N	\N	\N	I	L	Ekit	\N
ekg	\N	\N	\N	I	L	Ekari	\N
eki	\N	\N	\N	I	L	Eki	\N
ekk	\N	\N	\N	I	L	Standard Estonian	\N
ekl	\N	\N	\N	I	L	Kol (Bangladesh)	\N
ekm	\N	\N	\N	I	L	Elip	\N
eko	\N	\N	\N	I	L	Koti	\N
ekp	\N	\N	\N	I	L	Ekpeye	\N
ekr	\N	\N	\N	I	L	Yace	\N
eky	\N	\N	\N	I	L	Eastern Kayah	\N
ele	\N	\N	\N	I	L	Elepi	\N
elh	\N	\N	\N	I	L	El Hugeirat	\N
eli	\N	\N	\N	I	E	Nding	\N
elk	\N	\N	\N	I	L	Elkei	\N
ell	gre	ell	el	I	L	Modern Greek (1453-)	\N
elm	\N	\N	\N	I	L	Eleme	\N
elo	\N	\N	\N	I	L	El Molo	\N
elu	\N	\N	\N	I	L	Elu	\N
elx	elx	elx	\N	I	H	Elamite	\N
ema	\N	\N	\N	I	L	Emai-Iuleha-Ora	\N
emb	\N	\N	\N	I	L	Embaloh	\N
eme	\N	\N	\N	I	L	Emerillon	\N
emg	\N	\N	\N	I	L	Eastern Meohang	\N
emi	\N	\N	\N	I	L	Mussau-Emira	\N
emk	\N	\N	\N	I	L	Eastern Maninkakan	\N
emm	\N	\N	\N	I	E	Mamulique	\N
emn	\N	\N	\N	I	L	Eman	\N
emp	\N	\N	\N	I	L	Northern Emberá	\N
emq	\N	\N	\N	I	L	Eastern Minyag	\N
ems	\N	\N	\N	I	L	Pacific Gulf Yupik	\N
emu	\N	\N	\N	I	L	Eastern Muria	\N
emw	\N	\N	\N	I	L	Emplawas	\N
emx	\N	\N	\N	I	L	Erromintxela	\N
emy	\N	\N	\N	I	H	Epigraphic Mayan	\N
emz	\N	\N	\N	I	L	Mbessa	\N
ena	\N	\N	\N	I	L	Apali	\N
enb	\N	\N	\N	I	L	Markweeta	\N
enc	\N	\N	\N	I	L	En	\N
end	\N	\N	\N	I	L	Ende	\N
enf	\N	\N	\N	I	L	Forest Enets	\N
eng	eng	eng	en	I	L	English	\N
enh	\N	\N	\N	I	L	Tundra Enets	\N
enl	\N	\N	\N	I	L	Enlhet	\N
enm	enm	enm	\N	I	H	Middle English (1100-1500)	\N
enn	\N	\N	\N	I	L	Engenni	\N
eno	\N	\N	\N	I	L	Enggano	\N
enq	\N	\N	\N	I	L	Enga	\N
enr	\N	\N	\N	I	L	Emumu	\N
enu	\N	\N	\N	I	L	Enu	\N
env	\N	\N	\N	I	L	Enwan (Edo State)	\N
enw	\N	\N	\N	I	L	Enwan (Akwa Ibom State)	\N
enx	\N	\N	\N	I	L	Enxet	\N
eot	\N	\N	\N	I	L	Beti (Côte d'Ivoire)	\N
epi	\N	\N	\N	I	L	Epie	\N
epo	epo	epo	eo	I	C	Esperanto	\N
era	\N	\N	\N	I	L	Eravallan	\N
erg	\N	\N	\N	I	L	Sie	\N
erh	\N	\N	\N	I	L	Eruwa	\N
eri	\N	\N	\N	I	L	Ogea	\N
erk	\N	\N	\N	I	L	South Efate	\N
ero	\N	\N	\N	I	L	Horpa	\N
err	\N	\N	\N	I	E	Erre	\N
ers	\N	\N	\N	I	L	Ersu	\N
ert	\N	\N	\N	I	L	Eritai	\N
erw	\N	\N	\N	I	L	Erokwanas	\N
ese	\N	\N	\N	I	L	Ese Ejja	\N
esg	\N	\N	\N	I	L	Aheri Gondi	\N
esh	\N	\N	\N	I	L	Eshtehardi	\N
esi	\N	\N	\N	I	L	North Alaskan Inupiatun	\N
esk	\N	\N	\N	I	L	Northwest Alaska Inupiatun	\N
esl	\N	\N	\N	I	L	Egypt Sign Language	\N
esm	\N	\N	\N	I	E	Esuma	\N
esn	\N	\N	\N	I	L	Salvadoran Sign Language	\N
eso	\N	\N	\N	I	L	Estonian Sign Language	\N
esq	\N	\N	\N	I	E	Esselen	\N
ess	\N	\N	\N	I	L	Central Siberian Yupik	\N
est	est	est	et	M	L	Estonian	\N
esu	\N	\N	\N	I	L	Central Yupik	\N
esy	\N	\N	\N	I	L	Eskayan	\N
etb	\N	\N	\N	I	L	Etebi	\N
etc	\N	\N	\N	I	E	Etchemin	\N
eth	\N	\N	\N	I	L	Ethiopian Sign Language	\N
etn	\N	\N	\N	I	L	Eton (Vanuatu)	\N
eto	\N	\N	\N	I	L	Eton (Cameroon)	\N
etr	\N	\N	\N	I	L	Edolo	\N
ets	\N	\N	\N	I	L	Yekhee	\N
ett	\N	\N	\N	I	H	Etruscan	\N
etu	\N	\N	\N	I	L	Ejagham	\N
etx	\N	\N	\N	I	L	Eten	\N
etz	\N	\N	\N	I	L	Semimi	\N
eud	\N	\N	\N	I	E	Eudeve	\N
eus	baq	eus	eu	I	L	Basque	\N
eve	\N	\N	\N	I	L	Even	\N
evh	\N	\N	\N	I	L	Uvbie	\N
evn	\N	\N	\N	I	L	Evenki	\N
ewe	ewe	ewe	ee	I	L	Ewe	\N
ewo	ewo	ewo	\N	I	L	Ewondo	\N
ext	\N	\N	\N	I	L	Extremaduran	\N
eya	\N	\N	\N	I	E	Eyak	\N
eyo	\N	\N	\N	I	L	Keiyo	\N
eza	\N	\N	\N	I	L	Ezaa	\N
eze	\N	\N	\N	I	L	Uzekwe	\N
faa	\N	\N	\N	I	L	Fasu	\N
fab	\N	\N	\N	I	L	Fa d'Ambu	\N
fad	\N	\N	\N	I	L	Wagi	\N
faf	\N	\N	\N	I	L	Fagani	\N
fag	\N	\N	\N	I	L	Finongan	\N
fah	\N	\N	\N	I	L	Baissa Fali	\N
fai	\N	\N	\N	I	L	Faiwol	\N
faj	\N	\N	\N	I	L	Faita	\N
fak	\N	\N	\N	I	L	Fang (Cameroon)	\N
fal	\N	\N	\N	I	L	South Fali	\N
fam	\N	\N	\N	I	L	Fam	\N
fan	fan	fan	\N	I	L	Fang (Equatorial Guinea)	\N
fao	fao	fao	fo	I	L	Faroese	\N
fap	\N	\N	\N	I	L	Paloor	\N
far	\N	\N	\N	I	L	Fataleka	\N
fas	per	fas	fa	M	L	Persian	\N
fat	fat	fat	\N	I	L	Fanti	\N
fau	\N	\N	\N	I	L	Fayu	\N
fax	\N	\N	\N	I	L	Fala	\N
fay	\N	\N	\N	I	L	Southwestern Fars	\N
faz	\N	\N	\N	I	L	Northwestern Fars	\N
fbl	\N	\N	\N	I	L	West Albay Bikol	\N
fcs	\N	\N	\N	I	L	Quebec Sign Language	\N
fer	\N	\N	\N	I	L	Feroge	\N
ffi	\N	\N	\N	I	L	Foia Foia	\N
ffm	\N	\N	\N	I	L	Maasina Fulfulde	\N
fgr	\N	\N	\N	I	L	Fongoro	\N
fia	\N	\N	\N	I	L	Nobiin	\N
fie	\N	\N	\N	I	L	Fyer	\N
fif	\N	\N	\N	I	L	Faifi	\N
fij	fij	fij	fj	I	L	Fijian	\N
fil	fil	fil	\N	I	L	Filipino	\N
fin	fin	fin	fi	I	L	Finnish	\N
fip	\N	\N	\N	I	L	Fipa	\N
fir	\N	\N	\N	I	L	Firan	\N
fit	\N	\N	\N	I	L	Tornedalen Finnish	\N
fiw	\N	\N	\N	I	L	Fiwaga	\N
fkk	\N	\N	\N	I	L	Kirya-Konzəl	\N
fkv	\N	\N	\N	I	L	Kven Finnish	\N
fla	\N	\N	\N	I	L	Kalispel-Pend d'Oreille	\N
flh	\N	\N	\N	I	L	Foau	\N
fli	\N	\N	\N	I	L	Fali	\N
fll	\N	\N	\N	I	L	North Fali	\N
fln	\N	\N	\N	I	E	Flinders Island	\N
flr	\N	\N	\N	I	L	Fuliiru	\N
fly	\N	\N	\N	I	L	Flaaitaal	\N
fmp	\N	\N	\N	I	L	Fe'fe'	\N
fmu	\N	\N	\N	I	L	Far Western Muria	\N
fnb	\N	\N	\N	I	L	Fanbak	\N
fng	\N	\N	\N	I	L	Fanagalo	\N
fni	\N	\N	\N	I	L	Fania	\N
fod	\N	\N	\N	I	L	Foodo	\N
foi	\N	\N	\N	I	L	Foi	\N
fom	\N	\N	\N	I	L	Foma	\N
fon	fon	fon	\N	I	L	Fon	\N
for	\N	\N	\N	I	L	Fore	\N
fos	\N	\N	\N	I	E	Siraya	\N
fpe	\N	\N	\N	I	L	Fernando Po Creole English	\N
fqs	\N	\N	\N	I	L	Fas	\N
fra	fre	fra	fr	I	L	French	\N
frc	\N	\N	\N	I	L	Cajun French	\N
frd	\N	\N	\N	I	L	Fordata	\N
frk	\N	\N	\N	I	H	Frankish	\N
frm	frm	frm	\N	I	H	Middle French (ca. 1400-1600)	\N
fro	fro	fro	\N	I	H	Old French (842-ca. 1400)	\N
frp	\N	\N	\N	I	L	Arpitan	\N
frq	\N	\N	\N	I	L	Forak	\N
frr	frr	frr	\N	I	L	Northern Frisian	\N
frs	frs	frs	\N	I	L	Eastern Frisian	\N
frt	\N	\N	\N	I	L	Fortsenal	\N
fry	fry	fry	fy	I	L	Western Frisian	\N
fse	\N	\N	\N	I	L	Finnish Sign Language	\N
fsl	\N	\N	\N	I	L	French Sign Language	\N
fss	\N	\N	\N	I	L	Finland-Swedish Sign Language	\N
fub	\N	\N	\N	I	L	Adamawa Fulfulde	\N
fuc	\N	\N	\N	I	L	Pulaar	\N
fud	\N	\N	\N	I	L	East Futuna	\N
fue	\N	\N	\N	I	L	Borgu Fulfulde	\N
fuf	\N	\N	\N	I	L	Pular	\N
fuh	\N	\N	\N	I	L	Western Niger Fulfulde	\N
fui	\N	\N	\N	I	L	Bagirmi Fulfulde	\N
fuj	\N	\N	\N	I	L	Ko	\N
ful	ful	ful	ff	M	L	Fulah	\N
fum	\N	\N	\N	I	L	Fum	\N
fun	\N	\N	\N	I	L	Fulniô	\N
fuq	\N	\N	\N	I	L	Central-Eastern Niger Fulfulde	\N
fur	fur	fur	\N	I	L	Friulian	\N
fut	\N	\N	\N	I	L	Futuna-Aniwa	\N
fuu	\N	\N	\N	I	L	Furu	\N
fuv	\N	\N	\N	I	L	Nigerian Fulfulde	\N
fuy	\N	\N	\N	I	L	Fuyug	\N
fvr	\N	\N	\N	I	L	Fur	\N
fwa	\N	\N	\N	I	L	Fwâi	\N
fwe	\N	\N	\N	I	L	Fwe	\N
gaa	gaa	gaa	\N	I	L	Ga	\N
gab	\N	\N	\N	I	L	Gabri	\N
gac	\N	\N	\N	I	L	Mixed Great Andamanese	\N
gad	\N	\N	\N	I	L	Gaddang	\N
gae	\N	\N	\N	I	L	Guarequena	\N
gaf	\N	\N	\N	I	L	Gende	\N
gag	\N	\N	\N	I	L	Gagauz	\N
gah	\N	\N	\N	I	L	Alekano	\N
gai	\N	\N	\N	I	L	Borei	\N
gaj	\N	\N	\N	I	L	Gadsup	\N
gak	\N	\N	\N	I	L	Gamkonora	\N
gal	\N	\N	\N	I	L	Galolen	\N
gam	\N	\N	\N	I	L	Kandawo	\N
gan	\N	\N	\N	I	L	Gan Chinese	\N
gao	\N	\N	\N	I	L	Gants	\N
gap	\N	\N	\N	I	L	Gal	\N
gaq	\N	\N	\N	I	L	Gata'	\N
gar	\N	\N	\N	I	L	Galeya	\N
gas	\N	\N	\N	I	L	Adiwasi Garasia	\N
gat	\N	\N	\N	I	L	Kenati	\N
gau	\N	\N	\N	I	L	Mudhili Gadaba	\N
gaw	\N	\N	\N	I	L	Nobonob	\N
gax	\N	\N	\N	I	L	Borana-Arsi-Guji Oromo	\N
gay	gay	gay	\N	I	L	Gayo	\N
gaz	\N	\N	\N	I	L	West Central Oromo	\N
gba	gba	gba	\N	M	L	Gbaya (Central African Republic)	\N
gbb	\N	\N	\N	I	L	Kaytetye	\N
gbd	\N	\N	\N	I	L	Karajarri	\N
gbe	\N	\N	\N	I	L	Niksek	\N
gbf	\N	\N	\N	I	L	Gaikundi	\N
gbg	\N	\N	\N	I	L	Gbanziri	\N
gbh	\N	\N	\N	I	L	Defi Gbe	\N
gbi	\N	\N	\N	I	L	Galela	\N
gbj	\N	\N	\N	I	L	Bodo Gadaba	\N
gbk	\N	\N	\N	I	L	Gaddi	\N
gbl	\N	\N	\N	I	L	Gamit	\N
gbm	\N	\N	\N	I	L	Garhwali	\N
gbn	\N	\N	\N	I	L	Mo'da	\N
gbo	\N	\N	\N	I	L	Northern Grebo	\N
gbp	\N	\N	\N	I	L	Gbaya-Bossangoa	\N
gbq	\N	\N	\N	I	L	Gbaya-Bozoum	\N
gbr	\N	\N	\N	I	L	Gbagyi	\N
gbs	\N	\N	\N	I	L	Gbesi Gbe	\N
gbu	\N	\N	\N	I	L	Gagadu	\N
gbv	\N	\N	\N	I	L	Gbanu	\N
gbw	\N	\N	\N	I	L	Gabi-Gabi	\N
gbx	\N	\N	\N	I	L	Eastern Xwla Gbe	\N
gby	\N	\N	\N	I	L	Gbari	\N
gbz	\N	\N	\N	I	L	Zoroastrian Dari	\N
gcc	\N	\N	\N	I	L	Mali	\N
gcd	\N	\N	\N	I	E	Ganggalida	\N
gce	\N	\N	\N	I	E	Galice	\N
gcf	\N	\N	\N	I	L	Guadeloupean Creole French	\N
gcl	\N	\N	\N	I	L	Grenadian Creole English	\N
gcn	\N	\N	\N	I	L	Gaina	\N
gcr	\N	\N	\N	I	L	Guianese Creole French	\N
gct	\N	\N	\N	I	L	Colonia Tovar German	\N
gda	\N	\N	\N	I	L	Gade Lohar	\N
gdb	\N	\N	\N	I	L	Pottangi Ollar Gadaba	\N
gdc	\N	\N	\N	I	E	Gugu Badhun	\N
gdd	\N	\N	\N	I	L	Gedaged	\N
gde	\N	\N	\N	I	L	Gude	\N
gdf	\N	\N	\N	I	L	Guduf-Gava	\N
gdg	\N	\N	\N	I	L	Ga'dang	\N
gdh	\N	\N	\N	I	L	Gadjerawang	\N
gdi	\N	\N	\N	I	L	Gundi	\N
gdj	\N	\N	\N	I	L	Gurdjar	\N
gdk	\N	\N	\N	I	L	Gadang	\N
gdl	\N	\N	\N	I	L	Dirasha	\N
gdm	\N	\N	\N	I	L	Laal	\N
gdn	\N	\N	\N	I	L	Umanakaina	\N
gdo	\N	\N	\N	I	L	Ghodoberi	\N
gdq	\N	\N	\N	I	L	Mehri	\N
gdr	\N	\N	\N	I	L	Wipi	\N
gds	\N	\N	\N	I	L	Ghandruk Sign Language	\N
gdt	\N	\N	\N	I	E	Kungardutyi	\N
gdu	\N	\N	\N	I	L	Gudu	\N
gdx	\N	\N	\N	I	L	Godwari	\N
gea	\N	\N	\N	I	L	Geruma	\N
geb	\N	\N	\N	I	L	Kire	\N
gec	\N	\N	\N	I	L	Gboloo Grebo	\N
ged	\N	\N	\N	I	L	Gade	\N
gef	\N	\N	\N	I	L	Gerai	\N
geg	\N	\N	\N	I	L	Gengle	\N
geh	\N	\N	\N	I	L	Hutterite German	\N
gei	\N	\N	\N	I	L	Gebe	\N
gej	\N	\N	\N	I	L	Gen	\N
gek	\N	\N	\N	I	L	Ywom	\N
gel	\N	\N	\N	I	L	ut-Ma'in	\N
geq	\N	\N	\N	I	L	Geme	\N
ges	\N	\N	\N	I	L	Geser-Gorom	\N
gev	\N	\N	\N	I	L	Eviya	\N
gew	\N	\N	\N	I	L	Gera	\N
gex	\N	\N	\N	I	L	Garre	\N
gey	\N	\N	\N	I	L	Enya	\N
gez	gez	gez	\N	I	H	Geez	\N
gfk	\N	\N	\N	I	L	Patpatar	\N
gft	\N	\N	\N	I	E	Gafat	\N
gga	\N	\N	\N	I	L	Gao	\N
ggb	\N	\N	\N	I	L	Gbii	\N
ggd	\N	\N	\N	I	E	Gugadj	\N
gge	\N	\N	\N	I	L	Gurr-goni	\N
ggg	\N	\N	\N	I	L	Gurgula	\N
ggk	\N	\N	\N	I	E	Kungarakany	\N
ggl	\N	\N	\N	I	L	Ganglau	\N
ggt	\N	\N	\N	I	L	Gitua	\N
ggu	\N	\N	\N	I	L	Gagu	\N
ggw	\N	\N	\N	I	L	Gogodala	\N
gha	\N	\N	\N	I	L	Ghadamès	\N
ghc	\N	\N	\N	I	H	Hiberno-Scottish Gaelic	\N
ghe	\N	\N	\N	I	L	Southern Ghale	\N
ghh	\N	\N	\N	I	L	Northern Ghale	\N
ghk	\N	\N	\N	I	L	Geko Karen	\N
ghl	\N	\N	\N	I	L	Ghulfan	\N
ghn	\N	\N	\N	I	L	Ghanongga	\N
gho	\N	\N	\N	I	E	Ghomara	\N
ghr	\N	\N	\N	I	L	Ghera	\N
ghs	\N	\N	\N	I	L	Guhu-Samane	\N
ght	\N	\N	\N	I	L	Kuke	\N
gia	\N	\N	\N	I	L	Kija	\N
gib	\N	\N	\N	I	L	Gibanawa	\N
gic	\N	\N	\N	I	L	Gail	\N
gid	\N	\N	\N	I	L	Gidar	\N
gie	\N	\N	\N	I	L	Gaɓogbo	\N
gig	\N	\N	\N	I	L	Goaria	\N
gih	\N	\N	\N	I	L	Githabul	\N
gii	\N	\N	\N	I	L	Girirra	\N
gil	gil	gil	\N	I	L	Gilbertese	\N
gim	\N	\N	\N	I	L	Gimi (Eastern Highlands)	\N
gin	\N	\N	\N	I	L	Hinukh	\N
gip	\N	\N	\N	I	L	Gimi (West New Britain)	\N
giq	\N	\N	\N	I	L	Green Gelao	\N
gir	\N	\N	\N	I	L	Red Gelao	\N
gis	\N	\N	\N	I	L	North Giziga	\N
git	\N	\N	\N	I	L	Gitxsan	\N
giu	\N	\N	\N	I	L	Mulao	\N
giw	\N	\N	\N	I	L	White Gelao	\N
gix	\N	\N	\N	I	L	Gilima	\N
giy	\N	\N	\N	I	L	Giyug	\N
giz	\N	\N	\N	I	L	South Giziga	\N
gjk	\N	\N	\N	I	L	Kachi Koli	\N
gjm	\N	\N	\N	I	E	Gunditjmara	\N
gjn	\N	\N	\N	I	L	Gonja	\N
gjr	\N	\N	\N	I	L	Gurindji Kriol	\N
gju	\N	\N	\N	I	L	Gujari	\N
gka	\N	\N	\N	I	L	Guya	\N
gkd	\N	\N	\N	I	L	Magɨ (Madang Province)	\N
gke	\N	\N	\N	I	L	Ndai	\N
gkn	\N	\N	\N	I	L	Gokana	\N
gko	\N	\N	\N	I	E	Kok-Nar	\N
gkp	\N	\N	\N	I	L	Guinea Kpelle	\N
gku	\N	\N	\N	I	E	ǂUngkue	\N
gla	gla	gla	gd	I	L	Scottish Gaelic	\N
glb	\N	\N	\N	I	L	Belning	\N
glc	\N	\N	\N	I	L	Bon Gula	\N
gld	\N	\N	\N	I	L	Nanai	\N
gle	gle	gle	ga	I	L	Irish	\N
glg	glg	glg	gl	I	L	Galician	\N
glh	\N	\N	\N	I	L	Northwest Pashai	\N
glj	\N	\N	\N	I	L	Gula Iro	\N
glk	\N	\N	\N	I	L	Gilaki	\N
gll	\N	\N	\N	I	E	Garlali	\N
glo	\N	\N	\N	I	L	Galambu	\N
glr	\N	\N	\N	I	L	Glaro-Twabo	\N
glu	\N	\N	\N	I	L	Gula (Chad)	\N
glv	glv	glv	gv	I	L	Manx	\N
glw	\N	\N	\N	I	L	Glavda	\N
gly	\N	\N	\N	I	E	Gule	\N
gma	\N	\N	\N	I	E	Gambera	\N
gmb	\N	\N	\N	I	L	Gula'alaa	\N
gmd	\N	\N	\N	I	L	Mághdì	\N
gmg	\N	\N	\N	I	L	Magɨyi	\N
gmh	gmh	gmh	\N	I	H	Middle High German (ca. 1050-1500)	\N
gml	\N	\N	\N	I	H	Middle Low German	\N
gmm	\N	\N	\N	I	L	Gbaya-Mbodomo	\N
gmn	\N	\N	\N	I	L	Gimnime	\N
gmr	\N	\N	\N	I	L	Mirning	\N
gmu	\N	\N	\N	I	L	Gumalu	\N
gmv	\N	\N	\N	I	L	Gamo	\N
gmx	\N	\N	\N	I	L	Magoma	\N
gmy	\N	\N	\N	I	H	Mycenaean Greek	\N
gmz	\N	\N	\N	I	L	Mgbolizhia	\N
gna	\N	\N	\N	I	L	Kaansa	\N
gnb	\N	\N	\N	I	L	Gangte	\N
gnc	\N	\N	\N	I	E	Guanche	\N
gnd	\N	\N	\N	I	L	Zulgo-Gemzek	\N
gne	\N	\N	\N	I	L	Ganang	\N
gng	\N	\N	\N	I	L	Ngangam	\N
gnh	\N	\N	\N	I	L	Lere	\N
gni	\N	\N	\N	I	L	Gooniyandi	\N
gnj	\N	\N	\N	I	L	Ngen	\N
gnk	\N	\N	\N	I	L	ǁGana	\N
gnl	\N	\N	\N	I	E	Gangulu	\N
gnm	\N	\N	\N	I	L	Ginuman	\N
gnn	\N	\N	\N	I	L	Gumatj	\N
gno	\N	\N	\N	I	L	Northern Gondi	\N
gnq	\N	\N	\N	I	L	Gana	\N
gnr	\N	\N	\N	I	E	Gureng Gureng	\N
gnt	\N	\N	\N	I	L	Guntai	\N
gnu	\N	\N	\N	I	L	Gnau	\N
gnw	\N	\N	\N	I	L	Western Bolivian Guaraní	\N
gnz	\N	\N	\N	I	L	Ganzi	\N
goa	\N	\N	\N	I	L	Guro	\N
gob	\N	\N	\N	I	L	Playero	\N
goc	\N	\N	\N	I	L	Gorakor	\N
god	\N	\N	\N	I	L	Godié	\N
goe	\N	\N	\N	I	L	Gongduk	\N
gof	\N	\N	\N	I	L	Gofa	\N
gog	\N	\N	\N	I	L	Gogo	\N
goh	goh	goh	\N	I	H	Old High German (ca. 750-1050)	\N
goi	\N	\N	\N	I	L	Gobasi	\N
goj	\N	\N	\N	I	L	Gowlan	\N
gok	\N	\N	\N	I	L	Gowli	\N
gol	\N	\N	\N	I	L	Gola	\N
gom	\N	\N	\N	I	L	Goan Konkani	\N
gon	gon	gon	\N	M	L	Gondi	\N
goo	\N	\N	\N	I	L	Gone Dau	\N
gop	\N	\N	\N	I	L	Yeretuar	\N
goq	\N	\N	\N	I	L	Gorap	\N
gor	gor	gor	\N	I	L	Gorontalo	\N
gos	\N	\N	\N	I	L	Gronings	\N
got	got	got	\N	I	H	Gothic	\N
gou	\N	\N	\N	I	L	Gavar	\N
gov	\N	\N	\N	I	L	Goo	\N
gow	\N	\N	\N	I	L	Gorowa	\N
gox	\N	\N	\N	I	L	Gobu	\N
goy	\N	\N	\N	I	L	Goundo	\N
goz	\N	\N	\N	I	L	Gozarkhani	\N
gpa	\N	\N	\N	I	L	Gupa-Abawa	\N
gpe	\N	\N	\N	I	L	Ghanaian Pidgin English	\N
gpn	\N	\N	\N	I	L	Taiap	\N
gqa	\N	\N	\N	I	L	Ga'anda	\N
gqi	\N	\N	\N	I	L	Guiqiong	\N
gqn	\N	\N	\N	I	E	Guana (Brazil)	\N
gqr	\N	\N	\N	I	L	Gor	\N
gqu	\N	\N	\N	I	L	Qau	\N
gra	\N	\N	\N	I	L	Rajput Garasia	\N
grb	grb	grb	\N	M	L	Grebo	\N
grc	grc	grc	\N	I	H	Ancient Greek (to 1453)	\N
grd	\N	\N	\N	I	L	Guruntum-Mbaaru	\N
grg	\N	\N	\N	I	L	Madi	\N
grh	\N	\N	\N	I	L	Gbiri-Niragu	\N
gri	\N	\N	\N	I	L	Ghari	\N
grj	\N	\N	\N	I	L	Southern Grebo	\N
grm	\N	\N	\N	I	L	Kota Marudu Talantang	\N
grn	grn	grn	gn	M	L	Guarani	\N
gro	\N	\N	\N	I	L	Groma	\N
grq	\N	\N	\N	I	L	Gorovu	\N
grr	\N	\N	\N	I	L	Taznatit	\N
grs	\N	\N	\N	I	L	Gresi	\N
grt	\N	\N	\N	I	L	Garo	\N
gru	\N	\N	\N	I	L	Kistane	\N
grv	\N	\N	\N	I	L	Central Grebo	\N
grw	\N	\N	\N	I	L	Gweda	\N
grx	\N	\N	\N	I	L	Guriaso	\N
gry	\N	\N	\N	I	L	Barclayville Grebo	\N
grz	\N	\N	\N	I	L	Guramalum	\N
gse	\N	\N	\N	I	L	Ghanaian Sign Language	\N
gsg	\N	\N	\N	I	L	German Sign Language	\N
gsl	\N	\N	\N	I	L	Gusilay	\N
gsm	\N	\N	\N	I	L	Guatemalan Sign Language	\N
gsn	\N	\N	\N	I	L	Nema	\N
gso	\N	\N	\N	I	L	Southwest Gbaya	\N
gsp	\N	\N	\N	I	L	Wasembo	\N
gss	\N	\N	\N	I	L	Greek Sign Language	\N
gsw	gsw	gsw	\N	I	L	Swiss German	\N
gta	\N	\N	\N	I	L	Guató	\N
gtu	\N	\N	\N	I	E	Aghu-Tharnggala	\N
gua	\N	\N	\N	I	L	Shiki	\N
gub	\N	\N	\N	I	L	Guajajára	\N
guc	\N	\N	\N	I	L	Wayuu	\N
gud	\N	\N	\N	I	L	Yocoboué Dida	\N
gue	\N	\N	\N	I	L	Gurindji	\N
guf	\N	\N	\N	I	L	Gupapuyngu	\N
gug	\N	\N	\N	I	L	Paraguayan Guaraní	\N
guh	\N	\N	\N	I	L	Guahibo	\N
gui	\N	\N	\N	I	L	Eastern Bolivian Guaraní	\N
guj	guj	guj	gu	I	L	Gujarati	\N
guk	\N	\N	\N	I	L	Gumuz	\N
gul	\N	\N	\N	I	L	Sea Island Creole English	\N
gum	\N	\N	\N	I	L	Guambiano	\N
gun	\N	\N	\N	I	L	Mbyá Guaraní	\N
guo	\N	\N	\N	I	L	Guayabero	\N
gup	\N	\N	\N	I	L	Gunwinggu	\N
guq	\N	\N	\N	I	L	Aché	\N
gur	\N	\N	\N	I	L	Farefare	\N
gus	\N	\N	\N	I	L	Guinean Sign Language	\N
gut	\N	\N	\N	I	L	Maléku Jaíka	\N
guu	\N	\N	\N	I	L	Yanomamö	\N
guw	\N	\N	\N	I	L	Gun	\N
gux	\N	\N	\N	I	L	Gourmanchéma	\N
guz	\N	\N	\N	I	L	Gusii	\N
gva	\N	\N	\N	I	L	Guana (Paraguay)	\N
gvc	\N	\N	\N	I	L	Guanano	\N
gve	\N	\N	\N	I	L	Duwet	\N
gvf	\N	\N	\N	I	L	Golin	\N
gvj	\N	\N	\N	I	L	Guajá	\N
gvl	\N	\N	\N	I	L	Gulay	\N
gvm	\N	\N	\N	I	L	Gurmana	\N
gvn	\N	\N	\N	I	L	Kuku-Yalanji	\N
gvo	\N	\N	\N	I	L	Gavião Do Jiparaná	\N
gvp	\N	\N	\N	I	L	Pará Gavião	\N
gvr	\N	\N	\N	I	L	Gurung	\N
gvs	\N	\N	\N	I	L	Gumawana	\N
gvy	\N	\N	\N	I	E	Guyani	\N
gwa	\N	\N	\N	I	L	Mbato	\N
gwb	\N	\N	\N	I	L	Gwa	\N
gwc	\N	\N	\N	I	L	Gawri	\N
gwd	\N	\N	\N	I	L	Gawwada	\N
gwe	\N	\N	\N	I	L	Gweno	\N
gwf	\N	\N	\N	I	L	Gowro	\N
gwg	\N	\N	\N	I	L	Moo	\N
gwi	gwi	gwi	\N	I	L	Gwichʼin	\N
gwj	\N	\N	\N	I	L	ǀGwi	\N
gwm	\N	\N	\N	I	E	Awngthim	\N
gwn	\N	\N	\N	I	L	Gwandara	\N
gwr	\N	\N	\N	I	L	Gwere	\N
gwt	\N	\N	\N	I	L	Gawar-Bati	\N
gwu	\N	\N	\N	I	E	Guwamu	\N
gww	\N	\N	\N	I	L	Kwini	\N
gwx	\N	\N	\N	I	L	Gua	\N
gxx	\N	\N	\N	I	L	Wè Southern	\N
gya	\N	\N	\N	I	L	Northwest Gbaya	\N
gyb	\N	\N	\N	I	L	Garus	\N
gyd	\N	\N	\N	I	L	Kayardild	\N
gye	\N	\N	\N	I	L	Gyem	\N
gyf	\N	\N	\N	I	E	Gungabula	\N
gyg	\N	\N	\N	I	L	Gbayi	\N
gyi	\N	\N	\N	I	L	Gyele	\N
gyl	\N	\N	\N	I	L	Gayil	\N
gym	\N	\N	\N	I	L	Ngäbere	\N
gyn	\N	\N	\N	I	L	Guyanese Creole English	\N
gyo	\N	\N	\N	I	L	Gyalsumdo	\N
gyr	\N	\N	\N	I	L	Guarayu	\N
gyy	\N	\N	\N	I	E	Gunya	\N
gyz	\N	\N	\N	I	L	Geji	\N
gza	\N	\N	\N	I	L	Ganza	\N
gzi	\N	\N	\N	I	L	Gazi	\N
gzn	\N	\N	\N	I	L	Gane	\N
haa	\N	\N	\N	I	L	Han	\N
hab	\N	\N	\N	I	L	Hanoi Sign Language	\N
hac	\N	\N	\N	I	L	Gurani	\N
had	\N	\N	\N	I	L	Hatam	\N
hae	\N	\N	\N	I	L	Eastern Oromo	\N
haf	\N	\N	\N	I	L	Haiphong Sign Language	\N
hag	\N	\N	\N	I	L	Hanga	\N
hah	\N	\N	\N	I	L	Hahon	\N
hai	hai	hai	\N	M	L	Haida	\N
haj	\N	\N	\N	I	L	Hajong	\N
hak	\N	\N	\N	I	L	Hakka Chinese	\N
hal	\N	\N	\N	I	L	Halang	\N
ham	\N	\N	\N	I	L	Hewa	\N
han	\N	\N	\N	I	L	Hangaza	\N
hao	\N	\N	\N	I	L	Hakö	\N
hap	\N	\N	\N	I	L	Hupla	\N
haq	\N	\N	\N	I	L	Ha	\N
har	\N	\N	\N	I	L	Harari	\N
has	\N	\N	\N	I	L	Haisla	\N
hat	hat	hat	ht	I	L	Haitian	\N
hau	hau	hau	ha	I	L	Hausa	\N
hav	\N	\N	\N	I	L	Havu	\N
haw	haw	haw	\N	I	L	Hawaiian	\N
hax	\N	\N	\N	I	L	Southern Haida	\N
hay	\N	\N	\N	I	L	Haya	\N
haz	\N	\N	\N	I	L	Hazaragi	\N
hba	\N	\N	\N	I	L	Hamba	\N
hbb	\N	\N	\N	I	L	Huba	\N
hbn	\N	\N	\N	I	L	Heiban	\N
hbo	\N	\N	\N	I	H	Ancient Hebrew	\N
hbs	\N	\N	sh	M	L	Serbo-Croatian	Code element for 639-1 has been deprecated
hbu	\N	\N	\N	I	L	Habu	\N
hca	\N	\N	\N	I	L	Andaman Creole Hindi	\N
hch	\N	\N	\N	I	L	Huichol	\N
hdn	\N	\N	\N	I	L	Northern Haida	\N
hds	\N	\N	\N	I	L	Honduras Sign Language	\N
hdy	\N	\N	\N	I	L	Hadiyya	\N
hea	\N	\N	\N	I	L	Northern Qiandong Miao	\N
heb	heb	heb	he	I	L	Hebrew	\N
hed	\N	\N	\N	I	L	Herdé	\N
heg	\N	\N	\N	I	L	Helong	\N
heh	\N	\N	\N	I	L	Hehe	\N
hei	\N	\N	\N	I	L	Heiltsuk	\N
hem	\N	\N	\N	I	L	Hemba	\N
her	her	her	hz	I	L	Herero	\N
hgm	\N	\N	\N	I	L	Haiǁom	\N
hgw	\N	\N	\N	I	L	Haigwai	\N
hhi	\N	\N	\N	I	L	Hoia Hoia	\N
hhr	\N	\N	\N	I	L	Kerak	\N
hhy	\N	\N	\N	I	L	Hoyahoya	\N
hia	\N	\N	\N	I	L	Lamang	\N
hib	\N	\N	\N	I	E	Hibito	\N
hid	\N	\N	\N	I	L	Hidatsa	\N
hif	\N	\N	\N	I	L	Fiji Hindi	\N
hig	\N	\N	\N	I	L	Kamwe	\N
hih	\N	\N	\N	I	L	Pamosu	\N
hii	\N	\N	\N	I	L	Hinduri	\N
hij	\N	\N	\N	I	L	Hijuk	\N
hik	\N	\N	\N	I	L	Seit-Kaitetu	\N
hil	hil	hil	\N	I	L	Hiligaynon	\N
hin	hin	hin	hi	I	L	Hindi	\N
hio	\N	\N	\N	I	L	Tsoa	\N
hir	\N	\N	\N	I	L	Himarimã	\N
hit	hit	hit	\N	I	H	Hittite	\N
hiw	\N	\N	\N	I	L	Hiw	\N
hix	\N	\N	\N	I	L	Hixkaryána	\N
hji	\N	\N	\N	I	L	Haji	\N
hka	\N	\N	\N	I	L	Kahe	\N
hke	\N	\N	\N	I	L	Hunde	\N
hkh	\N	\N	\N	I	L	Khah	\N
hkk	\N	\N	\N	I	L	Hunjara-Kaina Ke	\N
hkn	\N	\N	\N	I	L	Mel-Khaonh	\N
hks	\N	\N	\N	I	L	Hong Kong Sign Language	\N
hla	\N	\N	\N	I	L	Halia	\N
hlb	\N	\N	\N	I	L	Halbi	\N
hld	\N	\N	\N	I	L	Halang Doan	\N
hle	\N	\N	\N	I	L	Hlersu	\N
hlt	\N	\N	\N	I	L	Matu Chin	\N
hlu	\N	\N	\N	I	H	Hieroglyphic Luwian	\N
hma	\N	\N	\N	I	L	Southern Mashan Hmong	\N
hmb	\N	\N	\N	I	L	Humburi Senni Songhay	\N
hmc	\N	\N	\N	I	L	Central Huishui Hmong	\N
hmd	\N	\N	\N	I	L	Large Flowery Miao	\N
hme	\N	\N	\N	I	L	Eastern Huishui Hmong	\N
hmf	\N	\N	\N	I	L	Hmong Don	\N
hmg	\N	\N	\N	I	L	Southwestern Guiyang Hmong	\N
hmh	\N	\N	\N	I	L	Southwestern Huishui Hmong	\N
hmi	\N	\N	\N	I	L	Northern Huishui Hmong	\N
hmj	\N	\N	\N	I	L	Ge	\N
hmk	\N	\N	\N	I	H	Maek	\N
hml	\N	\N	\N	I	L	Luopohe Hmong	\N
hmm	\N	\N	\N	I	L	Central Mashan Hmong	\N
hmn	hmn	hmn	\N	M	L	Hmong	\N
hmo	hmo	hmo	ho	I	L	Hiri Motu	\N
hmp	\N	\N	\N	I	L	Northern Mashan Hmong	\N
hmq	\N	\N	\N	I	L	Eastern Qiandong Miao	\N
hmr	\N	\N	\N	I	L	Hmar	\N
hms	\N	\N	\N	I	L	Southern Qiandong Miao	\N
hmt	\N	\N	\N	I	L	Hamtai	\N
hmu	\N	\N	\N	I	L	Hamap	\N
hmv	\N	\N	\N	I	L	Hmong Dô	\N
hmw	\N	\N	\N	I	L	Western Mashan Hmong	\N
hmy	\N	\N	\N	I	L	Southern Guiyang Hmong	\N
hmz	\N	\N	\N	I	L	Hmong Shua	\N
hna	\N	\N	\N	I	L	Mina (Cameroon)	\N
hnd	\N	\N	\N	I	L	Southern Hindko	\N
hne	\N	\N	\N	I	L	Chhattisgarhi	\N
hng	\N	\N	\N	I	L	Hungu	\N
hnh	\N	\N	\N	I	L	ǁAni	\N
hni	\N	\N	\N	I	L	Hani	\N
hnj	\N	\N	\N	I	L	Hmong Njua	\N
hnn	\N	\N	\N	I	L	Hanunoo	\N
hno	\N	\N	\N	I	L	Northern Hindko	\N
hns	\N	\N	\N	I	L	Caribbean Hindustani	\N
hnu	\N	\N	\N	I	L	Hung	\N
hoa	\N	\N	\N	I	L	Hoava	\N
hob	\N	\N	\N	I	L	Mari (Madang Province)	\N
hoc	\N	\N	\N	I	L	Ho	\N
hod	\N	\N	\N	I	E	Holma	\N
hoe	\N	\N	\N	I	L	Horom	\N
hoh	\N	\N	\N	I	L	Hobyót	\N
hoi	\N	\N	\N	I	L	Holikachuk	\N
hoj	\N	\N	\N	I	L	Hadothi	\N
hol	\N	\N	\N	I	L	Holu	\N
hom	\N	\N	\N	I	E	Homa	\N
hoo	\N	\N	\N	I	L	Holoholo	\N
hop	\N	\N	\N	I	L	Hopi	\N
hor	\N	\N	\N	I	E	Horo	\N
hos	\N	\N	\N	I	L	Ho Chi Minh City Sign Language	\N
hot	\N	\N	\N	I	L	Hote	\N
hov	\N	\N	\N	I	L	Hovongan	\N
how	\N	\N	\N	I	L	Honi	\N
hoy	\N	\N	\N	I	L	Holiya	\N
hoz	\N	\N	\N	I	L	Hozo	\N
hpo	\N	\N	\N	I	E	Hpon	\N
hps	\N	\N	\N	I	L	Hawai'i Sign Language (HSL)	\N
hra	\N	\N	\N	I	L	Hrangkhol	\N
hrc	\N	\N	\N	I	L	Niwer Mil	\N
hre	\N	\N	\N	I	L	Hre	\N
hrk	\N	\N	\N	I	L	Haruku	\N
hrm	\N	\N	\N	I	L	Horned Miao	\N
hro	\N	\N	\N	I	L	Haroi	\N
hrp	\N	\N	\N	I	E	Nhirrpi	\N
hrt	\N	\N	\N	I	L	Hértevin	\N
hru	\N	\N	\N	I	L	Hruso	\N
hrv	hrv	hrv	hr	I	L	Croatian	\N
hrw	\N	\N	\N	I	L	Warwar Feni	\N
hrx	\N	\N	\N	I	L	Hunsrik	\N
hrz	\N	\N	\N	I	L	Harzani	\N
hsb	hsb	hsb	\N	I	L	Upper Sorbian	\N
hsh	\N	\N	\N	I	L	Hungarian Sign Language	\N
hsl	\N	\N	\N	I	L	Hausa Sign Language	\N
hsn	\N	\N	\N	I	L	Xiang Chinese	\N
hss	\N	\N	\N	I	L	Harsusi	\N
hti	\N	\N	\N	I	E	Hoti	\N
hto	\N	\N	\N	I	L	Minica Huitoto	\N
hts	\N	\N	\N	I	L	Hadza	\N
htu	\N	\N	\N	I	L	Hitu	\N
htx	\N	\N	\N	I	H	Middle Hittite	\N
hub	\N	\N	\N	I	L	Huambisa	\N
huc	\N	\N	\N	I	L	ǂHua	\N
hud	\N	\N	\N	I	L	Huaulu	\N
hue	\N	\N	\N	I	L	San Francisco Del Mar Huave	\N
huf	\N	\N	\N	I	L	Humene	\N
hug	\N	\N	\N	I	L	Huachipaeri	\N
huh	\N	\N	\N	I	L	Huilliche	\N
hui	\N	\N	\N	I	L	Huli	\N
huj	\N	\N	\N	I	L	Northern Guiyang Hmong	\N
huk	\N	\N	\N	I	E	Hulung	\N
hul	\N	\N	\N	I	L	Hula	\N
hum	\N	\N	\N	I	L	Hungana	\N
hun	hun	hun	hu	I	L	Hungarian	\N
huo	\N	\N	\N	I	L	Hu	\N
hup	hup	hup	\N	I	L	Hupa	\N
huq	\N	\N	\N	I	L	Tsat	\N
hur	\N	\N	\N	I	L	Halkomelem	\N
hus	\N	\N	\N	I	L	Huastec	\N
hut	\N	\N	\N	I	L	Humla	\N
huu	\N	\N	\N	I	L	Murui Huitoto	\N
huv	\N	\N	\N	I	L	San Mateo Del Mar Huave	\N
huw	\N	\N	\N	I	E	Hukumina	\N
hux	\N	\N	\N	I	L	Nüpode Huitoto	\N
huy	\N	\N	\N	I	L	Hulaulá	\N
huz	\N	\N	\N	I	L	Hunzib	\N
hvc	\N	\N	\N	I	L	Haitian Vodoun Culture Language	\N
hve	\N	\N	\N	I	L	San Dionisio Del Mar Huave	\N
hvk	\N	\N	\N	I	L	Haveke	\N
hvn	\N	\N	\N	I	L	Sabu	\N
hvv	\N	\N	\N	I	L	Santa María Del Mar Huave	\N
hwa	\N	\N	\N	I	L	Wané	\N
hwc	\N	\N	\N	I	L	Hawai'i Creole English	\N
hwo	\N	\N	\N	I	L	Hwana	\N
hya	\N	\N	\N	I	L	Hya	\N
hye	arm	hye	hy	I	L	Armenian	\N
hyw	\N	\N	\N	I	L	Western Armenian	\N
iai	\N	\N	\N	I	L	Iaai	\N
ian	\N	\N	\N	I	L	Iatmul	\N
iar	\N	\N	\N	I	L	Purari	\N
iba	iba	iba	\N	I	L	Iban	\N
ibb	\N	\N	\N	I	L	Ibibio	\N
ibd	\N	\N	\N	I	L	Iwaidja	\N
ibe	\N	\N	\N	I	L	Akpes	\N
ibg	\N	\N	\N	I	L	Ibanag	\N
ibh	\N	\N	\N	I	L	Bih	\N
ibl	\N	\N	\N	I	L	Ibaloi	\N
ibm	\N	\N	\N	I	L	Agoi	\N
ibn	\N	\N	\N	I	L	Ibino	\N
ibo	ibo	ibo	ig	I	L	Igbo	\N
ibr	\N	\N	\N	I	L	Ibuoro	\N
ibu	\N	\N	\N	I	L	Ibu	\N
iby	\N	\N	\N	I	L	Ibani	\N
ica	\N	\N	\N	I	L	Ede Ica	\N
ich	\N	\N	\N	I	L	Etkywan	\N
icl	\N	\N	\N	I	L	Icelandic Sign Language	\N
icr	\N	\N	\N	I	L	Islander Creole English	\N
ida	\N	\N	\N	I	L	Idakho-Isukha-Tiriki	\N
idb	\N	\N	\N	I	L	Indo-Portuguese	\N
idc	\N	\N	\N	I	L	Idon	\N
idd	\N	\N	\N	I	L	Ede Idaca	\N
ide	\N	\N	\N	I	L	Idere	\N
idi	\N	\N	\N	I	L	Idi	\N
ido	ido	ido	io	I	C	Ido	\N
idr	\N	\N	\N	I	L	Indri	\N
ids	\N	\N	\N	I	L	Idesa	\N
idt	\N	\N	\N	I	L	Idaté	\N
idu	\N	\N	\N	I	L	Idoma	\N
ifa	\N	\N	\N	I	L	Amganad Ifugao	\N
ifb	\N	\N	\N	I	L	Batad Ifugao	\N
ife	\N	\N	\N	I	L	Ifè	\N
iff	\N	\N	\N	I	E	Ifo	\N
ifk	\N	\N	\N	I	L	Tuwali Ifugao	\N
ifm	\N	\N	\N	I	L	Teke-Fuumu	\N
ifu	\N	\N	\N	I	L	Mayoyao Ifugao	\N
ify	\N	\N	\N	I	L	Keley-I Kallahan	\N
igb	\N	\N	\N	I	L	Ebira	\N
ige	\N	\N	\N	I	L	Igede	\N
igg	\N	\N	\N	I	L	Igana	\N
igl	\N	\N	\N	I	L	Igala	\N
igm	\N	\N	\N	I	L	Kanggape	\N
ign	\N	\N	\N	I	L	Ignaciano	\N
igo	\N	\N	\N	I	L	Isebe	\N
igs	\N	\N	\N	I	C	Interglossa	\N
igw	\N	\N	\N	I	L	Igwe	\N
ihb	\N	\N	\N	I	L	Iha Based Pidgin	\N
ihi	\N	\N	\N	I	L	Ihievbe	\N
ihp	\N	\N	\N	I	L	Iha	\N
ihw	\N	\N	\N	I	E	Bidhawal	\N
iii	iii	iii	ii	I	L	Sichuan Yi	\N
iin	\N	\N	\N	I	E	Thiin	\N
ijc	\N	\N	\N	I	L	Izon	\N
ije	\N	\N	\N	I	L	Biseni	\N
ijj	\N	\N	\N	I	L	Ede Ije	\N
ijn	\N	\N	\N	I	L	Kalabari	\N
ijs	\N	\N	\N	I	L	Southeast Ijo	\N
ike	\N	\N	\N	I	L	Eastern Canadian Inuktitut	\N
ikh	\N	\N	\N	I	L	Ikhin-Arokho	\N
iki	\N	\N	\N	I	L	Iko	\N
ikk	\N	\N	\N	I	L	Ika	\N
ikl	\N	\N	\N	I	L	Ikulu	\N
iko	\N	\N	\N	I	L	Olulumo-Ikom	\N
ikp	\N	\N	\N	I	L	Ikpeshi	\N
ikr	\N	\N	\N	I	E	Ikaranggal	\N
iks	\N	\N	\N	I	L	Inuit Sign Language	\N
ikt	\N	\N	\N	I	L	Inuinnaqtun	\N
iku	iku	iku	iu	M	L	Inuktitut	\N
ikv	\N	\N	\N	I	L	Iku-Gora-Ankwa	\N
ikw	\N	\N	\N	I	L	Ikwere	\N
ikx	\N	\N	\N	I	L	Ik	\N
ikz	\N	\N	\N	I	L	Ikizu	\N
ila	\N	\N	\N	I	L	Ile Ape	\N
ilb	\N	\N	\N	I	L	Ila	\N
ile	ile	ile	ie	I	C	Interlingue	\N
ilg	\N	\N	\N	I	E	Garig-Ilgar	\N
ili	\N	\N	\N	I	L	Ili Turki	\N
ilk	\N	\N	\N	I	L	Ilongot	\N
ilm	\N	\N	\N	I	L	Iranun (Malaysia)	\N
ilo	ilo	ilo	\N	I	L	Iloko	\N
ilp	\N	\N	\N	I	L	Iranun (Philippines)	\N
ils	\N	\N	\N	I	L	International Sign	\N
ilu	\N	\N	\N	I	L	Ili'uun	\N
ilv	\N	\N	\N	I	L	Ilue	\N
ima	\N	\N	\N	I	L	Mala Malasar	\N
imi	\N	\N	\N	I	L	Anamgura	\N
iml	\N	\N	\N	I	E	Miluk	\N
imn	\N	\N	\N	I	L	Imonda	\N
imo	\N	\N	\N	I	L	Imbongu	\N
imr	\N	\N	\N	I	L	Imroing	\N
ims	\N	\N	\N	I	H	Marsian	\N
imt	\N	\N	\N	I	L	Imotong	\N
imy	\N	\N	\N	I	H	Milyan	\N
ina	ina	ina	ia	I	C	Interlingua (International Auxiliary Language Association)	\N
inb	\N	\N	\N	I	L	Inga	\N
ind	ind	ind	id	I	L	Indonesian	\N
ing	\N	\N	\N	I	L	Degexit'an	\N
inh	inh	inh	\N	I	L	Ingush	\N
inj	\N	\N	\N	I	L	Jungle Inga	\N
inl	\N	\N	\N	I	L	Indonesian Sign Language	\N
inm	\N	\N	\N	I	H	Minaean	\N
inn	\N	\N	\N	I	L	Isinai	\N
ino	\N	\N	\N	I	L	Inoke-Yate	\N
inp	\N	\N	\N	I	L	Iñapari	\N
ins	\N	\N	\N	I	L	Indian Sign Language	\N
int	\N	\N	\N	I	L	Intha	\N
inz	\N	\N	\N	I	E	Ineseño	\N
ior	\N	\N	\N	I	L	Inor	\N
iou	\N	\N	\N	I	L	Tuma-Irumu	\N
iow	\N	\N	\N	I	E	Iowa-Oto	\N
ipi	\N	\N	\N	I	L	Ipili	\N
ipk	ipk	ipk	ik	M	L	Inupiaq	\N
ipo	\N	\N	\N	I	L	Ipiko	\N
iqu	\N	\N	\N	I	L	Iquito	\N
iqw	\N	\N	\N	I	L	Ikwo	\N
ire	\N	\N	\N	I	L	Iresim	\N
irh	\N	\N	\N	I	L	Irarutu	\N
iri	\N	\N	\N	I	L	Rigwe	\N
irk	\N	\N	\N	I	L	Iraqw	\N
irn	\N	\N	\N	I	L	Irántxe	\N
irr	\N	\N	\N	I	L	Ir	\N
iru	\N	\N	\N	I	L	Irula	\N
irx	\N	\N	\N	I	L	Kamberau	\N
iry	\N	\N	\N	I	L	Iraya	\N
isa	\N	\N	\N	I	L	Isabi	\N
isc	\N	\N	\N	I	L	Isconahua	\N
isd	\N	\N	\N	I	L	Isnag	\N
ise	\N	\N	\N	I	L	Italian Sign Language	\N
isg	\N	\N	\N	I	L	Irish Sign Language	\N
ish	\N	\N	\N	I	L	Esan	\N
isi	\N	\N	\N	I	L	Nkem-Nkum	\N
isk	\N	\N	\N	I	L	Ishkashimi	\N
isl	ice	isl	is	I	L	Icelandic	\N
ism	\N	\N	\N	I	L	Masimasi	\N
isn	\N	\N	\N	I	L	Isanzu	\N
iso	\N	\N	\N	I	L	Isoko	\N
isr	\N	\N	\N	I	L	Israeli Sign Language	\N
ist	\N	\N	\N	I	L	Istriot	\N
isu	\N	\N	\N	I	L	Isu (Menchum Division)	\N
isv	\N	\N	\N	I	C	Interslavic	\N
ita	ita	ita	it	I	L	Italian	\N
itb	\N	\N	\N	I	L	Binongan Itneg	\N
itd	\N	\N	\N	I	L	Southern Tidung	\N
ite	\N	\N	\N	I	E	Itene	\N
iti	\N	\N	\N	I	L	Inlaod Itneg	\N
itk	\N	\N	\N	I	L	Judeo-Italian	\N
itl	\N	\N	\N	I	L	Itelmen	\N
itm	\N	\N	\N	I	L	Itu Mbon Uzo	\N
ito	\N	\N	\N	I	L	Itonama	\N
itr	\N	\N	\N	I	L	Iteri	\N
its	\N	\N	\N	I	L	Isekiri	\N
itt	\N	\N	\N	I	L	Maeng Itneg	\N
itv	\N	\N	\N	I	L	Itawit	\N
itw	\N	\N	\N	I	L	Ito	\N
itx	\N	\N	\N	I	L	Itik	\N
ity	\N	\N	\N	I	L	Moyadan Itneg	\N
itz	\N	\N	\N	I	L	Itzá	\N
ium	\N	\N	\N	I	L	Iu Mien	\N
ivb	\N	\N	\N	I	L	Ibatan	\N
ivv	\N	\N	\N	I	L	Ivatan	\N
iwk	\N	\N	\N	I	L	I-Wak	\N
iwm	\N	\N	\N	I	L	Iwam	\N
iwo	\N	\N	\N	I	L	Iwur	\N
iws	\N	\N	\N	I	L	Sepik Iwam	\N
ixc	\N	\N	\N	I	L	Ixcatec	\N
ixl	\N	\N	\N	I	L	Ixil	\N
iya	\N	\N	\N	I	L	Iyayu	\N
iyo	\N	\N	\N	I	L	Mesaka	\N
iyx	\N	\N	\N	I	L	Yaka (Congo)	\N
izh	\N	\N	\N	I	L	Ingrian	\N
izm	\N	\N	\N	I	L	Kizamani	\N
izr	\N	\N	\N	I	L	Izere	\N
izz	\N	\N	\N	I	L	Izii	\N
jaa	\N	\N	\N	I	L	Jamamadí	\N
jab	\N	\N	\N	I	L	Hyam	\N
jac	\N	\N	\N	I	L	Popti'	\N
jad	\N	\N	\N	I	L	Jahanka	\N
jae	\N	\N	\N	I	L	Yabem	\N
jaf	\N	\N	\N	I	L	Jara	\N
jah	\N	\N	\N	I	L	Jah Hut	\N
jaj	\N	\N	\N	I	L	Zazao	\N
jak	\N	\N	\N	I	L	Jakun	\N
jal	\N	\N	\N	I	L	Yalahatan	\N
jam	\N	\N	\N	I	L	Jamaican Creole English	\N
jan	\N	\N	\N	I	E	Jandai	\N
jao	\N	\N	\N	I	L	Yanyuwa	\N
jaq	\N	\N	\N	I	L	Yaqay	\N
jas	\N	\N	\N	I	L	New Caledonian Javanese	\N
jat	\N	\N	\N	I	L	Jakati	\N
jau	\N	\N	\N	I	L	Yaur	\N
jav	jav	jav	jv	I	L	Javanese	\N
jax	\N	\N	\N	I	L	Jambi Malay	\N
jay	\N	\N	\N	I	L	Yan-nhangu	\N
jaz	\N	\N	\N	I	L	Jawe	\N
jbe	\N	\N	\N	I	L	Judeo-Berber	\N
jbi	\N	\N	\N	I	E	Badjiri	\N
jbj	\N	\N	\N	I	L	Arandai	\N
jbk	\N	\N	\N	I	L	Barikewa	\N
jbm	\N	\N	\N	I	L	Bijim	\N
jbn	\N	\N	\N	I	L	Nafusi	\N
jbo	jbo	jbo	\N	I	C	Lojban	\N
jbr	\N	\N	\N	I	L	Jofotek-Bromnya	\N
jbt	\N	\N	\N	I	L	Jabutí	\N
jbu	\N	\N	\N	I	L	Jukun Takum	\N
jbw	\N	\N	\N	I	E	Yawijibaya	\N
jcs	\N	\N	\N	I	L	Jamaican Country Sign Language	\N
jct	\N	\N	\N	I	L	Krymchak	\N
jda	\N	\N	\N	I	L	Jad	\N
jdg	\N	\N	\N	I	L	Jadgali	\N
jdt	\N	\N	\N	I	L	Judeo-Tat	\N
jeb	\N	\N	\N	I	L	Jebero	\N
jee	\N	\N	\N	I	L	Jerung	\N
jeh	\N	\N	\N	I	L	Jeh	\N
jei	\N	\N	\N	I	L	Yei	\N
jek	\N	\N	\N	I	L	Jeri Kuo	\N
jel	\N	\N	\N	I	L	Yelmek	\N
jen	\N	\N	\N	I	L	Dza	\N
jer	\N	\N	\N	I	L	Jere	\N
jet	\N	\N	\N	I	L	Manem	\N
jeu	\N	\N	\N	I	L	Jonkor Bourmataguil	\N
jgb	\N	\N	\N	I	E	Ngbee	\N
jge	\N	\N	\N	I	L	Judeo-Georgian	\N
jgk	\N	\N	\N	I	L	Gwak	\N
jgo	\N	\N	\N	I	L	Ngomba	\N
jhi	\N	\N	\N	I	L	Jehai	\N
jhs	\N	\N	\N	I	L	Jhankot Sign Language	\N
jia	\N	\N	\N	I	L	Jina	\N
jib	\N	\N	\N	I	L	Jibu	\N
jic	\N	\N	\N	I	L	Tol	\N
jid	\N	\N	\N	I	L	Bu (Kaduna State)	\N
jie	\N	\N	\N	I	L	Jilbe	\N
jig	\N	\N	\N	I	L	Jingulu	\N
jih	\N	\N	\N	I	L	sTodsde	\N
jii	\N	\N	\N	I	L	Jiiddu	\N
jil	\N	\N	\N	I	L	Jilim	\N
jim	\N	\N	\N	I	L	Jimi (Cameroon)	\N
jio	\N	\N	\N	I	L	Jiamao	\N
jiq	\N	\N	\N	I	L	Guanyinqiao	\N
jit	\N	\N	\N	I	L	Jita	\N
jiu	\N	\N	\N	I	L	Youle Jinuo	\N
jiv	\N	\N	\N	I	L	Shuar	\N
jiy	\N	\N	\N	I	L	Buyuan Jinuo	\N
jje	\N	\N	\N	I	L	Jejueo	\N
jjr	\N	\N	\N	I	L	Bankal	\N
jka	\N	\N	\N	I	L	Kaera	\N
jkm	\N	\N	\N	I	L	Mobwa Karen	\N
jko	\N	\N	\N	I	L	Kubo	\N
jkp	\N	\N	\N	I	L	Paku Karen	\N
jkr	\N	\N	\N	I	L	Koro (India)	\N
jks	\N	\N	\N	I	L	Amami Koniya Sign Language	\N
jku	\N	\N	\N	I	L	Labir	\N
jle	\N	\N	\N	I	L	Ngile	\N
jls	\N	\N	\N	I	L	Jamaican Sign Language	\N
jma	\N	\N	\N	I	L	Dima	\N
jmb	\N	\N	\N	I	L	Zumbun	\N
jmc	\N	\N	\N	I	L	Machame	\N
jmd	\N	\N	\N	I	L	Yamdena	\N
jmi	\N	\N	\N	I	L	Jimi (Nigeria)	\N
jml	\N	\N	\N	I	L	Jumli	\N
jmn	\N	\N	\N	I	L	Makuri Naga	\N
jmr	\N	\N	\N	I	L	Kamara	\N
jms	\N	\N	\N	I	L	Mashi (Nigeria)	\N
jmw	\N	\N	\N	I	L	Mouwase	\N
jmx	\N	\N	\N	I	L	Western Juxtlahuaca Mixtec	\N
jna	\N	\N	\N	I	L	Jangshung	\N
jnd	\N	\N	\N	I	L	Jandavra	\N
jng	\N	\N	\N	I	E	Yangman	\N
jni	\N	\N	\N	I	L	Janji	\N
jnj	\N	\N	\N	I	L	Yemsa	\N
jnl	\N	\N	\N	I	L	Rawat	\N
jns	\N	\N	\N	I	L	Jaunsari	\N
job	\N	\N	\N	I	L	Joba	\N
jod	\N	\N	\N	I	L	Wojenaka	\N
jog	\N	\N	\N	I	L	Jogi	\N
jor	\N	\N	\N	I	E	Jorá	\N
jos	\N	\N	\N	I	L	Jordanian Sign Language	\N
jow	\N	\N	\N	I	L	Jowulu	\N
jpa	\N	\N	\N	I	H	Jewish Palestinian Aramaic	\N
jpn	jpn	jpn	ja	I	L	Japanese	\N
jpr	jpr	jpr	\N	I	L	Judeo-Persian	\N
jqr	\N	\N	\N	I	L	Jaqaru	\N
jra	\N	\N	\N	I	L	Jarai	\N
jrb	jrb	jrb	\N	M	L	Judeo-Arabic	\N
jrr	\N	\N	\N	I	L	Jiru	\N
jrt	\N	\N	\N	I	L	Jakattoe	\N
jru	\N	\N	\N	I	L	Japrería	\N
jsl	\N	\N	\N	I	L	Japanese Sign Language	\N
jua	\N	\N	\N	I	L	Júma	\N
jub	\N	\N	\N	I	L	Wannu	\N
juc	\N	\N	\N	I	H	Jurchen	\N
jud	\N	\N	\N	I	L	Worodougou	\N
juh	\N	\N	\N	I	L	Hõne	\N
jui	\N	\N	\N	I	E	Ngadjuri	\N
juk	\N	\N	\N	I	L	Wapan	\N
jul	\N	\N	\N	I	L	Jirel	\N
jum	\N	\N	\N	I	L	Jumjum	\N
jun	\N	\N	\N	I	L	Juang	\N
juo	\N	\N	\N	I	L	Jiba	\N
jup	\N	\N	\N	I	L	Hupdë	\N
jur	\N	\N	\N	I	L	Jurúna	\N
jus	\N	\N	\N	I	L	Jumla Sign Language	\N
jut	\N	\N	\N	I	H	Jutish	\N
juu	\N	\N	\N	I	L	Ju	\N
juw	\N	\N	\N	I	L	Wãpha	\N
juy	\N	\N	\N	I	L	Juray	\N
jvd	\N	\N	\N	I	L	Javindo	\N
jvn	\N	\N	\N	I	L	Caribbean Javanese	\N
jwi	\N	\N	\N	I	L	Jwira-Pepesa	\N
jya	\N	\N	\N	I	L	Jiarong	\N
jye	\N	\N	\N	I	L	Judeo-Yemeni Arabic	\N
jyy	\N	\N	\N	I	L	Jaya	\N
kaa	kaa	kaa	\N	I	L	Kara-Kalpak	\N
kab	kab	kab	\N	I	L	Kabyle	\N
kac	kac	kac	\N	I	L	Kachin	\N
kad	\N	\N	\N	I	L	Adara	\N
kae	\N	\N	\N	I	E	Ketangalan	\N
kaf	\N	\N	\N	I	L	Katso	\N
kag	\N	\N	\N	I	L	Kajaman	\N
kah	\N	\N	\N	I	L	Kara (Central African Republic)	\N
kai	\N	\N	\N	I	L	Karekare	\N
kaj	\N	\N	\N	I	L	Jju	\N
kak	\N	\N	\N	I	L	Kalanguya	\N
kal	kal	kal	kl	I	L	Kalaallisut	\N
kam	kam	kam	\N	I	L	Kamba (Kenya)	\N
kan	kan	kan	kn	I	L	Kannada	\N
kao	\N	\N	\N	I	L	Xaasongaxango	\N
kap	\N	\N	\N	I	L	Bezhta	\N
kaq	\N	\N	\N	I	L	Capanahua	\N
kas	kas	kas	ks	I	L	Kashmiri	\N
kat	geo	kat	ka	I	L	Georgian	\N
kau	kau	kau	kr	M	L	Kanuri	\N
kav	\N	\N	\N	I	L	Katukína	\N
kaw	kaw	kaw	\N	I	H	Kawi	\N
kax	\N	\N	\N	I	L	Kao	\N
kay	\N	\N	\N	I	L	Kamayurá	\N
kaz	kaz	kaz	kk	I	L	Kazakh	\N
kba	\N	\N	\N	I	E	Kalarko	\N
kbb	\N	\N	\N	I	E	Kaxuiâna	\N
kbc	\N	\N	\N	I	L	Kadiwéu	\N
kbd	kbd	kbd	\N	I	L	Kabardian	\N
kbe	\N	\N	\N	I	L	Kanju	\N
kbg	\N	\N	\N	I	L	Khamba	\N
kbh	\N	\N	\N	I	L	Camsá	\N
kbi	\N	\N	\N	I	L	Kaptiau	\N
kbj	\N	\N	\N	I	L	Kari	\N
kbk	\N	\N	\N	I	L	Grass Koiari	\N
kbl	\N	\N	\N	I	L	Kanembu	\N
kbm	\N	\N	\N	I	L	Iwal	\N
kbn	\N	\N	\N	I	L	Kare (Central African Republic)	\N
kbo	\N	\N	\N	I	L	Keliko	\N
kbp	\N	\N	\N	I	L	Kabiyè	\N
kbq	\N	\N	\N	I	L	Kamano	\N
kbr	\N	\N	\N	I	L	Kafa	\N
kbs	\N	\N	\N	I	L	Kande	\N
kbt	\N	\N	\N	I	L	Abadi	\N
kbu	\N	\N	\N	I	L	Kabutra	\N
kbv	\N	\N	\N	I	L	Dera (Indonesia)	\N
kbw	\N	\N	\N	I	L	Kaiep	\N
kbx	\N	\N	\N	I	L	Ap Ma	\N
kby	\N	\N	\N	I	L	Manga Kanuri	\N
kbz	\N	\N	\N	I	L	Duhwa	\N
kca	\N	\N	\N	I	L	Khanty	\N
kcb	\N	\N	\N	I	L	Kawacha	\N
kcc	\N	\N	\N	I	L	Lubila	\N
kcd	\N	\N	\N	I	L	Ngkâlmpw Kanum	\N
kce	\N	\N	\N	I	L	Kaivi	\N
kcf	\N	\N	\N	I	L	Ukaan	\N
kcg	\N	\N	\N	I	L	Tyap	\N
kch	\N	\N	\N	I	L	Vono	\N
kci	\N	\N	\N	I	L	Kamantan	\N
kcj	\N	\N	\N	I	L	Kobiana	\N
kck	\N	\N	\N	I	L	Kalanga	\N
kcl	\N	\N	\N	I	L	Kela (Papua New Guinea)	\N
kcm	\N	\N	\N	I	L	Gula (Central African Republic)	\N
kcn	\N	\N	\N	I	L	Nubi	\N
kco	\N	\N	\N	I	L	Kinalakna	\N
kcp	\N	\N	\N	I	L	Kanga	\N
kcq	\N	\N	\N	I	L	Kamo	\N
kcr	\N	\N	\N	I	L	Katla	\N
kcs	\N	\N	\N	I	L	Koenoem	\N
kct	\N	\N	\N	I	L	Kaian	\N
kcu	\N	\N	\N	I	L	Kami (Tanzania)	\N
kcv	\N	\N	\N	I	L	Kete	\N
kcw	\N	\N	\N	I	L	Kabwari	\N
kcx	\N	\N	\N	I	L	Kachama-Ganjule	\N
kcy	\N	\N	\N	I	L	Korandje	\N
kcz	\N	\N	\N	I	L	Konongo	\N
kda	\N	\N	\N	I	E	Worimi	\N
kdc	\N	\N	\N	I	L	Kutu	\N
kdd	\N	\N	\N	I	L	Yankunytjatjara	\N
kde	\N	\N	\N	I	L	Makonde	\N
kdf	\N	\N	\N	I	L	Mamusi	\N
kdg	\N	\N	\N	I	L	Seba	\N
kdh	\N	\N	\N	I	L	Tem	\N
kdi	\N	\N	\N	I	L	Kumam	\N
kdj	\N	\N	\N	I	L	Karamojong	\N
kdk	\N	\N	\N	I	L	Numèè	\N
kdl	\N	\N	\N	I	L	Tsikimba	\N
kdm	\N	\N	\N	I	L	Kagoma	\N
kdn	\N	\N	\N	I	L	Kunda	\N
kdp	\N	\N	\N	I	L	Kaningdon-Nindem	\N
kdq	\N	\N	\N	I	L	Koch	\N
kdr	\N	\N	\N	I	L	Karaim	\N
kdt	\N	\N	\N	I	L	Kuy	\N
kdu	\N	\N	\N	I	L	Kadaru	\N
kdw	\N	\N	\N	I	L	Koneraw	\N
kdx	\N	\N	\N	I	L	Kam	\N
kdy	\N	\N	\N	I	L	Keder	\N
kdz	\N	\N	\N	I	L	Kwaja	\N
kea	\N	\N	\N	I	L	Kabuverdianu	\N
keb	\N	\N	\N	I	L	Kélé	\N
kec	\N	\N	\N	I	L	Keiga	\N
ked	\N	\N	\N	I	L	Kerewe	\N
kee	\N	\N	\N	I	L	Eastern Keres	\N
kef	\N	\N	\N	I	L	Kpessi	\N
keg	\N	\N	\N	I	L	Tese	\N
keh	\N	\N	\N	I	L	Keak	\N
kei	\N	\N	\N	I	L	Kei	\N
kej	\N	\N	\N	I	L	Kadar	\N
kek	\N	\N	\N	I	L	Kekchí	\N
kel	\N	\N	\N	I	L	Kela (Democratic Republic of Congo)	\N
kem	\N	\N	\N	I	L	Kemak	\N
ken	\N	\N	\N	I	L	Kenyang	\N
keo	\N	\N	\N	I	L	Kakwa	\N
kep	\N	\N	\N	I	L	Kaikadi	\N
keq	\N	\N	\N	I	L	Kamar	\N
ker	\N	\N	\N	I	L	Kera	\N
kes	\N	\N	\N	I	L	Kugbo	\N
ket	\N	\N	\N	I	L	Ket	\N
keu	\N	\N	\N	I	L	Akebu	\N
kev	\N	\N	\N	I	L	Kanikkaran	\N
kew	\N	\N	\N	I	L	West Kewa	\N
kex	\N	\N	\N	I	L	Kukna	\N
key	\N	\N	\N	I	L	Kupia	\N
kez	\N	\N	\N	I	L	Kukele	\N
kfa	\N	\N	\N	I	L	Kodava	\N
kfb	\N	\N	\N	I	L	Northwestern Kolami	\N
kfc	\N	\N	\N	I	L	Konda-Dora	\N
kfd	\N	\N	\N	I	L	Korra Koraga	\N
kfe	\N	\N	\N	I	L	Kota (India)	\N
kff	\N	\N	\N	I	L	Koya	\N
kfg	\N	\N	\N	I	L	Kudiya	\N
kfh	\N	\N	\N	I	L	Kurichiya	\N
kfi	\N	\N	\N	I	L	Kannada Kurumba	\N
kfj	\N	\N	\N	I	L	Kemiehua	\N
kfk	\N	\N	\N	I	L	Kinnauri	\N
kfl	\N	\N	\N	I	L	Kung	\N
kfm	\N	\N	\N	I	L	Khunsari	\N
kfn	\N	\N	\N	I	L	Kuk	\N
kfo	\N	\N	\N	I	L	Koro (Côte d'Ivoire)	\N
kfp	\N	\N	\N	I	L	Korwa	\N
kfq	\N	\N	\N	I	L	Korku	\N
kfr	\N	\N	\N	I	L	Kachhi	\N
kfs	\N	\N	\N	I	L	Bilaspuri	\N
kft	\N	\N	\N	I	L	Kanjari	\N
kfu	\N	\N	\N	I	L	Katkari	\N
kfv	\N	\N	\N	I	L	Kurmukar	\N
kfw	\N	\N	\N	I	L	Kharam Naga	\N
kfx	\N	\N	\N	I	L	Kullu Pahari	\N
kfy	\N	\N	\N	I	L	Kumaoni	\N
kfz	\N	\N	\N	I	L	Koromfé	\N
kga	\N	\N	\N	I	L	Koyaga	\N
kgb	\N	\N	\N	I	L	Kawe	\N
kge	\N	\N	\N	I	L	Komering	\N
kgf	\N	\N	\N	I	L	Kube	\N
kgg	\N	\N	\N	I	L	Kusunda	\N
kgi	\N	\N	\N	I	L	Selangor Sign Language	\N
kgj	\N	\N	\N	I	L	Gamale Kham	\N
kgk	\N	\N	\N	I	L	Kaiwá	\N
kgl	\N	\N	\N	I	E	Kunggari	\N
kgn	\N	\N	\N	I	L	Karingani	\N
kgo	\N	\N	\N	I	L	Krongo	\N
kgp	\N	\N	\N	I	L	Kaingang	\N
kgq	\N	\N	\N	I	L	Kamoro	\N
kgr	\N	\N	\N	I	L	Abun	\N
kgs	\N	\N	\N	I	L	Kumbainggar	\N
kgt	\N	\N	\N	I	L	Somyev	\N
kgu	\N	\N	\N	I	L	Kobol	\N
kgv	\N	\N	\N	I	L	Karas	\N
kgw	\N	\N	\N	I	L	Karon Dori	\N
kgx	\N	\N	\N	I	L	Kamaru	\N
kgy	\N	\N	\N	I	L	Kyerung	\N
kha	kha	kha	\N	I	L	Khasi	\N
khb	\N	\N	\N	I	L	Lü	\N
khc	\N	\N	\N	I	L	Tukang Besi North	\N
khd	\N	\N	\N	I	L	Bädi Kanum	\N
khe	\N	\N	\N	I	L	Korowai	\N
khf	\N	\N	\N	I	L	Khuen	\N
khg	\N	\N	\N	I	L	Khams Tibetan	\N
khh	\N	\N	\N	I	L	Kehu	\N
khj	\N	\N	\N	I	L	Kuturmi	\N
khk	\N	\N	\N	I	L	Halh Mongolian	\N
khl	\N	\N	\N	I	L	Lusi	\N
khm	khm	khm	km	I	L	Khmer	\N
khn	\N	\N	\N	I	L	Khandesi	\N
kho	kho	kho	\N	I	H	Khotanese	\N
khp	\N	\N	\N	I	L	Kapori	\N
khq	\N	\N	\N	I	L	Koyra Chiini Songhay	\N
khr	\N	\N	\N	I	L	Kharia	\N
khs	\N	\N	\N	I	L	Kasua	\N
kht	\N	\N	\N	I	L	Khamti	\N
khu	\N	\N	\N	I	L	Nkhumbi	\N
khv	\N	\N	\N	I	L	Khvarshi	\N
khw	\N	\N	\N	I	L	Khowar	\N
khx	\N	\N	\N	I	L	Kanu	\N
khy	\N	\N	\N	I	L	Kele (Democratic Republic of Congo)	\N
khz	\N	\N	\N	I	L	Keapara	\N
kia	\N	\N	\N	I	L	Kim	\N
kib	\N	\N	\N	I	L	Koalib	\N
kic	\N	\N	\N	I	L	Kickapoo	\N
kid	\N	\N	\N	I	L	Koshin	\N
kie	\N	\N	\N	I	L	Kibet	\N
kif	\N	\N	\N	I	L	Eastern Parbate Kham	\N
kig	\N	\N	\N	I	L	Kimaama	\N
kih	\N	\N	\N	I	L	Kilmeri	\N
kii	\N	\N	\N	I	E	Kitsai	\N
kij	\N	\N	\N	I	L	Kilivila	\N
kik	kik	kik	ki	I	L	Kikuyu	\N
kil	\N	\N	\N	I	L	Kariya	\N
kim	\N	\N	\N	I	L	Karagas	\N
kin	kin	kin	rw	I	L	Kinyarwanda	\N
kio	\N	\N	\N	I	L	Kiowa	\N
kip	\N	\N	\N	I	L	Sheshi Kham	\N
kiq	\N	\N	\N	I	L	Kosadle	\N
kir	kir	kir	ky	I	L	Kirghiz	\N
kis	\N	\N	\N	I	L	Kis	\N
kit	\N	\N	\N	I	L	Agob	\N
kiu	\N	\N	\N	I	L	Kirmanjki (individual language)	\N
kiv	\N	\N	\N	I	L	Kimbu	\N
kiw	\N	\N	\N	I	L	Northeast Kiwai	\N
kix	\N	\N	\N	I	L	Khiamniungan Naga	\N
kiy	\N	\N	\N	I	L	Kirikiri	\N
kiz	\N	\N	\N	I	L	Kisi	\N
kja	\N	\N	\N	I	L	Mlap	\N
kjb	\N	\N	\N	I	L	Q'anjob'al	\N
kjc	\N	\N	\N	I	L	Coastal Konjo	\N
kjd	\N	\N	\N	I	L	Southern Kiwai	\N
kje	\N	\N	\N	I	L	Kisar	\N
kjg	\N	\N	\N	I	L	Khmu	\N
kjh	\N	\N	\N	I	L	Khakas	\N
kji	\N	\N	\N	I	L	Zabana	\N
kjj	\N	\N	\N	I	L	Khinalugh	\N
kjk	\N	\N	\N	I	L	Highland Konjo	\N
kjl	\N	\N	\N	I	L	Western Parbate Kham	\N
kjm	\N	\N	\N	I	L	Kháng	\N
kjn	\N	\N	\N	I	L	Kunjen	\N
kjo	\N	\N	\N	I	L	Harijan Kinnauri	\N
kjp	\N	\N	\N	I	L	Pwo Eastern Karen	\N
kjq	\N	\N	\N	I	L	Western Keres	\N
kjr	\N	\N	\N	I	L	Kurudu	\N
kjs	\N	\N	\N	I	L	East Kewa	\N
kjt	\N	\N	\N	I	L	Phrae Pwo Karen	\N
kju	\N	\N	\N	I	L	Kashaya	\N
kjv	\N	\N	\N	I	H	Kaikavian Literary Language	\N
kjx	\N	\N	\N	I	L	Ramopa	\N
kjy	\N	\N	\N	I	L	Erave	\N
kjz	\N	\N	\N	I	L	Bumthangkha	\N
kka	\N	\N	\N	I	L	Kakanda	\N
kkb	\N	\N	\N	I	L	Kwerisa	\N
kkc	\N	\N	\N	I	L	Odoodee	\N
kkd	\N	\N	\N	I	L	Kinuku	\N
kke	\N	\N	\N	I	L	Kakabe	\N
kkf	\N	\N	\N	I	L	Kalaktang Monpa	\N
kkg	\N	\N	\N	I	L	Mabaka Valley Kalinga	\N
kkh	\N	\N	\N	I	L	Khün	\N
kki	\N	\N	\N	I	L	Kagulu	\N
kkj	\N	\N	\N	I	L	Kako	\N
kkk	\N	\N	\N	I	L	Kokota	\N
kkl	\N	\N	\N	I	L	Kosarek Yale	\N
kkm	\N	\N	\N	I	L	Kiong	\N
kkn	\N	\N	\N	I	L	Kon Keu	\N
kko	\N	\N	\N	I	L	Karko	\N
kkp	\N	\N	\N	I	L	Gugubera	\N
kkq	\N	\N	\N	I	L	Kaeku	\N
kkr	\N	\N	\N	I	L	Kir-Balar	\N
kks	\N	\N	\N	I	L	Giiwo	\N
kkt	\N	\N	\N	I	L	Koi	\N
kku	\N	\N	\N	I	L	Tumi	\N
kkv	\N	\N	\N	I	L	Kangean	\N
kkw	\N	\N	\N	I	L	Teke-Kukuya	\N
kkx	\N	\N	\N	I	L	Kohin	\N
kky	\N	\N	\N	I	L	Guugu Yimidhirr	\N
kkz	\N	\N	\N	I	L	Kaska	\N
kla	\N	\N	\N	I	E	Klamath-Modoc	\N
klb	\N	\N	\N	I	L	Kiliwa	\N
klc	\N	\N	\N	I	L	Kolbila	\N
kld	\N	\N	\N	I	L	Gamilaraay	\N
kle	\N	\N	\N	I	L	Kulung (Nepal)	\N
klf	\N	\N	\N	I	L	Kendeje	\N
klg	\N	\N	\N	I	L	Tagakaulo	\N
klh	\N	\N	\N	I	L	Weliki	\N
kli	\N	\N	\N	I	L	Kalumpang	\N
klj	\N	\N	\N	I	L	Khalaj	\N
klk	\N	\N	\N	I	L	Kono (Nigeria)	\N
kll	\N	\N	\N	I	L	Kagan Kalagan	\N
klm	\N	\N	\N	I	L	Migum	\N
kln	\N	\N	\N	M	L	Kalenjin	\N
klo	\N	\N	\N	I	L	Kapya	\N
klp	\N	\N	\N	I	L	Kamasa	\N
klq	\N	\N	\N	I	L	Rumu	\N
klr	\N	\N	\N	I	L	Khaling	\N
kls	\N	\N	\N	I	L	Kalasha	\N
klt	\N	\N	\N	I	L	Nukna	\N
klu	\N	\N	\N	I	L	Klao	\N
klv	\N	\N	\N	I	L	Maskelynes	\N
klw	\N	\N	\N	I	L	Tado	\N
klx	\N	\N	\N	I	L	Koluwawa	\N
kly	\N	\N	\N	I	L	Kalao	\N
klz	\N	\N	\N	I	L	Kabola	\N
kma	\N	\N	\N	I	L	Konni	\N
kmb	kmb	kmb	\N	I	L	Kimbundu	\N
kmc	\N	\N	\N	I	L	Southern Dong	\N
kmd	\N	\N	\N	I	L	Majukayang Kalinga	\N
kme	\N	\N	\N	I	L	Bakole	\N
kmf	\N	\N	\N	I	L	Kare (Papua New Guinea)	\N
kmg	\N	\N	\N	I	L	Kâte	\N
kmh	\N	\N	\N	I	L	Kalam	\N
kmi	\N	\N	\N	I	L	Kami (Nigeria)	\N
kmj	\N	\N	\N	I	L	Kumarbhag Paharia	\N
kmk	\N	\N	\N	I	L	Limos Kalinga	\N
kml	\N	\N	\N	I	L	Tanudan Kalinga	\N
kmm	\N	\N	\N	I	L	Kom (India)	\N
kmn	\N	\N	\N	I	L	Awtuw	\N
kmo	\N	\N	\N	I	L	Kwoma	\N
kmp	\N	\N	\N	I	L	Gimme	\N
kmq	\N	\N	\N	I	L	Kwama	\N
kmr	\N	\N	\N	I	L	Northern Kurdish	\N
kms	\N	\N	\N	I	L	Kamasau	\N
kmt	\N	\N	\N	I	L	Kemtuik	\N
kmu	\N	\N	\N	I	L	Kanite	\N
kmv	\N	\N	\N	I	L	Karipúna Creole French	\N
kmw	\N	\N	\N	I	L	Komo (Democratic Republic of Congo)	\N
kmx	\N	\N	\N	I	L	Waboda	\N
kmy	\N	\N	\N	I	L	Koma	\N
kmz	\N	\N	\N	I	L	Khorasani Turkish	\N
kna	\N	\N	\N	I	L	Dera (Nigeria)	\N
knb	\N	\N	\N	I	L	Lubuagan Kalinga	\N
knc	\N	\N	\N	I	L	Central Kanuri	\N
knd	\N	\N	\N	I	L	Konda	\N
kne	\N	\N	\N	I	L	Kankanaey	\N
knf	\N	\N	\N	I	L	Mankanya	\N
kng	\N	\N	\N	I	L	Koongo	\N
kni	\N	\N	\N	I	L	Kanufi	\N
knj	\N	\N	\N	I	L	Western Kanjobal	\N
knk	\N	\N	\N	I	L	Kuranko	\N
knl	\N	\N	\N	I	L	Keninjal	\N
knm	\N	\N	\N	I	L	Kanamarí	\N
knn	\N	\N	\N	I	L	Konkani (individual language)	\N
kno	\N	\N	\N	I	L	Kono (Sierra Leone)	\N
knp	\N	\N	\N	I	L	Kwanja	\N
knq	\N	\N	\N	I	L	Kintaq	\N
knr	\N	\N	\N	I	L	Kaningra	\N
kns	\N	\N	\N	I	L	Kensiu	\N
knt	\N	\N	\N	I	L	Panoan Katukína	\N
knu	\N	\N	\N	I	L	Kono (Guinea)	\N
knv	\N	\N	\N	I	L	Tabo	\N
knw	\N	\N	\N	I	L	Kung-Ekoka	\N
knx	\N	\N	\N	I	L	Kendayan	\N
kny	\N	\N	\N	I	L	Kanyok	\N
knz	\N	\N	\N	I	L	Kalamsé	\N
koa	\N	\N	\N	I	L	Konomala	\N
koc	\N	\N	\N	I	E	Kpati	\N
kod	\N	\N	\N	I	L	Kodi	\N
koe	\N	\N	\N	I	L	Kacipo-Bale Suri	\N
kof	\N	\N	\N	I	E	Kubi	\N
kog	\N	\N	\N	I	L	Cogui	\N
koh	\N	\N	\N	I	L	Koyo	\N
koi	\N	\N	\N	I	L	Komi-Permyak	\N
kok	kok	kok	\N	M	L	Konkani (macrolanguage)	\N
kol	\N	\N	\N	I	L	Kol (Papua New Guinea)	\N
kom	kom	kom	kv	M	L	Komi	\N
kon	kon	kon	kg	M	L	Kongo	\N
koo	\N	\N	\N	I	L	Konzo	\N
kop	\N	\N	\N	I	L	Waube	\N
koq	\N	\N	\N	I	L	Kota (Gabon)	\N
kor	kor	kor	ko	I	L	Korean	\N
kos	kos	kos	\N	I	L	Kosraean	\N
kot	\N	\N	\N	I	L	Lagwan	\N
kou	\N	\N	\N	I	L	Koke	\N
kov	\N	\N	\N	I	L	Kudu-Camo	\N
kow	\N	\N	\N	I	L	Kugama	\N
koy	\N	\N	\N	I	L	Koyukon	\N
koz	\N	\N	\N	I	L	Korak	\N
kpa	\N	\N	\N	I	L	Kutto	\N
kpb	\N	\N	\N	I	L	Mullu Kurumba	\N
kpc	\N	\N	\N	I	L	Curripaco	\N
kpd	\N	\N	\N	I	L	Koba	\N
kpe	kpe	kpe	\N	M	L	Kpelle	\N
kpf	\N	\N	\N	I	L	Komba	\N
kpg	\N	\N	\N	I	L	Kapingamarangi	\N
kph	\N	\N	\N	I	L	Kplang	\N
kpi	\N	\N	\N	I	L	Kofei	\N
kpj	\N	\N	\N	I	L	Karajá	\N
kpk	\N	\N	\N	I	L	Kpan	\N
kpl	\N	\N	\N	I	L	Kpala	\N
kpm	\N	\N	\N	I	L	Koho	\N
kpn	\N	\N	\N	I	E	Kepkiriwát	\N
kpo	\N	\N	\N	I	L	Ikposo	\N
kpq	\N	\N	\N	I	L	Korupun-Sela	\N
kpr	\N	\N	\N	I	L	Korafe-Yegha	\N
kps	\N	\N	\N	I	L	Tehit	\N
kpt	\N	\N	\N	I	L	Karata	\N
kpu	\N	\N	\N	I	L	Kafoa	\N
kpv	\N	\N	\N	I	L	Komi-Zyrian	\N
kpw	\N	\N	\N	I	L	Kobon	\N
kpx	\N	\N	\N	I	L	Mountain Koiali	\N
kpy	\N	\N	\N	I	L	Koryak	\N
kpz	\N	\N	\N	I	L	Kupsabiny	\N
kqa	\N	\N	\N	I	L	Mum	\N
kqb	\N	\N	\N	I	L	Kovai	\N
kqc	\N	\N	\N	I	L	Doromu-Koki	\N
kqd	\N	\N	\N	I	L	Koy Sanjaq Surat	\N
kqe	\N	\N	\N	I	L	Kalagan	\N
kqf	\N	\N	\N	I	L	Kakabai	\N
kqg	\N	\N	\N	I	L	Khe	\N
kqh	\N	\N	\N	I	L	Kisankasa	\N
kqi	\N	\N	\N	I	L	Koitabu	\N
kqj	\N	\N	\N	I	L	Koromira	\N
kqk	\N	\N	\N	I	L	Kotafon Gbe	\N
kql	\N	\N	\N	I	L	Kyenele	\N
kqm	\N	\N	\N	I	L	Khisa	\N
kqn	\N	\N	\N	I	L	Kaonde	\N
kqo	\N	\N	\N	I	L	Eastern Krahn	\N
kqp	\N	\N	\N	I	L	Kimré	\N
kqq	\N	\N	\N	I	L	Krenak	\N
kqr	\N	\N	\N	I	L	Kimaragang	\N
kqs	\N	\N	\N	I	L	Northern Kissi	\N
kqt	\N	\N	\N	I	L	Klias River Kadazan	\N
kqu	\N	\N	\N	I	E	Seroa	\N
kqv	\N	\N	\N	I	L	Okolod	\N
kqw	\N	\N	\N	I	L	Kandas	\N
kqx	\N	\N	\N	I	L	Mser	\N
kqy	\N	\N	\N	I	L	Koorete	\N
kqz	\N	\N	\N	I	E	Korana	\N
kra	\N	\N	\N	I	L	Kumhali	\N
krb	\N	\N	\N	I	E	Karkin	\N
krc	krc	krc	\N	I	L	Karachay-Balkar	\N
krd	\N	\N	\N	I	L	Kairui-Midiki	\N
kre	\N	\N	\N	I	L	Panará	\N
krf	\N	\N	\N	I	L	Koro (Vanuatu)	\N
krh	\N	\N	\N	I	L	Kurama	\N
kri	\N	\N	\N	I	L	Krio	\N
krj	\N	\N	\N	I	L	Kinaray-A	\N
krk	\N	\N	\N	I	E	Kerek	\N
krl	krl	krl	\N	I	L	Karelian	\N
krn	\N	\N	\N	I	L	Sapo	\N
krp	\N	\N	\N	I	L	Durop	\N
krr	\N	\N	\N	I	L	Krung	\N
krs	\N	\N	\N	I	L	Gbaya (Sudan)	\N
krt	\N	\N	\N	I	L	Tumari Kanuri	\N
kru	kru	kru	\N	I	L	Kurukh	\N
krv	\N	\N	\N	I	L	Kavet	\N
krw	\N	\N	\N	I	L	Western Krahn	\N
krx	\N	\N	\N	I	L	Karon	\N
kry	\N	\N	\N	I	L	Kryts	\N
krz	\N	\N	\N	I	L	Sota Kanum	\N
ksb	\N	\N	\N	I	L	Shambala	\N
ksc	\N	\N	\N	I	L	Southern Kalinga	\N
ksd	\N	\N	\N	I	L	Kuanua	\N
kse	\N	\N	\N	I	L	Kuni	\N
ksf	\N	\N	\N	I	L	Bafia	\N
ksg	\N	\N	\N	I	L	Kusaghe	\N
ksh	\N	\N	\N	I	L	Kölsch	\N
ksi	\N	\N	\N	I	L	Krisa	\N
ksj	\N	\N	\N	I	L	Uare	\N
ksk	\N	\N	\N	I	L	Kansa	\N
ksl	\N	\N	\N	I	L	Kumalu	\N
ksm	\N	\N	\N	I	L	Kumba	\N
ksn	\N	\N	\N	I	L	Kasiguranin	\N
kso	\N	\N	\N	I	L	Kofa	\N
ksp	\N	\N	\N	I	L	Kaba	\N
ksq	\N	\N	\N	I	L	Kwaami	\N
ksr	\N	\N	\N	I	L	Borong	\N
kss	\N	\N	\N	I	L	Southern Kisi	\N
kst	\N	\N	\N	I	L	Winyé	\N
ksu	\N	\N	\N	I	L	Khamyang	\N
ksv	\N	\N	\N	I	L	Kusu	\N
ksw	\N	\N	\N	I	L	S'gaw Karen	\N
ksx	\N	\N	\N	I	L	Kedang	\N
ksy	\N	\N	\N	I	L	Kharia Thar	\N
ksz	\N	\N	\N	I	L	Kodaku	\N
kta	\N	\N	\N	I	L	Katua	\N
ktb	\N	\N	\N	I	L	Kambaata	\N
ktc	\N	\N	\N	I	L	Kholok	\N
ktd	\N	\N	\N	I	L	Kokata	\N
kte	\N	\N	\N	I	L	Nubri	\N
ktf	\N	\N	\N	I	L	Kwami	\N
ktg	\N	\N	\N	I	E	Kalkutung	\N
kth	\N	\N	\N	I	L	Karanga	\N
kti	\N	\N	\N	I	L	North Muyu	\N
ktj	\N	\N	\N	I	L	Plapo Krumen	\N
ktk	\N	\N	\N	I	E	Kaniet	\N
ktl	\N	\N	\N	I	L	Koroshi	\N
ktm	\N	\N	\N	I	L	Kurti	\N
ktn	\N	\N	\N	I	L	Karitiâna	\N
kto	\N	\N	\N	I	L	Kuot	\N
ktp	\N	\N	\N	I	L	Kaduo	\N
ktq	\N	\N	\N	I	E	Katabaga	\N
kts	\N	\N	\N	I	L	South Muyu	\N
ktt	\N	\N	\N	I	L	Ketum	\N
ktu	\N	\N	\N	I	L	Kituba (Democratic Republic of Congo)	\N
ktv	\N	\N	\N	I	L	Eastern Katu	\N
ktw	\N	\N	\N	I	E	Kato	\N
ktx	\N	\N	\N	I	L	Kaxararí	\N
kty	\N	\N	\N	I	L	Kango (Bas-Uélé District)	\N
ktz	\N	\N	\N	I	L	Juǀʼhoan	\N
kua	kua	kua	kj	I	L	Kuanyama	\N
kub	\N	\N	\N	I	L	Kutep	\N
kuc	\N	\N	\N	I	L	Kwinsu	\N
kud	\N	\N	\N	I	L	'Auhelawa	\N
kue	\N	\N	\N	I	L	Kuman (Papua New Guinea)	\N
kuf	\N	\N	\N	I	L	Western Katu	\N
kug	\N	\N	\N	I	L	Kupa	\N
kuh	\N	\N	\N	I	L	Kushi	\N
kui	\N	\N	\N	I	L	Kuikúro-Kalapálo	\N
kuj	\N	\N	\N	I	L	Kuria	\N
kuk	\N	\N	\N	I	L	Kepo'	\N
kul	\N	\N	\N	I	L	Kulere	\N
kum	kum	kum	\N	I	L	Kumyk	\N
kun	\N	\N	\N	I	L	Kunama	\N
kuo	\N	\N	\N	I	L	Kumukio	\N
kup	\N	\N	\N	I	L	Kunimaipa	\N
kuq	\N	\N	\N	I	L	Karipuna	\N
kur	kur	kur	ku	M	L	Kurdish	\N
kus	\N	\N	\N	I	L	Kusaal	\N
kut	kut	kut	\N	I	L	Kutenai	\N
kuu	\N	\N	\N	I	L	Upper Kuskokwim	\N
kuv	\N	\N	\N	I	L	Kur	\N
kuw	\N	\N	\N	I	L	Kpagua	\N
kux	\N	\N	\N	I	L	Kukatja	\N
kuy	\N	\N	\N	I	L	Kuuku-Ya'u	\N
kuz	\N	\N	\N	I	E	Kunza	\N
kva	\N	\N	\N	I	L	Bagvalal	\N
kvb	\N	\N	\N	I	L	Kubu	\N
kvc	\N	\N	\N	I	L	Kove	\N
kvd	\N	\N	\N	I	L	Kui (Indonesia)	\N
kve	\N	\N	\N	I	L	Kalabakan	\N
kvf	\N	\N	\N	I	L	Kabalai	\N
kvg	\N	\N	\N	I	L	Kuni-Boazi	\N
kvh	\N	\N	\N	I	L	Komodo	\N
kvi	\N	\N	\N	I	L	Kwang	\N
kvj	\N	\N	\N	I	L	Psikye	\N
kvk	\N	\N	\N	I	L	Korean Sign Language	\N
kvl	\N	\N	\N	I	L	Kayaw	\N
kvm	\N	\N	\N	I	L	Kendem	\N
kvn	\N	\N	\N	I	L	Border Kuna	\N
kvo	\N	\N	\N	I	L	Dobel	\N
kvp	\N	\N	\N	I	L	Kompane	\N
kvq	\N	\N	\N	I	L	Geba Karen	\N
kvr	\N	\N	\N	I	L	Kerinci	\N
kvt	\N	\N	\N	I	L	Lahta Karen	\N
kvu	\N	\N	\N	I	L	Yinbaw Karen	\N
kvv	\N	\N	\N	I	L	Kola	\N
kvw	\N	\N	\N	I	L	Wersing	\N
kvx	\N	\N	\N	I	L	Parkari Koli	\N
kvy	\N	\N	\N	I	L	Yintale Karen	\N
kvz	\N	\N	\N	I	L	Tsakwambo	\N
kwa	\N	\N	\N	I	L	Dâw	\N
kwb	\N	\N	\N	I	L	Kwa	\N
kwc	\N	\N	\N	I	L	Likwala	\N
kwd	\N	\N	\N	I	L	Kwaio	\N
kwe	\N	\N	\N	I	L	Kwerba	\N
kwf	\N	\N	\N	I	L	Kwara'ae	\N
kwg	\N	\N	\N	I	L	Sara Kaba Deme	\N
kwh	\N	\N	\N	I	L	Kowiai	\N
kwi	\N	\N	\N	I	L	Awa-Cuaiquer	\N
kwj	\N	\N	\N	I	L	Kwanga	\N
kwk	\N	\N	\N	I	L	Kwakiutl	\N
kwl	\N	\N	\N	I	L	Kofyar	\N
kwm	\N	\N	\N	I	L	Kwambi	\N
kwn	\N	\N	\N	I	L	Kwangali	\N
kwo	\N	\N	\N	I	L	Kwomtari	\N
kwp	\N	\N	\N	I	L	Kodia	\N
kwr	\N	\N	\N	I	L	Kwer	\N
kws	\N	\N	\N	I	L	Kwese	\N
kwt	\N	\N	\N	I	L	Kwesten	\N
kwu	\N	\N	\N	I	L	Kwakum	\N
kwv	\N	\N	\N	I	L	Sara Kaba Náà	\N
kww	\N	\N	\N	I	L	Kwinti	\N
kwx	\N	\N	\N	I	L	Khirwar	\N
kwy	\N	\N	\N	I	L	San Salvador Kongo	\N
kwz	\N	\N	\N	I	E	Kwadi	\N
kxa	\N	\N	\N	I	L	Kairiru	\N
kxb	\N	\N	\N	I	L	Krobu	\N
kxc	\N	\N	\N	I	L	Konso	\N
kxd	\N	\N	\N	I	L	Brunei	\N
kxf	\N	\N	\N	I	L	Manumanaw Karen	\N
kxh	\N	\N	\N	I	L	Karo (Ethiopia)	\N
kxi	\N	\N	\N	I	L	Keningau Murut	\N
kxj	\N	\N	\N	I	L	Kulfa	\N
kxk	\N	\N	\N	I	L	Zayein Karen	\N
kxm	\N	\N	\N	I	L	Northern Khmer	\N
kxn	\N	\N	\N	I	L	Kanowit-Tanjong Melanau	\N
kxo	\N	\N	\N	I	E	Kanoé	\N
kxp	\N	\N	\N	I	L	Wadiyara Koli	\N
kxq	\N	\N	\N	I	L	Smärky Kanum	\N
kxr	\N	\N	\N	I	L	Koro (Papua New Guinea)	\N
kxs	\N	\N	\N	I	L	Kangjia	\N
kxt	\N	\N	\N	I	L	Koiwat	\N
kxv	\N	\N	\N	I	L	Kuvi	\N
kxw	\N	\N	\N	I	L	Konai	\N
kxx	\N	\N	\N	I	L	Likuba	\N
kxy	\N	\N	\N	I	L	Kayong	\N
kxz	\N	\N	\N	I	L	Kerewo	\N
kya	\N	\N	\N	I	L	Kwaya	\N
kyb	\N	\N	\N	I	L	Butbut Kalinga	\N
kyc	\N	\N	\N	I	L	Kyaka	\N
kyd	\N	\N	\N	I	L	Karey	\N
kye	\N	\N	\N	I	L	Krache	\N
kyf	\N	\N	\N	I	L	Kouya	\N
kyg	\N	\N	\N	I	L	Keyagana	\N
kyh	\N	\N	\N	I	L	Karok	\N
kyi	\N	\N	\N	I	L	Kiput	\N
kyj	\N	\N	\N	I	L	Karao	\N
kyk	\N	\N	\N	I	L	Kamayo	\N
kyl	\N	\N	\N	I	L	Kalapuya	\N
kym	\N	\N	\N	I	L	Kpatili	\N
kyn	\N	\N	\N	I	L	Northern Binukidnon	\N
kyo	\N	\N	\N	I	L	Kelon	\N
kyp	\N	\N	\N	I	L	Kang	\N
kyq	\N	\N	\N	I	L	Kenga	\N
kyr	\N	\N	\N	I	L	Kuruáya	\N
kys	\N	\N	\N	I	L	Baram Kayan	\N
kyt	\N	\N	\N	I	L	Kayagar	\N
kyu	\N	\N	\N	I	L	Western Kayah	\N
kyv	\N	\N	\N	I	L	Kayort	\N
kyw	\N	\N	\N	I	L	Kudmali	\N
kyx	\N	\N	\N	I	L	Rapoisi	\N
kyy	\N	\N	\N	I	L	Kambaira	\N
kyz	\N	\N	\N	I	L	Kayabí	\N
kza	\N	\N	\N	I	L	Western Karaboro	\N
kzb	\N	\N	\N	I	L	Kaibobo	\N
kzc	\N	\N	\N	I	L	Bondoukou Kulango	\N
kzd	\N	\N	\N	I	L	Kadai	\N
kze	\N	\N	\N	I	L	Kosena	\N
kzf	\N	\N	\N	I	L	Da'a Kaili	\N
kzg	\N	\N	\N	I	L	Kikai	\N
kzi	\N	\N	\N	I	L	Kelabit	\N
kzk	\N	\N	\N	I	E	Kazukuru	\N
kzl	\N	\N	\N	I	L	Kayeli	\N
kzm	\N	\N	\N	I	L	Kais	\N
kzn	\N	\N	\N	I	L	Kokola	\N
kzo	\N	\N	\N	I	L	Kaningi	\N
kzp	\N	\N	\N	I	L	Kaidipang	\N
kzq	\N	\N	\N	I	L	Kaike	\N
kzr	\N	\N	\N	I	L	Karang	\N
kzs	\N	\N	\N	I	L	Sugut Dusun	\N
kzu	\N	\N	\N	I	L	Kayupulau	\N
kzv	\N	\N	\N	I	L	Komyandaret	\N
kzw	\N	\N	\N	I	E	Karirí-Xocó	\N
kzx	\N	\N	\N	I	E	Kamarian	\N
kzy	\N	\N	\N	I	L	Kango (Tshopo District)	\N
kzz	\N	\N	\N	I	L	Kalabra	\N
laa	\N	\N	\N	I	L	Southern Subanen	\N
lab	\N	\N	\N	I	H	Linear A	\N
lac	\N	\N	\N	I	L	Lacandon	\N
lad	lad	lad	\N	I	L	Ladino	\N
lae	\N	\N	\N	I	L	Pattani	\N
laf	\N	\N	\N	I	L	Lafofa	\N
lag	\N	\N	\N	I	L	Rangi	\N
lah	lah	lah	\N	M	L	Lahnda	\N
lai	\N	\N	\N	I	L	Lambya	\N
laj	\N	\N	\N	I	L	Lango (Uganda)	\N
lal	\N	\N	\N	I	L	Lalia	\N
lam	lam	lam	\N	I	L	Lamba	\N
lan	\N	\N	\N	I	L	Laru	\N
lao	lao	lao	lo	I	L	Lao	\N
lap	\N	\N	\N	I	L	Laka (Chad)	\N
laq	\N	\N	\N	I	L	Qabiao	\N
lar	\N	\N	\N	I	L	Larteh	\N
las	\N	\N	\N	I	L	Lama (Togo)	\N
lat	lat	lat	la	I	H	Latin	\N
lau	\N	\N	\N	I	L	Laba	\N
lav	lav	lav	lv	M	L	Latvian	\N
law	\N	\N	\N	I	L	Lauje	\N
lax	\N	\N	\N	I	L	Tiwa	\N
lay	\N	\N	\N	I	L	Lama Bai	\N
laz	\N	\N	\N	I	E	Aribwatsa	\N
lbb	\N	\N	\N	I	L	Label	\N
lbc	\N	\N	\N	I	L	Lakkia	\N
lbe	\N	\N	\N	I	L	Lak	\N
lbf	\N	\N	\N	I	L	Tinani	\N
lbg	\N	\N	\N	I	L	Laopang	\N
lbi	\N	\N	\N	I	L	La'bi	\N
lbj	\N	\N	\N	I	L	Ladakhi	\N
lbk	\N	\N	\N	I	L	Central Bontok	\N
lbl	\N	\N	\N	I	L	Libon Bikol	\N
lbm	\N	\N	\N	I	L	Lodhi	\N
lbn	\N	\N	\N	I	L	Rmeet	\N
lbo	\N	\N	\N	I	L	Laven	\N
lbq	\N	\N	\N	I	L	Wampar	\N
lbr	\N	\N	\N	I	L	Lohorung	\N
lbs	\N	\N	\N	I	L	Libyan Sign Language	\N
lbt	\N	\N	\N	I	L	Lachi	\N
lbu	\N	\N	\N	I	L	Labu	\N
lbv	\N	\N	\N	I	L	Lavatbura-Lamusong	\N
lbw	\N	\N	\N	I	L	Tolaki	\N
lbx	\N	\N	\N	I	L	Lawangan	\N
lby	\N	\N	\N	I	E	Lamalama	\N
lbz	\N	\N	\N	I	L	Lardil	\N
lcc	\N	\N	\N	I	L	Legenyem	\N
lcd	\N	\N	\N	I	L	Lola	\N
lce	\N	\N	\N	I	L	Loncong	\N
lcf	\N	\N	\N	I	L	Lubu	\N
lch	\N	\N	\N	I	L	Luchazi	\N
lcl	\N	\N	\N	I	L	Lisela	\N
lcm	\N	\N	\N	I	L	Tungag	\N
lcp	\N	\N	\N	I	L	Western Lawa	\N
lcq	\N	\N	\N	I	L	Luhu	\N
lcs	\N	\N	\N	I	L	Lisabata-Nuniali	\N
lda	\N	\N	\N	I	L	Kla-Dan	\N
ldb	\N	\N	\N	I	L	Dũya	\N
ldd	\N	\N	\N	I	L	Luri	\N
ldg	\N	\N	\N	I	L	Lenyima	\N
ldh	\N	\N	\N	I	L	Lamja-Dengsa-Tola	\N
ldi	\N	\N	\N	I	L	Laari	\N
ldj	\N	\N	\N	I	L	Lemoro	\N
ldk	\N	\N	\N	I	L	Leelau	\N
ldl	\N	\N	\N	I	L	Kaan	\N
ldm	\N	\N	\N	I	L	Landoma	\N
ldn	\N	\N	\N	I	C	Láadan	\N
ldo	\N	\N	\N	I	L	Loo	\N
ldp	\N	\N	\N	I	L	Tso	\N
ldq	\N	\N	\N	I	L	Lufu	\N
lea	\N	\N	\N	I	L	Lega-Shabunda	\N
leb	\N	\N	\N	I	L	Lala-Bisa	\N
lec	\N	\N	\N	I	L	Leco	\N
led	\N	\N	\N	I	L	Lendu	\N
lee	\N	\N	\N	I	L	Lyélé	\N
lef	\N	\N	\N	I	L	Lelemi	\N
leh	\N	\N	\N	I	L	Lenje	\N
lei	\N	\N	\N	I	L	Lemio	\N
lej	\N	\N	\N	I	L	Lengola	\N
lek	\N	\N	\N	I	L	Leipon	\N
lel	\N	\N	\N	I	L	Lele (Democratic Republic of Congo)	\N
lem	\N	\N	\N	I	L	Nomaande	\N
len	\N	\N	\N	I	E	Lenca	\N
leo	\N	\N	\N	I	L	Leti (Cameroon)	\N
lep	\N	\N	\N	I	L	Lepcha	\N
leq	\N	\N	\N	I	L	Lembena	\N
ler	\N	\N	\N	I	L	Lenkau	\N
les	\N	\N	\N	I	L	Lese	\N
let	\N	\N	\N	I	L	Lesing-Gelimi	\N
leu	\N	\N	\N	I	L	Kara (Papua New Guinea)	\N
lev	\N	\N	\N	I	L	Lamma	\N
lew	\N	\N	\N	I	L	Ledo Kaili	\N
lex	\N	\N	\N	I	L	Luang	\N
ley	\N	\N	\N	I	L	Lemolang	\N
lez	lez	lez	\N	I	L	Lezghian	\N
lfa	\N	\N	\N	I	L	Lefa	\N
lfn	\N	\N	\N	I	C	Lingua Franca Nova	\N
lga	\N	\N	\N	I	L	Lungga	\N
lgb	\N	\N	\N	I	L	Laghu	\N
lgg	\N	\N	\N	I	L	Lugbara	\N
lgh	\N	\N	\N	I	L	Laghuu	\N
lgi	\N	\N	\N	I	L	Lengilu	\N
lgk	\N	\N	\N	I	L	Lingarak	\N
lgl	\N	\N	\N	I	L	Wala	\N
lgm	\N	\N	\N	I	L	Lega-Mwenga	\N
lgn	\N	\N	\N	I	L	T'apo	\N
lgo	\N	\N	\N	I	L	Lango (South Sudan)	\N
lgq	\N	\N	\N	I	L	Logba	\N
lgr	\N	\N	\N	I	L	Lengo	\N
lgs	\N	\N	\N	I	L	Guinea-Bissau Sign Language	\N
lgt	\N	\N	\N	I	L	Pahi	\N
lgu	\N	\N	\N	I	L	Longgu	\N
lgz	\N	\N	\N	I	L	Ligenza	\N
lha	\N	\N	\N	I	L	Laha (Viet Nam)	\N
lhh	\N	\N	\N	I	L	Laha (Indonesia)	\N
lhi	\N	\N	\N	I	L	Lahu Shi	\N
lhl	\N	\N	\N	I	L	Lahul Lohar	\N
lhm	\N	\N	\N	I	L	Lhomi	\N
lhn	\N	\N	\N	I	L	Lahanan	\N
lhp	\N	\N	\N	I	L	Lhokpu	\N
lhs	\N	\N	\N	I	E	Mlahsö	\N
lht	\N	\N	\N	I	L	Lo-Toga	\N
lhu	\N	\N	\N	I	L	Lahu	\N
lia	\N	\N	\N	I	L	West-Central Limba	\N
lib	\N	\N	\N	I	L	Likum	\N
lic	\N	\N	\N	I	L	Hlai	\N
lid	\N	\N	\N	I	L	Nyindrou	\N
lie	\N	\N	\N	I	L	Likila	\N
lif	\N	\N	\N	I	L	Limbu	\N
lig	\N	\N	\N	I	L	Ligbi	\N
lih	\N	\N	\N	I	L	Lihir	\N
lij	\N	\N	\N	I	L	Ligurian	\N
lik	\N	\N	\N	I	L	Lika	\N
lil	\N	\N	\N	I	L	Lillooet	\N
lim	lim	lim	li	I	L	Limburgan	\N
lin	lin	lin	ln	I	L	Lingala	\N
lio	\N	\N	\N	I	L	Liki	\N
lip	\N	\N	\N	I	L	Sekpele	\N
liq	\N	\N	\N	I	L	Libido	\N
lir	\N	\N	\N	I	L	Liberian English	\N
lis	\N	\N	\N	I	L	Lisu	\N
lit	lit	lit	lt	I	L	Lithuanian	\N
liu	\N	\N	\N	I	L	Logorik	\N
liv	\N	\N	\N	I	L	Liv	\N
liw	\N	\N	\N	I	L	Col	\N
lix	\N	\N	\N	I	L	Liabuku	\N
liy	\N	\N	\N	I	L	Banda-Bambari	\N
liz	\N	\N	\N	I	L	Libinza	\N
lja	\N	\N	\N	I	E	Golpa	\N
lje	\N	\N	\N	I	L	Rampi	\N
lji	\N	\N	\N	I	L	Laiyolo	\N
ljl	\N	\N	\N	I	L	Li'o	\N
ljp	\N	\N	\N	I	L	Lampung Api	\N
ljw	\N	\N	\N	I	L	Yirandali	\N
ljx	\N	\N	\N	I	E	Yuru	\N
lka	\N	\N	\N	I	L	Lakalei	\N
lkb	\N	\N	\N	I	L	Kabras	\N
lkc	\N	\N	\N	I	L	Kucong	\N
lkd	\N	\N	\N	I	L	Lakondê	\N
lke	\N	\N	\N	I	L	Kenyi	\N
lkh	\N	\N	\N	I	L	Lakha	\N
lki	\N	\N	\N	I	L	Laki	\N
lkj	\N	\N	\N	I	L	Remun	\N
lkl	\N	\N	\N	I	L	Laeko-Libuat	\N
lkm	\N	\N	\N	I	E	Kalaamaya	\N
lkn	\N	\N	\N	I	L	Lakon	\N
lko	\N	\N	\N	I	L	Khayo	\N
lkr	\N	\N	\N	I	L	Päri	\N
lks	\N	\N	\N	I	L	Kisa	\N
lkt	\N	\N	\N	I	L	Lakota	\N
lku	\N	\N	\N	I	E	Kungkari	\N
lky	\N	\N	\N	I	L	Lokoya	\N
lla	\N	\N	\N	I	L	Lala-Roba	\N
llb	\N	\N	\N	I	L	Lolo	\N
llc	\N	\N	\N	I	L	Lele (Guinea)	\N
lld	\N	\N	\N	I	L	Ladin	\N
lle	\N	\N	\N	I	L	Lele (Papua New Guinea)	\N
llf	\N	\N	\N	I	E	Hermit	\N
llg	\N	\N	\N	I	L	Lole	\N
llh	\N	\N	\N	I	L	Lamu	\N
lli	\N	\N	\N	I	L	Teke-Laali	\N
llj	\N	\N	\N	I	E	Ladji Ladji	\N
llk	\N	\N	\N	I	E	Lelak	\N
lll	\N	\N	\N	I	L	Lilau	\N
llm	\N	\N	\N	I	L	Lasalimu	\N
lln	\N	\N	\N	I	L	Lele (Chad)	\N
llp	\N	\N	\N	I	L	North Efate	\N
llq	\N	\N	\N	I	L	Lolak	\N
lls	\N	\N	\N	I	L	Lithuanian Sign Language	\N
llu	\N	\N	\N	I	L	Lau	\N
llx	\N	\N	\N	I	L	Lauan	\N
lma	\N	\N	\N	I	L	East Limba	\N
lmb	\N	\N	\N	I	L	Merei	\N
lmc	\N	\N	\N	I	E	Limilngan	\N
lmd	\N	\N	\N	I	L	Lumun	\N
lme	\N	\N	\N	I	L	Pévé	\N
lmf	\N	\N	\N	I	L	South Lembata	\N
lmg	\N	\N	\N	I	L	Lamogai	\N
lmh	\N	\N	\N	I	L	Lambichhong	\N
lmi	\N	\N	\N	I	L	Lombi	\N
lmj	\N	\N	\N	I	L	West Lembata	\N
lmk	\N	\N	\N	I	L	Lamkang	\N
lml	\N	\N	\N	I	L	Hano	\N
lmn	\N	\N	\N	I	L	Lambadi	\N
lmo	\N	\N	\N	I	L	Lombard	\N
lmp	\N	\N	\N	I	L	Limbum	\N
lmq	\N	\N	\N	I	L	Lamatuka	\N
lmr	\N	\N	\N	I	L	Lamalera	\N
lmu	\N	\N	\N	I	L	Lamenu	\N
lmv	\N	\N	\N	I	L	Lomaiviti	\N
lmw	\N	\N	\N	I	L	Lake Miwok	\N
lmx	\N	\N	\N	I	L	Laimbue	\N
lmy	\N	\N	\N	I	L	Lamboya	\N
lna	\N	\N	\N	I	L	Langbashe	\N
lnb	\N	\N	\N	I	L	Mbalanhu	\N
lnd	\N	\N	\N	I	L	Lundayeh	\N
lng	\N	\N	\N	I	H	Langobardic	\N
lnh	\N	\N	\N	I	L	Lanoh	\N
lni	\N	\N	\N	I	L	Daantanai'	\N
lnj	\N	\N	\N	I	E	Leningitij	\N
lnl	\N	\N	\N	I	L	South Central Banda	\N
lnm	\N	\N	\N	I	L	Langam	\N
lnn	\N	\N	\N	I	L	Lorediakarkar	\N
lns	\N	\N	\N	I	L	Lamnso'	\N
lnu	\N	\N	\N	I	L	Longuda	\N
lnw	\N	\N	\N	I	E	Lanima	\N
lnz	\N	\N	\N	I	L	Lonzo	\N
loa	\N	\N	\N	I	L	Loloda	\N
lob	\N	\N	\N	I	L	Lobi	\N
loc	\N	\N	\N	I	L	Inonhan	\N
loe	\N	\N	\N	I	L	Saluan	\N
lof	\N	\N	\N	I	L	Logol	\N
log	\N	\N	\N	I	L	Logo	\N
loh	\N	\N	\N	I	L	Laarim	\N
loi	\N	\N	\N	I	L	Loma (Côte d'Ivoire)	\N
loj	\N	\N	\N	I	L	Lou	\N
lok	\N	\N	\N	I	L	Loko	\N
lol	lol	lol	\N	I	L	Mongo	\N
lom	\N	\N	\N	I	L	Loma (Liberia)	\N
lon	\N	\N	\N	I	L	Malawi Lomwe	\N
loo	\N	\N	\N	I	L	Lombo	\N
lop	\N	\N	\N	I	L	Lopa	\N
loq	\N	\N	\N	I	L	Lobala	\N
lor	\N	\N	\N	I	L	Téén	\N
los	\N	\N	\N	I	L	Loniu	\N
lot	\N	\N	\N	I	L	Otuho	\N
lou	\N	\N	\N	I	L	Louisiana Creole	\N
lov	\N	\N	\N	I	L	Lopi	\N
low	\N	\N	\N	I	L	Tampias Lobu	\N
lox	\N	\N	\N	I	L	Loun	\N
loy	\N	\N	\N	I	L	Loke	\N
loz	loz	loz	\N	I	L	Lozi	\N
lpa	\N	\N	\N	I	L	Lelepa	\N
lpe	\N	\N	\N	I	L	Lepki	\N
lpn	\N	\N	\N	I	L	Long Phuri Naga	\N
lpo	\N	\N	\N	I	L	Lipo	\N
lpx	\N	\N	\N	I	L	Lopit	\N
lqr	\N	\N	\N	I	L	Logir	\N
lra	\N	\N	\N	I	L	Rara Bakati'	\N
lrc	\N	\N	\N	I	L	Northern Luri	\N
lre	\N	\N	\N	I	E	Laurentian	\N
lrg	\N	\N	\N	I	E	Laragia	\N
lri	\N	\N	\N	I	L	Marachi	\N
lrk	\N	\N	\N	I	L	Loarki	\N
lrl	\N	\N	\N	I	L	Lari	\N
lrm	\N	\N	\N	I	L	Marama	\N
lrn	\N	\N	\N	I	L	Lorang	\N
lro	\N	\N	\N	I	L	Laro	\N
lrr	\N	\N	\N	I	L	Southern Yamphu	\N
lrt	\N	\N	\N	I	L	Larantuka Malay	\N
lrv	\N	\N	\N	I	L	Larevat	\N
lrz	\N	\N	\N	I	L	Lemerig	\N
lsa	\N	\N	\N	I	L	Lasgerdi	\N
lsb	\N	\N	\N	I	L	Burundian Sign Language	\N
lsc	\N	\N	\N	I	L	Albarradas Sign Language	\N
lsd	\N	\N	\N	I	L	Lishana Deni	\N
lse	\N	\N	\N	I	L	Lusengo	\N
lsh	\N	\N	\N	I	L	Lish	\N
lsi	\N	\N	\N	I	L	Lashi	\N
lsl	\N	\N	\N	I	L	Latvian Sign Language	\N
lsm	\N	\N	\N	I	L	Saamia	\N
lsn	\N	\N	\N	I	L	Tibetan Sign Language	\N
lso	\N	\N	\N	I	L	Laos Sign Language	\N
lsp	\N	\N	\N	I	L	Panamanian Sign Language	\N
lsr	\N	\N	\N	I	L	Aruop	\N
lss	\N	\N	\N	I	L	Lasi	\N
lst	\N	\N	\N	I	L	Trinidad and Tobago Sign Language	\N
lsv	\N	\N	\N	I	L	Sivia Sign Language	\N
lsw	\N	\N	\N	I	L	Seychelles Sign Language	\N
lsy	\N	\N	\N	I	L	Mauritian Sign Language	\N
ltc	\N	\N	\N	I	H	Late Middle Chinese	\N
ltg	\N	\N	\N	I	L	Latgalian	\N
lth	\N	\N	\N	I	L	Thur	\N
lti	\N	\N	\N	I	L	Leti (Indonesia)	\N
ltn	\N	\N	\N	I	L	Latundê	\N
lto	\N	\N	\N	I	L	Tsotso	\N
lts	\N	\N	\N	I	L	Tachoni	\N
ltu	\N	\N	\N	I	L	Latu	\N
ltz	ltz	ltz	lb	I	L	Luxembourgish	\N
lua	lua	lua	\N	I	L	Luba-Lulua	\N
lub	lub	lub	lu	I	L	Luba-Katanga	\N
luc	\N	\N	\N	I	L	Aringa	\N
lud	\N	\N	\N	I	L	Ludian	\N
lue	\N	\N	\N	I	L	Luvale	\N
luf	\N	\N	\N	I	L	Laua	\N
lug	lug	lug	lg	I	L	Ganda	\N
lui	lui	lui	\N	I	E	Luiseno	\N
luj	\N	\N	\N	I	L	Luna	\N
luk	\N	\N	\N	I	L	Lunanakha	\N
lul	\N	\N	\N	I	L	Olu'bo	\N
lum	\N	\N	\N	I	L	Luimbi	\N
lun	lun	lun	\N	I	L	Lunda	\N
luo	luo	luo	\N	I	L	Luo (Kenya and Tanzania)	\N
lup	\N	\N	\N	I	L	Lumbu	\N
luq	\N	\N	\N	I	L	Lucumi	\N
lur	\N	\N	\N	I	L	Laura	\N
lus	lus	lus	\N	I	L	Lushai	\N
lut	\N	\N	\N	I	L	Lushootseed	\N
luu	\N	\N	\N	I	L	Lumba-Yakkha	\N
luv	\N	\N	\N	I	L	Luwati	\N
luw	\N	\N	\N	I	L	Luo (Cameroon)	\N
luy	\N	\N	\N	M	L	Luyia	\N
luz	\N	\N	\N	I	L	Southern Luri	\N
lva	\N	\N	\N	I	L	Maku'a	\N
lvi	\N	\N	\N	I	L	Lavi	\N
lvk	\N	\N	\N	I	L	Lavukaleve	\N
lvl	\N	\N	\N	I	L	Lwel	\N
lvs	\N	\N	\N	I	L	Standard Latvian	\N
lvu	\N	\N	\N	I	L	Levuka	\N
lwa	\N	\N	\N	I	L	Lwalu	\N
lwe	\N	\N	\N	I	L	Lewo Eleng	\N
lwg	\N	\N	\N	I	L	Wanga	\N
lwh	\N	\N	\N	I	L	White Lachi	\N
lwl	\N	\N	\N	I	L	Eastern Lawa	\N
lwm	\N	\N	\N	I	L	Laomian	\N
lwo	\N	\N	\N	I	L	Luwo	\N
lws	\N	\N	\N	I	L	Malawian Sign Language	\N
lwt	\N	\N	\N	I	L	Lewotobi	\N
lwu	\N	\N	\N	I	L	Lawu	\N
lww	\N	\N	\N	I	L	Lewo	\N
lxm	\N	\N	\N	I	L	Lakurumau	\N
lya	\N	\N	\N	I	L	Layakha	\N
lyg	\N	\N	\N	I	L	Lyngngam	\N
lyn	\N	\N	\N	I	L	Luyana	\N
lzh	\N	\N	\N	I	H	Literary Chinese	\N
lzl	\N	\N	\N	I	L	Litzlitz	\N
lzn	\N	\N	\N	I	L	Leinong Naga	\N
lzz	\N	\N	\N	I	L	Laz	\N
maa	\N	\N	\N	I	L	San Jerónimo Tecóatl Mazatec	\N
mab	\N	\N	\N	I	L	Yutanduchi Mixtec	\N
mad	mad	mad	\N	I	L	Madurese	\N
mae	\N	\N	\N	I	L	Bo-Rukul	\N
maf	\N	\N	\N	I	L	Mafa	\N
mag	mag	mag	\N	I	L	Magahi	\N
mah	mah	mah	mh	I	L	Marshallese	\N
mai	mai	mai	\N	I	L	Maithili	\N
maj	\N	\N	\N	I	L	Jalapa De Díaz Mazatec	\N
mak	mak	mak	\N	I	L	Makasar	\N
mal	mal	mal	ml	I	L	Malayalam	\N
mam	\N	\N	\N	I	L	Mam	\N
man	man	man	\N	M	L	Mandingo	\N
maq	\N	\N	\N	I	L	Chiquihuitlán Mazatec	\N
mar	mar	mar	mr	I	L	Marathi	\N
mas	mas	mas	\N	I	L	Masai	\N
mat	\N	\N	\N	I	L	San Francisco Matlatzinca	\N
mau	\N	\N	\N	I	L	Huautla Mazatec	\N
mav	\N	\N	\N	I	L	Sateré-Mawé	\N
maw	\N	\N	\N	I	L	Mampruli	\N
max	\N	\N	\N	I	L	North Moluccan Malay	\N
maz	\N	\N	\N	I	L	Central Mazahua	\N
mba	\N	\N	\N	I	L	Higaonon	\N
mbb	\N	\N	\N	I	L	Western Bukidnon Manobo	\N
mbc	\N	\N	\N	I	L	Macushi	\N
mbd	\N	\N	\N	I	L	Dibabawon Manobo	\N
mbe	\N	\N	\N	I	E	Molale	\N
mbf	\N	\N	\N	I	L	Baba Malay	\N
mbh	\N	\N	\N	I	L	Mangseng	\N
mbi	\N	\N	\N	I	L	Ilianen Manobo	\N
mbj	\N	\N	\N	I	L	Nadëb	\N
mbk	\N	\N	\N	I	L	Malol	\N
mbl	\N	\N	\N	I	L	Maxakalí	\N
mbm	\N	\N	\N	I	L	Ombamba	\N
mbn	\N	\N	\N	I	L	Macaguán	\N
mbo	\N	\N	\N	I	L	Mbo (Cameroon)	\N
mbp	\N	\N	\N	I	L	Malayo	\N
mbq	\N	\N	\N	I	L	Maisin	\N
mbr	\N	\N	\N	I	L	Nukak Makú	\N
mbs	\N	\N	\N	I	L	Sarangani Manobo	\N
mbt	\N	\N	\N	I	L	Matigsalug Manobo	\N
mbu	\N	\N	\N	I	L	Mbula-Bwazza	\N
mbv	\N	\N	\N	I	L	Mbulungish	\N
mbw	\N	\N	\N	I	L	Maring	\N
mbx	\N	\N	\N	I	L	Mari (East Sepik Province)	\N
mby	\N	\N	\N	I	L	Memoni	\N
mbz	\N	\N	\N	I	L	Amoltepec Mixtec	\N
mca	\N	\N	\N	I	L	Maca	\N
mcb	\N	\N	\N	I	L	Machiguenga	\N
mcc	\N	\N	\N	I	L	Bitur	\N
mcd	\N	\N	\N	I	L	Sharanahua	\N
mce	\N	\N	\N	I	L	Itundujia Mixtec	\N
mcf	\N	\N	\N	I	L	Matsés	\N
mcg	\N	\N	\N	I	L	Mapoyo	\N
mch	\N	\N	\N	I	L	Maquiritari	\N
mci	\N	\N	\N	I	L	Mese	\N
mcj	\N	\N	\N	I	L	Mvanip	\N
mck	\N	\N	\N	I	L	Mbunda	\N
mcl	\N	\N	\N	I	E	Macaguaje	\N
mcm	\N	\N	\N	I	L	Malaccan Creole Portuguese	\N
mcn	\N	\N	\N	I	L	Masana	\N
mco	\N	\N	\N	I	L	Coatlán Mixe	\N
mcp	\N	\N	\N	I	L	Makaa	\N
mcq	\N	\N	\N	I	L	Ese	\N
mcr	\N	\N	\N	I	L	Menya	\N
mcs	\N	\N	\N	I	L	Mambai	\N
mct	\N	\N	\N	I	L	Mengisa	\N
mcu	\N	\N	\N	I	L	Cameroon Mambila	\N
mcv	\N	\N	\N	I	L	Minanibai	\N
mcw	\N	\N	\N	I	L	Mawa (Chad)	\N
mcx	\N	\N	\N	I	L	Mpiemo	\N
mcy	\N	\N	\N	I	L	South Watut	\N
mcz	\N	\N	\N	I	L	Mawan	\N
mda	\N	\N	\N	I	L	Mada (Nigeria)	\N
mdb	\N	\N	\N	I	L	Morigi	\N
mdc	\N	\N	\N	I	L	Male (Papua New Guinea)	\N
mdd	\N	\N	\N	I	L	Mbum	\N
mde	\N	\N	\N	I	L	Maba (Chad)	\N
mdf	mdf	mdf	\N	I	L	Moksha	\N
mdg	\N	\N	\N	I	L	Massalat	\N
mdh	\N	\N	\N	I	L	Maguindanaon	\N
mdi	\N	\N	\N	I	L	Mamvu	\N
mdj	\N	\N	\N	I	L	Mangbetu	\N
mdk	\N	\N	\N	I	L	Mangbutu	\N
mdl	\N	\N	\N	I	L	Maltese Sign Language	\N
mdm	\N	\N	\N	I	L	Mayogo	\N
mdn	\N	\N	\N	I	L	Mbati	\N
mdp	\N	\N	\N	I	L	Mbala	\N
mdq	\N	\N	\N	I	L	Mbole	\N
mdr	mdr	mdr	\N	I	L	Mandar	\N
mds	\N	\N	\N	I	L	Maria (Papua New Guinea)	\N
mdt	\N	\N	\N	I	L	Mbere	\N
mdu	\N	\N	\N	I	L	Mboko	\N
mdv	\N	\N	\N	I	L	Santa Lucía Monteverde Mixtec	\N
mdw	\N	\N	\N	I	L	Mbosi	\N
mdx	\N	\N	\N	I	L	Dizin	\N
mdy	\N	\N	\N	I	L	Male (Ethiopia)	\N
mdz	\N	\N	\N	I	L	Suruí Do Pará	\N
mea	\N	\N	\N	I	L	Menka	\N
meb	\N	\N	\N	I	L	Ikobi	\N
mec	\N	\N	\N	I	L	Marra	\N
med	\N	\N	\N	I	L	Melpa	\N
mee	\N	\N	\N	I	L	Mengen	\N
mef	\N	\N	\N	I	L	Megam	\N
meh	\N	\N	\N	I	L	Southwestern Tlaxiaco Mixtec	\N
mei	\N	\N	\N	I	L	Midob	\N
mej	\N	\N	\N	I	L	Meyah	\N
mek	\N	\N	\N	I	L	Mekeo	\N
mel	\N	\N	\N	I	L	Central Melanau	\N
mem	\N	\N	\N	I	E	Mangala	\N
men	men	men	\N	I	L	Mende (Sierra Leone)	\N
meo	\N	\N	\N	I	L	Kedah Malay	\N
mep	\N	\N	\N	I	L	Miriwoong	\N
meq	\N	\N	\N	I	L	Merey	\N
mer	\N	\N	\N	I	L	Meru	\N
mes	\N	\N	\N	I	L	Masmaje	\N
met	\N	\N	\N	I	L	Mato	\N
meu	\N	\N	\N	I	L	Motu	\N
mev	\N	\N	\N	I	L	Mano	\N
mew	\N	\N	\N	I	L	Maaka	\N
mey	\N	\N	\N	I	L	Hassaniyya	\N
mez	\N	\N	\N	I	L	Menominee	\N
mfa	\N	\N	\N	I	L	Pattani Malay	\N
mfb	\N	\N	\N	I	L	Bangka	\N
mfc	\N	\N	\N	I	L	Mba	\N
mfd	\N	\N	\N	I	L	Mendankwe-Nkwen	\N
mfe	\N	\N	\N	I	L	Morisyen	\N
mff	\N	\N	\N	I	L	Naki	\N
mfg	\N	\N	\N	I	L	Mogofin	\N
mfh	\N	\N	\N	I	L	Matal	\N
mfi	\N	\N	\N	I	L	Wandala	\N
mfj	\N	\N	\N	I	L	Mefele	\N
mfk	\N	\N	\N	I	L	North Mofu	\N
mfl	\N	\N	\N	I	L	Putai	\N
mfm	\N	\N	\N	I	L	Marghi South	\N
mfn	\N	\N	\N	I	L	Cross River Mbembe	\N
mfo	\N	\N	\N	I	L	Mbe	\N
mfp	\N	\N	\N	I	L	Makassar Malay	\N
mfq	\N	\N	\N	I	L	Moba	\N
mfr	\N	\N	\N	I	L	Marrithiyel	\N
mfs	\N	\N	\N	I	L	Mexican Sign Language	\N
mft	\N	\N	\N	I	L	Mokerang	\N
mfu	\N	\N	\N	I	L	Mbwela	\N
mfv	\N	\N	\N	I	L	Mandjak	\N
mfw	\N	\N	\N	I	E	Mulaha	\N
mfx	\N	\N	\N	I	L	Melo	\N
mfy	\N	\N	\N	I	L	Mayo	\N
mfz	\N	\N	\N	I	L	Mabaan	\N
mga	mga	mga	\N	I	H	Middle Irish (900-1200)	\N
mgb	\N	\N	\N	I	L	Mararit	\N
mgc	\N	\N	\N	I	L	Morokodo	\N
mgd	\N	\N	\N	I	L	Moru	\N
mge	\N	\N	\N	I	L	Mango	\N
mgf	\N	\N	\N	I	L	Maklew	\N
mgg	\N	\N	\N	I	L	Mpumpong	\N
mgh	\N	\N	\N	I	L	Makhuwa-Meetto	\N
mgi	\N	\N	\N	I	L	Lijili	\N
mgj	\N	\N	\N	I	L	Abureni	\N
mgk	\N	\N	\N	I	L	Mawes	\N
mgl	\N	\N	\N	I	L	Maleu-Kilenge	\N
mgm	\N	\N	\N	I	L	Mambae	\N
mgn	\N	\N	\N	I	L	Mbangi	\N
mgo	\N	\N	\N	I	L	Meta'	\N
mgp	\N	\N	\N	I	L	Eastern Magar	\N
mgq	\N	\N	\N	I	L	Malila	\N
mgr	\N	\N	\N	I	L	Mambwe-Lungu	\N
mgs	\N	\N	\N	I	L	Manda (Tanzania)	\N
mgt	\N	\N	\N	I	L	Mongol	\N
mgu	\N	\N	\N	I	L	Mailu	\N
mgv	\N	\N	\N	I	L	Matengo	\N
mgw	\N	\N	\N	I	L	Matumbi	\N
mgy	\N	\N	\N	I	L	Mbunga	\N
mgz	\N	\N	\N	I	L	Mbugwe	\N
mha	\N	\N	\N	I	L	Manda (India)	\N
mhb	\N	\N	\N	I	L	Mahongwe	\N
mhc	\N	\N	\N	I	L	Mocho	\N
mhd	\N	\N	\N	I	L	Mbugu	\N
mhe	\N	\N	\N	I	L	Besisi	\N
mhf	\N	\N	\N	I	L	Mamaa	\N
mhg	\N	\N	\N	I	L	Margu	\N
mhi	\N	\N	\N	I	L	Ma'di	\N
mhj	\N	\N	\N	I	L	Mogholi	\N
mhk	\N	\N	\N	I	L	Mungaka	\N
mhl	\N	\N	\N	I	L	Mauwake	\N
mhm	\N	\N	\N	I	L	Makhuwa-Moniga	\N
mhn	\N	\N	\N	I	L	Mócheno	\N
mho	\N	\N	\N	I	L	Mashi (Zambia)	\N
mhp	\N	\N	\N	I	L	Balinese Malay	\N
mhq	\N	\N	\N	I	L	Mandan	\N
mhr	\N	\N	\N	I	L	Eastern Mari	\N
mhs	\N	\N	\N	I	L	Buru (Indonesia)	\N
mht	\N	\N	\N	I	L	Mandahuaca	\N
mhu	\N	\N	\N	I	L	Digaro-Mishmi	\N
mhw	\N	\N	\N	I	L	Mbukushu	\N
mhx	\N	\N	\N	I	L	Maru	\N
mhy	\N	\N	\N	I	L	Ma'anyan	\N
mhz	\N	\N	\N	I	L	Mor (Mor Islands)	\N
mia	\N	\N	\N	I	L	Miami	\N
mib	\N	\N	\N	I	L	Atatláhuca Mixtec	\N
mic	mic	mic	\N	I	L	Mi'kmaq	\N
mid	\N	\N	\N	I	L	Mandaic	\N
mie	\N	\N	\N	I	L	Ocotepec Mixtec	\N
mif	\N	\N	\N	I	L	Mofu-Gudur	\N
mig	\N	\N	\N	I	L	San Miguel El Grande Mixtec	\N
mih	\N	\N	\N	I	L	Chayuco Mixtec	\N
mii	\N	\N	\N	I	L	Chigmecatitlán Mixtec	\N
mij	\N	\N	\N	I	L	Abar	\N
mik	\N	\N	\N	I	L	Mikasuki	\N
mil	\N	\N	\N	I	L	Peñoles Mixtec	\N
mim	\N	\N	\N	I	L	Alacatlatzala Mixtec	\N
min	min	min	\N	I	L	Minangkabau	\N
mio	\N	\N	\N	I	L	Pinotepa Nacional Mixtec	\N
mip	\N	\N	\N	I	L	Apasco-Apoala Mixtec	\N
miq	\N	\N	\N	I	L	Mískito	\N
mir	\N	\N	\N	I	L	Isthmus Mixe	\N
mis	mis	mis	\N	S	S	Uncoded languages	\N
mit	\N	\N	\N	I	L	Southern Puebla Mixtec	\N
miu	\N	\N	\N	I	L	Cacaloxtepec Mixtec	\N
miw	\N	\N	\N	I	L	Akoye	\N
mix	\N	\N	\N	I	L	Mixtepec Mixtec	\N
miy	\N	\N	\N	I	L	Ayutla Mixtec	\N
miz	\N	\N	\N	I	L	Coatzospan Mixtec	\N
mjb	\N	\N	\N	I	L	Makalero	\N
mjc	\N	\N	\N	I	L	San Juan Colorado Mixtec	\N
mjd	\N	\N	\N	I	L	Northwest Maidu	\N
mje	\N	\N	\N	I	E	Muskum	\N
mjg	\N	\N	\N	I	L	Tu	\N
mjh	\N	\N	\N	I	L	Mwera (Nyasa)	\N
mji	\N	\N	\N	I	L	Kim Mun	\N
mjj	\N	\N	\N	I	L	Mawak	\N
mjk	\N	\N	\N	I	L	Matukar	\N
mjl	\N	\N	\N	I	L	Mandeali	\N
mjm	\N	\N	\N	I	L	Medebur	\N
mjn	\N	\N	\N	I	L	Ma (Papua New Guinea)	\N
mjo	\N	\N	\N	I	L	Malankuravan	\N
mjp	\N	\N	\N	I	L	Malapandaram	\N
mjq	\N	\N	\N	I	E	Malaryan	\N
mjr	\N	\N	\N	I	L	Malavedan	\N
mjs	\N	\N	\N	I	L	Miship	\N
mjt	\N	\N	\N	I	L	Sauria Paharia	\N
mju	\N	\N	\N	I	L	Manna-Dora	\N
mjv	\N	\N	\N	I	L	Mannan	\N
mjw	\N	\N	\N	I	L	Karbi	\N
mjx	\N	\N	\N	I	L	Mahali	\N
mjy	\N	\N	\N	I	E	Mahican	\N
mjz	\N	\N	\N	I	L	Majhi	\N
mka	\N	\N	\N	I	L	Mbre	\N
mkb	\N	\N	\N	I	L	Mal Paharia	\N
mkc	\N	\N	\N	I	L	Siliput	\N
mkd	mac	mkd	mk	I	L	Macedonian	\N
mke	\N	\N	\N	I	L	Mawchi	\N
mkf	\N	\N	\N	I	L	Miya	\N
mkg	\N	\N	\N	I	L	Mak (China)	\N
mki	\N	\N	\N	I	L	Dhatki	\N
mkj	\N	\N	\N	I	L	Mokilese	\N
mkk	\N	\N	\N	I	L	Byep	\N
mkl	\N	\N	\N	I	L	Mokole	\N
mkm	\N	\N	\N	I	L	Moklen	\N
mkn	\N	\N	\N	I	L	Kupang Malay	\N
mko	\N	\N	\N	I	L	Mingang Doso	\N
mkp	\N	\N	\N	I	L	Moikodi	\N
mkq	\N	\N	\N	I	E	Bay Miwok	\N
mkr	\N	\N	\N	I	L	Malas	\N
mks	\N	\N	\N	I	L	Silacayoapan Mixtec	\N
mkt	\N	\N	\N	I	L	Vamale	\N
mku	\N	\N	\N	I	L	Konyanka Maninka	\N
mkv	\N	\N	\N	I	L	Mafea	\N
mkw	\N	\N	\N	I	L	Kituba (Congo)	\N
mkx	\N	\N	\N	I	L	Kinamiging Manobo	\N
mky	\N	\N	\N	I	L	East Makian	\N
mkz	\N	\N	\N	I	L	Makasae	\N
mla	\N	\N	\N	I	L	Malo	\N
mlb	\N	\N	\N	I	L	Mbule	\N
mlc	\N	\N	\N	I	L	Cao Lan	\N
mle	\N	\N	\N	I	L	Manambu	\N
mlf	\N	\N	\N	I	L	Mal	\N
mlg	mlg	mlg	mg	M	L	Malagasy	\N
mlh	\N	\N	\N	I	L	Mape	\N
mli	\N	\N	\N	I	L	Malimpung	\N
mlj	\N	\N	\N	I	L	Miltu	\N
mlk	\N	\N	\N	I	L	Ilwana	\N
mll	\N	\N	\N	I	L	Malua Bay	\N
mlm	\N	\N	\N	I	L	Mulam	\N
mln	\N	\N	\N	I	L	Malango	\N
mlo	\N	\N	\N	I	L	Mlomp	\N
mlp	\N	\N	\N	I	L	Bargam	\N
mlq	\N	\N	\N	I	L	Western Maninkakan	\N
mlr	\N	\N	\N	I	L	Vame	\N
mls	\N	\N	\N	I	L	Masalit	\N
mlt	mlt	mlt	mt	I	L	Maltese	\N
mlu	\N	\N	\N	I	L	To'abaita	\N
mlv	\N	\N	\N	I	L	Motlav	\N
mlw	\N	\N	\N	I	L	Moloko	\N
mlx	\N	\N	\N	I	L	Malfaxal	\N
mlz	\N	\N	\N	I	L	Malaynon	\N
mma	\N	\N	\N	I	L	Mama	\N
mmb	\N	\N	\N	I	L	Momina	\N
mmc	\N	\N	\N	I	L	Michoacán Mazahua	\N
mmd	\N	\N	\N	I	L	Maonan	\N
mme	\N	\N	\N	I	L	Mae	\N
mmf	\N	\N	\N	I	L	Mundat	\N
mmg	\N	\N	\N	I	L	North Ambrym	\N
mmh	\N	\N	\N	I	L	Mehináku	\N
mmi	\N	\N	\N	I	L	Musar	\N
mmj	\N	\N	\N	I	L	Majhwar	\N
mmk	\N	\N	\N	I	L	Mukha-Dora	\N
mml	\N	\N	\N	I	L	Man Met	\N
mmm	\N	\N	\N	I	L	Maii	\N
mmn	\N	\N	\N	I	L	Mamanwa	\N
mmo	\N	\N	\N	I	L	Mangga Buang	\N
mmp	\N	\N	\N	I	L	Siawi	\N
mmq	\N	\N	\N	I	L	Musak	\N
mmr	\N	\N	\N	I	L	Western Xiangxi Miao	\N
mmt	\N	\N	\N	I	L	Malalamai	\N
mmu	\N	\N	\N	I	L	Mmaala	\N
mmv	\N	\N	\N	I	E	Miriti	\N
mmw	\N	\N	\N	I	L	Emae	\N
mmx	\N	\N	\N	I	L	Madak	\N
mmy	\N	\N	\N	I	L	Migaama	\N
mmz	\N	\N	\N	I	L	Mabaale	\N
mna	\N	\N	\N	I	L	Mbula	\N
mnb	\N	\N	\N	I	L	Muna	\N
mnc	mnc	mnc	\N	I	L	Manchu	\N
mnd	\N	\N	\N	I	L	Mondé	\N
mne	\N	\N	\N	I	L	Naba	\N
mnf	\N	\N	\N	I	L	Mundani	\N
mng	\N	\N	\N	I	L	Eastern Mnong	\N
mnh	\N	\N	\N	I	L	Mono (Democratic Republic of Congo)	\N
mni	mni	mni	\N	I	L	Manipuri	\N
mnj	\N	\N	\N	I	L	Munji	\N
mnk	\N	\N	\N	I	L	Mandinka	\N
mnl	\N	\N	\N	I	L	Tiale	\N
mnm	\N	\N	\N	I	L	Mapena	\N
mnn	\N	\N	\N	I	L	Southern Mnong	\N
mnp	\N	\N	\N	I	L	Min Bei Chinese	\N
mnq	\N	\N	\N	I	L	Minriq	\N
mnr	\N	\N	\N	I	L	Mono (USA)	\N
mns	\N	\N	\N	I	L	Mansi	\N
mnu	\N	\N	\N	I	L	Mer	\N
mnv	\N	\N	\N	I	L	Rennell-Bellona	\N
mnw	\N	\N	\N	I	L	Mon	\N
mnx	\N	\N	\N	I	L	Manikion	\N
mny	\N	\N	\N	I	L	Manyawa	\N
mnz	\N	\N	\N	I	L	Moni	\N
moa	\N	\N	\N	I	L	Mwan	\N
moc	\N	\N	\N	I	L	Mocoví	\N
mod	\N	\N	\N	I	E	Mobilian	\N
moe	\N	\N	\N	I	L	Innu	\N
mog	\N	\N	\N	I	L	Mongondow	\N
moh	moh	moh	\N	I	L	Mohawk	\N
moi	\N	\N	\N	I	L	Mboi	\N
moj	\N	\N	\N	I	L	Monzombo	\N
mok	\N	\N	\N	I	L	Morori	\N
mom	\N	\N	\N	I	E	Mangue	\N
mon	mon	mon	mn	M	L	Mongolian	\N
moo	\N	\N	\N	I	L	Monom	\N
mop	\N	\N	\N	I	L	Mopán Maya	\N
moq	\N	\N	\N	I	L	Mor (Bomberai Peninsula)	\N
mor	\N	\N	\N	I	L	Moro	\N
mos	mos	mos	\N	I	L	Mossi	\N
mot	\N	\N	\N	I	L	Barí	\N
mou	\N	\N	\N	I	L	Mogum	\N
mov	\N	\N	\N	I	L	Mohave	\N
mow	\N	\N	\N	I	L	Moi (Congo)	\N
mox	\N	\N	\N	I	L	Molima	\N
moy	\N	\N	\N	I	L	Shekkacho	\N
moz	\N	\N	\N	I	L	Mukulu	\N
mpa	\N	\N	\N	I	L	Mpoto	\N
mpb	\N	\N	\N	I	L	Malak Malak	\N
mpc	\N	\N	\N	I	L	Mangarrayi	\N
mpd	\N	\N	\N	I	L	Machinere	\N
mpe	\N	\N	\N	I	L	Majang	\N
mpg	\N	\N	\N	I	L	Marba	\N
mph	\N	\N	\N	I	L	Maung	\N
mpi	\N	\N	\N	I	L	Mpade	\N
mpj	\N	\N	\N	I	L	Martu Wangka	\N
mpk	\N	\N	\N	I	L	Mbara (Chad)	\N
mpl	\N	\N	\N	I	L	Middle Watut	\N
mpm	\N	\N	\N	I	L	Yosondúa Mixtec	\N
mpn	\N	\N	\N	I	L	Mindiri	\N
mpo	\N	\N	\N	I	L	Miu	\N
mpp	\N	\N	\N	I	L	Migabac	\N
mpq	\N	\N	\N	I	L	Matís	\N
mpr	\N	\N	\N	I	L	Vangunu	\N
mps	\N	\N	\N	I	L	Dadibi	\N
mpt	\N	\N	\N	I	L	Mian	\N
mpu	\N	\N	\N	I	L	Makuráp	\N
mpv	\N	\N	\N	I	L	Mungkip	\N
mpw	\N	\N	\N	I	L	Mapidian	\N
mpx	\N	\N	\N	I	L	Misima-Panaeati	\N
mpy	\N	\N	\N	I	L	Mapia	\N
mpz	\N	\N	\N	I	L	Mpi	\N
mqa	\N	\N	\N	I	L	Maba (Indonesia)	\N
mqb	\N	\N	\N	I	L	Mbuko	\N
mqc	\N	\N	\N	I	L	Mangole	\N
mqe	\N	\N	\N	I	L	Matepi	\N
mqf	\N	\N	\N	I	L	Momuna	\N
mqg	\N	\N	\N	I	L	Kota Bangun Kutai Malay	\N
mqh	\N	\N	\N	I	L	Tlazoyaltepec Mixtec	\N
mqi	\N	\N	\N	I	L	Mariri	\N
mqj	\N	\N	\N	I	L	Mamasa	\N
mqk	\N	\N	\N	I	L	Rajah Kabunsuwan Manobo	\N
mql	\N	\N	\N	I	L	Mbelime	\N
mqm	\N	\N	\N	I	L	South Marquesan	\N
mqn	\N	\N	\N	I	L	Moronene	\N
mqo	\N	\N	\N	I	L	Modole	\N
mqp	\N	\N	\N	I	L	Manipa	\N
mqq	\N	\N	\N	I	L	Minokok	\N
mqr	\N	\N	\N	I	L	Mander	\N
mqs	\N	\N	\N	I	L	West Makian	\N
mqt	\N	\N	\N	I	L	Mok	\N
mqu	\N	\N	\N	I	L	Mandari	\N
mqv	\N	\N	\N	I	L	Mosimo	\N
mqw	\N	\N	\N	I	L	Murupi	\N
mqx	\N	\N	\N	I	L	Mamuju	\N
mqy	\N	\N	\N	I	L	Manggarai	\N
mqz	\N	\N	\N	I	L	Pano	\N
mra	\N	\N	\N	I	L	Mlabri	\N
mrb	\N	\N	\N	I	L	Marino	\N
mrc	\N	\N	\N	I	L	Maricopa	\N
mrd	\N	\N	\N	I	L	Western Magar	\N
mre	\N	\N	\N	I	E	Martha's Vineyard Sign Language	\N
mrf	\N	\N	\N	I	L	Elseng	\N
mrg	\N	\N	\N	I	L	Mising	\N
mrh	\N	\N	\N	I	L	Mara Chin	\N
mri	mao	mri	mi	I	L	Maori	\N
mrj	\N	\N	\N	I	L	Western Mari	\N
mrk	\N	\N	\N	I	L	Hmwaveke	\N
mrl	\N	\N	\N	I	L	Mortlockese	\N
mrm	\N	\N	\N	I	L	Merlav	\N
mrn	\N	\N	\N	I	L	Cheke Holo	\N
mro	\N	\N	\N	I	L	Mru	\N
mrp	\N	\N	\N	I	L	Morouas	\N
mrq	\N	\N	\N	I	L	North Marquesan	\N
mrr	\N	\N	\N	I	L	Maria (India)	\N
mrs	\N	\N	\N	I	L	Maragus	\N
mrt	\N	\N	\N	I	L	Marghi Central	\N
mru	\N	\N	\N	I	L	Mono (Cameroon)	\N
mrv	\N	\N	\N	I	L	Mangareva	\N
mrw	\N	\N	\N	I	L	Maranao	\N
mrx	\N	\N	\N	I	L	Maremgi	\N
mry	\N	\N	\N	I	L	Mandaya	\N
mrz	\N	\N	\N	I	L	Marind	\N
msa	may	msa	ms	M	L	Malay (macrolanguage)	\N
msb	\N	\N	\N	I	L	Masbatenyo	\N
msc	\N	\N	\N	I	L	Sankaran Maninka	\N
msd	\N	\N	\N	I	L	Yucatec Maya Sign Language	\N
mse	\N	\N	\N	I	L	Musey	\N
msf	\N	\N	\N	I	L	Mekwei	\N
msg	\N	\N	\N	I	L	Moraid	\N
msh	\N	\N	\N	I	L	Masikoro Malagasy	\N
msi	\N	\N	\N	I	L	Sabah Malay	\N
msj	\N	\N	\N	I	L	Ma (Democratic Republic of Congo)	\N
msk	\N	\N	\N	I	L	Mansaka	\N
msl	\N	\N	\N	I	L	Molof	\N
msm	\N	\N	\N	I	L	Agusan Manobo	\N
msn	\N	\N	\N	I	L	Vurës	\N
mso	\N	\N	\N	I	L	Mombum	\N
msp	\N	\N	\N	I	E	Maritsauá	\N
msq	\N	\N	\N	I	L	Caac	\N
msr	\N	\N	\N	I	L	Mongolian Sign Language	\N
mss	\N	\N	\N	I	L	West Masela	\N
msu	\N	\N	\N	I	L	Musom	\N
msv	\N	\N	\N	I	L	Maslam	\N
msw	\N	\N	\N	I	L	Mansoanka	\N
msx	\N	\N	\N	I	L	Moresada	\N
msy	\N	\N	\N	I	L	Aruamu	\N
msz	\N	\N	\N	I	L	Momare	\N
mta	\N	\N	\N	I	L	Cotabato Manobo	\N
mtb	\N	\N	\N	I	L	Anyin Morofo	\N
mtc	\N	\N	\N	I	L	Munit	\N
mtd	\N	\N	\N	I	L	Mualang	\N
mte	\N	\N	\N	I	L	Mono (Solomon Islands)	\N
mtf	\N	\N	\N	I	L	Murik (Papua New Guinea)	\N
mtg	\N	\N	\N	I	L	Una	\N
mth	\N	\N	\N	I	L	Munggui	\N
mti	\N	\N	\N	I	L	Maiwa (Papua New Guinea)	\N
mtj	\N	\N	\N	I	L	Moskona	\N
mtk	\N	\N	\N	I	L	Mbe'	\N
mtl	\N	\N	\N	I	L	Montol	\N
mtm	\N	\N	\N	I	E	Mator	\N
mtn	\N	\N	\N	I	E	Matagalpa	\N
mto	\N	\N	\N	I	L	Totontepec Mixe	\N
mtp	\N	\N	\N	I	L	Wichí Lhamtés Nocten	\N
mtq	\N	\N	\N	I	L	Muong	\N
mtr	\N	\N	\N	I	L	Mewari	\N
mts	\N	\N	\N	I	L	Yora	\N
mtt	\N	\N	\N	I	L	Mota	\N
mtu	\N	\N	\N	I	L	Tututepec Mixtec	\N
mtv	\N	\N	\N	I	L	Asaro'o	\N
mtw	\N	\N	\N	I	L	Southern Binukidnon	\N
mtx	\N	\N	\N	I	L	Tidaá Mixtec	\N
mty	\N	\N	\N	I	L	Nabi	\N
mua	\N	\N	\N	I	L	Mundang	\N
mub	\N	\N	\N	I	L	Mubi	\N
muc	\N	\N	\N	I	L	Ajumbu	\N
mud	\N	\N	\N	I	L	Mednyj Aleut	\N
mue	\N	\N	\N	I	L	Media Lengua	\N
mug	\N	\N	\N	I	L	Musgu	\N
muh	\N	\N	\N	I	L	Mündü	\N
mui	\N	\N	\N	I	L	Musi	\N
muj	\N	\N	\N	I	L	Mabire	\N
muk	\N	\N	\N	I	L	Mugom	\N
mul	mul	mul	\N	S	S	Multiple languages	\N
mum	\N	\N	\N	I	L	Maiwala	\N
muo	\N	\N	\N	I	L	Nyong	\N
mup	\N	\N	\N	I	L	Malvi	\N
muq	\N	\N	\N	I	L	Eastern Xiangxi Miao	\N
mur	\N	\N	\N	I	L	Murle	\N
mus	mus	mus	\N	I	L	Creek	\N
mut	\N	\N	\N	I	L	Western Muria	\N
muu	\N	\N	\N	I	L	Yaaku	\N
muv	\N	\N	\N	I	L	Muthuvan	\N
mux	\N	\N	\N	I	L	Bo-Ung	\N
muy	\N	\N	\N	I	L	Muyang	\N
muz	\N	\N	\N	I	L	Mursi	\N
mva	\N	\N	\N	I	L	Manam	\N
mvb	\N	\N	\N	I	E	Mattole	\N
mvd	\N	\N	\N	I	L	Mamboru	\N
mve	\N	\N	\N	I	L	Marwari (Pakistan)	\N
mvf	\N	\N	\N	I	L	Peripheral Mongolian	\N
mvg	\N	\N	\N	I	L	Yucuañe Mixtec	\N
mvh	\N	\N	\N	I	L	Mulgi	\N
mvi	\N	\N	\N	I	L	Miyako	\N
mvk	\N	\N	\N	I	L	Mekmek	\N
mvl	\N	\N	\N	I	E	Mbara (Australia)	\N
mvn	\N	\N	\N	I	L	Minaveha	\N
mvo	\N	\N	\N	I	L	Marovo	\N
mvp	\N	\N	\N	I	L	Duri	\N
mvq	\N	\N	\N	I	L	Moere	\N
mvr	\N	\N	\N	I	L	Marau	\N
mvs	\N	\N	\N	I	L	Massep	\N
mvt	\N	\N	\N	I	L	Mpotovoro	\N
mvu	\N	\N	\N	I	L	Marfa	\N
mvv	\N	\N	\N	I	L	Tagal Murut	\N
mvw	\N	\N	\N	I	L	Machinga	\N
mvx	\N	\N	\N	I	L	Meoswar	\N
mvy	\N	\N	\N	I	L	Indus Kohistani	\N
mvz	\N	\N	\N	I	L	Mesqan	\N
mwa	\N	\N	\N	I	L	Mwatebu	\N
mwb	\N	\N	\N	I	L	Juwal	\N
mwc	\N	\N	\N	I	L	Are	\N
mwe	\N	\N	\N	I	L	Mwera (Chimwera)	\N
mwf	\N	\N	\N	I	L	Murrinh-Patha	\N
mwg	\N	\N	\N	I	L	Aiklep	\N
mwh	\N	\N	\N	I	L	Mouk-Aria	\N
mwi	\N	\N	\N	I	L	Labo	\N
mwk	\N	\N	\N	I	L	Kita Maninkakan	\N
mwl	mwl	mwl	\N	I	L	Mirandese	\N
mwm	\N	\N	\N	I	L	Sar	\N
mwn	\N	\N	\N	I	L	Nyamwanga	\N
mwo	\N	\N	\N	I	L	Central Maewo	\N
mwp	\N	\N	\N	I	L	Kala Lagaw Ya	\N
mwq	\N	\N	\N	I	L	Mün Chin	\N
mwr	mwr	mwr	\N	M	L	Marwari	\N
mws	\N	\N	\N	I	L	Mwimbi-Muthambi	\N
mwt	\N	\N	\N	I	L	Moken	\N
mwu	\N	\N	\N	I	E	Mittu	\N
mwv	\N	\N	\N	I	L	Mentawai	\N
mww	\N	\N	\N	I	L	Hmong Daw	\N
mwz	\N	\N	\N	I	L	Moingi	\N
mxa	\N	\N	\N	I	L	Northwest Oaxaca Mixtec	\N
mxb	\N	\N	\N	I	L	Tezoatlán Mixtec	\N
mxc	\N	\N	\N	I	L	Manyika	\N
mxd	\N	\N	\N	I	L	Modang	\N
mxe	\N	\N	\N	I	L	Mele-Fila	\N
mxf	\N	\N	\N	I	L	Malgbe	\N
mxg	\N	\N	\N	I	L	Mbangala	\N
mxh	\N	\N	\N	I	L	Mvuba	\N
mxi	\N	\N	\N	I	H	Mozarabic	\N
mxj	\N	\N	\N	I	L	Miju-Mishmi	\N
mxk	\N	\N	\N	I	L	Monumbo	\N
mxl	\N	\N	\N	I	L	Maxi Gbe	\N
mxm	\N	\N	\N	I	L	Meramera	\N
mxn	\N	\N	\N	I	L	Moi (Indonesia)	\N
mxo	\N	\N	\N	I	L	Mbowe	\N
mxp	\N	\N	\N	I	L	Tlahuitoltepec Mixe	\N
mxq	\N	\N	\N	I	L	Juquila Mixe	\N
mxr	\N	\N	\N	I	L	Murik (Malaysia)	\N
mxs	\N	\N	\N	I	L	Huitepec Mixtec	\N
mxt	\N	\N	\N	I	L	Jamiltepec Mixtec	\N
mxu	\N	\N	\N	I	L	Mada (Cameroon)	\N
mxv	\N	\N	\N	I	L	Metlatónoc Mixtec	\N
mxw	\N	\N	\N	I	L	Namo	\N
mxx	\N	\N	\N	I	L	Mahou	\N
mxy	\N	\N	\N	I	L	Southeastern Nochixtlán Mixtec	\N
mxz	\N	\N	\N	I	L	Central Masela	\N
mya	bur	mya	my	I	L	Burmese	\N
myb	\N	\N	\N	I	L	Mbay	\N
myc	\N	\N	\N	I	L	Mayeka	\N
mye	\N	\N	\N	I	L	Myene	\N
myf	\N	\N	\N	I	L	Bambassi	\N
myg	\N	\N	\N	I	L	Manta	\N
myh	\N	\N	\N	I	L	Makah	\N
myj	\N	\N	\N	I	L	Mangayat	\N
myk	\N	\N	\N	I	L	Mamara Senoufo	\N
myl	\N	\N	\N	I	L	Moma	\N
mym	\N	\N	\N	I	L	Me'en	\N
myo	\N	\N	\N	I	L	Anfillo	\N
myp	\N	\N	\N	I	L	Pirahã	\N
myr	\N	\N	\N	I	L	Muniche	\N
mys	\N	\N	\N	I	E	Mesmes	\N
myu	\N	\N	\N	I	L	Mundurukú	\N
myv	myv	myv	\N	I	L	Erzya	\N
myw	\N	\N	\N	I	L	Muyuw	\N
myx	\N	\N	\N	I	L	Masaaba	\N
myy	\N	\N	\N	I	L	Macuna	\N
myz	\N	\N	\N	I	H	Classical Mandaic	\N
mza	\N	\N	\N	I	L	Santa María Zacatepec Mixtec	\N
mzb	\N	\N	\N	I	L	Tumzabt	\N
mzc	\N	\N	\N	I	L	Madagascar Sign Language	\N
mzd	\N	\N	\N	I	L	Malimba	\N
mze	\N	\N	\N	I	L	Morawa	\N
mzg	\N	\N	\N	I	L	Monastic Sign Language	\N
mzh	\N	\N	\N	I	L	Wichí Lhamtés Güisnay	\N
mzi	\N	\N	\N	I	L	Ixcatlán Mazatec	\N
mzj	\N	\N	\N	I	L	Manya	\N
mzk	\N	\N	\N	I	L	Nigeria Mambila	\N
mzl	\N	\N	\N	I	L	Mazatlán Mixe	\N
mzm	\N	\N	\N	I	L	Mumuye	\N
mzn	\N	\N	\N	I	L	Mazanderani	\N
mzo	\N	\N	\N	I	E	Matipuhy	\N
mzp	\N	\N	\N	I	L	Movima	\N
mzq	\N	\N	\N	I	L	Mori Atas	\N
mzr	\N	\N	\N	I	L	Marúbo	\N
mzs	\N	\N	\N	I	L	Macanese	\N
mzt	\N	\N	\N	I	L	Mintil	\N
mzu	\N	\N	\N	I	L	Inapang	\N
mzv	\N	\N	\N	I	L	Manza	\N
mzw	\N	\N	\N	I	L	Deg	\N
mzx	\N	\N	\N	I	L	Mawayana	\N
mzy	\N	\N	\N	I	L	Mozambican Sign Language	\N
mzz	\N	\N	\N	I	L	Maiadomu	\N
naa	\N	\N	\N	I	L	Namla	\N
nab	\N	\N	\N	I	L	Southern Nambikuára	\N
nac	\N	\N	\N	I	L	Narak	\N
nae	\N	\N	\N	I	E	Naka'ela	\N
naf	\N	\N	\N	I	L	Nabak	\N
nag	\N	\N	\N	I	L	Naga Pidgin	\N
naj	\N	\N	\N	I	L	Nalu	\N
nak	\N	\N	\N	I	L	Nakanai	\N
nal	\N	\N	\N	I	L	Nalik	\N
nam	\N	\N	\N	I	L	Ngan'gityemerri	\N
nan	\N	\N	\N	I	L	Min Nan Chinese	\N
nao	\N	\N	\N	I	L	Naaba	\N
nap	nap	nap	\N	I	L	Neapolitan	\N
naq	\N	\N	\N	I	L	Khoekhoe	\N
nar	\N	\N	\N	I	L	Iguta	\N
nas	\N	\N	\N	I	L	Naasioi	\N
nat	\N	\N	\N	I	L	Ca̱hungwa̱rya̱	\N
nau	nau	nau	na	I	L	Nauru	\N
nav	nav	nav	nv	I	L	Navajo	\N
naw	\N	\N	\N	I	L	Nawuri	\N
nax	\N	\N	\N	I	L	Nakwi	\N
nay	\N	\N	\N	I	E	Ngarrindjeri	\N
naz	\N	\N	\N	I	L	Coatepec Nahuatl	\N
nba	\N	\N	\N	I	L	Nyemba	\N
nbb	\N	\N	\N	I	L	Ndoe	\N
nbc	\N	\N	\N	I	L	Chang Naga	\N
nbd	\N	\N	\N	I	L	Ngbinda	\N
nbe	\N	\N	\N	I	L	Konyak Naga	\N
nbg	\N	\N	\N	I	L	Nagarchal	\N
nbh	\N	\N	\N	I	L	Ngamo	\N
nbi	\N	\N	\N	I	L	Mao Naga	\N
nbj	\N	\N	\N	I	L	Ngarinyman	\N
nbk	\N	\N	\N	I	L	Nake	\N
nbl	nbl	nbl	nr	I	L	South Ndebele	\N
nbm	\N	\N	\N	I	L	Ngbaka Ma'bo	\N
nbn	\N	\N	\N	I	L	Kuri	\N
nbo	\N	\N	\N	I	L	Nkukoli	\N
nbp	\N	\N	\N	I	L	Nnam	\N
nbq	\N	\N	\N	I	L	Nggem	\N
nbr	\N	\N	\N	I	L	Numana	\N
nbs	\N	\N	\N	I	L	Namibian Sign Language	\N
nbt	\N	\N	\N	I	L	Na	\N
nbu	\N	\N	\N	I	L	Rongmei Naga	\N
nbv	\N	\N	\N	I	L	Ngamambo	\N
nbw	\N	\N	\N	I	L	Southern Ngbandi	\N
nby	\N	\N	\N	I	L	Ningera	\N
nca	\N	\N	\N	I	L	Iyo	\N
ncb	\N	\N	\N	I	L	Central Nicobarese	\N
ncc	\N	\N	\N	I	L	Ponam	\N
ncd	\N	\N	\N	I	L	Nachering	\N
nce	\N	\N	\N	I	L	Yale	\N
ncf	\N	\N	\N	I	L	Notsi	\N
ncg	\N	\N	\N	I	L	Nisga'a	\N
nch	\N	\N	\N	I	L	Central Huasteca Nahuatl	\N
nci	\N	\N	\N	I	H	Classical Nahuatl	\N
ncj	\N	\N	\N	I	L	Northern Puebla Nahuatl	\N
nck	\N	\N	\N	I	L	Na-kara	\N
ncl	\N	\N	\N	I	L	Michoacán Nahuatl	\N
ncm	\N	\N	\N	I	L	Nambo	\N
ncn	\N	\N	\N	I	L	Nauna	\N
nco	\N	\N	\N	I	L	Sibe	\N
ncq	\N	\N	\N	I	L	Northern Katang	\N
ncr	\N	\N	\N	I	L	Ncane	\N
ncs	\N	\N	\N	I	L	Nicaraguan Sign Language	\N
nct	\N	\N	\N	I	L	Chothe Naga	\N
ncu	\N	\N	\N	I	L	Chumburung	\N
ncx	\N	\N	\N	I	L	Central Puebla Nahuatl	\N
ncz	\N	\N	\N	I	E	Natchez	\N
nda	\N	\N	\N	I	L	Ndasa	\N
ndb	\N	\N	\N	I	L	Kenswei Nsei	\N
ndc	\N	\N	\N	I	L	Ndau	\N
ndd	\N	\N	\N	I	L	Nde-Nsele-Nta	\N
nde	nde	nde	nd	I	L	North Ndebele	\N
ndf	\N	\N	\N	I	H	Nadruvian	\N
ndg	\N	\N	\N	I	L	Ndengereko	\N
ndh	\N	\N	\N	I	L	Ndali	\N
ndi	\N	\N	\N	I	L	Samba Leko	\N
ndj	\N	\N	\N	I	L	Ndamba	\N
ndk	\N	\N	\N	I	L	Ndaka	\N
ndl	\N	\N	\N	I	L	Ndolo	\N
ndm	\N	\N	\N	I	L	Ndam	\N
ndn	\N	\N	\N	I	L	Ngundi	\N
ndo	ndo	ndo	ng	I	L	Ndonga	\N
ndp	\N	\N	\N	I	L	Ndo	\N
ndq	\N	\N	\N	I	L	Ndombe	\N
ndr	\N	\N	\N	I	L	Ndoola	\N
nds	nds	nds	\N	I	L	Low German	\N
ndt	\N	\N	\N	I	L	Ndunga	\N
ndu	\N	\N	\N	I	L	Dugun	\N
ndv	\N	\N	\N	I	L	Ndut	\N
ndw	\N	\N	\N	I	L	Ndobo	\N
ndx	\N	\N	\N	I	L	Nduga	\N
ndy	\N	\N	\N	I	L	Lutos	\N
ndz	\N	\N	\N	I	L	Ndogo	\N
nea	\N	\N	\N	I	L	Eastern Ngad'a	\N
neb	\N	\N	\N	I	L	Toura (Côte d'Ivoire)	\N
nec	\N	\N	\N	I	L	Nedebang	\N
ned	\N	\N	\N	I	L	Nde-Gbite	\N
nee	\N	\N	\N	I	L	Nêlêmwa-Nixumwak	\N
nef	\N	\N	\N	I	L	Nefamese	\N
neg	\N	\N	\N	I	L	Negidal	\N
neh	\N	\N	\N	I	L	Nyenkha	\N
nei	\N	\N	\N	I	H	Neo-Hittite	\N
nej	\N	\N	\N	I	L	Neko	\N
nek	\N	\N	\N	I	L	Neku	\N
nem	\N	\N	\N	I	L	Nemi	\N
nen	\N	\N	\N	I	L	Nengone	\N
neo	\N	\N	\N	I	L	Ná-Meo	\N
nep	nep	nep	ne	M	L	Nepali (macrolanguage)	\N
neq	\N	\N	\N	I	L	North Central Mixe	\N
ner	\N	\N	\N	I	L	Yahadian	\N
nes	\N	\N	\N	I	L	Bhoti Kinnauri	\N
net	\N	\N	\N	I	L	Nete	\N
neu	\N	\N	\N	I	C	Neo	\N
nev	\N	\N	\N	I	L	Nyaheun	\N
new	new	new	\N	I	L	Newari	\N
nex	\N	\N	\N	I	L	Neme	\N
ney	\N	\N	\N	I	L	Neyo	\N
nez	\N	\N	\N	I	L	Nez Perce	\N
nfa	\N	\N	\N	I	L	Dhao	\N
nfd	\N	\N	\N	I	L	Ahwai	\N
nfl	\N	\N	\N	I	L	Ayiwo	\N
nfr	\N	\N	\N	I	L	Nafaanra	\N
nfu	\N	\N	\N	I	L	Mfumte	\N
nga	\N	\N	\N	I	L	Ngbaka	\N
ngb	\N	\N	\N	I	L	Northern Ngbandi	\N
ngc	\N	\N	\N	I	L	Ngombe (Democratic Republic of Congo)	\N
ngd	\N	\N	\N	I	L	Ngando (Central African Republic)	\N
nge	\N	\N	\N	I	L	Ngemba	\N
ngg	\N	\N	\N	I	L	Ngbaka Manza	\N
ngh	\N	\N	\N	I	L	Nǁng	\N
ngi	\N	\N	\N	I	L	Ngizim	\N
ngj	\N	\N	\N	I	L	Ngie	\N
ngk	\N	\N	\N	I	L	Dalabon	\N
ngl	\N	\N	\N	I	L	Lomwe	\N
ngm	\N	\N	\N	I	L	Ngatik Men's Creole	\N
ngn	\N	\N	\N	I	L	Ngwo	\N
ngp	\N	\N	\N	I	L	Ngulu	\N
ngq	\N	\N	\N	I	L	Ngurimi	\N
ngr	\N	\N	\N	I	L	Engdewu	\N
ngs	\N	\N	\N	I	L	Gvoko	\N
ngt	\N	\N	\N	I	L	Kriang	\N
ngu	\N	\N	\N	I	L	Guerrero Nahuatl	\N
ngv	\N	\N	\N	I	E	Nagumi	\N
ngw	\N	\N	\N	I	L	Ngwaba	\N
ngx	\N	\N	\N	I	L	Nggwahyi	\N
ngy	\N	\N	\N	I	L	Tibea	\N
ngz	\N	\N	\N	I	L	Ngungwel	\N
nha	\N	\N	\N	I	L	Nhanda	\N
nhb	\N	\N	\N	I	L	Beng	\N
nhc	\N	\N	\N	I	E	Tabasco Nahuatl	\N
nhd	\N	\N	\N	I	L	Chiripá	\N
nhe	\N	\N	\N	I	L	Eastern Huasteca Nahuatl	\N
nhf	\N	\N	\N	I	L	Nhuwala	\N
nhg	\N	\N	\N	I	L	Tetelcingo Nahuatl	\N
nhh	\N	\N	\N	I	L	Nahari	\N
nhi	\N	\N	\N	I	L	Zacatlán-Ahuacatlán-Tepetzintla Nahuatl	\N
nhk	\N	\N	\N	I	L	Isthmus-Cosoleacaque Nahuatl	\N
nhm	\N	\N	\N	I	L	Morelos Nahuatl	\N
nhn	\N	\N	\N	I	L	Central Nahuatl	\N
nho	\N	\N	\N	I	L	Takuu	\N
nhp	\N	\N	\N	I	L	Isthmus-Pajapan Nahuatl	\N
nhq	\N	\N	\N	I	L	Huaxcaleca Nahuatl	\N
nhr	\N	\N	\N	I	L	Naro	\N
nht	\N	\N	\N	I	L	Ometepec Nahuatl	\N
nhu	\N	\N	\N	I	L	Noone	\N
nhv	\N	\N	\N	I	L	Temascaltepec Nahuatl	\N
nhw	\N	\N	\N	I	L	Western Huasteca Nahuatl	\N
nhx	\N	\N	\N	I	L	Isthmus-Mecayapan Nahuatl	\N
nhy	\N	\N	\N	I	L	Northern Oaxaca Nahuatl	\N
nhz	\N	\N	\N	I	L	Santa María La Alta Nahuatl	\N
nia	nia	nia	\N	I	L	Nias	\N
nib	\N	\N	\N	I	L	Nakame	\N
nid	\N	\N	\N	I	E	Ngandi	\N
nie	\N	\N	\N	I	L	Niellim	\N
nif	\N	\N	\N	I	L	Nek	\N
nig	\N	\N	\N	I	E	Ngalakgan	\N
nih	\N	\N	\N	I	L	Nyiha (Tanzania)	\N
nii	\N	\N	\N	I	L	Nii	\N
nij	\N	\N	\N	I	L	Ngaju	\N
nik	\N	\N	\N	I	L	Southern Nicobarese	\N
nil	\N	\N	\N	I	L	Nila	\N
nim	\N	\N	\N	I	L	Nilamba	\N
nin	\N	\N	\N	I	L	Ninzo	\N
nio	\N	\N	\N	I	L	Nganasan	\N
niq	\N	\N	\N	I	L	Nandi	\N
nir	\N	\N	\N	I	L	Nimboran	\N
nis	\N	\N	\N	I	L	Nimi	\N
nit	\N	\N	\N	I	L	Southeastern Kolami	\N
niu	niu	niu	\N	I	L	Niuean	\N
niv	\N	\N	\N	I	L	Gilyak	\N
niw	\N	\N	\N	I	L	Nimo	\N
nix	\N	\N	\N	I	L	Hema	\N
niy	\N	\N	\N	I	L	Ngiti	\N
niz	\N	\N	\N	I	L	Ningil	\N
nja	\N	\N	\N	I	L	Nzanyi	\N
njb	\N	\N	\N	I	L	Nocte Naga	\N
njd	\N	\N	\N	I	L	Ndonde Hamba	\N
njh	\N	\N	\N	I	L	Lotha Naga	\N
nji	\N	\N	\N	I	L	Gudanji	\N
njj	\N	\N	\N	I	L	Njen	\N
njl	\N	\N	\N	I	L	Njalgulgule	\N
njm	\N	\N	\N	I	L	Angami Naga	\N
njn	\N	\N	\N	I	L	Liangmai Naga	\N
njo	\N	\N	\N	I	L	Ao Naga	\N
njr	\N	\N	\N	I	L	Njerep	\N
njs	\N	\N	\N	I	L	Nisa	\N
njt	\N	\N	\N	I	L	Ndyuka-Trio Pidgin	\N
nju	\N	\N	\N	I	L	Ngadjunmaya	\N
njx	\N	\N	\N	I	L	Kunyi	\N
njy	\N	\N	\N	I	L	Njyem	\N
njz	\N	\N	\N	I	L	Nyishi	\N
nka	\N	\N	\N	I	L	Nkoya	\N
nkb	\N	\N	\N	I	L	Khoibu Naga	\N
nkc	\N	\N	\N	I	L	Nkongho	\N
nkd	\N	\N	\N	I	L	Koireng	\N
nke	\N	\N	\N	I	L	Duke	\N
nkf	\N	\N	\N	I	L	Inpui Naga	\N
nkg	\N	\N	\N	I	L	Nekgini	\N
nkh	\N	\N	\N	I	L	Khezha Naga	\N
nki	\N	\N	\N	I	L	Thangal Naga	\N
nkj	\N	\N	\N	I	L	Nakai	\N
nkk	\N	\N	\N	I	L	Nokuku	\N
nkm	\N	\N	\N	I	L	Namat	\N
nkn	\N	\N	\N	I	L	Nkangala	\N
nko	\N	\N	\N	I	L	Nkonya	\N
nkp	\N	\N	\N	I	E	Niuatoputapu	\N
nkq	\N	\N	\N	I	L	Nkami	\N
nkr	\N	\N	\N	I	L	Nukuoro	\N
nks	\N	\N	\N	I	L	North Asmat	\N
nkt	\N	\N	\N	I	L	Nyika (Tanzania)	\N
nku	\N	\N	\N	I	L	Bouna Kulango	\N
nkv	\N	\N	\N	I	L	Nyika (Malawi and Zambia)	\N
nkw	\N	\N	\N	I	L	Nkutu	\N
nkx	\N	\N	\N	I	L	Nkoroo	\N
nkz	\N	\N	\N	I	L	Nkari	\N
nla	\N	\N	\N	I	L	Ngombale	\N
nlc	\N	\N	\N	I	L	Nalca	\N
nld	dut	nld	nl	I	L	Dutch	\N
nle	\N	\N	\N	I	L	East Nyala	\N
nlg	\N	\N	\N	I	L	Gela	\N
nli	\N	\N	\N	I	L	Grangali	\N
nlj	\N	\N	\N	I	L	Nyali	\N
nlk	\N	\N	\N	I	L	Ninia Yali	\N
nll	\N	\N	\N	I	L	Nihali	\N
nlm	\N	\N	\N	I	L	Mankiyali	\N
nlo	\N	\N	\N	I	L	Ngul	\N
nlq	\N	\N	\N	I	L	Lao Naga	\N
nlu	\N	\N	\N	I	L	Nchumbulu	\N
nlv	\N	\N	\N	I	L	Orizaba Nahuatl	\N
nlw	\N	\N	\N	I	E	Walangama	\N
nlx	\N	\N	\N	I	L	Nahali	\N
nly	\N	\N	\N	I	L	Nyamal	\N
nlz	\N	\N	\N	I	L	Nalögo	\N
nma	\N	\N	\N	I	L	Maram Naga	\N
nmb	\N	\N	\N	I	L	Big Nambas	\N
nmc	\N	\N	\N	I	L	Ngam	\N
nmd	\N	\N	\N	I	L	Ndumu	\N
nme	\N	\N	\N	I	L	Mzieme Naga	\N
nmf	\N	\N	\N	I	L	Tangkhul Naga (India)	\N
nmg	\N	\N	\N	I	L	Kwasio	\N
nmh	\N	\N	\N	I	L	Monsang Naga	\N
nmi	\N	\N	\N	I	L	Nyam	\N
nmj	\N	\N	\N	I	L	Ngombe (Central African Republic)	\N
nmk	\N	\N	\N	I	L	Namakura	\N
nml	\N	\N	\N	I	L	Ndemli	\N
nmm	\N	\N	\N	I	L	Manangba	\N
nmn	\N	\N	\N	I	L	ǃXóõ	\N
nmo	\N	\N	\N	I	L	Moyon Naga	\N
nmp	\N	\N	\N	I	E	Nimanbur	\N
nmq	\N	\N	\N	I	L	Nambya	\N
nmr	\N	\N	\N	I	E	Nimbari	\N
nms	\N	\N	\N	I	L	Letemboi	\N
nmt	\N	\N	\N	I	L	Namonuito	\N
nmu	\N	\N	\N	I	L	Northeast Maidu	\N
nmv	\N	\N	\N	I	E	Ngamini	\N
nmw	\N	\N	\N	I	L	Nimoa	\N
nmx	\N	\N	\N	I	L	Nama (Papua New Guinea)	\N
nmy	\N	\N	\N	I	L	Namuyi	\N
nmz	\N	\N	\N	I	L	Nawdm	\N
nna	\N	\N	\N	I	L	Nyangumarta	\N
nnb	\N	\N	\N	I	L	Nande	\N
nnc	\N	\N	\N	I	L	Nancere	\N
nnd	\N	\N	\N	I	L	West Ambae	\N
nne	\N	\N	\N	I	L	Ngandyera	\N
nnf	\N	\N	\N	I	L	Ngaing	\N
nng	\N	\N	\N	I	L	Maring Naga	\N
nnh	\N	\N	\N	I	L	Ngiemboon	\N
nni	\N	\N	\N	I	L	North Nuaulu	\N
nnj	\N	\N	\N	I	L	Nyangatom	\N
nnk	\N	\N	\N	I	L	Nankina	\N
nnl	\N	\N	\N	I	L	Northern Rengma Naga	\N
nnm	\N	\N	\N	I	L	Namia	\N
nnn	\N	\N	\N	I	L	Ngete	\N
nno	nno	nno	nn	I	L	Norwegian Nynorsk	\N
nnp	\N	\N	\N	I	L	Wancho Naga	\N
nnq	\N	\N	\N	I	L	Ngindo	\N
nnr	\N	\N	\N	I	E	Narungga	\N
nnt	\N	\N	\N	I	E	Nanticoke	\N
nnu	\N	\N	\N	I	L	Dwang	\N
nnv	\N	\N	\N	I	E	Nugunu (Australia)	\N
nnw	\N	\N	\N	I	L	Southern Nuni	\N
nny	\N	\N	\N	I	E	Nyangga	\N
nnz	\N	\N	\N	I	L	Nda'nda'	\N
noa	\N	\N	\N	I	L	Woun Meu	\N
nob	nob	nob	nb	I	L	Norwegian Bokmål	\N
noc	\N	\N	\N	I	L	Nuk	\N
nod	\N	\N	\N	I	L	Northern Thai	\N
noe	\N	\N	\N	I	L	Nimadi	\N
nof	\N	\N	\N	I	L	Nomane	\N
nog	nog	nog	\N	I	L	Nogai	\N
noh	\N	\N	\N	I	L	Nomu	\N
noi	\N	\N	\N	I	L	Noiri	\N
noj	\N	\N	\N	I	L	Nonuya	\N
nok	\N	\N	\N	I	E	Nooksack	\N
nol	\N	\N	\N	I	E	Nomlaki	\N
non	non	non	\N	I	H	Old Norse	\N
nop	\N	\N	\N	I	L	Numanggang	\N
noq	\N	\N	\N	I	L	Ngongo	\N
nor	nor	nor	no	M	L	Norwegian	\N
nos	\N	\N	\N	I	L	Eastern Nisu	\N
not	\N	\N	\N	I	L	Nomatsiguenga	\N
nou	\N	\N	\N	I	L	Ewage-Notu	\N
nov	\N	\N	\N	I	C	Novial	\N
now	\N	\N	\N	I	L	Nyambo	\N
noy	\N	\N	\N	I	L	Noy	\N
noz	\N	\N	\N	I	L	Nayi	\N
npa	\N	\N	\N	I	L	Nar Phu	\N
npb	\N	\N	\N	I	L	Nupbikha	\N
npg	\N	\N	\N	I	L	Ponyo-Gongwang Naga	\N
nph	\N	\N	\N	I	L	Phom Naga	\N
npi	\N	\N	\N	I	L	Nepali (individual language)	\N
npl	\N	\N	\N	I	L	Southeastern Puebla Nahuatl	\N
npn	\N	\N	\N	I	L	Mondropolon	\N
npo	\N	\N	\N	I	L	Pochuri Naga	\N
nps	\N	\N	\N	I	L	Nipsan	\N
npu	\N	\N	\N	I	L	Puimei Naga	\N
npx	\N	\N	\N	I	L	Noipx	\N
npy	\N	\N	\N	I	L	Napu	\N
nqg	\N	\N	\N	I	L	Southern Nago	\N
nqk	\N	\N	\N	I	L	Kura Ede Nago	\N
nql	\N	\N	\N	I	L	Ngendelengo	\N
nqm	\N	\N	\N	I	L	Ndom	\N
nqn	\N	\N	\N	I	L	Nen	\N
nqo	nqo	nqo	\N	I	L	N'Ko	\N
nqq	\N	\N	\N	I	L	Kyan-Karyaw Naga	\N
nqt	\N	\N	\N	I	L	Nteng	\N
nqy	\N	\N	\N	I	L	Akyaung Ari Naga	\N
nra	\N	\N	\N	I	L	Ngom	\N
nrb	\N	\N	\N	I	L	Nara	\N
nrc	\N	\N	\N	I	H	Noric	\N
nre	\N	\N	\N	I	L	Southern Rengma Naga	\N
nrf	\N	\N	\N	I	L	Jèrriais	\N
nrg	\N	\N	\N	I	L	Narango	\N
nri	\N	\N	\N	I	L	Chokri Naga	\N
nrk	\N	\N	\N	I	L	Ngarla	\N
nrl	\N	\N	\N	I	L	Ngarluma	\N
nrm	\N	\N	\N	I	L	Narom	\N
nrn	\N	\N	\N	I	E	Norn	\N
nrp	\N	\N	\N	I	H	North Picene	\N
nrr	\N	\N	\N	I	E	Norra	\N
nrt	\N	\N	\N	I	E	Northern Kalapuya	\N
nru	\N	\N	\N	I	L	Narua	\N
nrx	\N	\N	\N	I	E	Ngurmbur	\N
nrz	\N	\N	\N	I	L	Lala	\N
nsa	\N	\N	\N	I	L	Sangtam Naga	\N
nsb	\N	\N	\N	I	E	Lower Nossob	\N
nsc	\N	\N	\N	I	L	Nshi	\N
nsd	\N	\N	\N	I	L	Southern Nisu	\N
nse	\N	\N	\N	I	L	Nsenga	\N
nsf	\N	\N	\N	I	L	Northwestern Nisu	\N
nsg	\N	\N	\N	I	L	Ngasa	\N
nsh	\N	\N	\N	I	L	Ngoshie	\N
nsi	\N	\N	\N	I	L	Nigerian Sign Language	\N
nsk	\N	\N	\N	I	L	Naskapi	\N
nsl	\N	\N	\N	I	L	Norwegian Sign Language	\N
nsm	\N	\N	\N	I	L	Sumi Naga	\N
nsn	\N	\N	\N	I	L	Nehan	\N
nso	nso	nso	\N	I	L	Pedi	\N
nsp	\N	\N	\N	I	L	Nepalese Sign Language	\N
nsq	\N	\N	\N	I	L	Northern Sierra Miwok	\N
nsr	\N	\N	\N	I	L	Maritime Sign Language	\N
nss	\N	\N	\N	I	L	Nali	\N
nst	\N	\N	\N	I	L	Tase Naga	\N
nsu	\N	\N	\N	I	L	Sierra Negra Nahuatl	\N
nsv	\N	\N	\N	I	L	Southwestern Nisu	\N
nsw	\N	\N	\N	I	L	Navut	\N
nsx	\N	\N	\N	I	L	Nsongo	\N
nsy	\N	\N	\N	I	L	Nasal	\N
nsz	\N	\N	\N	I	L	Nisenan	\N
ntd	\N	\N	\N	I	L	Northern Tidung	\N
nte	\N	\N	\N	I	L	Nathembo	\N
ntg	\N	\N	\N	I	E	Ngantangarra	\N
nti	\N	\N	\N	I	L	Natioro	\N
ntj	\N	\N	\N	I	L	Ngaanyatjarra	\N
ntk	\N	\N	\N	I	L	Ikoma-Nata-Isenye	\N
ntm	\N	\N	\N	I	L	Nateni	\N
nto	\N	\N	\N	I	L	Ntomba	\N
ntp	\N	\N	\N	I	L	Northern Tepehuan	\N
ntr	\N	\N	\N	I	L	Delo	\N
ntu	\N	\N	\N	I	L	Natügu	\N
ntw	\N	\N	\N	I	E	Nottoway	\N
ntx	\N	\N	\N	I	L	Tangkhul Naga (Myanmar)	\N
nty	\N	\N	\N	I	L	Mantsi	\N
ntz	\N	\N	\N	I	L	Natanzi	\N
nua	\N	\N	\N	I	L	Yuanga	\N
nuc	\N	\N	\N	I	E	Nukuini	\N
nud	\N	\N	\N	I	L	Ngala	\N
nue	\N	\N	\N	I	L	Ngundu	\N
nuf	\N	\N	\N	I	L	Nusu	\N
nug	\N	\N	\N	I	E	Nungali	\N
nuh	\N	\N	\N	I	L	Ndunda	\N
nui	\N	\N	\N	I	L	Ngumbi	\N
nuj	\N	\N	\N	I	L	Nyole	\N
nuk	\N	\N	\N	I	L	Nuu-chah-nulth	\N
nul	\N	\N	\N	I	E	Nusa Laut	\N
num	\N	\N	\N	I	L	Niuafo'ou	\N
nun	\N	\N	\N	I	L	Anong	\N
nuo	\N	\N	\N	I	L	Nguôn	\N
nup	\N	\N	\N	I	L	Nupe-Nupe-Tako	\N
nuq	\N	\N	\N	I	L	Nukumanu	\N
nur	\N	\N	\N	I	L	Nukuria	\N
nus	\N	\N	\N	I	L	Nuer	\N
nut	\N	\N	\N	I	L	Nung (Viet Nam)	\N
nuu	\N	\N	\N	I	L	Ngbundu	\N
nuv	\N	\N	\N	I	L	Northern Nuni	\N
nuw	\N	\N	\N	I	L	Nguluwan	\N
nux	\N	\N	\N	I	L	Mehek	\N
nuy	\N	\N	\N	I	L	Nunggubuyu	\N
nuz	\N	\N	\N	I	L	Tlamacazapa Nahuatl	\N
nvh	\N	\N	\N	I	L	Nasarian	\N
nvm	\N	\N	\N	I	L	Namiae	\N
nvo	\N	\N	\N	I	L	Nyokon	\N
nwa	\N	\N	\N	I	E	Nawathinehena	\N
nwb	\N	\N	\N	I	L	Nyabwa	\N
nwc	nwc	nwc	\N	I	H	Classical Newari	\N
nwe	\N	\N	\N	I	L	Ngwe	\N
nwg	\N	\N	\N	I	E	Ngayawung	\N
nwi	\N	\N	\N	I	L	Southwest Tanna	\N
nwm	\N	\N	\N	I	L	Nyamusa-Molo	\N
nwo	\N	\N	\N	I	E	Nauo	\N
nwr	\N	\N	\N	I	L	Nawaru	\N
nww	\N	\N	\N	I	L	Ndwewe	\N
nwx	\N	\N	\N	I	H	Middle Newar	\N
nwy	\N	\N	\N	I	E	Nottoway-Meherrin	\N
nxa	\N	\N	\N	I	L	Nauete	\N
nxd	\N	\N	\N	I	L	Ngando (Democratic Republic of Congo)	\N
nxe	\N	\N	\N	I	L	Nage	\N
nxg	\N	\N	\N	I	L	Ngad'a	\N
nxi	\N	\N	\N	I	L	Nindi	\N
nxk	\N	\N	\N	I	L	Koki Naga	\N
nxl	\N	\N	\N	I	L	South Nuaulu	\N
nxm	\N	\N	\N	I	H	Numidian	\N
nxn	\N	\N	\N	I	E	Ngawun	\N
nxo	\N	\N	\N	I	L	Ndambomo	\N
nxq	\N	\N	\N	I	L	Naxi	\N
nxr	\N	\N	\N	I	L	Ninggerum	\N
nxx	\N	\N	\N	I	L	Nafri	\N
nya	nya	nya	ny	I	L	Nyanja	\N
nyb	\N	\N	\N	I	L	Nyangbo	\N
nyc	\N	\N	\N	I	L	Nyanga-li	\N
nyd	\N	\N	\N	I	L	Nyore	\N
nye	\N	\N	\N	I	L	Nyengo	\N
nyf	\N	\N	\N	I	L	Giryama	\N
nyg	\N	\N	\N	I	L	Nyindu	\N
nyh	\N	\N	\N	I	L	Nyikina	\N
nyi	\N	\N	\N	I	L	Ama (Sudan)	\N
nyj	\N	\N	\N	I	L	Nyanga	\N
nyk	\N	\N	\N	I	L	Nyaneka	\N
nyl	\N	\N	\N	I	L	Nyeu	\N
nym	nym	nym	\N	I	L	Nyamwezi	\N
nyn	nyn	nyn	\N	I	L	Nyankole	\N
nyo	nyo	nyo	\N	I	L	Nyoro	\N
nyp	\N	\N	\N	I	E	Nyang'i	\N
nyq	\N	\N	\N	I	L	Nayini	\N
nyr	\N	\N	\N	I	L	Nyiha (Malawi)	\N
nys	\N	\N	\N	I	L	Nyungar	\N
nyt	\N	\N	\N	I	E	Nyawaygi	\N
nyu	\N	\N	\N	I	L	Nyungwe	\N
nyv	\N	\N	\N	I	E	Nyulnyul	\N
nyw	\N	\N	\N	I	L	Nyaw	\N
nyx	\N	\N	\N	I	E	Nganyaywana	\N
nyy	\N	\N	\N	I	L	Nyakyusa-Ngonde	\N
nza	\N	\N	\N	I	L	Tigon Mbembe	\N
nzb	\N	\N	\N	I	L	Njebi	\N
nzd	\N	\N	\N	I	L	Nzadi	\N
nzi	nzi	nzi	\N	I	L	Nzima	\N
nzk	\N	\N	\N	I	L	Nzakara	\N
nzm	\N	\N	\N	I	L	Zeme Naga	\N
nzr	\N	\N	\N	I	L	Dir-Nyamzak-Mbarimi	\N
nzs	\N	\N	\N	I	L	New Zealand Sign Language	\N
nzu	\N	\N	\N	I	L	Teke-Nzikou	\N
nzy	\N	\N	\N	I	L	Nzakambay	\N
nzz	\N	\N	\N	I	L	Nanga Dama Dogon	\N
oaa	\N	\N	\N	I	L	Orok	\N
oac	\N	\N	\N	I	L	Oroch	\N
oar	\N	\N	\N	I	H	Old Aramaic (up to 700 BCE)	\N
oav	\N	\N	\N	I	H	Old Avar	\N
obi	\N	\N	\N	I	E	Obispeño	\N
obk	\N	\N	\N	I	L	Southern Bontok	\N
obl	\N	\N	\N	I	L	Oblo	\N
obm	\N	\N	\N	I	H	Moabite	\N
obo	\N	\N	\N	I	L	Obo Manobo	\N
obr	\N	\N	\N	I	H	Old Burmese	\N
obt	\N	\N	\N	I	H	Old Breton	\N
obu	\N	\N	\N	I	L	Obulom	\N
oca	\N	\N	\N	I	L	Ocaina	\N
och	\N	\N	\N	I	H	Old Chinese	\N
oci	oci	oci	oc	I	L	Occitan (post 1500)	\N
ocm	\N	\N	\N	I	H	Old Cham	\N
oco	\N	\N	\N	I	H	Old Cornish	\N
ocu	\N	\N	\N	I	L	Atzingo Matlatzinca	\N
oda	\N	\N	\N	I	L	Odut	\N
odk	\N	\N	\N	I	L	Od	\N
odt	\N	\N	\N	I	H	Old Dutch	\N
odu	\N	\N	\N	I	L	Odual	\N
ofo	\N	\N	\N	I	E	Ofo	\N
ofs	\N	\N	\N	I	H	Old Frisian	\N
ofu	\N	\N	\N	I	L	Efutop	\N
ogb	\N	\N	\N	I	L	Ogbia	\N
ogc	\N	\N	\N	I	L	Ogbah	\N
oge	\N	\N	\N	I	H	Old Georgian	\N
ogg	\N	\N	\N	I	L	Ogbogolo	\N
ogo	\N	\N	\N	I	L	Khana	\N
ogu	\N	\N	\N	I	L	Ogbronuagum	\N
oht	\N	\N	\N	I	H	Old Hittite	\N
ohu	\N	\N	\N	I	H	Old Hungarian	\N
oia	\N	\N	\N	I	L	Oirata	\N
oie	\N	\N	\N	I	L	Okolie	\N
oin	\N	\N	\N	I	L	Inebu One	\N
ojb	\N	\N	\N	I	L	Northwestern Ojibwa	\N
ojc	\N	\N	\N	I	L	Central Ojibwa	\N
ojg	\N	\N	\N	I	L	Eastern Ojibwa	\N
oji	oji	oji	oj	M	L	Ojibwa	\N
ojp	\N	\N	\N	I	H	Old Japanese	\N
ojs	\N	\N	\N	I	L	Severn Ojibwa	\N
ojv	\N	\N	\N	I	L	Ontong Java	\N
ojw	\N	\N	\N	I	L	Western Ojibwa	\N
oka	\N	\N	\N	I	L	Okanagan	\N
okb	\N	\N	\N	I	L	Okobo	\N
okc	\N	\N	\N	I	L	Kobo	\N
okd	\N	\N	\N	I	L	Okodia	\N
oke	\N	\N	\N	I	L	Okpe (Southwestern Edo)	\N
okg	\N	\N	\N	I	E	Koko Babangk	\N
okh	\N	\N	\N	I	L	Koresh-e Rostam	\N
oki	\N	\N	\N	I	L	Okiek	\N
okj	\N	\N	\N	I	E	Oko-Juwoi	\N
okk	\N	\N	\N	I	L	Kwamtim One	\N
okl	\N	\N	\N	I	E	Old Kentish Sign Language	\N
okm	\N	\N	\N	I	H	Middle Korean (10th-16th cent.)	\N
okn	\N	\N	\N	I	L	Oki-No-Erabu	\N
oko	\N	\N	\N	I	H	Old Korean (3rd-9th cent.)	\N
okr	\N	\N	\N	I	L	Kirike	\N
oks	\N	\N	\N	I	L	Oko-Eni-Osayen	\N
oku	\N	\N	\N	I	L	Oku	\N
okv	\N	\N	\N	I	L	Orokaiva	\N
okx	\N	\N	\N	I	L	Okpe (Northwestern Edo)	\N
okz	\N	\N	\N	I	H	Old Khmer	\N
ola	\N	\N	\N	I	L	Walungge	\N
old	\N	\N	\N	I	L	Mochi	\N
ole	\N	\N	\N	I	L	Olekha	\N
olk	\N	\N	\N	I	E	Olkol	\N
olm	\N	\N	\N	I	L	Oloma	\N
olo	\N	\N	\N	I	L	Livvi	\N
olr	\N	\N	\N	I	L	Olrat	\N
olt	\N	\N	\N	I	H	Old Lithuanian	\N
olu	\N	\N	\N	I	L	Kuvale	\N
oma	\N	\N	\N	I	L	Omaha-Ponca	\N
omb	\N	\N	\N	I	L	East Ambae	\N
omc	\N	\N	\N	I	E	Mochica	\N
omg	\N	\N	\N	I	L	Omagua	\N
omi	\N	\N	\N	I	L	Omi	\N
omk	\N	\N	\N	I	E	Omok	\N
oml	\N	\N	\N	I	L	Ombo	\N
omn	\N	\N	\N	I	H	Minoan	\N
omo	\N	\N	\N	I	L	Utarmbung	\N
omp	\N	\N	\N	I	H	Old Manipuri	\N
omr	\N	\N	\N	I	H	Old Marathi	\N
omt	\N	\N	\N	I	L	Omotik	\N
omu	\N	\N	\N	I	E	Omurano	\N
omw	\N	\N	\N	I	L	South Tairora	\N
omx	\N	\N	\N	I	H	Old Mon	\N
omy	\N	\N	\N	I	H	Old Malay	\N
ona	\N	\N	\N	I	L	Ona	\N
onb	\N	\N	\N	I	L	Lingao	\N
one	\N	\N	\N	I	L	Oneida	\N
ong	\N	\N	\N	I	L	Olo	\N
oni	\N	\N	\N	I	L	Onin	\N
onj	\N	\N	\N	I	L	Onjob	\N
onk	\N	\N	\N	I	L	Kabore One	\N
onn	\N	\N	\N	I	L	Onobasulu	\N
ono	\N	\N	\N	I	L	Onondaga	\N
onp	\N	\N	\N	I	L	Sartang	\N
onr	\N	\N	\N	I	L	Northern One	\N
ons	\N	\N	\N	I	L	Ono	\N
ont	\N	\N	\N	I	L	Ontenu	\N
onu	\N	\N	\N	I	L	Unua	\N
onw	\N	\N	\N	I	H	Old Nubian	\N
onx	\N	\N	\N	I	L	Onin Based Pidgin	\N
ood	\N	\N	\N	I	L	Tohono O'odham	\N
oog	\N	\N	\N	I	L	Ong	\N
oon	\N	\N	\N	I	L	Önge	\N
oor	\N	\N	\N	I	L	Oorlams	\N
oos	\N	\N	\N	I	H	Old Ossetic	\N
opa	\N	\N	\N	I	L	Okpamheri	\N
opk	\N	\N	\N	I	L	Kopkaka	\N
opm	\N	\N	\N	I	L	Oksapmin	\N
opo	\N	\N	\N	I	L	Opao	\N
opt	\N	\N	\N	I	E	Opata	\N
opy	\N	\N	\N	I	L	Ofayé	\N
ora	\N	\N	\N	I	L	Oroha	\N
orc	\N	\N	\N	I	L	Orma	\N
ore	\N	\N	\N	I	L	Orejón	\N
org	\N	\N	\N	I	L	Oring	\N
orh	\N	\N	\N	I	L	Oroqen	\N
ori	ori	ori	or	M	L	Oriya (macrolanguage)	\N
orm	orm	orm	om	M	L	Oromo	\N
orn	\N	\N	\N	I	L	Orang Kanaq	\N
oro	\N	\N	\N	I	L	Orokolo	\N
orr	\N	\N	\N	I	L	Oruma	\N
ors	\N	\N	\N	I	L	Orang Seletar	\N
ort	\N	\N	\N	I	L	Adivasi Oriya	\N
oru	\N	\N	\N	I	L	Ormuri	\N
orv	\N	\N	\N	I	H	Old Russian	\N
orw	\N	\N	\N	I	L	Oro Win	\N
orx	\N	\N	\N	I	L	Oro	\N
ory	\N	\N	\N	I	L	Odia	\N
orz	\N	\N	\N	I	L	Ormu	\N
osa	osa	osa	\N	I	L	Osage	\N
osc	\N	\N	\N	I	H	Oscan	\N
osi	\N	\N	\N	I	L	Osing	\N
osn	\N	\N	\N	I	H	Old Sundanese	\N
oso	\N	\N	\N	I	L	Ososo	\N
osp	\N	\N	\N	I	H	Old Spanish	\N
oss	oss	oss	os	I	L	Ossetian	\N
ost	\N	\N	\N	I	L	Osatu	\N
osu	\N	\N	\N	I	L	Southern One	\N
osx	\N	\N	\N	I	H	Old Saxon	\N
ota	ota	ota	\N	I	H	Ottoman Turkish (1500-1928)	\N
otb	\N	\N	\N	I	H	Old Tibetan	\N
otd	\N	\N	\N	I	L	Ot Danum	\N
ote	\N	\N	\N	I	L	Mezquital Otomi	\N
oti	\N	\N	\N	I	E	Oti	\N
otk	\N	\N	\N	I	H	Old Turkish	\N
otl	\N	\N	\N	I	L	Tilapa Otomi	\N
otm	\N	\N	\N	I	L	Eastern Highland Otomi	\N
otn	\N	\N	\N	I	L	Tenango Otomi	\N
otq	\N	\N	\N	I	L	Querétaro Otomi	\N
otr	\N	\N	\N	I	L	Otoro	\N
ots	\N	\N	\N	I	L	Estado de México Otomi	\N
ott	\N	\N	\N	I	L	Temoaya Otomi	\N
otu	\N	\N	\N	I	E	Otuke	\N
otw	\N	\N	\N	I	L	Ottawa	\N
otx	\N	\N	\N	I	L	Texcatepec Otomi	\N
oty	\N	\N	\N	I	H	Old Tamil	\N
otz	\N	\N	\N	I	L	Ixtenco Otomi	\N
oua	\N	\N	\N	I	L	Tagargrent	\N
oub	\N	\N	\N	I	L	Glio-Oubi	\N
oue	\N	\N	\N	I	L	Oune	\N
oui	\N	\N	\N	I	H	Old Uighur	\N
oum	\N	\N	\N	I	E	Ouma	\N
ovd	\N	\N	\N	I	L	Elfdalian	\N
owi	\N	\N	\N	I	L	Owiniga	\N
owl	\N	\N	\N	I	H	Old Welsh	\N
oyb	\N	\N	\N	I	L	Oy	\N
oyd	\N	\N	\N	I	L	Oyda	\N
oym	\N	\N	\N	I	L	Wayampi	\N
oyy	\N	\N	\N	I	L	Oya'oya	\N
ozm	\N	\N	\N	I	L	Koonzime	\N
pab	\N	\N	\N	I	L	Parecís	\N
pac	\N	\N	\N	I	L	Pacoh	\N
pad	\N	\N	\N	I	L	Paumarí	\N
pae	\N	\N	\N	I	L	Pagibete	\N
paf	\N	\N	\N	I	E	Paranawát	\N
pag	pag	pag	\N	I	L	Pangasinan	\N
pah	\N	\N	\N	I	L	Tenharim	\N
pai	\N	\N	\N	I	L	Pe	\N
pak	\N	\N	\N	I	L	Parakanã	\N
pal	pal	pal	\N	I	H	Pahlavi	\N
pam	pam	pam	\N	I	L	Pampanga	\N
pan	pan	pan	pa	I	L	Panjabi	\N
pao	\N	\N	\N	I	L	Northern Paiute	\N
pap	pap	pap	\N	I	L	Papiamento	\N
paq	\N	\N	\N	I	L	Parya	\N
par	\N	\N	\N	I	L	Panamint	\N
pas	\N	\N	\N	I	L	Papasena	\N
pau	pau	pau	\N	I	L	Palauan	\N
pav	\N	\N	\N	I	L	Pakaásnovos	\N
paw	\N	\N	\N	I	L	Pawnee	\N
pax	\N	\N	\N	I	E	Pankararé	\N
pay	\N	\N	\N	I	L	Pech	\N
paz	\N	\N	\N	I	E	Pankararú	\N
pbb	\N	\N	\N	I	L	Páez	\N
pbc	\N	\N	\N	I	L	Patamona	\N
pbe	\N	\N	\N	I	L	Mezontla Popoloca	\N
pbf	\N	\N	\N	I	L	Coyotepec Popoloca	\N
pbg	\N	\N	\N	I	E	Paraujano	\N
pbh	\N	\N	\N	I	L	E'ñapa Woromaipu	\N
pbi	\N	\N	\N	I	L	Parkwa	\N
pbl	\N	\N	\N	I	L	Mak (Nigeria)	\N
pbm	\N	\N	\N	I	L	Puebla Mazatec	\N
pbn	\N	\N	\N	I	L	Kpasam	\N
pbo	\N	\N	\N	I	L	Papel	\N
pbp	\N	\N	\N	I	L	Badyara	\N
pbr	\N	\N	\N	I	L	Pangwa	\N
pbs	\N	\N	\N	I	L	Central Pame	\N
pbt	\N	\N	\N	I	L	Southern Pashto	\N
pbu	\N	\N	\N	I	L	Northern Pashto	\N
pbv	\N	\N	\N	I	L	Pnar	\N
pby	\N	\N	\N	I	L	Pyu (Papua New Guinea)	\N
pca	\N	\N	\N	I	L	Santa Inés Ahuatempan Popoloca	\N
pcb	\N	\N	\N	I	L	Pear	\N
pcc	\N	\N	\N	I	L	Bouyei	\N
pcd	\N	\N	\N	I	L	Picard	\N
pce	\N	\N	\N	I	L	Ruching Palaung	\N
pcf	\N	\N	\N	I	L	Paliyan	\N
pcg	\N	\N	\N	I	L	Paniya	\N
pch	\N	\N	\N	I	L	Pardhan	\N
pci	\N	\N	\N	I	L	Duruwa	\N
pcj	\N	\N	\N	I	L	Parenga	\N
pck	\N	\N	\N	I	L	Paite Chin	\N
pcl	\N	\N	\N	I	L	Pardhi	\N
pcm	\N	\N	\N	I	L	Nigerian Pidgin	\N
pcn	\N	\N	\N	I	L	Piti	\N
pcp	\N	\N	\N	I	L	Pacahuara	\N
pcw	\N	\N	\N	I	L	Pyapun	\N
pda	\N	\N	\N	I	L	Anam	\N
pdc	\N	\N	\N	I	L	Pennsylvania German	\N
pdi	\N	\N	\N	I	L	Pa Di	\N
pdn	\N	\N	\N	I	L	Podena	\N
pdo	\N	\N	\N	I	L	Padoe	\N
pdt	\N	\N	\N	I	L	Plautdietsch	\N
pdu	\N	\N	\N	I	L	Kayan	\N
pea	\N	\N	\N	I	L	Peranakan Indonesian	\N
peb	\N	\N	\N	I	E	Eastern Pomo	\N
ped	\N	\N	\N	I	L	Mala (Papua New Guinea)	\N
pee	\N	\N	\N	I	L	Taje	\N
pef	\N	\N	\N	I	E	Northeastern Pomo	\N
peg	\N	\N	\N	I	L	Pengo	\N
peh	\N	\N	\N	I	L	Bonan	\N
pei	\N	\N	\N	I	L	Chichimeca-Jonaz	\N
pej	\N	\N	\N	I	E	Northern Pomo	\N
pek	\N	\N	\N	I	L	Penchal	\N
pel	\N	\N	\N	I	L	Pekal	\N
pem	\N	\N	\N	I	L	Phende	\N
peo	peo	peo	\N	I	H	Old Persian (ca. 600-400 B.C.)	\N
pep	\N	\N	\N	I	L	Kunja	\N
peq	\N	\N	\N	I	L	Southern Pomo	\N
pes	\N	\N	\N	I	L	Iranian Persian	\N
pev	\N	\N	\N	I	L	Pémono	\N
pex	\N	\N	\N	I	L	Petats	\N
pey	\N	\N	\N	I	L	Petjo	\N
pez	\N	\N	\N	I	L	Eastern Penan	\N
pfa	\N	\N	\N	I	L	Pááfang	\N
pfe	\N	\N	\N	I	L	Pere	\N
pfl	\N	\N	\N	I	L	Pfaelzisch	\N
pga	\N	\N	\N	I	L	Sudanese Creole Arabic	\N
pgd	\N	\N	\N	I	H	Gāndhārī	\N
pgg	\N	\N	\N	I	L	Pangwali	\N
pgi	\N	\N	\N	I	L	Pagi	\N
pgk	\N	\N	\N	I	L	Rerep	\N
pgl	\N	\N	\N	I	H	Primitive Irish	\N
pgn	\N	\N	\N	I	H	Paelignian	\N
pgs	\N	\N	\N	I	L	Pangseng	\N
pgu	\N	\N	\N	I	L	Pagu	\N
pgz	\N	\N	\N	I	L	Papua New Guinean Sign Language	\N
pha	\N	\N	\N	I	L	Pa-Hng	\N
phd	\N	\N	\N	I	L	Phudagi	\N
phg	\N	\N	\N	I	L	Phuong	\N
phh	\N	\N	\N	I	L	Phukha	\N
phj	\N	\N	\N	I	L	Pahari	\N
phk	\N	\N	\N	I	L	Phake	\N
phl	\N	\N	\N	I	L	Phalura	\N
phm	\N	\N	\N	I	L	Phimbi	\N
phn	phn	phn	\N	I	H	Phoenician	\N
pho	\N	\N	\N	I	L	Phunoi	\N
phq	\N	\N	\N	I	L	Phana'	\N
phr	\N	\N	\N	I	L	Pahari-Potwari	\N
pht	\N	\N	\N	I	L	Phu Thai	\N
phu	\N	\N	\N	I	L	Phuan	\N
phv	\N	\N	\N	I	L	Pahlavani	\N
phw	\N	\N	\N	I	L	Phangduwali	\N
pia	\N	\N	\N	I	L	Pima Bajo	\N
pib	\N	\N	\N	I	L	Yine	\N
pic	\N	\N	\N	I	L	Pinji	\N
pid	\N	\N	\N	I	L	Piaroa	\N
pie	\N	\N	\N	I	E	Piro	\N
pif	\N	\N	\N	I	L	Pingelapese	\N
pig	\N	\N	\N	I	L	Pisabo	\N
pih	\N	\N	\N	I	L	Pitcairn-Norfolk	\N
pij	\N	\N	\N	I	E	Pijao	\N
pil	\N	\N	\N	I	L	Yom	\N
pim	\N	\N	\N	I	E	Powhatan	\N
pin	\N	\N	\N	I	L	Piame	\N
pio	\N	\N	\N	I	L	Piapoco	\N
pip	\N	\N	\N	I	L	Pero	\N
pir	\N	\N	\N	I	L	Piratapuyo	\N
pis	\N	\N	\N	I	L	Pijin	\N
pit	\N	\N	\N	I	E	Pitta Pitta	\N
piu	\N	\N	\N	I	L	Pintupi-Luritja	\N
piv	\N	\N	\N	I	L	Pileni	\N
piw	\N	\N	\N	I	L	Pimbwe	\N
pix	\N	\N	\N	I	L	Piu	\N
piy	\N	\N	\N	I	L	Piya-Kwonci	\N
piz	\N	\N	\N	I	L	Pije	\N
pjt	\N	\N	\N	I	L	Pitjantjatjara	\N
pka	\N	\N	\N	I	H	Ardhamāgadhī Prākrit	\N
pkb	\N	\N	\N	I	L	Pokomo	\N
pkc	\N	\N	\N	I	H	Paekche	\N
pkg	\N	\N	\N	I	L	Pak-Tong	\N
pkh	\N	\N	\N	I	L	Pankhu	\N
pkn	\N	\N	\N	I	L	Pakanha	\N
pko	\N	\N	\N	I	L	Pökoot	\N
pkp	\N	\N	\N	I	L	Pukapuka	\N
pkr	\N	\N	\N	I	L	Attapady Kurumba	\N
pks	\N	\N	\N	I	L	Pakistan Sign Language	\N
pkt	\N	\N	\N	I	L	Maleng	\N
pku	\N	\N	\N	I	L	Paku	\N
pla	\N	\N	\N	I	L	Miani	\N
plb	\N	\N	\N	I	L	Polonombauk	\N
plc	\N	\N	\N	I	L	Central Palawano	\N
pld	\N	\N	\N	I	L	Polari	\N
ple	\N	\N	\N	I	L	Palu'e	\N
plg	\N	\N	\N	I	L	Pilagá	\N
plh	\N	\N	\N	I	L	Paulohi	\N
pli	pli	pli	pi	I	H	Pali	\N
plk	\N	\N	\N	I	L	Kohistani Shina	\N
pll	\N	\N	\N	I	L	Shwe Palaung	\N
pln	\N	\N	\N	I	L	Palenquero	\N
plo	\N	\N	\N	I	L	Oluta Popoluca	\N
plq	\N	\N	\N	I	H	Palaic	\N
plr	\N	\N	\N	I	L	Palaka Senoufo	\N
pls	\N	\N	\N	I	L	San Marcos Tlacoyalco Popoloca	\N
plt	\N	\N	\N	I	L	Plateau Malagasy	\N
plu	\N	\N	\N	I	L	Palikúr	\N
plv	\N	\N	\N	I	L	Southwest Palawano	\N
plw	\N	\N	\N	I	L	Brooke's Point Palawano	\N
ply	\N	\N	\N	I	L	Bolyu	\N
plz	\N	\N	\N	I	L	Paluan	\N
pma	\N	\N	\N	I	L	Paama	\N
pmb	\N	\N	\N	I	L	Pambia	\N
pmd	\N	\N	\N	I	E	Pallanganmiddang	\N
pme	\N	\N	\N	I	L	Pwaamei	\N
pmf	\N	\N	\N	I	L	Pamona	\N
pmh	\N	\N	\N	I	H	Māhārāṣṭri Prākrit	\N
pmi	\N	\N	\N	I	L	Northern Pumi	\N
pmj	\N	\N	\N	I	L	Southern Pumi	\N
pml	\N	\N	\N	I	E	Lingua Franca	\N
pmm	\N	\N	\N	I	L	Pomo	\N
pmn	\N	\N	\N	I	L	Pam	\N
pmo	\N	\N	\N	I	L	Pom	\N
pmq	\N	\N	\N	I	L	Northern Pame	\N
pmr	\N	\N	\N	I	L	Paynamar	\N
pms	\N	\N	\N	I	L	Piemontese	\N
pmt	\N	\N	\N	I	L	Tuamotuan	\N
pmw	\N	\N	\N	I	L	Plains Miwok	\N
pmx	\N	\N	\N	I	L	Poumei Naga	\N
pmy	\N	\N	\N	I	L	Papuan Malay	\N
pmz	\N	\N	\N	I	E	Southern Pame	\N
pna	\N	\N	\N	I	L	Punan Bah-Biau	\N
pnb	\N	\N	\N	I	L	Western Panjabi	\N
pnc	\N	\N	\N	I	L	Pannei	\N
pnd	\N	\N	\N	I	L	Mpinda	\N
pne	\N	\N	\N	I	L	Western Penan	\N
png	\N	\N	\N	I	L	Pangu	\N
pnh	\N	\N	\N	I	L	Penrhyn	\N
pni	\N	\N	\N	I	L	Aoheng	\N
pnj	\N	\N	\N	I	E	Pinjarup	\N
pnk	\N	\N	\N	I	L	Paunaka	\N
pnl	\N	\N	\N	I	L	Paleni	\N
pnm	\N	\N	\N	I	L	Punan Batu 1	\N
pnn	\N	\N	\N	I	L	Pinai-Hagahai	\N
pno	\N	\N	\N	I	E	Panobo	\N
pnp	\N	\N	\N	I	L	Pancana	\N
pnq	\N	\N	\N	I	L	Pana (Burkina Faso)	\N
pnr	\N	\N	\N	I	L	Panim	\N
pns	\N	\N	\N	I	L	Ponosakan	\N
pnt	\N	\N	\N	I	L	Pontic	\N
pnu	\N	\N	\N	I	L	Jiongnai Bunu	\N
pnv	\N	\N	\N	I	L	Pinigura	\N
pnw	\N	\N	\N	I	L	Banyjima	\N
pnx	\N	\N	\N	I	L	Phong-Kniang	\N
pny	\N	\N	\N	I	L	Pinyin	\N
pnz	\N	\N	\N	I	L	Pana (Central African Republic)	\N
poc	\N	\N	\N	I	L	Poqomam	\N
poe	\N	\N	\N	I	L	San Juan Atzingo Popoloca	\N
pof	\N	\N	\N	I	L	Poke	\N
pog	\N	\N	\N	I	E	Potiguára	\N
poh	\N	\N	\N	I	L	Poqomchi'	\N
poi	\N	\N	\N	I	L	Highland Popoluca	\N
pok	\N	\N	\N	I	L	Pokangá	\N
pol	pol	pol	pl	I	L	Polish	\N
pom	\N	\N	\N	I	L	Southeastern Pomo	\N
pon	pon	pon	\N	I	L	Pohnpeian	\N
poo	\N	\N	\N	I	E	Central Pomo	\N
pop	\N	\N	\N	I	L	Pwapwâ	\N
poq	\N	\N	\N	I	L	Texistepec Popoluca	\N
por	por	por	pt	I	L	Portuguese	\N
pos	\N	\N	\N	I	L	Sayula Popoluca	\N
pot	\N	\N	\N	I	L	Potawatomi	\N
pov	\N	\N	\N	I	L	Upper Guinea Crioulo	\N
pow	\N	\N	\N	I	L	San Felipe Otlaltepec Popoloca	\N
pox	\N	\N	\N	I	E	Polabian	\N
poy	\N	\N	\N	I	L	Pogolo	\N
ppe	\N	\N	\N	I	L	Papi	\N
ppi	\N	\N	\N	I	L	Paipai	\N
ppk	\N	\N	\N	I	L	Uma	\N
ppl	\N	\N	\N	I	L	Pipil	\N
ppm	\N	\N	\N	I	L	Papuma	\N
ppn	\N	\N	\N	I	L	Papapana	\N
ppo	\N	\N	\N	I	L	Folopa	\N
ppp	\N	\N	\N	I	L	Pelende	\N
ppq	\N	\N	\N	I	L	Pei	\N
pps	\N	\N	\N	I	L	San Luís Temalacayuca Popoloca	\N
ppt	\N	\N	\N	I	L	Pare	\N
ppu	\N	\N	\N	I	E	Papora	\N
pqa	\N	\N	\N	I	L	Pa'a	\N
pqm	\N	\N	\N	I	L	Malecite-Passamaquoddy	\N
prc	\N	\N	\N	I	L	Parachi	\N
prd	\N	\N	\N	I	L	Parsi-Dari	\N
pre	\N	\N	\N	I	L	Principense	\N
prf	\N	\N	\N	I	L	Paranan	\N
prg	\N	\N	\N	I	L	Prussian	\N
prh	\N	\N	\N	I	L	Porohanon	\N
pri	\N	\N	\N	I	L	Paicî	\N
prk	\N	\N	\N	I	L	Parauk	\N
prl	\N	\N	\N	I	L	Peruvian Sign Language	\N
prm	\N	\N	\N	I	L	Kibiri	\N
prn	\N	\N	\N	I	L	Prasuni	\N
pro	pro	pro	\N	I	H	Old Provençal (to 1500)	\N
prq	\N	\N	\N	I	L	Ashéninka Perené	\N
prr	\N	\N	\N	I	E	Puri	\N
prs	\N	\N	\N	I	L	Dari	\N
prt	\N	\N	\N	I	L	Phai	\N
pru	\N	\N	\N	I	L	Puragi	\N
prw	\N	\N	\N	I	L	Parawen	\N
prx	\N	\N	\N	I	L	Purik	\N
prz	\N	\N	\N	I	L	Providencia Sign Language	\N
psa	\N	\N	\N	I	L	Asue Awyu	\N
psc	\N	\N	\N	I	L	Iranian Sign Language	\N
psd	\N	\N	\N	I	L	Plains Indian Sign Language	\N
pse	\N	\N	\N	I	L	Central Malay	\N
psg	\N	\N	\N	I	L	Penang Sign Language	\N
psh	\N	\N	\N	I	L	Southwest Pashai	\N
psi	\N	\N	\N	I	L	Southeast Pashai	\N
psl	\N	\N	\N	I	L	Puerto Rican Sign Language	\N
psm	\N	\N	\N	I	E	Pauserna	\N
psn	\N	\N	\N	I	L	Panasuan	\N
pso	\N	\N	\N	I	L	Polish Sign Language	\N
psp	\N	\N	\N	I	L	Philippine Sign Language	\N
psq	\N	\N	\N	I	L	Pasi	\N
psr	\N	\N	\N	I	L	Portuguese Sign Language	\N
pss	\N	\N	\N	I	L	Kaulong	\N
pst	\N	\N	\N	I	L	Central Pashto	\N
psu	\N	\N	\N	I	H	Sauraseni Prākrit	\N
psw	\N	\N	\N	I	L	Port Sandwich	\N
psy	\N	\N	\N	I	E	Piscataway	\N
pta	\N	\N	\N	I	L	Pai Tavytera	\N
pth	\N	\N	\N	I	E	Pataxó Hã-Ha-Hãe	\N
pti	\N	\N	\N	I	L	Pindiini	\N
ptn	\N	\N	\N	I	L	Patani	\N
pto	\N	\N	\N	I	L	Zo'é	\N
ptp	\N	\N	\N	I	L	Patep	\N
ptq	\N	\N	\N	I	L	Pattapu	\N
ptr	\N	\N	\N	I	L	Piamatsina	\N
ptt	\N	\N	\N	I	L	Enrekang	\N
ptu	\N	\N	\N	I	L	Bambam	\N
ptv	\N	\N	\N	I	L	Port Vato	\N
ptw	\N	\N	\N	I	E	Pentlatch	\N
pty	\N	\N	\N	I	L	Pathiya	\N
pua	\N	\N	\N	I	L	Western Highland Purepecha	\N
pub	\N	\N	\N	I	L	Purum	\N
puc	\N	\N	\N	I	L	Punan Merap	\N
pud	\N	\N	\N	I	L	Punan Aput	\N
pue	\N	\N	\N	I	E	Puelche	\N
puf	\N	\N	\N	I	L	Punan Merah	\N
pug	\N	\N	\N	I	L	Phuie	\N
pui	\N	\N	\N	I	L	Puinave	\N
puj	\N	\N	\N	I	L	Punan Tubu	\N
pum	\N	\N	\N	I	L	Puma	\N
puo	\N	\N	\N	I	L	Puoc	\N
pup	\N	\N	\N	I	L	Pulabu	\N
puq	\N	\N	\N	I	E	Puquina	\N
pur	\N	\N	\N	I	L	Puruborá	\N
pus	pus	pus	ps	M	L	Pushto	\N
put	\N	\N	\N	I	L	Putoh	\N
puu	\N	\N	\N	I	L	Punu	\N
puw	\N	\N	\N	I	L	Puluwatese	\N
pux	\N	\N	\N	I	L	Puare	\N
puy	\N	\N	\N	I	E	Purisimeño	\N
pwa	\N	\N	\N	I	L	Pawaia	\N
pwb	\N	\N	\N	I	L	Panawa	\N
pwg	\N	\N	\N	I	L	Gapapaiwa	\N
pwi	\N	\N	\N	I	E	Patwin	\N
pwm	\N	\N	\N	I	L	Molbog	\N
pwn	\N	\N	\N	I	L	Paiwan	\N
pwo	\N	\N	\N	I	L	Pwo Western Karen	\N
pwr	\N	\N	\N	I	L	Powari	\N
pww	\N	\N	\N	I	L	Pwo Northern Karen	\N
pxm	\N	\N	\N	I	L	Quetzaltepec Mixe	\N
pye	\N	\N	\N	I	L	Pye Krumen	\N
pym	\N	\N	\N	I	L	Fyam	\N
pyn	\N	\N	\N	I	L	Poyanáwa	\N
pys	\N	\N	\N	I	L	Paraguayan Sign Language	\N
pyu	\N	\N	\N	I	L	Puyuma	\N
pyx	\N	\N	\N	I	H	Pyu (Myanmar)	\N
pyy	\N	\N	\N	I	L	Pyen	\N
pze	\N	\N	\N	I	L	Pesse	\N
pzh	\N	\N	\N	I	L	Pazeh	\N
pzn	\N	\N	\N	I	L	Jejara Naga	\N
qua	\N	\N	\N	I	L	Quapaw	\N
qub	\N	\N	\N	I	L	Huallaga Huánuco Quechua	\N
quc	\N	\N	\N	I	L	K'iche'	\N
qud	\N	\N	\N	I	L	Calderón Highland Quichua	\N
que	que	que	qu	M	L	Quechua	\N
quf	\N	\N	\N	I	L	Lambayeque Quechua	\N
qug	\N	\N	\N	I	L	Chimborazo Highland Quichua	\N
quh	\N	\N	\N	I	L	South Bolivian Quechua	\N
qui	\N	\N	\N	I	L	Quileute	\N
quk	\N	\N	\N	I	L	Chachapoyas Quechua	\N
qul	\N	\N	\N	I	L	North Bolivian Quechua	\N
qum	\N	\N	\N	I	L	Sipacapense	\N
qun	\N	\N	\N	I	E	Quinault	\N
qup	\N	\N	\N	I	L	Southern Pastaza Quechua	\N
quq	\N	\N	\N	I	L	Quinqui	\N
qur	\N	\N	\N	I	L	Yanahuanca Pasco Quechua	\N
qus	\N	\N	\N	I	L	Santiago del Estero Quichua	\N
quv	\N	\N	\N	I	L	Sacapulteco	\N
quw	\N	\N	\N	I	L	Tena Lowland Quichua	\N
qux	\N	\N	\N	I	L	Yauyos Quechua	\N
quy	\N	\N	\N	I	L	Ayacucho Quechua	\N
quz	\N	\N	\N	I	L	Cusco Quechua	\N
qva	\N	\N	\N	I	L	Ambo-Pasco Quechua	\N
qvc	\N	\N	\N	I	L	Cajamarca Quechua	\N
qve	\N	\N	\N	I	L	Eastern Apurímac Quechua	\N
qvh	\N	\N	\N	I	L	Huamalíes-Dos de Mayo Huánuco Quechua	\N
qvi	\N	\N	\N	I	L	Imbabura Highland Quichua	\N
qvj	\N	\N	\N	I	L	Loja Highland Quichua	\N
qvl	\N	\N	\N	I	L	Cajatambo North Lima Quechua	\N
qvm	\N	\N	\N	I	L	Margos-Yarowilca-Lauricocha Quechua	\N
qvn	\N	\N	\N	I	L	North Junín Quechua	\N
qvo	\N	\N	\N	I	L	Napo Lowland Quechua	\N
qvp	\N	\N	\N	I	L	Pacaraos Quechua	\N
qvs	\N	\N	\N	I	L	San Martín Quechua	\N
qvw	\N	\N	\N	I	L	Huaylla Wanca Quechua	\N
qvy	\N	\N	\N	I	L	Queyu	\N
qvz	\N	\N	\N	I	L	Northern Pastaza Quichua	\N
qwa	\N	\N	\N	I	L	Corongo Ancash Quechua	\N
qwc	\N	\N	\N	I	H	Classical Quechua	\N
qwh	\N	\N	\N	I	L	Huaylas Ancash Quechua	\N
qwm	\N	\N	\N	I	E	Kuman (Russia)	\N
qws	\N	\N	\N	I	L	Sihuas Ancash Quechua	\N
qwt	\N	\N	\N	I	E	Kwalhioqua-Tlatskanai	\N
qxa	\N	\N	\N	I	L	Chiquián Ancash Quechua	\N
qxc	\N	\N	\N	I	L	Chincha Quechua	\N
qxh	\N	\N	\N	I	L	Panao Huánuco Quechua	\N
qxl	\N	\N	\N	I	L	Salasaca Highland Quichua	\N
qxn	\N	\N	\N	I	L	Northern Conchucos Ancash Quechua	\N
qxo	\N	\N	\N	I	L	Southern Conchucos Ancash Quechua	\N
qxp	\N	\N	\N	I	L	Puno Quechua	\N
qxq	\N	\N	\N	I	L	Qashqa'i	\N
qxr	\N	\N	\N	I	L	Cañar Highland Quichua	\N
qxs	\N	\N	\N	I	L	Southern Qiang	\N
qxt	\N	\N	\N	I	L	Santa Ana de Tusi Pasco Quechua	\N
qxu	\N	\N	\N	I	L	Arequipa-La Unión Quechua	\N
qxw	\N	\N	\N	I	L	Jauja Wanca Quechua	\N
qya	\N	\N	\N	I	C	Quenya	\N
qyp	\N	\N	\N	I	E	Quiripi	\N
raa	\N	\N	\N	I	L	Dungmali	\N
rab	\N	\N	\N	I	L	Camling	\N
rac	\N	\N	\N	I	L	Rasawa	\N
rad	\N	\N	\N	I	L	Rade	\N
raf	\N	\N	\N	I	L	Western Meohang	\N
rag	\N	\N	\N	I	L	Logooli	\N
rah	\N	\N	\N	I	L	Rabha	\N
rai	\N	\N	\N	I	L	Ramoaaina	\N
raj	raj	raj	\N	M	L	Rajasthani	\N
rak	\N	\N	\N	I	L	Tulu-Bohuai	\N
ral	\N	\N	\N	I	L	Ralte	\N
ram	\N	\N	\N	I	L	Canela	\N
ran	\N	\N	\N	I	L	Riantana	\N
rao	\N	\N	\N	I	L	Rao	\N
rap	rap	rap	\N	I	L	Rapanui	\N
raq	\N	\N	\N	I	L	Saam	\N
rar	rar	rar	\N	I	L	Rarotongan	\N
ras	\N	\N	\N	I	L	Tegali	\N
rat	\N	\N	\N	I	L	Razajerdi	\N
rau	\N	\N	\N	I	L	Raute	\N
rav	\N	\N	\N	I	L	Sampang	\N
raw	\N	\N	\N	I	L	Rawang	\N
rax	\N	\N	\N	I	L	Rang	\N
ray	\N	\N	\N	I	L	Rapa	\N
raz	\N	\N	\N	I	L	Rahambuu	\N
rbb	\N	\N	\N	I	L	Rumai Palaung	\N
rbk	\N	\N	\N	I	L	Northern Bontok	\N
rbl	\N	\N	\N	I	L	Miraya Bikol	\N
rbp	\N	\N	\N	I	E	Barababaraba	\N
rcf	\N	\N	\N	I	L	Réunion Creole French	\N
rdb	\N	\N	\N	I	L	Rudbari	\N
rea	\N	\N	\N	I	L	Rerau	\N
reb	\N	\N	\N	I	L	Rembong	\N
ree	\N	\N	\N	I	L	Rejang Kayan	\N
reg	\N	\N	\N	I	L	Kara (Tanzania)	\N
rei	\N	\N	\N	I	L	Reli	\N
rej	\N	\N	\N	I	L	Rejang	\N
rel	\N	\N	\N	I	L	Rendille	\N
rem	\N	\N	\N	I	E	Remo	\N
ren	\N	\N	\N	I	L	Rengao	\N
rer	\N	\N	\N	I	E	Rer Bare	\N
res	\N	\N	\N	I	L	Reshe	\N
ret	\N	\N	\N	I	L	Retta	\N
rey	\N	\N	\N	I	L	Reyesano	\N
rga	\N	\N	\N	I	L	Roria	\N
rge	\N	\N	\N	I	L	Romano-Greek	\N
rgk	\N	\N	\N	I	E	Rangkas	\N
rgn	\N	\N	\N	I	L	Romagnol	\N
rgr	\N	\N	\N	I	L	Resígaro	\N
rgs	\N	\N	\N	I	L	Southern Roglai	\N
rgu	\N	\N	\N	I	L	Ringgou	\N
rhg	\N	\N	\N	I	L	Rohingya	\N
rhp	\N	\N	\N	I	L	Yahang	\N
ria	\N	\N	\N	I	L	Riang (India)	\N
rib	\N	\N	\N	I	L	Bribri Sign Language	\N
rif	\N	\N	\N	I	L	Tarifit	\N
ril	\N	\N	\N	I	L	Riang Lang	\N
rim	\N	\N	\N	I	L	Nyaturu	\N
rin	\N	\N	\N	I	L	Nungu	\N
rir	\N	\N	\N	I	L	Ribun	\N
rit	\N	\N	\N	I	L	Ritharrngu	\N
riu	\N	\N	\N	I	L	Riung	\N
rjg	\N	\N	\N	I	L	Rajong	\N
rji	\N	\N	\N	I	L	Raji	\N
rjs	\N	\N	\N	I	L	Rajbanshi	\N
rka	\N	\N	\N	I	L	Kraol	\N
rkb	\N	\N	\N	I	L	Rikbaktsa	\N
rkh	\N	\N	\N	I	L	Rakahanga-Manihiki	\N
rki	\N	\N	\N	I	L	Rakhine	\N
rkm	\N	\N	\N	I	L	Marka	\N
rkt	\N	\N	\N	I	L	Rangpuri	\N
rkw	\N	\N	\N	I	E	Arakwal	\N
rma	\N	\N	\N	I	L	Rama	\N
rmb	\N	\N	\N	I	L	Rembarrnga	\N
rmc	\N	\N	\N	I	L	Carpathian Romani	\N
rmd	\N	\N	\N	I	E	Traveller Danish	\N
rme	\N	\N	\N	I	L	Angloromani	\N
rmf	\N	\N	\N	I	L	Kalo Finnish Romani	\N
rmg	\N	\N	\N	I	L	Traveller Norwegian	\N
rmh	\N	\N	\N	I	L	Murkim	\N
rmi	\N	\N	\N	I	L	Lomavren	\N
rmk	\N	\N	\N	I	L	Romkun	\N
rml	\N	\N	\N	I	L	Baltic Romani	\N
rmm	\N	\N	\N	I	L	Roma	\N
rmn	\N	\N	\N	I	L	Balkan Romani	\N
rmo	\N	\N	\N	I	L	Sinte Romani	\N
rmp	\N	\N	\N	I	L	Rempi	\N
rmq	\N	\N	\N	I	L	Caló	\N
rms	\N	\N	\N	I	L	Romanian Sign Language	\N
rmt	\N	\N	\N	I	L	Domari	\N
rmu	\N	\N	\N	I	L	Tavringer Romani	\N
rmv	\N	\N	\N	I	C	Romanova	\N
rmw	\N	\N	\N	I	L	Welsh Romani	\N
rmx	\N	\N	\N	I	L	Romam	\N
rmy	\N	\N	\N	I	L	Vlax Romani	\N
rmz	\N	\N	\N	I	L	Marma	\N
rnb	\N	\N	\N	I	L	Brunca Sign Language	\N
rnd	\N	\N	\N	I	L	Ruund	\N
rng	\N	\N	\N	I	L	Ronga	\N
rnl	\N	\N	\N	I	L	Ranglong	\N
rnn	\N	\N	\N	I	L	Roon	\N
rnp	\N	\N	\N	I	L	Rongpo	\N
rnr	\N	\N	\N	I	E	Nari Nari	\N
rnw	\N	\N	\N	I	L	Rungwa	\N
rob	\N	\N	\N	I	L	Tae'	\N
roc	\N	\N	\N	I	L	Cacgia Roglai	\N
rod	\N	\N	\N	I	L	Rogo	\N
roe	\N	\N	\N	I	L	Ronji	\N
rof	\N	\N	\N	I	L	Rombo	\N
rog	\N	\N	\N	I	L	Northern Roglai	\N
roh	roh	roh	rm	I	L	Romansh	\N
rol	\N	\N	\N	I	L	Romblomanon	\N
rom	rom	rom	\N	M	L	Romany	\N
ron	rum	ron	ro	I	L	Romanian	\N
roo	\N	\N	\N	I	L	Rotokas	\N
rop	\N	\N	\N	I	L	Kriol	\N
ror	\N	\N	\N	I	L	Rongga	\N
rou	\N	\N	\N	I	L	Runga	\N
row	\N	\N	\N	I	L	Dela-Oenale	\N
rpn	\N	\N	\N	I	L	Repanbitip	\N
rpt	\N	\N	\N	I	L	Rapting	\N
rri	\N	\N	\N	I	L	Ririo	\N
rrm	\N	\N	\N	I	E	Moriori	\N
rro	\N	\N	\N	I	L	Waima	\N
rrt	\N	\N	\N	I	E	Arritinngithigh	\N
rsb	\N	\N	\N	I	L	Romano-Serbian	\N
rsk	\N	\N	\N	I	L	Ruthenian	\N
rsl	\N	\N	\N	I	L	Russian Sign Language	\N
rsm	\N	\N	\N	I	L	Miriwoong Sign Language	\N
rsn	\N	\N	\N	I	L	Rwandan Sign Language	\N
rsw	\N	\N	\N	I	L	Rishiwa	\N
rtc	\N	\N	\N	I	L	Rungtu Chin	\N
rth	\N	\N	\N	I	L	Ratahan	\N
rtm	\N	\N	\N	I	L	Rotuman	\N
rts	\N	\N	\N	I	E	Yurats	\N
rtw	\N	\N	\N	I	L	Rathawi	\N
rub	\N	\N	\N	I	L	Gungu	\N
ruc	\N	\N	\N	I	L	Ruuli	\N
rue	\N	\N	\N	I	L	Rusyn	\N
ruf	\N	\N	\N	I	L	Luguru	\N
rug	\N	\N	\N	I	L	Roviana	\N
ruh	\N	\N	\N	I	L	Ruga	\N
rui	\N	\N	\N	I	L	Rufiji	\N
ruk	\N	\N	\N	I	L	Che	\N
run	run	run	rn	I	L	Rundi	\N
ruo	\N	\N	\N	I	L	Istro Romanian	\N
rup	rup	rup	\N	I	L	Macedo-Romanian	\N
ruq	\N	\N	\N	I	L	Megleno Romanian	\N
rus	rus	rus	ru	I	L	Russian	\N
rut	\N	\N	\N	I	L	Rutul	\N
ruu	\N	\N	\N	I	L	Lanas Lobu	\N
ruy	\N	\N	\N	I	L	Mala (Nigeria)	\N
ruz	\N	\N	\N	I	L	Ruma	\N
rwa	\N	\N	\N	I	L	Rawo	\N
rwk	\N	\N	\N	I	L	Rwa	\N
rwl	\N	\N	\N	I	L	Ruwila	\N
rwm	\N	\N	\N	I	L	Amba (Uganda)	\N
rwo	\N	\N	\N	I	L	Rawa	\N
rwr	\N	\N	\N	I	L	Marwari (India)	\N
rxd	\N	\N	\N	I	L	Ngardi	\N
rxw	\N	\N	\N	I	E	Karuwali	\N
ryn	\N	\N	\N	I	L	Northern Amami-Oshima	\N
rys	\N	\N	\N	I	L	Yaeyama	\N
ryu	\N	\N	\N	I	L	Central Okinawan	\N
rzh	\N	\N	\N	I	L	Rāziḥī	\N
saa	\N	\N	\N	I	L	Saba	\N
sab	\N	\N	\N	I	L	Buglere	\N
sac	\N	\N	\N	I	L	Meskwaki	\N
sad	sad	sad	\N	I	L	Sandawe	\N
sae	\N	\N	\N	I	L	Sabanê	\N
saf	\N	\N	\N	I	L	Safaliba	\N
sag	sag	sag	sg	I	L	Sango	\N
sah	sah	sah	\N	I	L	Yakut	\N
saj	\N	\N	\N	I	L	Sahu	\N
sak	\N	\N	\N	I	L	Sake	\N
sam	sam	sam	\N	I	E	Samaritan Aramaic	\N
san	san	san	sa	M	H	Sanskrit	\N
sao	\N	\N	\N	I	L	Sause	\N
saq	\N	\N	\N	I	L	Samburu	\N
sar	\N	\N	\N	I	E	Saraveca	\N
sas	sas	sas	\N	I	L	Sasak	\N
sat	sat	sat	\N	I	L	Santali	\N
sau	\N	\N	\N	I	L	Saleman	\N
sav	\N	\N	\N	I	L	Saafi-Saafi	\N
saw	\N	\N	\N	I	L	Sawi	\N
sax	\N	\N	\N	I	L	Sa	\N
say	\N	\N	\N	I	L	Saya	\N
saz	\N	\N	\N	I	L	Saurashtra	\N
sba	\N	\N	\N	I	L	Ngambay	\N
sbb	\N	\N	\N	I	L	Simbo	\N
sbc	\N	\N	\N	I	L	Kele (Papua New Guinea)	\N
sbd	\N	\N	\N	I	L	Southern Samo	\N
sbe	\N	\N	\N	I	L	Saliba	\N
sbf	\N	\N	\N	I	L	Chabu	\N
sbg	\N	\N	\N	I	L	Seget	\N
sbh	\N	\N	\N	I	L	Sori-Harengan	\N
sbi	\N	\N	\N	I	L	Seti	\N
sbj	\N	\N	\N	I	L	Surbakhal	\N
sbk	\N	\N	\N	I	L	Safwa	\N
sbl	\N	\N	\N	I	L	Botolan Sambal	\N
sbm	\N	\N	\N	I	L	Sagala	\N
sbn	\N	\N	\N	I	L	Sindhi Bhil	\N
sbo	\N	\N	\N	I	L	Sabüm	\N
sbp	\N	\N	\N	I	L	Sangu (Tanzania)	\N
sbq	\N	\N	\N	I	L	Sileibi	\N
sbr	\N	\N	\N	I	L	Sembakung Murut	\N
sbs	\N	\N	\N	I	L	Subiya	\N
sbt	\N	\N	\N	I	L	Kimki	\N
sbu	\N	\N	\N	I	L	Stod Bhoti	\N
sbv	\N	\N	\N	I	H	Sabine	\N
sbw	\N	\N	\N	I	L	Simba	\N
sbx	\N	\N	\N	I	L	Seberuang	\N
sby	\N	\N	\N	I	L	Soli	\N
sbz	\N	\N	\N	I	L	Sara Kaba	\N
scb	\N	\N	\N	I	L	Chut	\N
sce	\N	\N	\N	I	L	Dongxiang	\N
scf	\N	\N	\N	I	L	San Miguel Creole French	\N
scg	\N	\N	\N	I	L	Sanggau	\N
sch	\N	\N	\N	I	L	Sakachep	\N
sci	\N	\N	\N	I	L	Sri Lankan Creole Malay	\N
sck	\N	\N	\N	I	L	Sadri	\N
scl	\N	\N	\N	I	L	Shina	\N
scn	scn	scn	\N	I	L	Sicilian	\N
sco	sco	sco	\N	I	L	Scots	\N
scp	\N	\N	\N	I	L	Hyolmo	\N
scq	\N	\N	\N	I	L	Sa'och	\N
scs	\N	\N	\N	I	L	North Slavey	\N
sct	\N	\N	\N	I	L	Southern Katang	\N
scu	\N	\N	\N	I	L	Shumcho	\N
scv	\N	\N	\N	I	L	Sheni	\N
scw	\N	\N	\N	I	L	Sha	\N
scx	\N	\N	\N	I	H	Sicel	\N
sda	\N	\N	\N	I	L	Toraja-Sa'dan	\N
sdb	\N	\N	\N	I	L	Shabak	\N
sdc	\N	\N	\N	I	L	Sassarese Sardinian	\N
sde	\N	\N	\N	I	L	Surubu	\N
sdf	\N	\N	\N	I	L	Sarli	\N
sdg	\N	\N	\N	I	L	Savi	\N
sdh	\N	\N	\N	I	L	Southern Kurdish	\N
sdj	\N	\N	\N	I	L	Suundi	\N
sdk	\N	\N	\N	I	L	Sos Kundi	\N
sdl	\N	\N	\N	I	L	Saudi Arabian Sign Language	\N
sdn	\N	\N	\N	I	L	Gallurese Sardinian	\N
sdo	\N	\N	\N	I	L	Bukar-Sadung Bidayuh	\N
sdp	\N	\N	\N	I	L	Sherdukpen	\N
sdq	\N	\N	\N	I	L	Semandang	\N
sdr	\N	\N	\N	I	L	Oraon Sadri	\N
sds	\N	\N	\N	I	E	Sened	\N
sdt	\N	\N	\N	I	E	Shuadit	\N
sdu	\N	\N	\N	I	L	Sarudu	\N
sdx	\N	\N	\N	I	L	Sibu Melanau	\N
sdz	\N	\N	\N	I	L	Sallands	\N
sea	\N	\N	\N	I	L	Semai	\N
seb	\N	\N	\N	I	L	Shempire Senoufo	\N
sec	\N	\N	\N	I	L	Sechelt	\N
sed	\N	\N	\N	I	L	Sedang	\N
see	\N	\N	\N	I	L	Seneca	\N
sef	\N	\N	\N	I	L	Cebaara Senoufo	\N
seg	\N	\N	\N	I	L	Segeju	\N
seh	\N	\N	\N	I	L	Sena	\N
sei	\N	\N	\N	I	L	Seri	\N
sej	\N	\N	\N	I	L	Sene	\N
sek	\N	\N	\N	I	L	Sekani	\N
sel	sel	sel	\N	I	L	Selkup	\N
sen	\N	\N	\N	I	L	Nanerigé Sénoufo	\N
seo	\N	\N	\N	I	L	Suarmin	\N
sep	\N	\N	\N	I	L	Sìcìté Sénoufo	\N
seq	\N	\N	\N	I	L	Senara Sénoufo	\N
ser	\N	\N	\N	I	L	Serrano	\N
ses	\N	\N	\N	I	L	Koyraboro Senni Songhai	\N
set	\N	\N	\N	I	L	Sentani	\N
seu	\N	\N	\N	I	L	Serui-Laut	\N
sev	\N	\N	\N	I	L	Nyarafolo Senoufo	\N
sew	\N	\N	\N	I	L	Sewa Bay	\N
sey	\N	\N	\N	I	L	Secoya	\N
sez	\N	\N	\N	I	L	Senthang Chin	\N
sfb	\N	\N	\N	I	L	Langue des signes de Belgique Francophone	\N
sfe	\N	\N	\N	I	L	Eastern Subanen	\N
sfm	\N	\N	\N	I	L	Small Flowery Miao	\N
sfs	\N	\N	\N	I	L	South African Sign Language	\N
sfw	\N	\N	\N	I	L	Sehwi	\N
sga	sga	sga	\N	I	H	Old Irish (to 900)	\N
sgb	\N	\N	\N	I	L	Mag-antsi Ayta	\N
sgc	\N	\N	\N	I	L	Kipsigis	\N
sgd	\N	\N	\N	I	L	Surigaonon	\N
sge	\N	\N	\N	I	L	Segai	\N
sgg	\N	\N	\N	I	L	Swiss-German Sign Language	\N
sgh	\N	\N	\N	I	L	Shughni	\N
sgi	\N	\N	\N	I	L	Suga	\N
sgj	\N	\N	\N	I	L	Surgujia	\N
sgk	\N	\N	\N	I	L	Sangkong	\N
sgm	\N	\N	\N	I	E	Singa	\N
sgp	\N	\N	\N	I	L	Singpho	\N
sgr	\N	\N	\N	I	L	Sangisari	\N
sgs	\N	\N	\N	I	L	Samogitian	\N
sgt	\N	\N	\N	I	L	Brokpake	\N
sgu	\N	\N	\N	I	L	Salas	\N
sgw	\N	\N	\N	I	L	Sebat Bet Gurage	\N
sgx	\N	\N	\N	I	L	Sierra Leone Sign Language	\N
sgy	\N	\N	\N	I	L	Sanglechi	\N
sgz	\N	\N	\N	I	L	Sursurunga	\N
sha	\N	\N	\N	I	L	Shall-Zwall	\N
shb	\N	\N	\N	I	L	Ninam	\N
shc	\N	\N	\N	I	L	Sonde	\N
shd	\N	\N	\N	I	L	Kundal Shahi	\N
she	\N	\N	\N	I	L	Sheko	\N
shg	\N	\N	\N	I	L	Shua	\N
shh	\N	\N	\N	I	L	Shoshoni	\N
shi	\N	\N	\N	I	L	Tachelhit	\N
shj	\N	\N	\N	I	L	Shatt	\N
shk	\N	\N	\N	I	L	Shilluk	\N
shl	\N	\N	\N	I	L	Shendu	\N
shm	\N	\N	\N	I	L	Shahrudi	\N
shn	shn	shn	\N	I	L	Shan	\N
sho	\N	\N	\N	I	L	Shanga	\N
shp	\N	\N	\N	I	L	Shipibo-Conibo	\N
shq	\N	\N	\N	I	L	Sala	\N
shr	\N	\N	\N	I	L	Shi	\N
shs	\N	\N	\N	I	L	Shuswap	\N
sht	\N	\N	\N	I	E	Shasta	\N
shu	\N	\N	\N	I	L	Chadian Arabic	\N
shv	\N	\N	\N	I	L	Shehri	\N
shw	\N	\N	\N	I	L	Shwai	\N
shx	\N	\N	\N	I	L	She	\N
shy	\N	\N	\N	I	L	Tachawit	\N
shz	\N	\N	\N	I	L	Syenara Senoufo	\N
sia	\N	\N	\N	I	E	Akkala Sami	\N
sib	\N	\N	\N	I	L	Sebop	\N
sid	sid	sid	\N	I	L	Sidamo	\N
sie	\N	\N	\N	I	L	Simaa	\N
sif	\N	\N	\N	I	L	Siamou	\N
sig	\N	\N	\N	I	L	Paasaal	\N
sih	\N	\N	\N	I	L	Zire	\N
sii	\N	\N	\N	I	L	Shom Peng	\N
sij	\N	\N	\N	I	L	Numbami	\N
sik	\N	\N	\N	I	L	Sikiana	\N
sil	\N	\N	\N	I	L	Tumulung Sisaala	\N
sim	\N	\N	\N	I	L	Mende (Papua New Guinea)	\N
sin	sin	sin	si	I	L	Sinhala	\N
sip	\N	\N	\N	I	L	Sikkimese	\N
siq	\N	\N	\N	I	L	Sonia	\N
sir	\N	\N	\N	I	L	Siri	\N
sis	\N	\N	\N	I	E	Siuslaw	\N
siu	\N	\N	\N	I	L	Sinagen	\N
siv	\N	\N	\N	I	L	Sumariup	\N
siw	\N	\N	\N	I	L	Siwai	\N
six	\N	\N	\N	I	L	Sumau	\N
siy	\N	\N	\N	I	L	Sivandi	\N
siz	\N	\N	\N	I	L	Siwi	\N
sja	\N	\N	\N	I	L	Epena	\N
sjb	\N	\N	\N	I	L	Sajau Basap	\N
sjd	\N	\N	\N	I	L	Kildin Sami	\N
sje	\N	\N	\N	I	L	Pite Sami	\N
sjg	\N	\N	\N	I	L	Assangori	\N
sjk	\N	\N	\N	I	E	Kemi Sami	\N
sjl	\N	\N	\N	I	L	Sajalong	\N
sjm	\N	\N	\N	I	L	Mapun	\N
sjn	\N	\N	\N	I	C	Sindarin	\N
sjo	\N	\N	\N	I	L	Xibe	\N
sjp	\N	\N	\N	I	L	Surjapuri	\N
sjr	\N	\N	\N	I	L	Siar-Lak	\N
sjs	\N	\N	\N	I	E	Senhaja De Srair	\N
sjt	\N	\N	\N	I	L	Ter Sami	\N
sju	\N	\N	\N	I	L	Ume Sami	\N
sjw	\N	\N	\N	I	L	Shawnee	\N
ska	\N	\N	\N	I	L	Skagit	\N
skb	\N	\N	\N	I	L	Saek	\N
skc	\N	\N	\N	I	L	Ma Manda	\N
skd	\N	\N	\N	I	L	Southern Sierra Miwok	\N
ske	\N	\N	\N	I	L	Seke (Vanuatu)	\N
skf	\N	\N	\N	I	L	Sakirabiá	\N
skg	\N	\N	\N	I	L	Sakalava Malagasy	\N
skh	\N	\N	\N	I	L	Sikule	\N
ski	\N	\N	\N	I	L	Sika	\N
skj	\N	\N	\N	I	L	Seke (Nepal)	\N
skm	\N	\N	\N	I	L	Kutong	\N
skn	\N	\N	\N	I	L	Kolibugan Subanon	\N
sko	\N	\N	\N	I	L	Seko Tengah	\N
skp	\N	\N	\N	I	L	Sekapan	\N
skq	\N	\N	\N	I	L	Sininkere	\N
skr	\N	\N	\N	I	L	Saraiki	\N
sks	\N	\N	\N	I	L	Maia	\N
skt	\N	\N	\N	I	L	Sakata	\N
sku	\N	\N	\N	I	L	Sakao	\N
skv	\N	\N	\N	I	L	Skou	\N
skw	\N	\N	\N	I	E	Skepi Creole Dutch	\N
skx	\N	\N	\N	I	L	Seko Padang	\N
sky	\N	\N	\N	I	L	Sikaiana	\N
skz	\N	\N	\N	I	L	Sekar	\N
slc	\N	\N	\N	I	L	Sáliba	\N
sld	\N	\N	\N	I	L	Sissala	\N
sle	\N	\N	\N	I	L	Sholaga	\N
slf	\N	\N	\N	I	L	Swiss-Italian Sign Language	\N
slg	\N	\N	\N	I	L	Selungai Murut	\N
slh	\N	\N	\N	I	L	Southern Puget Sound Salish	\N
sli	\N	\N	\N	I	L	Lower Silesian	\N
slj	\N	\N	\N	I	L	Salumá	\N
slk	slo	slk	sk	I	L	Slovak	\N
sll	\N	\N	\N	I	L	Salt-Yui	\N
slm	\N	\N	\N	I	L	Pangutaran Sama	\N
sln	\N	\N	\N	I	E	Salinan	\N
slp	\N	\N	\N	I	L	Lamaholot	\N
slr	\N	\N	\N	I	L	Salar	\N
sls	\N	\N	\N	I	L	Singapore Sign Language	\N
slt	\N	\N	\N	I	L	Sila	\N
slu	\N	\N	\N	I	L	Selaru	\N
slv	slv	slv	sl	I	L	Slovenian	\N
slw	\N	\N	\N	I	L	Sialum	\N
slx	\N	\N	\N	I	L	Salampasu	\N
sly	\N	\N	\N	I	L	Selayar	\N
slz	\N	\N	\N	I	L	Ma'ya	\N
sma	sma	sma	\N	I	L	Southern Sami	\N
smb	\N	\N	\N	I	L	Simbari	\N
smc	\N	\N	\N	I	E	Som	\N
sme	sme	sme	se	I	L	Northern Sami	\N
smf	\N	\N	\N	I	L	Auwe	\N
smg	\N	\N	\N	I	L	Simbali	\N
smh	\N	\N	\N	I	L	Samei	\N
smj	smj	smj	\N	I	L	Lule Sami	\N
smk	\N	\N	\N	I	L	Bolinao	\N
sml	\N	\N	\N	I	L	Central Sama	\N
smm	\N	\N	\N	I	L	Musasa	\N
smn	smn	smn	\N	I	L	Inari Sami	\N
smo	smo	smo	sm	I	L	Samoan	\N
smp	\N	\N	\N	I	E	Samaritan	\N
smq	\N	\N	\N	I	L	Samo	\N
smr	\N	\N	\N	I	L	Simeulue	\N
sms	sms	sms	\N	I	L	Skolt Sami	\N
smt	\N	\N	\N	I	L	Simte	\N
smu	\N	\N	\N	I	E	Somray	\N
smv	\N	\N	\N	I	L	Samvedi	\N
smw	\N	\N	\N	I	L	Sumbawa	\N
smx	\N	\N	\N	I	L	Samba	\N
smy	\N	\N	\N	I	L	Semnani	\N
smz	\N	\N	\N	I	L	Simeku	\N
sna	sna	sna	sn	I	L	Shona	\N
snc	\N	\N	\N	I	L	Sinaugoro	\N
snd	snd	snd	sd	I	L	Sindhi	\N
sne	\N	\N	\N	I	L	Bau Bidayuh	\N
snf	\N	\N	\N	I	L	Noon	\N
sng	\N	\N	\N	I	L	Sanga (Democratic Republic of Congo)	\N
sni	\N	\N	\N	I	E	Sensi	\N
snj	\N	\N	\N	I	L	Riverain Sango	\N
snk	snk	snk	\N	I	L	Soninke	\N
snl	\N	\N	\N	I	L	Sangil	\N
snm	\N	\N	\N	I	L	Southern Ma'di	\N
snn	\N	\N	\N	I	L	Siona	\N
sno	\N	\N	\N	I	L	Snohomish	\N
snp	\N	\N	\N	I	L	Siane	\N
snq	\N	\N	\N	I	L	Sangu (Gabon)	\N
snr	\N	\N	\N	I	L	Sihan	\N
sns	\N	\N	\N	I	L	South West Bay	\N
snu	\N	\N	\N	I	L	Senggi	\N
snv	\N	\N	\N	I	L	Sa'ban	\N
snw	\N	\N	\N	I	L	Selee	\N
snx	\N	\N	\N	I	L	Sam	\N
sny	\N	\N	\N	I	L	Saniyo-Hiyewe	\N
snz	\N	\N	\N	I	L	Kou	\N
soa	\N	\N	\N	I	L	Thai Song	\N
sob	\N	\N	\N	I	L	Sobei	\N
soc	\N	\N	\N	I	L	So (Democratic Republic of Congo)	\N
sod	\N	\N	\N	I	L	Songoora	\N
soe	\N	\N	\N	I	L	Songomeno	\N
sog	sog	sog	\N	I	H	Sogdian	\N
soh	\N	\N	\N	I	L	Aka	\N
soi	\N	\N	\N	I	L	Sonha	\N
soj	\N	\N	\N	I	L	Soi	\N
sok	\N	\N	\N	I	L	Sokoro	\N
sol	\N	\N	\N	I	L	Solos	\N
som	som	som	so	I	L	Somali	\N
soo	\N	\N	\N	I	L	Songo	\N
sop	\N	\N	\N	I	L	Songe	\N
soq	\N	\N	\N	I	L	Kanasi	\N
sor	\N	\N	\N	I	L	Somrai	\N
sos	\N	\N	\N	I	L	Seeku	\N
sot	sot	sot	st	I	L	Southern Sotho	\N
sou	\N	\N	\N	I	L	Southern Thai	\N
sov	\N	\N	\N	I	L	Sonsorol	\N
sow	\N	\N	\N	I	L	Sowanda	\N
sox	\N	\N	\N	I	L	Swo	\N
soy	\N	\N	\N	I	L	Miyobe	\N
soz	\N	\N	\N	I	L	Temi	\N
spa	spa	spa	es	I	L	Spanish	\N
spb	\N	\N	\N	I	L	Sepa (Indonesia)	\N
spc	\N	\N	\N	I	L	Sapé	\N
spd	\N	\N	\N	I	L	Saep	\N
spe	\N	\N	\N	I	L	Sepa (Papua New Guinea)	\N
spg	\N	\N	\N	I	L	Sian	\N
spi	\N	\N	\N	I	L	Saponi	\N
spk	\N	\N	\N	I	L	Sengo	\N
spl	\N	\N	\N	I	L	Selepet	\N
spm	\N	\N	\N	I	L	Akukem	\N
spn	\N	\N	\N	I	L	Sanapaná	\N
spo	\N	\N	\N	I	L	Spokane	\N
spp	\N	\N	\N	I	L	Supyire Senoufo	\N
spq	\N	\N	\N	I	L	Loreto-Ucayali Spanish	\N
spr	\N	\N	\N	I	L	Saparua	\N
sps	\N	\N	\N	I	L	Saposa	\N
spt	\N	\N	\N	I	L	Spiti Bhoti	\N
spu	\N	\N	\N	I	L	Sapuan	\N
spv	\N	\N	\N	I	L	Sambalpuri	\N
spx	\N	\N	\N	I	H	South Picene	\N
spy	\N	\N	\N	I	L	Sabaot	\N
sqa	\N	\N	\N	I	L	Shama-Sambuga	\N
sqh	\N	\N	\N	I	L	Shau	\N
sqi	alb	sqi	sq	M	L	Albanian	\N
sqk	\N	\N	\N	I	L	Albanian Sign Language	\N
sqm	\N	\N	\N	I	L	Suma	\N
sqn	\N	\N	\N	I	E	Susquehannock	\N
sqo	\N	\N	\N	I	L	Sorkhei	\N
sqq	\N	\N	\N	I	L	Sou	\N
sqr	\N	\N	\N	I	H	Siculo Arabic	\N
sqs	\N	\N	\N	I	L	Sri Lankan Sign Language	\N
sqt	\N	\N	\N	I	L	Soqotri	\N
squ	\N	\N	\N	I	L	Squamish	\N
sqx	\N	\N	\N	I	L	Kufr Qassem Sign Language (KQSL)	\N
sra	\N	\N	\N	I	L	Saruga	\N
srb	\N	\N	\N	I	L	Sora	\N
src	\N	\N	\N	I	L	Logudorese Sardinian	\N
srd	srd	srd	sc	M	L	Sardinian	\N
sre	\N	\N	\N	I	L	Sara	\N
srf	\N	\N	\N	I	L	Nafi	\N
srg	\N	\N	\N	I	L	Sulod	\N
srh	\N	\N	\N	I	L	Sarikoli	\N
sri	\N	\N	\N	I	L	Siriano	\N
srk	\N	\N	\N	I	L	Serudung Murut	\N
srl	\N	\N	\N	I	L	Isirawa	\N
srm	\N	\N	\N	I	L	Saramaccan	\N
srn	srn	srn	\N	I	L	Sranan Tongo	\N
sro	\N	\N	\N	I	L	Campidanese Sardinian	\N
srp	srp	srp	sr	I	L	Serbian	\N
srq	\N	\N	\N	I	L	Sirionó	\N
srr	srr	srr	\N	I	L	Serer	\N
srs	\N	\N	\N	I	L	Sarsi	\N
srt	\N	\N	\N	I	L	Sauri	\N
sru	\N	\N	\N	I	L	Suruí	\N
srv	\N	\N	\N	I	L	Southern Sorsoganon	\N
srw	\N	\N	\N	I	L	Serua	\N
srx	\N	\N	\N	I	L	Sirmauri	\N
sry	\N	\N	\N	I	L	Sera	\N
srz	\N	\N	\N	I	L	Shahmirzadi	\N
ssb	\N	\N	\N	I	L	Southern Sama	\N
ssc	\N	\N	\N	I	L	Suba-Simbiti	\N
ssd	\N	\N	\N	I	L	Siroi	\N
sse	\N	\N	\N	I	L	Balangingi	\N
ssf	\N	\N	\N	I	L	Thao	\N
ssg	\N	\N	\N	I	L	Seimat	\N
ssh	\N	\N	\N	I	L	Shihhi Arabic	\N
ssi	\N	\N	\N	I	L	Sansi	\N
ssj	\N	\N	\N	I	L	Sausi	\N
ssk	\N	\N	\N	I	L	Sunam	\N
ssl	\N	\N	\N	I	L	Western Sisaala	\N
ssm	\N	\N	\N	I	L	Semnam	\N
ssn	\N	\N	\N	I	L	Waata	\N
sso	\N	\N	\N	I	L	Sissano	\N
ssp	\N	\N	\N	I	L	Spanish Sign Language	\N
ssq	\N	\N	\N	I	L	So'a	\N
ssr	\N	\N	\N	I	L	Swiss-French Sign Language	\N
sss	\N	\N	\N	I	L	Sô	\N
sst	\N	\N	\N	I	L	Sinasina	\N
ssu	\N	\N	\N	I	L	Susuami	\N
ssv	\N	\N	\N	I	L	Shark Bay	\N
ssw	ssw	ssw	ss	I	L	Swati	\N
ssx	\N	\N	\N	I	L	Samberigi	\N
ssy	\N	\N	\N	I	L	Saho	\N
ssz	\N	\N	\N	I	L	Sengseng	\N
sta	\N	\N	\N	I	L	Settla	\N
stb	\N	\N	\N	I	L	Northern Subanen	\N
std	\N	\N	\N	I	L	Sentinel	\N
ste	\N	\N	\N	I	L	Liana-Seti	\N
stf	\N	\N	\N	I	L	Seta	\N
stg	\N	\N	\N	I	L	Trieng	\N
sth	\N	\N	\N	I	L	Shelta	\N
sti	\N	\N	\N	I	L	Bulo Stieng	\N
stj	\N	\N	\N	I	L	Matya Samo	\N
stk	\N	\N	\N	I	L	Arammba	\N
stl	\N	\N	\N	I	L	Stellingwerfs	\N
stm	\N	\N	\N	I	L	Setaman	\N
stn	\N	\N	\N	I	L	Owa	\N
sto	\N	\N	\N	I	L	Stoney	\N
stp	\N	\N	\N	I	L	Southeastern Tepehuan	\N
stq	\N	\N	\N	I	L	Saterfriesisch	\N
str	\N	\N	\N	I	L	Straits Salish	\N
sts	\N	\N	\N	I	L	Shumashti	\N
stt	\N	\N	\N	I	L	Budeh Stieng	\N
stu	\N	\N	\N	I	L	Samtao	\N
stv	\N	\N	\N	I	L	Silt'e	\N
stw	\N	\N	\N	I	L	Satawalese	\N
sty	\N	\N	\N	I	L	Siberian Tatar	\N
sua	\N	\N	\N	I	L	Sulka	\N
sub	\N	\N	\N	I	L	Suku	\N
suc	\N	\N	\N	I	L	Western Subanon	\N
sue	\N	\N	\N	I	L	Suena	\N
sug	\N	\N	\N	I	L	Suganga	\N
sui	\N	\N	\N	I	L	Suki	\N
suj	\N	\N	\N	I	L	Shubi	\N
suk	suk	suk	\N	I	L	Sukuma	\N
sun	sun	sun	su	I	L	Sundanese	\N
suo	\N	\N	\N	I	L	Bouni	\N
suq	\N	\N	\N	I	L	Tirmaga-Chai Suri	\N
sur	\N	\N	\N	I	L	Mwaghavul	\N
sus	sus	sus	\N	I	L	Susu	\N
sut	\N	\N	\N	I	E	Subtiaba	\N
suv	\N	\N	\N	I	L	Puroik	\N
suw	\N	\N	\N	I	L	Sumbwa	\N
sux	sux	sux	\N	I	H	Sumerian	\N
suy	\N	\N	\N	I	L	Suyá	\N
suz	\N	\N	\N	I	L	Sunwar	\N
sva	\N	\N	\N	I	L	Svan	\N
svb	\N	\N	\N	I	L	Ulau-Suain	\N
svc	\N	\N	\N	I	L	Vincentian Creole English	\N
sve	\N	\N	\N	I	L	Serili	\N
svk	\N	\N	\N	I	L	Slovakian Sign Language	\N
svm	\N	\N	\N	I	L	Slavomolisano	\N
svs	\N	\N	\N	I	L	Savosavo	\N
svx	\N	\N	\N	I	H	Skalvian	\N
swa	swa	swa	sw	M	L	Swahili (macrolanguage)	\N
swb	\N	\N	\N	I	L	Maore Comorian	\N
swc	\N	\N	\N	I	L	Congo Swahili	\N
swe	swe	swe	sv	I	L	Swedish	\N
swf	\N	\N	\N	I	L	Sere	\N
swg	\N	\N	\N	I	L	Swabian	\N
swh	\N	\N	\N	I	L	Swahili (individual language)	\N
swi	\N	\N	\N	I	L	Sui	\N
swj	\N	\N	\N	I	L	Sira	\N
swk	\N	\N	\N	I	L	Malawi Sena	\N
swl	\N	\N	\N	I	L	Swedish Sign Language	\N
swm	\N	\N	\N	I	L	Samosa	\N
swn	\N	\N	\N	I	L	Sawknah	\N
swo	\N	\N	\N	I	L	Shanenawa	\N
swp	\N	\N	\N	I	L	Suau	\N
swq	\N	\N	\N	I	L	Sharwa	\N
swr	\N	\N	\N	I	L	Saweru	\N
sws	\N	\N	\N	I	L	Seluwasan	\N
swt	\N	\N	\N	I	L	Sawila	\N
swu	\N	\N	\N	I	L	Suwawa	\N
swv	\N	\N	\N	I	L	Shekhawati	\N
sww	\N	\N	\N	I	E	Sowa	\N
swx	\N	\N	\N	I	L	Suruahá	\N
swy	\N	\N	\N	I	L	Sarua	\N
sxb	\N	\N	\N	I	L	Suba	\N
sxc	\N	\N	\N	I	H	Sicanian	\N
sxe	\N	\N	\N	I	L	Sighu	\N
sxg	\N	\N	\N	I	L	Shuhi	\N
sxk	\N	\N	\N	I	E	Southern Kalapuya	\N
sxl	\N	\N	\N	I	E	Selian	\N
sxm	\N	\N	\N	I	L	Samre	\N
sxn	\N	\N	\N	I	L	Sangir	\N
sxo	\N	\N	\N	I	H	Sorothaptic	\N
sxr	\N	\N	\N	I	L	Saaroa	\N
sxs	\N	\N	\N	I	L	Sasaru	\N
sxu	\N	\N	\N	I	L	Upper Saxon	\N
sxw	\N	\N	\N	I	L	Saxwe Gbe	\N
sya	\N	\N	\N	I	L	Siang	\N
syb	\N	\N	\N	I	L	Central Subanen	\N
syc	syc	syc	\N	I	H	Classical Syriac	\N
syi	\N	\N	\N	I	L	Seki	\N
syk	\N	\N	\N	I	L	Sukur	\N
syl	\N	\N	\N	I	L	Sylheti	\N
sym	\N	\N	\N	I	L	Maya Samo	\N
syn	\N	\N	\N	I	L	Senaya	\N
syo	\N	\N	\N	I	L	Suoy	\N
syr	syr	syr	\N	M	L	Syriac	\N
sys	\N	\N	\N	I	L	Sinyar	\N
syw	\N	\N	\N	I	L	Kagate	\N
syx	\N	\N	\N	I	L	Samay	\N
syy	\N	\N	\N	I	L	Al-Sayyid Bedouin Sign Language	\N
sza	\N	\N	\N	I	L	Semelai	\N
szb	\N	\N	\N	I	L	Ngalum	\N
szc	\N	\N	\N	I	L	Semaq Beri	\N
sze	\N	\N	\N	I	L	Seze	\N
szg	\N	\N	\N	I	L	Sengele	\N
szl	\N	\N	\N	I	L	Silesian	\N
szn	\N	\N	\N	I	L	Sula	\N
szp	\N	\N	\N	I	L	Suabo	\N
szs	\N	\N	\N	I	L	Solomon Islands Sign Language	\N
szv	\N	\N	\N	I	L	Isu (Fako Division)	\N
szw	\N	\N	\N	I	L	Sawai	\N
szy	\N	\N	\N	I	L	Sakizaya	\N
taa	\N	\N	\N	I	L	Lower Tanana	\N
tab	\N	\N	\N	I	L	Tabassaran	\N
tac	\N	\N	\N	I	L	Lowland Tarahumara	\N
tad	\N	\N	\N	I	L	Tause	\N
tae	\N	\N	\N	I	L	Tariana	\N
taf	\N	\N	\N	I	L	Tapirapé	\N
tag	\N	\N	\N	I	L	Tagoi	\N
tah	tah	tah	ty	I	L	Tahitian	\N
taj	\N	\N	\N	I	L	Eastern Tamang	\N
tak	\N	\N	\N	I	L	Tala	\N
tal	\N	\N	\N	I	L	Tal	\N
tam	tam	tam	ta	I	L	Tamil	\N
tan	\N	\N	\N	I	L	Tangale	\N
tao	\N	\N	\N	I	L	Yami	\N
tap	\N	\N	\N	I	L	Taabwa	\N
taq	\N	\N	\N	I	L	Tamasheq	\N
tar	\N	\N	\N	I	L	Central Tarahumara	\N
tas	\N	\N	\N	I	E	Tay Boi	\N
tat	tat	tat	tt	I	L	Tatar	\N
tau	\N	\N	\N	I	L	Upper Tanana	\N
tav	\N	\N	\N	I	L	Tatuyo	\N
taw	\N	\N	\N	I	L	Tai	\N
tax	\N	\N	\N	I	L	Tamki	\N
tay	\N	\N	\N	I	L	Atayal	\N
taz	\N	\N	\N	I	L	Tocho	\N
tba	\N	\N	\N	I	L	Aikanã	\N
tbc	\N	\N	\N	I	L	Takia	\N
tbd	\N	\N	\N	I	L	Kaki Ae	\N
tbe	\N	\N	\N	I	L	Tanimbili	\N
tbf	\N	\N	\N	I	L	Mandara	\N
tbg	\N	\N	\N	I	L	North Tairora	\N
tbh	\N	\N	\N	I	E	Dharawal	\N
tbi	\N	\N	\N	I	L	Gaam	\N
tbj	\N	\N	\N	I	L	Tiang	\N
tbk	\N	\N	\N	I	L	Calamian Tagbanwa	\N
tbl	\N	\N	\N	I	L	Tboli	\N
tbm	\N	\N	\N	I	L	Tagbu	\N
tbn	\N	\N	\N	I	L	Barro Negro Tunebo	\N
tbo	\N	\N	\N	I	L	Tawala	\N
tbp	\N	\N	\N	I	L	Taworta	\N
tbr	\N	\N	\N	I	L	Tumtum	\N
tbs	\N	\N	\N	I	L	Tanguat	\N
tbt	\N	\N	\N	I	L	Tembo (Kitembo)	\N
tbu	\N	\N	\N	I	E	Tubar	\N
tbv	\N	\N	\N	I	L	Tobo	\N
tbw	\N	\N	\N	I	L	Tagbanwa	\N
tbx	\N	\N	\N	I	L	Kapin	\N
tby	\N	\N	\N	I	L	Tabaru	\N
tbz	\N	\N	\N	I	L	Ditammari	\N
tca	\N	\N	\N	I	L	Ticuna	\N
tcb	\N	\N	\N	I	L	Tanacross	\N
tcc	\N	\N	\N	I	L	Datooga	\N
tcd	\N	\N	\N	I	L	Tafi	\N
tce	\N	\N	\N	I	L	Southern Tutchone	\N
tcf	\N	\N	\N	I	L	Malinaltepec Me'phaa	\N
tcg	\N	\N	\N	I	L	Tamagario	\N
tch	\N	\N	\N	I	L	Turks And Caicos Creole English	\N
tci	\N	\N	\N	I	L	Wára	\N
tck	\N	\N	\N	I	L	Tchitchege	\N
tcl	\N	\N	\N	I	E	Taman (Myanmar)	\N
tcm	\N	\N	\N	I	L	Tanahmerah	\N
tcn	\N	\N	\N	I	L	Tichurong	\N
tco	\N	\N	\N	I	L	Taungyo	\N
tcp	\N	\N	\N	I	L	Tawr Chin	\N
tcq	\N	\N	\N	I	L	Kaiy	\N
tcs	\N	\N	\N	I	L	Torres Strait Creole	\N
tct	\N	\N	\N	I	L	T'en	\N
tcu	\N	\N	\N	I	L	Southeastern Tarahumara	\N
tcw	\N	\N	\N	I	L	Tecpatlán Totonac	\N
tcx	\N	\N	\N	I	L	Toda	\N
tcy	\N	\N	\N	I	L	Tulu	\N
tcz	\N	\N	\N	I	L	Thado Chin	\N
tda	\N	\N	\N	I	L	Tagdal	\N
tdb	\N	\N	\N	I	L	Panchpargania	\N
tdc	\N	\N	\N	I	L	Emberá-Tadó	\N
tdd	\N	\N	\N	I	L	Tai Nüa	\N
tde	\N	\N	\N	I	L	Tiranige Diga Dogon	\N
tdf	\N	\N	\N	I	L	Talieng	\N
tdg	\N	\N	\N	I	L	Western Tamang	\N
tdh	\N	\N	\N	I	L	Thulung	\N
tdi	\N	\N	\N	I	L	Tomadino	\N
tdj	\N	\N	\N	I	L	Tajio	\N
tdk	\N	\N	\N	I	L	Tambas	\N
tdl	\N	\N	\N	I	L	Sur	\N
tdm	\N	\N	\N	I	L	Taruma	\N
tdn	\N	\N	\N	I	L	Tondano	\N
tdo	\N	\N	\N	I	L	Teme	\N
tdq	\N	\N	\N	I	L	Tita	\N
tdr	\N	\N	\N	I	L	Todrah	\N
tds	\N	\N	\N	I	L	Doutai	\N
tdt	\N	\N	\N	I	L	Tetun Dili	\N
tdv	\N	\N	\N	I	L	Toro	\N
tdx	\N	\N	\N	I	L	Tandroy-Mahafaly Malagasy	\N
tdy	\N	\N	\N	I	L	Tadyawan	\N
tea	\N	\N	\N	I	L	Temiar	\N
teb	\N	\N	\N	I	E	Tetete	\N
tec	\N	\N	\N	I	L	Terik	\N
ted	\N	\N	\N	I	L	Tepo Krumen	\N
tee	\N	\N	\N	I	L	Huehuetla Tepehua	\N
tef	\N	\N	\N	I	L	Teressa	\N
teg	\N	\N	\N	I	L	Teke-Tege	\N
teh	\N	\N	\N	I	L	Tehuelche	\N
tei	\N	\N	\N	I	L	Torricelli	\N
tek	\N	\N	\N	I	L	Ibali Teke	\N
tel	tel	tel	te	I	L	Telugu	\N
tem	tem	tem	\N	I	L	Timne	\N
ten	\N	\N	\N	I	E	Tama (Colombia)	\N
teo	\N	\N	\N	I	L	Teso	\N
tep	\N	\N	\N	I	E	Tepecano	\N
teq	\N	\N	\N	I	L	Temein	\N
ter	ter	ter	\N	I	L	Tereno	\N
tes	\N	\N	\N	I	L	Tengger	\N
tet	tet	tet	\N	I	L	Tetum	\N
teu	\N	\N	\N	I	L	Soo	\N
tev	\N	\N	\N	I	L	Teor	\N
tew	\N	\N	\N	I	L	Tewa (USA)	\N
tex	\N	\N	\N	I	L	Tennet	\N
tey	\N	\N	\N	I	L	Tulishi	\N
tez	\N	\N	\N	I	L	Tetserret	\N
tfi	\N	\N	\N	I	L	Tofin Gbe	\N
tfn	\N	\N	\N	I	L	Tanaina	\N
tfo	\N	\N	\N	I	L	Tefaro	\N
tfr	\N	\N	\N	I	L	Teribe	\N
tft	\N	\N	\N	I	L	Ternate	\N
tga	\N	\N	\N	I	L	Sagalla	\N
tgb	\N	\N	\N	I	L	Tobilung	\N
tgc	\N	\N	\N	I	L	Tigak	\N
tgd	\N	\N	\N	I	L	Ciwogai	\N
tge	\N	\N	\N	I	L	Eastern Gorkha Tamang	\N
tgf	\N	\N	\N	I	L	Chalikha	\N
tgh	\N	\N	\N	I	L	Tobagonian Creole English	\N
tgi	\N	\N	\N	I	L	Lawunuia	\N
tgj	\N	\N	\N	I	L	Tagin	\N
tgk	tgk	tgk	tg	I	L	Tajik	\N
tgl	tgl	tgl	tl	I	L	Tagalog	\N
tgn	\N	\N	\N	I	L	Tandaganon	\N
tgo	\N	\N	\N	I	L	Sudest	\N
tgp	\N	\N	\N	I	L	Tangoa	\N
tgq	\N	\N	\N	I	L	Tring	\N
tgr	\N	\N	\N	I	L	Tareng	\N
tgs	\N	\N	\N	I	L	Nume	\N
tgt	\N	\N	\N	I	L	Central Tagbanwa	\N
tgu	\N	\N	\N	I	L	Tanggu	\N
tgv	\N	\N	\N	I	E	Tingui-Boto	\N
tgw	\N	\N	\N	I	L	Tagwana Senoufo	\N
tgx	\N	\N	\N	I	L	Tagish	\N
tgy	\N	\N	\N	I	E	Togoyo	\N
tgz	\N	\N	\N	I	E	Tagalaka	\N
tha	tha	tha	th	I	L	Thai	\N
thd	\N	\N	\N	I	L	Kuuk Thaayorre	\N
the	\N	\N	\N	I	L	Chitwania Tharu	\N
thf	\N	\N	\N	I	L	Thangmi	\N
thh	\N	\N	\N	I	L	Northern Tarahumara	\N
thi	\N	\N	\N	I	L	Tai Long	\N
thk	\N	\N	\N	I	L	Tharaka	\N
thl	\N	\N	\N	I	L	Dangaura Tharu	\N
thm	\N	\N	\N	I	L	Aheu	\N
thn	\N	\N	\N	I	L	Thachanadan	\N
thp	\N	\N	\N	I	L	Thompson	\N
thq	\N	\N	\N	I	L	Kochila Tharu	\N
thr	\N	\N	\N	I	L	Rana Tharu	\N
ths	\N	\N	\N	I	L	Thakali	\N
tht	\N	\N	\N	I	L	Tahltan	\N
thu	\N	\N	\N	I	L	Thuri	\N
thv	\N	\N	\N	I	L	Tahaggart Tamahaq	\N
thy	\N	\N	\N	I	L	Tha	\N
thz	\N	\N	\N	I	L	Tayart Tamajeq	\N
tia	\N	\N	\N	I	L	Tidikelt Tamazight	\N
tic	\N	\N	\N	I	L	Tira	\N
tif	\N	\N	\N	I	L	Tifal	\N
tig	tig	tig	\N	I	L	Tigre	\N
tih	\N	\N	\N	I	L	Timugon Murut	\N
tii	\N	\N	\N	I	L	Tiene	\N
tij	\N	\N	\N	I	L	Tilung	\N
tik	\N	\N	\N	I	L	Tikar	\N
til	\N	\N	\N	I	E	Tillamook	\N
tim	\N	\N	\N	I	L	Timbe	\N
tin	\N	\N	\N	I	L	Tindi	\N
tio	\N	\N	\N	I	L	Teop	\N
tip	\N	\N	\N	I	L	Trimuris	\N
tiq	\N	\N	\N	I	L	Tiéfo	\N
tir	tir	tir	ti	I	L	Tigrinya	\N
tis	\N	\N	\N	I	L	Masadiit Itneg	\N
tit	\N	\N	\N	I	L	Tinigua	\N
tiu	\N	\N	\N	I	L	Adasen	\N
tiv	tiv	tiv	\N	I	L	Tiv	\N
tiw	\N	\N	\N	I	L	Tiwi	\N
tix	\N	\N	\N	I	L	Southern Tiwa	\N
tiy	\N	\N	\N	I	L	Tiruray	\N
tiz	\N	\N	\N	I	L	Tai Hongjin	\N
tja	\N	\N	\N	I	L	Tajuasohn	\N
tjg	\N	\N	\N	I	L	Tunjung	\N
tji	\N	\N	\N	I	L	Northern Tujia	\N
tjj	\N	\N	\N	I	L	Tjungundji	\N
tjl	\N	\N	\N	I	L	Tai Laing	\N
tjm	\N	\N	\N	I	E	Timucua	\N
tjn	\N	\N	\N	I	E	Tonjon	\N
tjo	\N	\N	\N	I	L	Temacine Tamazight	\N
tjp	\N	\N	\N	I	L	Tjupany	\N
tjs	\N	\N	\N	I	L	Southern Tujia	\N
tju	\N	\N	\N	I	E	Tjurruru	\N
tjw	\N	\N	\N	I	L	Djabwurrung	\N
tka	\N	\N	\N	I	E	Truká	\N
tkb	\N	\N	\N	I	L	Buksa	\N
tkd	\N	\N	\N	I	L	Tukudede	\N
tke	\N	\N	\N	I	L	Takwane	\N
tkf	\N	\N	\N	I	E	Tukumanféd	\N
tkg	\N	\N	\N	I	L	Tesaka Malagasy	\N
tkl	tkl	tkl	\N	I	L	Tokelau	\N
tkm	\N	\N	\N	I	E	Takelma	\N
tkn	\N	\N	\N	I	L	Toku-No-Shima	\N
tkp	\N	\N	\N	I	L	Tikopia	\N
tkq	\N	\N	\N	I	L	Tee	\N
tkr	\N	\N	\N	I	L	Tsakhur	\N
tks	\N	\N	\N	I	L	Takestani	\N
tkt	\N	\N	\N	I	L	Kathoriya Tharu	\N
tku	\N	\N	\N	I	L	Upper Necaxa Totonac	\N
tkv	\N	\N	\N	I	L	Mur Pano	\N
tkw	\N	\N	\N	I	L	Teanu	\N
tkx	\N	\N	\N	I	L	Tangko	\N
tkz	\N	\N	\N	I	L	Takua	\N
tla	\N	\N	\N	I	L	Southwestern Tepehuan	\N
tlb	\N	\N	\N	I	L	Tobelo	\N
tlc	\N	\N	\N	I	L	Yecuatla Totonac	\N
tld	\N	\N	\N	I	L	Talaud	\N
tlf	\N	\N	\N	I	L	Telefol	\N
tlg	\N	\N	\N	I	L	Tofanma	\N
tlh	tlh	tlh	\N	I	C	Klingon	\N
tli	tli	tli	\N	I	L	Tlingit	\N
tlj	\N	\N	\N	I	L	Talinga-Bwisi	\N
tlk	\N	\N	\N	I	L	Taloki	\N
tll	\N	\N	\N	I	L	Tetela	\N
tlm	\N	\N	\N	I	L	Tolomako	\N
tln	\N	\N	\N	I	L	Talondo'	\N
tlo	\N	\N	\N	I	L	Talodi	\N
tlp	\N	\N	\N	I	L	Filomena Mata-Coahuitlán Totonac	\N
tlq	\N	\N	\N	I	L	Tai Loi	\N
tlr	\N	\N	\N	I	L	Talise	\N
tls	\N	\N	\N	I	L	Tambotalo	\N
tlt	\N	\N	\N	I	L	Sou Nama	\N
tlu	\N	\N	\N	I	L	Tulehu	\N
tlv	\N	\N	\N	I	L	Taliabu	\N
tlx	\N	\N	\N	I	L	Khehek	\N
tly	\N	\N	\N	I	L	Talysh	\N
tma	\N	\N	\N	I	L	Tama (Chad)	\N
tmb	\N	\N	\N	I	L	Katbol	\N
tmc	\N	\N	\N	I	L	Tumak	\N
tmd	\N	\N	\N	I	L	Haruai	\N
tme	\N	\N	\N	I	E	Tremembé	\N
tmf	\N	\N	\N	I	L	Toba-Maskoy	\N
tmg	\N	\N	\N	I	E	Ternateño	\N
tmh	tmh	tmh	\N	M	L	Tamashek	\N
tmi	\N	\N	\N	I	L	Tutuba	\N
tmj	\N	\N	\N	I	L	Samarokena	\N
tml	\N	\N	\N	I	L	Tamnim Citak	\N
tmm	\N	\N	\N	I	L	Tai Thanh	\N
tmn	\N	\N	\N	I	L	Taman (Indonesia)	\N
tmo	\N	\N	\N	I	L	Temoq	\N
tmq	\N	\N	\N	I	L	Tumleo	\N
tmr	\N	\N	\N	I	E	Jewish Babylonian Aramaic (ca. 200-1200 CE)	\N
tms	\N	\N	\N	I	L	Tima	\N
tmt	\N	\N	\N	I	L	Tasmate	\N
tmu	\N	\N	\N	I	L	Iau	\N
tmv	\N	\N	\N	I	L	Tembo (Motembo)	\N
tmw	\N	\N	\N	I	L	Temuan	\N
tmy	\N	\N	\N	I	L	Tami	\N
tmz	\N	\N	\N	I	E	Tamanaku	\N
tna	\N	\N	\N	I	L	Tacana	\N
tnb	\N	\N	\N	I	L	Western Tunebo	\N
tnc	\N	\N	\N	I	L	Tanimuca-Retuarã	\N
tnd	\N	\N	\N	I	L	Angosturas Tunebo	\N
tng	\N	\N	\N	I	L	Tobanga	\N
tnh	\N	\N	\N	I	L	Maiani	\N
tni	\N	\N	\N	I	L	Tandia	\N
tnk	\N	\N	\N	I	L	Kwamera	\N
tnl	\N	\N	\N	I	L	Lenakel	\N
tnm	\N	\N	\N	I	L	Tabla	\N
tnn	\N	\N	\N	I	L	North Tanna	\N
tno	\N	\N	\N	I	L	Toromono	\N
tnp	\N	\N	\N	I	L	Whitesands	\N
tnq	\N	\N	\N	I	E	Taino	\N
tnr	\N	\N	\N	I	L	Ménik	\N
tns	\N	\N	\N	I	L	Tenis	\N
tnt	\N	\N	\N	I	L	Tontemboan	\N
tnu	\N	\N	\N	I	L	Tay Khang	\N
tnv	\N	\N	\N	I	L	Tangchangya	\N
tnw	\N	\N	\N	I	L	Tonsawang	\N
tnx	\N	\N	\N	I	L	Tanema	\N
tny	\N	\N	\N	I	L	Tongwe	\N
tnz	\N	\N	\N	I	L	Ten'edn	\N
tob	\N	\N	\N	I	L	Toba	\N
toc	\N	\N	\N	I	L	Coyutla Totonac	\N
tod	\N	\N	\N	I	L	Toma	\N
tof	\N	\N	\N	I	L	Gizrra	\N
tog	tog	tog	\N	I	L	Tonga (Nyasa)	\N
toh	\N	\N	\N	I	L	Gitonga	\N
toi	\N	\N	\N	I	L	Tonga (Zambia)	\N
toj	\N	\N	\N	I	L	Tojolabal	\N
tok	\N	\N	\N	I	C	Toki Pona	\N
tol	\N	\N	\N	I	E	Tolowa	\N
tom	\N	\N	\N	I	L	Tombulu	\N
ton	ton	ton	to	I	L	Tonga (Tonga Islands)	\N
too	\N	\N	\N	I	L	Xicotepec De Juárez Totonac	\N
top	\N	\N	\N	I	L	Papantla Totonac	\N
toq	\N	\N	\N	I	L	Toposa	\N
tor	\N	\N	\N	I	L	Togbo-Vara Banda	\N
tos	\N	\N	\N	I	L	Highland Totonac	\N
tou	\N	\N	\N	I	L	Tho	\N
tov	\N	\N	\N	I	L	Upper Taromi	\N
tow	\N	\N	\N	I	L	Jemez	\N
tox	\N	\N	\N	I	L	Tobian	\N
toy	\N	\N	\N	I	L	Topoiyo	\N
toz	\N	\N	\N	I	L	To	\N
tpa	\N	\N	\N	I	L	Taupota	\N
tpc	\N	\N	\N	I	L	Azoyú Me'phaa	\N
tpe	\N	\N	\N	I	L	Tippera	\N
tpf	\N	\N	\N	I	L	Tarpia	\N
tpg	\N	\N	\N	I	L	Kula	\N
tpi	tpi	tpi	\N	I	L	Tok Pisin	\N
tpj	\N	\N	\N	I	L	Tapieté	\N
tpk	\N	\N	\N	I	E	Tupinikin	\N
tpl	\N	\N	\N	I	L	Tlacoapa Me'phaa	\N
tpm	\N	\N	\N	I	L	Tampulma	\N
tpn	\N	\N	\N	I	E	Tupinambá	\N
tpo	\N	\N	\N	I	L	Tai Pao	\N
tpp	\N	\N	\N	I	L	Pisaflores Tepehua	\N
tpq	\N	\N	\N	I	L	Tukpa	\N
tpr	\N	\N	\N	I	L	Tuparí	\N
tpt	\N	\N	\N	I	L	Tlachichilco Tepehua	\N
tpu	\N	\N	\N	I	L	Tampuan	\N
tpv	\N	\N	\N	I	L	Tanapag	\N
tpx	\N	\N	\N	I	L	Acatepec Me'phaa	\N
tpy	\N	\N	\N	I	L	Trumai	\N
tpz	\N	\N	\N	I	L	Tinputz	\N
tqb	\N	\N	\N	I	L	Tembé	\N
tql	\N	\N	\N	I	L	Lehali	\N
tqm	\N	\N	\N	I	L	Turumsa	\N
tqn	\N	\N	\N	I	L	Tenino	\N
tqo	\N	\N	\N	I	L	Toaripi	\N
tqp	\N	\N	\N	I	L	Tomoip	\N
tqq	\N	\N	\N	I	L	Tunni	\N
tqr	\N	\N	\N	I	E	Torona	\N
tqt	\N	\N	\N	I	L	Western Totonac	\N
tqu	\N	\N	\N	I	L	Touo	\N
tqw	\N	\N	\N	I	E	Tonkawa	\N
tra	\N	\N	\N	I	L	Tirahi	\N
trb	\N	\N	\N	I	L	Terebu	\N
trc	\N	\N	\N	I	L	Copala Triqui	\N
trd	\N	\N	\N	I	L	Turi	\N
tre	\N	\N	\N	I	L	East Tarangan	\N
trf	\N	\N	\N	I	L	Trinidadian Creole English	\N
trg	\N	\N	\N	I	L	Lishán Didán	\N
trh	\N	\N	\N	I	L	Turaka	\N
tri	\N	\N	\N	I	L	Trió	\N
trj	\N	\N	\N	I	L	Toram	\N
trl	\N	\N	\N	I	L	Traveller Scottish	\N
trm	\N	\N	\N	I	L	Tregami	\N
trn	\N	\N	\N	I	L	Trinitario	\N
tro	\N	\N	\N	I	L	Tarao Naga	\N
trp	\N	\N	\N	I	L	Kok Borok	\N
trq	\N	\N	\N	I	L	San Martín Itunyoso Triqui	\N
trr	\N	\N	\N	I	L	Taushiro	\N
trs	\N	\N	\N	I	L	Chicahuaxtla Triqui	\N
trt	\N	\N	\N	I	L	Tunggare	\N
tru	\N	\N	\N	I	L	Turoyo	\N
trv	\N	\N	\N	I	L	Sediq	\N
trw	\N	\N	\N	I	L	Torwali	\N
trx	\N	\N	\N	I	L	Tringgus-Sembaan Bidayuh	\N
try	\N	\N	\N	I	E	Turung	\N
trz	\N	\N	\N	I	E	Torá	\N
tsa	\N	\N	\N	I	L	Tsaangi	\N
tsb	\N	\N	\N	I	L	Tsamai	\N
tsc	\N	\N	\N	I	L	Tswa	\N
tsd	\N	\N	\N	I	L	Tsakonian	\N
tse	\N	\N	\N	I	L	Tunisian Sign Language	\N
tsg	\N	\N	\N	I	L	Tausug	\N
tsh	\N	\N	\N	I	L	Tsuvan	\N
tsi	tsi	tsi	\N	I	L	Tsimshian	\N
tsj	\N	\N	\N	I	L	Tshangla	\N
tsk	\N	\N	\N	I	L	Tseku	\N
tsl	\N	\N	\N	I	L	Ts'ün-Lao	\N
tsm	\N	\N	\N	I	L	Turkish Sign Language	\N
tsn	tsn	tsn	tn	I	L	Tswana	\N
tso	tso	tso	ts	I	L	Tsonga	\N
tsp	\N	\N	\N	I	L	Northern Toussian	\N
tsq	\N	\N	\N	I	L	Thai Sign Language	\N
tsr	\N	\N	\N	I	L	Akei	\N
tss	\N	\N	\N	I	L	Taiwan Sign Language	\N
tst	\N	\N	\N	I	L	Tondi Songway Kiini	\N
tsu	\N	\N	\N	I	L	Tsou	\N
tsv	\N	\N	\N	I	L	Tsogo	\N
tsw	\N	\N	\N	I	L	Tsishingini	\N
tsx	\N	\N	\N	I	L	Mubami	\N
tsy	\N	\N	\N	I	L	Tebul Sign Language	\N
tsz	\N	\N	\N	I	L	Purepecha	\N
tta	\N	\N	\N	I	E	Tutelo	\N
ttb	\N	\N	\N	I	L	Gaa	\N
ttc	\N	\N	\N	I	L	Tektiteko	\N
ttd	\N	\N	\N	I	L	Tauade	\N
tte	\N	\N	\N	I	L	Bwanabwana	\N
ttf	\N	\N	\N	I	L	Tuotomb	\N
ttg	\N	\N	\N	I	L	Tutong	\N
tth	\N	\N	\N	I	L	Upper Ta'oih	\N
tti	\N	\N	\N	I	L	Tobati	\N
ttj	\N	\N	\N	I	L	Tooro	\N
ttk	\N	\N	\N	I	L	Totoro	\N
ttl	\N	\N	\N	I	L	Totela	\N
ttm	\N	\N	\N	I	L	Northern Tutchone	\N
ttn	\N	\N	\N	I	L	Towei	\N
tto	\N	\N	\N	I	L	Lower Ta'oih	\N
ttp	\N	\N	\N	I	L	Tombelala	\N
ttq	\N	\N	\N	I	L	Tawallammat Tamajaq	\N
ttr	\N	\N	\N	I	L	Tera	\N
tts	\N	\N	\N	I	L	Northeastern Thai	\N
ttt	\N	\N	\N	I	L	Muslim Tat	\N
ttu	\N	\N	\N	I	L	Torau	\N
ttv	\N	\N	\N	I	L	Titan	\N
ttw	\N	\N	\N	I	L	Long Wat	\N
tty	\N	\N	\N	I	L	Sikaritai	\N
ttz	\N	\N	\N	I	L	Tsum	\N
tua	\N	\N	\N	I	L	Wiarumus	\N
tub	\N	\N	\N	I	E	Tübatulabal	\N
tuc	\N	\N	\N	I	L	Mutu	\N
tud	\N	\N	\N	I	E	Tuxá	\N
tue	\N	\N	\N	I	L	Tuyuca	\N
tuf	\N	\N	\N	I	L	Central Tunebo	\N
tug	\N	\N	\N	I	L	Tunia	\N
tuh	\N	\N	\N	I	L	Taulil	\N
tui	\N	\N	\N	I	L	Tupuri	\N
tuj	\N	\N	\N	I	L	Tugutil	\N
tuk	tuk	tuk	tk	I	L	Turkmen	\N
tul	\N	\N	\N	I	L	Tula	\N
tum	tum	tum	\N	I	L	Tumbuka	\N
tun	\N	\N	\N	I	L	Tunica	\N
tuo	\N	\N	\N	I	L	Tucano	\N
tuq	\N	\N	\N	I	L	Tedaga	\N
tur	tur	tur	tr	I	L	Turkish	\N
tus	\N	\N	\N	I	L	Tuscarora	\N
tuu	\N	\N	\N	I	L	Tututni	\N
tuv	\N	\N	\N	I	L	Turkana	\N
tux	\N	\N	\N	I	E	Tuxináwa	\N
tuy	\N	\N	\N	I	L	Tugen	\N
tuz	\N	\N	\N	I	L	Turka	\N
tva	\N	\N	\N	I	L	Vaghua	\N
tvd	\N	\N	\N	I	L	Tsuvadi	\N
tve	\N	\N	\N	I	L	Te'un	\N
tvi	\N	\N	\N	I	L	Tulai	\N
tvk	\N	\N	\N	I	L	Southeast Ambrym	\N
tvl	tvl	tvl	\N	I	L	Tuvalu	\N
tvm	\N	\N	\N	I	L	Tela-Masbuar	\N
tvn	\N	\N	\N	I	L	Tavoyan	\N
tvo	\N	\N	\N	I	L	Tidore	\N
tvs	\N	\N	\N	I	L	Taveta	\N
tvt	\N	\N	\N	I	L	Tutsa Naga	\N
tvu	\N	\N	\N	I	L	Tunen	\N
tvw	\N	\N	\N	I	L	Sedoa	\N
tvx	\N	\N	\N	I	E	Taivoan	\N
tvy	\N	\N	\N	I	E	Timor Pidgin	\N
twa	\N	\N	\N	I	E	Twana	\N
twb	\N	\N	\N	I	L	Western Tawbuid	\N
twc	\N	\N	\N	I	E	Teshenawa	\N
twd	\N	\N	\N	I	L	Twents	\N
twe	\N	\N	\N	I	L	Tewa (Indonesia)	\N
twf	\N	\N	\N	I	L	Northern Tiwa	\N
twg	\N	\N	\N	I	L	Tereweng	\N
twh	\N	\N	\N	I	L	Tai Dón	\N
twi	twi	twi	tw	I	L	Twi	\N
twl	\N	\N	\N	I	L	Tawara	\N
twm	\N	\N	\N	I	L	Tawang Monpa	\N
twn	\N	\N	\N	I	L	Twendi	\N
two	\N	\N	\N	I	L	Tswapong	\N
twp	\N	\N	\N	I	L	Ere	\N
twq	\N	\N	\N	I	L	Tasawaq	\N
twr	\N	\N	\N	I	L	Southwestern Tarahumara	\N
twt	\N	\N	\N	I	E	Turiwára	\N
twu	\N	\N	\N	I	L	Termanu	\N
tww	\N	\N	\N	I	L	Tuwari	\N
twx	\N	\N	\N	I	L	Tewe	\N
twy	\N	\N	\N	I	L	Tawoyan	\N
txa	\N	\N	\N	I	L	Tombonuo	\N
txb	\N	\N	\N	I	H	Tokharian B	\N
txc	\N	\N	\N	I	E	Tsetsaut	\N
txe	\N	\N	\N	I	L	Totoli	\N
txg	\N	\N	\N	I	H	Tangut	\N
txh	\N	\N	\N	I	H	Thracian	\N
txi	\N	\N	\N	I	L	Ikpeng	\N
txj	\N	\N	\N	I	L	Tarjumo	\N
txm	\N	\N	\N	I	L	Tomini	\N
txn	\N	\N	\N	I	L	West Tarangan	\N
txo	\N	\N	\N	I	L	Toto	\N
txq	\N	\N	\N	I	L	Tii	\N
txr	\N	\N	\N	I	H	Tartessian	\N
txs	\N	\N	\N	I	L	Tonsea	\N
txt	\N	\N	\N	I	L	Citak	\N
txu	\N	\N	\N	I	L	Kayapó	\N
txx	\N	\N	\N	I	L	Tatana	\N
txy	\N	\N	\N	I	L	Tanosy Malagasy	\N
tya	\N	\N	\N	I	L	Tauya	\N
tye	\N	\N	\N	I	L	Kyanga	\N
tyh	\N	\N	\N	I	L	O'du	\N
tyi	\N	\N	\N	I	L	Teke-Tsaayi	\N
tyj	\N	\N	\N	I	L	Tai Do	\N
tyl	\N	\N	\N	I	L	Thu Lao	\N
tyn	\N	\N	\N	I	L	Kombai	\N
typ	\N	\N	\N	I	E	Thaypan	\N
tyr	\N	\N	\N	I	L	Tai Daeng	\N
tys	\N	\N	\N	I	L	Tày Sa Pa	\N
tyt	\N	\N	\N	I	L	Tày Tac	\N
tyu	\N	\N	\N	I	L	Kua	\N
tyv	tyv	tyv	\N	I	L	Tuvinian	\N
tyx	\N	\N	\N	I	L	Teke-Tyee	\N
tyy	\N	\N	\N	I	L	Tiyaa	\N
tyz	\N	\N	\N	I	L	Tày	\N
tza	\N	\N	\N	I	L	Tanzanian Sign Language	\N
tzh	\N	\N	\N	I	L	Tzeltal	\N
tzj	\N	\N	\N	I	L	Tz'utujil	\N
tzl	\N	\N	\N	I	C	Talossan	\N
tzm	\N	\N	\N	I	L	Central Atlas Tamazight	\N
tzn	\N	\N	\N	I	L	Tugun	\N
tzo	\N	\N	\N	I	L	Tzotzil	\N
tzx	\N	\N	\N	I	L	Tabriak	\N
uam	\N	\N	\N	I	E	Uamué	\N
uan	\N	\N	\N	I	L	Kuan	\N
uar	\N	\N	\N	I	L	Tairuma	\N
uba	\N	\N	\N	I	L	Ubang	\N
ubi	\N	\N	\N	I	L	Ubi	\N
ubl	\N	\N	\N	I	L	Buhi'non Bikol	\N
ubr	\N	\N	\N	I	L	Ubir	\N
ubu	\N	\N	\N	I	L	Umbu-Ungu	\N
uby	\N	\N	\N	I	E	Ubykh	\N
uda	\N	\N	\N	I	L	Uda	\N
ude	\N	\N	\N	I	L	Udihe	\N
udg	\N	\N	\N	I	L	Muduga	\N
udi	\N	\N	\N	I	L	Udi	\N
udj	\N	\N	\N	I	L	Ujir	\N
udl	\N	\N	\N	I	L	Wuzlam	\N
udm	udm	udm	\N	I	L	Udmurt	\N
udu	\N	\N	\N	I	L	Uduk	\N
ues	\N	\N	\N	I	L	Kioko	\N
ufi	\N	\N	\N	I	L	Ufim	\N
uga	uga	uga	\N	I	H	Ugaritic	\N
ugb	\N	\N	\N	I	E	Kuku-Ugbanh	\N
uge	\N	\N	\N	I	L	Ughele	\N
ugh	\N	\N	\N	I	L	Kubachi	\N
ugn	\N	\N	\N	I	L	Ugandan Sign Language	\N
ugo	\N	\N	\N	I	L	Ugong	\N
ugy	\N	\N	\N	I	L	Uruguayan Sign Language	\N
uha	\N	\N	\N	I	L	Uhami	\N
uhn	\N	\N	\N	I	L	Damal	\N
uig	uig	uig	ug	I	L	Uighur	\N
uis	\N	\N	\N	I	L	Uisai	\N
uiv	\N	\N	\N	I	L	Iyive	\N
uji	\N	\N	\N	I	L	Tanjijili	\N
uka	\N	\N	\N	I	L	Kaburi	\N
ukg	\N	\N	\N	I	L	Ukuriguma	\N
ukh	\N	\N	\N	I	L	Ukhwejo	\N
uki	\N	\N	\N	I	L	Kui (India)	\N
ukk	\N	\N	\N	I	L	Muak Sa-aak	\N
ukl	\N	\N	\N	I	L	Ukrainian Sign Language	\N
ukp	\N	\N	\N	I	L	Ukpe-Bayobiri	\N
ukq	\N	\N	\N	I	L	Ukwa	\N
ukr	ukr	ukr	uk	I	L	Ukrainian	\N
uks	\N	\N	\N	I	L	Urubú-Kaapor Sign Language	\N
uku	\N	\N	\N	I	L	Ukue	\N
ukv	\N	\N	\N	I	L	Kuku	\N
ukw	\N	\N	\N	I	L	Ukwuani-Aboh-Ndoni	\N
uky	\N	\N	\N	I	E	Kuuk-Yak	\N
ula	\N	\N	\N	I	L	Fungwa	\N
ulb	\N	\N	\N	I	L	Ulukwumi	\N
ulc	\N	\N	\N	I	L	Ulch	\N
ule	\N	\N	\N	I	E	Lule	\N
ulf	\N	\N	\N	I	L	Usku	\N
uli	\N	\N	\N	I	L	Ulithian	\N
ulk	\N	\N	\N	I	L	Meriam Mir	\N
ull	\N	\N	\N	I	L	Ullatan	\N
ulm	\N	\N	\N	I	L	Ulumanda'	\N
uln	\N	\N	\N	I	L	Unserdeutsch	\N
ulu	\N	\N	\N	I	L	Uma' Lung	\N
ulw	\N	\N	\N	I	L	Ulwa	\N
uly	\N	\N	\N	I	L	Buli	\N
uma	\N	\N	\N	I	L	Umatilla	\N
umb	umb	umb	\N	I	L	Umbundu	\N
umc	\N	\N	\N	I	H	Marrucinian	\N
umd	\N	\N	\N	I	E	Umbindhamu	\N
umg	\N	\N	\N	I	E	Morrobalama	\N
umi	\N	\N	\N	I	L	Ukit	\N
umm	\N	\N	\N	I	L	Umon	\N
umn	\N	\N	\N	I	L	Makyan Naga	\N
umo	\N	\N	\N	I	E	Umotína	\N
ump	\N	\N	\N	I	L	Umpila	\N
umr	\N	\N	\N	I	E	Umbugarla	\N
ums	\N	\N	\N	I	L	Pendau	\N
umu	\N	\N	\N	I	L	Munsee	\N
una	\N	\N	\N	I	L	North Watut	\N
und	und	und	\N	S	S	Undetermined	\N
une	\N	\N	\N	I	L	Uneme	\N
ung	\N	\N	\N	I	L	Ngarinyin	\N
uni	\N	\N	\N	I	L	Uni	\N
unk	\N	\N	\N	I	L	Enawené-Nawé	\N
unm	\N	\N	\N	I	E	Unami	\N
unn	\N	\N	\N	I	L	Kurnai	\N
unr	\N	\N	\N	I	L	Mundari	\N
unu	\N	\N	\N	I	L	Unubahe	\N
unx	\N	\N	\N	I	L	Munda	\N
unz	\N	\N	\N	I	L	Unde Kaili	\N
uon	\N	\N	\N	I	E	Kulon	\N
upi	\N	\N	\N	I	L	Umeda	\N
upv	\N	\N	\N	I	L	Uripiv-Wala-Rano-Atchin	\N
ura	\N	\N	\N	I	L	Urarina	\N
urb	\N	\N	\N	I	L	Urubú-Kaapor	\N
urc	\N	\N	\N	I	E	Urningangg	\N
urd	urd	urd	ur	I	L	Urdu	\N
ure	\N	\N	\N	I	L	Uru	\N
urf	\N	\N	\N	I	E	Uradhi	\N
urg	\N	\N	\N	I	L	Urigina	\N
urh	\N	\N	\N	I	L	Urhobo	\N
uri	\N	\N	\N	I	L	Urim	\N
urk	\N	\N	\N	I	L	Urak Lawoi'	\N
url	\N	\N	\N	I	L	Urali	\N
urm	\N	\N	\N	I	L	Urapmin	\N
urn	\N	\N	\N	I	L	Uruangnirin	\N
uro	\N	\N	\N	I	L	Ura (Papua New Guinea)	\N
urp	\N	\N	\N	I	L	Uru-Pa-In	\N
urr	\N	\N	\N	I	L	Lehalurup	\N
urt	\N	\N	\N	I	L	Urat	\N
uru	\N	\N	\N	I	E	Urumi	\N
urv	\N	\N	\N	I	E	Uruava	\N
urw	\N	\N	\N	I	L	Sop	\N
urx	\N	\N	\N	I	L	Urimo	\N
ury	\N	\N	\N	I	L	Orya	\N
urz	\N	\N	\N	I	L	Uru-Eu-Wau-Wau	\N
usa	\N	\N	\N	I	L	Usarufa	\N
ush	\N	\N	\N	I	L	Ushojo	\N
usi	\N	\N	\N	I	L	Usui	\N
usk	\N	\N	\N	I	L	Usaghade	\N
usp	\N	\N	\N	I	L	Uspanteco	\N
uss	\N	\N	\N	I	L	us-Saare	\N
usu	\N	\N	\N	I	L	Uya	\N
uta	\N	\N	\N	I	L	Otank	\N
ute	\N	\N	\N	I	L	Ute-Southern Paiute	\N
uth	\N	\N	\N	I	L	ut-Hun	\N
utp	\N	\N	\N	I	L	Amba (Solomon Islands)	\N
utr	\N	\N	\N	I	L	Etulo	\N
utu	\N	\N	\N	I	L	Utu	\N
uum	\N	\N	\N	I	L	Urum	\N
uur	\N	\N	\N	I	L	Ura (Vanuatu)	\N
uuu	\N	\N	\N	I	L	U	\N
uve	\N	\N	\N	I	L	West Uvean	\N
uvh	\N	\N	\N	I	L	Uri	\N
uvl	\N	\N	\N	I	L	Lote	\N
uwa	\N	\N	\N	I	L	Kuku-Uwanh	\N
uya	\N	\N	\N	I	L	Doko-Uyanga	\N
uzb	uzb	uzb	uz	M	L	Uzbek	\N
uzn	\N	\N	\N	I	L	Northern Uzbek	\N
uzs	\N	\N	\N	I	L	Southern Uzbek	\N
vaa	\N	\N	\N	I	L	Vaagri Booli	\N
vae	\N	\N	\N	I	L	Vale	\N
vaf	\N	\N	\N	I	L	Vafsi	\N
vag	\N	\N	\N	I	L	Vagla	\N
vah	\N	\N	\N	I	L	Varhadi-Nagpuri	\N
vai	vai	vai	\N	I	L	Vai	\N
vaj	\N	\N	\N	I	L	Sekele	\N
val	\N	\N	\N	I	L	Vehes	\N
vam	\N	\N	\N	I	L	Vanimo	\N
van	\N	\N	\N	I	L	Valman	\N
vao	\N	\N	\N	I	L	Vao	\N
vap	\N	\N	\N	I	L	Vaiphei	\N
var	\N	\N	\N	I	L	Huarijio	\N
vas	\N	\N	\N	I	L	Vasavi	\N
vau	\N	\N	\N	I	L	Vanuma	\N
vav	\N	\N	\N	I	L	Varli	\N
vay	\N	\N	\N	I	L	Wayu	\N
vbb	\N	\N	\N	I	L	Southeast Babar	\N
vbk	\N	\N	\N	I	L	Southwestern Bontok	\N
vec	\N	\N	\N	I	L	Venetian	\N
ved	\N	\N	\N	I	L	Veddah	\N
vel	\N	\N	\N	I	L	Veluws	\N
vem	\N	\N	\N	I	L	Vemgo-Mabas	\N
ven	ven	ven	ve	I	L	Venda	\N
veo	\N	\N	\N	I	E	Ventureño	\N
vep	\N	\N	\N	I	L	Veps	\N
ver	\N	\N	\N	I	L	Mom Jango	\N
vgr	\N	\N	\N	I	L	Vaghri	\N
vgt	\N	\N	\N	I	L	Vlaamse Gebarentaal	\N
vic	\N	\N	\N	I	L	Virgin Islands Creole English	\N
vid	\N	\N	\N	I	L	Vidunda	\N
vie	vie	vie	vi	I	L	Vietnamese	\N
vif	\N	\N	\N	I	L	Vili	\N
vig	\N	\N	\N	I	L	Viemo	\N
vil	\N	\N	\N	I	L	Vilela	\N
vin	\N	\N	\N	I	L	Vinza	\N
vis	\N	\N	\N	I	L	Vishavan	\N
vit	\N	\N	\N	I	L	Viti	\N
viv	\N	\N	\N	I	L	Iduna	\N
vjk	\N	\N	\N	I	L	Bajjika	\N
vka	\N	\N	\N	I	E	Kariyarra	\N
vkj	\N	\N	\N	I	L	Kujarge	\N
vkk	\N	\N	\N	I	L	Kaur	\N
vkl	\N	\N	\N	I	L	Kulisusu	\N
vkm	\N	\N	\N	I	E	Kamakan	\N
vkn	\N	\N	\N	I	L	Koro Nulu	\N
vko	\N	\N	\N	I	L	Kodeoha	\N
vkp	\N	\N	\N	I	L	Korlai Creole Portuguese	\N
vkt	\N	\N	\N	I	L	Tenggarong Kutai Malay	\N
vku	\N	\N	\N	I	L	Kurrama	\N
vkz	\N	\N	\N	I	L	Koro Zuba	\N
vlp	\N	\N	\N	I	L	Valpei	\N
vls	\N	\N	\N	I	L	Vlaams	\N
vma	\N	\N	\N	I	E	Martuyhunira	\N
vmb	\N	\N	\N	I	E	Barbaram	\N
vmc	\N	\N	\N	I	L	Juxtlahuaca Mixtec	\N
vmd	\N	\N	\N	I	L	Mudu Koraga	\N
vme	\N	\N	\N	I	L	East Masela	\N
vmf	\N	\N	\N	I	L	Mainfränkisch	\N
vmg	\N	\N	\N	I	L	Lungalunga	\N
vmh	\N	\N	\N	I	L	Maraghei	\N
vmi	\N	\N	\N	I	E	Miwa	\N
vmj	\N	\N	\N	I	L	Ixtayutla Mixtec	\N
vmk	\N	\N	\N	I	L	Makhuwa-Shirima	\N
vml	\N	\N	\N	I	E	Malgana	\N
vmm	\N	\N	\N	I	L	Mitlatongo Mixtec	\N
vmp	\N	\N	\N	I	L	Soyaltepec Mazatec	\N
vmq	\N	\N	\N	I	L	Soyaltepec Mixtec	\N
vmr	\N	\N	\N	I	L	Marenje	\N
vms	\N	\N	\N	I	E	Moksela	\N
vmu	\N	\N	\N	I	E	Muluridyi	\N
vmv	\N	\N	\N	I	E	Valley Maidu	\N
vmw	\N	\N	\N	I	L	Makhuwa	\N
vmx	\N	\N	\N	I	L	Tamazola Mixtec	\N
vmy	\N	\N	\N	I	L	Ayautla Mazatec	\N
vmz	\N	\N	\N	I	L	Mazatlán Mazatec	\N
vnk	\N	\N	\N	I	L	Vano	\N
vnm	\N	\N	\N	I	L	Vinmavis	\N
vnp	\N	\N	\N	I	L	Vunapu	\N
vol	vol	vol	vo	I	C	Volapük	\N
vor	\N	\N	\N	I	L	Voro	\N
vot	vot	vot	\N	I	L	Votic	\N
vra	\N	\N	\N	I	L	Vera'a	\N
vro	\N	\N	\N	I	L	Võro	\N
vrs	\N	\N	\N	I	L	Varisi	\N
vrt	\N	\N	\N	I	L	Burmbar	\N
vsi	\N	\N	\N	I	L	Moldova Sign Language	\N
vsl	\N	\N	\N	I	L	Venezuelan Sign Language	\N
vsn	\N	\N	\N	I	H	Vedic Sanskrit	\N
vsv	\N	\N	\N	I	L	Valencian Sign Language	\N
vto	\N	\N	\N	I	L	Vitou	\N
vum	\N	\N	\N	I	L	Vumbu	\N
vun	\N	\N	\N	I	L	Vunjo	\N
vut	\N	\N	\N	I	L	Vute	\N
vwa	\N	\N	\N	I	L	Awa (China)	\N
waa	\N	\N	\N	I	L	Walla Walla	\N
wab	\N	\N	\N	I	L	Wab	\N
wac	\N	\N	\N	I	E	Wasco-Wishram	\N
wad	\N	\N	\N	I	L	Wamesa	\N
wae	\N	\N	\N	I	L	Walser	\N
waf	\N	\N	\N	I	E	Wakoná	\N
wag	\N	\N	\N	I	L	Wa'ema	\N
wah	\N	\N	\N	I	L	Watubela	\N
wai	\N	\N	\N	I	L	Wares	\N
waj	\N	\N	\N	I	L	Waffa	\N
wal	wal	wal	\N	I	L	Wolaytta	\N
wam	\N	\N	\N	I	E	Wampanoag	\N
wan	\N	\N	\N	I	L	Wan	\N
wao	\N	\N	\N	I	E	Wappo	\N
wap	\N	\N	\N	I	L	Wapishana	\N
waq	\N	\N	\N	I	L	Wagiman	\N
war	war	war	\N	I	L	Waray (Philippines)	\N
was	was	was	\N	I	L	Washo	\N
wat	\N	\N	\N	I	L	Kaninuwa	\N
wau	\N	\N	\N	I	L	Waurá	\N
wav	\N	\N	\N	I	L	Waka	\N
waw	\N	\N	\N	I	L	Waiwai	\N
wax	\N	\N	\N	I	L	Watam	\N
way	\N	\N	\N	I	L	Wayana	\N
waz	\N	\N	\N	I	L	Wampur	\N
wba	\N	\N	\N	I	L	Warao	\N
wbb	\N	\N	\N	I	L	Wabo	\N
wbe	\N	\N	\N	I	L	Waritai	\N
wbf	\N	\N	\N	I	L	Wara	\N
wbh	\N	\N	\N	I	L	Wanda	\N
wbi	\N	\N	\N	I	L	Vwanji	\N
wbj	\N	\N	\N	I	L	Alagwa	\N
wbk	\N	\N	\N	I	L	Waigali	\N
wbl	\N	\N	\N	I	L	Wakhi	\N
wbm	\N	\N	\N	I	L	Wa	\N
wbp	\N	\N	\N	I	L	Warlpiri	\N
wbq	\N	\N	\N	I	L	Waddar	\N
wbr	\N	\N	\N	I	L	Wagdi	\N
wbs	\N	\N	\N	I	L	West Bengal Sign Language	\N
wbt	\N	\N	\N	I	L	Warnman	\N
wbv	\N	\N	\N	I	L	Wajarri	\N
wbw	\N	\N	\N	I	L	Woi	\N
wca	\N	\N	\N	I	L	Yanomámi	\N
wci	\N	\N	\N	I	L	Waci Gbe	\N
wdd	\N	\N	\N	I	L	Wandji	\N
wdg	\N	\N	\N	I	L	Wadaginam	\N
wdj	\N	\N	\N	I	L	Wadjiginy	\N
wdk	\N	\N	\N	I	E	Wadikali	\N
wdt	\N	\N	\N	I	L	Wendat	\N
wdu	\N	\N	\N	I	E	Wadjigu	\N
wdy	\N	\N	\N	I	E	Wadjabangayi	\N
wea	\N	\N	\N	I	E	Wewaw	\N
wec	\N	\N	\N	I	L	Wè Western	\N
wed	\N	\N	\N	I	L	Wedau	\N
weg	\N	\N	\N	I	L	Wergaia	\N
weh	\N	\N	\N	I	L	Weh	\N
wei	\N	\N	\N	I	L	Kiunum	\N
wem	\N	\N	\N	I	L	Weme Gbe	\N
weo	\N	\N	\N	I	L	Wemale	\N
wep	\N	\N	\N	I	L	Westphalien	\N
wer	\N	\N	\N	I	L	Weri	\N
wes	\N	\N	\N	I	L	Cameroon Pidgin	\N
wet	\N	\N	\N	I	L	Perai	\N
weu	\N	\N	\N	I	L	Rawngtu Chin	\N
wew	\N	\N	\N	I	L	Wejewa	\N
wfg	\N	\N	\N	I	L	Yafi	\N
wga	\N	\N	\N	I	E	Wagaya	\N
wgb	\N	\N	\N	I	L	Wagawaga	\N
wgg	\N	\N	\N	I	E	Wangkangurru	\N
wgi	\N	\N	\N	I	L	Wahgi	\N
wgo	\N	\N	\N	I	L	Waigeo	\N
wgu	\N	\N	\N	I	E	Wirangu	\N
wgy	\N	\N	\N	I	L	Warrgamay	\N
wha	\N	\N	\N	I	L	Sou Upaa	\N
whg	\N	\N	\N	I	L	North Wahgi	\N
whk	\N	\N	\N	I	L	Wahau Kenyah	\N
whu	\N	\N	\N	I	L	Wahau Kayan	\N
wib	\N	\N	\N	I	L	Southern Toussian	\N
wic	\N	\N	\N	I	E	Wichita	\N
wie	\N	\N	\N	I	E	Wik-Epa	\N
wif	\N	\N	\N	I	E	Wik-Keyangan	\N
wig	\N	\N	\N	I	L	Wik Ngathan	\N
wih	\N	\N	\N	I	L	Wik-Me'anha	\N
wii	\N	\N	\N	I	L	Minidien	\N
wij	\N	\N	\N	I	L	Wik-Iiyanh	\N
wik	\N	\N	\N	I	L	Wikalkan	\N
wil	\N	\N	\N	I	E	Wilawila	\N
wim	\N	\N	\N	I	L	Wik-Mungkan	\N
win	\N	\N	\N	I	L	Ho-Chunk	\N
wir	\N	\N	\N	I	E	Wiraféd	\N
wiu	\N	\N	\N	I	L	Wiru	\N
wiv	\N	\N	\N	I	L	Vitu	\N
wiy	\N	\N	\N	I	E	Wiyot	\N
wja	\N	\N	\N	I	L	Waja	\N
wji	\N	\N	\N	I	L	Warji	\N
wka	\N	\N	\N	I	E	Kw'adza	\N
wkb	\N	\N	\N	I	L	Kumbaran	\N
wkd	\N	\N	\N	I	L	Wakde	\N
wkl	\N	\N	\N	I	L	Kalanadi	\N
wkr	\N	\N	\N	I	L	Keerray-Woorroong	\N
wku	\N	\N	\N	I	L	Kunduvadi	\N
wkw	\N	\N	\N	I	E	Wakawaka	\N
wky	\N	\N	\N	I	E	Wangkayutyuru	\N
wla	\N	\N	\N	I	L	Walio	\N
wlc	\N	\N	\N	I	L	Mwali Comorian	\N
wle	\N	\N	\N	I	L	Wolane	\N
wlg	\N	\N	\N	I	L	Kunbarlang	\N
wlh	\N	\N	\N	I	L	Welaun	\N
wli	\N	\N	\N	I	L	Waioli	\N
wlk	\N	\N	\N	I	E	Wailaki	\N
wll	\N	\N	\N	I	L	Wali (Sudan)	\N
wlm	\N	\N	\N	I	H	Middle Welsh	\N
wln	wln	wln	wa	I	L	Walloon	\N
wlo	\N	\N	\N	I	L	Wolio	\N
wlr	\N	\N	\N	I	L	Wailapa	\N
wls	\N	\N	\N	I	L	Wallisian	\N
wlu	\N	\N	\N	I	E	Wuliwuli	\N
wlv	\N	\N	\N	I	L	Wichí Lhamtés Vejoz	\N
wlw	\N	\N	\N	I	L	Walak	\N
wlx	\N	\N	\N	I	L	Wali (Ghana)	\N
wly	\N	\N	\N	I	E	Waling	\N
wma	\N	\N	\N	I	E	Mawa (Nigeria)	\N
wmb	\N	\N	\N	I	L	Wambaya	\N
wmc	\N	\N	\N	I	L	Wamas	\N
wmd	\N	\N	\N	I	L	Mamaindé	\N
wme	\N	\N	\N	I	L	Wambule	\N
wmg	\N	\N	\N	I	L	Western Minyag	\N
wmh	\N	\N	\N	I	L	Waima'a	\N
wmi	\N	\N	\N	I	E	Wamin	\N
wmm	\N	\N	\N	I	L	Maiwa (Indonesia)	\N
wmn	\N	\N	\N	I	E	Waamwang	\N
wmo	\N	\N	\N	I	L	Wom (Papua New Guinea)	\N
wms	\N	\N	\N	I	L	Wambon	\N
wmt	\N	\N	\N	I	L	Walmajarri	\N
wmw	\N	\N	\N	I	L	Mwani	\N
wmx	\N	\N	\N	I	L	Womo	\N
wnb	\N	\N	\N	I	L	Mokati	\N
wnc	\N	\N	\N	I	L	Wantoat	\N
wnd	\N	\N	\N	I	E	Wandarang	\N
wne	\N	\N	\N	I	L	Waneci	\N
wng	\N	\N	\N	I	L	Wanggom	\N
wni	\N	\N	\N	I	L	Ndzwani Comorian	\N
wnk	\N	\N	\N	I	L	Wanukaka	\N
wnm	\N	\N	\N	I	E	Wanggamala	\N
wnn	\N	\N	\N	I	E	Wunumara	\N
wno	\N	\N	\N	I	L	Wano	\N
wnp	\N	\N	\N	I	L	Wanap	\N
wnu	\N	\N	\N	I	L	Usan	\N
wnw	\N	\N	\N	I	L	Wintu	\N
wny	\N	\N	\N	I	L	Wanyi	\N
woa	\N	\N	\N	I	L	Kuwema	\N
wob	\N	\N	\N	I	L	Wè Northern	\N
woc	\N	\N	\N	I	L	Wogeo	\N
wod	\N	\N	\N	I	L	Wolani	\N
woe	\N	\N	\N	I	L	Woleaian	\N
wof	\N	\N	\N	I	L	Gambian Wolof	\N
wog	\N	\N	\N	I	L	Wogamusin	\N
woi	\N	\N	\N	I	L	Kamang	\N
wok	\N	\N	\N	I	L	Longto	\N
wol	wol	wol	wo	I	L	Wolof	\N
wom	\N	\N	\N	I	L	Wom (Nigeria)	\N
won	\N	\N	\N	I	L	Wongo	\N
woo	\N	\N	\N	I	L	Manombai	\N
wor	\N	\N	\N	I	L	Woria	\N
wos	\N	\N	\N	I	L	Hanga Hundi	\N
wow	\N	\N	\N	I	L	Wawonii	\N
woy	\N	\N	\N	I	E	Weyto	\N
wpc	\N	\N	\N	I	L	Maco	\N
wrb	\N	\N	\N	I	E	Waluwarra	\N
wrg	\N	\N	\N	I	E	Warungu	\N
wrh	\N	\N	\N	I	E	Wiradjuri	\N
wri	\N	\N	\N	I	E	Wariyangga	\N
wrk	\N	\N	\N	I	L	Garrwa	\N
wrl	\N	\N	\N	I	L	Warlmanpa	\N
wrm	\N	\N	\N	I	L	Warumungu	\N
wrn	\N	\N	\N	I	L	Warnang	\N
wro	\N	\N	\N	I	E	Worrorra	\N
wrp	\N	\N	\N	I	L	Waropen	\N
wrr	\N	\N	\N	I	L	Wardaman	\N
wrs	\N	\N	\N	I	L	Waris	\N
wru	\N	\N	\N	I	L	Waru	\N
wrv	\N	\N	\N	I	L	Waruna	\N
wrw	\N	\N	\N	I	E	Gugu Warra	\N
wrx	\N	\N	\N	I	L	Wae Rana	\N
wry	\N	\N	\N	I	L	Merwari	\N
wrz	\N	\N	\N	I	E	Waray (Australia)	\N
wsa	\N	\N	\N	I	L	Warembori	\N
wsg	\N	\N	\N	I	L	Adilabad Gondi	\N
wsi	\N	\N	\N	I	L	Wusi	\N
wsk	\N	\N	\N	I	L	Waskia	\N
wsr	\N	\N	\N	I	L	Owenia	\N
wss	\N	\N	\N	I	L	Wasa	\N
wsu	\N	\N	\N	I	E	Wasu	\N
wsv	\N	\N	\N	I	E	Wotapuri-Katarqalai	\N
wtb	\N	\N	\N	I	L	Matambwe	\N
wtf	\N	\N	\N	I	L	Watiwa	\N
wth	\N	\N	\N	I	E	Wathawurrung	\N
wti	\N	\N	\N	I	L	Berta	\N
wtk	\N	\N	\N	I	L	Watakataui	\N
wtm	\N	\N	\N	I	L	Mewati	\N
wtw	\N	\N	\N	I	L	Wotu	\N
wua	\N	\N	\N	I	L	Wikngenchera	\N
wub	\N	\N	\N	I	L	Wunambal	\N
wud	\N	\N	\N	I	L	Wudu	\N
wuh	\N	\N	\N	I	L	Wutunhua	\N
wul	\N	\N	\N	I	L	Silimo	\N
wum	\N	\N	\N	I	L	Wumbvu	\N
wun	\N	\N	\N	I	L	Bungu	\N
wur	\N	\N	\N	I	E	Wurrugu	\N
wut	\N	\N	\N	I	L	Wutung	\N
wuu	\N	\N	\N	I	L	Wu Chinese	\N
wuv	\N	\N	\N	I	L	Wuvulu-Aua	\N
wux	\N	\N	\N	I	L	Wulna	\N
wuy	\N	\N	\N	I	L	Wauyai	\N
wwa	\N	\N	\N	I	L	Waama	\N
wwb	\N	\N	\N	I	E	Wakabunga	\N
wwo	\N	\N	\N	I	L	Wetamut	\N
wwr	\N	\N	\N	I	E	Warrwa	\N
www	\N	\N	\N	I	L	Wawa	\N
wxa	\N	\N	\N	I	L	Waxianghua	\N
wxw	\N	\N	\N	I	E	Wardandi	\N
wyb	\N	\N	\N	I	L	Wangaaybuwan-Ngiyambaa	\N
wyi	\N	\N	\N	I	E	Woiwurrung	\N
wym	\N	\N	\N	I	L	Wymysorys	\N
wyn	\N	\N	\N	I	L	Wyandot	\N
wyr	\N	\N	\N	I	L	Wayoró	\N
wyy	\N	\N	\N	I	L	Western Fijian	\N
xaa	\N	\N	\N	I	H	Andalusian Arabic	\N
xab	\N	\N	\N	I	L	Sambe	\N
xac	\N	\N	\N	I	L	Kachari	\N
xad	\N	\N	\N	I	E	Adai	\N
xae	\N	\N	\N	I	H	Aequian	\N
xag	\N	\N	\N	I	H	Aghwan	\N
xai	\N	\N	\N	I	E	Kaimbé	\N
xaj	\N	\N	\N	I	E	Ararandewára	\N
xak	\N	\N	\N	I	E	Máku	\N
xal	xal	xal	\N	I	L	Kalmyk	\N
xam	\N	\N	\N	I	E	ǀXam	\N
xan	\N	\N	\N	I	L	Xamtanga	\N
xao	\N	\N	\N	I	L	Khao	\N
xap	\N	\N	\N	I	E	Apalachee	\N
xaq	\N	\N	\N	I	H	Aquitanian	\N
xar	\N	\N	\N	I	E	Karami	\N
xas	\N	\N	\N	I	E	Kamas	\N
xat	\N	\N	\N	I	L	Katawixi	\N
xau	\N	\N	\N	I	L	Kauwera	\N
xav	\N	\N	\N	I	L	Xavánte	\N
xaw	\N	\N	\N	I	L	Kawaiisu	\N
xay	\N	\N	\N	I	L	Kayan Mahakam	\N
xbb	\N	\N	\N	I	E	Lower Burdekin	\N
xbc	\N	\N	\N	I	H	Bactrian	\N
xbd	\N	\N	\N	I	E	Bindal	\N
xbe	\N	\N	\N	I	E	Bigambal	\N
xbg	\N	\N	\N	I	E	Bunganditj	\N
xbi	\N	\N	\N	I	L	Kombio	\N
xbj	\N	\N	\N	I	E	Birrpayi	\N
xbm	\N	\N	\N	I	H	Middle Breton	\N
xbn	\N	\N	\N	I	E	Kenaboi	\N
xbo	\N	\N	\N	I	H	Bolgarian	\N
xbp	\N	\N	\N	I	E	Bibbulman	\N
xbr	\N	\N	\N	I	L	Kambera	\N
xbw	\N	\N	\N	I	E	Kambiwá	\N
xby	\N	\N	\N	I	L	Batjala	\N
xcb	\N	\N	\N	I	H	Cumbric	\N
xcc	\N	\N	\N	I	H	Camunic	\N
xce	\N	\N	\N	I	H	Celtiberian	\N
xcg	\N	\N	\N	I	H	Cisalpine Gaulish	\N
xch	\N	\N	\N	I	E	Chemakum	\N
xcl	\N	\N	\N	I	H	Classical Armenian	\N
xcm	\N	\N	\N	I	E	Comecrudo	\N
xcn	\N	\N	\N	I	E	Cotoname	\N
xco	\N	\N	\N	I	H	Chorasmian	\N
xcr	\N	\N	\N	I	H	Carian	\N
xct	\N	\N	\N	I	H	Classical Tibetan	\N
xcu	\N	\N	\N	I	H	Curonian	\N
xcv	\N	\N	\N	I	E	Chuvantsy	\N
xcw	\N	\N	\N	I	E	Coahuilteco	\N
xcy	\N	\N	\N	I	E	Cayuse	\N
xda	\N	\N	\N	I	L	Darkinyung	\N
xdc	\N	\N	\N	I	H	Dacian	\N
xdk	\N	\N	\N	I	E	Dharuk	\N
xdm	\N	\N	\N	I	H	Edomite	\N
xdo	\N	\N	\N	I	L	Kwandu	\N
xdq	\N	\N	\N	I	L	Kaitag	\N
xdy	\N	\N	\N	I	L	Malayic Dayak	\N
xeb	\N	\N	\N	I	H	Eblan	\N
xed	\N	\N	\N	I	L	Hdi	\N
xeg	\N	\N	\N	I	E	ǁXegwi	\N
xel	\N	\N	\N	I	L	Kelo	\N
xem	\N	\N	\N	I	L	Kembayan	\N
xep	\N	\N	\N	I	H	Epi-Olmec	\N
xer	\N	\N	\N	I	L	Xerénte	\N
xes	\N	\N	\N	I	L	Kesawai	\N
xet	\N	\N	\N	I	L	Xetá	\N
xeu	\N	\N	\N	I	L	Keoru-Ahia	\N
xfa	\N	\N	\N	I	H	Faliscan	\N
xga	\N	\N	\N	I	H	Galatian	\N
xgb	\N	\N	\N	I	E	Gbin	\N
xgd	\N	\N	\N	I	E	Gudang	\N
xgf	\N	\N	\N	I	E	Gabrielino-Fernandeño	\N
xgg	\N	\N	\N	I	E	Goreng	\N
xgi	\N	\N	\N	I	E	Garingbal	\N
xgl	\N	\N	\N	I	H	Galindan	\N
xgm	\N	\N	\N	I	E	Dharumbal	\N
xgr	\N	\N	\N	I	E	Garza	\N
xgu	\N	\N	\N	I	L	Unggumi	\N
xgw	\N	\N	\N	I	E	Guwa	\N
xha	\N	\N	\N	I	H	Harami	\N
xhc	\N	\N	\N	I	H	Hunnic	\N
xhd	\N	\N	\N	I	H	Hadrami	\N
xhe	\N	\N	\N	I	L	Khetrani	\N
xhm	\N	\N	\N	I	H	Middle Khmer (1400 to 1850 CE)	\N
xho	xho	xho	xh	I	L	Xhosa	\N
xhr	\N	\N	\N	I	H	Hernican	\N
xht	\N	\N	\N	I	H	Hattic	\N
xhu	\N	\N	\N	I	H	Hurrian	\N
xhv	\N	\N	\N	I	L	Khua	\N
xib	\N	\N	\N	I	H	Iberian	\N
xii	\N	\N	\N	I	L	Xiri	\N
xil	\N	\N	\N	I	H	Illyrian	\N
xin	\N	\N	\N	I	E	Xinca	\N
xir	\N	\N	\N	I	E	Xiriâna	\N
xis	\N	\N	\N	I	L	Kisan	\N
xiv	\N	\N	\N	I	H	Indus Valley Language	\N
xiy	\N	\N	\N	I	L	Xipaya	\N
xjb	\N	\N	\N	I	E	Minjungbal	\N
xjt	\N	\N	\N	I	E	Jaitmatang	\N
xka	\N	\N	\N	I	L	Kalkoti	\N
xkb	\N	\N	\N	I	L	Northern Nago	\N
xkc	\N	\N	\N	I	L	Kho'ini	\N
xkd	\N	\N	\N	I	L	Mendalam Kayan	\N
xke	\N	\N	\N	I	L	Kereho	\N
xkf	\N	\N	\N	I	L	Khengkha	\N
xkg	\N	\N	\N	I	L	Kagoro	\N
xki	\N	\N	\N	I	L	Kenyan Sign Language	\N
xkj	\N	\N	\N	I	L	Kajali	\N
xkk	\N	\N	\N	I	L	Kachok	\N
xkl	\N	\N	\N	I	L	Mainstream Kenyah	\N
xkn	\N	\N	\N	I	L	Kayan River Kayan	\N
xko	\N	\N	\N	I	L	Kiorr	\N
xkp	\N	\N	\N	I	L	Kabatei	\N
xkq	\N	\N	\N	I	L	Koroni	\N
xkr	\N	\N	\N	I	E	Xakriabá	\N
xks	\N	\N	\N	I	L	Kumbewaha	\N
xkt	\N	\N	\N	I	L	Kantosi	\N
xku	\N	\N	\N	I	L	Kaamba	\N
xkv	\N	\N	\N	I	L	Kgalagadi	\N
xkw	\N	\N	\N	I	L	Kembra	\N
xkx	\N	\N	\N	I	L	Karore	\N
xky	\N	\N	\N	I	L	Uma' Lasan	\N
xkz	\N	\N	\N	I	L	Kurtokha	\N
xla	\N	\N	\N	I	L	Kamula	\N
xlb	\N	\N	\N	I	E	Loup B	\N
xlc	\N	\N	\N	I	H	Lycian	\N
xld	\N	\N	\N	I	H	Lydian	\N
xle	\N	\N	\N	I	H	Lemnian	\N
xlg	\N	\N	\N	I	H	Ligurian (Ancient)	\N
xli	\N	\N	\N	I	H	Liburnian	\N
xln	\N	\N	\N	I	H	Alanic	\N
xlo	\N	\N	\N	I	E	Loup A	\N
xlp	\N	\N	\N	I	H	Lepontic	\N
xls	\N	\N	\N	I	H	Lusitanian	\N
xlu	\N	\N	\N	I	H	Cuneiform Luwian	\N
xly	\N	\N	\N	I	H	Elymian	\N
xma	\N	\N	\N	I	L	Mushungulu	\N
xmb	\N	\N	\N	I	L	Mbonga	\N
xmc	\N	\N	\N	I	L	Makhuwa-Marrevone	\N
xmd	\N	\N	\N	I	L	Mbudum	\N
xme	\N	\N	\N	I	H	Median	\N
xmf	\N	\N	\N	I	L	Mingrelian	\N
xmg	\N	\N	\N	I	L	Mengaka	\N
xmh	\N	\N	\N	I	L	Kugu-Muminh	\N
xmj	\N	\N	\N	I	L	Majera	\N
xmk	\N	\N	\N	I	H	Ancient Macedonian	\N
xml	\N	\N	\N	I	L	Malaysian Sign Language	\N
xmm	\N	\N	\N	I	L	Manado Malay	\N
xmn	\N	\N	\N	I	H	Manichaean Middle Persian	\N
xmo	\N	\N	\N	I	L	Morerebi	\N
xmp	\N	\N	\N	I	E	Kuku-Mu'inh	\N
xmq	\N	\N	\N	I	E	Kuku-Mangk	\N
xmr	\N	\N	\N	I	H	Meroitic	\N
xms	\N	\N	\N	I	L	Moroccan Sign Language	\N
xmt	\N	\N	\N	I	L	Matbat	\N
xmu	\N	\N	\N	I	E	Kamu	\N
xmv	\N	\N	\N	I	L	Antankarana Malagasy	\N
xmw	\N	\N	\N	I	L	Tsimihety Malagasy	\N
xmx	\N	\N	\N	I	L	Salawati	\N
xmy	\N	\N	\N	I	L	Mayaguduna	\N
xmz	\N	\N	\N	I	L	Mori Bawah	\N
xna	\N	\N	\N	I	H	Ancient North Arabian	\N
xnb	\N	\N	\N	I	L	Kanakanabu	\N
xng	\N	\N	\N	I	H	Middle Mongolian	\N
xnh	\N	\N	\N	I	L	Kuanhua	\N
xni	\N	\N	\N	I	E	Ngarigu	\N
xnj	\N	\N	\N	I	L	Ngoni (Tanzania)	\N
xnk	\N	\N	\N	I	E	Nganakarti	\N
xnm	\N	\N	\N	I	E	Ngumbarl	\N
xnn	\N	\N	\N	I	L	Northern Kankanay	\N
xno	\N	\N	\N	I	H	Anglo-Norman	\N
xnq	\N	\N	\N	I	L	Ngoni (Mozambique)	\N
xnr	\N	\N	\N	I	L	Kangri	\N
xns	\N	\N	\N	I	L	Kanashi	\N
xnt	\N	\N	\N	I	E	Narragansett	\N
xnu	\N	\N	\N	I	E	Nukunul	\N
xny	\N	\N	\N	I	L	Nyiyaparli	\N
xnz	\N	\N	\N	I	L	Kenzi	\N
xoc	\N	\N	\N	I	E	O'chi'chi'	\N
xod	\N	\N	\N	I	L	Kokoda	\N
xog	\N	\N	\N	I	L	Soga	\N
xoi	\N	\N	\N	I	L	Kominimung	\N
xok	\N	\N	\N	I	L	Xokleng	\N
xom	\N	\N	\N	I	L	Komo (Sudan)	\N
xon	\N	\N	\N	I	L	Konkomba	\N
xoo	\N	\N	\N	I	E	Xukurú	\N
xop	\N	\N	\N	I	L	Kopar	\N
xor	\N	\N	\N	I	L	Korubo	\N
xow	\N	\N	\N	I	L	Kowaki	\N
xpa	\N	\N	\N	I	E	Pirriya	\N
xpb	\N	\N	\N	I	E	Northeastern Tasmanian	\N
xpc	\N	\N	\N	I	H	Pecheneg	\N
xpd	\N	\N	\N	I	E	Oyster Bay Tasmanian	\N
xpe	\N	\N	\N	I	L	Liberia Kpelle	\N
xpf	\N	\N	\N	I	E	Southeast Tasmanian	\N
xpg	\N	\N	\N	I	H	Phrygian	\N
xph	\N	\N	\N	I	E	North Midlands Tasmanian	\N
xpi	\N	\N	\N	I	H	Pictish	\N
xpj	\N	\N	\N	I	E	Mpalitjanh	\N
xpk	\N	\N	\N	I	L	Kulina Pano	\N
xpl	\N	\N	\N	I	E	Port Sorell Tasmanian	\N
xpm	\N	\N	\N	I	E	Pumpokol	\N
xpn	\N	\N	\N	I	E	Kapinawá	\N
xpo	\N	\N	\N	I	E	Pochutec	\N
xpp	\N	\N	\N	I	H	Puyo-Paekche	\N
xpq	\N	\N	\N	I	E	Mohegan-Pequot	\N
xpr	\N	\N	\N	I	H	Parthian	\N
xps	\N	\N	\N	I	H	Pisidian	\N
xpt	\N	\N	\N	I	E	Punthamara	\N
xpu	\N	\N	\N	I	H	Punic	\N
xpv	\N	\N	\N	I	E	Northern Tasmanian	\N
xpw	\N	\N	\N	I	E	Northwestern Tasmanian	\N
xpx	\N	\N	\N	I	E	Southwestern Tasmanian	\N
xpy	\N	\N	\N	I	H	Puyo	\N
xpz	\N	\N	\N	I	E	Bruny Island Tasmanian	\N
xqa	\N	\N	\N	I	H	Karakhanid	\N
xqt	\N	\N	\N	I	H	Qatabanian	\N
xra	\N	\N	\N	I	L	Krahô	\N
xrb	\N	\N	\N	I	L	Eastern Karaboro	\N
xrd	\N	\N	\N	I	E	Gundungurra	\N
xre	\N	\N	\N	I	L	Kreye	\N
xrg	\N	\N	\N	I	E	Minang	\N
xri	\N	\N	\N	I	L	Krikati-Timbira	\N
xrm	\N	\N	\N	I	H	Armazic	\N
xrn	\N	\N	\N	I	E	Arin	\N
xrr	\N	\N	\N	I	H	Raetic	\N
xrt	\N	\N	\N	I	E	Aranama-Tamique	\N
xru	\N	\N	\N	I	L	Marriammu	\N
xrw	\N	\N	\N	I	L	Karawa	\N
xsa	\N	\N	\N	I	H	Sabaean	\N
xsb	\N	\N	\N	I	L	Sambal	\N
xsc	\N	\N	\N	I	H	Scythian	\N
xsd	\N	\N	\N	I	H	Sidetic	\N
xse	\N	\N	\N	I	L	Sempan	\N
xsh	\N	\N	\N	I	L	Shamang	\N
xsi	\N	\N	\N	I	L	Sio	\N
xsj	\N	\N	\N	I	L	Subi	\N
xsl	\N	\N	\N	I	L	South Slavey	\N
xsm	\N	\N	\N	I	L	Kasem	\N
xsn	\N	\N	\N	I	L	Sanga (Nigeria)	\N
xso	\N	\N	\N	I	E	Solano	\N
xsp	\N	\N	\N	I	L	Silopi	\N
xsq	\N	\N	\N	I	L	Makhuwa-Saka	\N
xsr	\N	\N	\N	I	L	Sherpa	\N
xsu	\N	\N	\N	I	L	Sanumá	\N
xsv	\N	\N	\N	I	E	Sudovian	\N
xsy	\N	\N	\N	I	L	Saisiyat	\N
xta	\N	\N	\N	I	L	Alcozauca Mixtec	\N
xtb	\N	\N	\N	I	L	Chazumba Mixtec	\N
xtc	\N	\N	\N	I	L	Katcha-Kadugli-Miri	\N
xtd	\N	\N	\N	I	L	Diuxi-Tilantongo Mixtec	\N
xte	\N	\N	\N	I	L	Ketengban	\N
xtg	\N	\N	\N	I	H	Transalpine Gaulish	\N
xth	\N	\N	\N	I	E	Yitha Yitha	\N
xti	\N	\N	\N	I	L	Sinicahua Mixtec	\N
xtj	\N	\N	\N	I	L	San Juan Teita Mixtec	\N
xtl	\N	\N	\N	I	L	Tijaltepec Mixtec	\N
xtm	\N	\N	\N	I	L	Magdalena Peñasco Mixtec	\N
xtn	\N	\N	\N	I	L	Northern Tlaxiaco Mixtec	\N
xto	\N	\N	\N	I	H	Tokharian A	\N
xtp	\N	\N	\N	I	L	San Miguel Piedras Mixtec	\N
xtq	\N	\N	\N	I	H	Tumshuqese	\N
xtr	\N	\N	\N	I	H	Early Tripuri	\N
xts	\N	\N	\N	I	L	Sindihui Mixtec	\N
xtt	\N	\N	\N	I	L	Tacahua Mixtec	\N
xtu	\N	\N	\N	I	L	Cuyamecalco Mixtec	\N
xtv	\N	\N	\N	I	E	Thawa	\N
xtw	\N	\N	\N	I	L	Tawandê	\N
xty	\N	\N	\N	I	L	Yoloxochitl Mixtec	\N
xua	\N	\N	\N	I	L	Alu Kurumba	\N
xub	\N	\N	\N	I	L	Betta Kurumba	\N
xud	\N	\N	\N	I	E	Umiida	\N
xug	\N	\N	\N	I	L	Kunigami	\N
xuj	\N	\N	\N	I	L	Jennu Kurumba	\N
xul	\N	\N	\N	I	E	Ngunawal	\N
xum	\N	\N	\N	I	H	Umbrian	\N
xun	\N	\N	\N	I	E	Unggaranggu	\N
xuo	\N	\N	\N	I	L	Kuo	\N
xup	\N	\N	\N	I	E	Upper Umpqua	\N
xur	\N	\N	\N	I	H	Urartian	\N
xut	\N	\N	\N	I	E	Kuthant	\N
xuu	\N	\N	\N	I	L	Kxoe	\N
xve	\N	\N	\N	I	H	Venetic	\N
xvi	\N	\N	\N	I	L	Kamviri	\N
xvn	\N	\N	\N	I	H	Vandalic	\N
xvo	\N	\N	\N	I	H	Volscian	\N
xvs	\N	\N	\N	I	H	Vestinian	\N
xwa	\N	\N	\N	I	L	Kwaza	\N
xwc	\N	\N	\N	I	E	Woccon	\N
xwd	\N	\N	\N	I	E	Wadi Wadi	\N
xwe	\N	\N	\N	I	L	Xwela Gbe	\N
xwg	\N	\N	\N	I	L	Kwegu	\N
xwj	\N	\N	\N	I	E	Wajuk	\N
xwk	\N	\N	\N	I	E	Wangkumara	\N
xwl	\N	\N	\N	I	L	Western Xwla Gbe	\N
xwo	\N	\N	\N	I	E	Written Oirat	\N
xwr	\N	\N	\N	I	L	Kwerba Mamberamo	\N
xwt	\N	\N	\N	I	E	Wotjobaluk	\N
xww	\N	\N	\N	I	E	Wemba Wemba	\N
xxb	\N	\N	\N	I	E	Boro (Ghana)	\N
xxk	\N	\N	\N	I	L	Ke'o	\N
xxm	\N	\N	\N	I	E	Minkin	\N
xxr	\N	\N	\N	I	E	Koropó	\N
xxt	\N	\N	\N	I	E	Tambora	\N
xya	\N	\N	\N	I	E	Yaygir	\N
xyb	\N	\N	\N	I	E	Yandjibara	\N
xyj	\N	\N	\N	I	E	Mayi-Yapi	\N
xyk	\N	\N	\N	I	E	Mayi-Kulan	\N
xyl	\N	\N	\N	I	E	Yalakalore	\N
xyt	\N	\N	\N	I	E	Mayi-Thakurti	\N
xyy	\N	\N	\N	I	L	Yorta Yorta	\N
xzh	\N	\N	\N	I	H	Zhang-Zhung	\N
xzm	\N	\N	\N	I	E	Zemgalian	\N
xzp	\N	\N	\N	I	H	Ancient Zapotec	\N
yaa	\N	\N	\N	I	L	Yaminahua	\N
yab	\N	\N	\N	I	L	Yuhup	\N
yac	\N	\N	\N	I	L	Pass Valley Yali	\N
yad	\N	\N	\N	I	L	Yagua	\N
yae	\N	\N	\N	I	L	Pumé	\N
yaf	\N	\N	\N	I	L	Yaka (Democratic Republic of Congo)	\N
yag	\N	\N	\N	I	L	Yámana	\N
yah	\N	\N	\N	I	L	Yazgulyam	\N
yai	\N	\N	\N	I	L	Yagnobi	\N
yaj	\N	\N	\N	I	L	Banda-Yangere	\N
yak	\N	\N	\N	I	L	Yakama	\N
yal	\N	\N	\N	I	L	Yalunka	\N
yam	\N	\N	\N	I	L	Yamba	\N
yan	\N	\N	\N	I	L	Mayangna	\N
yao	yao	yao	\N	I	L	Yao	\N
yap	yap	yap	\N	I	L	Yapese	\N
yaq	\N	\N	\N	I	L	Yaqui	\N
yar	\N	\N	\N	I	L	Yabarana	\N
yas	\N	\N	\N	I	L	Nugunu (Cameroon)	\N
yat	\N	\N	\N	I	L	Yambeta	\N
yau	\N	\N	\N	I	L	Yuwana	\N
yav	\N	\N	\N	I	L	Yangben	\N
yaw	\N	\N	\N	I	L	Yawalapití	\N
yax	\N	\N	\N	I	L	Yauma	\N
yay	\N	\N	\N	I	L	Agwagwune	\N
yaz	\N	\N	\N	I	L	Lokaa	\N
yba	\N	\N	\N	I	L	Yala	\N
ybb	\N	\N	\N	I	L	Yemba	\N
ybe	\N	\N	\N	I	L	West Yugur	\N
ybh	\N	\N	\N	I	L	Yakha	\N
ybi	\N	\N	\N	I	L	Yamphu	\N
ybj	\N	\N	\N	I	L	Hasha	\N
ybk	\N	\N	\N	I	L	Bokha	\N
ybl	\N	\N	\N	I	L	Yukuben	\N
ybm	\N	\N	\N	I	L	Yaben	\N
ybn	\N	\N	\N	I	E	Yabaâna	\N
ybo	\N	\N	\N	I	L	Yabong	\N
ybx	\N	\N	\N	I	L	Yawiyo	\N
yby	\N	\N	\N	I	L	Yaweyuha	\N
ych	\N	\N	\N	I	L	Chesu	\N
ycl	\N	\N	\N	I	L	Lolopo	\N
ycn	\N	\N	\N	I	L	Yucuna	\N
ycp	\N	\N	\N	I	L	Chepya	\N
ycr	\N	\N	\N	I	L	Yilan Creole	\N
yda	\N	\N	\N	I	E	Yanda	\N
ydd	\N	\N	\N	I	L	Eastern Yiddish	\N
yde	\N	\N	\N	I	L	Yangum Dey	\N
ydg	\N	\N	\N	I	L	Yidgha	\N
ydk	\N	\N	\N	I	L	Yoidik	\N
yea	\N	\N	\N	I	L	Ravula	\N
yec	\N	\N	\N	I	L	Yeniche	\N
yee	\N	\N	\N	I	L	Yimas	\N
yei	\N	\N	\N	I	E	Yeni	\N
yej	\N	\N	\N	I	L	Yevanic	\N
yel	\N	\N	\N	I	L	Yela	\N
yer	\N	\N	\N	I	L	Tarok	\N
yes	\N	\N	\N	I	L	Nyankpa	\N
yet	\N	\N	\N	I	L	Yetfa	\N
yeu	\N	\N	\N	I	L	Yerukula	\N
yev	\N	\N	\N	I	L	Yapunda	\N
yey	\N	\N	\N	I	L	Yeyi	\N
yga	\N	\N	\N	I	E	Malyangapa	\N
ygi	\N	\N	\N	I	E	Yiningayi	\N
ygl	\N	\N	\N	I	L	Yangum Gel	\N
ygm	\N	\N	\N	I	L	Yagomi	\N
ygp	\N	\N	\N	I	L	Gepo	\N
ygr	\N	\N	\N	I	L	Yagaria	\N
ygs	\N	\N	\N	I	L	Yolŋu Sign Language	\N
ygu	\N	\N	\N	I	L	Yugul	\N
ygw	\N	\N	\N	I	L	Yagwoia	\N
yha	\N	\N	\N	I	L	Baha Buyang	\N
yhd	\N	\N	\N	I	L	Judeo-Iraqi Arabic	\N
yhl	\N	\N	\N	I	L	Hlepho Phowa	\N
yhs	\N	\N	\N	I	L	Yan-nhaŋu Sign Language	\N
yia	\N	\N	\N	I	L	Yinggarda	\N
yid	yid	yid	yi	M	L	Yiddish	\N
yif	\N	\N	\N	I	L	Ache	\N
yig	\N	\N	\N	I	L	Wusa Nasu	\N
yih	\N	\N	\N	I	E	Western Yiddish	\N
yii	\N	\N	\N	I	L	Yidiny	\N
yij	\N	\N	\N	I	L	Yindjibarndi	\N
yik	\N	\N	\N	I	L	Dongshanba Lalo	\N
yil	\N	\N	\N	I	E	Yindjilandji	\N
yim	\N	\N	\N	I	L	Yimchungru Naga	\N
yin	\N	\N	\N	I	L	Riang Lai	\N
yip	\N	\N	\N	I	L	Pholo	\N
yiq	\N	\N	\N	I	L	Miqie	\N
yir	\N	\N	\N	I	L	North Awyu	\N
yis	\N	\N	\N	I	L	Yis	\N
yit	\N	\N	\N	I	L	Eastern Lalu	\N
yiu	\N	\N	\N	I	L	Awu	\N
yiv	\N	\N	\N	I	L	Northern Nisu	\N
yix	\N	\N	\N	I	L	Axi Yi	\N
yiz	\N	\N	\N	I	L	Azhe	\N
yka	\N	\N	\N	I	L	Yakan	\N
ykg	\N	\N	\N	I	L	Northern Yukaghir	\N
ykh	\N	\N	\N	I	L	Khamnigan Mongol	\N
yki	\N	\N	\N	I	L	Yoke	\N
ykk	\N	\N	\N	I	L	Yakaikeke	\N
ykl	\N	\N	\N	I	L	Khlula	\N
ykm	\N	\N	\N	I	L	Kap	\N
ykn	\N	\N	\N	I	L	Kua-nsi	\N
yko	\N	\N	\N	I	L	Yasa	\N
ykr	\N	\N	\N	I	L	Yekora	\N
ykt	\N	\N	\N	I	L	Kathu	\N
yku	\N	\N	\N	I	L	Kuamasi	\N
yky	\N	\N	\N	I	L	Yakoma	\N
yla	\N	\N	\N	I	L	Yaul	\N
ylb	\N	\N	\N	I	L	Yaleba	\N
yle	\N	\N	\N	I	L	Yele	\N
ylg	\N	\N	\N	I	L	Yelogu	\N
yli	\N	\N	\N	I	L	Angguruk Yali	\N
yll	\N	\N	\N	I	L	Yil	\N
ylm	\N	\N	\N	I	L	Limi	\N
yln	\N	\N	\N	I	L	Langnian Buyang	\N
ylo	\N	\N	\N	I	L	Naluo Yi	\N
ylr	\N	\N	\N	I	E	Yalarnnga	\N
ylu	\N	\N	\N	I	L	Aribwaung	\N
yly	\N	\N	\N	I	L	Nyâlayu	\N
ymb	\N	\N	\N	I	L	Yambes	\N
ymc	\N	\N	\N	I	L	Southern Muji	\N
ymd	\N	\N	\N	I	L	Muda	\N
yme	\N	\N	\N	I	E	Yameo	\N
ymg	\N	\N	\N	I	L	Yamongeri	\N
ymh	\N	\N	\N	I	L	Mili	\N
ymi	\N	\N	\N	I	L	Moji	\N
ymk	\N	\N	\N	I	L	Makwe	\N
yml	\N	\N	\N	I	L	Iamalele	\N
ymm	\N	\N	\N	I	L	Maay	\N
ymn	\N	\N	\N	I	L	Yamna	\N
ymo	\N	\N	\N	I	L	Yangum Mon	\N
ymp	\N	\N	\N	I	L	Yamap	\N
ymq	\N	\N	\N	I	L	Qila Muji	\N
ymr	\N	\N	\N	I	L	Malasar	\N
yms	\N	\N	\N	I	H	Mysian	\N
ymx	\N	\N	\N	I	L	Northern Muji	\N
ymz	\N	\N	\N	I	L	Muzi	\N
yna	\N	\N	\N	I	L	Aluo	\N
ynd	\N	\N	\N	I	E	Yandruwandha	\N
yne	\N	\N	\N	I	L	Lang'e	\N
yng	\N	\N	\N	I	L	Yango	\N
ynk	\N	\N	\N	I	L	Naukan Yupik	\N
ynl	\N	\N	\N	I	L	Yangulam	\N
ynn	\N	\N	\N	I	E	Yana	\N
yno	\N	\N	\N	I	L	Yong	\N
ynq	\N	\N	\N	I	L	Yendang	\N
yns	\N	\N	\N	I	L	Yansi	\N
ynu	\N	\N	\N	I	E	Yahuna	\N
yob	\N	\N	\N	I	E	Yoba	\N
yog	\N	\N	\N	I	L	Yogad	\N
yoi	\N	\N	\N	I	L	Yonaguni	\N
yok	\N	\N	\N	I	L	Yokuts	\N
yol	\N	\N	\N	I	E	Yola	\N
yom	\N	\N	\N	I	L	Yombe	\N
yon	\N	\N	\N	I	L	Yongkom	\N
yor	yor	yor	yo	I	L	Yoruba	\N
yot	\N	\N	\N	I	L	Yotti	\N
yox	\N	\N	\N	I	L	Yoron	\N
yoy	\N	\N	\N	I	L	Yoy	\N
ypa	\N	\N	\N	I	L	Phala	\N
ypb	\N	\N	\N	I	L	Labo Phowa	\N
ypg	\N	\N	\N	I	L	Phola	\N
yph	\N	\N	\N	I	L	Phupha	\N
ypm	\N	\N	\N	I	L	Phuma	\N
ypn	\N	\N	\N	I	L	Ani Phowa	\N
ypo	\N	\N	\N	I	L	Alo Phola	\N
ypp	\N	\N	\N	I	L	Phupa	\N
ypz	\N	\N	\N	I	L	Phuza	\N
yra	\N	\N	\N	I	L	Yerakai	\N
yrb	\N	\N	\N	I	L	Yareba	\N
yre	\N	\N	\N	I	L	Yaouré	\N
yrk	\N	\N	\N	I	L	Nenets	\N
yrl	\N	\N	\N	I	L	Nhengatu	\N
yrm	\N	\N	\N	I	L	Yirrk-Mel	\N
yrn	\N	\N	\N	I	L	Yerong	\N
yro	\N	\N	\N	I	L	Yaroamë	\N
yrs	\N	\N	\N	I	L	Yarsun	\N
yrw	\N	\N	\N	I	L	Yarawata	\N
yry	\N	\N	\N	I	L	Yarluyandi	\N
ysc	\N	\N	\N	I	E	Yassic	\N
ysd	\N	\N	\N	I	L	Samatao	\N
ysg	\N	\N	\N	I	L	Sonaga	\N
ysl	\N	\N	\N	I	L	Yugoslavian Sign Language	\N
ysm	\N	\N	\N	I	L	Myanmar Sign Language	\N
ysn	\N	\N	\N	I	L	Sani	\N
yso	\N	\N	\N	I	L	Nisi (China)	\N
ysp	\N	\N	\N	I	L	Southern Lolopo	\N
ysr	\N	\N	\N	I	E	Sirenik Yupik	\N
yss	\N	\N	\N	I	L	Yessan-Mayo	\N
ysy	\N	\N	\N	I	L	Sanie	\N
yta	\N	\N	\N	I	L	Talu	\N
ytl	\N	\N	\N	I	L	Tanglang	\N
ytp	\N	\N	\N	I	L	Thopho	\N
ytw	\N	\N	\N	I	L	Yout Wam	\N
yty	\N	\N	\N	I	E	Yatay	\N
yua	\N	\N	\N	I	L	Yucateco	\N
yub	\N	\N	\N	I	E	Yugambal	\N
yuc	\N	\N	\N	I	L	Yuchi	\N
yud	\N	\N	\N	I	L	Judeo-Tripolitanian Arabic	\N
yue	\N	\N	\N	I	L	Yue Chinese	\N
yuf	\N	\N	\N	I	L	Havasupai-Walapai-Yavapai	\N
yug	\N	\N	\N	I	E	Yug	\N
yui	\N	\N	\N	I	L	Yurutí	\N
yuj	\N	\N	\N	I	L	Karkar-Yuri	\N
yuk	\N	\N	\N	I	E	Yuki	\N
yul	\N	\N	\N	I	L	Yulu	\N
yum	\N	\N	\N	I	L	Quechan	\N
yun	\N	\N	\N	I	L	Bena (Nigeria)	\N
yup	\N	\N	\N	I	L	Yukpa	\N
yuq	\N	\N	\N	I	L	Yuqui	\N
yur	\N	\N	\N	I	E	Yurok	\N
yut	\N	\N	\N	I	L	Yopno	\N
yuw	\N	\N	\N	I	L	Yau (Morobe Province)	\N
yux	\N	\N	\N	I	L	Southern Yukaghir	\N
yuy	\N	\N	\N	I	L	East Yugur	\N
yuz	\N	\N	\N	I	L	Yuracare	\N
yva	\N	\N	\N	I	L	Yawa	\N
yvt	\N	\N	\N	I	E	Yavitero	\N
ywa	\N	\N	\N	I	L	Kalou	\N
ywg	\N	\N	\N	I	L	Yinhawangka	\N
ywl	\N	\N	\N	I	L	Western Lalu	\N
ywn	\N	\N	\N	I	L	Yawanawa	\N
ywq	\N	\N	\N	I	L	Wuding-Luquan Yi	\N
ywr	\N	\N	\N	I	L	Yawuru	\N
ywt	\N	\N	\N	I	L	Xishanba Lalo	\N
ywu	\N	\N	\N	I	L	Wumeng Nasu	\N
yww	\N	\N	\N	I	E	Yawarawarga	\N
yxa	\N	\N	\N	I	E	Mayawali	\N
yxg	\N	\N	\N	I	E	Yagara	\N
yxl	\N	\N	\N	I	E	Yardliyawarra	\N
yxm	\N	\N	\N	I	E	Yinwum	\N
yxu	\N	\N	\N	I	E	Yuyu	\N
yxy	\N	\N	\N	I	E	Yabula Yabula	\N
yyr	\N	\N	\N	I	E	Yir Yoront	\N
yyu	\N	\N	\N	I	L	Yau (Sandaun Province)	\N
yyz	\N	\N	\N	I	L	Ayizi	\N
yzg	\N	\N	\N	I	L	E'ma Buyang	\N
yzk	\N	\N	\N	I	L	Zokhuo	\N
zaa	\N	\N	\N	I	L	Sierra de Juárez Zapotec	\N
zab	\N	\N	\N	I	L	Western Tlacolula Valley Zapotec	\N
zac	\N	\N	\N	I	L	Ocotlán Zapotec	\N
zad	\N	\N	\N	I	L	Cajonos Zapotec	\N
zae	\N	\N	\N	I	L	Yareni Zapotec	\N
zaf	\N	\N	\N	I	L	Ayoquesco Zapotec	\N
zag	\N	\N	\N	I	L	Zaghawa	\N
zah	\N	\N	\N	I	L	Zangwal	\N
zai	\N	\N	\N	I	L	Isthmus Zapotec	\N
zaj	\N	\N	\N	I	L	Zaramo	\N
zak	\N	\N	\N	I	L	Zanaki	\N
zal	\N	\N	\N	I	L	Zauzou	\N
zam	\N	\N	\N	I	L	Miahuatlán Zapotec	\N
zao	\N	\N	\N	I	L	Ozolotepec Zapotec	\N
zap	zap	zap	\N	M	L	Zapotec	\N
zaq	\N	\N	\N	I	L	Aloápam Zapotec	\N
zar	\N	\N	\N	I	L	Rincón Zapotec	\N
zas	\N	\N	\N	I	L	Santo Domingo Albarradas Zapotec	\N
zat	\N	\N	\N	I	L	Tabaa Zapotec	\N
zau	\N	\N	\N	I	L	Zangskari	\N
zav	\N	\N	\N	I	L	Yatzachi Zapotec	\N
zaw	\N	\N	\N	I	L	Mitla Zapotec	\N
zax	\N	\N	\N	I	L	Xadani Zapotec	\N
zay	\N	\N	\N	I	L	Zayse-Zergulla	\N
zaz	\N	\N	\N	I	L	Zari	\N
zba	\N	\N	\N	I	C	Balaibalan	\N
zbc	\N	\N	\N	I	L	Central Berawan	\N
zbe	\N	\N	\N	I	L	East Berawan	\N
zbl	zbl	zbl	\N	I	C	Blissymbols	\N
zbt	\N	\N	\N	I	L	Batui	\N
zbu	\N	\N	\N	I	L	Bu (Bauchi State)	\N
zbw	\N	\N	\N	I	L	West Berawan	\N
zca	\N	\N	\N	I	L	Coatecas Altas Zapotec	\N
zcd	\N	\N	\N	I	L	Las Delicias Zapotec	\N
zch	\N	\N	\N	I	L	Central Hongshuihe Zhuang	\N
zdj	\N	\N	\N	I	L	Ngazidja Comorian	\N
zea	\N	\N	\N	I	L	Zeeuws	\N
zeg	\N	\N	\N	I	L	Zenag	\N
zeh	\N	\N	\N	I	L	Eastern Hongshuihe Zhuang	\N
zem	\N	\N	\N	I	L	Zeem	\N
zen	zen	zen	\N	I	L	Zenaga	\N
zga	\N	\N	\N	I	L	Kinga	\N
zgb	\N	\N	\N	I	L	Guibei Zhuang	\N
zgh	zgh	zgh	\N	I	L	Standard Moroccan Tamazight	\N
zgm	\N	\N	\N	I	L	Minz Zhuang	\N
zgn	\N	\N	\N	I	L	Guibian Zhuang	\N
zgr	\N	\N	\N	I	L	Magori	\N
zha	zha	zha	za	M	L	Zhuang	\N
zhb	\N	\N	\N	I	L	Zhaba	\N
zhd	\N	\N	\N	I	L	Dai Zhuang	\N
zhi	\N	\N	\N	I	L	Zhire	\N
zhn	\N	\N	\N	I	L	Nong Zhuang	\N
zho	chi	zho	zh	M	L	Chinese	\N
zhw	\N	\N	\N	I	L	Zhoa	\N
zia	\N	\N	\N	I	L	Zia	\N
zib	\N	\N	\N	I	L	Zimbabwe Sign Language	\N
zik	\N	\N	\N	I	L	Zimakani	\N
zil	\N	\N	\N	I	L	Zialo	\N
zim	\N	\N	\N	I	L	Mesme	\N
zin	\N	\N	\N	I	L	Zinza	\N
ziw	\N	\N	\N	I	L	Zigula	\N
ziz	\N	\N	\N	I	L	Zizilivakan	\N
zka	\N	\N	\N	I	L	Kaimbulawa	\N
zkd	\N	\N	\N	I	L	Kadu	\N
zkg	\N	\N	\N	I	H	Koguryo	\N
zkh	\N	\N	\N	I	H	Khorezmian	\N
zkk	\N	\N	\N	I	E	Karankawa	\N
zkn	\N	\N	\N	I	L	Kanan	\N
zko	\N	\N	\N	I	E	Kott	\N
zkp	\N	\N	\N	I	E	São Paulo Kaingáng	\N
zkr	\N	\N	\N	I	L	Zakhring	\N
zkt	\N	\N	\N	I	H	Kitan	\N
zku	\N	\N	\N	I	L	Kaurna	\N
zkv	\N	\N	\N	I	E	Krevinian	\N
zkz	\N	\N	\N	I	H	Khazar	\N
zla	\N	\N	\N	I	L	Zula	\N
zlj	\N	\N	\N	I	L	Liujiang Zhuang	\N
zlm	\N	\N	\N	I	L	Malay (individual language)	\N
zln	\N	\N	\N	I	L	Lianshan Zhuang	\N
zlq	\N	\N	\N	I	L	Liuqian Zhuang	\N
zlu	\N	\N	\N	I	L	Zul	\N
zma	\N	\N	\N	I	L	Manda (Australia)	\N
zmb	\N	\N	\N	I	L	Zimba	\N
zmc	\N	\N	\N	I	E	Margany	\N
zmd	\N	\N	\N	I	L	Maridan	\N
zme	\N	\N	\N	I	E	Mangerr	\N
zmf	\N	\N	\N	I	L	Mfinu	\N
zmg	\N	\N	\N	I	L	Marti Ke	\N
zmh	\N	\N	\N	I	E	Makolkol	\N
zmi	\N	\N	\N	I	L	Negeri Sembilan Malay	\N
zmj	\N	\N	\N	I	L	Maridjabin	\N
zmk	\N	\N	\N	I	E	Mandandanyi	\N
zml	\N	\N	\N	I	E	Matngala	\N
zmm	\N	\N	\N	I	L	Marimanindji	\N
zmn	\N	\N	\N	I	L	Mbangwe	\N
zmo	\N	\N	\N	I	L	Molo	\N
zmp	\N	\N	\N	I	L	Mpuono	\N
zmq	\N	\N	\N	I	L	Mituku	\N
zmr	\N	\N	\N	I	L	Maranunggu	\N
zms	\N	\N	\N	I	L	Mbesa	\N
zmt	\N	\N	\N	I	L	Maringarr	\N
zmu	\N	\N	\N	I	E	Muruwari	\N
zmv	\N	\N	\N	I	E	Mbariman-Gudhinma	\N
zmw	\N	\N	\N	I	L	Mbo (Democratic Republic of Congo)	\N
zmx	\N	\N	\N	I	L	Bomitaba	\N
zmy	\N	\N	\N	I	L	Mariyedi	\N
zmz	\N	\N	\N	I	L	Mbandja	\N
zna	\N	\N	\N	I	L	Zan Gula	\N
zne	\N	\N	\N	I	L	Zande (individual language)	\N
zng	\N	\N	\N	I	L	Mang	\N
znk	\N	\N	\N	I	E	Manangkari	\N
zns	\N	\N	\N	I	L	Mangas	\N
zoc	\N	\N	\N	I	L	Copainalá Zoque	\N
zoh	\N	\N	\N	I	L	Chimalapa Zoque	\N
zom	\N	\N	\N	I	L	Zou	\N
zoo	\N	\N	\N	I	L	Asunción Mixtepec Zapotec	\N
zoq	\N	\N	\N	I	L	Tabasco Zoque	\N
zor	\N	\N	\N	I	L	Rayón Zoque	\N
zos	\N	\N	\N	I	L	Francisco León Zoque	\N
zpa	\N	\N	\N	I	L	Lachiguiri Zapotec	\N
zpb	\N	\N	\N	I	L	Yautepec Zapotec	\N
zpc	\N	\N	\N	I	L	Choapan Zapotec	\N
zpd	\N	\N	\N	I	L	Southeastern Ixtlán Zapotec	\N
zpe	\N	\N	\N	I	L	Petapa Zapotec	\N
zpf	\N	\N	\N	I	L	San Pedro Quiatoni Zapotec	\N
zpg	\N	\N	\N	I	L	Guevea De Humboldt Zapotec	\N
zph	\N	\N	\N	I	L	Totomachapan Zapotec	\N
zpi	\N	\N	\N	I	L	Santa María Quiegolani Zapotec	\N
zpj	\N	\N	\N	I	L	Quiavicuzas Zapotec	\N
zpk	\N	\N	\N	I	L	Tlacolulita Zapotec	\N
zpl	\N	\N	\N	I	L	Lachixío Zapotec	\N
zpm	\N	\N	\N	I	L	Mixtepec Zapotec	\N
zpn	\N	\N	\N	I	L	Santa Inés Yatzechi Zapotec	\N
zpo	\N	\N	\N	I	L	Amatlán Zapotec	\N
zpp	\N	\N	\N	I	L	El Alto Zapotec	\N
zpq	\N	\N	\N	I	L	Zoogocho Zapotec	\N
zpr	\N	\N	\N	I	L	Santiago Xanica Zapotec	\N
zps	\N	\N	\N	I	L	Coatlán Zapotec	\N
zpt	\N	\N	\N	I	L	San Vicente Coatlán Zapotec	\N
zpu	\N	\N	\N	I	L	Yalálag Zapotec	\N
zpv	\N	\N	\N	I	L	Chichicapan Zapotec	\N
zpw	\N	\N	\N	I	L	Zaniza Zapotec	\N
zpx	\N	\N	\N	I	L	San Baltazar Loxicha Zapotec	\N
zpy	\N	\N	\N	I	L	Mazaltepec Zapotec	\N
zpz	\N	\N	\N	I	L	Texmelucan Zapotec	\N
zqe	\N	\N	\N	I	L	Qiubei Zhuang	\N
zra	\N	\N	\N	I	H	Kara (Korea)	\N
zrg	\N	\N	\N	I	L	Mirgan	\N
zrn	\N	\N	\N	I	L	Zerenkel	\N
zro	\N	\N	\N	I	L	Záparo	\N
zrp	\N	\N	\N	I	E	Zarphatic	\N
zrs	\N	\N	\N	I	L	Mairasi	\N
zsa	\N	\N	\N	I	L	Sarasira	\N
zsk	\N	\N	\N	I	H	Kaskean	\N
zsl	\N	\N	\N	I	L	Zambian Sign Language	\N
zsm	\N	\N	\N	I	L	Standard Malay	\N
zsr	\N	\N	\N	I	L	Southern Rincon Zapotec	\N
zsu	\N	\N	\N	I	L	Sukurum	\N
zte	\N	\N	\N	I	L	Elotepec Zapotec	\N
ztg	\N	\N	\N	I	L	Xanaguía Zapotec	\N
ztl	\N	\N	\N	I	L	Lapaguía-Guivini Zapotec	\N
ztm	\N	\N	\N	I	L	San Agustín Mixtepec Zapotec	\N
ztn	\N	\N	\N	I	L	Santa Catarina Albarradas Zapotec	\N
ztp	\N	\N	\N	I	L	Loxicha Zapotec	\N
ztq	\N	\N	\N	I	L	Quioquitani-Quierí Zapotec	\N
zts	\N	\N	\N	I	L	Tilquiapan Zapotec	\N
ztt	\N	\N	\N	I	L	Tejalapan Zapotec	\N
ztu	\N	\N	\N	I	L	Güilá Zapotec	\N
ztx	\N	\N	\N	I	L	Zaachila Zapotec	\N
zty	\N	\N	\N	I	L	Yatee Zapotec	\N
zuh	\N	\N	\N	I	L	Tokano	\N
zul	zul	zul	zu	I	L	Zulu	\N
zum	\N	\N	\N	I	L	Kumzari	\N
zun	zun	zun	\N	I	L	Zuni	\N
zuy	\N	\N	\N	I	L	Zumaya	\N
zwa	\N	\N	\N	I	L	Zay	\N
zxx	zxx	zxx	\N	S	S	No linguistic content	\N
zyb	\N	\N	\N	I	L	Yongbei Zhuang	\N
zyg	\N	\N	\N	I	L	Yang Zhuang	\N
zyj	\N	\N	\N	I	L	Youjiang Zhuang	\N
zyn	\N	\N	\N	I	L	Yongnan Zhuang	\N
zyp	\N	\N	\N	I	L	Zyphe Chin	\N
zza	zza	zza	\N	M	L	Zaza	\N
zzj	\N	\N	\N	I	L	Zuojiang Zhuang	\N
\.


--
-- Data for Name: bands; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands (id_band, band, likes, active, note) FROM stdin;
8b427a493fc39574fc801404bc032a2f	1000Mods	y	t	\N
721c28f4c74928cc9e0bb3fef345e408	Aborted	y	t	\N
0a7ba3f35a9750ff956dca1d548dad12	Abrogation	y	t	\N
54b72f3169fea84731d3bcba785eac49	Acranius	y	t	\N
d05a0e65818a69cc689b38c0c0007834	ADDICT	y	t	\N
dcabc7299e2b9ed5b05c33273e5fdd19	Aeon of Disease	y	t	\N
5ce10014f645da4156ddd2cd0965986e	Agnostic Front	y	t	\N
a332f1280622f9628fccd1b7aac7370a	Agrypnie	y	t	\N
249789ae53c239814de8e606ff717ec9	Airborn	m	t	\N
fe5b73c2c2cd2d9278c3835c791289b6	All its Grace	y	t	\N
942c9f2520684c22eb6216a92b711f9e	Amon Amarth	y	t	\N
7cd7921da2e6aab79c441a0c2ffc969b	Amorphis	y	t	\N
948098e746bdf1c1045c12f042ea98c2	Analepsy	y	t	\N
59d153c1c2408b702189623231b7898a	Angelus Apatrida	y	t	\N
06efe152a554665e02b8dc4f620bf3f1	Anthrax	y	t	\N
14ab730fe0172d780da6d9e5d432c129	AntiPeeWee	m	t	\N
449b4d758aa7151bc1bbb24c3ffb40bb	Anubis	m	t	\N
5df92b70e2855656e9b3ffdf313d7379	Anüs	y	t	\N
3e75cd2f2f6733ea4901458a7ce4236d	Apey & The Pea	n	t	\N
108c58fc39b79afc55fac7d9edf4aa2a	Arch Enemy	y	t	\N
28bc31b338dbd482802b77ed1fd82a50	Arroganz	y	t	\N
49c4097bae6c6ea96f552e38cfb6c2d1	Artillery	n	t	\N
e3f0bf612190af6c3fad41214115e004	Asomvel	y	t	\N
fb47f889f2c7c4fee1553d0f817b8aaa	Asphyx	y	t	\N
264721f3fc2aee2d28dadcdff432dbc1	Atomwinter	m	t	\N
9a322166803a48932356586f05ef83c7	At the Gates	y	t	\N
75ab0270163731ee05f35640d56ef473	Audrey Horne	m	t	\N
9d3ac6904ce73645c6234803cd7e47ca	Außerwelt	y	t	\N
d1fb4e47d8421364f49199ee395ad1d3	Aversions Crown	y	t	\N
44012166c6633196dc30563db3ffd017	Avowal	y	t	\N
905a40c3533830252a909603c6fa1e6a	Avulsed	y	t	\N
aed85c73079b54830cd50a75c0958a90	Baleful Abyss (Zombieslut)	y	t	\N
da2110633f62b16a571c40318e4e4c1c	Battle against the Empire	y	t	\N
529a1d385b4a8ca97ea7369477c7b6a7	Battle Beast	m	t	\N
be20385e18333edb329d4574f364a1f0	Behemoth	y	t	\N
ee69e7d19f11ca58843ec2e9e77ddb38	Benediction	y	t	\N
925bd435e2718d623768dbf1bc1cfb60	Benighted	y	t	\N
ad01952b3c254c8ebefaf6f73ae62f7d	Betrayal	y	t	\N
7c7ab6fbcb47bd5df1e167ca28220ee9	Betraying the Martyrs	m	t	\N
e8afde257f8a2cbbd39d866ddfc06103	Bitchfork	y	t	\N
8f1f10cb698cb995fd69a671af6ecd58	Black Crown Initiate	y	t	\N
bbddc022ee323e0a2b2d8c67e5cd321f	Black Medusa	y	t	\N
74b3b7be6ed71b946a151d164ad8ede5	Black Reunion	y	t	\N
d9ab6b54c3bd5b212e8dc3a14e7699ef	Blæck Fox	y	t	\N
679eaa47efb2f814f2642966ee6bdfe1	Blessed Hellride	y	t	\N
e1db3add02ca4c1af33edc5a970a3bdc	Blizzen	m	t	\N
1c6987adbe5ab3e4364685e8caed0f59	Bloodbound	y	t	\N
cf4ee20655dd3f8f0a553c73ffe3f72a	Blood Fire Death	y	t	\N
b3ffff8517114caf70b9e70734dbaf6f	Bloodred Hourglass	y	t	\N
a4cbfb212102da21b82d94be555ac3ec	Blood Red Throne	y	t	\N
10d91715ea91101cfe0767c812da8151	Bloodspot	y	t	\N
1209f43dbecaba22f3514bf40135f991	Bobby Sixkiller and the Renegades	y	t	\N
dcff9a127428ffb03fc02fdf6cc39575	Böhse Onkelz	m	t	\N
6c00bb1a64f660600a6c1545377f92dc	Bokassa	y	t	\N
55159d04cc4faebd64689d3b74a94009	Booze & Glory	m	t	\N
b6da055500e3d92698575a3cfc74906c	Born from Pain	m	t	\N
1e9413d4cc9af0ad12a6707776573ba0	Bösedeath	y	t	\N
b01fbaf98cfbc1b72e8bca0b2e48769c	Bowel Evacuation	y	t	\N
4b98a8c164586e11779a0ef9421ad0ee	Brainstorm	m	t	\N
897edb97d775897f69fa168a88b01c19	Brand of Sacrifice	y	t	\N
eeaeec364c925e0c821660c7a953546e	Broken Teeth	m	t	\N
7533f96ec01fd81438833f71539c7d4e	Bullet	m	t	\N
11635778f116ce6922f6068638a39028	Burn	m	t	\N
d449a9b2eed8b0556dc7be9cda36b67b	Bury Tomorrow	y	t	\N
7eaf9a47aa47f3c65595ae107feab05d	Caliban	y	t	\N
7463543d784aa59ca86359a50ef58c8e	Cancer	y	t	\N
c4f0f5cedeffc6265ec3220ab594d56b	Candlemass	m	t	\N
63bd9a49dd18fbc89c2ec1e1b689ddda	Cannibal Corpse	y	t	\N
63ae1791fc0523f47bea9485ffec8b8c	Carach Angren	y	t	\N
c4c7cb77b45a448aa3ca63082671ad97	Carnal Decay	y	t	\N
5435326cf392e2cd8ad7768150cd5df6	Carnation	y	t	\N
828d51c39c87aad9b1407d409fa58e36	CCCP	y	t	\N
d2ff1e521585a91a94fb22752dd0ab45	Chapel of Disease	y	t	\N
6f199e29c5782bd05a4fef98e7e41419	Circle of Execution	y	t	\N
6830afd7158930ca7d1959ce778eb681	Combichrist	y	t	\N
a61b878c2b563f289de2109fa0f42144	Conan	m	t	\N
e67e51d5f41cfc9162ef7fd977d1f9f5	Condemned	y	t	\N
3d2ff8abd980d730b2f4fd0abae52f60	Converge	m	t	\N
ffa7450fd138573d8ae665134bccd02c	Corpsessed	y	t	\N
faabbecd319372311ed0781d17b641d1	Counterparts	m	t	\N
9f19396638dd8111f2cee938fdf4e455	Critical Mess	y	t	\N
fdcbfded0aaf369d936a70324b39c978	Crossplane	y	t	\N
1056b63fdc3c5015cc4591aa9989c14f	Crusher	y	t	\N
b5d9c5289fe97968a5634b3e138bf9e2	Cryptopsy	y	t	\N
1734b04cf734cb291d97c135d74b4b87	Cytotoxin	y	t	\N
7d6b45c02283175f490558068d1fc81b	Dagoba	y	t	\N
8d7a18d54e82fcfb7a11566ce94b9109	Daily Insanity	y	t	\N
dddb04bc0d058486d0ef0212c6ea0682	Darkall Slaves	y	t	\N
0e2ea6aa669710389cf4d6e2ddf408c4	Darkened Nocturn Slaughtercult	y	t	\N
63ad3072dc5472bb44c2c42ede26d90f	Darkness	m	t	\N
2aae4f711c09481c8353003202e05359	Dark Zodiak	y	t	\N
28f843fa3a493a3720c4c45942ad970e	Dawn of Disease	y	t	\N
9bc2ca9505a273b06aa0b285061cd1de	Dead Congregation	y	t	\N
51fa80e44b7555c4130bd06c53f4835c	Cradle of Filth	y	t	\N
17bcf0bc2768911a378a55f42acedba7	Gwar	m	t	\N
ce2caf05154395724e4436f042b8fa53	Begging for Incest	y	t	\N
b0ce1e93de9839d07dab8d268ca23728	Colours of Autumn	y	t	\N
348bcdb386eb9cb478b55a7574622b7c	Bloodgod	y	f	\N
d3ed8223151e14b936436c336a4c7278	Batushka	y	t	Krzysztof Drabikowski's Batushka
b1bdad87bd3c4ac2c22473846d301a9e	Al Goregrind	m	f	\N
9138c2cc0326412f2515623f4c850eb3	Dead Eyed Sleeper (Legacy)	y	t	\N
44b7bda13ac1febe84d8607ca8bbf439	Death Angel	y	t	\N
d857ab11d383a7e4d4239a54cbf2a63d	Deathrite	y	t	\N
c74b5aa120021cbe18dcddd70d8622da	Deathstorm	y	t	\N
3af7c6d148d216f13f66669acb8d5c59	Debauchery's Balgeroth	y	t	\N
522b6c44eb0aedf4970f2990a2f2a812	Decapitated	y	t	\N
f4219e8fec02ce146754a5be8a85f246	Decaying Days	y	t	\N
c5f022ef2f3211dc1e3b8062ffe764f0	Defaced	y	t	\N
0ab20b5ad4d15b445ed94fa4eebb18d8	Defocus	y	t	\N
7fc454efb6df96e012e0f937723d24aa	Demored	y	t	\N
8edfa58b1aedb58629b80e5be2b2bd92	Denyal	y	t	\N
8589a6a4d8908d7e8813e9a1c5693d70	Depulsed	y	t	\N
947ce14614263eab49f780d68555aef8	Deranged	y	t	\N
7c83727aa466b3b1b9d6556369714fcf	Desbroce	y	t	\N
71e32909a1bec1edfc09aec09ca2ac17	Desdemonia	y	t	\N
3d01ff8c75214314c4ca768c30e6807b	Deserted Fear	y	t	\N
7771012413f955f819866e517b275cb4	Destinity	y	t	\N
36f969b6aeff175204078b0533eae1a0	Deströyer 666	y	t	\N
1bc1f7348d79a353ea4f594de9dd1392	Devil Driver	y	t	\N
2082a7d613f976e7b182a3fe80a28958	Dimmu Borgir	y	t	\N
d9bc1db8c13da3a131d853237e1f05b2	Disbelief	y	t	\N
9cf73d0300eea453f17c6faaeb871c55	Discreation	m	t	\N
4dddd8579760abb62aa4b1910725e73c	Disquiet	m	t	\N
d6de9c99f5cfa46352b2bc0be5c98c41	Dissecdead	y	t	\N
5194c60496c6f02e8b169de9a0aa542c	Double Crush Syndrome	m	t	\N
8654991720656374d632a5bb0c20ff11	Downfall of Gaia	m	t	\N
6a0e9ce4e2da4f2cbcd1292fddaa0ac6	Down to Nothing	m	t	\N
fe228019addf1d561d0123caae8d1e52	Dragonsfire	n	t	\N
1104831a0d0fe7d2a6a4198c781e0e0d	Dust Bolt	y	t	\N
889aaf9cd0894206af758577cf5cf071	Dyscarnate	y	t	\N
410d913416c022077c5c1709bf104d3c	EDGEBALL	n	t	\N
c5dc33e23743fb951b3fe7f1f477b794	Einherjer	y	t	\N
97ee29f216391d19f8769f79a1218a71	Eisregen	y	t	\N
b885447285ece8226facd896c04cdba2	Ektomorf	y	t	\N
f07c3eef5b7758026d45a12c7e2f6134	Embrace Decay	y	t	\N
0b6e98d660e2901c33333347da37ad36	Emerald	n	t	\N
6d3b28f48c848a21209a84452d66c0c4	Eminenz	y	t	\N
8c69497eba819ee79a964a0d790368fb	Endlevel	y	t	\N
1197a69404ee9475146f3d631de12bde	End of Green	y	t	\N
d730e65d54d6c0479561d25724afd813	Enforcer	n	t	\N
457f098eeb8e1518008449e9b1cb580d	Enisum	y	t	\N
ac94d15f46f10707a39c4bc513cd9f98	Enterprise Earth	y	t	\N
37f02eba79e0a3d29dfd6a4cf2f4d019	Epica	n	t	\N
39e83bc14e95fcbc05848fc33c30821f	Epicardiectomy	y	t	\N
f0c051b57055b052a3b7da1608f3039e	Eradicator	m	t	\N
e08383c479d96a8a762e23a99fd8bf84	Ereb Altor	m	t	\N
ff5b48d38ce7d0c47c57555d4783a118	Evertale	m	t	\N
8945663993a728ab19a3853e5b820a42	Evil Invaders	y	t	\N
28a95ef0eabe44a27f49bbaecaa8a847	Exhorder	y	t	\N
0cdf051c93865faa15cbc5cd3d2b69fb	Exodus	y	t	\N
4b503a03f3f1aec6e5b4d53dd8148498	Extermination Dismemberment	y	t	\N
887d6449e3544dca547a2ddba8f2d894	Exumer	y	t	\N
2672777b38bc4ce58c49cf4c82813a42	Fallen Temple	y	t	\N
832dd1d8efbdb257c2c7d3e505142f48	Far from ready	m	t	\N
f37ab058561fb6d233b9c2a0b080d4d1	Feuerschwanz	y	t	\N
3be3e956aeb5dc3b16285463e02af25b	Finsterforst	y	t	\N
42563d0088d6ac1a47648fc7621e77c6	Firtan	y	t	\N
7df8865bbec157552b8a579e0ed9bfe3	Five Finger Death Punch	y	t	\N
c883319a1db14bc28eff8088c5eba10e	Fjoergyn	y	t	\N
6b7cf117ecf0fea745c4c375c1480cb5	Fleshcrawl	y	t	\N
187ebdf7947f4b61e0725c93227676a4	Fleshgod Apocalypse	y	t	\N
4276250c9b1b839b9508825303c5c5ae	Fleshsphere	y	t	\N
7462f03404f29ea618bcc9d52de8e647	Flesh Trading Company	y	t	\N
5efb7d24387b25d8325839be958d9adf	Fracture	m	t	\N
9db9bc745a7568b51b3a968d215ddad6	From North	m	t	\N
cddf835bea180bd14234a825be7a7a82	Funeral Whore	y	t	\N
fdc90583bd7a58b91384dea3d1659cde	Furies	n	t	\N
401357e57c765967393ba391a338e89b	Ghost	y	t	\N
e64b94f14765cee7e05b4bec8f5fee31	Gingerpig	m	t	\N
d0a1fd0467dc892f0dc27711637c864e	God Dethroned	y	t	\N
e271e871e304f59e62a263ffe574ea2d	GodSkill	y	t	\N
a8d9eeed285f1d47836a5546a280a256	Godslave	y	t	\N
abbf8e3e3c3e78be8bd886484c1283c1	Grabak	y	t	\N
87f44124fb8d24f4c832138baede45c7	Grand Magus	y	t	\N
ed24ff8971b1fa43a1efbb386618ce35	Grave	y	t	\N
33b6f1b596a60fa87baef3d2c05b7c04	Grave Pleasures	m	t	\N
426fdc79046e281c5322161f011ce68c	Graveyard	y	t	\N
988d10abb9f42e7053450af19ad64c7f	Gut	n	t	\N
b89e91ccf14bfd7f485dd7be7d789b0a	H2O	m	t	\N
87ded0ea2f4029da0a0022000d59232b	Hadal Maw	m	t	\N
2a024edafb06c7882e2e1f7b57f2f951	Hailstone	m	t	\N
2fa2f1801dd37d6eb9fe4e34a782e397	Hämatom	y	t	\N
e0c2b0cc2e71294cd86916807fef62cb	Hammer King	m	t	\N
52ee4c6902f6ead006b0fb2f3e2d7771	Hängerbänd	y	t	\N
4f48e858e9ed95709458e17027bb94bf	Hark	y	t	\N
e0de9c10bbf73520385ea5dcbdf62073	Hatebreed	y	t	\N
065b56757c6f6a0fba7ab0c64e4c1ae1	Hate Eternal	y	t	\N
952dc6362e304f00575264e9d54d1fa6	Haunted Cemetery	y	t	\N
5cd1c3c856115627b4c3e93991f2d9cd	Havok	y	t	\N
0903a7e60f0eb20fdc8cc0b8dbd45526	Hell Boullevard	y	t	\N
32af59a47b8c7e1c982ae797fc491180	Hellknife	y	t	\N
fb8be6409408481ad69166324bdade9c	Hell:On	y	t	\N
bd4184ee062e4982b878b6b188793f5b	Hellripper	y	t	\N
0020f19414b5f2874a0bfacd9d511b84	Helrunar	y	t	\N
de12bbf91bc797df25ab4ae9cee1946b	Hexenizer	y	t	\N
237e378c239b44bff1e9a42ab866580c	Hierophant	y	t	\N
89adcf990042dfdac7fd23685b3f1e37	High Fighter	m	t	\N
44f2dc3400ce17fad32a189178ae72fa	Hills have Eyes	m	t	\N
3bd94845163385cecefc5265a2e5a525	Hollowed	y	t	\N
0b0d1c3752576d666c14774b8233889f	Hollow World	m	t	\N
3614c45db20ee41e068c2ab7969eb3b5	Ellende	y	t	\N
9d969d25c9f506c5518bb090ad5f8266	Embryectomy	y	t	\N
ade72e999b4e78925b18cf48d1faafa4	Exorcised Gods	y	t	\N
a4902fb3d5151e823c74dfd51551b4b0	Horisont	m	t	\N
99bd5eff92fc3ba728a9da5aa1971488	Horresque	y	t	\N
24ff2b4548c6bc357d9d9ab47882661e	Humator	y	t	\N
776da10f7e18ffde35ea94d144dc60a3	Hypocrisy	y	t	\N
829922527f0e7d64a3cfda67e24351e3	Ichor	y	t	\N
bfc9ace5d2a11fae56d038d68c601f00	I Declare War	y	t	\N
443866d78de61ab3cd3e0e9bf97a34f6	Igel vs. Shark	m	t	\N
b570e354b7ebc40e20029fcc7a15e5a7	Ignite	n	t	\N
7492a1ca2669793b485b295798f5d782	I'll be damned	m	t	\N
63d7f33143522ba270cb2c87f724b126	Illdisposed	y	t	\N
aa86b6fc103fc757e14f03afe6eb0c0a	Imperium Dekadenz	y	t	\N
91a337f89fe65fec1c97f52a821c1178	Inconcessus Lux Lucis	y	t	\N
5ec1e9fa36898eaf6d1021be67e0d00c	Indian Nightmare	n	t	\N
8ce896355a45f5b9959eb676b8b5580c	Infected World	m	t	\N
bbce8e45250a239a252752fac7137e00	In Flames	y	t	\N
baa9d4eef21c7b89f42720313b5812d4	Ingested	y	t	\N
2414366fe63cf7017444181acacb6347	Inhumate	y	t	\N
1ac0c8e8c04cf2d6f02fdb8292e74588	Insanity Alert	m	t	\N
5f992768f7bb9592bed35b07197c87d0	Insulter	m	t	\N
ca5a010309ffb20190558ec20d97e5b2	In the Woods	n	t	\N
f644bd92037985f8eb20311bc6d5ed94	Into Darkness	y	t	\N
a825b2b87f3b61c9660b81f340f6e519	Iron Bastards	m	t	\N
891a55e21dfacf2f97c450c77e7c3ea7	Iron Reagan	y	t	\N
ef6369d9794dbe861a56100e92a3c71d	Isole	m	t	\N
73affe574e6d4dc2fa72b46dc9dd4815	Jinjer	n	t	\N
649db5c9643e1c17b3a44579980da0ad	Kaasschaaf	y	t	\N
1e8563d294da81043c2772b36753efaf	Kadavar	m	t	\N
362f8cdd1065b0f33e73208eb358991d	Kambrium	y	t	\N
820de5995512273916b117944d6da15a	Kataklysm	y	t	\N
6d57b25c282247075f5e03cde27814df	Knockdown Brutality	y	t	\N
bbb668ff900efa57d936e726a09e4fe8	Korpiklaani	y	t	\N
2501f7ba78cc0fd07efb7c17666ff12e	Korpse	y	t	\N
76700087e932c3272e05694610d604ba	Kosmokrator	m	t	\N
9b1088b616414d0dc515ab1f2b4922f1	Kreator	y	t	\N
dfdef9b5190f331de20fe029babf032e	Lacrimas Profundere	m	t	\N
4cfab0d66614c6bb6d399837656c590e	Legion of the Damned	y	t	\N
5b22d1d5846a2b6b6d0cf342e912d124	Light to the blind	m	t	\N
4261335bcdc95bd89fd530ba35afbf4c	Liver Values	m	t	\N
2cfe35095995e8dd15ab7b867e178c15	Lonewolf	y	t	\N
2cf65e28c586eeb98daaecf6eb573e7a	Lordi	m	t	\N
3cdb47307aeb005121b09c41c8d8bee6	Los Skeleteros	y	t	\N
53407737e93f53afdfc588788b8288e8	Lyra's Legacy	n	t	\N
006fc2724417174310cf06d2672e34d2	Määt	y	t	\N
7db066b46f48d010fdb8c87337cdeda4	Madball	y	t	\N
a3f5542dc915b94a5e10dab658bb0959	Manegarm	y	t	\N
2ac79000a90b015badf6747312c0ccad	Mantar	y	t	\N
eb2c788da4f36fba18b85ae75aff0344	Marduk	y	t	\N
626dceb92e4249628c1e76a2c955cd24	Meatknife	y	t	\N
8fda25275801e4a40df6c73078baf753	Mecalimb	m	t	\N
3a2a7f86ca87268be9b9e0557b013565	Membaris	m	t	\N
ac03fad3be179a237521ec4ef2620fb0	Metal Inquisitor	n	t	\N
8b0ee5a501cef4a5699fd3b2d4549e8f	Metallica	y	t	\N
7e2b83d69e6c93adf203e13bc7d6f444	Milking the Goatmachine	y	t	\N
0fbddeb130361265f1ba6f86b00f0968	Mindflair	y	t	\N
3f15c445cb553524b235b01ab75fe9a6	Ministry	y	t	\N
656d1497f7e25fe0559c6be81a4bccae	Misery Index	y	t	\N
f60ab90d94b9cafe6b32f6a93ee8fcda	Mizery	m	t	\N
8775f64336ee5e9a8114fbe3a5a628c5	MØL	y	t	\N
e872b77ff7ac24acc5fa373ebe9bb492	Molotov	y	t	\N
f0e1f32b93f622ea3ddbf6b55b439812	Mono Inc.	m	t	\N
53a0aafa942245f18098ccd58b4121aa	Moontowers	n	t	\N
0780d2d1dbd538fec3cdd8699b08ea02	Morasth	y	t	\N
4a45ac6d83b85125b4163a40364e7b2c	More Than A Thousand	m	t	\N
2252d763a2a4ac815b122a0176e3468f	Mosaic	y	t	\N
11d396b078f0ae37570c8ef0f45937ad	Motörblast	y	t	\N
585b13106ecfd7ede796242aeaed4ea8	Motorowl	y	t	\N
6c1fcd3c91bc400e5c16f467d75dced3	Mr. Irish Bastard	y	t	\N
a7f9797e4cd716e1516f9d4845b0e1e2	Municipal Waste	m	t	\N
7d878673694ff2498fbea0e5ba27e0ea	Nailed to Obscurity	y	t	\N
0844ad55f17011abed4a5208a3a05b74	Napalm Death	y	t	\N
6738f9acd4740d945178c649d6981734	Nasty	m	t	\N
33f03dd57f667d41ac77c6baec352a81	need2destroy	y	t	\N
3509af6be9fe5defc1500f5c77e38563	Nekrovault	y	t	\N
0640cfbf1d269b69c535ea4e288dfd96	Nepumuc	m	t	\N
a716390764a4896d99837e99f9e009c9	Nervosa	y	t	\N
e74a88c71835c14d92d583a1ed87cc6c	Nifelheim	y	t	\N
3d6ff25ab61ad55180a6aee9b64515bf	Nile	y	t	\N
36648510adbf2a3b2028197a60b5dada	NIOR	y	t	\N
eb3bfb5a3ccdd4483aabc307ae236066	No Brainer	y	t	\N
1ebd63d759e9ff532d5ce63ecb818731	Nocte Obducta	m	t	\N
1c06fc6740d924cab33dce73643d84b9	Nocturnal Graves	y	t	\N
4a2a0d0c29a49d9126dcb19230aa1994	No Return	y	t	\N
059792b70fc0686fb296e7fcae0bda50	Obscenity	m	t	\N
7dfe9aa0ca5bb31382879ccd144cc3ae	Of Colours	y	t	\N
a650d82df8ca65bb69a45242ab66b399	Omnium Gatherum	y	t	\N
3dda886448fe98771c001b56a4da9893	Omophagia	y	t	\N
d73310b95e8b4dece44e2a55dd1274e6	Orbit Culture	y	t	\N
fb28e62c0e801a787d55d97615e89771	Orcus Patera	y	t	\N
652208d2aa8cdd769632dbaeb7a16358	Orden Ogan	y	t	\N
660813131789b822f0c75c667e23fc85	Overkill	m	t	\N
b5f7b25b0154c34540eea8965f90984d	Pain City	y	t	\N
a7a9c1b4e7f10bd1fdf77aff255154f7	Papa Roach	m	t	\N
e64d38b05d197d60009a43588b2e4583	Paradise Lost	m	t	\N
88711444ece8fe638ae0fb11c64e2df3	Party Cannon	y	t	\N
278c094627c0dd891d75ea7a3d0d021e	Paxtilence	y	t	\N
0a56095b73dcbd2a76bb9d4831881cb3	Phantom Winter	n	t	\N
ff578d3db4dc3311b3098c8365d54e6b	Pighead	y	t	\N
80fcd08f6e887f6cfbedd2156841ab2b	P.O. Box	y	t	\N
db38e12f9903b156f9dc91fce2ef3919	Pokerface	m	t	\N
58db028cf01dd425e5af6c7d511291c1	Moronic	y	f	\N
6c607fc8c0adc99559bc14e01170fee1	Incite	y	t	\N
90d127641ffe2a600891cd2e3992685b	Poltergeist	m	t	\N
2e7a848dc99bd27acb36636124855faf	Porn the Gore	y	t	\N
79566192cda6b33a9ff59889eede2d66	Power Trip	y	t	\N
3964d4f40b6166aa9d370855bd20f662	Prediction	y	t	\N
4548a3b9c1e31cf001041dc0d166365b	Pripjat	y	t	\N
450948d9f14e07ba5e3015c2d726b452	Promethee	y	t	\N
c4678a2e0eef323aeb196670f2bc8a6e	Prostitute Desfigurement	y	t	\N
c1923ca7992dc6e79d28331abbb64e72	Psycroptic	y	t	\N
5842a0c2470fe12ee3acfeec16c79c57	Public Grave	y	t	\N
96682d9c9f1bed695dbf9176d3ee234c	Purify	y	t	\N
7f29efc2495ce308a8f4aa7bfc11d701	Randy Hansen	y	t	\N
12e93f5fab5f7d16ef37711ef264d282	Raw Ensemble	y	t	\N
4094ffd492ba473a2a7bea1b19b1662d	Reactory	y	t	\N
02d44fbbe1bfacd6eaa9b20299b1cb78	Rectal Smegma	y	t	\N
9ab8f911c74597493400602dc4d2b412	Refuge	y	t	\N
11f8d9ec8f6803ea61733840f13bc246	Relics of Humanity	y	t	\N
54f0b93fa83225e4a712b70c68c0ab6f	Revelation Steel	m	t	\N
1cdd53cece78d6e8dffcf664fa3d1be2	Revel in Flesh	y	t	\N
1e88302efcfc873691f0c31be4e2a388	Rezet	y	t	\N
2af9e4497582a6faa68a42ac2d512735	Rings of Saturn	y	t	\N
13caf3d14133dfb51067264d857eaf70	Risk it	y	t	\N
1e14d6b40d8e81d8d856ba66225dcbf3	Riverroth	m	t	\N
5b20ea1312a1a21beaa8b86fe3a07140	Rivers of Nihil	y	t	\N
fa03eb688ad8aa1db593d33dabd89bad	Root	y	t	\N
7a4fafa7badd04d5d3114ab67b0caf9d	Saltatio Mortis	n	t	\N
4cabe475dd501f3fd4da7273b5890c33	Samael	y	t	\N
f8e7112b86fcd9210dfaf32c00d6d375	Sanguine	n	t	\N
91c9ed0262dea7446a4f3a3e1cdd0698	Satan's Fall	n	t	\N
79ce9bd96a3184b1ee7c700aa2927e67	Schizophrenia	y	t	\N
218f2bdae8ad3bb60482b201e280ffdc	Scordatura	y	t	\N
4927f3218b038c780eb795766dfd04ee	Scornebeke	y	t	\N
0a97b893b92a7df612eadfe97589f242	Scrvmp	y	t	\N
31d8a0a978fad885b57a685b1a0229df	Seii Taishogun	y	t	\N
7ef36a3325a61d4f1cff91acbe77c7e3	Sensles	m	t	\N
5b709b96ee02a30be5eee558e3058245	Sepultura	y	t	\N
19baf8a6a25030ced87cd0ce733365a9	Serrabulho	y	t	\N
91b18e22d4963b216af00e1dd43b5d05	Shoot the Girl first	n	t	\N
6bd19bad2b0168d4481b19f9c25b4a9f	Shores of Null	y	t	\N
53369c74c3cacdc38bdcdeda9284fe3c	Siberian Meat Grinder	y	t	\N
6bafe8cf106c32d485c469d36c056989	Sick of it all	y	t	\N
66599a31754b5ac2a202c46c2b577c8e	Six Feet Under	m	t	\N
4453eb658c6a304675bd52ca75fbae6d	Skeleton Pit	y	t	\N
5e4317ada306a255748447aef73fff68	Skeletonwitch	y	t	\N
360c000b499120147c8472998859a9fe	Skinned Alive	y	t	\N
e62a773154e1179b0cc8c5592207cb10	Skull Fist	n	t	\N
4bb93d90453dd63cc1957a033f7855c7	Slaughterra	y	t	\N
f29d276fd930f1ad7687ed7e22929b64	Sleepers' Guilt	y	t	\N
249229ca88aa4a8815315bb085cf4d61	Slipknot	y	t	\N
c05d504b806ad065c9b548c0cb1334cd	Sober Truth	m	t	\N
b96a3cb81197e8308c87f6296174fe3e	Sodom	y	t	\N
8edf4531385941dfc85e3f3d3e32d24f	Soilwork	y	t	\N
90d523ebbf276f516090656ebfccdc9f	Solstafir	n	t	\N
94ca28ea8d99549c2280bcc93f98c853	Soulburn	y	t	\N
076365679712e4206301117486c3d0ec	Soulfly	y	t	\N
abd7ab19ff758cf4c1a2667e5bbac444	Spasm	y	t	\N
0af74c036db52f48ad6cbfef6fee2999	Stam1na	y	t	\N
095849fbdc267416abc6ddb48be311d7	Stillbirth	y	t	\N
72778afd2696801f5f3a1f35d0e4e357	Still Patient?	m	t	\N
5c0adc906f34f9404d65a47eea76dac0	Stonefall	y	t	\N
fdcf3cdc04f367257c92382e032b6293	Storm	y	t	\N
8bc31f7cc79c177ab7286dda04e2d1e5	Street Dogs	y	t	\N
88dd124c0720845cba559677f3afa15d	Sucking Leech	y	t	\N
2df8905eae6823023de6604dc5346c29	Suicidal Angels	y	t	\N
7e0d5240ec5d34a30b6f24909e5edcb4	Suicidal Tendencies	y	t	\N
f4f870098db58eeae93742dd2bcaf2b2	Sulphur Aeon	y	t	\N
d433b7c1ce696b94a8d8f72de6cfbeaa	Sun of the Sleepless	y	t	\N
28bb59d835e87f3fd813a58074ca0e11	Supreme Carnage	y	t	\N
bbc155fb2b111bf61c4f5ff892915e6b	Switch	y	t	\N
f953fa7b33e7b6503f4380895bbe41c8	Take Offense	m	t	\N
ad62209fb63910acf40280cea3647ec5	Task Force Beer	y	t	\N
0a267617c0b5b4d53e43a7d4e4c522ad	Teethgrinder	y	t	\N
058fcf8b126253956deb3ce672d107a7	Terror	y	t	\N
b14814d0ee12ffadc8f09ab9c604a9d0	Testament	y	t	\N
5447110e1e461c8c22890580c796277a	The black Dahlia Murder	y	t	\N
9e84832a15f2698f67079a3224c2b6fb	The Creatures from the Tomb	y	t	\N
4a7d9e528dada8409e88865225fb27c4	The Feelgood McLouds	y	t	\N
d3e98095eeccaa253050d67210ef02bb	The Idiots	y	t	\N
c3490492512b7fe65cdb0c7305044675	The Jailbreakers	y	t	\N
e61e30572fd58669ae9ea410774e0eb6	The Monolith Project	y	t	\N
990813672e87b667add44c712bb28d3d	The Ominous Circle	y	t	\N
8143ee8032c71f6f3f872fc5bb2a4fed	The Phobos Ensemble	m	t	\N
485065ad2259054abf342d7ae3fe27e6	The Privateer	m	t	\N
278606b1ac0ae7ef86e86342d1f259c3	The Prophecy 23	y	t	\N
c127f32dc042184d12b8c1433a77e8c4	The Vintage Caravan	m	t	\N
e4b3296f8a9e2a378eb3eb9576b91a37	Thornafire	y	t	\N
09d8e20a5368ce1e5c421a04cb566434	Thrudvangar	y	t	\N
4366d01be1b2ddef162fc0ebb6933508	Thunderstorm	m	t	\N
46174766ce49edbbbc40e271c87b5a83	Thy Antichrist	y	t	\N
4fa857a989df4e1deea676a43dceea07	Too many Assholes	y	t	\N
36cbc41c1c121f2c68f5776a118ea027	Tornado	m	t	\N
da867941c8bacf9be8e59bc13d765f92	Traitors	y	t	\N
6ee2e6d391fa98d7990b502e72c7ec58	Trancemission	m	t	\N
a4977b96c7e5084fcce21a0d07b045f8	Tribulation	y	t	\N
1da77fa5b97c17be83cc3d0693c405cf	Twitching Tongues	m	t	\N
e0f39406f0e15487dd9d3997b2f5ca61	Übergang	y	t	\N
399033f75fcf47d6736c9c5209222ab8	Undertow	y	t	\N
6f195d8f9fe09d45d2e680f7d7157541	Une Misere	y	t	\N
cafe9e68e8f90b3e1328da8858695b31	Tankard	y	t	\N
4ee21b1371ba008a26b313c7622256f8	Shambala	m	f	\N
2113f739f81774557041db616ee851e6	Unleashed	m	t	\N
32814ff4ca9a26b8d430a8c0bc8dc63e	Ur	y	t	\N
e29ef4beb480eab906ffa7c05aeec23d	Vader	y	t	\N
2447873ddeeecaa165263091c0cbb22f	Vargsheim	y	t	\N
86482a1e94052aa18cd803a51104cdb9	Vektor	y	t	\N
fcd1c1b547d03e760d1defa4d2b98783	Victorius	n	t	\N
6369ba49db4cf35b35a7c47e3d4a4fd0	Visdom	m	t	\N
935b48a84528c4280ec208ce529deea0	Visions of Disfigurement	y	t	\N
52b133bfecec2fba79ecf451de3cf3bb	Völkerball	y	t	\N
559ccea48c3460ebc349587d35e808dd	Vomitory	y	t	\N
8e11b2f987a99ed900a44aa1aa8bd3d0	Vortex	n	t	\N
59f06d56c38ac98effb4c6da117b0305	Walls of Jericho	y	t	\N
804803e43d2c779d00004a6e87f28e30	Warbringer	y	t	\N
f042da2a954a1521114551a6f9e22c75	Warfield	y	t	\N
b1d465aaf3ccf8701684211b1623adf2	Warkings	m	t	\N
4f840b1febbbcdb12b9517cd0a91e8f4	When Plagues Collide	y	t	\N
c2855b6617a1b08fed3824564e15a653	Whitechapel	m	t	\N
405c7f920b019235f244315a564a8aed	Who killed Janis	m	t	\N
8e62fc75d9d0977d0be4771df05b3c2f	Wintersun	y	t	\N
cd9483c1733b17f57d11a77c9404893c	Wisdom in Chains	m	t	\N
3656edf3a40a25ccd00d414c9ecbb635	Witchfucker	y	t	\N
6d89517dbd1a634b097f81f5bdbb07a2	Witchhunter	m	t	\N
db46d9a37b31baa64cb51604a2e4939a	Within Destruction	y	t	\N
5af874093e5efcbaeb4377b84c5f2ec5	Wizard	m	t	\N
8a6f1a01e4b0d9e272126a8646a72088	Wolfheart	y	t	\N
5037c1968f3b239541c546d32dec39eb	World of Tomorrow	m	t	\N
3e52c77d795b7055eeff0c44687724a1	Xaon	y	t	\N
5952dff7a6b1b3c94238ad3c6a42b904	Zebrahead	m	t	\N
deaccc41a952e269107cc9a507dfa131	Zodiac	y	t	\N
bb4cc149e8027369e71eb1bb36cd98e0	Zombi	m	t	\N
754230e2c158107a2e93193c829e9e59	Crisix	y	t	\N
a29c1c4f0a97173007be3b737e8febcc	Redgrin	y	t	\N
4fab532a185610bb854e0946f4def6a4	Torment of Souls	y	t	\N
e25ee917084bdbdc8506b56abef0f351	Skelethal	y	t	\N
e6fd7b62a39c109109d33fcd3b5e129d	Keitzer	y	t	\N
da29e297c23e7868f1d50ec5a6a4359b	Blodtåke	y	t	\N
96048e254d2e02ba26f53edd271d3f88	Souldevourer	y	t	\N
c2275e8ac71d308946a63958bc7603a1	Fabulous Desaster	y	t	\N
3bcbddf6c114327fc72ea06bcb02f9ef	Satan Worship	y	t	\N
dde3e0b0cc344a7b072bbab8c429f4ff	The Laws Kill Destroy (Fábio Jhasko's Sarcófago tribute)	y	t	\N
b785a5ffad5e7e36ccac25c51d5d8908	Mortal Peril	y	t	\N
63c0a328ae2bee49789212822f79b83f	Infected Inzestor	y	t	\N
83d15841023cff02eafedb1c87df9b11	Birdflesh	m	t	\N
f03bde11d261f185cbacfa32c1c6538c	Master	y	t	\N
f6540bc63be4c0cb21811353c0d24f69	Misanthropia	y	t	\N
ea16d031090828264793e860a00cc995	Severe Torture	y	t	\N
5eed658c4b7b68a0ecc49205b68d54e7	Undying Lust for Cadaverous Molestation (UxLxCxM)	y	t	\N
96e3cdb363fe6df2723be5b994ad117a	Lecks inc.	y	t	\N
4ad6c928711328d1cf0167bc87079a14	Hate	y	t	\N
a0fb30950d2a150c1d2624716f216316	Belphegor	y	t	\N
c8d551145807972d194691247e7102a2	I am Morbid	y	t	\N
45b568ce63ea724c415677711b4328a7	Baest	y	t	\N
145bd9cf987b6f96fa6f3b3b326303c9	Der rote Milan	y	t	\N
c238980432ab6442df9b2c6698c43e47	Äera	y	t	\N
39a25b9c88ce401ca54fd7479d1c8b73	Jesajah	y	t	\N
8cadf0ad04644ce2947bf3aa2817816e	Balberskult	y	t	\N
85fac49d29a31f1f9a8a18d6b04b9fc9	Hellburst	y	t	\N
b81ee269be538a500ed057b3222c86a2	Crypts	y	t	\N
5518086aebc9159ba7424be0073ce5c9	Wound	y	t	\N
2c4e2c9948ddac6145e529c2ae7296da	Venefixion	y	t	\N
c9af1c425ca093648e919c2e471df3bd	Asagraum	y	t	\N
0291e38d9a3d398052be0ca52a7b1592	Possession	y	t	\N
8852173e80d762d62f0bcb379d82ebdb	Grave Miasma	m	t	\N
000f49c98c428aff4734497823d04f45	Sacramentum﻿	m	t	\N
dea293bdffcfb292b244b6fe92d246dc	Impaled Nazarene	m	t	\N
cf71a88972b5e06d8913cf53c916e6e4	Bloodland	y	t	\N
ac62ad2816456aa712809bf01327add1	LAWMÄNNER	n	t	\N
302ebe0389198972c223f4b72894780a	Stagewar	m	t	\N
470f3f69a2327481d26309dc65656f44	The Fog	y	t	\N
e254616b4a5bd5aaa54f90a3985ed184	Goath	y	t	\N
3c5c578b7cf5cc0d23c1730d1d51436a	Velvet Viper	n	t	\N
eaeaed2d9f3137518a5c8c7e6733214f	Elmsfire	m	t	\N
8ccd65d7f0f028405867991ae3eaeb56	Poisöned Speed	y	t	\N
781acc7e58c9a746d58f6e65ab1e90c4	Harakiri For The Sky	y	t	\N
e5a674a93987de4a52230105907fffe9	Nachtblut	y	t	\N
a2459c5c8a50215716247769c3dea40b	Mister Misery	m	t	\N
e285e4ecb358b92237298f67526beff7	Pyogenesis	n	t	\N
d832b654664d104f0fbb9b6674a09a11	Schöngeist	y	t	\N
2aeb128c6d3eb7e79acb393b50e1cf7b	Enter Tragedy	y	t	\N
213c449bd4bcfcdb6bffecf55b2c30b4	Erdling	y	t	\N
4ea353ae22a1c0d26327638f600aeac8	Stahlmann	y	t	\N
66244bb43939f81c100f03922cdc3439	Sabaton	y	t	\N
a538bfe6fe150a92a72d78f89733dbd0	The Spirit	y	t	\N
02f36cf6fe7b187306b2a7d423cafc2c	Orca	y	t	\N
26830d74f9ed8e7e4ea4e82e28fa4761	Kryn	m	t	\N
ccff6df2a54baa3adeb0bddb8067e7c0	V.I.D.A	y	t	\N
368ff974da0defe085637b7199231c0a	Impartial	m	t	\N
c2e88140e99f33883dac39daee70ac36	Lycanthrope	m	t	\N
93f4aac22b526b5f0c908462da306ffc	Speedemon	y	t	\N
1bb6d0271ea775dfdfa7f9fe1048147a	Almøst Human	y	t	\N
f17c7007dd2ed483b9df587c1fdac2c7	Moral Putrefaction	y	t	\N
03022be9e2729189e226cca023a2c9bf	Cadaver	y	t	\N
4d79c341966242c047f3833289ee3a13	Criminal	y	t	\N
32921081f86e80cd10138b8959260e1a	Tranatopsy	y	t	\N
3041a64f7587a6768d8e307b2662785b	Ludicia	y	t	\N
ab7b69efdaf168cbbe9a5b03d901be74	Komodo	m	t	\N
8259dc0bcebabcb0696496ca406dd672	Typhus	m	t	\N
57b9fe77adaac4846c238e995adb6ee2	Múr	y	t	\N
2654d6e7cec2ef045ca1772a980fbc4c	Fusion Bomb	y	t	\N
6a8538b37162b23d68791b9a0c54a5bf	Mork	y	t	\N
3921cb3f97a88349e153beb5492f6ef4	Gaerea	y	t	\N
f9f57e175d62861bb5f2bda44a078df7	Kampfar	m	t	\N
9ee30f495029e1fdf6567045f2079be1	Crypta	y	t	\N
57eba43d6bec2a8115e94d6fbb42bc75	Lost Society	n	t	\N
071dbd416520d14b2e3688145801de41	Venom	y	t	\N
9fc7c7342d41c7c53c6e8e4b9bc53fc4	Moonspell	n	t	\N
5588cb8830fdb8ac7159b7cf5d1e611e	Striker	n	t	\N
a5a8afc6c35c2625298b9ce4cc447b39	Auðn	y	t	\N
6ff24c538936b5b53e88258f88294666	Ill Niño	m	t	\N
d399575133268305c24d87f1c2ef054a	Implore	y	t	\N
71e720cd3fcc3cdb99f2f4dc7122e078	Mythraeum	y	t	\N
743c89c3e93b9295c1ae6e750047fb1e	The Risen Dread	y	t	\N
e4f0ad5ef0ac3037084d8a5e3ca1cabc	Pestilence	y	t	\N
c58de8415b504a6ffa5d0b14967f91bb	Onslaught	y	t	\N
2d1f30c9fc8d7200bdf15b730c4cd757	Blood Incantation	y	t	\N
a1cebab6ecfd371779f9c18e36cbba0c	Cattle Decapitation	y	t	\N
54c09bacc963763eb8742fa1da44a968	Misanthropic	y	t	\N
0870b61c5e913cb405d250e80c9ba9b9	Leng Tch'e	y	t	\N
e563e0ba5dbf7c9417681c407d016277	Bloodtruth	y	t	\N
1745438c6be58479227d8c0d0220eec5	Organectomy	y	t	\N
7e5550d889d46d55df3065d742b5da51	Gutslit	y	t	\N
393a71c997d856ed5bb85a9695be6e46	Coffin Feeder	y	t	\N
20f0ae2f661bf20e506108c40c33a6f3	Suffocation	y	t	\N
3ed0c2ad2c9e6e7b161e6fe0175fe113	Acéldama	y	t	\N
96604499bfc96fcdb6da0faa204ff2fe	Gore Dimension	y	t	\N
dd18fa7a5052f2bce8ff7cb4a30903ea	Gutalax	y	t	\N
fd9a5c27c20cd89e4ffcc1592563abcf	Bound to Prevail	y	t	\N
a5475ebd65796bee170ad9f1ef746394	Basement Torture Killings	y	t	\N
1fda271217bb4c043c691fc6344087c1	Kanine	y	t	\N
cba95a42c53bdc6fbf3ddf9bf10a4069	Profanity	y	t	\N
fe2c9aea6c702e6b82bc19b4a5d76f90	Hurakan	y	t	\N
bb66c20c42c26f1874525c3ab956ec41	Brutal Sphincter	y	t	\N
aad365e95c3d5fadb5fdf9517c371e89	Tortharry	y	t	\N
88a51a2e269e7026f0734f3ef3244e89	Human Prey	y	t	\N
5c1a922f41003eb7a19b570c33b99ff4	Phrymerial	y	t	\N
de506362ebfcf7c632d659aa1f2b465d	Cumbeast	y	t	\N
1a8780e5531549bd454a04630a74cd4d	Monasteries	y	t	\N
c0d7362d0f52d119f1beb38b12c0b651	Côte D' Aver	y	t	\N
edd506a412c4f830215d4c0f1ac06e55	Vomit the Soul	y	t	\N
dde31adc1b0014ce659a65c8b4d6ce42	Endseeker	y	t	\N
4267b5081fdfb47c085db24b58d949e0	Wormed	y	t	\N
8f7de32e3b76c02859d6b007417bd509	Beheaded	y	t	\N
332d6b94de399f86d499be57f8a5a5ca	Shores of Lunacy	y	t	\N
b73377a1ec60e58d4eeb03347268c11b	April in Flames	y	t	\N
e3419706e1838c7ce6c25a28bef0c248	Asinis	y	t	\N
382ed38ecc68052678c5ac5646298b63	Mike Litoris Complot	y	t	\N
213c302f84c5d45929b66a20074075df	Lesson in Violence	y	t	\N
22c030759ab12f97e941af558566505e	Urinal Tribunal	y	t	\N
f5507c2c7beee622b98ade0b93abb7fe	Melodramatic Fools	y	t	\N
41bee031bd7d2fdb14ff48c92f4d7984	Cypecore	y	t	\N
39a464d24bf08e6e8df586eb5fa7ee30	Shot Crew	y	t	\N
f7c3dcc7ba01d0ead8e0cfb59cdf6afc	Impending Mindfuck	y	t	\N
4b42093adfc268ce8974a3fa8c4f6bca	Thron	y	t	\N
70d0b58ef51e537361d676f05ea39c7b	Heretoir	m	t	\N
6f0eadd7aadf134b1b84d9761808d5ad	Asphagor	y	t	\N
6896f30283ad47ceb4a17c8c8d625891	Drill Star Autopsy	y	t	\N
25118c5df9a2865a8bc97feb4aff4a18	Zero Degree	y	t	\N
5a53bed7a0e05c2b865537d96a39646f	Ferndal	y	t	\N
29b7417c5145049d6593a0d88759b9ee	Avataria	y	t	\N
4176aa79eae271d1b82015feceb00571	Graveworm	y	t	\N
c81794404ad68d298e9ceb75f69cf810	Agathodaimon	y	t	\N
d0386252fd85f76fc517724666cf59ae	Iron Savior	n	t	\N
0cddbf403096e44a08bc37d1e2e99b0f	Saxorior	y	t	\N
546bb05114b78748d142c67cdbdd34fd	Empyreal	y	t	\N
4ac863b6f6fa5ef02afdd9c1ca2a5e24	Eridu	y	t	\N
1e2bcbb679ccfdea27b28bd1ea9f2e67	Jarl	y	t	\N
0b9d35d460b848ad46ec0568961113bf	Torian	n	t	\N
b7e529a8e9af2a2610182b3d3fc33698	Machine Head	y	t	\N
1c62394f457ee9a56b0885f622299ea2	The Halo Effect	y	t	\N
64d9f86ed9eeac2695ec7847fe7ea313	Credic	y	t	\N
b04d1a151c786ee00092110333873a37	Glemsel	y	t	\N
65b029279eb0f99c0a565926566f6759	Naxen	y	t	\N
9bfbfab5220218468ecb02ed546e3d90	Horns of Domination	y	t	\N
be41b6cfece7dfa1b4e4d226fb999607	Beltez	y	t	\N
9c158607f29eaf8f567cc6304ada9c6d	Ninkharsag	y	t	\N
ca7e3b5c1860730cfd7b400de217fef2	Hemelbestormer	y	t	\N
8f4e7c5f66d6ee5698c01de29affc562	Algebra	y	t	\N
f0bf2458b4c1a22fc329f036dd439f08	Comaniac	y	t	\N
25fa2cdf2be085aa5394db743677fb69	Cryptosis	y	t	\N
32917b03e82a83d455dd6b7f8609532c	Fatal Fire	n	t	\N
0bcf509f7eb2db3b663f5782c8c4a86e	Dispised Icon	y	t	\N
4ffc374ef33b65b6acb388167ec542c0	Viscera	y	t	\N
42c9b99c6b409bc9990658f6e7829542	Oceano	y	t	\N
0c2277f470a7e9a2d70195ba32e1b08a	Distant	y	t	\N
47b23e889175dde5d6057db61cb52847	Crowbar	y	t	\N
bb51d2b900ba638568e48193aada8a6c	Sacred Reich	y	t	\N
92df3fd170b0285cd722e855a2968393	Guineapig	y	t	\N
b20a4217acaf4316739c6a5f6679ef60	Plasma	y	t	\N
34b1dade51ffdab56daebcf6ac981371	The Hu	y	t	\N
9d57ebbd1d3b135839b78221388394a1	Volbeat	y	t	\N
1833e2cfde2a7cf621d60288da14830c	Bad Wolves	m	t	\N
65976b6494d411d609160a2dfd98f903	Skindred	m	t	\N
178227c5aef3b3ded144b9e19867a370	Diaroe	y	t	\N
75cde58f0e5563f287f2d4afb0ce4b7e	Depression	y	t	\N
b74881ac32a010e91ac7fcbcfebe210e	Placenta Powerfist	y	t	\N
351af29ee203c740c3209a0e0a8e9c22	Fulci	y	t	\N
bbdbdf297183a1c24be29ed89711f744	Revocation	y	t	\N
6e512379810ecf71206459e6a1e64154	Goatwhore	y	t	\N
f3b65f675d13d81c12d3bb30b0190cd1	Alluvial	y	t	\N
1918775515a9c7b8db011fd35a443b82	Creeping Death	y	t	\N
15bf34427540dd1945e5992583412b2f	Dropdead	y	t	\N
ba8033b8cfb1ebfc91a5d03b3a268d9f	Escuela Grind	y	t	\N
fd85bfffd5a0667738f6110281b25db8	Necrotted	y	t	\N
6e4b91e3d1950bcad012dbfbdd0fff09	Legal Hate	y	t	\N
32a02a8a7927de4a39e9e14f2dc46ac6	Deep Dirty	y	t	\N
747f992097b9e5c9df7585931537150a	Blood	y	t	\N
13c260ca90c0f47c9418790429220899	Schirenc Plays Pungent Stench	y	t	\N
19819b153eb0990c821bc106e34ab3e1	Mason	y	t	\N
b619e7f3135359e3f778e90d1942e6f5	Antagonism	y	t	\N
0ddd0b1b6329e9cb9a64c4d947e641a8	Plagueborne	y	t	\N
30354302ae1c0715ccad2649da3d9443	Orobas	y	t	\N
89eec5d48b8969bf61eea38e4b3cfdbf	Kilminister	y	t	\N
703b1360391d2aef7b9ec688b00849bb	Vomit Spell	y	t	\N
b4b46e6ce2c563dd296e8bae768e1b9d	Servant	y	t	\N
5c8c8b827ae259b8e4f8cb567a577a3e	Shaârghot	y	t	\N
7f00429970ee9fd2a3185f777ff79922	Ragnarök Nordic & Viking Folk	y	t	\N
92e2cf901fe43bb77d99af2ff42ade77	Perchta	y	t	\N
1a1bfb986176c0ba845ae4f43d027f58	Estampie	y	t	\N
7ecdb1a0eb7c01d081acf2b7e11531c0	Rauhbein	y	t	\N
094caa14a3a49bf282d8f0f262a01f43	Apocalypse Orchestra	y	t	\N
c4ddbffb73c1c34d20bd5b3f425ce4b1	Elvenking	m	t	\N
110cb86243320511676f788dbc46f633	HateSphere	y	t	\N
8e9f5b1fc0e61f9a289aba4c59e49521	sign of death	y	t	\N
014dbc80621be3ddc6dd0150bc6571ff	Nervecell	y	t	\N
536d1ccb9cce397f948171765c0120d4	WeedWizard	y	t	\N
15b70a4565372e2da0d330568fe1d795	Human Waste	y	t	\N
8e331f2ea604deea899bfd0a494309ba	Braincasket	y	t	\N
46e1d00c2019ff857c307085c58e0015	5 Stabbed 4 Corpses	y	t	\N
6afdd78eac862dd63833a3ce5964b74b	Pusboil	y	t	\N
fb5f71046fd15a0a22d7bda38971f142	Vibrio Cholera	y	t	\N
512914f31042dacd2a05bfcebaacdb96	Demorphed	y	t	\N
d96d9dac0f19368234a1fe2d4daf7f7c	OPS - Orphan Playground Sniper	y	t	\N
5aa3856374df5daa99d3d33e6a38a865	Vor die Hunde	y	t	\N
e83655f0458b6c309866fbde556be35a	Hereza	y	t	\N
92dd59a949dfceab979dd25ac858f204	Gorgatron	y	t	\N
ee1bc524d6d3410e94a99706dcb12319	Rottenness	y	t	\N
c09ffd48de204e4610d474ade2cf3a0d	Nuclear Vomit	y	t	\N
3e7f48e97425d4c532a0787e54843863	Dead Man's Hand	y	t	\N
bfff088b67e0fc6d1b80dbd6b6f0620c	The Gentlemen's Revenge	y	t	\N
233dedc0bee8bbdf7930eab3dd54daee	Gunnar	n	t	\N
80f19b325c934c8396780d0c66a87c99	The Hollywood Vampires	y	t	\N
3ccca65d3d9843b81f4e251dcf8a3e8c	Sting	y	t	\N
9144b4f0da4c96565c47c38f0bc16593	Shaggy	y	t	\N
8b3d594047e4544f608c2ebb151aeb45	Witchkrieg	y	t	\N
ca03a570b4d4a22329359dc105a9ef22	Harlott	y	t	\N
f5eaa9c89bd215868235b0c068050883	Angstskíg	m	t	\N
9f10d335198e90990f3437c5733468e7	Tiamat	m	t	\N
b34f0dad8c934ee71aaabb2a675f9822	Gorleben	m	t	\N
c6458620084029f07681a55746ee4d69	Bitchhammer	m	t	\N
dcd3968ac5b1ab25328f4ed42cdf2e2b	Infest	y	t	\N
6e25aa27fcd893613fac13b0312fe36d	Corrupt	y	t	\N
63e961dd2daa48ed1dade27a54f03ec4	Incantation	y	t	\N
4cc6d79ef4cf3af13b6c9b77783e688b	Embryo	y	t	\N
da34d04ff19376defc2facc252e52cf0	Shampoon Killer	y	t	\N
eaf446aca5ddd602d0ab194667e7bec1	Boötes Void	y	t	\N
ee325100d772dd075010b61b6f33c82a	Sněť	y	t	\N
950d43371e8291185e524550ad3fd0df	Kadaverficker	y	t	\N
2aa7757363ff360f3a08283c1d157b2c	Maceration	y	t	\N
d71218f2abfdd51d95ba7995b93bd536	Mephorash	y	t	\N
12c0763f59f7697824567a3ca32191db	Haemorrhage	y	t	\N
4e14f71c5702f5f71ad7de50587e2409	Methane	y	t	\N
8f7d02638c253eb2d03118800c623203	Necrosy	y	t	\N
d2ec9ebbccaa3c6925b86d1bd528d12f	Massacre	y	t	\N
2cca468dcaea0a807f756b1de2b3ec7b	Sirrush	y	t	\N
c8c012313f10e2d0830f3fbc5afca619	Midnight	y	t	\N
cf3ecbdc9b5ae9c5a87ab05403691350	Mystifier	y	t	\N
9323fc63b40460bcb68a7ad9840bad5a	Possessed	y	t	\N
6429807f6febbf061ac85089a8c3173d	LIK	y	t	\N
7b959644258e567b32d7c38e21fdb6fa	Ash Nazg Búrz	y	t	\N
b08c5a0f666c5f8a83a7bcafe51ec49b	Seth	y	t	\N
eb626abaffa54be81830da1b29a3f1d8	Demonical	y	t	\N
dd663d37df2cb0b5e222614dd720f6d3	Arkona	y	t	\N
71aabfaa43d427516f4020c7178de31c	Darkfall	y	t	\N
32f27ae0d5337bb62c636e3f6f17b0ff	Totensucht	y	t	\N
d9a6c1fcbafa92784f501ca419fe4090	Saor	y	t	\N
afd755c6a62ac0a0947a39c4f2cd2c20	Home Reared Meat	y	t	\N
b69b0e9285e4fa15470b0969836ac5ae	Nyctopia	y	t	\N
79d924bae828df8e676ba27e5dfc5f42	Riot City	n	t	\N
84557a1d9eb96a680c0557724e1d0532	Defleshed	y	t	\N
ead662696e0486cb7a478ecd13a0b5c5	Resurrected	y	t	\N
62165afb63fc004e619dff4d2132517c	Phantom Corporation	y	t	\N
b5d1848944ce92433b626211ed9e46f8	Bodyfarm	y	t	\N
92e67ef6f0f8c77b1dd631bd3b37ebca	Krisiun	y	t	\N
fe1f86f611c34fba898e4c90b71ec981	Bloodbath	y	t	\N
8c22a88267727dd513bf8ca278661e4d	Deicide	y	t	\N
541455f74d6f393174ff14b99e01b22d	Matt Miller	y	t	\N
90bebabe0c80676a4f6207ee0f8caa4c	Groundville Bastards	y	t	\N
ee8cde73a364c2b066f795edda1a303a	The Killer Apes	y	t	\N
92e25f3ba88109b777bd65b3b3de28a9	Pinch Black	y	t	\N
3e3b4203ce868f55b084eb4f2da535d3	Putrid Pile	y	t	\N
88ae6d397912fe633198a78a3b10f82e	Signs of the Swarm	y	t	\N
d2ec80fcff98ecb676da474dfcb5fe5c	Squash Bowels	y	t	\N
e31fabfff3891257949efc248dfa97e2	VILE	y	t	\N
4f6ae7ce964e64fdc143602aaaab1c26	Suffocate Bastard	y	t	\N
fe1fbc7d376820477e38b5fa497e4509	Fleshless	y	t	\N
b4087680a00055c7b9551c6a1ef50816	Anime Torment	y	t	\N
e318f5bc96fd248b69f6a969a320769e	Kraanium	y	t	\N
56525146be490541a00c20a1dab0a465	Viscera Trail	y	t	\N
186aab3d817bd38f76c754001b0ab04d	Holy Moses	m	f	\N
2f39cfcedf45336beb2e966e80b93e22	Gutrectomy	y	t	\N
51053ffab2737bd21724ed0b7e6c56f7	Embrace your Punishment	y	t	\N
869d4f93046289e11b591fc7a740bc43	Devangelic	y	t	\N
edb40909b64e73b547843287929818de	Monument of Misanthropy	y	t	\N
5b3c70181a572c8d92d906ca20298d93	Ruins of Perception	y	t	\N
37b93f83b5fe94e766346ef212283282	Vulvectomy	y	t	\N
dbde8de43043d69c4fdd3e50a72b859d	Torsofuck	y	t	\N
fd1bd629160356260c497da84df860e2	Crepitation	y	t	\N
3dba6c9259786defe62551e38665a94a	Amputated	y	t	\N
34d29649cb20a10a5e6b59c531077a59	Colpocleisis	y	t	\N
c02f12329daf99e6297001ef684d6285	Kinski	y	t	\N
be3c26bf034e9e62057314f3945f87be	Cephalic Carnage	m	t	\N
986a4f4e41790e819dc8b2a297aa8c87	Malignancy	m	t	\N
f64162c264d5679d130b6e8ae84d704e	Invoker	y	t	\N
0674a20e29104e21d141843a86421323	Torturized	y	t	\N
24dd5b3de900b9ee06f913a550beb64c	Groza	y	t	\N
fe7838d63434580c47798cbc5c2c8c63	Flammenaar	y	t	\N
e47c5fcf4a752dfcfbccaab5988193ef	Asenblut	y	t	\N
3d482a4abe7d814a741b06cb6306d598	Obscurity	y	t	\N
856256d0fddf6bfd898ef43777a80f0c	Aetherian	y	t	\N
b5bc9b34286d4d4943fc301fe9b46e46	Convictive	y	t	\N
589a30eb4a7274605385d3414ae82aaa	Nameless Death	y	t	\N
d79d3a518bd9912fb38fa2ef71c39750	Matricide	y	t	\N
5ff09619b7364339a105a1cbcb8d65fd	Angelcrypt	y	t	\N
2eb6fb05d553b296096973cb97912cc0	Macbeth	m	t	\N
50681f5168e67b62daa1837d8f693001	The Shit Shakers	y	t	\N
e163173b9350642f7c855bf37c144ce0	Jo Carley and the old dry skulls	y	t	\N
69af98a8916998443129c057ee04aec4	Skaphos	y	t	\N
57338bd22a6c5ba32f90981ffb25ef23	Warside	y	t	\N
48aeffb54173796a88ef8c4eb06dbf10	Horrible Creatures	y	t	\N
07759c4afc493965a5420e03bdc9b773	Magefa	y	t	\N
8989ab42027d29679d1dedc518eb04bd	On every Page	y	t	\N
a51211ef8cbbf7b49bfb27c099c30ce1	Mindreaper	y	t	\N
0dc9cb94cdd3a9e89383d344a103ed5b	Infected Chaos	y	t	\N
c45ca1e791f2849d9d11b3948fdefb74	Maniacs Brainacts	y	t	\N
54f89c837a689f7f27667efb92e3e6b1	Isn't	y	t	\N
49f6021766f78bffb3f824eb199acfbc	Wotolom	y	t	\N
f04de6fafc611682779eb2eb36bdbe25	Lack of Senses	m	t	\N
266674d0a44a3a0102ab80021ddfd451	Disrooted	m	t	\N
50e7b1ba464091976138ec6a57b08ba0	Guardians Gate	m	t	\N
ada3962af4845c243fcd1ccafc815b09	Arctic Winter	y	t	\N
b05f3966288598b02cda4a41d6d1eb6b	Epicedium	y	t	\N
c7d1a2a30826683fd366e7fd6527e79c	Crescent	y	t	\N
6ff4735b0fc4160e081440b3f7238925	Purgatory	y	t	\N
100691b7539d5ae455b6f4a18394420c	Torture Killer	y	t	\N
d5282bd6b63b4cd51b50b40d192f1161	Ton Steine Scherben	y	t	\N
5159fd46698ae21d56f1684c2041bd79	Are we used to it	y	t	\N
c63ecd19a0ca74c22dfcf3063c9805d2	Contrast	y	t	\N
e08f00b43f7aa539eb60cfa149afd92e	Alteration	y	t	\N
793955e5d62f9b22bae3b59463c9ef63	Soulburner	y	t	\N
e4f2a1b2efa9caa67e58fa9610903ef0	Hellgarden	y	t	\N
25ebb3d62ad1160c96bbdea951ad2f34	Destruction	y	t	\N
57f003f2f413eedf53362b020f467be4	Whiplash	y	t	\N
5ef6a0f70220936a0158ad66fd5d9082	Journey of D.C.	y	t	\N
d97a4c5c71013baac562c2b5126909e1	Hellbent on Rocking	y	t	\N
1ebe59bfb566a19bc3ce5f4fb6c79cd3	Lost on Airfield	y	t	\N
5f572d201a24500b2db6eca489a6a620	Defacing God	y	t	\N
ac6dc9583812a034be2f5aacbf439236	Triagone	y	t	\N
7f499363c322c1243827700c67a7591c	Losing my Grip	y	t	\N
2040754b0f9589a89ce88912bcf0648e	LEYKA	y	t	\N
13cd421d8a1cb48800543b9317aa2f52	Decreate	y	t	\N
4b9f3b159347c34232c9f4b220cb22de	Spreading Miasma	y	t	\N
81a17f1bf76469b18fbe410d8ec77da8	Root of all Evil	y	t	\N
81a86312a4aa3660f273d6ed5e4a6c7d	No Face no Case	m	t	\N
77f2b3ea9e4bd785f5ff322bae51ba07	Children of Bodom	y	f	\N
2876f7ecdae220b3c0dcb91ff13d0590	Ctulu	y	f	\N
121189969c46f49b8249633c2d5a7bfa	Slayer	y	f	\N
546f8a4844ac636dd18025dcc673a3ab	Harvest their Bodies	y	t	\N
20d32d36893828d060096b2cd149820b	Call of Charon	y	t	\N
15137b95180ccc986f6321acffb9cb6f	Trennjaeger	y	t	\N
692649c1372f37ed50339b91337e7fec	Cavalera Conspiracy	y	t	\N
0f512371d62ae34741d14dde50ab4529	Cliteater	y	f	\N
0646225016fba179076d7df56260d1b2	Uburen	y	t	\N
ce5e821f2dcc57569eae793f628c99cf	Kanonenfieber	y	t	\N
cd11b262d721d8b3f35ad2d2af8431dd	Rats of Gomorrah (Divide)	y	t	Change name from Divide to Rats of Gomorrah
3771bd5f354df475660a24613fcb7a8c	Arkuum	y	t	\N
f43bb3f980f58c66fc81874924043946	Gernotshagen	y	t	\N
15cee64305c1b40a4fac10c26ffa227d	Soul Grinder	y	t	\N
069cdf9184e271a3c6d45ad7e86fcac2	Rise of Kronos (Surface)	y	t	Change name from Surface to Rise of Kronos
e9782409a3511c3535149cdfb5b76364	Slamentation	y	t	\N
f7c31a68856cab2620244be2df27c728	Blue Collar Punks	y	t	\N
ae2056f2540325e2de91f64f5ac130b6	Knife1	m	t	They play Hardcore
eced087124a41417845c0b0f4ff44ba9	Knife2	y	t	\N
edaf03c0c66aa548df3cebdae0f94545	Imha Tarikat	y	t	\N
16cbdd4df5f89d771dccfa1111d7f4bc	Spearhead	y	t	\N
9abdb4a0588186fc4425b29080e820a2	Bresslufd	y	t	\N
06a4594d3b323539e9dc4820625d01b8	NineUnderZero	y	t	\N
b5c7675d6faefd09e871a6c1157e9353	PushSeven12	n	t	\N
ae653e4f46c5928cc4b4b171efbcf881	Abbath	y	t	\N
1683f5557c9db93b35d1d2ae450baa21	Toxic Holocaust	y	t	\N
df8457281db2cba8bbcb4b3b80f2b9a3	Liverless	y	t	\N
f85df6e18a73a6d1f5ccb59ee51558ae	Rigorious	y	t	\N
0308321fc4f75ddaed8208c24f2cb918	Abrasive	y	t	\N
4ceb1f68d8a260c644c25799629a5615	Necromorphic Despair	y	t	\N
7acb475eda543ccd0622d546c5772c5a	Chordotomy	y	t	\N
ba8d3efe842e0755020a2f1bc5533585	Ascendancy	m	t	\N
5a154476dd67358f4dab8500076dece3	Screwed Death	m	t	\N
b8e18040dc07eead8e6741733653a740	Mother	y	t	\N
0bc244b6aa99080c3d37fea06d328193	Munich Fiends	y	t	\N
b46e412d7f90e277a1b9370cfeb26abe	Los Mezcaleros	n	t	\N
49920f80faa980ca10fea8f31ddd5fc9	Odd Couple	y	t	\N
fddfe79923a5373a44237e0e60f5c845	Tiny Fingers	y	t	\N
277ce66a47017ca1ce55714d5d2232b2	Crimson Fire	n	t	\N
2ad8a3ceb96c6bf74695f896999019d8	Apostasie	y	t	\N
fc4734cc48ce1595c9dbbe806f663af8	Carnifex	y	t	\N
567ddbaeec9bc3c5f0348a21ebd914b1	Vexed	y	t	\N
25cde5325befa9538b771717514351fb	Welded	y	t	\N
cf2676445aa6abcc43a4b0d4b01b42a1	Hell Patröl	y	t	\N
3005cc8298f189f94923611386015c78	Alltheniko	y	t	\N
7f2679aa5b1116cc22bab4ee10018f59	Bütcher	y	t	\N
8a1acf425fb1bca48fb543edcc20a90d	Martyr	n	t	\N
c2d7bbc06d62144545c45b9060b0a629	Megalive	y	t	\N
62254b7ab0a2b3d3138bde893dde64a3	Spitfire	y	t	\N
f291caafeb623728ebf0166ac4cb0825	Devil's Hours	y	t	\N
1a46202030819f7419e300997199c955	Reflexor	y	t	\N
1f94ea2f8cb55dd130ec2254c7c2238c	Fintroll	y	t	\N
8d788b28d613c227ea3c87ac898a8256	Metsatöll	y	t	\N
5226c9e67aff4f963aea67c95cd5f3f0	Suotana	y	t	\N
e58ecda1a7b9bfdff6a10d398f468c3f	Keep of Kalessin	y	t	\N
183bea99848e19bdb720ba5774d216ba	Gasbrand	y	t	\N
495ddc6ae449bf858afe5512d28563f5	Medico Peste	y	t	\N
b2b4ae56a4531455e275770dc577b68e	Devastator	y	t	\N
3b0b94c18b8d65aec3a8ca7f4dae720d	Tears of Fire	y	t	Location: Germany
f9d5d4c7b26c7b832ee503b767d5df52	Slaughter Messiah	m	t	\N
5d56713e4586c9b1920eb1a3d4597564	Nakkeknaekker	y	t	\N
f9030edd3045787fcbcfd47da5246596	Plaguemace	y	t	\N
215513a2c867f8b24d5aea58c9abfff6	Cognitive	y	t	\N
1ca632ac231052e4116239ccb8952dfe	Macabre Demise	y	t	\N
62a40f6fa589c7007ded80d26ad1c3a9	Fallujah	y	t	\N
7d9488e60660507d0f88850245ddc7a5	Vulvodynia	y	t	\N
abb4decfc5a094f45911b94337e7e2c4	Mélancholia	y	t	\N
e061c04af9609876757f0b33d14c63e5	South of Hessen	y	t	\N
\.


--
-- Data for Name: bands_countries; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands_countries (id_band, id_country) FROM stdin;
fb47f889f2c7c4fee1553d0f817b8aaa	NLD                             
348bcdb386eb9cb478b55a7574622b7c	NLD                             
925bd435e2718d623768dbf1bc1cfb60	FRA                             
7c7ab6fbcb47bd5df1e167ca28220ee9	FRA                             
0cdf051c93865faa15cbc5cd3d2b69fb	USA                             
b89e91ccf14bfd7f485dd7be7d789b0a	USA                             
e0de9c10bbf73520385ea5dcbdf62073	USA                             
065b56757c6f6a0fba7ab0c64e4c1ae1	USA                             
b6da055500e3d92698575a3cfc74906c	NLD                             
5cd1c3c856115627b4c3e93991f2d9cd	USA                             
bfc9ace5d2a11fae56d038d68c601f00	USA                             
63ae1791fc0523f47bea9485ffec8b8c	NLD                             
b570e354b7ebc40e20029fcc7a15e5a7	USA                             
6c607fc8c0adc99559bc14e01170fee1	USA                             
891a55e21dfacf2f97c450c77e7c3ea7	USA                             
8b0ee5a501cef4a5699fd3b2d4549e8f	USA                             
3f15c445cb553524b235b01ab75fe9a6	USA                             
656d1497f7e25fe0559c6be81a4bccae	USA                             
f60ab90d94b9cafe6b32f6a93ee8fcda	USA                             
a7f9797e4cd716e1516f9d4845b0e1e2	USA                             
3d6ff25ab61ad55180a6aee9b64515bf	USA                             
660813131789b822f0c75c667e23fc85	USA                             
a7a9c1b4e7f10bd1fdf77aff255154f7	USA                             
79566192cda6b33a9ff59889eede2d66	USA                             
7f29efc2495ce308a8f4aa7bfc11d701	USA                             
5b20ea1312a1a21beaa8b86fe3a07140	USA                             
6bafe8cf106c32d485c469d36c056989	USA                             
66599a31754b5ac2a202c46c2b577c8e	USA                             
5e4317ada306a255748447aef73fff68	USA                             
121189969c46f49b8249633c2d5a7bfa	USA                             
249229ca88aa4a8815315bb085cf4d61	USA                             
076365679712e4206301117486c3d0ec	USA                             
fc4734cc48ce1595c9dbbe806f663af8	USA                             
86482a1e94052aa18cd803a51104cdb9	USA                             
59f06d56c38ac98effb4c6da117b0305	USA                             
e3f0bf612190af6c3fad41214115e004	GBR                             
ee69e7d19f11ca58843ec2e9e77ddb38	GBR                             
897edb97d775897f69fa168a88b01c19	CAN                             
3e75cd2f2f6733ea4901458a7ce4236d	HUN                             
d3ed8223151e14b936436c336a4c7278	POL                             
be20385e18333edb329d4574f364a1f0	POL                             
49c4097bae6c6ea96f552e38cfb6c2d1	DNK                             
449b4d758aa7151bc1bbb24c3ffb40bb	CUB                             
0a7ba3f35a9750ff956dca1d548dad12	DEU                             
54b72f3169fea84731d3bcba785eac49	DEU                             
d05a0e65818a69cc689b38c0c0007834	DEU                             
dcabc7299e2b9ed5b05c33273e5fdd19	DEU                             
a332f1280622f9628fccd1b7aac7370a	DEU                             
b1bdad87bd3c4ac2c22473846d301a9e	DEU                             
fe5b73c2c2cd2d9278c3835c791289b6	DEU                             
7d6b45c02283175f490558068d1fc81b	FRA                             
dddb04bc0d058486d0ef0212c6ea0682	FRA                             
7771012413f955f819866e517b275cb4	FRA                             
4dddd8579760abb62aa4b1910725e73c	NLD                             
37f02eba79e0a3d29dfd6a4cf2f4d019	NLD                             
804803e43d2c779d00004a6e87f28e30	USA                             
c2855b6617a1b08fed3824564e15a653	USA                             
cd9483c1733b17f57d11a77c9404893c	USA                             
5952dff7a6b1b3c94238ad3c6a42b904	USA                             
bb4cc149e8027369e71eb1bb36cd98e0	USA                             
39e83bc14e95fcbc05848fc33c30821f	CZE                             
c8d551145807972d194691247e7102a2	USA                             
2d1f30c9fc8d7200bdf15b730c4cd757	USA                             
a1cebab6ecfd371779f9c18e36cbba0c	USA                             
17bcf0bc2768911a378a55f42acedba7	USA                             
71e720cd3fcc3cdb99f2f4dc7122e078	USA                             
20f0ae2f661bf20e506108c40c33a6f3	USA                             
42c9b99c6b409bc9990658f6e7829542	USA                             
bb51d2b900ba638568e48193aada8a6c	USA                             
1833e2cfde2a7cf621d60288da14830c	USA                             
bbdbdf297183a1c24be29ed89711f744	USA                             
6e512379810ecf71206459e6a1e64154	USA                             
f3b65f675d13d81c12d3bb30b0190cd1	USA                             
1918775515a9c7b8db011fd35a443b82	USA                             
15bf34427540dd1945e5992583412b2f	USA                             
ba8033b8cfb1ebfc91a5d03b3a268d9f	USA                             
233dedc0bee8bbdf7930eab3dd54daee	USA                             
80f19b325c934c8396780d0c66a87c99	USA                             
6e25aa27fcd893613fac13b0312fe36d	USA                             
63e961dd2daa48ed1dade27a54f03ec4	USA                             
d2ec9ebbccaa3c6925b86d1bd528d12f	USA                             
c8c012313f10e2d0830f3fbc5afca619	USA                             
9323fc63b40460bcb68a7ad9840bad5a	USA                             
8c22a88267727dd513bf8ca278661e4d	USA                             
541455f74d6f393174ff14b99e01b22d	USA                             
3e3b4203ce868f55b084eb4f2da535d3	USA                             
88ae6d397912fe633198a78a3b10f82e	USA                             
e31fabfff3891257949efc248dfa97e2	USA                             
986a4f4e41790e819dc8b2a297aa8c87	USA                             
be3c26bf034e9e62057314f3945f87be	USA                             
57f003f2f413eedf53362b020f467be4	USA                             
692649c1372f37ed50339b91337e7fec	USA                             
1683f5557c9db93b35d1d2ae450baa21	USA                             
a61b878c2b563f289de2109fa0f42144	GBR                             
51fa80e44b7555c4130bd06c53f4835c	GBR                             
889aaf9cd0894206af758577cf5cf071	GBR                             
faabbecd319372311ed0781d17b641d1	CAN                             
b5d9c5289fe97968a5634b3e138bf9e2	CAN                             
4b503a03f3f1aec6e5b4d53dd8148498	BLR                             
7c83727aa466b3b1b9d6556369714fcf	CUB                             
9f19396638dd8111f2cee938fdf4e455	DEU                             
fdcbfded0aaf369d936a70324b39c978	DEU                             
1056b63fdc3c5015cc4591aa9989c14f	DEU                             
2876f7ecdae220b3c0dcb91ff13d0590	DEU                             
1734b04cf734cb291d97c135d74b4b87	DEU                             
8d7a18d54e82fcfb7a11566ce94b9109	DEU                             
0e2ea6aa669710389cf4d6e2ddf408c4	DEU                             
63ad3072dc5472bb44c2c42ede26d90f	DEU                             
2aae4f711c09481c8353003202e05359	DEU                             
fdc90583bd7a58b91384dea3d1659cde	FRA                             
2414366fe63cf7017444181acacb6347	FRA                             
a825b2b87f3b61c9660b81f340f6e519	FRA                             
7df8865bbec157552b8a579e0ed9bfe3	USA                             
cddf835bea180bd14234a825be7a7a82	NLD                             
215513a2c867f8b24d5aea58c9abfff6	USA                             
62a40f6fa589c7007ded80d26ad1c3a9	USA                             
74b3b7be6ed71b946a151d164ad8ede5	GBR                             
e64b94f14765cee7e05b4bec8f5fee31	NLD                             
d0a1fd0467dc892f0dc27711637c864e	NLD                             
649db5c9643e1c17b3a44579980da0ad	NLD                             
55159d04cc4faebd64689d3b74a94009	GBR                             
eeaeec364c925e0c821660c7a953546e	GBR                             
4f48e858e9ed95709458e17027bb94bf	GBR                             
2501f7ba78cc0fd07efb7c17666ff12e	NLD                             
dd18fa7a5052f2bce8ff7cb4a30903ea	CZE                             
bd4184ee062e4982b878b6b188793f5b	GBR                             
91a337f89fe65fec1c97f52a821c1178	GBR                             
baa9d4eef21c7b89f42720313b5812d4	GBR                             
820de5995512273916b117944d6da15a	CAN                             
fb8be6409408481ad69166324bdade9c	UKR                             
73affe574e6d4dc2fa72b46dc9dd4815	UKR                             
7492a1ca2669793b485b295798f5d782	DNK                             
63d7f33143522ba270cb2c87f724b126	DNK                             
33b6f1b596a60fa87baef3d2c05b7c04	FIN                             
bbb668ff900efa57d936e726a09e4fe8	FIN                             
ca5a010309ffb20190558ec20d97e5b2	NOR                             
9db9bc745a7568b51b3a968d215ddad6	SWE                             
401357e57c765967393ba391a338e89b	SWE                             
87f44124fb8d24f4c832138baede45c7	SWE                             
ed24ff8971b1fa43a1efbb386618ce35	SWE                             
a4902fb3d5151e823c74dfd51551b4b0	SWE                             
776da10f7e18ffde35ea94d144dc60a3	SWE                             
bbce8e45250a239a252752fac7137e00	SWE                             
ef6369d9794dbe861a56100e92a3c71d	SWE                             
187ebdf7947f4b61e0725c93227676a4	ITA                             
0903a7e60f0eb20fdc8cc0b8dbd45526	ITA                             
237e378c239b44bff1e9a42ab866580c	ITA                             
44f2dc3400ce17fad32a189178ae72fa	PRT                             
426fdc79046e281c5322161f011ce68c	ESP                             
443866d78de61ab3cd3e0e9bf97a34f6	AUT                             
1ac0c8e8c04cf2d6f02fdb8292e74588	AUT                             
76700087e932c3272e05694610d604ba	BEL                             
87ded0ea2f4029da0a0022000d59232b	AUS                             
0b0d1c3752576d666c14774b8233889f	AUS                             
42563d0088d6ac1a47648fc7621e77c6	DEU                             
c883319a1db14bc28eff8088c5eba10e	DEU                             
6b7cf117ecf0fea745c4c375c1480cb5	DEU                             
4276250c9b1b839b9508825303c5c5ae	DEU                             
7462f03404f29ea618bcc9d52de8e647	DEU                             
5efb7d24387b25d8325839be958d9adf	DEU                             
e271e871e304f59e62a263ffe574ea2d	DEU                             
a8d9eeed285f1d47836a5546a280a256	DEU                             
abbf8e3e3c3e78be8bd886484c1283c1	DEU                             
2cfe35095995e8dd15ab7b867e178c15	FRA                             
4a2a0d0c29a49d9126dcb19230aa1994	FRA                             
80fcd08f6e887f6cfbedd2156841ab2b	FRA                             
7db066b46f48d010fdb8c87337cdeda4	USA                             
4cfab0d66614c6bb6d399837656c590e	NLD                             
c4678a2e0eef323aeb196670f2bc8a6e	NLD                             
0844ad55f17011abed4a5208a3a05b74	GBR                             
e64d38b05d197d60009a43588b2e4583	GBR                             
88711444ece8fe638ae0fb11c64e2df3	GBR                             
e872b77ff7ac24acc5fa373ebe9bb492	MEX                             
db38e12f9903b156f9dc91fce2ef3919	RUS                             
a716390764a4896d99837e99f9e009c9	BRA                             
b885447285ece8226facd896c04cdba2	HUN                             
522b6c44eb0aedf4970f2990a2f2a812	POL                             
2e7a848dc99bd27acb36636124855faf	ROU                             
8775f64336ee5e9a8114fbe3a5a628c5	DNK                             
7cd7921da2e6aab79c441a0c2ffc969b	FIN                             
529a1d385b4a8ca97ea7369477c7b6a7	FIN                             
b3ffff8517114caf70b9e70734dbaf6f	FIN                             
77f2b3ea9e4bd785f5ff322bae51ba07	FIN                             
ffa7450fd138573d8ae665134bccd02c	FIN                             
2cf65e28c586eeb98daaecf6eb573e7a	FIN                             
a650d82df8ca65bb69a45242ab66b399	FIN                             
75ab0270163731ee05f35640d56ef473	NOR                             
a4cbfb212102da21b82d94be555ac3ec	NOR                             
6c00bb1a64f660600a6c1545377f92dc	NOR                             
6830afd7158930ca7d1959ce778eb681	NOR                             
2082a7d613f976e7b182a3fe80a28958	NOR                             
c5dc33e23743fb951b3fe7f1f477b794	NOR                             
8fda25275801e4a40df6c73078baf753	NOR                             
b5f7b25b0154c34540eea8965f90984d	NOR                             
942c9f2520684c22eb6216a92b711f9e	SWE                             
5df92b70e2855656e9b3ffdf313d7379	SWE                             
108c58fc39b79afc55fac7d9edf4aa2a	SWE                             
9a322166803a48932356586f05ef83c7	SWE                             
1c6987adbe5ab3e4364685e8caed0f59	SWE                             
7533f96ec01fd81438833f71539c7d4e	SWE                             
c4f0f5cedeffc6265ec3220ab594d56b	SWE                             
947ce14614263eab49f780d68555aef8	SWE                             
d730e65d54d6c0479561d25724afd813	SWE                             
e08383c479d96a8a762e23a99fd8bf84	SWE                             
a3f5542dc915b94a5e10dab658bb0959	SWE                             
eb2c788da4f36fba18b85ae75aff0344	SWE                             
e74a88c71835c14d92d583a1ed87cc6c	SWE                             
d73310b95e8b4dece44e2a55dd1274e6	SWE                             
6429807f6febbf061ac85089a8c3173d	SWE                             
66244bb43939f81c100f03922cdc3439	SWE                             
83d15841023cff02eafedb1c87df9b11	SWE                             
26830d74f9ed8e7e4ea4e82e28fa4761	HRV                             
dfdef9b5190f331de20fe029babf032e	DEU                             
5b22d1d5846a2b6b6d0cf342e912d124	DEU                             
4261335bcdc95bd89fd530ba35afbf4c	DEU                             
3cdb47307aeb005121b09c41c8d8bee6	DEU                             
53407737e93f53afdfc588788b8288e8	DEU                             
006fc2724417174310cf06d2672e34d2	DEU                             
2ac79000a90b015badf6747312c0ccad	DEU                             
626dceb92e4249628c1e76a2c955cd24	DEU                             
3a2a7f86ca87268be9b9e0557b013565	DEU                             
ac03fad3be179a237521ec4ef2620fb0	DEU                             
7e2b83d69e6c93adf203e13bc7d6f444	DEU                             
91b18e22d4963b216af00e1dd43b5d05	FRA                             
02d44fbbe1bfacd6eaa9b20299b1cb78	NLD                             
2af9e4497582a6faa68a42ac2d512735	USA                             
f8e7112b86fcd9210dfaf32c00d6d375	GBR                             
218f2bdae8ad3bb60482b201e280ffdc	GBR                             
65976b6494d411d609160a2dfd98f903	GBR                             
5b709b96ee02a30be5eee558e3058245	BRA                             
94ca28ea8d99549c2280bcc93f98c853	NLD                             
e4b3296f8a9e2a378eb3eb9576b91a37	CHL                             
e62a773154e1179b0cc8c5592207cb10	CAN                             
0a267617c0b5b4d53e43a7d4e4c522ad	NLD                             
11f8d9ec8f6803ea61733840f13bc246	BLR                             
53369c74c3cacdc38bdcdeda9284fe3c	RUS                             
fa03eb688ad8aa1db593d33dabd89bad	CZE                             
91c9ed0262dea7446a4f3a3e1cdd0698	FIN                             
0af74c036db52f48ad6cbfef6fee2999	FIN                             
90d523ebbf276f516090656ebfccdc9f	ISL                             
abd7ab19ff758cf4c1a2667e5bbac444	CZE                             
c127f32dc042184d12b8c1433a77e8c4	ISL                             
8edf4531385941dfc85e3f3d3e32d24f	SWE                             
8b427a493fc39574fc801404bc032a2f	GRC                             
9bc2ca9505a273b06aa0b285061cd1de	GRC                             
9d969d25c9f506c5518bb090ad5f8266	GRC                             
2df8905eae6823023de6604dc5346c29	GRC                             
8259dc0bcebabcb0696496ca406dd672	GRC                             
249789ae53c239814de8e606ff717ec9	ITA                             
c4ddbffb73c1c34d20bd5b3f425ce4b1	ITA                             
457f098eeb8e1518008449e9b1cb580d	ITA                             
6bd19bad2b0168d4481b19f9c25b4a9f	ITA                             
e563e0ba5dbf7c9417681c407d016277	ITA                             
edd506a412c4f830215d4c0f1ac06e55	ITA                             
fd9a5c27c20cd89e4ffcc1592563abcf	MLT                             
8f7de32e3b76c02859d6b007417bd509	MLT                             
948098e746bdf1c1045c12f042ea98c2	PRT                             
4a45ac6d83b85125b4163a40364e7b2c	PRT                             
19baf8a6a25030ced87cd0ce733365a9	PRT                             
990813672e87b667add44c712bb28d3d	PRT                             
9fc7c7342d41c7c53c6e8e4b9bc53fc4	PRT                             
3921cb3f97a88349e153beb5492f6ef4	PRT                             
93f4aac22b526b5f0c908462da306ffc	PRT                             
1e14d6b40d8e81d8d856ba66225dcbf3	SRB                             
59d153c1c2408b702189623231b7898a	ESP                             
905a40c3533830252a909603c6fa1e6a	ESP                             
5c1a922f41003eb7a19b570c33b99ff4	ESP                             
4267b5081fdfb47c085db24b58d949e0	ESP                             
e8afde257f8a2cbbd39d866ddfc06103	AUT                             
c74b5aa120021cbe18dcddd70d8622da	AUT                             
3614c45db20ee41e068c2ab7969eb3b5	AUT                             
3964d4f40b6166aa9d370855bd20f662	AUT                             
31d8a0a978fad885b57a685b1a0229df	AUT                             
8143ee8032c71f6f3f872fc5bb2a4fed	AUT                             
46174766ce49edbbbc40e271c87b5a83	COL                             
bbc155fb2b111bf61c4f5ff892915e6b	CUB                             
9ab8f911c74597493400602dc4d2b412	DEU                             
54f0b93fa83225e4a712b70c68c0ab6f	DEU                             
1cdd53cece78d6e8dffcf664fa3d1be2	DEU                             
1e88302efcfc873691f0c31be4e2a388	DEU                             
13caf3d14133dfb51067264d857eaf70	DEU                             
7a4fafa7badd04d5d3114ab67b0caf9d	DEU                             
4927f3218b038c780eb795766dfd04ee	DEU                             
0a97b893b92a7df612eadfe97589f242	DEU                             
7ef36a3325a61d4f1cff91acbe77c7e3	DEU                             
e25ee917084bdbdc8506b56abef0f351	FRA                             
8e11b2f987a99ed900a44aa1aa8bd3d0	NLD                             
96e3cdb363fe6df2723be5b994ad117a	FRA                             
2c4e2c9948ddac6145e529c2ae7296da	FRA                             
f6540bc63be4c0cb21811353c0d24f69	NLD                             
da867941c8bacf9be8e59bc13d765f92	USA                             
935b48a84528c4280ec208ce529deea0	GBR                             
8852173e80d762d62f0bcb379d82ebdb	GBR                             
e4f0ad5ef0ac3037084d8a5e3ca1cabc	NLD                             
ea16d031090828264793e860a00cc995	NLD                             
b1d465aaf3ccf8701684211b1623adf2	150                             
c9af1c425ca093648e919c2e471df3bd	NLD                             
dde3e0b0cc344a7b072bbab8c429f4ff	BRA                             
e29ef4beb480eab906ffa7c05aeec23d	POL                             
4ad6c928711328d1cf0167bc87079a14	POL                             
45b568ce63ea724c415677711b4328a7	DNK                             
36cbc41c1c121f2c68f5776a118ea027	FIN                             
8e62fc75d9d0977d0be4771df05b3c2f	FIN                             
f03bde11d261f185cbacfa32c1c6538c	CZE                             
8a6f1a01e4b0d9e272126a8646a72088	FIN                             
dea293bdffcfb292b244b6fe92d246dc	FIN                             
6f195d8f9fe09d45d2e680f7d7157541	ISL                             
3bcbddf6c114327fc72ea06bcb02f9ef	001                             
a4977b96c7e5084fcce21a0d07b045f8	SWE                             
2113f739f81774557041db616ee851e6	SWE                             
559ccea48c3460ebc349587d35e808dd	SWE                             
000f49c98c428aff4734497823d04f45	SWE                             
db46d9a37b31baa64cb51604a2e4939a	SVN                             
754230e2c158107a2e93193c829e9e59	ESP                             
a0fb30950d2a150c1d2624716f216316	AUT                             
39a25b9c88ce401ca54fd7479d1c8b73	AUT                             
781acc7e58c9a746d58f6e65ab1e90c4	AUT                             
edb40909b64e73b547843287929818de	AUT                             
721c28f4c74928cc9e0bb3fef345e408	BEL                             
5435326cf392e2cd8ad7768150cd5df6	BEL                             
8945663993a728ab19a3853e5b820a42	BEL                             
6738f9acd4740d945178c649d6981734	BEL                             
79ce9bd96a3184b1ee7c700aa2927e67	BEL                             
4f840b1febbbcdb12b9517cd0a91e8f4	BEL                             
0291e38d9a3d398052be0ca52a7b1592	BEL                             
0870b61c5e913cb405d250e80c9ba9b9	BEL                             
393a71c997d856ed5bb85a9695be6e46	BEL                             
bb66c20c42c26f1874525c3ab956ec41	BEL                             
71e32909a1bec1edfc09aec09ca2ac17	LUX                             
f29d276fd930f1ad7687ed7e22929b64	LUX                             
2654d6e7cec2ef045ca1772a980fbc4c	LUX                             
382ed38ecc68052678c5ac5646298b63	LUX                             
c4c7cb77b45a448aa3ca63082671ad97	CHE                             
6f199e29c5782bd05a4fef98e7e41419	CHE                             
c5f022ef2f3211dc1e3b8062ffe764f0	CHE                             
0b6e98d660e2901c33333347da37ad36	CHE                             
3dda886448fe98771c001b56a4da9893	CHE                             
90d127641ffe2a600891cd2e3992685b	CHE                             
4fa857a989df4e1deea676a43dceea07	DEU                             
6ee2e6d391fa98d7990b502e72c7ec58	DEU                             
e0f39406f0e15487dd9d3997b2f5ca61	DEU                             
399033f75fcf47d6736c9c5209222ab8	DEU                             
32814ff4ca9a26b8d430a8c0bc8dc63e	DEU                             
2447873ddeeecaa165263091c0cbb22f	DEU                             
fcd1c1b547d03e760d1defa4d2b98783	DEU                             
6369ba49db4cf35b35a7c47e3d4a4fd0	DEU                             
1fda271217bb4c043c691fc6344087c1	FRA                             
fe2c9aea6c702e6b82bc19b4a5d76f90	FRA                             
c0d7362d0f52d119f1beb38b12c0b651	NLD                             
6ff24c538936b5b53e88258f88294666	USA                             
aad365e95c3d5fadb5fdf9517c371e89	CZE                             
071dbd416520d14b2e3688145801de41	GBR                             
c58de8415b504a6ffa5d0b14967f91bb	GBR                             
a5475ebd65796bee170ad9f1ef746394	GBR                             
1a8780e5531549bd454a04630a74cd4d	GBR                             
3ed0c2ad2c9e6e7b161e6fe0175fe113	CRI                             
32921081f86e80cd10138b8959260e1a	MEX                             
ab7b69efdaf168cbbe9a5b03d901be74	PAN                             
ccff6df2a54baa3adeb0bddb8067e7c0	ARG                             
9ee30f495029e1fdf6567045f2079be1	BRA                             
4d79c341966242c047f3833289ee3a13	CHL                             
5588cb8830fdb8ac7159b7cf5d1e611e	CAN                             
3041a64f7587a6768d8e307b2662785b	IDN                             
02f36cf6fe7b187306b2a7d423cafc2c	PHL                             
f17c7007dd2ed483b9df587c1fdac2c7	IND                             
7e5550d889d46d55df3065d742b5da51	IND                             
96604499bfc96fcdb6da0faa204ff2fe	TUR                             
368ff974da0defe085637b7199231c0a	FRO                             
57eba43d6bec2a8115e94d6fbb42bc75	FIN                             
de506362ebfcf7c632d659aa1f2b465d	FIN                             
a5a8afc6c35c2625298b9ce4cc447b39	ISL                             
57b9fe77adaac4846c238e995adb6ee2	ISL                             
743c89c3e93b9295c1ae6e750047fb1e	IRL                             
f9f57e175d62861bb5f2bda44a078df7	NOR                             
6a8538b37162b23d68791b9a0c54a5bf	NOR                             
03022be9e2729189e226cca023a2c9bf	NOR                             
a2459c5c8a50215716247769c3dea40b	SWE                             
eaeaed2d9f3137518a5c8c7e6733214f	DEU                             
8ccd65d7f0f028405867991ae3eaeb56	DEU                             
e5a674a93987de4a52230105907fffe9	DEU                             
e285e4ecb358b92237298f67526beff7	DEU                             
d832b654664d104f0fbb9b6674a09a11	DEU                             
2aeb128c6d3eb7e79acb393b50e1cf7b	DEU                             
b619e7f3135359e3f778e90d1942e6f5	FRA                             
5c8c8b827ae259b8e4f8cb567a577a3e	FRA                             
25fa2cdf2be085aa5394db743677fb69	NLD                             
b7e529a8e9af2a2610182b3d3fc33698	USA                             
9c158607f29eaf8f567cc6304ada9c6d	GBR                             
4ffc374ef33b65b6acb388167ec542c0	GBR                             
0bcf509f7eb2db3b663f5782c8c4a86e	CAN                             
0c2277f470a7e9a2d70195ba32e1b08a	NLD                             
34b1dade51ffdab56daebcf6ac981371	MNG                             
c09ffd48de204e4610d474ade2cf3a0d	POL                             
b04d1a151c786ee00092110333873a37	DNK                             
9d57ebbd1d3b135839b78221388394a1	DNK                             
30354302ae1c0715ccad2649da3d9443	DNK                             
110cb86243320511676f788dbc46f633	DNK                             
1c62394f457ee9a56b0885f622299ea2	SWE                             
8e331f2ea604deea899bfd0a494309ba	NLD                             
094caa14a3a49bf282d8f0f262a01f43	SWE                             
e83655f0458b6c309866fbde556be35a	HRV                             
4176aa79eae271d1b82015feceb00571	ITA                             
014dbc80621be3ddc6dd0150bc6571ff	ARE                             
92df3fd170b0285cd722e855a2968393	ITA                             
351af29ee203c740c3209a0e0a8e9c22	ITA                             
7f00429970ee9fd2a3185f777ff79922	ITA                             
6f0eadd7aadf134b1b84d9761808d5ad	AUT                             
13c260ca90c0f47c9418790429220899	AUT                             
92e2cf901fe43bb77d99af2ff42ade77	AUT                             
ca7e3b5c1860730cfd7b400de217fef2	BEL                             
450948d9f14e07ba5e3015c2d726b452	CHE                             
4cabe475dd501f3fd4da7273b5890c33	CHE                             
3e52c77d795b7055eeff0c44687724a1	CHE                             
1bb6d0271ea775dfdfa7f9fe1048147a	CHE                             
8f4e7c5f66d6ee5698c01de29affc562	CHE                             
f0bf2458b4c1a22fc329f036dd439f08	CHE                             
6afdd78eac862dd63833a3ce5964b74b	CHE                             
d1fb4e47d8421364f49199ee395ad1d3	AUS                             
36f969b6aeff175204078b0533eae1a0	AUS                             
1c06fc6740d924cab33dce73643d84b9	AUS                             
c1923ca7992dc6e79d28331abbb64e72	AUS                             
c2e88140e99f33883dac39daee70ac36	AUS                             
19819b153eb0990c821bc106e34ab3e1	AUS                             
ca03a570b4d4a22329359dc105a9ef22	AUS                             
1745438c6be58479227d8c0d0220eec5	NZL                             
4b42093adfc268ce8974a3fa8c4f6bca	DEU                             
70d0b58ef51e537361d676f05ea39c7b	DEU                             
6896f30283ad47ceb4a17c8c8d625891	DEU                             
25118c5df9a2865a8bc97feb4aff4a18	DEU                             
5a53bed7a0e05c2b865537d96a39646f	DEU                             
29b7417c5145049d6593a0d88759b9ee	DEU                             
c81794404ad68d298e9ceb75f69cf810	DEU                             
d0386252fd85f76fc517724666cf59ae	DEU                             
0cddbf403096e44a08bc37d1e2e99b0f	DEU                             
b08c5a0f666c5f8a83a7bcafe51ec49b	FRA                             
b5d1848944ce92433b626211ed9e46f8	NLD                             
51053ffab2737bd21724ed0b7e6c56f7	FRA                             
92dd59a949dfceab979dd25ac858f204	USA                             
3ccca65d3d9843b81f4e251dcf8a3e8c	GBR                             
d9a6c1fcbafa92784f501ca419fe4090	GBR                             
b69b0e9285e4fa15470b0969836ac5ae	GBR                             
0f512371d62ae34741d14dde50ab4529	NLD                             
da34d04ff19376defc2facc252e52cf0	CZE                             
fd1bd629160356260c497da84df860e2	GBR                             
ee325100d772dd075010b61b6f33c82a	CZE                             
fe1fbc7d376820477e38b5fa497e4509	CZE                             
3dba6c9259786defe62551e38665a94a	GBR                             
34d29649cb20a10a5e6b59c531077a59	GBR                             
b4087680a00055c7b9551c6a1ef50816	CZE                             
9144b4f0da4c96565c47c38f0bc16593	JAM                             
ee1bc524d6d3410e94a99706dcb12319	MEX                             
7b959644258e567b32d7c38e21fdb6fa	MEX                             
cf3ecbdc9b5ae9c5a87ab05403691350	BRA                             
92e67ef6f0f8c77b1dd631bd3b37ebca	BRA                             
79d924bae828df8e676ba27e5dfc5f42	CAN                             
56525146be490541a00c20a1dab0a465	ISR                             
dd663d37df2cb0b5e222614dd720f6d3	POL                             
d2ec80fcff98ecb676da474dfcb5fe5c	POL                             
f5eaa9c89bd215868235b0c068050883	DNK                             
2aa7757363ff360f3a08283c1d157b2c	DNK                             
dbde8de43043d69c4fdd3e50a72b859d	FIN                             
e318f5bc96fd248b69f6a969a320769e	NOR                             
9f10d335198e90990f3437c5733468e7	SWE                             
d71218f2abfdd51d95ba7995b93bd536	SWE                             
4e14f71c5702f5f71ad7de50587e2409	SWE                             
eb626abaffa54be81830da1b29a3f1d8	SWE                             
84557a1d9eb96a680c0557724e1d0532	SWE                             
fe1f86f611c34fba898e4c90b71ec981	SWE                             
4cc6d79ef4cf3af13b6c9b77783e688b	ITA                             
8f7d02638c253eb2d03118800c623203	ITA                             
2cca468dcaea0a807f756b1de2b3ec7b	ITA                             
869d4f93046289e11b591fc7a740bc43	ITA                             
37b93f83b5fe94e766346ef212283282	ITA                             
dcd3968ac5b1ab25328f4ed42cdf2e2b	SRB                             
12c0763f59f7697824567a3ca32191db	ESP                             
71aabfaa43d427516f4020c7178de31c	AUT                             
bfff088b67e0fc6d1b80dbd6b6f0620c	DEU                             
3e7f48e97425d4c532a0787e54843863	DEU                             
8b3d594047e4544f608c2ebb151aeb45	DEU                             
eaf446aca5ddd602d0ab194667e7bec1	DEU                             
b34f0dad8c934ee71aaabb2a675f9822	DEU                             
c6458620084029f07681a55746ee4d69	DEU                             
950d43371e8291185e524550ad3fd0df	DEU                             
186aab3d817bd38f76c754001b0ab04d	DEU                             
32f27ae0d5337bb62c636e3f6f17b0ff	DEU                             
57338bd22a6c5ba32f90981ffb25ef23	FRA                             
69af98a8916998443129c057ee04aec4	FRA                             
e163173b9350642f7c855bf37c144ce0	GBR                             
48aeffb54173796a88ef8c4eb06dbf10	CZE                             
54f89c837a689f7f27667efb92e3e6b1	150                             
e9782409a3511c3535149cdfb5b76364	150                             
81a86312a4aa3660f273d6ed5e4a6c7d	CZE                             
c7d1a2a30826683fd366e7fd6527e79c	EGY                             
793955e5d62f9b22bae3b59463c9ef63	CHL                             
e4f2a1b2efa9caa67e58fa9610903ef0	CHL                             
d79d3a518bd9912fb38fa2ef71c39750	ISR                             
5f572d201a24500b2db6eca489a6a620	DNK                             
100691b7539d5ae455b6f4a18394420c	FIN                             
0646225016fba179076d7df56260d1b2	NOR                             
ae653e4f46c5928cc4b4b171efbcf881	NOR                             
856256d0fddf6bfd898ef43777a80f0c	GRC                             
5ff09619b7364339a105a1cbcb8d65fd	MLT                             
0dc9cb94cdd3a9e89383d344a103ed5b	AUT                             
ac6dc9583812a034be2f5aacbf439236	BEL                             
4ceb1f68d8a260c644c25799629a5615	BEL                             
fe7838d63434580c47798cbc5c2c8c63	DEU                             
e47c5fcf4a752dfcfbccaab5988193ef	DEU                             
3d482a4abe7d814a741b06cb6306d598	DEU                             
b5bc9b34286d4d4943fc301fe9b46e46	DEU                             
589a30eb4a7274605385d3414ae82aaa	DEU                             
5ce10014f645da4156ddd2cd0965986e	USA                             
06efe152a554665e02b8dc4f620bf3f1	USA                             
8f1f10cb698cb995fd69a671af6ecd58	USA                             
11635778f116ce6922f6068638a39028	USA                             
8a1acf425fb1bca48fb543edcc20a90d	NLD                             
63bd9a49dd18fbc89c2ec1e1b689ddda	USA                             
e67e51d5f41cfc9162ef7fd977d1f9f5	USA                             
3d2ff8abd980d730b2f4fd0abae52f60	USA                             
47b23e889175dde5d6057db61cb52847	USA                             
44b7bda13ac1febe84d8607ca8bbf439	USA                             
3b0b94c18b8d65aec3a8ca7f4dae720d	IRN                             
8589a6a4d8908d7e8813e9a1c5693d70	USA                             
1bc1f7348d79a353ea4f594de9dd1392	USA                             
6a0e9ce4e2da4f2cbcd1292fddaa0ac6	USA                             
ac94d15f46f10707a39c4bc513cd9f98	USA                             
28a95ef0eabe44a27f49bbaecaa8a847	USA                             
567ddbaeec9bc3c5f0348a21ebd914b1	GBR                             
b2b4ae56a4531455e275770dc577b68e	GBR                             
fddfe79923a5373a44237e0e60f5c845	ISR                             
495ddc6ae449bf858afe5512d28563f5	POL                             
f9030edd3045787fcbcfd47da5246596	DNK                             
5d56713e4586c9b1920eb1a3d4597564	DNK                             
8d788b28d613c227ea3c87ac898a8256	EST                             
1f94ea2f8cb55dd130ec2254c7c2238c	FIN                             
5226c9e67aff4f963aea67c95cd5f3f0	FIN                             
e58ecda1a7b9bfdff6a10d398f468c3f	NOR                             
277ce66a47017ca1ce55714d5d2232b2	GRC                             
3005cc8298f189f94923611386015c78	ITA                             
7f2679aa5b1116cc22bab4ee10018f59	BEL                             
b46e412d7f90e277a1b9370cfeb26abe	DEU                             
49920f80faa980ca10fea8f31ddd5fc9	DEU                             
2ad8a3ceb96c6bf74695f896999019d8	DEU                             
25cde5325befa9538b771717514351fb	DEU                             
cf2676445aa6abcc43a4b0d4b01b42a1	DEU                             
c2d7bbc06d62144545c45b9060b0a629	DEU                             
62254b7ab0a2b3d3138bde893dde64a3	DEU                             
f291caafeb623728ebf0166ac4cb0825	DEU                             
1a46202030819f7419e300997199c955	DEU                             
183bea99848e19bdb720ba5774d216ba	DEU                             
f9d5d4c7b26c7b832ee503b767d5df52	BEL                             
8bc31f7cc79c177ab7286dda04e2d1e5	USA                             
7e0d5240ec5d34a30b6f24909e5edcb4	USA                             
f953fa7b33e7b6503f4380895bbe41c8	USA                             
058fcf8b126253956deb3ce672d107a7	USA                             
b14814d0ee12ffadc8f09ab9c604a9d0	USA                             
5447110e1e461c8c22890580c796277a	USA                             
1da77fa5b97c17be83cc3d0693c405cf	USA                             
d449a9b2eed8b0556dc7be9cda36b67b	GBR                             
7463543d784aa59ca86359a50ef58c8e	GBR                             
14ab730fe0172d780da6d9e5d432c129	DEU                             
28bc31b338dbd482802b77ed1fd82a50	DEU                             
264721f3fc2aee2d28dadcdff432dbc1	DEU                             
9d3ac6904ce73645c6234803cd7e47ca	DEU                             
44012166c6633196dc30563db3ffd017	DEU                             
aed85c73079b54830cd50a75c0958a90	DEU                             
da2110633f62b16a571c40318e4e4c1c	DEU                             
ce2caf05154395724e4436f042b8fa53	DEU                             
ad01952b3c254c8ebefaf6f73ae62f7d	DEU                             
bbddc022ee323e0a2b2d8c67e5cd321f	DEU                             
d9ab6b54c3bd5b212e8dc3a14e7699ef	DEU                             
679eaa47efb2f814f2642966ee6bdfe1	DEU                             
e1db3add02ca4c1af33edc5a970a3bdc	DEU                             
cf4ee20655dd3f8f0a553c73ffe3f72a	DEU                             
10d91715ea91101cfe0767c812da8151	DEU                             
1209f43dbecaba22f3514bf40135f991	DEU                             
dcff9a127428ffb03fc02fdf6cc39575	DEU                             
1e9413d4cc9af0ad12a6707776573ba0	DEU                             
b01fbaf98cfbc1b72e8bca0b2e48769c	DEU                             
4b98a8c164586e11779a0ef9421ad0ee	DEU                             
1ca632ac231052e4116239ccb8952dfe	DEU                             
e061c04af9609876757f0b33d14c63e5	DEU                             
7d9488e60660507d0f88850245ddc7a5	ZAF                             
abb4decfc5a094f45911b94337e7e2c4	AUS                             
7eaf9a47aa47f3c65595ae107feab05d	DEU                             
828d51c39c87aad9b1407d409fa58e36	DEU                             
d2ff1e521585a91a94fb22752dd0ab45	DEU                             
b0ce1e93de9839d07dab8d268ca23728	DEU                             
28f843fa3a493a3720c4c45942ad970e	DEU                             
9138c2cc0326412f2515623f4c850eb3	DEU                             
d857ab11d383a7e4d4239a54cbf2a63d	DEU                             
3af7c6d148d216f13f66669acb8d5c59	DEU                             
f4219e8fec02ce146754a5be8a85f246	DEU                             
0ab20b5ad4d15b445ed94fa4eebb18d8	DEU                             
7fc454efb6df96e012e0f937723d24aa	DEU                             
8edfa58b1aedb58629b80e5be2b2bd92	DEU                             
3d01ff8c75214314c4ca768c30e6807b	DEU                             
d9bc1db8c13da3a131d853237e1f05b2	DEU                             
9cf73d0300eea453f17c6faaeb871c55	DEU                             
d6de9c99f5cfa46352b2bc0be5c98c41	DEU                             
5194c60496c6f02e8b169de9a0aa542c	DEU                             
8654991720656374d632a5bb0c20ff11	DEU                             
fe228019addf1d561d0123caae8d1e52	DEU                             
1104831a0d0fe7d2a6a4198c781e0e0d	DEU                             
410d913416c022077c5c1709bf104d3c	DEU                             
97ee29f216391d19f8769f79a1218a71	DEU                             
f07c3eef5b7758026d45a12c7e2f6134	DEU                             
6d3b28f48c848a21209a84452d66c0c4	DEU                             
8c69497eba819ee79a964a0d790368fb	DEU                             
1197a69404ee9475146f3d631de12bde	DEU                             
f0c051b57055b052a3b7da1608f3039e	DEU                             
ff5b48d38ce7d0c47c57555d4783a118	DEU                             
ade72e999b4e78925b18cf48d1faafa4	DEU                             
887d6449e3544dca547a2ddba8f2d894	DEU                             
2672777b38bc4ce58c49cf4c82813a42	DEU                             
832dd1d8efbdb257c2c7d3e505142f48	DEU                             
f37ab058561fb6d233b9c2a0b080d4d1	DEU                             
3be3e956aeb5dc3b16285463e02af25b	DEU                             
988d10abb9f42e7053450af19ad64c7f	DEU                             
2a024edafb06c7882e2e1f7b57f2f951	DEU                             
2fa2f1801dd37d6eb9fe4e34a782e397	DEU                             
e0c2b0cc2e71294cd86916807fef62cb	DEU                             
52ee4c6902f6ead006b0fb2f3e2d7771	DEU                             
952dc6362e304f00575264e9d54d1fa6	DEU                             
32af59a47b8c7e1c982ae797fc491180	DEU                             
0020f19414b5f2874a0bfacd9d511b84	DEU                             
de12bbf91bc797df25ab4ae9cee1946b	DEU                             
89adcf990042dfdac7fd23685b3f1e37	DEU                             
3bd94845163385cecefc5265a2e5a525	DEU                             
99bd5eff92fc3ba728a9da5aa1971488	DEU                             
24ff2b4548c6bc357d9d9ab47882661e	DEU                             
829922527f0e7d64a3cfda67e24351e3	DEU                             
aa86b6fc103fc757e14f03afe6eb0c0a	DEU                             
5ec1e9fa36898eaf6d1021be67e0d00c	DEU                             
8ce896355a45f5b9959eb676b8b5580c	DEU                             
5f992768f7bb9592bed35b07197c87d0	DEU                             
f644bd92037985f8eb20311bc6d5ed94	DEU                             
1e8563d294da81043c2772b36753efaf	DEU                             
362f8cdd1065b0f33e73208eb358991d	DEU                             
6d57b25c282247075f5e03cde27814df	DEU                             
9b1088b616414d0dc515ab1f2b4922f1	DEU                             
0fbddeb130361265f1ba6f86b00f0968	DEU                             
f0e1f32b93f622ea3ddbf6b55b439812	DEU                             
53a0aafa942245f18098ccd58b4121aa	DEU                             
0780d2d1dbd538fec3cdd8699b08ea02	DEU                             
58db028cf01dd425e5af6c7d511291c1	DEU                             
2252d763a2a4ac815b122a0176e3468f	DEU                             
11d396b078f0ae37570c8ef0f45937ad	DEU                             
585b13106ecfd7ede796242aeaed4ea8	DEU                             
6c1fcd3c91bc400e5c16f467d75dced3	DEU                             
7d878673694ff2498fbea0e5ba27e0ea	DEU                             
33f03dd57f667d41ac77c6baec352a81	DEU                             
3509af6be9fe5defc1500f5c77e38563	DEU                             
0640cfbf1d269b69c535ea4e288dfd96	DEU                             
36648510adbf2a3b2028197a60b5dada	DEU                             
eb3bfb5a3ccdd4483aabc307ae236066	DEU                             
1ebd63d759e9ff532d5ce63ecb818731	DEU                             
059792b70fc0686fb296e7fcae0bda50	DEU                             
7dfe9aa0ca5bb31382879ccd144cc3ae	DEU                             
fb28e62c0e801a787d55d97615e89771	DEU                             
652208d2aa8cdd769632dbaeb7a16358	DEU                             
278c094627c0dd891d75ea7a3d0d021e	DEU                             
0a56095b73dcbd2a76bb9d4831881cb3	DEU                             
ff578d3db4dc3311b3098c8365d54e6b	DEU                             
4548a3b9c1e31cf001041dc0d166365b	DEU                             
5842a0c2470fe12ee3acfeec16c79c57	DEU                             
96682d9c9f1bed695dbf9176d3ee234c	DEU                             
12e93f5fab5f7d16ef37711ef264d282	DEU                             
4094ffd492ba473a2a7bea1b19b1662d	DEU                             
4ee21b1371ba008a26b313c7622256f8	DEU                             
4453eb658c6a304675bd52ca75fbae6d	DEU                             
360c000b499120147c8472998859a9fe	DEU                             
4bb93d90453dd63cc1957a033f7855c7	DEU                             
c05d504b806ad065c9b548c0cb1334cd	DEU                             
b96a3cb81197e8308c87f6296174fe3e	DEU                             
095849fbdc267416abc6ddb48be311d7	DEU                             
72778afd2696801f5f3a1f35d0e4e357	DEU                             
5c0adc906f34f9404d65a47eea76dac0	DEU                             
fdcf3cdc04f367257c92382e032b6293	DEU                             
88dd124c0720845cba559677f3afa15d	DEU                             
f4f870098db58eeae93742dd2bcaf2b2	DEU                             
d433b7c1ce696b94a8d8f72de6cfbeaa	DEU                             
28bb59d835e87f3fd813a58074ca0e11	DEU                             
cafe9e68e8f90b3e1328da8858695b31	DEU                             
ad62209fb63910acf40280cea3647ec5	DEU                             
9e84832a15f2698f67079a3224c2b6fb	DEU                             
4a7d9e528dada8409e88865225fb27c4	DEU                             
d3e98095eeccaa253050d67210ef02bb	DEU                             
c3490492512b7fe65cdb0c7305044675	DEU                             
e61e30572fd58669ae9ea410774e0eb6	DEU                             
485065ad2259054abf342d7ae3fe27e6	DEU                             
278606b1ac0ae7ef86e86342d1f259c3	DEU                             
a538bfe6fe150a92a72d78f89733dbd0	DEU                             
09d8e20a5368ce1e5c421a04cb566434	DEU                             
4366d01be1b2ddef162fc0ebb6933508	DEU                             
52b133bfecec2fba79ecf451de3cf3bb	DEU                             
f042da2a954a1521114551a6f9e22c75	DEU                             
405c7f920b019235f244315a564a8aed	DEU                             
3656edf3a40a25ccd00d414c9ecbb635	DEU                             
6d89517dbd1a634b097f81f5bdbb07a2	DEU                             
5af874093e5efcbaeb4377b84c5f2ec5	DEU                             
5037c1968f3b239541c546d32dec39eb	DEU                             
deaccc41a952e269107cc9a507dfa131	DEU                             
a29c1c4f0a97173007be3b737e8febcc	DEU                             
4fab532a185610bb854e0946f4def6a4	DEU                             
e6fd7b62a39c109109d33fcd3b5e129d	DEU                             
da29e297c23e7868f1d50ec5a6a4359b	DEU                             
96048e254d2e02ba26f53edd271d3f88	DEU                             
c2275e8ac71d308946a63958bc7603a1	DEU                             
b785a5ffad5e7e36ccac25c51d5d8908	DEU                             
63c0a328ae2bee49789212822f79b83f	DEU                             
5eed658c4b7b68a0ecc49205b68d54e7	DEU                             
145bd9cf987b6f96fa6f3b3b326303c9	DEU                             
c238980432ab6442df9b2c6698c43e47	DEU                             
8cadf0ad04644ce2947bf3aa2817816e	DEU                             
85fac49d29a31f1f9a8a18d6b04b9fc9	DEU                             
b81ee269be538a500ed057b3222c86a2	DEU                             
cf71a88972b5e06d8913cf53c916e6e4	DEU                             
5518086aebc9159ba7424be0073ce5c9	DEU                             
302ebe0389198972c223f4b72894780a	DEU                             
ac62ad2816456aa712809bf01327add1	DEU                             
470f3f69a2327481d26309dc65656f44	DEU                             
e254616b4a5bd5aaa54f90a3985ed184	DEU                             
3c5c578b7cf5cc0d23c1730d1d51436a	DEU                             
213c449bd4bcfcdb6bffecf55b2c30b4	DEU                             
4ea353ae22a1c0d26327638f600aeac8	DEU                             
d399575133268305c24d87f1c2ef054a	DEU                             
54c09bacc963763eb8742fa1da44a968	DEU                             
cba95a42c53bdc6fbf3ddf9bf10a4069	DEU                             
88a51a2e269e7026f0734f3ef3244e89	DEU                             
dde31adc1b0014ce659a65c8b4d6ce42	DEU                             
332d6b94de399f86d499be57f8a5a5ca	DEU                             
b73377a1ec60e58d4eeb03347268c11b	DEU                             
e3419706e1838c7ce6c25a28bef0c248	DEU                             
213c302f84c5d45929b66a20074075df	DEU                             
22c030759ab12f97e941af558566505e	DEU                             
f5507c2c7beee622b98ade0b93abb7fe	DEU                             
41bee031bd7d2fdb14ff48c92f4d7984	DEU                             
39a464d24bf08e6e8df586eb5fa7ee30	DEU                             
f7c3dcc7ba01d0ead8e0cfb59cdf6afc	DEU                             
0b9d35d460b848ad46ec0568961113bf	DEU                             
546bb05114b78748d142c67cdbdd34fd	DEU                             
4ac863b6f6fa5ef02afdd9c1ca2a5e24	DEU                             
1e2bcbb679ccfdea27b28bd1ea9f2e67	DEU                             
64d9f86ed9eeac2695ec7847fe7ea313	DEU                             
65b029279eb0f99c0a565926566f6759	DEU                             
9bfbfab5220218468ecb02ed546e3d90	DEU                             
be41b6cfece7dfa1b4e4d226fb999607	DEU                             
32917b03e82a83d455dd6b7f8609532c	DEU                             
b20a4217acaf4316739c6a5f6679ef60	DEU                             
178227c5aef3b3ded144b9e19867a370	DEU                             
75cde58f0e5563f287f2d4afb0ce4b7e	DEU                             
b74881ac32a010e91ac7fcbcfebe210e	DEU                             
fd85bfffd5a0667738f6110281b25db8	DEU                             
6e4b91e3d1950bcad012dbfbdd0fff09	DEU                             
32a02a8a7927de4a39e9e14f2dc46ac6	DEU                             
747f992097b9e5c9df7585931537150a	DEU                             
0ddd0b1b6329e9cb9a64c4d947e641a8	DEU                             
89eec5d48b8969bf61eea38e4b3cfdbf	DEU                             
703b1360391d2aef7b9ec688b00849bb	DEU                             
b4b46e6ce2c563dd296e8bae768e1b9d	DEU                             
1a1bfb986176c0ba845ae4f43d027f58	DEU                             
7ecdb1a0eb7c01d081acf2b7e11531c0	DEU                             
8e9f5b1fc0e61f9a289aba4c59e49521	DEU                             
536d1ccb9cce397f948171765c0120d4	DEU                             
15b70a4565372e2da0d330568fe1d795	DEU                             
46e1d00c2019ff857c307085c58e0015	DEU                             
fb5f71046fd15a0a22d7bda38971f142	DEU                             
512914f31042dacd2a05bfcebaacdb96	DEU                             
d96d9dac0f19368234a1fe2d4daf7f7c	DEU                             
5aa3856374df5daa99d3d33e6a38a865	DEU                             
afd755c6a62ac0a0947a39c4f2cd2c20	DEU                             
ead662696e0486cb7a478ecd13a0b5c5	DEU                             
62165afb63fc004e619dff4d2132517c	DEU                             
90bebabe0c80676a4f6207ee0f8caa4c	DEU                             
ee8cde73a364c2b066f795edda1a303a	DEU                             
92e25f3ba88109b777bd65b3b3de28a9	DEU                             
4f6ae7ce964e64fdc143602aaaab1c26	DEU                             
2f39cfcedf45336beb2e966e80b93e22	DEU                             
5b3c70181a572c8d92d906ca20298d93	DEU                             
c02f12329daf99e6297001ef684d6285	DEU                             
f64162c264d5679d130b6e8ae84d704e	DEU                             
0674a20e29104e21d141843a86421323	DEU                             
24dd5b3de900b9ee06f913a550beb64c	DEU                             
2eb6fb05d553b296096973cb97912cc0	DEU                             
50681f5168e67b62daa1837d8f693001	DEU                             
ada3962af4845c243fcd1ccafc815b09	DEU                             
07759c4afc493965a5420e03bdc9b773	DEU                             
8989ab42027d29679d1dedc518eb04bd	DEU                             
266674d0a44a3a0102ab80021ddfd451	DEU                             
50e7b1ba464091976138ec6a57b08ba0	DEU                             
a51211ef8cbbf7b49bfb27c099c30ce1	DEU                             
c45ca1e791f2849d9d11b3948fdefb74	DEU                             
b05f3966288598b02cda4a41d6d1eb6b	DEU                             
6ff4735b0fc4160e081440b3f7238925	DEU                             
d5282bd6b63b4cd51b50b40d192f1161	DEU                             
5159fd46698ae21d56f1684c2041bd79	DEU                             
c63ecd19a0ca74c22dfcf3063c9805d2	DEU                             
e08f00b43f7aa539eb60cfa149afd92e	DEU                             
5ef6a0f70220936a0158ad66fd5d9082	DEU                             
25ebb3d62ad1160c96bbdea951ad2f34	DEU                             
d97a4c5c71013baac562c2b5126909e1	DEU                             
1ebe59bfb566a19bc3ce5f4fb6c79cd3	DEU                             
7f499363c322c1243827700c67a7591c	DEU                             
2040754b0f9589a89ce88912bcf0648e	DEU                             
13cd421d8a1cb48800543b9317aa2f52	DEU                             
4b9f3b159347c34232c9f4b220cb22de	DEU                             
81a17f1bf76469b18fbe410d8ec77da8	DEU                             
15137b95180ccc986f6321acffb9cb6f	DEU                             
20d32d36893828d060096b2cd149820b	DEU                             
546f8a4844ac636dd18025dcc673a3ab	DEU                             
ce5e821f2dcc57569eae793f628c99cf	DEU                             
cd11b262d721d8b3f35ad2d2af8431dd	DEU                             
15cee64305c1b40a4fac10c26ffa227d	DEU                             
3771bd5f354df475660a24613fcb7a8c	DEU                             
f43bb3f980f58c66fc81874924043946	DEU                             
069cdf9184e271a3c6d45ad7e86fcac2	DEU                             
49f6021766f78bffb3f824eb199acfbc	DEU                             
f04de6fafc611682779eb2eb36bdbe25	DEU                             
f7c31a68856cab2620244be2df27c728	DEU                             
ae2056f2540325e2de91f64f5ac130b6	DEU                             
eced087124a41417845c0b0f4ff44ba9	DEU                             
edaf03c0c66aa548df3cebdae0f94545	DEU                             
16cbdd4df5f89d771dccfa1111d7f4bc	DEU                             
9abdb4a0588186fc4425b29080e820a2	DEU                             
06a4594d3b323539e9dc4820625d01b8	DEU                             
b5c7675d6faefd09e871a6c1157e9353	DEU                             
df8457281db2cba8bbcb4b3b80f2b9a3	DEU                             
f85df6e18a73a6d1f5ccb59ee51558ae	DEU                             
0308321fc4f75ddaed8208c24f2cb918	DEU                             
7acb475eda543ccd0622d546c5772c5a	DEU                             
ba8d3efe842e0755020a2f1bc5533585	DEU                             
5a154476dd67358f4dab8500076dece3	DEU                             
b8e18040dc07eead8e6741733653a740	DEU                             
0bc244b6aa99080c3d37fea06d328193	DEU                             
\.


--
-- Data for Name: bands_events; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands_events (id_band, id_event) FROM stdin;
0020f19414b5f2874a0bfacd9d511b84	6b09e6ae26a0d03456b17df4c0964a2f
0020f19414b5f2874a0bfacd9d511b84	d5cd210a82be3dd1a7879b83ba5657c0
0020f19414b5f2874a0bfacd9d511b84	f8549f73852c778caa3e9c09558739f2
006fc2724417174310cf06d2672e34d2	084c45f4c0bf86930df25ae1c59b3fe6
02d44fbbe1bfacd6eaa9b20299b1cb78	633f06bd0bd191373d667af54af0939b
058fcf8b126253956deb3ce672d107a7	63a722e7e0aa4866721305fab1342530
058fcf8b126253956deb3ce672d107a7	9e829f734a90920dd15d3b93134ee270
059792b70fc0686fb296e7fcae0bda50	084c45f4c0bf86930df25ae1c59b3fe6
0640cfbf1d269b69c535ea4e288dfd96	7e2e7fa5ce040664bf7aaaef1cebd897
065b56757c6f6a0fba7ab0c64e4c1ae1	0a85beacde1a467e23452f40b4710030
06efe152a554665e02b8dc4f620bf3f1	42c7a1c1e7836f74ced153a27d98cef0
076365679712e4206301117486c3d0ec	ec9a23a8132c85ca37af85c69a2743c5
0780d2d1dbd538fec3cdd8699b08ea02	ff3bed6eb88bb82b3a77ddaf50933689
0844ad55f17011abed4a5208a3a05b74	8640cd270510da320a9dd71429b95531
0903a7e60f0eb20fdc8cc0b8dbd45526	dae84dc2587a374c667d0ba291f33481
095849fbdc267416abc6ddb48be311d7	a7fe0b5f5ae6fbfa811d754074e03d95
09d8e20a5368ce1e5c421a04cb566434	2a6b51056784227b35e412c444f54359
0a267617c0b5b4d53e43a7d4e4c522ad	a7fe0b5f5ae6fbfa811d754074e03d95
0a56095b73dcbd2a76bb9d4831881cb3	ff3bed6eb88bb82b3a77ddaf50933689
0a7ba3f35a9750ff956dca1d548dad12	f5a56d2eb1cd18bf3059cc15519097ea
0a97b893b92a7df612eadfe97589f242	00f269da8a1eee6c08cebcc093968ee1
0af74c036db52f48ad6cbfef6fee2999	dae84dc2587a374c667d0ba291f33481
0b0d1c3752576d666c14774b8233889f	cc4617b9ce3c2eee5d1e566eb2fbb1f6
0b6e98d660e2901c33333347da37ad36	abefb7041d2488eadeedba9a0829b753
0cdf051c93865faa15cbc5cd3d2b69fb	0aa506a505f1115202f993ee4d650480
0e2ea6aa669710389cf4d6e2ddf408c4	0a85beacde1a467e23452f40b4710030
0fbddeb130361265f1ba6f86b00f0968	a7fe0b5f5ae6fbfa811d754074e03d95
1056b63fdc3c5015cc4591aa9989c14f	1ea2f5c46c57c12dea2fed56cb87566f
1056b63fdc3c5015cc4591aa9989c14f	20b7e40ecd659c47ca991e0d420a54eb
1056b63fdc3c5015cc4591aa9989c14f	53812183e083ed8a87818371d6b3dbfb
1056b63fdc3c5015cc4591aa9989c14f	abefb7041d2488eadeedba9a0829b753
108c58fc39b79afc55fac7d9edf4aa2a	43bcb284a3d1a0eea2c7923d45b7f14e
108c58fc39b79afc55fac7d9edf4aa2a	64896cd59778f32b1c61561a21af6598
108c58fc39b79afc55fac7d9edf4aa2a	ec9a23a8132c85ca37af85c69a2743c5
10d91715ea91101cfe0767c812da8151	1104831a0d0fe7d2a6a4198c781e0e0d
1104831a0d0fe7d2a6a4198c781e0e0d	1104831a0d0fe7d2a6a4198c781e0e0d
1104831a0d0fe7d2a6a4198c781e0e0d	372ca4be7841a47ba693d4de7d220981
11635778f116ce6922f6068638a39028	1fad423d9d1f48b7bd6d31c8d5cb17ed
11f8d9ec8f6803ea61733840f13bc246	189f11691712600d4e1b0bdb4122e8aa
1209f43dbecaba22f3514bf40135f991	53812183e083ed8a87818371d6b3dbfb
121189969c46f49b8249633c2d5a7bfa	42c7a1c1e7836f74ced153a27d98cef0
13caf3d14133dfb51067264d857eaf70	9e829f734a90920dd15d3b93134ee270
14ab730fe0172d780da6d9e5d432c129	abefb7041d2488eadeedba9a0829b753
1734b04cf734cb291d97c135d74b4b87	00da417154f2da39e79c9dcf4d7502fa
1734b04cf734cb291d97c135d74b4b87	f8ead2514f0df3c6e8ec84b992dd6e44
187ebdf7947f4b61e0725c93227676a4	060fd8422f03df6eca94da7605b3a9cd
19baf8a6a25030ced87cd0ce733365a9	a7fe0b5f5ae6fbfa811d754074e03d95
1ac0c8e8c04cf2d6f02fdb8292e74588	63a722e7e0aa4866721305fab1342530
1ac0c8e8c04cf2d6f02fdb8292e74588	abefb7041d2488eadeedba9a0829b753
1bc1f7348d79a353ea4f594de9dd1392	a72c5a8b761c2fc1097f162eeda5d5db
1c06fc6740d924cab33dce73643d84b9	f861455af8364fc3fe01aef3fc597905
1c6987adbe5ab3e4364685e8caed0f59	d2a4c05671f768ba487ad365d2a0fb6e
1cdd53cece78d6e8dffcf664fa3d1be2	189f11691712600d4e1b0bdb4122e8aa
1cdd53cece78d6e8dffcf664fa3d1be2	85c434b11120b4ba2f116e89843a594e
1cdd53cece78d6e8dffcf664fa3d1be2	f5a56d2eb1cd18bf3059cc15519097ea
1da77fa5b97c17be83cc3d0693c405cf	9e829f734a90920dd15d3b93134ee270
1e14d6b40d8e81d8d856ba66225dcbf3	abefb7041d2488eadeedba9a0829b753
1e8563d294da81043c2772b36753efaf	a72c5a8b761c2fc1097f162eeda5d5db
1e88302efcfc873691f0c31be4e2a388	488af8bdc554488b6c8854fae6ae8610
1e9413d4cc9af0ad12a6707776573ba0	00f269da8a1eee6c08cebcc093968ee1
1e9413d4cc9af0ad12a6707776573ba0	85c434b11120b4ba2f116e89843a594e
1e9413d4cc9af0ad12a6707776573ba0	d8f60019c8e6cdbb84839791fd989d81
1ebd63d759e9ff532d5ce63ecb818731	ca69aebb5919e75661d929c1fbd39582
2082a7d613f976e7b182a3fe80a28958	dae84dc2587a374c667d0ba291f33481
2113f739f81774557041db616ee851e6	633f06bd0bd191373d667af54af0939b
218f2bdae8ad3bb60482b201e280ffdc	a7fe0b5f5ae6fbfa811d754074e03d95
2252d763a2a4ac815b122a0176e3468f	d5cd210a82be3dd1a7879b83ba5657c0
237e378c239b44bff1e9a42ab866580c	a122cd22f946f0c229745d88d89b05bd
2414366fe63cf7017444181acacb6347	00f269da8a1eee6c08cebcc093968ee1
2447873ddeeecaa165263091c0cbb22f	f8549f73852c778caa3e9c09558739f2
249229ca88aa4a8815315bb085cf4d61	553a00f0c40ce1b1107f833da69988e4
249789ae53c239814de8e606ff717ec9	abefb7041d2488eadeedba9a0829b753
24ff2b4548c6bc357d9d9ab47882661e	3af7c6d148d216f13f66669acb8d5c59
2501f7ba78cc0fd07efb7c17666ff12e	d8f74ab86e77455ffbd398065ee109a8
264721f3fc2aee2d28dadcdff432dbc1	f68790d8b2f82aad75f0c27be554ee48
2672777b38bc4ce58c49cf4c82813a42	5e65cc6b7435c63dac4b2baf17ab5838
278606b1ac0ae7ef86e86342d1f259c3	1104831a0d0fe7d2a6a4198c781e0e0d
278c094627c0dd891d75ea7a3d0d021e	abefb7041d2488eadeedba9a0829b753
2876f7ecdae220b3c0dcb91ff13d0590	6b09e6ae26a0d03456b17df4c0964a2f
28a95ef0eabe44a27f49bbaecaa8a847	0a85beacde1a467e23452f40b4710030
28bb59d835e87f3fd813a58074ca0e11	d8f60019c8e6cdbb84839791fd989d81
28bc31b338dbd482802b77ed1fd82a50	d5cd210a82be3dd1a7879b83ba5657c0
28f843fa3a493a3720c4c45942ad970e	0a85beacde1a467e23452f40b4710030
28f843fa3a493a3720c4c45942ad970e	8368e0fd31972c67de1117fb0fe12268
28f843fa3a493a3720c4c45942ad970e	d2a4c05671f768ba487ad365d2a0fb6e
28f843fa3a493a3720c4c45942ad970e	d8f60019c8e6cdbb84839791fd989d81
2a024edafb06c7882e2e1f7b57f2f951	d2a4c05671f768ba487ad365d2a0fb6e
2aae4f711c09481c8353003202e05359	6b09e6ae26a0d03456b17df4c0964a2f
2ac79000a90b015badf6747312c0ccad	9afc751ca7f2d91d23c453b32fd21864
2ac79000a90b015badf6747312c0ccad	d5cd210a82be3dd1a7879b83ba5657c0
2ac79000a90b015badf6747312c0ccad	ec9a23a8132c85ca37af85c69a2743c5
2af9e4497582a6faa68a42ac2d512735	06e5f3d0d817c436d351a9cf1bf94dfa
2cf65e28c586eeb98daaecf6eb573e7a	dae84dc2587a374c667d0ba291f33481
2cfe35095995e8dd15ab7b867e178c15	abefb7041d2488eadeedba9a0829b753
2df8905eae6823023de6604dc5346c29	0aa506a505f1115202f993ee4d650480
2e7a848dc99bd27acb36636124855faf	00f269da8a1eee6c08cebcc093968ee1
2fa2f1801dd37d6eb9fe4e34a782e397	dae84dc2587a374c667d0ba291f33481
31d8a0a978fad885b57a685b1a0229df	a7fe0b5f5ae6fbfa811d754074e03d95
32814ff4ca9a26b8d430a8c0bc8dc63e	ff3bed6eb88bb82b3a77ddaf50933689
32af59a47b8c7e1c982ae797fc491180	189f11691712600d4e1b0bdb4122e8aa
32af59a47b8c7e1c982ae797fc491180	62f7101086340682e5bc58a86976cfb5
33b6f1b596a60fa87baef3d2c05b7c04	3f15c445cb553524b235b01ab75fe9a6
348bcdb386eb9cb478b55a7574622b7c	f5a56d2eb1cd18bf3059cc15519097ea
3509af6be9fe5defc1500f5c77e38563	f68790d8b2f82aad75f0c27be554ee48
360c000b499120147c8472998859a9fe	85c434b11120b4ba2f116e89843a594e
3614c45db20ee41e068c2ab7969eb3b5	2a6b51056784227b35e412c444f54359
362f8cdd1065b0f33e73208eb358991d	d2a4c05671f768ba487ad365d2a0fb6e
3656edf3a40a25ccd00d414c9ecbb635	a7fe0b5f5ae6fbfa811d754074e03d95
36648510adbf2a3b2028197a60b5dada	372ca4be7841a47ba693d4de7d220981
36cbc41c1c121f2c68f5776a118ea027	f5a56d2eb1cd18bf3059cc15519097ea
36f969b6aeff175204078b0533eae1a0	f861455af8364fc3fe01aef3fc597905
37f02eba79e0a3d29dfd6a4cf2f4d019	dae84dc2587a374c667d0ba291f33481
3964d4f40b6166aa9d370855bd20f662	abefb7041d2488eadeedba9a0829b753
39e83bc14e95fcbc05848fc33c30821f	a7fe0b5f5ae6fbfa811d754074e03d95
3a2a7f86ca87268be9b9e0557b013565	62f7101086340682e5bc58a86976cfb5
3af7c6d148d216f13f66669acb8d5c59	3af7c6d148d216f13f66669acb8d5c59
3af7c6d148d216f13f66669acb8d5c59	d5cd210a82be3dd1a7879b83ba5657c0
3bd94845163385cecefc5265a2e5a525	53812183e083ed8a87818371d6b3dbfb
3be3e956aeb5dc3b16285463e02af25b	6b09e6ae26a0d03456b17df4c0964a2f
3cdb47307aeb005121b09c41c8d8bee6	a626f2fb0794eeb25b074b4c43776634
3cdb47307aeb005121b09c41c8d8bee6	d1832e7b44502c04ec5819ef3085371a
3d01ff8c75214314c4ca768c30e6807b	0a85beacde1a467e23452f40b4710030
3d01ff8c75214314c4ca768c30e6807b	6d5c464f0c139d97e715c51b43983695
3d01ff8c75214314c4ca768c30e6807b	85c434b11120b4ba2f116e89843a594e
3d01ff8c75214314c4ca768c30e6807b	a122cd22f946f0c229745d88d89b05bd
3d2ff8abd980d730b2f4fd0abae52f60	3f15c445cb553524b235b01ab75fe9a6
3d6ff25ab61ad55180a6aee9b64515bf	0a85beacde1a467e23452f40b4710030
3dda886448fe98771c001b56a4da9893	a7fe0b5f5ae6fbfa811d754074e03d95
3e52c77d795b7055eeff0c44687724a1	6b09e6ae26a0d03456b17df4c0964a2f
3e75cd2f2f6733ea4901458a7ce4236d	a2cc2bc245b90654e721d7040c028647
3f15c445cb553524b235b01ab75fe9a6	3f15c445cb553524b235b01ab75fe9a6
401357e57c765967393ba391a338e89b	12e7b1918420daf69b976a5949f9ba85
401357e57c765967393ba391a338e89b	e1baa5fa38e1e6c824f2011f89475f03
405c7f920b019235f244315a564a8aed	0e4e0056244fb82f89e66904ad62fdaf
4094ffd492ba473a2a7bea1b19b1662d	20cf9df7281c50060aaf023e04fd5082
410d913416c022077c5c1709bf104d3c	1ea2f5c46c57c12dea2fed56cb87566f
42563d0088d6ac1a47648fc7621e77c6	f8549f73852c778caa3e9c09558739f2
4261335bcdc95bd89fd530ba35afbf4c	00f269da8a1eee6c08cebcc093968ee1
426fdc79046e281c5322161f011ce68c	0a85beacde1a467e23452f40b4710030
4276250c9b1b839b9508825303c5c5ae	189f11691712600d4e1b0bdb4122e8aa
4366d01be1b2ddef162fc0ebb6933508	1ea2f5c46c57c12dea2fed56cb87566f
4366d01be1b2ddef162fc0ebb6933508	f10fa26efffb6c69534e7b0f7890272d
44012166c6633196dc30563db3ffd017	62f7101086340682e5bc58a86976cfb5
443866d78de61ab3cd3e0e9bf97a34f6	372ca4be7841a47ba693d4de7d220981
4453eb658c6a304675bd52ca75fbae6d	d2a4c05671f768ba487ad365d2a0fb6e
449b4d758aa7151bc1bbb24c3ffb40bb	be95780f2b4fba1a76846b716e69ed6d
44b7bda13ac1febe84d8607ca8bbf439	0aa506a505f1115202f993ee4d650480
44f2dc3400ce17fad32a189178ae72fa	d3284558d8cda50eb33b5e5ce91da2af
450948d9f14e07ba5e3015c2d726b452	d3284558d8cda50eb33b5e5ce91da2af
4548a3b9c1e31cf001041dc0d166365b	0a85beacde1a467e23452f40b4710030
4548a3b9c1e31cf001041dc0d166365b	20cf9df7281c50060aaf023e04fd5082
457f098eeb8e1518008449e9b1cb580d	6b09e6ae26a0d03456b17df4c0964a2f
46174766ce49edbbbc40e271c87b5a83	d45cf5e6b7af0cee99b37f15b13360ed
47b23e889175dde5d6057db61cb52847	372ca4be7841a47ba693d4de7d220981
485065ad2259054abf342d7ae3fe27e6	d2a4c05671f768ba487ad365d2a0fb6e
4927f3218b038c780eb795766dfd04ee	6b09e6ae26a0d03456b17df4c0964a2f
49c4097bae6c6ea96f552e38cfb6c2d1	0a85beacde1a467e23452f40b4710030
4a2a0d0c29a49d9126dcb19230aa1994	2a6b51056784227b35e412c444f54359
4a45ac6d83b85125b4163a40364e7b2c	d3284558d8cda50eb33b5e5ce91da2af
4a7d9e528dada8409e88865225fb27c4	ca69aebb5919e75661d929c1fbd39582
4b503a03f3f1aec6e5b4d53dd8148498	d8f74ab86e77455ffbd398065ee109a8
4b98a8c164586e11779a0ef9421ad0ee	ec9a23a8132c85ca37af85c69a2743c5
4cabe475dd501f3fd4da7273b5890c33	a72c5a8b761c2fc1097f162eeda5d5db
4cfab0d66614c6bb6d399837656c590e	dae84dc2587a374c667d0ba291f33481
4dddd8579760abb62aa4b1910725e73c	f5a56d2eb1cd18bf3059cc15519097ea
4ee21b1371ba008a26b313c7622256f8	7126a50ce66fe18b84a7bfb3defea15f
4ee21b1371ba008a26b313c7622256f8	ca69aebb5919e75661d929c1fbd39582
4f48e858e9ed95709458e17027bb94bf	a61b878c2b563f289de2109fa0f42144
4f840b1febbbcdb12b9517cd0a91e8f4	e471494f42d963b13f025c0636c43763
4fa857a989df4e1deea676a43dceea07	a7fe0b5f5ae6fbfa811d754074e03d95
5037c1968f3b239541c546d32dec39eb	e471494f42d963b13f025c0636c43763
5194c60496c6f02e8b169de9a0aa542c	d2a4c05671f768ba487ad365d2a0fb6e
51fa80e44b7555c4130bd06c53f4835c	d45cf5e6b7af0cee99b37f15b13360ed
51fa80e44b7555c4130bd06c53f4835c	dae84dc2587a374c667d0ba291f33481
522b6c44eb0aedf4970f2990a2f2a812	5e45d87cab8e0b30fba4603b4821bfcd
529a1d385b4a8ca97ea7369477c7b6a7	d2a4c05671f768ba487ad365d2a0fb6e
52b133bfecec2fba79ecf451de3cf3bb	52b133bfecec2fba79ecf451de3cf3bb
52b133bfecec2fba79ecf451de3cf3bb	fcbfd4ea93701414772acad10ad93a5f
52ee4c6902f6ead006b0fb2f3e2d7771	0e4e0056244fb82f89e66904ad62fdaf
52ee4c6902f6ead006b0fb2f3e2d7771	a7ea7b6c1894204987ce4694c1febe03
52ee4c6902f6ead006b0fb2f3e2d7771	f10fa26efffb6c69534e7b0f7890272d
53369c74c3cacdc38bdcdeda9284fe3c	8224efe45b1d8a1ebc0b9fb0a5405ac6
53407737e93f53afdfc588788b8288e8	abefb7041d2488eadeedba9a0829b753
53a0aafa942245f18098ccd58b4121aa	abefb7041d2488eadeedba9a0829b753
5435326cf392e2cd8ad7768150cd5df6	a122cd22f946f0c229745d88d89b05bd
5447110e1e461c8c22890580c796277a	a72c5a8b761c2fc1097f162eeda5d5db
54b72f3169fea84731d3bcba785eac49	00da417154f2da39e79c9dcf4d7502fa
54b72f3169fea84731d3bcba785eac49	633f06bd0bd191373d667af54af0939b
54f0b93fa83225e4a712b70c68c0ab6f	4c90356614158305d8527b80886d2c1e
55159d04cc4faebd64689d3b74a94009	8224efe45b1d8a1ebc0b9fb0a5405ac6
559ccea48c3460ebc349587d35e808dd	633f06bd0bd191373d667af54af0939b
5842a0c2470fe12ee3acfeec16c79c57	00f269da8a1eee6c08cebcc093968ee1
585b13106ecfd7ede796242aeaed4ea8	ca69aebb5919e75661d929c1fbd39582
58db028cf01dd425e5af6c7d511291c1	00f269da8a1eee6c08cebcc093968ee1
58db028cf01dd425e5af6c7d511291c1	85c434b11120b4ba2f116e89843a594e
5952dff7a6b1b3c94238ad3c6a42b904	0e33f8fbbb12367a6e8159a3b096898a
59d153c1c2408b702189623231b7898a	4bc4f9db3d901e8efe90f60d85a0420d
59f06d56c38ac98effb4c6da117b0305	1fad423d9d1f48b7bd6d31c8d5cb17ed
59f06d56c38ac98effb4c6da117b0305	8224efe45b1d8a1ebc0b9fb0a5405ac6
5af874093e5efcbaeb4377b84c5f2ec5	d2a4c05671f768ba487ad365d2a0fb6e
5b20ea1312a1a21beaa8b86fe3a07140	c9a70f42ce4dcd82a99ed83a5117b890
5b22d1d5846a2b6b6d0cf342e912d124	d1ee83d5951b1668e95b22446c38ba1c
5b709b96ee02a30be5eee558e3058245	c8ee19d8e2f21851dc16db65d7b138bc
5c0adc906f34f9404d65a47eea76dac0	53812183e083ed8a87818371d6b3dbfb
5c0adc906f34f9404d65a47eea76dac0	ec9a23a8132c85ca37af85c69a2743c5
5cd1c3c856115627b4c3e93991f2d9cd	372ca4be7841a47ba693d4de7d220981
5ce10014f645da4156ddd2cd0965986e	1fad423d9d1f48b7bd6d31c8d5cb17ed
5ce10014f645da4156ddd2cd0965986e	ec9a23a8132c85ca37af85c69a2743c5
5df92b70e2855656e9b3ffdf313d7379	00f269da8a1eee6c08cebcc093968ee1
5e4317ada306a255748447aef73fff68	9afc751ca7f2d91d23c453b32fd21864
5ec1e9fa36898eaf6d1021be67e0d00c	0a85beacde1a467e23452f40b4710030
5efb7d24387b25d8325839be958d9adf	53812183e083ed8a87818371d6b3dbfb
5f992768f7bb9592bed35b07197c87d0	abefb7041d2488eadeedba9a0829b753
626dceb92e4249628c1e76a2c955cd24	a7fe0b5f5ae6fbfa811d754074e03d95
6369ba49db4cf35b35a7c47e3d4a4fd0	ec9a23a8132c85ca37af85c69a2743c5
63ad3072dc5472bb44c2c42ede26d90f	0a85beacde1a467e23452f40b4710030
63ad3072dc5472bb44c2c42ede26d90f	abefb7041d2488eadeedba9a0829b753
63ae1791fc0523f47bea9485ffec8b8c	d45cf5e6b7af0cee99b37f15b13360ed
63bd9a49dd18fbc89c2ec1e1b689ddda	0dcd062f5beffeaae2efae21ef9f3755
63d7f33143522ba270cb2c87f724b126	0a85beacde1a467e23452f40b4710030
63d7f33143522ba270cb2c87f724b126	633f06bd0bd191373d667af54af0939b
63d7f33143522ba270cb2c87f724b126	6b09e6ae26a0d03456b17df4c0964a2f
649db5c9643e1c17b3a44579980da0ad	a7fe0b5f5ae6fbfa811d754074e03d95
652208d2aa8cdd769632dbaeb7a16358	a72c5a8b761c2fc1097f162eeda5d5db
656d1497f7e25fe0559c6be81a4bccae	633f06bd0bd191373d667af54af0939b
65976b6494d411d609160a2dfd98f903	0e33f8fbbb12367a6e8159a3b096898a
660813131789b822f0c75c667e23fc85	dae84dc2587a374c667d0ba291f33481
66599a31754b5ac2a202c46c2b577c8e	f5a56d2eb1cd18bf3059cc15519097ea
6738f9acd4740d945178c649d6981734	372ca4be7841a47ba693d4de7d220981
679eaa47efb2f814f2642966ee6bdfe1	a7ea7b6c1894204987ce4694c1febe03
6830afd7158930ca7d1959ce778eb681	dae84dc2587a374c667d0ba291f33481
6a0e9ce4e2da4f2cbcd1292fddaa0ac6	1fad423d9d1f48b7bd6d31c8d5cb17ed
6b7cf117ecf0fea745c4c375c1480cb5	633f06bd0bd191373d667af54af0939b
6bafe8cf106c32d485c469d36c056989	8224efe45b1d8a1ebc0b9fb0a5405ac6
6bafe8cf106c32d485c469d36c056989	a72c5a8b761c2fc1097f162eeda5d5db
6bd19bad2b0168d4481b19f9c25b4a9f	d5cd210a82be3dd1a7879b83ba5657c0
6c00bb1a64f660600a6c1545377f92dc	12e7b1918420daf69b976a5949f9ba85
6c1fcd3c91bc400e5c16f467d75dced3	dae84dc2587a374c667d0ba291f33481
6c607fc8c0adc99559bc14e01170fee1	f5a56d2eb1cd18bf3059cc15519097ea
6d3b28f48c848a21209a84452d66c0c4	2a6b51056784227b35e412c444f54359
6d57b25c282247075f5e03cde27814df	00f269da8a1eee6c08cebcc093968ee1
6ee2e6d391fa98d7990b502e72c7ec58	4c90356614158305d8527b80886d2c1e
6f195d8f9fe09d45d2e680f7d7157541	5e45d87cab8e0b30fba4603b4821bfcd
6f199e29c5782bd05a4fef98e7e41419	a2cc2bc245b90654e721d7040c028647
71e32909a1bec1edfc09aec09ca2ac17	6b09e6ae26a0d03456b17df4c0964a2f
721c28f4c74928cc9e0bb3fef345e408	5e45d87cab8e0b30fba4603b4821bfcd
721c28f4c74928cc9e0bb3fef345e408	c8ee19d8e2f21851dc16db65d7b138bc
721c28f4c74928cc9e0bb3fef345e408	f8ead2514f0df3c6e8ec84b992dd6e44
72778afd2696801f5f3a1f35d0e4e357	7126a50ce66fe18b84a7bfb3defea15f
73affe574e6d4dc2fa72b46dc9dd4815	64896cd59778f32b1c61561a21af6598
73affe574e6d4dc2fa72b46dc9dd4815	9418ebabb93c5c1f47a05666913ec6e4
7462f03404f29ea618bcc9d52de8e647	0a85beacde1a467e23452f40b4710030
7463543d784aa59ca86359a50ef58c8e	0a85beacde1a467e23452f40b4710030
7492a1ca2669793b485b295798f5d782	372ca4be7841a47ba693d4de7d220981
74b3b7be6ed71b946a151d164ad8ede5	0e4e0056244fb82f89e66904ad62fdaf
7533f96ec01fd81438833f71539c7d4e	372ca4be7841a47ba693d4de7d220981
75ab0270163731ee05f35640d56ef473	a72c5a8b761c2fc1097f162eeda5d5db
76700087e932c3272e05694610d604ba	f68790d8b2f82aad75f0c27be554ee48
776da10f7e18ffde35ea94d144dc60a3	43bcb284a3d1a0eea2c7923d45b7f14e
776da10f7e18ffde35ea94d144dc60a3	663ea93736c204faee5f6c339203be3e
776da10f7e18ffde35ea94d144dc60a3	dae84dc2587a374c667d0ba291f33481
7771012413f955f819866e517b275cb4	6b09e6ae26a0d03456b17df4c0964a2f
77f2b3ea9e4bd785f5ff322bae51ba07	dae84dc2587a374c667d0ba291f33481
79566192cda6b33a9ff59889eede2d66	63a722e7e0aa4866721305fab1342530
79ce9bd96a3184b1ee7c700aa2927e67	4bc4f9db3d901e8efe90f60d85a0420d
7a4fafa7badd04d5d3114ab67b0caf9d	dae84dc2587a374c667d0ba291f33481
7c7ab6fbcb47bd5df1e167ca28220ee9	ec9a23a8132c85ca37af85c69a2743c5
7c83727aa466b3b1b9d6556369714fcf	be95780f2b4fba1a76846b716e69ed6d
7cd7921da2e6aab79c441a0c2ffc969b	9418ebabb93c5c1f47a05666913ec6e4
7cd7921da2e6aab79c441a0c2ffc969b	ca69aebb5919e75661d929c1fbd39582
7d6b45c02283175f490558068d1fc81b	ca69aebb5919e75661d929c1fbd39582
7d878673694ff2498fbea0e5ba27e0ea	9418ebabb93c5c1f47a05666913ec6e4
7d878673694ff2498fbea0e5ba27e0ea	d2a4c05671f768ba487ad365d2a0fb6e
7d878673694ff2498fbea0e5ba27e0ea	dae84dc2587a374c667d0ba291f33481
7db066b46f48d010fdb8c87337cdeda4	63a722e7e0aa4866721305fab1342530
7df8865bbec157552b8a579e0ed9bfe3	42c7a1c1e7836f74ced153a27d98cef0
7dfe9aa0ca5bb31382879ccd144cc3ae	dd50d5dcc02ea12c31e0ff495891dc22
7e0d5240ec5d34a30b6f24909e5edcb4	1fad423d9d1f48b7bd6d31c8d5cb17ed
7e0d5240ec5d34a30b6f24909e5edcb4	42c7a1c1e7836f74ced153a27d98cef0
7e0d5240ec5d34a30b6f24909e5edcb4	dd50d5dcc02ea12c31e0ff495891dc22
7e2b83d69e6c93adf203e13bc7d6f444	85c434b11120b4ba2f116e89843a594e
7e2b83d69e6c93adf203e13bc7d6f444	d5cd210a82be3dd1a7879b83ba5657c0
7e2b83d69e6c93adf203e13bc7d6f444	dae84dc2587a374c667d0ba291f33481
7eaf9a47aa47f3c65595ae107feab05d	dae84dc2587a374c667d0ba291f33481
7ef36a3325a61d4f1cff91acbe77c7e3	4c90356614158305d8527b80886d2c1e
7f29efc2495ce308a8f4aa7bfc11d701	c5593cbec8087184815492eee880f9a8
7fc454efb6df96e012e0f937723d24aa	084c45f4c0bf86930df25ae1c59b3fe6
804803e43d2c779d00004a6e87f28e30	a72c5a8b761c2fc1097f162eeda5d5db
80fcd08f6e887f6cfbedd2156841ab2b	a72c5a8b761c2fc1097f162eeda5d5db
8143ee8032c71f6f3f872fc5bb2a4fed	a2cc2bc245b90654e721d7040c028647
820de5995512273916b117944d6da15a	060fd8422f03df6eca94da7605b3a9cd
820de5995512273916b117944d6da15a	663ea93736c204faee5f6c339203be3e
828d51c39c87aad9b1407d409fa58e36	f10fa26efffb6c69534e7b0f7890272d
829922527f0e7d64a3cfda67e24351e3	d8f60019c8e6cdbb84839791fd989d81
832dd1d8efbdb257c2c7d3e505142f48	372ca4be7841a47ba693d4de7d220981
8589a6a4d8908d7e8813e9a1c5693d70	189f11691712600d4e1b0bdb4122e8aa
86482a1e94052aa18cd803a51104cdb9	ec9a23a8132c85ca37af85c69a2743c5
8654991720656374d632a5bb0c20ff11	a61b878c2b563f289de2109fa0f42144
8775f64336ee5e9a8114fbe3a5a628c5	c9a70f42ce4dcd82a99ed83a5117b890
87ded0ea2f4029da0a0022000d59232b	cc4617b9ce3c2eee5d1e566eb2fbb1f6
87f44124fb8d24f4c832138baede45c7	939fec794a3b41bc213c4df0c66c96f5
87f44124fb8d24f4c832138baede45c7	dae84dc2587a374c667d0ba291f33481
88711444ece8fe638ae0fb11c64e2df3	00f269da8a1eee6c08cebcc093968ee1
887d6449e3544dca547a2ddba8f2d894	20cf9df7281c50060aaf023e04fd5082
889aaf9cd0894206af758577cf5cf071	060fd8422f03df6eca94da7605b3a9cd
88dd124c0720845cba559677f3afa15d	00f269da8a1eee6c08cebcc093968ee1
891a55e21dfacf2f97c450c77e7c3ea7	9e829f734a90920dd15d3b93134ee270
8945663993a728ab19a3853e5b820a42	4bc4f9db3d901e8efe90f60d85a0420d
8945663993a728ab19a3853e5b820a42	9afc751ca7f2d91d23c453b32fd21864
897edb97d775897f69fa168a88b01c19	06e5f3d0d817c436d351a9cf1bf94dfa
89adcf990042dfdac7fd23685b3f1e37	a61b878c2b563f289de2109fa0f42144
8a6f1a01e4b0d9e272126a8646a72088	d45cf5e6b7af0cee99b37f15b13360ed
8b0ee5a501cef4a5699fd3b2d4549e8f	12e7b1918420daf69b976a5949f9ba85
8b0ee5a501cef4a5699fd3b2d4549e8f	26a40a3dc89f8b78c61fa31d1137482c
8b427a493fc39574fc801404bc032a2f	ca69aebb5919e75661d929c1fbd39582
8bc31f7cc79c177ab7286dda04e2d1e5	a72c5a8b761c2fc1097f162eeda5d5db
8c69497eba819ee79a964a0d790368fb	d5cd210a82be3dd1a7879b83ba5657c0
8ce896355a45f5b9959eb676b8b5580c	7126a50ce66fe18b84a7bfb3defea15f
8d7a18d54e82fcfb7a11566ce94b9109	2a6b51056784227b35e412c444f54359
8e11b2f987a99ed900a44aa1aa8bd3d0	abefb7041d2488eadeedba9a0829b753
8e62fc75d9d0977d0be4771df05b3c2f	64896cd59778f32b1c61561a21af6598
8e62fc75d9d0977d0be4771df05b3c2f	dae84dc2587a374c667d0ba291f33481
8edf4531385941dfc85e3f3d3e32d24f	372ca4be7841a47ba693d4de7d220981
8edf4531385941dfc85e3f3d3e32d24f	9418ebabb93c5c1f47a05666913ec6e4
8edf4531385941dfc85e3f3d3e32d24f	c8ee19d8e2f21851dc16db65d7b138bc
8edfa58b1aedb58629b80e5be2b2bd92	7e2e7fa5ce040664bf7aaaef1cebd897
8edfa58b1aedb58629b80e5be2b2bd92	a72c5a8b761c2fc1097f162eeda5d5db
8f1f10cb698cb995fd69a671af6ecd58	c9a70f42ce4dcd82a99ed83a5117b890
8fda25275801e4a40df6c73078baf753	f5a56d2eb1cd18bf3059cc15519097ea
905a40c3533830252a909603c6fa1e6a	00f269da8a1eee6c08cebcc093968ee1
90d127641ffe2a600891cd2e3992685b	2a6b51056784227b35e412c444f54359
90d523ebbf276f516090656ebfccdc9f	372ca4be7841a47ba693d4de7d220981
9138c2cc0326412f2515623f4c850eb3	189f11691712600d4e1b0bdb4122e8aa
9138c2cc0326412f2515623f4c850eb3	85c434b11120b4ba2f116e89843a594e
91a337f89fe65fec1c97f52a821c1178	f861455af8364fc3fe01aef3fc597905
4bb93d90453dd63cc1957a033f7855c7	d1ee83d5951b1668e95b22446c38ba1c
91b18e22d4963b216af00e1dd43b5d05	ec9a23a8132c85ca37af85c69a2743c5
91c9ed0262dea7446a4f3a3e1cdd0698	abefb7041d2488eadeedba9a0829b753
925bd435e2718d623768dbf1bc1cfb60	85c434b11120b4ba2f116e89843a594e
925bd435e2718d623768dbf1bc1cfb60	f8ead2514f0df3c6e8ec84b992dd6e44
935b48a84528c4280ec208ce529deea0	a7fe0b5f5ae6fbfa811d754074e03d95
942c9f2520684c22eb6216a92b711f9e	43bcb284a3d1a0eea2c7923d45b7f14e
942c9f2520684c22eb6216a92b711f9e	939fec794a3b41bc213c4df0c66c96f5
942c9f2520684c22eb6216a92b711f9e	dae84dc2587a374c667d0ba291f33481
947ce14614263eab49f780d68555aef8	a7fe0b5f5ae6fbfa811d754074e03d95
948098e746bdf1c1045c12f042ea98c2	d8f74ab86e77455ffbd398065ee109a8
952dc6362e304f00575264e9d54d1fa6	a7fe0b5f5ae6fbfa811d754074e03d95
96682d9c9f1bed695dbf9176d3ee234c	20b7e40ecd659c47ca991e0d420a54eb
96682d9c9f1bed695dbf9176d3ee234c	53812183e083ed8a87818371d6b3dbfb
96682d9c9f1bed695dbf9176d3ee234c	568177b2430c48380b6d8dab67dbe98c
96682d9c9f1bed695dbf9176d3ee234c	c150d400f383afb8e8427813549a82d3
96682d9c9f1bed695dbf9176d3ee234c	c3b4e4db5f94fac6979eb07371836e81
96682d9c9f1bed695dbf9176d3ee234c	eb2330cf8b87aa13aad89f32d6cfda18
97ee29f216391d19f8769f79a1218a71	d5cd210a82be3dd1a7879b83ba5657c0
988d10abb9f42e7053450af19ad64c7f	85c434b11120b4ba2f116e89843a594e
990813672e87b667add44c712bb28d3d	d8f60019c8e6cdbb84839791fd989d81
99bd5eff92fc3ba728a9da5aa1971488	084c45f4c0bf86930df25ae1c59b3fe6
9a322166803a48932356586f05ef83c7	6d5c464f0c139d97e715c51b43983695
9ab8f911c74597493400602dc4d2b412	2a6b51056784227b35e412c444f54359
9b1088b616414d0dc515ab1f2b4922f1	c8ee19d8e2f21851dc16db65d7b138bc
9bc2ca9505a273b06aa0b285061cd1de	f68790d8b2f82aad75f0c27be554ee48
9bc2ca9505a273b06aa0b285061cd1de	f861455af8364fc3fe01aef3fc597905
9cf73d0300eea453f17c6faaeb871c55	f68790d8b2f82aad75f0c27be554ee48
9d3ac6904ce73645c6234803cd7e47ca	6b09e6ae26a0d03456b17df4c0964a2f
9d969d25c9f506c5518bb090ad5f8266	d8f74ab86e77455ffbd398065ee109a8
9db9bc745a7568b51b3a968d215ddad6	dae84dc2587a374c667d0ba291f33481
9e84832a15f2698f67079a3224c2b6fb	a7fe0b5f5ae6fbfa811d754074e03d95
9f19396638dd8111f2cee938fdf4e455	2a6b51056784227b35e412c444f54359
a332f1280622f9628fccd1b7aac7370a	d5cd210a82be3dd1a7879b83ba5657c0
a3f5542dc915b94a5e10dab658bb0959	8368e0fd31972c67de1117fb0fe12268
a4902fb3d5151e823c74dfd51551b4b0	372ca4be7841a47ba693d4de7d220981
a4977b96c7e5084fcce21a0d07b045f8	64896cd59778f32b1c61561a21af6598
a4cbfb212102da21b82d94be555ac3ec	00f269da8a1eee6c08cebcc093968ee1
a538bfe6fe150a92a72d78f89733dbd0	663ea93736c204faee5f6c339203be3e
a61b878c2b563f289de2109fa0f42144	a61b878c2b563f289de2109fa0f42144
a650d82df8ca65bb69a45242ab66b399	dae84dc2587a374c667d0ba291f33481
a716390764a4896d99837e99f9e009c9	488af8bdc554488b6c8854fae6ae8610
a716390764a4896d99837e99f9e009c9	dae84dc2587a374c667d0ba291f33481
a7a9c1b4e7f10bd1fdf77aff255154f7	42c7a1c1e7836f74ced153a27d98cef0
a7f9797e4cd716e1516f9d4845b0e1e2	1fad423d9d1f48b7bd6d31c8d5cb17ed
a7f9797e4cd716e1516f9d4845b0e1e2	8224efe45b1d8a1ebc0b9fb0a5405ac6
a825b2b87f3b61c9660b81f340f6e519	ec9a23a8132c85ca37af85c69a2743c5
a8d9eeed285f1d47836a5546a280a256	6b09e6ae26a0d03456b17df4c0964a2f
a8d9eeed285f1d47836a5546a280a256	ca69aebb5919e75661d929c1fbd39582
aa86b6fc103fc757e14f03afe6eb0c0a	f8549f73852c778caa3e9c09558739f2
abbf8e3e3c3e78be8bd886484c1283c1	2a6b51056784227b35e412c444f54359
abd7ab19ff758cf4c1a2667e5bbac444	633f06bd0bd191373d667af54af0939b
ac03fad3be179a237521ec4ef2620fb0	0a85beacde1a467e23452f40b4710030
ac03fad3be179a237521ec4ef2620fb0	a72c5a8b761c2fc1097f162eeda5d5db
ac94d15f46f10707a39c4bc513cd9f98	06e5f3d0d817c436d351a9cf1bf94dfa
ad01952b3c254c8ebefaf6f73ae62f7d	0dcd062f5beffeaae2efae21ef9f3755
ad62209fb63910acf40280cea3647ec5	a7fe0b5f5ae6fbfa811d754074e03d95
ade72e999b4e78925b18cf48d1faafa4	e471494f42d963b13f025c0636c43763
aed85c73079b54830cd50a75c0958a90	633f06bd0bd191373d667af54af0939b
aed85c73079b54830cd50a75c0958a90	a7fe0b5f5ae6fbfa811d754074e03d95
b01fbaf98cfbc1b72e8bca0b2e48769c	00f269da8a1eee6c08cebcc093968ee1
b0ce1e93de9839d07dab8d268ca23728	7126a50ce66fe18b84a7bfb3defea15f
069cdf9184e271a3c6d45ad7e86fcac2	3af7c6d148d216f13f66669acb8d5c59
b14814d0ee12ffadc8f09ab9c604a9d0	939fec794a3b41bc213c4df0c66c96f5
b1bdad87bd3c4ac2c22473846d301a9e	3af7c6d148d216f13f66669acb8d5c59
b1bdad87bd3c4ac2c22473846d301a9e	85c434b11120b4ba2f116e89843a594e
b1d465aaf3ccf8701684211b1623adf2	dae84dc2587a374c667d0ba291f33481
b3ffff8517114caf70b9e70734dbaf6f	dae84dc2587a374c667d0ba291f33481
b570e354b7ebc40e20029fcc7a15e5a7	372ca4be7841a47ba693d4de7d220981
b570e354b7ebc40e20029fcc7a15e5a7	8224efe45b1d8a1ebc0b9fb0a5405ac6
b570e354b7ebc40e20029fcc7a15e5a7	9e829f734a90920dd15d3b93134ee270
b5d9c5289fe97968a5634b3e138bf9e2	f8ead2514f0df3c6e8ec84b992dd6e44
b5f7b25b0154c34540eea8965f90984d	a7ea7b6c1894204987ce4694c1febe03
b6da055500e3d92698575a3cfc74906c	63a722e7e0aa4866721305fab1342530
b885447285ece8226facd896c04cdba2	8640cd270510da320a9dd71429b95531
b885447285ece8226facd896c04cdba2	a2cc2bc245b90654e721d7040c028647
b89e91ccf14bfd7f485dd7be7d789b0a	9e829f734a90920dd15d3b93134ee270
b96a3cb81197e8308c87f6296174fe3e	0aa506a505f1115202f993ee4d650480
baa9d4eef21c7b89f42720313b5812d4	5e45d87cab8e0b30fba4603b4821bfcd
bb4cc149e8027369e71eb1bb36cd98e0	e1baa5fa38e1e6c824f2011f89475f03
bbb668ff900efa57d936e726a09e4fe8	dae84dc2587a374c667d0ba291f33481
bbc155fb2b111bf61c4f5ff892915e6b	be95780f2b4fba1a76846b716e69ed6d
bbce8e45250a239a252752fac7137e00	bbce8e45250a239a252752fac7137e00
bd4184ee062e4982b878b6b188793f5b	abefb7041d2488eadeedba9a0829b753
be20385e18333edb329d4574f364a1f0	553a00f0c40ce1b1107f833da69988e4
bfc9ace5d2a11fae56d038d68c601f00	00da417154f2da39e79c9dcf4d7502fa
c05d504b806ad065c9b548c0cb1334cd	568177b2430c48380b6d8dab67dbe98c
c127f32dc042184d12b8c1433a77e8c4	ec9a23a8132c85ca37af85c69a2743c5
c1923ca7992dc6e79d28331abbb64e72	cc4617b9ce3c2eee5d1e566eb2fbb1f6
c2855b6617a1b08fed3824564e15a653	060fd8422f03df6eca94da7605b3a9cd
c3490492512b7fe65cdb0c7305044675	dcda9434b422f9aa793f0a8874922306
c4678a2e0eef323aeb196670f2bc8a6e	633f06bd0bd191373d667af54af0939b
c4c7cb77b45a448aa3ca63082671ad97	00f269da8a1eee6c08cebcc093968ee1
c4ddbffb73c1c34d20bd5b3f425ce4b1	dae84dc2587a374c667d0ba291f33481
c4f0f5cedeffc6265ec3220ab594d56b	8640cd270510da320a9dd71429b95531
c5dc33e23743fb951b3fe7f1f477b794	8368e0fd31972c67de1117fb0fe12268
c5f022ef2f3211dc1e3b8062ffe764f0	00f269da8a1eee6c08cebcc093968ee1
c74b5aa120021cbe18dcddd70d8622da	0a85beacde1a467e23452f40b4710030
c883319a1db14bc28eff8088c5eba10e	2a6b51056784227b35e412c444f54359
ca5a010309ffb20190558ec20d97e5b2	d5cd210a82be3dd1a7879b83ba5657c0
cafe9e68e8f90b3e1328da8858695b31	ca69aebb5919e75661d929c1fbd39582
cafe9e68e8f90b3e1328da8858695b31	d2a4c05671f768ba487ad365d2a0fb6e
cd9483c1733b17f57d11a77c9404893c	9e829f734a90920dd15d3b93134ee270
cddf835bea180bd14234a825be7a7a82	d8f60019c8e6cdbb84839791fd989d81
ce2caf05154395724e4436f042b8fa53	00f269da8a1eee6c08cebcc093968ee1
ce2caf05154395724e4436f042b8fa53	d8f74ab86e77455ffbd398065ee109a8
cf4ee20655dd3f8f0a553c73ffe3f72a	2a6b51056784227b35e412c444f54359
d05a0e65818a69cc689b38c0c0007834	abefb7041d2488eadeedba9a0829b753
d0a1fd0467dc892f0dc27711637c864e	2a6b51056784227b35e412c444f54359
d1fb4e47d8421364f49199ee395ad1d3	cc4617b9ce3c2eee5d1e566eb2fbb1f6
d2ff1e521585a91a94fb22752dd0ab45	0a85beacde1a467e23452f40b4710030
d3e98095eeccaa253050d67210ef02bb	dd50d5dcc02ea12c31e0ff495891dc22
d3ed8223151e14b936436c336a4c7278	d45cf5e6b7af0cee99b37f15b13360ed
d433b7c1ce696b94a8d8f72de6cfbeaa	d5cd210a82be3dd1a7879b83ba5657c0
d449a9b2eed8b0556dc7be9cda36b67b	ca69aebb5919e75661d929c1fbd39582
d6de9c99f5cfa46352b2bc0be5c98c41	2a6b51056784227b35e412c444f54359
d730e65d54d6c0479561d25724afd813	ca69aebb5919e75661d929c1fbd39582
d73310b95e8b4dece44e2a55dd1274e6	c9a70f42ce4dcd82a99ed83a5117b890
d857ab11d383a7e4d4239a54cbf2a63d	084c45f4c0bf86930df25ae1c59b3fe6
d857ab11d383a7e4d4239a54cbf2a63d	9afc751ca7f2d91d23c453b32fd21864
d9ab6b54c3bd5b212e8dc3a14e7699ef	ff3bed6eb88bb82b3a77ddaf50933689
da2110633f62b16a571c40318e4e4c1c	53812183e083ed8a87818371d6b3dbfb
da867941c8bacf9be8e59bc13d765f92	06e5f3d0d817c436d351a9cf1bf94dfa
db38e12f9903b156f9dc91fce2ef3919	2a6b51056784227b35e412c444f54359
db46d9a37b31baa64cb51604a2e4939a	cc4617b9ce3c2eee5d1e566eb2fbb1f6
dcabc7299e2b9ed5b05c33273e5fdd19	f68790d8b2f82aad75f0c27be554ee48
dcff9a127428ffb03fc02fdf6cc39575	42c7a1c1e7836f74ced153a27d98cef0
dd18fa7a5052f2bce8ff7cb4a30903ea	85c434b11120b4ba2f116e89843a594e
dddb04bc0d058486d0ef0212c6ea0682	189f11691712600d4e1b0bdb4122e8aa
de12bbf91bc797df25ab4ae9cee1946b	6b09e6ae26a0d03456b17df4c0964a2f
deaccc41a952e269107cc9a507dfa131	8640cd270510da320a9dd71429b95531
dfdef9b5190f331de20fe029babf032e	dae84dc2587a374c667d0ba291f33481
e08383c479d96a8a762e23a99fd8bf84	d5cd210a82be3dd1a7879b83ba5657c0
e0c2b0cc2e71294cd86916807fef62cb	d2a4c05671f768ba487ad365d2a0fb6e
e0de9c10bbf73520385ea5dcbdf62073	63a722e7e0aa4866721305fab1342530
e0de9c10bbf73520385ea5dcbdf62073	ca69aebb5919e75661d929c1fbd39582
e0f39406f0e15487dd9d3997b2f5ca61	20cf9df7281c50060aaf023e04fd5082
e1db3add02ca4c1af33edc5a970a3bdc	d2a4c05671f768ba487ad365d2a0fb6e
e271e871e304f59e62a263ffe574ea2d	c150d400f383afb8e8427813549a82d3
e29ef4beb480eab906ffa7c05aeec23d	dae84dc2587a374c667d0ba291f33481
e3f0bf612190af6c3fad41214115e004	ca69aebb5919e75661d929c1fbd39582
e4b3296f8a9e2a378eb3eb9576b91a37	6b09e6ae26a0d03456b17df4c0964a2f
e61e30572fd58669ae9ea410774e0eb6	00f269da8a1eee6c08cebcc093968ee1
e62a773154e1179b0cc8c5592207cb10	ca69aebb5919e75661d929c1fbd39582
e64b94f14765cee7e05b4bec8f5fee31	ec9a23a8132c85ca37af85c69a2743c5
e64d38b05d197d60009a43588b2e4583	372ca4be7841a47ba693d4de7d220981
e67e51d5f41cfc9162ef7fd977d1f9f5	189f11691712600d4e1b0bdb4122e8aa
e74a88c71835c14d92d583a1ed87cc6c	6d5c464f0c139d97e715c51b43983695
e872b77ff7ac24acc5fa373ebe9bb492	e872b77ff7ac24acc5fa373ebe9bb492
e8afde257f8a2cbbd39d866ddfc06103	00f269da8a1eee6c08cebcc093968ee1
eb2c788da4f36fba18b85ae75aff0344	0a85beacde1a467e23452f40b4710030
ed24ff8971b1fa43a1efbb386618ce35	dae84dc2587a374c667d0ba291f33481
ee69e7d19f11ca58843ec2e9e77ddb38	ca69aebb5919e75661d929c1fbd39582
eeaeec364c925e0c821660c7a953546e	63a722e7e0aa4866721305fab1342530
ef6369d9794dbe861a56100e92a3c71d	d5cd210a82be3dd1a7879b83ba5657c0
f042da2a954a1521114551a6f9e22c75	4c90356614158305d8527b80886d2c1e
f042da2a954a1521114551a6f9e22c75	568177b2430c48380b6d8dab67dbe98c
f042da2a954a1521114551a6f9e22c75	d2a4c05671f768ba487ad365d2a0fb6e
f07c3eef5b7758026d45a12c7e2f6134	53812183e083ed8a87818371d6b3dbfb
f07c3eef5b7758026d45a12c7e2f6134	c3b4e4db5f94fac6979eb07371836e81
f0c051b57055b052a3b7da1608f3039e	eb2330cf8b87aa13aad89f32d6cfda18
f0e1f32b93f622ea3ddbf6b55b439812	dae84dc2587a374c667d0ba291f33481
f29d276fd930f1ad7687ed7e22929b64	2a6b51056784227b35e412c444f54359
f29d276fd930f1ad7687ed7e22929b64	d2a4c05671f768ba487ad365d2a0fb6e
f37ab058561fb6d233b9c2a0b080d4d1	dae84dc2587a374c667d0ba291f33481
f4219e8fec02ce146754a5be8a85f246	189f11691712600d4e1b0bdb4122e8aa
f4f870098db58eeae93742dd2bcaf2b2	0a85beacde1a467e23452f40b4710030
f60ab90d94b9cafe6b32f6a93ee8fcda	1fad423d9d1f48b7bd6d31c8d5cb17ed
f644bd92037985f8eb20311bc6d5ed94	00f269da8a1eee6c08cebcc093968ee1
f8e7112b86fcd9210dfaf32c00d6d375	0e33f8fbbb12367a6e8159a3b096898a
f953fa7b33e7b6503f4380895bbe41c8	8224efe45b1d8a1ebc0b9fb0a5405ac6
fa03eb688ad8aa1db593d33dabd89bad	abefb7041d2488eadeedba9a0829b753
faabbecd319372311ed0781d17b641d1	a72c5a8b761c2fc1097f162eeda5d5db
fb28e62c0e801a787d55d97615e89771	f10fa26efffb6c69534e7b0f7890272d
fb47f889f2c7c4fee1553d0f817b8aaa	85c434b11120b4ba2f116e89843a594e
fb8be6409408481ad69166324bdade9c	0a85beacde1a467e23452f40b4710030
fcd1c1b547d03e760d1defa4d2b98783	6b09e6ae26a0d03456b17df4c0964a2f
fdc90583bd7a58b91384dea3d1659cde	abefb7041d2488eadeedba9a0829b753
fe228019addf1d561d0123caae8d1e52	abefb7041d2488eadeedba9a0829b753
fe5b73c2c2cd2d9278c3835c791289b6	a72c5a8b761c2fc1097f162eeda5d5db
fe5b73c2c2cd2d9278c3835c791289b6	d1ee83d5951b1668e95b22446c38ba1c
ff578d3db4dc3311b3098c8365d54e6b	189f11691712600d4e1b0bdb4122e8aa
ff578d3db4dc3311b3098c8365d54e6b	a7fe0b5f5ae6fbfa811d754074e03d95
ff5b48d38ce7d0c47c57555d4783a118	d2a4c05671f768ba487ad365d2a0fb6e
ffa7450fd138573d8ae665134bccd02c	0a85beacde1a467e23452f40b4710030
fdcf3cdc04f367257c92382e032b6293	d0f1ffdb2d3a20a41f9c0f10df3b9386
bbddc022ee323e0a2b2d8c67e5cd321f	d0f1ffdb2d3a20a41f9c0f10df3b9386
4bb93d90453dd63cc1957a033f7855c7	d0f1ffdb2d3a20a41f9c0f10df3b9386
94ca28ea8d99549c2280bcc93f98c853	73d6ec35ad0e4ef8f213ba89d8bfd7d7
24ff2b4548c6bc357d9d9ab47882661e	73d6ec35ad0e4ef8f213ba89d8bfd7d7
1cdd53cece78d6e8dffcf664fa3d1be2	441306dd21b61d9a52e04b9e177cc9b5
6d89517dbd1a634b097f81f5bdbb07a2	441306dd21b61d9a52e04b9e177cc9b5
eb3bfb5a3ccdd4483aabc307ae236066	441306dd21b61d9a52e04b9e177cc9b5
0ab20b5ad4d15b445ed94fa4eebb18d8	441306dd21b61d9a52e04b9e177cc9b5
33f03dd57f667d41ac77c6baec352a81	441306dd21b61d9a52e04b9e177cc9b5
399033f75fcf47d6736c9c5209222ab8	441306dd21b61d9a52e04b9e177cc9b5
d9bc1db8c13da3a131d853237e1f05b2	441306dd21b61d9a52e04b9e177cc9b5
1197a69404ee9475146f3d631de12bde	441306dd21b61d9a52e04b9e177cc9b5
12e93f5fab5f7d16ef37711ef264d282	441306dd21b61d9a52e04b9e177cc9b5
fdcbfded0aaf369d936a70324b39c978	13afebb96e2d2d27345bd3b1fefc4db0
52ee4c6902f6ead006b0fb2f3e2d7771	13afebb96e2d2d27345bd3b1fefc4db0
96682d9c9f1bed695dbf9176d3ee234c	f3603438cf79ee848cb2f5e4a5884663
1056b63fdc3c5015cc4591aa9989c14f	f3603438cf79ee848cb2f5e4a5884663
754230e2c158107a2e93193c829e9e59	3c61b014201d6f62468d72d0363f7725
1ac0c8e8c04cf2d6f02fdb8292e74588	3c61b014201d6f62468d72d0363f7725
f042da2a954a1521114551a6f9e22c75	a71ac13634cd0b6d26e52d11c76f0a63
4fab532a185610bb854e0946f4def6a4	a71ac13634cd0b6d26e52d11c76f0a63
a29c1c4f0a97173007be3b737e8febcc	a71ac13634cd0b6d26e52d11c76f0a63
96048e254d2e02ba26f53edd271d3f88	8d821ce4aedb7300e067cfa9eb7f1eee
da29e297c23e7868f1d50ec5a6a4359b	8d821ce4aedb7300e067cfa9eb7f1eee
e6fd7b62a39c109109d33fcd3b5e129d	8d821ce4aedb7300e067cfa9eb7f1eee
e25ee917084bdbdc8506b56abef0f351	8d821ce4aedb7300e067cfa9eb7f1eee
6b7cf117ecf0fea745c4c375c1480cb5	8d821ce4aedb7300e067cfa9eb7f1eee
99bd5eff92fc3ba728a9da5aa1971488	8d821ce4aedb7300e067cfa9eb7f1eee
754230e2c158107a2e93193c829e9e59	fce1fb772d7bd71211bb915625ac11af
754230e2c158107a2e93193c829e9e59	95f89582ba9dcfbed475ebb3c06162db
96682d9c9f1bed695dbf9176d3ee234c	fce1fb772d7bd71211bb915625ac11af
c2275e8ac71d308946a63958bc7603a1	95f89582ba9dcfbed475ebb3c06162db
dde3e0b0cc344a7b072bbab8c429f4ff	9f1a399c301132b273f595b1cfc5e99d
3bcbddf6c114327fc72ea06bcb02f9ef	9f1a399c301132b273f595b1cfc5e99d
b785a5ffad5e7e36ccac25c51d5d8908	23fcfcbd4fa686b213960a04f49856f4
fb47f889f2c7c4fee1553d0f817b8aaa	d3582717412a80f08b23f8add23a1f35
2aae4f711c09481c8353003202e05359	23fcfcbd4fa686b213960a04f49856f4
4bb93d90453dd63cc1957a033f7855c7	54bf7e97edddf051b2a98b21b6d47e6a
f042da2a954a1521114551a6f9e22c75	bb378a3687cc64953bf36ccea6eb5a27
abd7ab19ff758cf4c1a2667e5bbac444	46ffa374af00ed2b76c1cfaa98b76e90
63c0a328ae2bee49789212822f79b83f	46ffa374af00ed2b76c1cfaa98b76e90
28bc31b338dbd482802b77ed1fd82a50	46ffa374af00ed2b76c1cfaa98b76e90
83d15841023cff02eafedb1c87df9b11	46ffa374af00ed2b76c1cfaa98b76e90
d9bc1db8c13da3a131d853237e1f05b2	46ffa374af00ed2b76c1cfaa98b76e90
99bd5eff92fc3ba728a9da5aa1971488	46ffa374af00ed2b76c1cfaa98b76e90
f03bde11d261f185cbacfa32c1c6538c	46ffa374af00ed2b76c1cfaa98b76e90
f6540bc63be4c0cb21811353c0d24f69	46ffa374af00ed2b76c1cfaa98b76e90
e4f0ad5ef0ac3037084d8a5e3ca1cabc	46ffa374af00ed2b76c1cfaa98b76e90
ea16d031090828264793e860a00cc995	46ffa374af00ed2b76c1cfaa98b76e90
5eed658c4b7b68a0ecc49205b68d54e7	46ffa374af00ed2b76c1cfaa98b76e90
a0fb30950d2a150c1d2624716f216316	0cd1c230352e99227f43acc46129d6b4
4ad6c928711328d1cf0167bc87079a14	0cd1c230352e99227f43acc46129d6b4
96e3cdb363fe6df2723be5b994ad117a	0cd1c230352e99227f43acc46129d6b4
c8d551145807972d194691247e7102a2	0cd1c230352e99227f43acc46129d6b4
96682d9c9f1bed695dbf9176d3ee234c	6f14a4e8ecdf87e02d77cec09b6c98b9
f0c051b57055b052a3b7da1608f3039e	6f14a4e8ecdf87e02d77cec09b6c98b9
3d01ff8c75214314c4ca768c30e6807b	808e3291422cea1b35c76af1b5ba5326
99bd5eff92fc3ba728a9da5aa1971488	808e3291422cea1b35c76af1b5ba5326
2a024edafb06c7882e2e1f7b57f2f951	808e3291422cea1b35c76af1b5ba5326
45b568ce63ea724c415677711b4328a7	20970f44b43a10d7282a77eda20866e2
10d91715ea91101cfe0767c812da8151	20970f44b43a10d7282a77eda20866e2
99bd5eff92fc3ba728a9da5aa1971488	9feb9a9930d633ef18e1dae581b65327
c238980432ab6442df9b2c6698c43e47	9feb9a9930d633ef18e1dae581b65327
145bd9cf987b6f96fa6f3b3b326303c9	9feb9a9930d633ef18e1dae581b65327
39a25b9c88ce401ca54fd7479d1c8b73	8342e65069254a6fd6d2bbc87aff8192
8cadf0ad04644ce2947bf3aa2817816e	8342e65069254a6fd6d2bbc87aff8192
85fac49d29a31f1f9a8a18d6b04b9fc9	8342e65069254a6fd6d2bbc87aff8192
b81ee269be538a500ed057b3222c86a2	8342e65069254a6fd6d2bbc87aff8192
cf71a88972b5e06d8913cf53c916e6e4	8342e65069254a6fd6d2bbc87aff8192
5518086aebc9159ba7424be0073ce5c9	8342e65069254a6fd6d2bbc87aff8192
2c4e2c9948ddac6145e529c2ae7296da	8342e65069254a6fd6d2bbc87aff8192
c9af1c425ca093648e919c2e471df3bd	8342e65069254a6fd6d2bbc87aff8192
0291e38d9a3d398052be0ca52a7b1592	8342e65069254a6fd6d2bbc87aff8192
8852173e80d762d62f0bcb379d82ebdb	8342e65069254a6fd6d2bbc87aff8192
000f49c98c428aff4734497823d04f45	8342e65069254a6fd6d2bbc87aff8192
dea293bdffcfb292b244b6fe92d246dc	8342e65069254a6fd6d2bbc87aff8192
1cdd53cece78d6e8dffcf664fa3d1be2	8342e65069254a6fd6d2bbc87aff8192
d0a1fd0467dc892f0dc27711637c864e	8342e65069254a6fd6d2bbc87aff8192
302ebe0389198972c223f4b72894780a	320951dccf4030808c979375af8356b6
ac62ad2816456aa712809bf01327add1	320951dccf4030808c979375af8356b6
470f3f69a2327481d26309dc65656f44	320951dccf4030808c979375af8356b6
e254616b4a5bd5aaa54f90a3985ed184	320951dccf4030808c979375af8356b6
3c5c578b7cf5cc0d23c1730d1d51436a	320951dccf4030808c979375af8356b6
eaeaed2d9f3137518a5c8c7e6733214f	320951dccf4030808c979375af8356b6
8ccd65d7f0f028405867991ae3eaeb56	320951dccf4030808c979375af8356b6
d0a1fd0467dc892f0dc27711637c864e	320951dccf4030808c979375af8356b6
5f992768f7bb9592bed35b07197c87d0	320951dccf4030808c979375af8356b6
b1bdad87bd3c4ac2c22473846d301a9e	320951dccf4030808c979375af8356b6
9ee30f495029e1fdf6567045f2079be1	fc0dc52ba0b7a645c4d70c0df70abb40
071dbd416520d14b2e3688145801de41	fc0dc52ba0b7a645c4d70c0df70abb40
781acc7e58c9a746d58f6e65ab1e90c4	7712d7dceef5a521b4a554c431752979
e5a674a93987de4a52230105907fffe9	7712d7dceef5a521b4a554c431752979
a2459c5c8a50215716247769c3dea40b	7712d7dceef5a521b4a554c431752979
e285e4ecb358b92237298f67526beff7	7712d7dceef5a521b4a554c431752979
dfdef9b5190f331de20fe029babf032e	7712d7dceef5a521b4a554c431752979
d832b654664d104f0fbb9b6674a09a11	7712d7dceef5a521b4a554c431752979
2aeb128c6d3eb7e79acb393b50e1cf7b	7712d7dceef5a521b4a554c431752979
213c449bd4bcfcdb6bffecf55b2c30b4	7712d7dceef5a521b4a554c431752979
4ea353ae22a1c0d26327638f600aeac8	7712d7dceef5a521b4a554c431752979
8b0ee5a501cef4a5699fd3b2d4549e8f	6118dc6a9a96e892fa5bbaac3ccb6d99
66244bb43939f81c100f03922cdc3439	6118dc6a9a96e892fa5bbaac3ccb6d99
7df8865bbec157552b8a579e0ed9bfe3	6118dc6a9a96e892fa5bbaac3ccb6d99
be20385e18333edb329d4574f364a1f0	6118dc6a9a96e892fa5bbaac3ccb6d99
8edfa58b1aedb58629b80e5be2b2bd92	9c697f7def422e3f6f885d3ec9741603
da2110633f62b16a571c40318e4e4c1c	9c697f7def422e3f6f885d3ec9741603
5b709b96ee02a30be5eee558e3058245	b1e4aa22275a6a4b3213b44fc342f9fe
754230e2c158107a2e93193c829e9e59	b1e4aa22275a6a4b3213b44fc342f9fe
96682d9c9f1bed695dbf9176d3ee234c	31c3824b57ad0919df18a79978c701e9
2df8905eae6823023de6604dc5346c29	31c3824b57ad0919df18a79978c701e9
776da10f7e18ffde35ea94d144dc60a3	fc0dc52ba0b7a645c4d70c0df70abb40
2df8905eae6823023de6604dc5346c29	fc0dc52ba0b7a645c4d70c0df70abb40
02d44fbbe1bfacd6eaa9b20299b1cb78	fc0dc52ba0b7a645c4d70c0df70abb40
a4977b96c7e5084fcce21a0d07b045f8	fc0dc52ba0b7a645c4d70c0df70abb40
9fc7c7342d41c7c53c6e8e4b9bc53fc4	fc0dc52ba0b7a645c4d70c0df70abb40
2ac79000a90b015badf6747312c0ccad	fc0dc52ba0b7a645c4d70c0df70abb40
652208d2aa8cdd769632dbaeb7a16358	fc0dc52ba0b7a645c4d70c0df70abb40
1ac0c8e8c04cf2d6f02fdb8292e74588	fc0dc52ba0b7a645c4d70c0df70abb40
5588cb8830fdb8ac7159b7cf5d1e611e	fc0dc52ba0b7a645c4d70c0df70abb40
4ad6c928711328d1cf0167bc87079a14	fc0dc52ba0b7a645c4d70c0df70abb40
a5a8afc6c35c2625298b9ce4cc447b39	fc0dc52ba0b7a645c4d70c0df70abb40
a538bfe6fe150a92a72d78f89733dbd0	fc0dc52ba0b7a645c4d70c0df70abb40
44b7bda13ac1febe84d8607ca8bbf439	fc0dc52ba0b7a645c4d70c0df70abb40
d399575133268305c24d87f1c2ef054a	fc0dc52ba0b7a645c4d70c0df70abb40
6ff24c538936b5b53e88258f88294666	fc0dc52ba0b7a645c4d70c0df70abb40
02f36cf6fe7b187306b2a7d423cafc2c	fc0dc52ba0b7a645c4d70c0df70abb40
26830d74f9ed8e7e4ea4e82e28fa4761	fc0dc52ba0b7a645c4d70c0df70abb40
ccff6df2a54baa3adeb0bddb8067e7c0	fc0dc52ba0b7a645c4d70c0df70abb40
4d79c341966242c047f3833289ee3a13	fc0dc52ba0b7a645c4d70c0df70abb40
c58de8415b504a6ffa5d0b14967f91bb	fc0dc52ba0b7a645c4d70c0df70abb40
03022be9e2729189e226cca023a2c9bf	fc0dc52ba0b7a645c4d70c0df70abb40
c2e88140e99f33883dac39daee70ac36	fc0dc52ba0b7a645c4d70c0df70abb40
368ff974da0defe085637b7199231c0a	fc0dc52ba0b7a645c4d70c0df70abb40
93f4aac22b526b5f0c908462da306ffc	fc0dc52ba0b7a645c4d70c0df70abb40
71e720cd3fcc3cdb99f2f4dc7122e078	fc0dc52ba0b7a645c4d70c0df70abb40
f17c7007dd2ed483b9df587c1fdac2c7	fc0dc52ba0b7a645c4d70c0df70abb40
32921081f86e80cd10138b8959260e1a	fc0dc52ba0b7a645c4d70c0df70abb40
ab7b69efdaf168cbbe9a5b03d901be74	fc0dc52ba0b7a645c4d70c0df70abb40
57b9fe77adaac4846c238e995adb6ee2	fc0dc52ba0b7a645c4d70c0df70abb40
3921cb3f97a88349e153beb5492f6ef4	fc0dc52ba0b7a645c4d70c0df70abb40
3041a64f7587a6768d8e307b2662785b	fc0dc52ba0b7a645c4d70c0df70abb40
8259dc0bcebabcb0696496ca406dd672	fc0dc52ba0b7a645c4d70c0df70abb40
2654d6e7cec2ef045ca1772a980fbc4c	fc0dc52ba0b7a645c4d70c0df70abb40
6a8538b37162b23d68791b9a0c54a5bf	fc0dc52ba0b7a645c4d70c0df70abb40
559ccea48c3460ebc349587d35e808dd	fc0dc52ba0b7a645c4d70c0df70abb40
e4f0ad5ef0ac3037084d8a5e3ca1cabc	fc0dc52ba0b7a645c4d70c0df70abb40
f9f57e175d62861bb5f2bda44a078df7	fc0dc52ba0b7a645c4d70c0df70abb40
17bcf0bc2768911a378a55f42acedba7	fc0dc52ba0b7a645c4d70c0df70abb40
a0fb30950d2a150c1d2624716f216316	fc0dc52ba0b7a645c4d70c0df70abb40
1bb6d0271ea775dfdfa7f9fe1048147a	fc0dc52ba0b7a645c4d70c0df70abb40
b04d1a151c786ee00092110333873a37	95cc14735b9cc969baa1fe1d8e4196ae
65b029279eb0f99c0a565926566f6759	95cc14735b9cc969baa1fe1d8e4196ae
9bfbfab5220218468ecb02ed546e3d90	95cc14735b9cc969baa1fe1d8e4196ae
be41b6cfece7dfa1b4e4d226fb999607	95cc14735b9cc969baa1fe1d8e4196ae
9c158607f29eaf8f567cc6304ada9c6d	95cc14735b9cc969baa1fe1d8e4196ae
ca7e3b5c1860730cfd7b400de217fef2	95cc14735b9cc969baa1fe1d8e4196ae
86482a1e94052aa18cd803a51104cdb9	700b8ca4c946e01dc92ab6c33757cafb
f0bf2458b4c1a22fc329f036dd439f08	700b8ca4c946e01dc92ab6c33757cafb
25fa2cdf2be085aa5394db743677fb69	700b8ca4c946e01dc92ab6c33757cafb
8f4e7c5f66d6ee5698c01de29affc562	700b8ca4c946e01dc92ab6c33757cafb
32917b03e82a83d455dd6b7f8609532c	b5b9346b4a9da4233b62daad23cf36ed
1209f43dbecaba22f3514bf40135f991	b5b9346b4a9da4233b62daad23cf36ed
3cdb47307aeb005121b09c41c8d8bee6	f87736b916e7d1ac60d0b7b1b7ca97b4
522b6c44eb0aedf4970f2990a2f2a812	57dc48deed395dc3a98caea535768d2f
4ffc374ef33b65b6acb388167ec542c0	57dc48deed395dc3a98caea535768d2f
0c2277f470a7e9a2d70195ba32e1b08a	57dc48deed395dc3a98caea535768d2f
42c9b99c6b409bc9990658f6e7829542	57dc48deed395dc3a98caea535768d2f
0bcf509f7eb2db3b663f5782c8c4a86e	57dc48deed395dc3a98caea535768d2f
3d01ff8c75214314c4ca768c30e6807b	bf742e78e40e9b736c8f8cc47a37277c
8c69497eba819ee79a964a0d790368fb	bf742e78e40e9b736c8f8cc47a37277c
2d1f30c9fc8d7200bdf15b730c4cd757	fc0dc52ba0b7a645c4d70c0df70abb40
a1cebab6ecfd371779f9c18e36cbba0c	fc0dc52ba0b7a645c4d70c0df70abb40
743c89c3e93b9295c1ae6e750047fb1e	fc0dc52ba0b7a645c4d70c0df70abb40
54c09bacc963763eb8742fa1da44a968	7c02da151320d3aa28b1e0f54b0264b0
828d51c39c87aad9b1407d409fa58e36	7c02da151320d3aa28b1e0f54b0264b0
52ee4c6902f6ead006b0fb2f3e2d7771	7c02da151320d3aa28b1e0f54b0264b0
095849fbdc267416abc6ddb48be311d7	824428dadd859deaf1af1916aea84cfc
e563e0ba5dbf7c9417681c407d016277	824428dadd859deaf1af1916aea84cfc
1745438c6be58479227d8c0d0220eec5	824428dadd859deaf1af1916aea84cfc
7e5550d889d46d55df3065d742b5da51	824428dadd859deaf1af1916aea84cfc
0870b61c5e913cb405d250e80c9ba9b9	824428dadd859deaf1af1916aea84cfc
393a71c997d856ed5bb85a9695be6e46	824428dadd859deaf1af1916aea84cfc
baa9d4eef21c7b89f42720313b5812d4	824428dadd859deaf1af1916aea84cfc
20f0ae2f661bf20e506108c40c33a6f3	824428dadd859deaf1af1916aea84cfc
96604499bfc96fcdb6da0faa204ff2fe	824428dadd859deaf1af1916aea84cfc
3ed0c2ad2c9e6e7b161e6fe0175fe113	824428dadd859deaf1af1916aea84cfc
57eba43d6bec2a8115e94d6fbb42bc75	fc0dc52ba0b7a645c4d70c0df70abb40
dd18fa7a5052f2bce8ff7cb4a30903ea	824428dadd859deaf1af1916aea84cfc
fd9a5c27c20cd89e4ffcc1592563abcf	824428dadd859deaf1af1916aea84cfc
a5475ebd65796bee170ad9f1ef746394	824428dadd859deaf1af1916aea84cfc
1fda271217bb4c043c691fc6344087c1	824428dadd859deaf1af1916aea84cfc
cba95a42c53bdc6fbf3ddf9bf10a4069	824428dadd859deaf1af1916aea84cfc
fe2c9aea6c702e6b82bc19b4a5d76f90	824428dadd859deaf1af1916aea84cfc
bb66c20c42c26f1874525c3ab956ec41	824428dadd859deaf1af1916aea84cfc
aad365e95c3d5fadb5fdf9517c371e89	824428dadd859deaf1af1916aea84cfc
2501f7ba78cc0fd07efb7c17666ff12e	824428dadd859deaf1af1916aea84cfc
925bd435e2718d623768dbf1bc1cfb60	824428dadd859deaf1af1916aea84cfc
88a51a2e269e7026f0734f3ef3244e89	824428dadd859deaf1af1916aea84cfc
5c1a922f41003eb7a19b570c33b99ff4	824428dadd859deaf1af1916aea84cfc
de506362ebfcf7c632d659aa1f2b465d	824428dadd859deaf1af1916aea84cfc
1a8780e5531549bd454a04630a74cd4d	824428dadd859deaf1af1916aea84cfc
c0d7362d0f52d119f1beb38b12c0b651	824428dadd859deaf1af1916aea84cfc
edd506a412c4f830215d4c0f1ac06e55	824428dadd859deaf1af1916aea84cfc
39e83bc14e95fcbc05848fc33c30821f	824428dadd859deaf1af1916aea84cfc
948098e746bdf1c1045c12f042ea98c2	824428dadd859deaf1af1916aea84cfc
dde31adc1b0014ce659a65c8b4d6ce42	824428dadd859deaf1af1916aea84cfc
4b503a03f3f1aec6e5b4d53dd8148498	824428dadd859deaf1af1916aea84cfc
4267b5081fdfb47c085db24b58d949e0	824428dadd859deaf1af1916aea84cfc
8f7de32e3b76c02859d6b007417bd509	824428dadd859deaf1af1916aea84cfc
332d6b94de399f86d499be57f8a5a5ca	9922a07485d25c089f12792a50c5bfad
b73377a1ec60e58d4eeb03347268c11b	9922a07485d25c089f12792a50c5bfad
e3419706e1838c7ce6c25a28bef0c248	9922a07485d25c089f12792a50c5bfad
d9bc1db8c13da3a131d853237e1f05b2	9922a07485d25c089f12792a50c5bfad
3af7c6d148d216f13f66669acb8d5c59	9922a07485d25c089f12792a50c5bfad
382ed38ecc68052678c5ac5646298b63	9922a07485d25c089f12792a50c5bfad
213c302f84c5d45929b66a20074075df	9922a07485d25c089f12792a50c5bfad
22c030759ab12f97e941af558566505e	9922a07485d25c089f12792a50c5bfad
f5507c2c7beee622b98ade0b93abb7fe	9922a07485d25c089f12792a50c5bfad
8c69497eba819ee79a964a0d790368fb	9922a07485d25c089f12792a50c5bfad
095849fbdc267416abc6ddb48be311d7	9922a07485d25c089f12792a50c5bfad
41bee031bd7d2fdb14ff48c92f4d7984	9922a07485d25c089f12792a50c5bfad
754230e2c158107a2e93193c829e9e59	9922a07485d25c089f12792a50c5bfad
b885447285ece8226facd896c04cdba2	9922a07485d25c089f12792a50c5bfad
39a464d24bf08e6e8df586eb5fa7ee30	9922a07485d25c089f12792a50c5bfad
f7c3dcc7ba01d0ead8e0cfb59cdf6afc	40c1eb30fa7abc7fdb3d8e35c61f6a7c
095849fbdc267416abc6ddb48be311d7	40c1eb30fa7abc7fdb3d8e35c61f6a7c
7e5550d889d46d55df3065d742b5da51	40c1eb30fa7abc7fdb3d8e35c61f6a7c
1745438c6be58479227d8c0d0220eec5	40c1eb30fa7abc7fdb3d8e35c61f6a7c
4b42093adfc268ce8974a3fa8c4f6bca	4eb278e51ecc7a4e052416dc604ad5c5
70d0b58ef51e537361d676f05ea39c7b	4eb278e51ecc7a4e052416dc604ad5c5
6f0eadd7aadf134b1b84d9761808d5ad	4eb278e51ecc7a4e052416dc604ad5c5
6896f30283ad47ceb4a17c8c8d625891	4eb278e51ecc7a4e052416dc604ad5c5
25118c5df9a2865a8bc97feb4aff4a18	4eb278e51ecc7a4e052416dc604ad5c5
5a53bed7a0e05c2b865537d96a39646f	4eb278e51ecc7a4e052416dc604ad5c5
29b7417c5145049d6593a0d88759b9ee	4eb278e51ecc7a4e052416dc604ad5c5
4176aa79eae271d1b82015feceb00571	4eb278e51ecc7a4e052416dc604ad5c5
c81794404ad68d298e9ceb75f69cf810	4eb278e51ecc7a4e052416dc604ad5c5
d0386252fd85f76fc517724666cf59ae	4eb278e51ecc7a4e052416dc604ad5c5
0cddbf403096e44a08bc37d1e2e99b0f	4eb278e51ecc7a4e052416dc604ad5c5
0b9d35d460b848ad46ec0568961113bf	4eb278e51ecc7a4e052416dc604ad5c5
546bb05114b78748d142c67cdbdd34fd	4eb278e51ecc7a4e052416dc604ad5c5
4ac863b6f6fa5ef02afdd9c1ca2a5e24	4eb278e51ecc7a4e052416dc604ad5c5
1e2bcbb679ccfdea27b28bd1ea9f2e67	4eb278e51ecc7a4e052416dc604ad5c5
4b42093adfc268ce8974a3fa8c4f6bca	8342e65069254a6fd6d2bbc87aff8192
942c9f2520684c22eb6216a92b711f9e	5c32c0f1d91f2c6579bb1e0b4da7d10c
b7e529a8e9af2a2610182b3d3fc33698	5c32c0f1d91f2c6579bb1e0b4da7d10c
1c62394f457ee9a56b0885f622299ea2	5c32c0f1d91f2c6579bb1e0b4da7d10c
3af7c6d148d216f13f66669acb8d5c59	e1c9ae13502e64fd6fa4121f4af7fb0e
64d9f86ed9eeac2695ec7847fe7ea313	e1c9ae13502e64fd6fa4121f4af7fb0e
4fab532a185610bb854e0946f4def6a4	52270ed38759952c9cbd6487b265a3a7
1cdd53cece78d6e8dffcf664fa3d1be2	52270ed38759952c9cbd6487b265a3a7
dd18fa7a5052f2bce8ff7cb4a30903ea	0e94c08f1e572c5415f66d193fbc322a
abd7ab19ff758cf4c1a2667e5bbac444	0e94c08f1e572c5415f66d193fbc322a
92df3fd170b0285cd722e855a2968393	0e94c08f1e572c5415f66d193fbc322a
b20a4217acaf4316739c6a5f6679ef60	0e94c08f1e572c5415f66d193fbc322a
5b709b96ee02a30be5eee558e3058245	fb40042479b7dab1545b6ff8b011e288
bb51d2b900ba638568e48193aada8a6c	fb40042479b7dab1545b6ff8b011e288
47b23e889175dde5d6057db61cb52847	fb40042479b7dab1545b6ff8b011e288
34b1dade51ffdab56daebcf6ac981371	cb155874b040e90a5653d5d13bab932b
9d57ebbd1d3b135839b78221388394a1	161882776281e759c9c63d385457ce2c
1833e2cfde2a7cf621d60288da14830c	161882776281e759c9c63d385457ce2c
65976b6494d411d609160a2dfd98f903	161882776281e759c9c63d385457ce2c
178227c5aef3b3ded144b9e19867a370	f10521a3f832fd2c698b1ac0319ea29a
7e2b83d69e6c93adf203e13bc7d6f444	f10521a3f832fd2c698b1ac0319ea29a
75cde58f0e5563f287f2d4afb0ce4b7e	f10521a3f832fd2c698b1ac0319ea29a
351af29ee203c740c3209a0e0a8e9c22	f10521a3f832fd2c698b1ac0319ea29a
b74881ac32a010e91ac7fcbcfebe210e	f10521a3f832fd2c698b1ac0319ea29a
b20a4217acaf4316739c6a5f6679ef60	f10521a3f832fd2c698b1ac0319ea29a
095849fbdc267416abc6ddb48be311d7	f10521a3f832fd2c698b1ac0319ea29a
1918775515a9c7b8db011fd35a443b82	9f348351c96df42bcc7496c2010d4d1d
f3b65f675d13d81c12d3bb30b0190cd1	9f348351c96df42bcc7496c2010d4d1d
6e512379810ecf71206459e6a1e64154	9f348351c96df42bcc7496c2010d4d1d
bbdbdf297183a1c24be29ed89711f744	9f348351c96df42bcc7496c2010d4d1d
0844ad55f17011abed4a5208a3a05b74	63cc3a7986e4e746cdb607be909b90d4
53369c74c3cacdc38bdcdeda9284fe3c	63cc3a7986e4e746cdb607be909b90d4
15bf34427540dd1945e5992583412b2f	63cc3a7986e4e746cdb607be909b90d4
ba8033b8cfb1ebfc91a5d03b3a268d9f	63cc3a7986e4e746cdb607be909b90d4
fd85bfffd5a0667738f6110281b25db8	7fc85de86476aadededbf6716f2eebad
fd85bfffd5a0667738f6110281b25db8	00da417154f2da39e79c9dcf4d7502fa
fd85bfffd5a0667738f6110281b25db8	441306dd21b61d9a52e04b9e177cc9b5
6e4b91e3d1950bcad012dbfbdd0fff09	7fc85de86476aadededbf6716f2eebad
4fab532a185610bb854e0946f4def6a4	7fc85de86476aadededbf6716f2eebad
32a02a8a7927de4a39e9e14f2dc46ac6	7fc85de86476aadededbf6716f2eebad
e6fd7b62a39c109109d33fcd3b5e129d	7fc85de86476aadededbf6716f2eebad
5435326cf392e2cd8ad7768150cd5df6	7fc85de86476aadededbf6716f2eebad
747f992097b9e5c9df7585931537150a	7fc85de86476aadededbf6716f2eebad
1cdd53cece78d6e8dffcf664fa3d1be2	7fc85de86476aadededbf6716f2eebad
1734b04cf734cb291d97c135d74b4b87	7fc85de86476aadededbf6716f2eebad
ee69e7d19f11ca58843ec2e9e77ddb38	7fc85de86476aadededbf6716f2eebad
fb47f889f2c7c4fee1553d0f817b8aaa	7fc85de86476aadededbf6716f2eebad
13c260ca90c0f47c9418790429220899	7fc85de86476aadededbf6716f2eebad
8945663993a728ab19a3853e5b820a42	18ef7142c02d84033cc9d41687981691
19819b153eb0990c821bc106e34ab3e1	18ef7142c02d84033cc9d41687981691
79ce9bd96a3184b1ee7c700aa2927e67	18ef7142c02d84033cc9d41687981691
804803e43d2c779d00004a6e87f28e30	18ef7142c02d84033cc9d41687981691
b619e7f3135359e3f778e90d1942e6f5	6b6bceac41ce67726a6218b1155f2e70
1104831a0d0fe7d2a6a4198c781e0e0d	6b6bceac41ce67726a6218b1155f2e70
754230e2c158107a2e93193c829e9e59	6b6bceac41ce67726a6218b1155f2e70
1ac0c8e8c04cf2d6f02fdb8292e74588	6b6bceac41ce67726a6218b1155f2e70
fb28e62c0e801a787d55d97615e89771	60bb0152f453d3f043b4dabee1a60513
54c09bacc963763eb8742fa1da44a968	60bb0152f453d3f043b4dabee1a60513
0ddd0b1b6329e9cb9a64c4d947e641a8	60bb0152f453d3f043b4dabee1a60513
30354302ae1c0715ccad2649da3d9443	60bb0152f453d3f043b4dabee1a60513
89eec5d48b8969bf61eea38e4b3cfdbf	6d7c6c981877a0dedcb276ef841e10aa
5518086aebc9159ba7424be0073ce5c9	6f745abd8c203f0f0e821ceeb77e5d24
703b1360391d2aef7b9ec688b00849bb	6f745abd8c203f0f0e821ceeb77e5d24
b4b46e6ce2c563dd296e8bae768e1b9d	6f745abd8c203f0f0e821ceeb77e5d24
110cb86243320511676f788dbc46f633	d5fba38ea6078ea36b9ac0539a8d40c9
8e9f5b1fc0e61f9a289aba4c59e49521	d5fba38ea6078ea36b9ac0539a8d40c9
5c8c8b827ae259b8e4f8cb567a577a3e	97a06553981fd4531de6d5542136b854
7f00429970ee9fd2a3185f777ff79922	97a06553981fd4531de6d5542136b854
92e2cf901fe43bb77d99af2ff42ade77	97a06553981fd4531de6d5542136b854
c4ddbffb73c1c34d20bd5b3f425ce4b1	97a06553981fd4531de6d5542136b854
1a1bfb986176c0ba845ae4f43d027f58	97a06553981fd4531de6d5542136b854
7ecdb1a0eb7c01d081acf2b7e11531c0	97a06553981fd4531de6d5542136b854
094caa14a3a49bf282d8f0f262a01f43	97a06553981fd4531de6d5542136b854
1cdd53cece78d6e8dffcf664fa3d1be2	7d126fe510b243454713c0ac4cd66011
54b72f3169fea84731d3bcba785eac49	7d126fe510b243454713c0ac4cd66011
8e9f5b1fc0e61f9a289aba4c59e49521	7d126fe510b243454713c0ac4cd66011
014dbc80621be3ddc6dd0150bc6571ff	7d126fe510b243454713c0ac4cd66011
9bfbfab5220218468ecb02ed546e3d90	8342e65069254a6fd6d2bbc87aff8192
6d57b25c282247075f5e03cde27814df	7d126fe510b243454713c0ac4cd66011
e8afde257f8a2cbbd39d866ddfc06103	7d126fe510b243454713c0ac4cd66011
536d1ccb9cce397f948171765c0120d4	7d126fe510b243454713c0ac4cd66011
15b70a4565372e2da0d330568fe1d795	7d126fe510b243454713c0ac4cd66011
8e331f2ea604deea899bfd0a494309ba	7d126fe510b243454713c0ac4cd66011
ff578d3db4dc3311b3098c8365d54e6b	7d126fe510b243454713c0ac4cd66011
46e1d00c2019ff857c307085c58e0015	7d126fe510b243454713c0ac4cd66011
6afdd78eac862dd63833a3ce5964b74b	7d126fe510b243454713c0ac4cd66011
fb5f71046fd15a0a22d7bda38971f142	7d126fe510b243454713c0ac4cd66011
512914f31042dacd2a05bfcebaacdb96	7d126fe510b243454713c0ac4cd66011
d96d9dac0f19368234a1fe2d4daf7f7c	7d126fe510b243454713c0ac4cd66011
5aa3856374df5daa99d3d33e6a38a865	7d126fe510b243454713c0ac4cd66011
e83655f0458b6c309866fbde556be35a	7d126fe510b243454713c0ac4cd66011
92dd59a949dfceab979dd25ac858f204	7d126fe510b243454713c0ac4cd66011
ee1bc524d6d3410e94a99706dcb12319	7d126fe510b243454713c0ac4cd66011
c09ffd48de204e4610d474ade2cf3a0d	7d126fe510b243454713c0ac4cd66011
3e7f48e97425d4c532a0787e54843863	9c553520982c65b603e9d741eaa56b09
bfff088b67e0fc6d1b80dbd6b6f0620c	9c553520982c65b603e9d741eaa56b09
34b1dade51ffdab56daebcf6ac981371	2cd4ca525a2d7af5ffa5f6286998ceb0
233dedc0bee8bbdf7930eab3dd54daee	2cd4ca525a2d7af5ffa5f6286998ceb0
80f19b325c934c8396780d0c66a87c99	e59ace10fad0af976f723748e6fd2ea8
3ccca65d3d9843b81f4e251dcf8a3e8c	89b8688929aebb711cffaa22561b1395
9144b4f0da4c96565c47c38f0bc16593	89b8688929aebb711cffaa22561b1395
10d91715ea91101cfe0767c812da8151	2200574eb6396407ec9fc642c91f0e5a
8b3d594047e4544f608c2ebb151aeb45	2200574eb6396407ec9fc642c91f0e5a
ca03a570b4d4a22329359dc105a9ef22	2200574eb6396407ec9fc642c91f0e5a
7fc454efb6df96e012e0f937723d24aa	cb16e5f28a9e5532485fe35beca8d438
f5eaa9c89bd215868235b0c068050883	cb16e5f28a9e5532485fe35beca8d438
dcd3968ac5b1ab25328f4ed42cdf2e2b	cb16e5f28a9e5532485fe35beca8d438
6e25aa27fcd893613fac13b0312fe36d	cb16e5f28a9e5532485fe35beca8d438
3614c45db20ee41e068c2ab7969eb3b5	cb16e5f28a9e5532485fe35beca8d438
63e961dd2daa48ed1dade27a54f03ec4	cb16e5f28a9e5532485fe35beca8d438
2113f739f81774557041db616ee851e6	cb16e5f28a9e5532485fe35beca8d438
9f10d335198e90990f3437c5733468e7	cb16e5f28a9e5532485fe35beca8d438
4cc6d79ef4cf3af13b6c9b77783e688b	cb16e5f28a9e5532485fe35beca8d438
da34d04ff19376defc2facc252e52cf0	cb16e5f28a9e5532485fe35beca8d438
eaf446aca5ddd602d0ab194667e7bec1	cb16e5f28a9e5532485fe35beca8d438
b34f0dad8c934ee71aaabb2a675f9822	cb16e5f28a9e5532485fe35beca8d438
c6458620084029f07681a55746ee4d69	cb16e5f28a9e5532485fe35beca8d438
ee325100d772dd075010b61b6f33c82a	cb16e5f28a9e5532485fe35beca8d438
950d43371e8291185e524550ad3fd0df	cb16e5f28a9e5532485fe35beca8d438
2aa7757363ff360f3a08283c1d157b2c	cb16e5f28a9e5532485fe35beca8d438
d71218f2abfdd51d95ba7995b93bd536	cb16e5f28a9e5532485fe35beca8d438
186aab3d817bd38f76c754001b0ab04d	cb16e5f28a9e5532485fe35beca8d438
12c0763f59f7697824567a3ca32191db	cb16e5f28a9e5532485fe35beca8d438
4e14f71c5702f5f71ad7de50587e2409	cb16e5f28a9e5532485fe35beca8d438
8f7d02638c253eb2d03118800c623203	cb16e5f28a9e5532485fe35beca8d438
70d0b58ef51e537361d676f05ea39c7b	cb16e5f28a9e5532485fe35beca8d438
237e378c239b44bff1e9a42ab866580c	cb16e5f28a9e5532485fe35beca8d438
9ee30f495029e1fdf6567045f2079be1	cb16e5f28a9e5532485fe35beca8d438
d2ec9ebbccaa3c6925b86d1bd528d12f	cb16e5f28a9e5532485fe35beca8d438
2cca468dcaea0a807f756b1de2b3ec7b	cb16e5f28a9e5532485fe35beca8d438
c8c012313f10e2d0830f3fbc5afca619	cb16e5f28a9e5532485fe35beca8d438
cafe9e68e8f90b3e1328da8858695b31	cb16e5f28a9e5532485fe35beca8d438
cf3ecbdc9b5ae9c5a87ab05403691350	cb16e5f28a9e5532485fe35beca8d438
9323fc63b40460bcb68a7ad9840bad5a	cb16e5f28a9e5532485fe35beca8d438
6a8538b37162b23d68791b9a0c54a5bf	cb16e5f28a9e5532485fe35beca8d438
cba95a42c53bdc6fbf3ddf9bf10a4069	cb16e5f28a9e5532485fe35beca8d438
6429807f6febbf061ac85089a8c3173d	084c45f4c0bf86930df25ae1c59b3fe6
7b959644258e567b32d7c38e21fdb6fa	cb16e5f28a9e5532485fe35beca8d438
b08c5a0f666c5f8a83a7bcafe51ec49b	ddfe34c53312f205cb9ee1df3ee0cd0e
eb626abaffa54be81830da1b29a3f1d8	ddfe34c53312f205cb9ee1df3ee0cd0e
f4f870098db58eeae93742dd2bcaf2b2	ddfe34c53312f205cb9ee1df3ee0cd0e
dd663d37df2cb0b5e222614dd720f6d3	ddfe34c53312f205cb9ee1df3ee0cd0e
71aabfaa43d427516f4020c7178de31c	ddfe34c53312f205cb9ee1df3ee0cd0e
32f27ae0d5337bb62c636e3f6f17b0ff	ddfe34c53312f205cb9ee1df3ee0cd0e
187ebdf7947f4b61e0725c93227676a4	ddfe34c53312f205cb9ee1df3ee0cd0e
d9a6c1fcbafa92784f501ca419fe4090	ddfe34c53312f205cb9ee1df3ee0cd0e
4176aa79eae271d1b82015feceb00571	ddfe34c53312f205cb9ee1df3ee0cd0e
c81794404ad68d298e9ceb75f69cf810	ddfe34c53312f205cb9ee1df3ee0cd0e
fd85bfffd5a0667738f6110281b25db8	ddfe34c53312f205cb9ee1df3ee0cd0e
7b959644258e567b32d7c38e21fdb6fa	ddfe34c53312f205cb9ee1df3ee0cd0e
b4b46e6ce2c563dd296e8bae768e1b9d	ddfe34c53312f205cb9ee1df3ee0cd0e
afd755c6a62ac0a0947a39c4f2cd2c20	ddfe34c53312f205cb9ee1df3ee0cd0e
b69b0e9285e4fa15470b0969836ac5ae	ddfe34c53312f205cb9ee1df3ee0cd0e
bd4184ee062e4982b878b6b188793f5b	0962c746a7d30ba0f037b21fb8e32858
79d924bae828df8e676ba27e5dfc5f42	0962c746a7d30ba0f037b21fb8e32858
950d43371e8291185e524550ad3fd0df	bc9dd8d4890a5523a876931328350747
1fda271217bb4c043c691fc6344087c1	bc9dd8d4890a5523a876931328350747
dde31adc1b0014ce659a65c8b4d6ce42	bc9dd8d4890a5523a876931328350747
45b568ce63ea724c415677711b4328a7	bc9dd8d4890a5523a876931328350747
7463543d784aa59ca86359a50ef58c8e	bc9dd8d4890a5523a876931328350747
84557a1d9eb96a680c0557724e1d0532	bc9dd8d4890a5523a876931328350747
c8d551145807972d194691247e7102a2	bc9dd8d4890a5523a876931328350747
820de5995512273916b117944d6da15a	bc9dd8d4890a5523a876931328350747
ead662696e0486cb7a478ecd13a0b5c5	bc9dd8d4890a5523a876931328350747
62165afb63fc004e619dff4d2132517c	bc9dd8d4890a5523a876931328350747
edd506a412c4f830215d4c0f1ac06e55	bc9dd8d4890a5523a876931328350747
095849fbdc267416abc6ddb48be311d7	bc9dd8d4890a5523a876931328350747
393a71c997d856ed5bb85a9695be6e46	bc9dd8d4890a5523a876931328350747
dd18fa7a5052f2bce8ff7cb4a30903ea	bc9dd8d4890a5523a876931328350747
79ce9bd96a3184b1ee7c700aa2927e67	bc9dd8d4890a5523a876931328350747
b5d1848944ce92433b626211ed9e46f8	bc9dd8d4890a5523a876931328350747
a4cbfb212102da21b82d94be555ac3ec	bc9dd8d4890a5523a876931328350747
92e67ef6f0f8c77b1dd631bd3b37ebca	bc9dd8d4890a5523a876931328350747
fe1f86f611c34fba898e4c90b71ec981	bc9dd8d4890a5523a876931328350747
8c22a88267727dd513bf8ca278661e4d	bc9dd8d4890a5523a876931328350747
9323fc63b40460bcb68a7ad9840bad5a	1be77f077186f07ab5b59287427b15c2
541455f74d6f393174ff14b99e01b22d	1be77f077186f07ab5b59287427b15c2
3e3b4203ce868f55b084eb4f2da535d3	e396e5afb7cf4c68b9adce7af6adad8c
88ae6d397912fe633198a78a3b10f82e	e396e5afb7cf4c68b9adce7af6adad8c
d2ec80fcff98ecb676da474dfcb5fe5c	e396e5afb7cf4c68b9adce7af6adad8c
d399575133268305c24d87f1c2ef054a	e396e5afb7cf4c68b9adce7af6adad8c
e31fabfff3891257949efc248dfa97e2	e396e5afb7cf4c68b9adce7af6adad8c
4f6ae7ce964e64fdc143602aaaab1c26	e396e5afb7cf4c68b9adce7af6adad8c
cd11b262d721d8b3f35ad2d2af8431dd	cb16e5f28a9e5532485fe35beca8d438
069cdf9184e271a3c6d45ad7e86fcac2	bc9dd8d4890a5523a876931328350747
96682d9c9f1bed695dbf9176d3ee234c	fa64fb0e05a9c0e32010d73760dfa53f
fe1fbc7d376820477e38b5fa497e4509	e396e5afb7cf4c68b9adce7af6adad8c
b4087680a00055c7b9551c6a1ef50816	e396e5afb7cf4c68b9adce7af6adad8c
0ddd0b1b6329e9cb9a64c4d947e641a8	e396e5afb7cf4c68b9adce7af6adad8c
13c260ca90c0f47c9418790429220899	e396e5afb7cf4c68b9adce7af6adad8c
986a4f4e41790e819dc8b2a297aa8c87	e396e5afb7cf4c68b9adce7af6adad8c
7e2b83d69e6c93adf203e13bc7d6f444	e396e5afb7cf4c68b9adce7af6adad8c
e318f5bc96fd248b69f6a969a320769e	e396e5afb7cf4c68b9adce7af6adad8c
56525146be490541a00c20a1dab0a465	e396e5afb7cf4c68b9adce7af6adad8c
0a267617c0b5b4d53e43a7d4e4c522ad	e396e5afb7cf4c68b9adce7af6adad8c
2f39cfcedf45336beb2e966e80b93e22	e396e5afb7cf4c68b9adce7af6adad8c
51053ffab2737bd21724ed0b7e6c56f7	e396e5afb7cf4c68b9adce7af6adad8c
869d4f93046289e11b591fc7a740bc43	e396e5afb7cf4c68b9adce7af6adad8c
edb40909b64e73b547843287929818de	e396e5afb7cf4c68b9adce7af6adad8c
5b3c70181a572c8d92d906ca20298d93	e396e5afb7cf4c68b9adce7af6adad8c
1fda271217bb4c043c691fc6344087c1	e396e5afb7cf4c68b9adce7af6adad8c
be3c26bf034e9e62057314f3945f87be	e396e5afb7cf4c68b9adce7af6adad8c
37b93f83b5fe94e766346ef212283282	e396e5afb7cf4c68b9adce7af6adad8c
dbde8de43043d69c4fdd3e50a72b859d	e396e5afb7cf4c68b9adce7af6adad8c
0f512371d62ae34741d14dde50ab4529	e396e5afb7cf4c68b9adce7af6adad8c
54b72f3169fea84731d3bcba785eac49	e396e5afb7cf4c68b9adce7af6adad8c
fd85bfffd5a0667738f6110281b25db8	e396e5afb7cf4c68b9adce7af6adad8c
fd1bd629160356260c497da84df860e2	e396e5afb7cf4c68b9adce7af6adad8c
3dba6c9259786defe62551e38665a94a	e396e5afb7cf4c68b9adce7af6adad8c
9d969d25c9f506c5518bb090ad5f8266	e396e5afb7cf4c68b9adce7af6adad8c
ce2caf05154395724e4436f042b8fa53	e396e5afb7cf4c68b9adce7af6adad8c
34d29649cb20a10a5e6b59c531077a59	e396e5afb7cf4c68b9adce7af6adad8c
c02f12329daf99e6297001ef684d6285	e396e5afb7cf4c68b9adce7af6adad8c
3af7c6d148d216f13f66669acb8d5c59	477a7e7627b4482929c215de7d3c4a76
f64162c264d5679d130b6e8ae84d704e	477a7e7627b4482929c215de7d3c4a76
0674a20e29104e21d141843a86421323	477a7e7627b4482929c215de7d3c4a76
24dd5b3de900b9ee06f913a550beb64c	477a7e7627b4482929c215de7d3c4a76
fe7838d63434580c47798cbc5c2c8c63	477a7e7627b4482929c215de7d3c4a76
e47c5fcf4a752dfcfbccaab5988193ef	477a7e7627b4482929c215de7d3c4a76
3d482a4abe7d814a741b06cb6306d598	477a7e7627b4482929c215de7d3c4a76
d9bc1db8c13da3a131d853237e1f05b2	477a7e7627b4482929c215de7d3c4a76
d0a1fd0467dc892f0dc27711637c864e	477a7e7627b4482929c215de7d3c4a76
856256d0fddf6bfd898ef43777a80f0c	477a7e7627b4482929c215de7d3c4a76
b5bc9b34286d4d4943fc301fe9b46e46	477a7e7627b4482929c215de7d3c4a76
589a30eb4a7274605385d3414ae82aaa	477a7e7627b4482929c215de7d3c4a76
d79d3a518bd9912fb38fa2ef71c39750	477a7e7627b4482929c215de7d3c4a76
5ff09619b7364339a105a1cbcb8d65fd	477a7e7627b4482929c215de7d3c4a76
42563d0088d6ac1a47648fc7621e77c6	477a7e7627b4482929c215de7d3c4a76
2eb6fb05d553b296096973cb97912cc0	477a7e7627b4482929c215de7d3c4a76
50681f5168e67b62daa1837d8f693001	7e834ee3aea78e49afb45728dbb63de2
e163173b9350642f7c855bf37c144ce0	7e834ee3aea78e49afb45728dbb63de2
e29ef4beb480eab906ffa7c05aeec23d	b4bc434cadf0eb32a339ac495a2268e8
559ccea48c3460ebc349587d35e808dd	b4bc434cadf0eb32a339ac495a2268e8
69af98a8916998443129c057ee04aec4	b4bc434cadf0eb32a339ac495a2268e8
57338bd22a6c5ba32f90981ffb25ef23	b4bc434cadf0eb32a339ac495a2268e8
48aeffb54173796a88ef8c4eb06dbf10	331460836901954849fb420c890f1c44
07759c4afc493965a5420e03bdc9b773	331460836901954849fb420c890f1c44
48aeffb54173796a88ef8c4eb06dbf10	7e8a1347517055c0af14a3df27f42a4d
8989ab42027d29679d1dedc518eb04bd	7e8a1347517055c0af14a3df27f42a4d
266674d0a44a3a0102ab80021ddfd451	7e8a1347517055c0af14a3df27f42a4d
50e7b1ba464091976138ec6a57b08ba0	7e8a1347517055c0af14a3df27f42a4d
a51211ef8cbbf7b49bfb27c099c30ce1	7e8a1347517055c0af14a3df27f42a4d
0dc9cb94cdd3a9e89383d344a103ed5b	7e8a1347517055c0af14a3df27f42a4d
c45ca1e791f2849d9d11b3948fdefb74	7e8a1347517055c0af14a3df27f42a4d
54f89c837a689f7f27667efb92e3e6b1	7e8a1347517055c0af14a3df27f42a4d
ada3962af4845c243fcd1ccafc815b09	331460836901954849fb420c890f1c44
ada3962af4845c243fcd1ccafc815b09	7e8a1347517055c0af14a3df27f42a4d
897edb97d775897f69fa168a88b01c19	bc9dd8d4890a5523a876931328350747
b05f3966288598b02cda4a41d6d1eb6b	0e4288f287e446bf417ba4e0664a1c26
1e9413d4cc9af0ad12a6707776573ba0	0e4288f287e446bf417ba4e0664a1c26
e6fd7b62a39c109109d33fcd3b5e129d	0e4288f287e446bf417ba4e0664a1c26
c7d1a2a30826683fd366e7fd6527e79c	0e4288f287e446bf417ba4e0664a1c26
6ff4735b0fc4160e081440b3f7238925	0e4288f287e446bf417ba4e0664a1c26
f4f870098db58eeae93742dd2bcaf2b2	0e4288f287e446bf417ba4e0664a1c26
100691b7539d5ae455b6f4a18394420c	0e4288f287e446bf417ba4e0664a1c26
d5282bd6b63b4cd51b50b40d192f1161	3aa0df8e70b789a940e8a4df74c1c1de
8b3d594047e4544f608c2ebb151aeb45	b0f45689c096147b963b998eccdbc19e
5159fd46698ae21d56f1684c2041bd79	b0f45689c096147b963b998eccdbc19e
92e25f3ba88109b777bd65b3b3de28a9	3048f2df2a1969708f48957002d0ea46
c63ecd19a0ca74c22dfcf3063c9805d2	3048f2df2a1969708f48957002d0ea46
e08f00b43f7aa539eb60cfa149afd92e	3048f2df2a1969708f48957002d0ea46
793955e5d62f9b22bae3b59463c9ef63	3048f2df2a1969708f48957002d0ea46
e4f2a1b2efa9caa67e58fa9610903ef0	3048f2df2a1969708f48957002d0ea46
25ebb3d62ad1160c96bbdea951ad2f34	dad100b64679b43501647a37e886a148
754230e2c158107a2e93193c829e9e59	dad100b64679b43501647a37e886a148
d730e65d54d6c0479561d25724afd813	dad100b64679b43501647a37e886a148
57f003f2f413eedf53362b020f467be4	dad100b64679b43501647a37e886a148
b20a4217acaf4316739c6a5f6679ef60	98bbd03f950cbc96d6639a4b7b43e76a
5ef6a0f70220936a0158ad66fd5d9082	98bbd03f950cbc96d6639a4b7b43e76a
52ee4c6902f6ead006b0fb2f3e2d7771	ef91a35f7de705463fc18a852a0eaa9c
d97a4c5c71013baac562c2b5126909e1	ef91a35f7de705463fc18a852a0eaa9c
92e25f3ba88109b777bd65b3b3de28a9	1ac607a573d595a27f07adef0073a8fd
54c09bacc963763eb8742fa1da44a968	1ac607a573d595a27f07adef0073a8fd
1ebe59bfb566a19bc3ce5f4fb6c79cd3	1ac607a573d595a27f07adef0073a8fd
92e67ef6f0f8c77b1dd631bd3b37ebca	2d2f874ab54161fb8158d43487e77eb6
45b568ce63ea724c415677711b4328a7	2d2f874ab54161fb8158d43487e77eb6
5f572d201a24500b2db6eca489a6a620	2d2f874ab54161fb8158d43487e77eb6
ac6dc9583812a034be2f5aacbf439236	2d2f874ab54161fb8158d43487e77eb6
59d153c1c2408b702189623231b7898a	8df16d3b3a2ca21ba921c310aadb7803
bb51d2b900ba638568e48193aada8a6c	8df16d3b3a2ca21ba921c310aadb7803
44b7bda13ac1febe84d8607ca8bbf439	8df16d3b3a2ca21ba921c310aadb7803
7f499363c322c1243827700c67a7591c	dedb3aef6ecd0d48a7e7a41d8545a2d9
2040754b0f9589a89ce88912bcf0648e	dedb3aef6ecd0d48a7e7a41d8545a2d9
b0ce1e93de9839d07dab8d268ca23728	dedb3aef6ecd0d48a7e7a41d8545a2d9
13cd421d8a1cb48800543b9317aa2f52	dedb3aef6ecd0d48a7e7a41d8545a2d9
5b3c70181a572c8d92d906ca20298d93	dedb3aef6ecd0d48a7e7a41d8545a2d9
de506362ebfcf7c632d659aa1f2b465d	dedb3aef6ecd0d48a7e7a41d8545a2d9
5c1a922f41003eb7a19b570c33b99ff4	dedb3aef6ecd0d48a7e7a41d8545a2d9
095849fbdc267416abc6ddb48be311d7	dedb3aef6ecd0d48a7e7a41d8545a2d9
4b9f3b159347c34232c9f4b220cb22de	dedb3aef6ecd0d48a7e7a41d8545a2d9
ade72e999b4e78925b18cf48d1faafa4	dedb3aef6ecd0d48a7e7a41d8545a2d9
81a17f1bf76469b18fbe410d8ec77da8	dedb3aef6ecd0d48a7e7a41d8545a2d9
332d6b94de399f86d499be57f8a5a5ca	dedb3aef6ecd0d48a7e7a41d8545a2d9
2f39cfcedf45336beb2e966e80b93e22	dedb3aef6ecd0d48a7e7a41d8545a2d9
81a86312a4aa3660f273d6ed5e4a6c7d	dedb3aef6ecd0d48a7e7a41d8545a2d9
ade72e999b4e78925b18cf48d1faafa4	a1ba44498f1b706e9ec67d6c50842b42
546f8a4844ac636dd18025dcc673a3ab	a1ba44498f1b706e9ec67d6c50842b42
20d32d36893828d060096b2cd149820b	a1ba44498f1b706e9ec67d6c50842b42
15137b95180ccc986f6321acffb9cb6f	a1ba44498f1b706e9ec67d6c50842b42
692649c1372f37ed50339b91337e7fec	86726dd04d66ca3def8c4e2ccfbbf3e2
6c607fc8c0adc99559bc14e01170fee1	86726dd04d66ca3def8c4e2ccfbbf3e2
0646225016fba179076d7df56260d1b2	b8a9f22cb877ce0189a3ce04e105f0c1
ce5e821f2dcc57569eae793f628c99cf	b8a9f22cb877ce0189a3ce04e105f0c1
d3ed8223151e14b936436c336a4c7278	b8a9f22cb877ce0189a3ce04e105f0c1
1cdd53cece78d6e8dffcf664fa3d1be2	d3582717412a80f08b23f8add23a1f35
63d7f33143522ba270cb2c87f724b126	d3582717412a80f08b23f8add23a1f35
ad01952b3c254c8ebefaf6f73ae62f7d	d3582717412a80f08b23f8add23a1f35
cd11b262d721d8b3f35ad2d2af8431dd	fc0dc52ba0b7a645c4d70c0df70abb40
e47c5fcf4a752dfcfbccaab5988193ef	6a1b89e9076bdcb811ab7b4b6b5fbb23
3771bd5f354df475660a24613fcb7a8c	6a1b89e9076bdcb811ab7b4b6b5fbb23
f43bb3f980f58c66fc81874924043946	6a1b89e9076bdcb811ab7b4b6b5fbb23
b5d1848944ce92433b626211ed9e46f8	68884e33784d424fef2065652b743ee7
9cf73d0300eea453f17c6faaeb871c55	68884e33784d424fef2065652b743ee7
cd11b262d721d8b3f35ad2d2af8431dd	68884e33784d424fef2065652b743ee7
15cee64305c1b40a4fac10c26ffa227d	68884e33784d424fef2065652b743ee7
069cdf9184e271a3c6d45ad7e86fcac2	c150d400f383afb8e8427813549a82d3
069cdf9184e271a3c6d45ad7e86fcac2	d5cd210a82be3dd1a7879b83ba5657c0
069cdf9184e271a3c6d45ad7e86fcac2	e1c9ae13502e64fd6fa4121f4af7fb0e
3be3e956aeb5dc3b16285463e02af25b	6a1b89e9076bdcb811ab7b4b6b5fbb23
6b7cf117ecf0fea745c4c375c1480cb5	68884e33784d424fef2065652b743ee7
bb66c20c42c26f1874525c3ab956ec41	cc0c4b3208cad5143bf8aec2c74ac9df
32a02a8a7927de4a39e9e14f2dc46ac6	cc0c4b3208cad5143bf8aec2c74ac9df
e9782409a3511c3535149cdfb5b76364	cc0c4b3208cad5143bf8aec2c74ac9df
382ed38ecc68052678c5ac5646298b63	cc0c4b3208cad5143bf8aec2c74ac9df
90bebabe0c80676a4f6207ee0f8caa4c	fa64fb0e05a9c0e32010d73760dfa53f
ee8cde73a364c2b066f795edda1a303a	fa64fb0e05a9c0e32010d73760dfa53f
54c09bacc963763eb8742fa1da44a968	fa64fb0e05a9c0e32010d73760dfa53f
92e25f3ba88109b777bd65b3b3de28a9	fa64fb0e05a9c0e32010d73760dfa53f
49f6021766f78bffb3f824eb199acfbc	4454869140a41f593eb7d8575d0f97c8
8b3d594047e4544f608c2ebb151aeb45	4454869140a41f593eb7d8575d0f97c8
f04de6fafc611682779eb2eb36bdbe25	4454869140a41f593eb7d8575d0f97c8
8edfa58b1aedb58629b80e5be2b2bd92	91b0a2f2ba6b8909cc412bf37e35f779
f7c31a68856cab2620244be2df27c728	91b0a2f2ba6b8909cc412bf37e35f779
11d396b078f0ae37570c8ef0f45937ad	55feb5f143059bd9a7a647ba7daab977
11d396b078f0ae37570c8ef0f45937ad	85500121e0087db5354d72b484d1a90e
ae2056f2540325e2de91f64f5ac130b6	e471494f42d963b13f025c0636c43763
b96a3cb81197e8308c87f6296174fe3e	b5b0b9a19e53b658857004f145d6a94f
eced087124a41417845c0b0f4ff44ba9	b5b0b9a19e53b658857004f145d6a94f
94ca28ea8d99549c2280bcc93f98c853	b5b0b9a19e53b658857004f145d6a94f
edaf03c0c66aa548df3cebdae0f94545	b5b0b9a19e53b658857004f145d6a94f
d9bc1db8c13da3a131d853237e1f05b2	ee46f6424a052ac12d2c76309c260a36
4276250c9b1b839b9508825303c5c5ae	ee46f6424a052ac12d2c76309c260a36
16cbdd4df5f89d771dccfa1111d7f4bc	ee46f6424a052ac12d2c76309c260a36
9abdb4a0588186fc4425b29080e820a2	ee46f6424a052ac12d2c76309c260a36
06a4594d3b323539e9dc4820625d01b8	180e57969fd1e8948ebdf21ff1b57d3d
b5c7675d6faefd09e871a6c1157e9353	180e57969fd1e8948ebdf21ff1b57d3d
ae653e4f46c5928cc4b4b171efbcf881	04fdcbd453ccdcfc343ffc7ab6b27a8d
1683f5557c9db93b35d1d2ae450baa21	04fdcbd453ccdcfc343ffc7ab6b27a8d
bd4184ee062e4982b878b6b188793f5b	04fdcbd453ccdcfc343ffc7ab6b27a8d
96682d9c9f1bed695dbf9176d3ee234c	379d64538f810914012edc9981039183
df8457281db2cba8bbcb4b3b80f2b9a3	379d64538f810914012edc9981039183
f85df6e18a73a6d1f5ccb59ee51558ae	379d64538f810914012edc9981039183
0308321fc4f75ddaed8208c24f2cb918	0b305bfbd40df03ea4a962caa5bfc8f4
4ceb1f68d8a260c644c25799629a5615	0b305bfbd40df03ea4a962caa5bfc8f4
7acb475eda543ccd0622d546c5772c5a	0b305bfbd40df03ea4a962caa5bfc8f4
e6fd7b62a39c109109d33fcd3b5e129d	0b305bfbd40df03ea4a962caa5bfc8f4
e318f5bc96fd248b69f6a969a320769e	0b305bfbd40df03ea4a962caa5bfc8f4
f042da2a954a1521114551a6f9e22c75	d691b12bf758d4895b52dd338feb3a10
ba8d3efe842e0755020a2f1bc5533585	d691b12bf758d4895b52dd338feb3a10
5a154476dd67358f4dab8500076dece3	d691b12bf758d4895b52dd338feb3a10
b8e18040dc07eead8e6741733653a740	95f435dc4c76d20082aafca8e5a394c9
0bc244b6aa99080c3d37fea06d328193	95f435dc4c76d20082aafca8e5a394c9
59d153c1c2408b702189623231b7898a	02ce1b3a6156c9f73724ea3efabde2e8
b46e412d7f90e277a1b9370cfeb26abe	8307a775d42c5bfbaab36501bf6a3f6c
49920f80faa980ca10fea8f31ddd5fc9	5c22297e2817e4a0c9ee608a67bcf297
fddfe79923a5373a44237e0e60f5c845	5c22297e2817e4a0c9ee608a67bcf297
2df8905eae6823023de6604dc5346c29	ae89cc8a42502f057aa1d7cbdf5105a8
2654d6e7cec2ef045ca1772a980fbc4c	ae89cc8a42502f057aa1d7cbdf5105a8
277ce66a47017ca1ce55714d5d2232b2	ae89cc8a42502f057aa1d7cbdf5105a8
cf4ee20655dd3f8f0a553c73ffe3f72a	e3e419c6d94bb9333e21fbfa231367a0
2ad8a3ceb96c6bf74695f896999019d8	e3e419c6d94bb9333e21fbfa231367a0
721c28f4c74928cc9e0bb3fef345e408	fd4a13ab709b0975de3c7528ca3aab0e
fc4734cc48ce1595c9dbbe806f663af8	fd4a13ab709b0975de3c7528ca3aab0e
bbdbdf297183a1c24be29ed89711f744	fd4a13ab709b0975de3c7528ca3aab0e
567ddbaeec9bc3c5f0348a21ebd914b1	fd4a13ab709b0975de3c7528ca3aab0e
f042da2a954a1521114551a6f9e22c75	573a39e7d69678efec23ba7a9e99f0f5
25cde5325befa9538b771717514351fb	573a39e7d69678efec23ba7a9e99f0f5
cf2676445aa6abcc43a4b0d4b01b42a1	573a39e7d69678efec23ba7a9e99f0f5
c2275e8ac71d308946a63958bc7603a1	573a39e7d69678efec23ba7a9e99f0f5
3005cc8298f189f94923611386015c78	573a39e7d69678efec23ba7a9e99f0f5
7f2679aa5b1116cc22bab4ee10018f59	573a39e7d69678efec23ba7a9e99f0f5
8a1acf425fb1bca48fb543edcc20a90d	573a39e7d69678efec23ba7a9e99f0f5
f042da2a954a1521114551a6f9e22c75	b8fabad72c3fd0540815a6cd8d126a14
c2d7bbc06d62144545c45b9060b0a629	b8fabad72c3fd0540815a6cd8d126a14
cf2676445aa6abcc43a4b0d4b01b42a1	b8fabad72c3fd0540815a6cd8d126a14
62254b7ab0a2b3d3138bde893dde64a3	b8fabad72c3fd0540815a6cd8d126a14
a332f1280622f9628fccd1b7aac7370a	1d8cf922eebeba04d4aa27b8b5e412c3
99bd5eff92fc3ba728a9da5aa1971488	1d8cf922eebeba04d4aa27b8b5e412c3
f291caafeb623728ebf0166ac4cb0825	1d8cf922eebeba04d4aa27b8b5e412c3
96682d9c9f1bed695dbf9176d3ee234c	31b7b744437a5b46fb982fcdf1b94851
1a46202030819f7419e300997199c955	31b7b744437a5b46fb982fcdf1b94851
1f94ea2f8cb55dd130ec2254c7c2238c	2c6a917b013e933d5ef1aa0a6216e575
8d788b28d613c227ea3c87ac898a8256	2c6a917b013e933d5ef1aa0a6216e575
5226c9e67aff4f963aea67c95cd5f3f0	2c6a917b013e933d5ef1aa0a6216e575
7f29efc2495ce308a8f4aa7bfc11d701	fd5ccee80a5d5a1a16944aefe2b840c5
4ad6c928711328d1cf0167bc87079a14	f853b43cbe11fe4cdef7009f0f98d4f2
e58ecda1a7b9bfdff6a10d398f468c3f	f853b43cbe11fe4cdef7009f0f98d4f2
183bea99848e19bdb720ba5774d216ba	220f8c4b62141ad5acd8b11d4d0f2bd3
495ddc6ae449bf858afe5512d28563f5	220f8c4b62141ad5acd8b11d4d0f2bd3
3b0b94c18b8d65aec3a8ca7f4dae720d	220f8c4b62141ad5acd8b11d4d0f2bd3
b2b4ae56a4531455e275770dc577b68e	220f8c4b62141ad5acd8b11d4d0f2bd3
f9d5d4c7b26c7b832ee503b767d5df52	220f8c4b62141ad5acd8b11d4d0f2bd3
9ee30f495029e1fdf6567045f2079be1	6bc91856db67c4e90b455638fa43e0bd
5d56713e4586c9b1920eb1a3d4597564	6bc91856db67c4e90b455638fa43e0bd
f9030edd3045787fcbcfd47da5246596	6bc91856db67c4e90b455638fa43e0bd
88711444ece8fe638ae0fb11c64e2df3	5e651777820428286fde01ffe87cb4b7
215513a2c867f8b24d5aea58c9abfff6	5e651777820428286fde01ffe87cb4b7
1e9413d4cc9af0ad12a6707776573ba0	5e651777820428286fde01ffe87cb4b7
b20a4217acaf4316739c6a5f6679ef60	5e651777820428286fde01ffe87cb4b7
1ca632ac231052e4116239ccb8952dfe	5e651777820428286fde01ffe87cb4b7
baa9d4eef21c7b89f42720313b5812d4	45dbcc9d20cd0f431b1f4774cd0a0bf3
62a40f6fa589c7007ded80d26ad1c3a9	45dbcc9d20cd0f431b1f4774cd0a0bf3
7d9488e60660507d0f88850245ddc7a5	45dbcc9d20cd0f431b1f4774cd0a0bf3
abb4decfc5a094f45911b94337e7e2c4	45dbcc9d20cd0f431b1f4774cd0a0bf3
a716390764a4896d99837e99f9e009c9	cf8e56fdc88304e772838b2a47d8c23b
28a95ef0eabe44a27f49bbaecaa8a847	cf8e56fdc88304e772838b2a47d8c23b
16cbdd4df5f89d771dccfa1111d7f4bc	3eda085ef6acc8b084dda9440115af56
e061c04af9609876757f0b33d14c63e5	3eda085ef6acc8b084dda9440115af56
4fab532a185610bb854e0946f4def6a4	ac4ad77eed8faf4ef8d91fb1df7fe196
6b7cf117ecf0fea745c4c375c1480cb5	ac4ad77eed8faf4ef8d91fb1df7fe196
4276250c9b1b839b9508825303c5c5ae	ac4ad77eed8faf4ef8d91fb1df7fe196
\.


--
-- Data for Name: bands_generes; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands_generes (id_band, id_genere) FROM stdin;
0020f19414b5f2874a0bfacd9d511b84	cb6ef856481bc776bba38fbf15b8b3fb
006fc2724417174310cf06d2672e34d2	17b8dff9566f6c98062ad5811c762f44
02d44fbbe1bfacd6eaa9b20299b1cb78	7fa69773873856d74f68a6824ca4b691
02d44fbbe1bfacd6eaa9b20299b1cb78	deb8040131c3f6a3caf6a616b34ac482
058fcf8b126253956deb3ce672d107a7	6de7f9aa9c912bf8c81a9ce2bfc062bd
058fcf8b126253956deb3ce672d107a7	7a3808eef413b514776a7202fd2cb94f
059792b70fc0686fb296e7fcae0bda50	17b8dff9566f6c98062ad5811c762f44
0640cfbf1d269b69c535ea4e288dfd96	97a6395e2906e8f41d27e53a40aebae4
065b56757c6f6a0fba7ab0c64e4c1ae1	17b8dff9566f6c98062ad5811c762f44
06efe152a554665e02b8dc4f620bf3f1	585f02a68092351a078fc43a21a56564
06efe152a554665e02b8dc4f620bf3f1	a29864963573d7bb061691ff823b97dd
076365679712e4206301117486c3d0ec	17b8dff9566f6c98062ad5811c762f44
076365679712e4206301117486c3d0ec	a29864963573d7bb061691ff823b97dd
076365679712e4206301117486c3d0ec	d5a9c37bc91d6d5d55a3c2e38c3bf97d
0780d2d1dbd538fec3cdd8699b08ea02	60e1fa5bfa060b5fff1db1ca1bae4f99
0780d2d1dbd538fec3cdd8699b08ea02	885ba57d521cd859bacf6f76fb37ef7c
0780d2d1dbd538fec3cdd8699b08ea02	a178914dea39e23c117e164b05b43995
0780d2d1dbd538fec3cdd8699b08ea02	ed8e37bad13d76c6dbeb58152440b41e
0844ad55f17011abed4a5208a3a05b74	10a17b42501166d3bf8fbdff7e1d52b6
0844ad55f17011abed4a5208a3a05b74	17b8dff9566f6c98062ad5811c762f44
0903a7e60f0eb20fdc8cc0b8dbd45526	4144b216bf706803a5f17d7d0a9cf4a3
095849fbdc267416abc6ddb48be311d7	7fa69773873856d74f68a6824ca4b691
095849fbdc267416abc6ddb48be311d7	caac3244eefed8cffee878acae427e28
09d8e20a5368ce1e5c421a04cb566434	a379c6c3bf4b1a401ce748b34729389a
0a267617c0b5b4d53e43a7d4e4c522ad	10a17b42501166d3bf8fbdff7e1d52b6
0a267617c0b5b4d53e43a7d4e4c522ad	17b8dff9566f6c98062ad5811c762f44
0a267617c0b5b4d53e43a7d4e4c522ad	1d67aeafcd3b898e05a75da0fdc01365
0a267617c0b5b4d53e43a7d4e4c522ad	a68d5b72c2f98613f511337a59312f78
0a267617c0b5b4d53e43a7d4e4c522ad	ea9565886c02dbdc4892412537e607d7
0a56095b73dcbd2a76bb9d4831881cb3	ea9565886c02dbdc4892412537e607d7
0a7ba3f35a9750ff956dca1d548dad12	01864d382accf1cdb077e42032b16340
0a97b893b92a7df612eadfe97589f242	eaa57a9b4248ce3968e718895e1c2f04
0af74c036db52f48ad6cbfef6fee2999	04ae76937270105919847d05aee582b4
0af74c036db52f48ad6cbfef6fee2999	a29864963573d7bb061691ff823b97dd
0af74c036db52f48ad6cbfef6fee2999	f41da0c65a8fa3690e6a6877e7112afb
0b0d1c3752576d666c14774b8233889f	01864d382accf1cdb077e42032b16340
0b6e98d660e2901c33333347da37ad36	04ae76937270105919847d05aee582b4
0cdf051c93865faa15cbc5cd3d2b69fb	a29864963573d7bb061691ff823b97dd
0e2ea6aa669710389cf4d6e2ddf408c4	a68d5b72c2f98613f511337a59312f78
0fbddeb130361265f1ba6f86b00f0968	10a17b42501166d3bf8fbdff7e1d52b6
1056b63fdc3c5015cc4591aa9989c14f	a29864963573d7bb061691ff823b97dd
108c58fc39b79afc55fac7d9edf4aa2a	01864d382accf1cdb077e42032b16340
10d91715ea91101cfe0767c812da8151	17b8dff9566f6c98062ad5811c762f44
10d91715ea91101cfe0767c812da8151	a29864963573d7bb061691ff823b97dd
1104831a0d0fe7d2a6a4198c781e0e0d	a29864963573d7bb061691ff823b97dd
11635778f116ce6922f6068638a39028	04ae76937270105919847d05aee582b4
11635778f116ce6922f6068638a39028	6fb9bf02fc5d663c1de8c117382bed0b
11635778f116ce6922f6068638a39028	f0095594f17b3793be8291117582f96b
11d396b078f0ae37570c8ef0f45937ad	9ba0204bc48d4b8721344dd83b832afe
11f8d9ec8f6803ea61733840f13bc246	7fa69773873856d74f68a6824ca4b691
1209f43dbecaba22f3514bf40135f991	1e612d6c48bc9652afeb616536fced51
121189969c46f49b8249633c2d5a7bfa	a29864963573d7bb061691ff823b97dd
13caf3d14133dfb51067264d857eaf70	1c800aa97116d9afd83204d65d50199a
14ab730fe0172d780da6d9e5d432c129	a29864963573d7bb061691ff823b97dd
1734b04cf734cb291d97c135d74b4b87	2df929d9b6150c082888b66e8129ee3f
1734b04cf734cb291d97c135d74b4b87	7fa69773873856d74f68a6824ca4b691
187ebdf7947f4b61e0725c93227676a4	2df929d9b6150c082888b66e8129ee3f
187ebdf7947f4b61e0725c93227676a4	97a6395e2906e8f41d27e53a40aebae4
19baf8a6a25030ced87cd0ce733365a9	10a17b42501166d3bf8fbdff7e1d52b6
19baf8a6a25030ced87cd0ce733365a9	17b8dff9566f6c98062ad5811c762f44
1ac0c8e8c04cf2d6f02fdb8292e74588	2e607ef3a19cf3de029e2c5882896d33
1ac0c8e8c04cf2d6f02fdb8292e74588	a29864963573d7bb061691ff823b97dd
1bc1f7348d79a353ea4f594de9dd1392	01864d382accf1cdb077e42032b16340
1bc1f7348d79a353ea4f594de9dd1392	d5a9c37bc91d6d5d55a3c2e38c3bf97d
1c06fc6740d924cab33dce73643d84b9	eb182befdeccf17696b666b32eb5a313
1c6987adbe5ab3e4364685e8caed0f59	04ae76937270105919847d05aee582b4
1c6987adbe5ab3e4364685e8caed0f59	4fb2ada7c5440a256ed0e03c967fce74
1cdd53cece78d6e8dffcf664fa3d1be2	17b8dff9566f6c98062ad5811c762f44
1da77fa5b97c17be83cc3d0693c405cf	1c800aa97116d9afd83204d65d50199a
1e14d6b40d8e81d8d856ba66225dcbf3	a29864963573d7bb061691ff823b97dd
1e8563d294da81043c2772b36753efaf	1396a3913454b8016ddf671d02e861b1
1e8563d294da81043c2772b36753efaf	2a78330cc0de19f12ae9c7de65b9d5d5
1e8563d294da81043c2772b36753efaf	8472603ee3d6dea8e274608e9cbebb6b
1e8563d294da81043c2772b36753efaf	dcd00c11302e3b16333943340d6b4a6b
1e88302efcfc873691f0c31be4e2a388	a29864963573d7bb061691ff823b97dd
1e9413d4cc9af0ad12a6707776573ba0	7fa69773873856d74f68a6824ca4b691
1ebd63d759e9ff532d5ce63ecb818731	b86219c2df5a0d889f490f88ff22e228
2082a7d613f976e7b182a3fe80a28958	de62af4f3af4adf9e8c8791071ddafe3
2113f739f81774557041db616ee851e6	17b8dff9566f6c98062ad5811c762f44
218f2bdae8ad3bb60482b201e280ffdc	7fa69773873856d74f68a6824ca4b691
2252d763a2a4ac815b122a0176e3468f	a68d5b72c2f98613f511337a59312f78
237e378c239b44bff1e9a42ab866580c	17b8dff9566f6c98062ad5811c762f44
237e378c239b44bff1e9a42ab866580c	a68d5b72c2f98613f511337a59312f78
2414366fe63cf7017444181acacb6347	10a17b42501166d3bf8fbdff7e1d52b6
2414366fe63cf7017444181acacb6347	17b8dff9566f6c98062ad5811c762f44
2447873ddeeecaa165263091c0cbb22f	a68d5b72c2f98613f511337a59312f78
249229ca88aa4a8815315bb085cf4d61	02d3190ce0f08f32be33da6cc8ec8df8
249229ca88aa4a8815315bb085cf4d61	bb273189d856ee630d92fbc0274178bb
249789ae53c239814de8e606ff717ec9	04ae76937270105919847d05aee582b4
249789ae53c239814de8e606ff717ec9	4fb2ada7c5440a256ed0e03c967fce74
24ff2b4548c6bc357d9d9ab47882661e	17b8dff9566f6c98062ad5811c762f44
2501f7ba78cc0fd07efb7c17666ff12e	924ae2289369a9c1d279d1d59088be64
264721f3fc2aee2d28dadcdff432dbc1	17b8dff9566f6c98062ad5811c762f44
2672777b38bc4ce58c49cf4c82813a42	a29864963573d7bb061691ff823b97dd
278606b1ac0ae7ef86e86342d1f259c3	a29864963573d7bb061691ff823b97dd
278c094627c0dd891d75ea7a3d0d021e	a29864963573d7bb061691ff823b97dd
2876f7ecdae220b3c0dcb91ff13d0590	a68d5b72c2f98613f511337a59312f78
28a95ef0eabe44a27f49bbaecaa8a847	a29864963573d7bb061691ff823b97dd
28a95ef0eabe44a27f49bbaecaa8a847	d5a9c37bc91d6d5d55a3c2e38c3bf97d
28bb59d835e87f3fd813a58074ca0e11	17b8dff9566f6c98062ad5811c762f44
28bc31b338dbd482802b77ed1fd82a50	17b8dff9566f6c98062ad5811c762f44
28bc31b338dbd482802b77ed1fd82a50	a68d5b72c2f98613f511337a59312f78
28f843fa3a493a3720c4c45942ad970e	01864d382accf1cdb077e42032b16340
2a024edafb06c7882e2e1f7b57f2f951	01864d382accf1cdb077e42032b16340
2a024edafb06c7882e2e1f7b57f2f951	a68d5b72c2f98613f511337a59312f78
2aae4f711c09481c8353003202e05359	17b8dff9566f6c98062ad5811c762f44
2aae4f711c09481c8353003202e05359	a29864963573d7bb061691ff823b97dd
2ac79000a90b015badf6747312c0ccad	a68d5b72c2f98613f511337a59312f78
2ac79000a90b015badf6747312c0ccad	ea9565886c02dbdc4892412537e607d7
2af9e4497582a6faa68a42ac2d512735	d93cf30d3eb53125668057b982b433a3
2cf65e28c586eeb98daaecf6eb573e7a	04ae76937270105919847d05aee582b4
2cf65e28c586eeb98daaecf6eb573e7a	dcd00c11302e3b16333943340d6b4a6b
2cfe35095995e8dd15ab7b867e178c15	04ae76937270105919847d05aee582b4
2cfe35095995e8dd15ab7b867e178c15	585f02a68092351a078fc43a21a56564
2df8905eae6823023de6604dc5346c29	a29864963573d7bb061691ff823b97dd
2e7a848dc99bd27acb36636124855faf	deb8040131c3f6a3caf6a616b34ac482
2fa2f1801dd37d6eb9fe4e34a782e397	d5a9c37bc91d6d5d55a3c2e38c3bf97d
31d8a0a978fad885b57a685b1a0229df	10a17b42501166d3bf8fbdff7e1d52b6
32814ff4ca9a26b8d430a8c0bc8dc63e	60e1fa5bfa060b5fff1db1ca1bae4f99
32814ff4ca9a26b8d430a8c0bc8dc63e	885ba57d521cd859bacf6f76fb37ef7c
32814ff4ca9a26b8d430a8c0bc8dc63e	ea9565886c02dbdc4892412537e607d7
32af59a47b8c7e1c982ae797fc491180	1d67aeafcd3b898e05a75da0fdc01365
33b6f1b596a60fa87baef3d2c05b7c04	57a1aaebe3e5e271aca272988c802651
33b6f1b596a60fa87baef3d2c05b7c04	9c093ec7867ba1df61e27a5943168b90
33b6f1b596a60fa87baef3d2c05b7c04	f79873ac4ff0e556619b15d82f6da52c
348bcdb386eb9cb478b55a7574622b7c	17b8dff9566f6c98062ad5811c762f44
3509af6be9fe5defc1500f5c77e38563	17b8dff9566f6c98062ad5811c762f44
360c000b499120147c8472998859a9fe	17b8dff9566f6c98062ad5811c762f44
3614c45db20ee41e068c2ab7969eb3b5	763a34aaa76475a926827873753d534f
362f8cdd1065b0f33e73208eb358991d	01864d382accf1cdb077e42032b16340
362f8cdd1065b0f33e73208eb358991d	fa20a7164233ec73db640970dae420cf
3656edf3a40a25ccd00d414c9ecbb635	885ba57d521cd859bacf6f76fb37ef7c
3656edf3a40a25ccd00d414c9ecbb635	a68d5b72c2f98613f511337a59312f78
3656edf3a40a25ccd00d414c9ecbb635	ea9565886c02dbdc4892412537e607d7
36648510adbf2a3b2028197a60b5dada	02d3190ce0f08f32be33da6cc8ec8df8
36648510adbf2a3b2028197a60b5dada	7a3808eef413b514776a7202fd2cb94f
36cbc41c1c121f2c68f5776a118ea027	a29864963573d7bb061691ff823b97dd
36f969b6aeff175204078b0533eae1a0	a29864963573d7bb061691ff823b97dd
36f969b6aeff175204078b0533eae1a0	a68d5b72c2f98613f511337a59312f78
37f02eba79e0a3d29dfd6a4cf2f4d019	303d6389f4089fe9a87559515b84156d
37f02eba79e0a3d29dfd6a4cf2f4d019	4fb2ada7c5440a256ed0e03c967fce74
3964d4f40b6166aa9d370855bd20f662	a29864963573d7bb061691ff823b97dd
3964d4f40b6166aa9d370855bd20f662	a68d5b72c2f98613f511337a59312f78
39e83bc14e95fcbc05848fc33c30821f	7fa69773873856d74f68a6824ca4b691
3a2a7f86ca87268be9b9e0557b013565	a68d5b72c2f98613f511337a59312f78
3af7c6d148d216f13f66669acb8d5c59	17b8dff9566f6c98062ad5811c762f44
3af7c6d148d216f13f66669acb8d5c59	dcd00c11302e3b16333943340d6b4a6b
3bd94845163385cecefc5265a2e5a525	a29864963573d7bb061691ff823b97dd
3bd94845163385cecefc5265a2e5a525	d5a9c37bc91d6d5d55a3c2e38c3bf97d
3be3e956aeb5dc3b16285463e02af25b	8c42e2739ed83a54e5b2781b504c92de
3cdb47307aeb005121b09c41c8d8bee6	64ec11b17b6f822930f9deb757fa59e8
3d01ff8c75214314c4ca768c30e6807b	17b8dff9566f6c98062ad5811c762f44
3d2ff8abd980d730b2f4fd0abae52f60	2336f976c6d510d2a269a746a7756232
3d2ff8abd980d730b2f4fd0abae52f60	7a3808eef413b514776a7202fd2cb94f
3d2ff8abd980d730b2f4fd0abae52f60	f0095594f17b3793be8291117582f96b
3d2ff8abd980d730b2f4fd0abae52f60	fc8e55855e2f474c28507e4db7ba5f13
3d6ff25ab61ad55180a6aee9b64515bf	2df929d9b6150c082888b66e8129ee3f
3d6ff25ab61ad55180a6aee9b64515bf	7fa69773873856d74f68a6824ca4b691
3dda886448fe98771c001b56a4da9893	17b8dff9566f6c98062ad5811c762f44
3e52c77d795b7055eeff0c44687724a1	97a6395e2906e8f41d27e53a40aebae4
3e75cd2f2f6733ea4901458a7ce4236d	65d1fb3d4d28880c964b985cf335e04c
3e75cd2f2f6733ea4901458a7ce4236d	ea9565886c02dbdc4892412537e607d7
3f15c445cb553524b235b01ab75fe9a6	34d8a5e79a59df217c6882ee766c850a
3f15c445cb553524b235b01ab75fe9a6	4895247ad195629fecd388b047a739b4
401357e57c765967393ba391a338e89b	04ae76937270105919847d05aee582b4
401357e57c765967393ba391a338e89b	4cfbb125e9878528bab91d12421134d8
405c7f920b019235f244315a564a8aed	6add228b14f132e14ae9da754ef070c5
4094ffd492ba473a2a7bea1b19b1662d	a29864963573d7bb061691ff823b97dd
410d913416c022077c5c1709bf104d3c	c3ee1962dffaa352386a05e845ab9d0d
42563d0088d6ac1a47648fc7621e77c6	93cce11930403f5b3ce8938a2bde5efa
42563d0088d6ac1a47648fc7621e77c6	a68d5b72c2f98613f511337a59312f78
4261335bcdc95bd89fd530ba35afbf4c	eaa57a9b4248ce3968e718895e1c2f04
426fdc79046e281c5322161f011ce68c	17b8dff9566f6c98062ad5811c762f44
4276250c9b1b839b9508825303c5c5ae	17b8dff9566f6c98062ad5811c762f44
4366d01be1b2ddef162fc0ebb6933508	04ae76937270105919847d05aee582b4
4366d01be1b2ddef162fc0ebb6933508	dcd00c11302e3b16333943340d6b4a6b
44012166c6633196dc30563db3ffd017	a68d5b72c2f98613f511337a59312f78
443866d78de61ab3cd3e0e9bf97a34f6	4cfbb125e9878528bab91d12421134d8
4453eb658c6a304675bd52ca75fbae6d	a29864963573d7bb061691ff823b97dd
449b4d758aa7151bc1bbb24c3ffb40bb	eaa57a9b4248ce3968e718895e1c2f04
44b7bda13ac1febe84d8607ca8bbf439	a29864963573d7bb061691ff823b97dd
44f2dc3400ce17fad32a189178ae72fa	7a3808eef413b514776a7202fd2cb94f
450948d9f14e07ba5e3015c2d726b452	01864d382accf1cdb077e42032b16340
450948d9f14e07ba5e3015c2d726b452	7a3808eef413b514776a7202fd2cb94f
4548a3b9c1e31cf001041dc0d166365b	585f02a68092351a078fc43a21a56564
4548a3b9c1e31cf001041dc0d166365b	a29864963573d7bb061691ff823b97dd
457f098eeb8e1518008449e9b1cb580d	a68d5b72c2f98613f511337a59312f78
457f098eeb8e1518008449e9b1cb580d	ed8e37bad13d76c6dbeb58152440b41e
46174766ce49edbbbc40e271c87b5a83	a68d5b72c2f98613f511337a59312f78
47b23e889175dde5d6057db61cb52847	ea9565886c02dbdc4892412537e607d7
485065ad2259054abf342d7ae3fe27e6	4fb2ada7c5440a256ed0e03c967fce74
485065ad2259054abf342d7ae3fe27e6	8c42e2739ed83a54e5b2781b504c92de
4927f3218b038c780eb795766dfd04ee	885ba57d521cd859bacf6f76fb37ef7c
49c4097bae6c6ea96f552e38cfb6c2d1	a29864963573d7bb061691ff823b97dd
4a2a0d0c29a49d9126dcb19230aa1994	17b8dff9566f6c98062ad5811c762f44
4a2a0d0c29a49d9126dcb19230aa1994	a29864963573d7bb061691ff823b97dd
4a45ac6d83b85125b4163a40364e7b2c	7a3808eef413b514776a7202fd2cb94f
4a45ac6d83b85125b4163a40364e7b2c	bb273189d856ee630d92fbc0274178bb
4a45ac6d83b85125b4163a40364e7b2c	f0095594f17b3793be8291117582f96b
4a7d9e528dada8409e88865225fb27c4	273112316e7fab5a848516666e3a57d1
4a7d9e528dada8409e88865225fb27c4	ef5131009b7ced0b35ea49c8c7690cef
4b503a03f3f1aec6e5b4d53dd8148498	924ae2289369a9c1d279d1d59088be64
4b98a8c164586e11779a0ef9421ad0ee	4fb2ada7c5440a256ed0e03c967fce74
4cabe475dd501f3fd4da7273b5890c33	34d8a5e79a59df217c6882ee766c850a
4cabe475dd501f3fd4da7273b5890c33	887f0b9675f70bc312e17c93f248b5aa
4cfab0d66614c6bb6d399837656c590e	17b8dff9566f6c98062ad5811c762f44
4cfab0d66614c6bb6d399837656c590e	a29864963573d7bb061691ff823b97dd
4dddd8579760abb62aa4b1910725e73c	0138eefa704205fd48d98528ddcdd5bc
4ee21b1371ba008a26b313c7622256f8	c08ed51a7772c1f8352ad69071187515
4ee21b1371ba008a26b313c7622256f8	ff3a5da5aa221f7e16361efcccf4cbaa
4f48e858e9ed95709458e17027bb94bf	4cfbb125e9878528bab91d12421134d8
4f48e858e9ed95709458e17027bb94bf	65d1fb3d4d28880c964b985cf335e04c
4f48e858e9ed95709458e17027bb94bf	ea9565886c02dbdc4892412537e607d7
4f840b1febbbcdb12b9517cd0a91e8f4	caac3244eefed8cffee878acae427e28
4fa857a989df4e1deea676a43dceea07	10a17b42501166d3bf8fbdff7e1d52b6
5037c1968f3b239541c546d32dec39eb	4c4f4d32429ac8424cb110b4117036e4
5194c60496c6f02e8b169de9a0aa542c	6add228b14f132e14ae9da754ef070c5
51fa80e44b7555c4130bd06c53f4835c	ba60b529061c0af9afe655b44957e41b
51fa80e44b7555c4130bd06c53f4835c	de62af4f3af4adf9e8c8791071ddafe3
522b6c44eb0aedf4970f2990a2f2a812	17b8dff9566f6c98062ad5811c762f44
522b6c44eb0aedf4970f2990a2f2a812	2df929d9b6150c082888b66e8129ee3f
522b6c44eb0aedf4970f2990a2f2a812	d5a9c37bc91d6d5d55a3c2e38c3bf97d
529a1d385b4a8ca97ea7369477c7b6a7	04ae76937270105919847d05aee582b4
52b133bfecec2fba79ecf451de3cf3bb	dfda7d5357bc0afc43a89e8ac992216f
52ee4c6902f6ead006b0fb2f3e2d7771	04ae76937270105919847d05aee582b4
52ee4c6902f6ead006b0fb2f3e2d7771	1c800aa97116d9afd83204d65d50199a
53369c74c3cacdc38bdcdeda9284fe3c	2e607ef3a19cf3de029e2c5882896d33
53369c74c3cacdc38bdcdeda9284fe3c	a29864963573d7bb061691ff823b97dd
53407737e93f53afdfc588788b8288e8	36e61931478cf781e59da3b5ae2ee64e
53a0aafa942245f18098ccd58b4121aa	04ae76937270105919847d05aee582b4
5435326cf392e2cd8ad7768150cd5df6	17b8dff9566f6c98062ad5811c762f44
5447110e1e461c8c22890580c796277a	01864d382accf1cdb077e42032b16340
54b72f3169fea84731d3bcba785eac49	7fa69773873856d74f68a6824ca4b691
54f0b93fa83225e4a712b70c68c0ab6f	04ae76937270105919847d05aee582b4
55159d04cc4faebd64689d3b74a94009	7349da19c2ad6654280ecf64ce42b837
559ccea48c3460ebc349587d35e808dd	17b8dff9566f6c98062ad5811c762f44
5842a0c2470fe12ee3acfeec16c79c57	17b8dff9566f6c98062ad5811c762f44
585b13106ecfd7ede796242aeaed4ea8	04ae76937270105919847d05aee582b4
585b13106ecfd7ede796242aeaed4ea8	2a78330cc0de19f12ae9c7de65b9d5d5
585b13106ecfd7ede796242aeaed4ea8	7ac5b6239ee196614c19db6965c67b31
585b13106ecfd7ede796242aeaed4ea8	885ba57d521cd859bacf6f76fb37ef7c
585b13106ecfd7ede796242aeaed4ea8	d5d0458ada103152d94ff3828bf33909
58db028cf01dd425e5af6c7d511291c1	17b8dff9566f6c98062ad5811c762f44
5952dff7a6b1b3c94238ad3c6a42b904	02c4d46b0568d199466ef1baa339adc8
5952dff7a6b1b3c94238ad3c6a42b904	1302a3937910e1487d44cec8f9a09660
5952dff7a6b1b3c94238ad3c6a42b904	6fa3bbbff822349fee0eaf8cd78c0623
5952dff7a6b1b3c94238ad3c6a42b904	72616c6de7633d9ac97165fc7887fa3a
5952dff7a6b1b3c94238ad3c6a42b904	e7faf05839e2f549fb3455df7327942b
5952dff7a6b1b3c94238ad3c6a42b904	ef5131009b7ced0b35ea49c8c7690cef
59d153c1c2408b702189623231b7898a	a29864963573d7bb061691ff823b97dd
59f06d56c38ac98effb4c6da117b0305	7a3808eef413b514776a7202fd2cb94f
5af874093e5efcbaeb4377b84c5f2ec5	b6a0263862e208f05258353f86fa3318
5b20ea1312a1a21beaa8b86fe3a07140	2df929d9b6150c082888b66e8129ee3f
5b22d1d5846a2b6b6d0cf342e912d124	7a3808eef413b514776a7202fd2cb94f
5b709b96ee02a30be5eee558e3058245	02d3190ce0f08f32be33da6cc8ec8df8
5b709b96ee02a30be5eee558e3058245	a29864963573d7bb061691ff823b97dd
5b709b96ee02a30be5eee558e3058245	d5a9c37bc91d6d5d55a3c2e38c3bf97d
5c0adc906f34f9404d65a47eea76dac0	02d3190ce0f08f32be33da6cc8ec8df8
5c0adc906f34f9404d65a47eea76dac0	bb273189d856ee630d92fbc0274178bb
5c0adc906f34f9404d65a47eea76dac0	d5a9c37bc91d6d5d55a3c2e38c3bf97d
5cd1c3c856115627b4c3e93991f2d9cd	a29864963573d7bb061691ff823b97dd
5ce10014f645da4156ddd2cd0965986e	2336f976c6d510d2a269a746a7756232
5ce10014f645da4156ddd2cd0965986e	2e607ef3a19cf3de029e2c5882896d33
5ce10014f645da4156ddd2cd0965986e	7349da19c2ad6654280ecf64ce42b837
5df92b70e2855656e9b3ffdf313d7379	10a17b42501166d3bf8fbdff7e1d52b6
5df92b70e2855656e9b3ffdf313d7379	7fa69773873856d74f68a6824ca4b691
5e4317ada306a255748447aef73fff68	01864d382accf1cdb077e42032b16340
5e4317ada306a255748447aef73fff68	a29864963573d7bb061691ff823b97dd
5ec1e9fa36898eaf6d1021be67e0d00c	04ae76937270105919847d05aee582b4
5ec1e9fa36898eaf6d1021be67e0d00c	585f02a68092351a078fc43a21a56564
5ec1e9fa36898eaf6d1021be67e0d00c	5bf88dc6f6501943cc5bc4c42c71b36b
5efb7d24387b25d8325839be958d9adf	36e61931478cf781e59da3b5ae2ee64e
5efb7d24387b25d8325839be958d9adf	4fb2ada7c5440a256ed0e03c967fce74
5f992768f7bb9592bed35b07197c87d0	17b8dff9566f6c98062ad5811c762f44
5f992768f7bb9592bed35b07197c87d0	a29864963573d7bb061691ff823b97dd
5f992768f7bb9592bed35b07197c87d0	a68d5b72c2f98613f511337a59312f78
626dceb92e4249628c1e76a2c955cd24	7fa69773873856d74f68a6824ca4b691
6369ba49db4cf35b35a7c47e3d4a4fd0	bbc90d6701da0aa2bf7f6f2acb79e18c
6369ba49db4cf35b35a7c47e3d4a4fd0	dcd00c11302e3b16333943340d6b4a6b
63ad3072dc5472bb44c2c42ede26d90f	a29864963573d7bb061691ff823b97dd
63ae1791fc0523f47bea9485ffec8b8c	de62af4f3af4adf9e8c8791071ddafe3
63bd9a49dd18fbc89c2ec1e1b689ddda	17b8dff9566f6c98062ad5811c762f44
63d7f33143522ba270cb2c87f724b126	01864d382accf1cdb077e42032b16340
63d7f33143522ba270cb2c87f724b126	d5a9c37bc91d6d5d55a3c2e38c3bf97d
649db5c9643e1c17b3a44579980da0ad	10a17b42501166d3bf8fbdff7e1d52b6
649db5c9643e1c17b3a44579980da0ad	17b8dff9566f6c98062ad5811c762f44
652208d2aa8cdd769632dbaeb7a16358	4fb2ada7c5440a256ed0e03c967fce74
656d1497f7e25fe0559c6be81a4bccae	10a17b42501166d3bf8fbdff7e1d52b6
656d1497f7e25fe0559c6be81a4bccae	17b8dff9566f6c98062ad5811c762f44
65976b6494d411d609160a2dfd98f903	02d3190ce0f08f32be33da6cc8ec8df8
65976b6494d411d609160a2dfd98f903	2d4b3247824e58c3c9af547cce7c2c8f
65976b6494d411d609160a2dfd98f903	bb273189d856ee630d92fbc0274178bb
660813131789b822f0c75c667e23fc85	a29864963573d7bb061691ff823b97dd
660813131789b822f0c75c667e23fc85	d5a9c37bc91d6d5d55a3c2e38c3bf97d
66599a31754b5ac2a202c46c2b577c8e	17b8dff9566f6c98062ad5811c762f44
66599a31754b5ac2a202c46c2b577c8e	d5a9c37bc91d6d5d55a3c2e38c3bf97d
66599a31754b5ac2a202c46c2b577c8e	ecbff10e148109728d5ebce3341bb85e
6738f9acd4740d945178c649d6981734	e6218d584a501be9b1c36ac5ed13f2db
679eaa47efb2f814f2642966ee6bdfe1	a279b219de7726798fc2497d48bc0402
679eaa47efb2f814f2642966ee6bdfe1	d5a9c37bc91d6d5d55a3c2e38c3bf97d
6830afd7158930ca7d1959ce778eb681	34d8a5e79a59df217c6882ee766c850a
6830afd7158930ca7d1959ce778eb681	b45e0862060b7535e176f48d3e0b89f3
6a0e9ce4e2da4f2cbcd1292fddaa0ac6	2336f976c6d510d2a269a746a7756232
6b7cf117ecf0fea745c4c375c1480cb5	17b8dff9566f6c98062ad5811c762f44
6bafe8cf106c32d485c469d36c056989	2336f976c6d510d2a269a746a7756232
6bafe8cf106c32d485c469d36c056989	6de7f9aa9c912bf8c81a9ce2bfc062bd
6bd19bad2b0168d4481b19f9c25b4a9f	262770cfc76233c4f0d7a1e43a36cbf7
6bd19bad2b0168d4481b19f9c25b4a9f	885ba57d521cd859bacf6f76fb37ef7c
6c00bb1a64f660600a6c1545377f92dc	1396a3913454b8016ddf671d02e861b1
6c00bb1a64f660600a6c1545377f92dc	2336f976c6d510d2a269a746a7756232
6c1fcd3c91bc400e5c16f467d75dced3	268a3b877b5f3694d5d1964c654ca91c
6c607fc8c0adc99559bc14e01170fee1	a29864963573d7bb061691ff823b97dd
6c607fc8c0adc99559bc14e01170fee1	d5a9c37bc91d6d5d55a3c2e38c3bf97d
6d3b28f48c848a21209a84452d66c0c4	17b8dff9566f6c98062ad5811c762f44
6d3b28f48c848a21209a84452d66c0c4	a68d5b72c2f98613f511337a59312f78
6d57b25c282247075f5e03cde27814df	eaa57a9b4248ce3968e718895e1c2f04
6ee2e6d391fa98d7990b502e72c7ec58	04ae76937270105919847d05aee582b4
6f195d8f9fe09d45d2e680f7d7157541	7a3808eef413b514776a7202fd2cb94f
6f195d8f9fe09d45d2e680f7d7157541	c5405146cd45f9d9b4f02406c35315a8
6f199e29c5782bd05a4fef98e7e41419	7a3808eef413b514776a7202fd2cb94f
71e32909a1bec1edfc09aec09ca2ac17	17b8dff9566f6c98062ad5811c762f44
721c28f4c74928cc9e0bb3fef345e408	17b8dff9566f6c98062ad5811c762f44
72778afd2696801f5f3a1f35d0e4e357	1eef6db16bfc0aaf8904df1503895979
72778afd2696801f5f3a1f35d0e4e357	9c093ec7867ba1df61e27a5943168b90
73affe574e6d4dc2fa72b46dc9dd4815	7a3808eef413b514776a7202fd2cb94f
73affe574e6d4dc2fa72b46dc9dd4815	d5a9c37bc91d6d5d55a3c2e38c3bf97d
73affe574e6d4dc2fa72b46dc9dd4815	f41da0c65a8fa3690e6a6877e7112afb
7462f03404f29ea618bcc9d52de8e647	04ae76937270105919847d05aee582b4
7462f03404f29ea618bcc9d52de8e647	17b8dff9566f6c98062ad5811c762f44
7462f03404f29ea618bcc9d52de8e647	a29864963573d7bb061691ff823b97dd
7463543d784aa59ca86359a50ef58c8e	17b8dff9566f6c98062ad5811c762f44
7463543d784aa59ca86359a50ef58c8e	a29864963573d7bb061691ff823b97dd
7492a1ca2669793b485b295798f5d782	6add228b14f132e14ae9da754ef070c5
74b3b7be6ed71b946a151d164ad8ede5	b7d08853c905c8cd1467f7bdf0dc176f
7533f96ec01fd81438833f71539c7d4e	04ae76937270105919847d05aee582b4
75ab0270163731ee05f35640d56ef473	c08ed51a7772c1f8352ad69071187515
75ab0270163731ee05f35640d56ef473	dcd00c11302e3b16333943340d6b4a6b
76700087e932c3272e05694610d604ba	a68d5b72c2f98613f511337a59312f78
776da10f7e18ffde35ea94d144dc60a3	01864d382accf1cdb077e42032b16340
7771012413f955f819866e517b275cb4	17b8dff9566f6c98062ad5811c762f44
7771012413f955f819866e517b275cb4	a29864963573d7bb061691ff823b97dd
77f2b3ea9e4bd785f5ff322bae51ba07	01864d382accf1cdb077e42032b16340
77f2b3ea9e4bd785f5ff322bae51ba07	4fb2ada7c5440a256ed0e03c967fce74
79566192cda6b33a9ff59889eede2d66	2e607ef3a19cf3de029e2c5882896d33
79566192cda6b33a9ff59889eede2d66	a29864963573d7bb061691ff823b97dd
79ce9bd96a3184b1ee7c700aa2927e67	17b8dff9566f6c98062ad5811c762f44
79ce9bd96a3184b1ee7c700aa2927e67	a29864963573d7bb061691ff823b97dd
7a4fafa7badd04d5d3114ab67b0caf9d	0849fb9eb585f2c20b427a99f1231e40
7c7ab6fbcb47bd5df1e167ca28220ee9	7a3808eef413b514776a7202fd2cb94f
7c7ab6fbcb47bd5df1e167ca28220ee9	caac3244eefed8cffee878acae427e28
7c83727aa466b3b1b9d6556369714fcf	02d3190ce0f08f32be33da6cc8ec8df8
7c83727aa466b3b1b9d6556369714fcf	10a17b42501166d3bf8fbdff7e1d52b6
7c83727aa466b3b1b9d6556369714fcf	1c800aa97116d9afd83204d65d50199a
7c83727aa466b3b1b9d6556369714fcf	5bf88dc6f6501943cc5bc4c42c71b36b
7cd7921da2e6aab79c441a0c2ffc969b	17b8dff9566f6c98062ad5811c762f44
7cd7921da2e6aab79c441a0c2ffc969b	36e61931478cf781e59da3b5ae2ee64e
7cd7921da2e6aab79c441a0c2ffc969b	885ba57d521cd859bacf6f76fb37ef7c
7cd7921da2e6aab79c441a0c2ffc969b	f41da0c65a8fa3690e6a6877e7112afb
7d6b45c02283175f490558068d1fc81b	34d8a5e79a59df217c6882ee766c850a
7d6b45c02283175f490558068d1fc81b	d5a9c37bc91d6d5d55a3c2e38c3bf97d
7d878673694ff2498fbea0e5ba27e0ea	17b8dff9566f6c98062ad5811c762f44
7db066b46f48d010fdb8c87337cdeda4	6de7f9aa9c912bf8c81a9ce2bfc062bd
7df8865bbec157552b8a579e0ed9bfe3	04ae76937270105919847d05aee582b4
7df8865bbec157552b8a579e0ed9bfe3	a29864963573d7bb061691ff823b97dd
7df8865bbec157552b8a579e0ed9bfe3	bb273189d856ee630d92fbc0274178bb
7df8865bbec157552b8a579e0ed9bfe3	d5a9c37bc91d6d5d55a3c2e38c3bf97d
7df8865bbec157552b8a579e0ed9bfe3	dcd00c11302e3b16333943340d6b4a6b
7dfe9aa0ca5bb31382879ccd144cc3ae	5cbdaf6af370a627c84c43743e99e016
7e0d5240ec5d34a30b6f24909e5edcb4	2336f976c6d510d2a269a746a7756232
7e0d5240ec5d34a30b6f24909e5edcb4	2e607ef3a19cf3de029e2c5882896d33
7e0d5240ec5d34a30b6f24909e5edcb4	a29864963573d7bb061691ff823b97dd
7e2b83d69e6c93adf203e13bc7d6f444	10a17b42501166d3bf8fbdff7e1d52b6
7e2b83d69e6c93adf203e13bc7d6f444	17b8dff9566f6c98062ad5811c762f44
7eaf9a47aa47f3c65595ae107feab05d	7a3808eef413b514776a7202fd2cb94f
7ef36a3325a61d4f1cff91acbe77c7e3	0138eefa704205fd48d98528ddcdd5bc
7f29efc2495ce308a8f4aa7bfc11d701	94876c8f843fa0641ed7bdf6562bdbcf
7fc454efb6df96e012e0f937723d24aa	17b8dff9566f6c98062ad5811c762f44
804803e43d2c779d00004a6e87f28e30	a29864963573d7bb061691ff823b97dd
80fcd08f6e887f6cfbedd2156841ab2b	e7faf05839e2f549fb3455df7327942b
8143ee8032c71f6f3f872fc5bb2a4fed	17b8dff9566f6c98062ad5811c762f44
8143ee8032c71f6f3f872fc5bb2a4fed	d5a9c37bc91d6d5d55a3c2e38c3bf97d
8143ee8032c71f6f3f872fc5bb2a4fed	f41da0c65a8fa3690e6a6877e7112afb
820de5995512273916b117944d6da15a	01864d382accf1cdb077e42032b16340
828d51c39c87aad9b1407d409fa58e36	2e607ef3a19cf3de029e2c5882896d33
829922527f0e7d64a3cfda67e24351e3	17b8dff9566f6c98062ad5811c762f44
829922527f0e7d64a3cfda67e24351e3	caac3244eefed8cffee878acae427e28
832dd1d8efbdb257c2c7d3e505142f48	ff7aa8ca226e1b753b0a71d7f0f2e174
8589a6a4d8908d7e8813e9a1c5693d70	7fa69773873856d74f68a6824ca4b691
86482a1e94052aa18cd803a51104cdb9	2894c332092204f7389275e1359f8e9b
8654991720656374d632a5bb0c20ff11	1d67aeafcd3b898e05a75da0fdc01365
8654991720656374d632a5bb0c20ff11	239401e2c0d502df7c9009439bdb5bd3
8654991720656374d632a5bb0c20ff11	4428b837e98e3cc023fc5cd583b28b20
8775f64336ee5e9a8114fbe3a5a628c5	60e1fa5bfa060b5fff1db1ca1bae4f99
8775f64336ee5e9a8114fbe3a5a628c5	f224a37b854811cb14412ceeca43a6ad
87ded0ea2f4029da0a0022000d59232b	2df929d9b6150c082888b66e8129ee3f
87f44124fb8d24f4c832138baede45c7	04ae76937270105919847d05aee582b4
87f44124fb8d24f4c832138baede45c7	885ba57d521cd859bacf6f76fb37ef7c
88711444ece8fe638ae0fb11c64e2df3	924ae2289369a9c1d279d1d59088be64
887d6449e3544dca547a2ddba8f2d894	a29864963573d7bb061691ff823b97dd
889aaf9cd0894206af758577cf5cf071	17b8dff9566f6c98062ad5811c762f44
88dd124c0720845cba559677f3afa15d	10a17b42501166d3bf8fbdff7e1d52b6
891a55e21dfacf2f97c450c77e7c3ea7	2336f976c6d510d2a269a746a7756232
891a55e21dfacf2f97c450c77e7c3ea7	2e607ef3a19cf3de029e2c5882896d33
8945663993a728ab19a3853e5b820a42	585f02a68092351a078fc43a21a56564
897edb97d775897f69fa168a88b01c19	2df929d9b6150c082888b66e8129ee3f
897edb97d775897f69fa168a88b01c19	7fa69773873856d74f68a6824ca4b691
89adcf990042dfdac7fd23685b3f1e37	65d1fb3d4d28880c964b985cf335e04c
89adcf990042dfdac7fd23685b3f1e37	ea9565886c02dbdc4892412537e607d7
8a6f1a01e4b0d9e272126a8646a72088	01864d382accf1cdb077e42032b16340
8b0ee5a501cef4a5699fd3b2d4549e8f	04ae76937270105919847d05aee582b4
8b0ee5a501cef4a5699fd3b2d4549e8f	a29864963573d7bb061691ff823b97dd
8b427a493fc39574fc801404bc032a2f	1396a3913454b8016ddf671d02e861b1
8b427a493fc39574fc801404bc032a2f	2a78330cc0de19f12ae9c7de65b9d5d5
8b427a493fc39574fc801404bc032a2f	ad49b27a742fb199ab722bce67e9c7b2
8bc31f7cc79c177ab7286dda04e2d1e5	7349da19c2ad6654280ecf64ce42b837
8bc31f7cc79c177ab7286dda04e2d1e5	d31813e8ef36490c57d4977e637efbd4
8bc31f7cc79c177ab7286dda04e2d1e5	ef5131009b7ced0b35ea49c8c7690cef
8c69497eba819ee79a964a0d790368fb	17b8dff9566f6c98062ad5811c762f44
8c69497eba819ee79a964a0d790368fb	a29864963573d7bb061691ff823b97dd
8ce896355a45f5b9959eb676b8b5580c	320094e3f180ee372243f1161e9adadc
8d7a18d54e82fcfb7a11566ce94b9109	04ae76937270105919847d05aee582b4
8d7a18d54e82fcfb7a11566ce94b9109	a29864963573d7bb061691ff823b97dd
8e11b2f987a99ed900a44aa1aa8bd3d0	04ae76937270105919847d05aee582b4
8e62fc75d9d0977d0be4771df05b3c2f	fbe238aca6c496dcd05fb8d6d98f275b
8edf4531385941dfc85e3f3d3e32d24f	7886613ffb324e4e0065f25868545a63
8edf4531385941dfc85e3f3d3e32d24f	7a3808eef413b514776a7202fd2cb94f
8edfa58b1aedb58629b80e5be2b2bd92	1c800aa97116d9afd83204d65d50199a
8edfa58b1aedb58629b80e5be2b2bd92	5bf88dc6f6501943cc5bc4c42c71b36b
8edfa58b1aedb58629b80e5be2b2bd92	7a3808eef413b514776a7202fd2cb94f
8f1f10cb698cb995fd69a671af6ecd58	fd00614e73cb66fd71ab13c970a074d8
8fda25275801e4a40df6c73078baf753	01864d382accf1cdb077e42032b16340
8fda25275801e4a40df6c73078baf753	d5a9c37bc91d6d5d55a3c2e38c3bf97d
905a40c3533830252a909603c6fa1e6a	17b8dff9566f6c98062ad5811c762f44
90d127641ffe2a600891cd2e3992685b	a29864963573d7bb061691ff823b97dd
90d523ebbf276f516090656ebfccdc9f	4cfbb125e9878528bab91d12421134d8
90d523ebbf276f516090656ebfccdc9f	60e1fa5bfa060b5fff1db1ca1bae4f99
9138c2cc0326412f2515623f4c850eb3	17b8dff9566f6c98062ad5811c762f44
91a337f89fe65fec1c97f52a821c1178	a68d5b72c2f98613f511337a59312f78
4bb93d90453dd63cc1957a033f7855c7	17b8dff9566f6c98062ad5811c762f44
4bb93d90453dd63cc1957a033f7855c7	7a3808eef413b514776a7202fd2cb94f
4bb93d90453dd63cc1957a033f7855c7	a29864963573d7bb061691ff823b97dd
91b18e22d4963b216af00e1dd43b5d05	f0095594f17b3793be8291117582f96b
91b18e22d4963b216af00e1dd43b5d05	fad6ee4f3b0aded7d0974703e35ae032
91c9ed0262dea7446a4f3a3e1cdd0698	04ae76937270105919847d05aee582b4
91c9ed0262dea7446a4f3a3e1cdd0698	585f02a68092351a078fc43a21a56564
925bd435e2718d623768dbf1bc1cfb60	10a17b42501166d3bf8fbdff7e1d52b6
925bd435e2718d623768dbf1bc1cfb60	7fa69773873856d74f68a6824ca4b691
935b48a84528c4280ec208ce529deea0	7fa69773873856d74f68a6824ca4b691
942c9f2520684c22eb6216a92b711f9e	01864d382accf1cdb077e42032b16340
947ce14614263eab49f780d68555aef8	7fa69773873856d74f68a6824ca4b691
948098e746bdf1c1045c12f042ea98c2	924ae2289369a9c1d279d1d59088be64
952dc6362e304f00575264e9d54d1fa6	17b8dff9566f6c98062ad5811c762f44
96682d9c9f1bed695dbf9176d3ee234c	a29864963573d7bb061691ff823b97dd
97ee29f216391d19f8769f79a1218a71	0cf6ece7453aa814e08cb7c33bd39846
97ee29f216391d19f8769f79a1218a71	17b8dff9566f6c98062ad5811c762f44
97ee29f216391d19f8769f79a1218a71	a68d5b72c2f98613f511337a59312f78
988d10abb9f42e7053450af19ad64c7f	10a17b42501166d3bf8fbdff7e1d52b6
988d10abb9f42e7053450af19ad64c7f	781f547374aef3a99c113ad5a9c12981
990813672e87b667add44c712bb28d3d	17b8dff9566f6c98062ad5811c762f44
990813672e87b667add44c712bb28d3d	a68d5b72c2f98613f511337a59312f78
99bd5eff92fc3ba728a9da5aa1971488	1868ffbe3756a1c3f58300f45aa5e1d3
9a322166803a48932356586f05ef83c7	01864d382accf1cdb077e42032b16340
9ab8f911c74597493400602dc4d2b412	04ae76937270105919847d05aee582b4
9ab8f911c74597493400602dc4d2b412	4fb2ada7c5440a256ed0e03c967fce74
9ab8f911c74597493400602dc4d2b412	585f02a68092351a078fc43a21a56564
9b1088b616414d0dc515ab1f2b4922f1	a29864963573d7bb061691ff823b97dd
9bc2ca9505a273b06aa0b285061cd1de	17b8dff9566f6c98062ad5811c762f44
9cf73d0300eea453f17c6faaeb871c55	17b8dff9566f6c98062ad5811c762f44
9d3ac6904ce73645c6234803cd7e47ca	239401e2c0d502df7c9009439bdb5bd3
9d969d25c9f506c5518bb090ad5f8266	924ae2289369a9c1d279d1d59088be64
9db9bc745a7568b51b3a968d215ddad6	8c42e2739ed83a54e5b2781b504c92de
9db9bc745a7568b51b3a968d215ddad6	e8376ca6a0ac30b2ad0d64de6061adab
9e84832a15f2698f67079a3224c2b6fb	7fa69773873856d74f68a6824ca4b691
9e84832a15f2698f67079a3224c2b6fb	deb8040131c3f6a3caf6a616b34ac482
9f19396638dd8111f2cee938fdf4e455	17b8dff9566f6c98062ad5811c762f44
a332f1280622f9628fccd1b7aac7370a	239401e2c0d502df7c9009439bdb5bd3
a332f1280622f9628fccd1b7aac7370a	f41da0c65a8fa3690e6a6877e7112afb
a3f5542dc915b94a5e10dab658bb0959	8c42e2739ed83a54e5b2781b504c92de
a3f5542dc915b94a5e10dab658bb0959	a68d5b72c2f98613f511337a59312f78
a3f5542dc915b94a5e10dab658bb0959	e8376ca6a0ac30b2ad0d64de6061adab
a4902fb3d5151e823c74dfd51551b4b0	bca74411b74f01449c61b29131bc545e
a4902fb3d5151e823c74dfd51551b4b0	c1bfb800f95ae493952b6db9eb4f0209
a4902fb3d5151e823c74dfd51551b4b0	d5d0458ada103152d94ff3828bf33909
a4902fb3d5151e823c74dfd51551b4b0	dcd00c11302e3b16333943340d6b4a6b
a4977b96c7e5084fcce21a0d07b045f8	0cf6ece7453aa814e08cb7c33bd39846
a4cbfb212102da21b82d94be555ac3ec	17b8dff9566f6c98062ad5811c762f44
a538bfe6fe150a92a72d78f89733dbd0	17b8dff9566f6c98062ad5811c762f44
a538bfe6fe150a92a72d78f89733dbd0	a68d5b72c2f98613f511337a59312f78
a61b878c2b563f289de2109fa0f42144	65805a3772889203be8908bb44d964b3
a61b878c2b563f289de2109fa0f42144	885ba57d521cd859bacf6f76fb37ef7c
a650d82df8ca65bb69a45242ab66b399	01864d382accf1cdb077e42032b16340
a716390764a4896d99837e99f9e009c9	a29864963573d7bb061691ff823b97dd
a7a9c1b4e7f10bd1fdf77aff255154f7	02d3190ce0f08f32be33da6cc8ec8df8
a7a9c1b4e7f10bd1fdf77aff255154f7	1302a3937910e1487d44cec8f9a09660
a7a9c1b4e7f10bd1fdf77aff255154f7	bb273189d856ee630d92fbc0274178bb
a7a9c1b4e7f10bd1fdf77aff255154f7	dcd00c11302e3b16333943340d6b4a6b
a7a9c1b4e7f10bd1fdf77aff255154f7	ff7aa8ca226e1b753b0a71d7f0f2e174
a7f9797e4cd716e1516f9d4845b0e1e2	2e607ef3a19cf3de029e2c5882896d33
a7f9797e4cd716e1516f9d4845b0e1e2	a29864963573d7bb061691ff823b97dd
a825b2b87f3b61c9660b81f340f6e519	b7628553175256a081199e493d97bd3b
a8d9eeed285f1d47836a5546a280a256	a29864963573d7bb061691ff823b97dd
aa86b6fc103fc757e14f03afe6eb0c0a	a68d5b72c2f98613f511337a59312f78
abbf8e3e3c3e78be8bd886484c1283c1	a68d5b72c2f98613f511337a59312f78
abd7ab19ff758cf4c1a2667e5bbac444	deb8040131c3f6a3caf6a616b34ac482
ac03fad3be179a237521ec4ef2620fb0	04ae76937270105919847d05aee582b4
ac94d15f46f10707a39c4bc513cd9f98	2df929d9b6150c082888b66e8129ee3f
ac94d15f46f10707a39c4bc513cd9f98	7fa69773873856d74f68a6824ca4b691
ad01952b3c254c8ebefaf6f73ae62f7d	17b8dff9566f6c98062ad5811c762f44
ad62209fb63910acf40280cea3647ec5	10a17b42501166d3bf8fbdff7e1d52b6
ad62209fb63910acf40280cea3647ec5	17b8dff9566f6c98062ad5811c762f44
ad62209fb63910acf40280cea3647ec5	d5a9c37bc91d6d5d55a3c2e38c3bf97d
ade72e999b4e78925b18cf48d1faafa4	caac3244eefed8cffee878acae427e28
aed85c73079b54830cd50a75c0958a90	17b8dff9566f6c98062ad5811c762f44
b01fbaf98cfbc1b72e8bca0b2e48769c	781f547374aef3a99c113ad5a9c12981
b0ce1e93de9839d07dab8d268ca23728	3770d5a677c09a444a026dc7434bff36
b0ce1e93de9839d07dab8d268ca23728	f0095594f17b3793be8291117582f96b
b14814d0ee12ffadc8f09ab9c604a9d0	a29864963573d7bb061691ff823b97dd
b1bdad87bd3c4ac2c22473846d301a9e	7fa69773873856d74f68a6824ca4b691
b1d465aaf3ccf8701684211b1623adf2	4fb2ada7c5440a256ed0e03c967fce74
b3ffff8517114caf70b9e70734dbaf6f	01864d382accf1cdb077e42032b16340
b3ffff8517114caf70b9e70734dbaf6f	a29864963573d7bb061691ff823b97dd
b570e354b7ebc40e20029fcc7a15e5a7	8dae638cc517185f1e6f065fcd5e8af3
b5d9c5289fe97968a5634b3e138bf9e2	2df929d9b6150c082888b66e8129ee3f
b5d9c5289fe97968a5634b3e138bf9e2	7fa69773873856d74f68a6824ca4b691
b5d9c5289fe97968a5634b3e138bf9e2	caac3244eefed8cffee878acae427e28
b5f7b25b0154c34540eea8965f90984d	04ae76937270105919847d05aee582b4
b5f7b25b0154c34540eea8965f90984d	4cfbb125e9878528bab91d12421134d8
b5f7b25b0154c34540eea8965f90984d	dcd00c11302e3b16333943340d6b4a6b
b6da055500e3d92698575a3cfc74906c	1c800aa97116d9afd83204d65d50199a
b6da055500e3d92698575a3cfc74906c	5bf88dc6f6501943cc5bc4c42c71b36b
b6da055500e3d92698575a3cfc74906c	7a3808eef413b514776a7202fd2cb94f
b885447285ece8226facd896c04cdba2	a29864963573d7bb061691ff823b97dd
b885447285ece8226facd896c04cdba2	d5a9c37bc91d6d5d55a3c2e38c3bf97d
b89e91ccf14bfd7f485dd7be7d789b0a	02c4d46b0568d199466ef1baa339adc8
b89e91ccf14bfd7f485dd7be7d789b0a	2336f976c6d510d2a269a746a7756232
b89e91ccf14bfd7f485dd7be7d789b0a	8dae638cc517185f1e6f065fcd5e8af3
b89e91ccf14bfd7f485dd7be7d789b0a	ef5131009b7ced0b35ea49c8c7690cef
b96a3cb81197e8308c87f6296174fe3e	a29864963573d7bb061691ff823b97dd
baa9d4eef21c7b89f42720313b5812d4	7fa69773873856d74f68a6824ca4b691
baa9d4eef21c7b89f42720313b5812d4	caac3244eefed8cffee878acae427e28
baa9d4eef21c7b89f42720313b5812d4	e22aa8f4c79b6c4bbeb6bcc7f4e1eb26
bb4cc149e8027369e71eb1bb36cd98e0	c1bfb800f95ae493952b6db9eb4f0209
bb4cc149e8027369e71eb1bb36cd98e0	d5d0458ada103152d94ff3828bf33909
bbb668ff900efa57d936e726a09e4fe8	8c42e2739ed83a54e5b2781b504c92de
bbc155fb2b111bf61c4f5ff892915e6b	1c800aa97116d9afd83204d65d50199a
bbce8e45250a239a252752fac7137e00	7a3808eef413b514776a7202fd2cb94f
bbce8e45250a239a252752fac7137e00	ff7aa8ca226e1b753b0a71d7f0f2e174
bd4184ee062e4982b878b6b188793f5b	585f02a68092351a078fc43a21a56564
bd4184ee062e4982b878b6b188793f5b	a68d5b72c2f98613f511337a59312f78
be20385e18333edb329d4574f364a1f0	17b8dff9566f6c98062ad5811c762f44
be20385e18333edb329d4574f364a1f0	a68d5b72c2f98613f511337a59312f78
bfc9ace5d2a11fae56d038d68c601f00	caac3244eefed8cffee878acae427e28
c05d504b806ad065c9b548c0cb1334cd	a29864963573d7bb061691ff823b97dd
c05d504b806ad065c9b548c0cb1334cd	d5a9c37bc91d6d5d55a3c2e38c3bf97d
c127f32dc042184d12b8c1433a77e8c4	1396a3913454b8016ddf671d02e861b1
c127f32dc042184d12b8c1433a77e8c4	2a78330cc0de19f12ae9c7de65b9d5d5
c127f32dc042184d12b8c1433a77e8c4	bbc90d6701da0aa2bf7f6f2acb79e18c
c127f32dc042184d12b8c1433a77e8c4	d5d0458ada103152d94ff3828bf33909
c127f32dc042184d12b8c1433a77e8c4	dcd00c11302e3b16333943340d6b4a6b
c1923ca7992dc6e79d28331abbb64e72	2df929d9b6150c082888b66e8129ee3f
c2855b6617a1b08fed3824564e15a653	caac3244eefed8cffee878acae427e28
c3490492512b7fe65cdb0c7305044675	5b412998332f677ddcc911605985ee3b
c4678a2e0eef323aeb196670f2bc8a6e	7fa69773873856d74f68a6824ca4b691
c4c7cb77b45a448aa3ca63082671ad97	17b8dff9566f6c98062ad5811c762f44
c4c7cb77b45a448aa3ca63082671ad97	caac3244eefed8cffee878acae427e28
c4c7cb77b45a448aa3ca63082671ad97	d5a9c37bc91d6d5d55a3c2e38c3bf97d
c4ddbffb73c1c34d20bd5b3f425ce4b1	8c42e2739ed83a54e5b2781b504c92de
c4f0f5cedeffc6265ec3220ab594d56b	2bd0f5e2048d09734470145332ecdd24
c5dc33e23743fb951b3fe7f1f477b794	e8376ca6a0ac30b2ad0d64de6061adab
c5f022ef2f3211dc1e3b8062ffe764f0	17b8dff9566f6c98062ad5811c762f44
c74b5aa120021cbe18dcddd70d8622da	a29864963573d7bb061691ff823b97dd
c883319a1db14bc28eff8088c5eba10e	ad38eede5e5edecd3903f1701acecf8e
c883319a1db14bc28eff8088c5eba10e	b86219c2df5a0d889f490f88ff22e228
ca5a010309ffb20190558ec20d97e5b2	a68d5b72c2f98613f511337a59312f78
ca5a010309ffb20190558ec20d97e5b2	cbfeef2f0e2cd992e0ea65924a0f28a1
ca5a010309ffb20190558ec20d97e5b2	f41da0c65a8fa3690e6a6877e7112afb
cafe9e68e8f90b3e1328da8858695b31	a29864963573d7bb061691ff823b97dd
cd9483c1733b17f57d11a77c9404893c	2336f976c6d510d2a269a746a7756232
cd9483c1733b17f57d11a77c9404893c	7349da19c2ad6654280ecf64ce42b837
cd9483c1733b17f57d11a77c9404893c	bb273189d856ee630d92fbc0274178bb
cd9483c1733b17f57d11a77c9404893c	ef5131009b7ced0b35ea49c8c7690cef
cddf835bea180bd14234a825be7a7a82	17b8dff9566f6c98062ad5811c762f44
ce2caf05154395724e4436f042b8fa53	924ae2289369a9c1d279d1d59088be64
cf4ee20655dd3f8f0a553c73ffe3f72a	f633e7b30932bbf60ed87e8ebc26839d
d05a0e65818a69cc689b38c0c0007834	a29864963573d7bb061691ff823b97dd
d0a1fd0467dc892f0dc27711637c864e	1868ffbe3756a1c3f58300f45aa5e1d3
d1fb4e47d8421364f49199ee395ad1d3	17b8dff9566f6c98062ad5811c762f44
d1fb4e47d8421364f49199ee395ad1d3	a68d5b72c2f98613f511337a59312f78
d2ff1e521585a91a94fb22752dd0ab45	17b8dff9566f6c98062ad5811c762f44
d3e98095eeccaa253050d67210ef02bb	1c800aa97116d9afd83204d65d50199a
d3e98095eeccaa253050d67210ef02bb	2e607ef3a19cf3de029e2c5882896d33
d3e98095eeccaa253050d67210ef02bb	7349da19c2ad6654280ecf64ce42b837
d3e98095eeccaa253050d67210ef02bb	d3fcef9d7f88d2a12ea460c604731cd5
d3ed8223151e14b936436c336a4c7278	a68d5b72c2f98613f511337a59312f78
d433b7c1ce696b94a8d8f72de6cfbeaa	a68d5b72c2f98613f511337a59312f78
d433b7c1ce696b94a8d8f72de6cfbeaa	ed8e37bad13d76c6dbeb58152440b41e
d449a9b2eed8b0556dc7be9cda36b67b	7a3808eef413b514776a7202fd2cb94f
d449a9b2eed8b0556dc7be9cda36b67b	836ea59914cc7a8e81ee0dd63f7c21c1
d449a9b2eed8b0556dc7be9cda36b67b	f0095594f17b3793be8291117582f96b
d6de9c99f5cfa46352b2bc0be5c98c41	17b8dff9566f6c98062ad5811c762f44
d730e65d54d6c0479561d25724afd813	04ae76937270105919847d05aee582b4
d730e65d54d6c0479561d25724afd813	585f02a68092351a078fc43a21a56564
d73310b95e8b4dece44e2a55dd1274e6	01864d382accf1cdb077e42032b16340
d73310b95e8b4dece44e2a55dd1274e6	d5a9c37bc91d6d5d55a3c2e38c3bf97d
d857ab11d383a7e4d4239a54cbf2a63d	10a17b42501166d3bf8fbdff7e1d52b6
d857ab11d383a7e4d4239a54cbf2a63d	17b8dff9566f6c98062ad5811c762f44
d9ab6b54c3bd5b212e8dc3a14e7699ef	60e1fa5bfa060b5fff1db1ca1bae4f99
d9ab6b54c3bd5b212e8dc3a14e7699ef	885ba57d521cd859bacf6f76fb37ef7c
d9ab6b54c3bd5b212e8dc3a14e7699ef	ea9565886c02dbdc4892412537e607d7
da2110633f62b16a571c40318e4e4c1c	17095255b1df76ab27dd48f29b215a5f
da867941c8bacf9be8e59bc13d765f92	2df929d9b6150c082888b66e8129ee3f
da867941c8bacf9be8e59bc13d765f92	7fa69773873856d74f68a6824ca4b691
db38e12f9903b156f9dc91fce2ef3919	a29864963573d7bb061691ff823b97dd
db46d9a37b31baa64cb51604a2e4939a	caac3244eefed8cffee878acae427e28
dcabc7299e2b9ed5b05c33273e5fdd19	17b8dff9566f6c98062ad5811c762f44
dcff9a127428ffb03fc02fdf6cc39575	04ae76937270105919847d05aee582b4
dcff9a127428ffb03fc02fdf6cc39575	5bf88dc6f6501943cc5bc4c42c71b36b
dcff9a127428ffb03fc02fdf6cc39575	dcd00c11302e3b16333943340d6b4a6b
dd18fa7a5052f2bce8ff7cb4a30903ea	deb8040131c3f6a3caf6a616b34ac482
dddb04bc0d058486d0ef0212c6ea0682	7fa69773873856d74f68a6824ca4b691
de12bbf91bc797df25ab4ae9cee1946b	585f02a68092351a078fc43a21a56564
de12bbf91bc797df25ab4ae9cee1946b	a29864963573d7bb061691ff823b97dd
deaccc41a952e269107cc9a507dfa131	bbc90d6701da0aa2bf7f6f2acb79e18c
deaccc41a952e269107cc9a507dfa131	dcd00c11302e3b16333943340d6b4a6b
dfdef9b5190f331de20fe029babf032e	0cf6ece7453aa814e08cb7c33bd39846
dfdef9b5190f331de20fe029babf032e	9c093ec7867ba1df61e27a5943168b90
e08383c479d96a8a762e23a99fd8bf84	2bd0f5e2048d09734470145332ecdd24
e08383c479d96a8a762e23a99fd8bf84	a68d5b72c2f98613f511337a59312f78
e08383c479d96a8a762e23a99fd8bf84	e8376ca6a0ac30b2ad0d64de6061adab
e0c2b0cc2e71294cd86916807fef62cb	04ae76937270105919847d05aee582b4
e0de9c10bbf73520385ea5dcbdf62073	7a3808eef413b514776a7202fd2cb94f
e0f39406f0e15487dd9d3997b2f5ca61	2336f976c6d510d2a269a746a7756232
e0f39406f0e15487dd9d3997b2f5ca61	2e607ef3a19cf3de029e2c5882896d33
e0f39406f0e15487dd9d3997b2f5ca61	a29864963573d7bb061691ff823b97dd
e1db3add02ca4c1af33edc5a970a3bdc	04ae76937270105919847d05aee582b4
e1db3add02ca4c1af33edc5a970a3bdc	585f02a68092351a078fc43a21a56564
e271e871e304f59e62a263ffe574ea2d	17b8dff9566f6c98062ad5811c762f44
e271e871e304f59e62a263ffe574ea2d	caac3244eefed8cffee878acae427e28
e29ef4beb480eab906ffa7c05aeec23d	17b8dff9566f6c98062ad5811c762f44
e29ef4beb480eab906ffa7c05aeec23d	a29864963573d7bb061691ff823b97dd
e3f0bf612190af6c3fad41214115e004	04ae76937270105919847d05aee582b4
e4b3296f8a9e2a378eb3eb9576b91a37	17b8dff9566f6c98062ad5811c762f44
e61e30572fd58669ae9ea410774e0eb6	17b8dff9566f6c98062ad5811c762f44
e61e30572fd58669ae9ea410774e0eb6	a68d5b72c2f98613f511337a59312f78
e62a773154e1179b0cc8c5592207cb10	04ae76937270105919847d05aee582b4
e62a773154e1179b0cc8c5592207cb10	585f02a68092351a078fc43a21a56564
e64b94f14765cee7e05b4bec8f5fee31	4cfbb125e9878528bab91d12421134d8
e64d38b05d197d60009a43588b2e4583	0cf6ece7453aa814e08cb7c33bd39846
e64d38b05d197d60009a43588b2e4583	17b8dff9566f6c98062ad5811c762f44
e64d38b05d197d60009a43588b2e4583	4cfbb125e9878528bab91d12421134d8
e64d38b05d197d60009a43588b2e4583	885ba57d521cd859bacf6f76fb37ef7c
e67e51d5f41cfc9162ef7fd977d1f9f5	7fa69773873856d74f68a6824ca4b691
e74a88c71835c14d92d583a1ed87cc6c	a29864963573d7bb061691ff823b97dd
e74a88c71835c14d92d583a1ed87cc6c	a68d5b72c2f98613f511337a59312f78
e872b77ff7ac24acc5fa373ebe9bb492	02d3190ce0f08f32be33da6cc8ec8df8
e872b77ff7ac24acc5fa373ebe9bb492	2e9dfd2e07792b56179212f5b8f473e6
e872b77ff7ac24acc5fa373ebe9bb492	72616c6de7633d9ac97165fc7887fa3a
e872b77ff7ac24acc5fa373ebe9bb492	8bbab0ae4d00ad9ffee6cddaf9338584
e872b77ff7ac24acc5fa373ebe9bb492	ad6296818a1cb902ac5d1a3950e79dbe
e872b77ff7ac24acc5fa373ebe9bb492	bfd67ea5a2f5557126b299e33a435ab3
e872b77ff7ac24acc5fa373ebe9bb492	ff7aa8ca226e1b753b0a71d7f0f2e174
e8afde257f8a2cbbd39d866ddfc06103	10a17b42501166d3bf8fbdff7e1d52b6
e8afde257f8a2cbbd39d866ddfc06103	17b8dff9566f6c98062ad5811c762f44
eb2c788da4f36fba18b85ae75aff0344	a68d5b72c2f98613f511337a59312f78
ed24ff8971b1fa43a1efbb386618ce35	17b8dff9566f6c98062ad5811c762f44
ee69e7d19f11ca58843ec2e9e77ddb38	17b8dff9566f6c98062ad5811c762f44
eeaeec364c925e0c821660c7a953546e	1c800aa97116d9afd83204d65d50199a
ef6369d9794dbe861a56100e92a3c71d	2bd0f5e2048d09734470145332ecdd24
f042da2a954a1521114551a6f9e22c75	a29864963573d7bb061691ff823b97dd
f07c3eef5b7758026d45a12c7e2f6134	4b3bb0b44a6aa876b9e125a2c2a5d6a2
f0c051b57055b052a3b7da1608f3039e	a29864963573d7bb061691ff823b97dd
f0e1f32b93f622ea3ddbf6b55b439812	0cf6ece7453aa814e08cb7c33bd39846
f0e1f32b93f622ea3ddbf6b55b439812	1eef6db16bfc0aaf8904df1503895979
f0e1f32b93f622ea3ddbf6b55b439812	34d8a5e79a59df217c6882ee766c850a
f0e1f32b93f622ea3ddbf6b55b439812	ff7aa8ca226e1b753b0a71d7f0f2e174
f29d276fd930f1ad7687ed7e22929b64	01864d382accf1cdb077e42032b16340
f37ab058561fb6d233b9c2a0b080d4d1	f82c0cf1d80eca5ea2884bbc7bd04269
f4219e8fec02ce146754a5be8a85f246	01864d382accf1cdb077e42032b16340
f4219e8fec02ce146754a5be8a85f246	885ba57d521cd859bacf6f76fb37ef7c
f4f870098db58eeae93742dd2bcaf2b2	1868ffbe3756a1c3f58300f45aa5e1d3
f60ab90d94b9cafe6b32f6a93ee8fcda	1c800aa97116d9afd83204d65d50199a
f644bd92037985f8eb20311bc6d5ed94	17b8dff9566f6c98062ad5811c762f44
f8e7112b86fcd9210dfaf32c00d6d375	bb273189d856ee630d92fbc0274178bb
f953fa7b33e7b6503f4380895bbe41c8	2e607ef3a19cf3de029e2c5882896d33
f953fa7b33e7b6503f4380895bbe41c8	a29864963573d7bb061691ff823b97dd
fa03eb688ad8aa1db593d33dabd89bad	8de5a5b30fc3e013e9b52811fe6f3356
fa03eb688ad8aa1db593d33dabd89bad	a68d5b72c2f98613f511337a59312f78
faabbecd319372311ed0781d17b641d1	2336f976c6d510d2a269a746a7756232
faabbecd319372311ed0781d17b641d1	7a3808eef413b514776a7202fd2cb94f
faabbecd319372311ed0781d17b641d1	8dae638cc517185f1e6f065fcd5e8af3
fb28e62c0e801a787d55d97615e89771	a68d5b72c2f98613f511337a59312f78
fb47f889f2c7c4fee1553d0f817b8aaa	17b8dff9566f6c98062ad5811c762f44
fb47f889f2c7c4fee1553d0f817b8aaa	885ba57d521cd859bacf6f76fb37ef7c
fb8be6409408481ad69166324bdade9c	17b8dff9566f6c98062ad5811c762f44
fb8be6409408481ad69166324bdade9c	a29864963573d7bb061691ff823b97dd
fcd1c1b547d03e760d1defa4d2b98783	4fb2ada7c5440a256ed0e03c967fce74
fdc90583bd7a58b91384dea3d1659cde	04ae76937270105919847d05aee582b4
fdc90583bd7a58b91384dea3d1659cde	dcd00c11302e3b16333943340d6b4a6b
fe228019addf1d561d0123caae8d1e52	36e61931478cf781e59da3b5ae2ee64e
fe5b73c2c2cd2d9278c3835c791289b6	01864d382accf1cdb077e42032b16340
fe5b73c2c2cd2d9278c3835c791289b6	7a3808eef413b514776a7202fd2cb94f
ff578d3db4dc3311b3098c8365d54e6b	7fa69773873856d74f68a6824ca4b691
ff5b48d38ce7d0c47c57555d4783a118	4fb2ada7c5440a256ed0e03c967fce74
ffa7450fd138573d8ae665134bccd02c	17b8dff9566f6c98062ad5811c762f44
2447873ddeeecaa165263091c0cbb22f	7a09fdabda255b02b2283e724071944b
fdcf3cdc04f367257c92382e032b6293	a279b219de7726798fc2497d48bc0402
fdcf3cdc04f367257c92382e032b6293	885ba57d521cd859bacf6f76fb37ef7c
bbddc022ee323e0a2b2d8c67e5cd321f	eaa57a9b4248ce3968e718895e1c2f04
94ca28ea8d99549c2280bcc93f98c853	a68d5b72c2f98613f511337a59312f78
94ca28ea8d99549c2280bcc93f98c853	885ba57d521cd859bacf6f76fb37ef7c
94ca28ea8d99549c2280bcc93f98c853	17b8dff9566f6c98062ad5811c762f44
6d89517dbd1a634b097f81f5bdbb07a2	8a055a3739ca4b38b9c5a188d6295830
eb3bfb5a3ccdd4483aabc307ae236066	eaa57a9b4248ce3968e718895e1c2f04
0ab20b5ad4d15b445ed94fa4eebb18d8	7a3808eef413b514776a7202fd2cb94f
12e93f5fab5f7d16ef37711ef264d282	a29864963573d7bb061691ff823b97dd
33f03dd57f667d41ac77c6baec352a81	bb273189d856ee630d92fbc0274178bb
399033f75fcf47d6736c9c5209222ab8	d5a9c37bc91d6d5d55a3c2e38c3bf97d
399033f75fcf47d6736c9c5209222ab8	0cf6ece7453aa814e08cb7c33bd39846
399033f75fcf47d6736c9c5209222ab8	885ba57d521cd859bacf6f76fb37ef7c
d9bc1db8c13da3a131d853237e1f05b2	17b8dff9566f6c98062ad5811c762f44
d9bc1db8c13da3a131d853237e1f05b2	a29864963573d7bb061691ff823b97dd
d9bc1db8c13da3a131d853237e1f05b2	ea9565886c02dbdc4892412537e607d7
1197a69404ee9475146f3d631de12bde	885ba57d521cd859bacf6f76fb37ef7c
1197a69404ee9475146f3d631de12bde	9c093ec7867ba1df61e27a5943168b90
fdcbfded0aaf369d936a70324b39c978	eaa57a9b4248ce3968e718895e1c2f04
fdcbfded0aaf369d936a70324b39c978	6add228b14f132e14ae9da754ef070c5
754230e2c158107a2e93193c829e9e59	a29864963573d7bb061691ff823b97dd
a29c1c4f0a97173007be3b737e8febcc	17b8dff9566f6c98062ad5811c762f44
4fab532a185610bb854e0946f4def6a4	17b8dff9566f6c98062ad5811c762f44
e25ee917084bdbdc8506b56abef0f351	17b8dff9566f6c98062ad5811c762f44
e6fd7b62a39c109109d33fcd3b5e129d	17b8dff9566f6c98062ad5811c762f44
e6fd7b62a39c109109d33fcd3b5e129d	10a17b42501166d3bf8fbdff7e1d52b6
da29e297c23e7868f1d50ec5a6a4359b	17b8dff9566f6c98062ad5811c762f44
da29e297c23e7868f1d50ec5a6a4359b	a68d5b72c2f98613f511337a59312f78
da29e297c23e7868f1d50ec5a6a4359b	885ba57d521cd859bacf6f76fb37ef7c
96048e254d2e02ba26f53edd271d3f88	17b8dff9566f6c98062ad5811c762f44
c2275e8ac71d308946a63958bc7603a1	a29864963573d7bb061691ff823b97dd
3bcbddf6c114327fc72ea06bcb02f9ef	a29864963573d7bb061691ff823b97dd
3bcbddf6c114327fc72ea06bcb02f9ef	a68d5b72c2f98613f511337a59312f78
dde3e0b0cc344a7b072bbab8c429f4ff	a29864963573d7bb061691ff823b97dd
dde3e0b0cc344a7b072bbab8c429f4ff	a68d5b72c2f98613f511337a59312f78
dde3e0b0cc344a7b072bbab8c429f4ff	17b8dff9566f6c98062ad5811c762f44
b785a5ffad5e7e36ccac25c51d5d8908	a29864963573d7bb061691ff823b97dd
63c0a328ae2bee49789212822f79b83f	0d1830fc8ac21dfabd6f33ab01578c0b
83d15841023cff02eafedb1c87df9b11	10a17b42501166d3bf8fbdff7e1d52b6
f03bde11d261f185cbacfa32c1c6538c	a29864963573d7bb061691ff823b97dd
f03bde11d261f185cbacfa32c1c6538c	17b8dff9566f6c98062ad5811c762f44
f6540bc63be4c0cb21811353c0d24f69	262770cfc76233c4f0d7a1e43a36cbf7
e4f0ad5ef0ac3037084d8a5e3ca1cabc	17b8dff9566f6c98062ad5811c762f44
e4f0ad5ef0ac3037084d8a5e3ca1cabc	a29864963573d7bb061691ff823b97dd
e4f0ad5ef0ac3037084d8a5e3ca1cabc	fd00614e73cb66fd71ab13c970a074d8
ea16d031090828264793e860a00cc995	17b8dff9566f6c98062ad5811c762f44
5eed658c4b7b68a0ecc49205b68d54e7	deb8040131c3f6a3caf6a616b34ac482
a0fb30950d2a150c1d2624716f216316	17b8dff9566f6c98062ad5811c762f44
a0fb30950d2a150c1d2624716f216316	a68d5b72c2f98613f511337a59312f78
4ad6c928711328d1cf0167bc87079a14	1868ffbe3756a1c3f58300f45aa5e1d3
4ad6c928711328d1cf0167bc87079a14	17b8dff9566f6c98062ad5811c762f44
96e3cdb363fe6df2723be5b994ad117a	efe010f3a24895472e65b173e01b969d
c8d551145807972d194691247e7102a2	17b8dff9566f6c98062ad5811c762f44
45b568ce63ea724c415677711b4328a7	17b8dff9566f6c98062ad5811c762f44
c238980432ab6442df9b2c6698c43e47	9713131159f9810e6f5ae73d82633adb
145bd9cf987b6f96fa6f3b3b326303c9	a68d5b72c2f98613f511337a59312f78
39a25b9c88ce401ca54fd7479d1c8b73	a68d5b72c2f98613f511337a59312f78
8cadf0ad04644ce2947bf3aa2817816e	a68d5b72c2f98613f511337a59312f78
85fac49d29a31f1f9a8a18d6b04b9fc9	a68d5b72c2f98613f511337a59312f78
85fac49d29a31f1f9a8a18d6b04b9fc9	a29864963573d7bb061691ff823b97dd
b81ee269be538a500ed057b3222c86a2	17b8dff9566f6c98062ad5811c762f44
cf71a88972b5e06d8913cf53c916e6e4	17b8dff9566f6c98062ad5811c762f44
5518086aebc9159ba7424be0073ce5c9	17b8dff9566f6c98062ad5811c762f44
5518086aebc9159ba7424be0073ce5c9	01864d382accf1cdb077e42032b16340
5518086aebc9159ba7424be0073ce5c9	a68d5b72c2f98613f511337a59312f78
2c4e2c9948ddac6145e529c2ae7296da	17b8dff9566f6c98062ad5811c762f44
c9af1c425ca093648e919c2e471df3bd	a68d5b72c2f98613f511337a59312f78
0291e38d9a3d398052be0ca52a7b1592	a68d5b72c2f98613f511337a59312f78
0291e38d9a3d398052be0ca52a7b1592	17b8dff9566f6c98062ad5811c762f44
8852173e80d762d62f0bcb379d82ebdb	a68d5b72c2f98613f511337a59312f78
8852173e80d762d62f0bcb379d82ebdb	17b8dff9566f6c98062ad5811c762f44
000f49c98c428aff4734497823d04f45	262770cfc76233c4f0d7a1e43a36cbf7
000f49c98c428aff4734497823d04f45	17b8dff9566f6c98062ad5811c762f44
dea293bdffcfb292b244b6fe92d246dc	a68d5b72c2f98613f511337a59312f78
302ebe0389198972c223f4b72894780a	a29864963573d7bb061691ff823b97dd
ac62ad2816456aa712809bf01327add1	04ae76937270105919847d05aee582b4
470f3f69a2327481d26309dc65656f44	885ba57d521cd859bacf6f76fb37ef7c
470f3f69a2327481d26309dc65656f44	17b8dff9566f6c98062ad5811c762f44
e254616b4a5bd5aaa54f90a3985ed184	17b8dff9566f6c98062ad5811c762f44
e254616b4a5bd5aaa54f90a3985ed184	a68d5b72c2f98613f511337a59312f78
3c5c578b7cf5cc0d23c1730d1d51436a	4fb2ada7c5440a256ed0e03c967fce74
3c5c578b7cf5cc0d23c1730d1d51436a	04ae76937270105919847d05aee582b4
eaeaed2d9f3137518a5c8c7e6733214f	36e61931478cf781e59da3b5ae2ee64e
8ccd65d7f0f028405867991ae3eaeb56	04ae76937270105919847d05aee582b4
8ccd65d7f0f028405867991ae3eaeb56	585f02a68092351a078fc43a21a56564
781acc7e58c9a746d58f6e65ab1e90c4	239401e2c0d502df7c9009439bdb5bd3
e5a674a93987de4a52230105907fffe9	564807fb144a93a857bfda85ab34068d
e5a674a93987de4a52230105907fffe9	a68d5b72c2f98613f511337a59312f78
a2459c5c8a50215716247769c3dea40b	bb273189d856ee630d92fbc0274178bb
e285e4ecb358b92237298f67526beff7	885ba57d521cd859bacf6f76fb37ef7c
e285e4ecb358b92237298f67526beff7	17b8dff9566f6c98062ad5811c762f44
e285e4ecb358b92237298f67526beff7	0cf6ece7453aa814e08cb7c33bd39846
e285e4ecb358b92237298f67526beff7	ff7aa8ca226e1b753b0a71d7f0f2e174
e285e4ecb358b92237298f67526beff7	5bf88dc6f6501943cc5bc4c42c71b36b
d832b654664d104f0fbb9b6674a09a11	1eef6db16bfc0aaf8904df1503895979
2aeb128c6d3eb7e79acb393b50e1cf7b	0cf6ece7453aa814e08cb7c33bd39846
213c449bd4bcfcdb6bffecf55b2c30b4	1eef6db16bfc0aaf8904df1503895979
213c449bd4bcfcdb6bffecf55b2c30b4	9d78e15bf91aef0090e0a37bab153d98
213c449bd4bcfcdb6bffecf55b2c30b4	a46700f6342a2525a9fba12d974d786e
4ea353ae22a1c0d26327638f600aeac8	a46700f6342a2525a9fba12d974d786e
4ea353ae22a1c0d26327638f600aeac8	1eef6db16bfc0aaf8904df1503895979
66244bb43939f81c100f03922cdc3439	4fb2ada7c5440a256ed0e03c967fce74
d399575133268305c24d87f1c2ef054a	1868ffbe3756a1c3f58300f45aa5e1d3
d399575133268305c24d87f1c2ef054a	10a17b42501166d3bf8fbdff7e1d52b6
d399575133268305c24d87f1c2ef054a	1d67aeafcd3b898e05a75da0fdc01365
6ff24c538936b5b53e88258f88294666	02d3190ce0f08f32be33da6cc8ec8df8
6ff24c538936b5b53e88258f88294666	2da00ba473acb055e8652437024c6fd4
6ff24c538936b5b53e88258f88294666	bb273189d856ee630d92fbc0274178bb
6ff24c538936b5b53e88258f88294666	7a3808eef413b514776a7202fd2cb94f
a5a8afc6c35c2625298b9ce4cc447b39	9713131159f9810e6f5ae73d82633adb
5588cb8830fdb8ac7159b7cf5d1e611e	04ae76937270105919847d05aee582b4
5588cb8830fdb8ac7159b7cf5d1e611e	4fb2ada7c5440a256ed0e03c967fce74
9fc7c7342d41c7c53c6e8e4b9bc53fc4	a68d5b72c2f98613f511337a59312f78
9fc7c7342d41c7c53c6e8e4b9bc53fc4	0cf6ece7453aa814e08cb7c33bd39846
071dbd416520d14b2e3688145801de41	a68d5b72c2f98613f511337a59312f78
071dbd416520d14b2e3688145801de41	585f02a68092351a078fc43a21a56564
071dbd416520d14b2e3688145801de41	504724f4d7623c2a03384bd0f213e524
2d1f30c9fc8d7200bdf15b730c4cd757	17b8dff9566f6c98062ad5811c762f44
a1cebab6ecfd371779f9c18e36cbba0c	fd00614e73cb66fd71ab13c970a074d8
a1cebab6ecfd371779f9c18e36cbba0c	10a17b42501166d3bf8fbdff7e1d52b6
57eba43d6bec2a8115e94d6fbb42bc75	a29864963573d7bb061691ff823b97dd
57eba43d6bec2a8115e94d6fbb42bc75	d5a9c37bc91d6d5d55a3c2e38c3bf97d
57eba43d6bec2a8115e94d6fbb42bc75	7a3808eef413b514776a7202fd2cb94f
57eba43d6bec2a8115e94d6fbb42bc75	02d3190ce0f08f32be33da6cc8ec8df8
9ee30f495029e1fdf6567045f2079be1	17b8dff9566f6c98062ad5811c762f44
17bcf0bc2768911a378a55f42acedba7	f22794f69ce5910cb4be68ff9026570d
f9f57e175d62861bb5f2bda44a078df7	cb6ef856481bc776bba38fbf15b8b3fb
3921cb3f97a88349e153beb5492f6ef4	a68d5b72c2f98613f511337a59312f78
6a8538b37162b23d68791b9a0c54a5bf	a68d5b72c2f98613f511337a59312f78
2654d6e7cec2ef045ca1772a980fbc4c	a29864963573d7bb061691ff823b97dd
57b9fe77adaac4846c238e995adb6ee2	4b3bb0b44a6aa876b9e125a2c2a5d6a2
8259dc0bcebabcb0696496ca406dd672	a29864963573d7bb061691ff823b97dd
8259dc0bcebabcb0696496ca406dd672	585f02a68092351a078fc43a21a56564
ab7b69efdaf168cbbe9a5b03d901be74	04ae76937270105919847d05aee582b4
ab7b69efdaf168cbbe9a5b03d901be74	a29864963573d7bb061691ff823b97dd
3041a64f7587a6768d8e307b2662785b	17b8dff9566f6c98062ad5811c762f44
3041a64f7587a6768d8e307b2662785b	caac3244eefed8cffee878acae427e28
32921081f86e80cd10138b8959260e1a	17b8dff9566f6c98062ad5811c762f44
4d79c341966242c047f3833289ee3a13	17b8dff9566f6c98062ad5811c762f44
4d79c341966242c047f3833289ee3a13	a29864963573d7bb061691ff823b97dd
4d79c341966242c047f3833289ee3a13	d5a9c37bc91d6d5d55a3c2e38c3bf97d
c58de8415b504a6ffa5d0b14967f91bb	2336f976c6d510d2a269a746a7756232
c58de8415b504a6ffa5d0b14967f91bb	a29864963573d7bb061691ff823b97dd
03022be9e2729189e226cca023a2c9bf	17b8dff9566f6c98062ad5811c762f44
03022be9e2729189e226cca023a2c9bf	a68d5b72c2f98613f511337a59312f78
03022be9e2729189e226cca023a2c9bf	a29864963573d7bb061691ff823b97dd
f17c7007dd2ed483b9df587c1fdac2c7	17b8dff9566f6c98062ad5811c762f44
1bb6d0271ea775dfdfa7f9fe1048147a	4b3bb0b44a6aa876b9e125a2c2a5d6a2
743c89c3e93b9295c1ae6e750047fb1e	d5a9c37bc91d6d5d55a3c2e38c3bf97d
743c89c3e93b9295c1ae6e750047fb1e	7a3808eef413b514776a7202fd2cb94f
93f4aac22b526b5f0c908462da306ffc	585f02a68092351a078fc43a21a56564
93f4aac22b526b5f0c908462da306ffc	a29864963573d7bb061691ff823b97dd
c2e88140e99f33883dac39daee70ac36	04ae76937270105919847d05aee582b4
368ff974da0defe085637b7199231c0a	7a3808eef413b514776a7202fd2cb94f
ccff6df2a54baa3adeb0bddb8067e7c0	a29864963573d7bb061691ff823b97dd
ccff6df2a54baa3adeb0bddb8067e7c0	01864d382accf1cdb077e42032b16340
ccff6df2a54baa3adeb0bddb8067e7c0	7a3808eef413b514776a7202fd2cb94f
26830d74f9ed8e7e4ea4e82e28fa4761	5cbdaf6af370a627c84c43743e99e016
02f36cf6fe7b187306b2a7d423cafc2c	f41da0c65a8fa3690e6a6877e7112afb
71e720cd3fcc3cdb99f2f4dc7122e078	a68d5b72c2f98613f511337a59312f78
54c09bacc963763eb8742fa1da44a968	17b8dff9566f6c98062ad5811c762f44
e563e0ba5dbf7c9417681c407d016277	74d754b83e2656bcc0cb58033a03e6e4
1745438c6be58479227d8c0d0220eec5	e22aa8f4c79b6c4bbeb6bcc7f4e1eb26
1745438c6be58479227d8c0d0220eec5	7fa69773873856d74f68a6824ca4b691
7e5550d889d46d55df3065d742b5da51	7fa69773873856d74f68a6824ca4b691
0870b61c5e913cb405d250e80c9ba9b9	10a17b42501166d3bf8fbdff7e1d52b6
393a71c997d856ed5bb85a9695be6e46	caac3244eefed8cffee878acae427e28
20f0ae2f661bf20e506108c40c33a6f3	7fa69773873856d74f68a6824ca4b691
20f0ae2f661bf20e506108c40c33a6f3	2df929d9b6150c082888b66e8129ee3f
96604499bfc96fcdb6da0faa204ff2fe	7fa69773873856d74f68a6824ca4b691
3ed0c2ad2c9e6e7b161e6fe0175fe113	17b8dff9566f6c98062ad5811c762f44
3ed0c2ad2c9e6e7b161e6fe0175fe113	7fa69773873856d74f68a6824ca4b691
fd9a5c27c20cd89e4ffcc1592563abcf	17b8dff9566f6c98062ad5811c762f44
a5475ebd65796bee170ad9f1ef746394	17b8dff9566f6c98062ad5811c762f44
a5475ebd65796bee170ad9f1ef746394	10a17b42501166d3bf8fbdff7e1d52b6
1fda271217bb4c043c691fc6344087c1	f008a5f1cb81bcfa397f7c1987f2bf55
cba95a42c53bdc6fbf3ddf9bf10a4069	17b8dff9566f6c98062ad5811c762f44
cba95a42c53bdc6fbf3ddf9bf10a4069	2df929d9b6150c082888b66e8129ee3f
fe2c9aea6c702e6b82bc19b4a5d76f90	caac3244eefed8cffee878acae427e28
fe2c9aea6c702e6b82bc19b4a5d76f90	7fa69773873856d74f68a6824ca4b691
bb66c20c42c26f1874525c3ab956ec41	7fa69773873856d74f68a6824ca4b691
bb66c20c42c26f1874525c3ab956ec41	deb8040131c3f6a3caf6a616b34ac482
aad365e95c3d5fadb5fdf9517c371e89	17b8dff9566f6c98062ad5811c762f44
88a51a2e269e7026f0734f3ef3244e89	7fa69773873856d74f68a6824ca4b691
5c1a922f41003eb7a19b570c33b99ff4	2df929d9b6150c082888b66e8129ee3f
5c1a922f41003eb7a19b570c33b99ff4	b1ba0a25e72cac8ac1f43019f45edcc9
5c1a922f41003eb7a19b570c33b99ff4	17b8dff9566f6c98062ad5811c762f44
de506362ebfcf7c632d659aa1f2b465d	7fa69773873856d74f68a6824ca4b691
1a8780e5531549bd454a04630a74cd4d	caac3244eefed8cffee878acae427e28
c0d7362d0f52d119f1beb38b12c0b651	17b8dff9566f6c98062ad5811c762f44
c0d7362d0f52d119f1beb38b12c0b651	10a17b42501166d3bf8fbdff7e1d52b6
edd506a412c4f830215d4c0f1ac06e55	e22aa8f4c79b6c4bbeb6bcc7f4e1eb26
edd506a412c4f830215d4c0f1ac06e55	7fa69773873856d74f68a6824ca4b691
dde31adc1b0014ce659a65c8b4d6ce42	17b8dff9566f6c98062ad5811c762f44
4267b5081fdfb47c085db24b58d949e0	7fa69773873856d74f68a6824ca4b691
4267b5081fdfb47c085db24b58d949e0	2df929d9b6150c082888b66e8129ee3f
8f7de32e3b76c02859d6b007417bd509	7fa69773873856d74f68a6824ca4b691
332d6b94de399f86d499be57f8a5a5ca	caac3244eefed8cffee878acae427e28
b73377a1ec60e58d4eeb03347268c11b	d5a9c37bc91d6d5d55a3c2e38c3bf97d
e3419706e1838c7ce6c25a28bef0c248	7a3808eef413b514776a7202fd2cb94f
382ed38ecc68052678c5ac5646298b63	7fa69773873856d74f68a6824ca4b691
382ed38ecc68052678c5ac5646298b63	10a17b42501166d3bf8fbdff7e1d52b6
213c302f84c5d45929b66a20074075df	a29864963573d7bb061691ff823b97dd
22c030759ab12f97e941af558566505e	10a17b42501166d3bf8fbdff7e1d52b6
f5507c2c7beee622b98ade0b93abb7fe	a29864963573d7bb061691ff823b97dd
f5507c2c7beee622b98ade0b93abb7fe	04ae76937270105919847d05aee582b4
f5507c2c7beee622b98ade0b93abb7fe	dcd00c11302e3b16333943340d6b4a6b
41bee031bd7d2fdb14ff48c92f4d7984	7a3808eef413b514776a7202fd2cb94f
41bee031bd7d2fdb14ff48c92f4d7984	7886613ffb324e4e0065f25868545a63
41bee031bd7d2fdb14ff48c92f4d7984	34d8a5e79a59df217c6882ee766c850a
39a464d24bf08e6e8df586eb5fa7ee30	4cfbb125e9878528bab91d12421134d8
39a464d24bf08e6e8df586eb5fa7ee30	eaa57a9b4248ce3968e718895e1c2f04
f7c3dcc7ba01d0ead8e0cfb59cdf6afc	924ae2289369a9c1d279d1d59088be64
4b42093adfc268ce8974a3fa8c4f6bca	a68d5b72c2f98613f511337a59312f78
70d0b58ef51e537361d676f05ea39c7b	239401e2c0d502df7c9009439bdb5bd3
6f0eadd7aadf134b1b84d9761808d5ad	a68d5b72c2f98613f511337a59312f78
6896f30283ad47ceb4a17c8c8d625891	17b8dff9566f6c98062ad5811c762f44
6896f30283ad47ceb4a17c8c8d625891	d5a9c37bc91d6d5d55a3c2e38c3bf97d
25118c5df9a2865a8bc97feb4aff4a18	01864d382accf1cdb077e42032b16340
5a53bed7a0e05c2b865537d96a39646f	262770cfc76233c4f0d7a1e43a36cbf7
29b7417c5145049d6593a0d88759b9ee	0cf6ece7453aa814e08cb7c33bd39846
29b7417c5145049d6593a0d88759b9ee	4cfbb125e9878528bab91d12421134d8
4176aa79eae271d1b82015feceb00571	262770cfc76233c4f0d7a1e43a36cbf7
4176aa79eae271d1b82015feceb00571	17b8dff9566f6c98062ad5811c762f44
4176aa79eae271d1b82015feceb00571	0cf6ece7453aa814e08cb7c33bd39846
c81794404ad68d298e9ceb75f69cf810	de62af4f3af4adf9e8c8791071ddafe3
c81794404ad68d298e9ceb75f69cf810	0cf6ece7453aa814e08cb7c33bd39846
c81794404ad68d298e9ceb75f69cf810	a68d5b72c2f98613f511337a59312f78
d0386252fd85f76fc517724666cf59ae	4fb2ada7c5440a256ed0e03c967fce74
d0386252fd85f76fc517724666cf59ae	585f02a68092351a078fc43a21a56564
0cddbf403096e44a08bc37d1e2e99b0f	262770cfc76233c4f0d7a1e43a36cbf7
0b9d35d460b848ad46ec0568961113bf	4fb2ada7c5440a256ed0e03c967fce74
546bb05114b78748d142c67cdbdd34fd	17b8dff9566f6c98062ad5811c762f44
546bb05114b78748d142c67cdbdd34fd	262770cfc76233c4f0d7a1e43a36cbf7
4ac863b6f6fa5ef02afdd9c1ca2a5e24	17b8dff9566f6c98062ad5811c762f44
4ac863b6f6fa5ef02afdd9c1ca2a5e24	262770cfc76233c4f0d7a1e43a36cbf7
1e2bcbb679ccfdea27b28bd1ea9f2e67	a68d5b72c2f98613f511337a59312f78
1c62394f457ee9a56b0885f622299ea2	01864d382accf1cdb077e42032b16340
b7e529a8e9af2a2610182b3d3fc33698	d5a9c37bc91d6d5d55a3c2e38c3bf97d
b7e529a8e9af2a2610182b3d3fc33698	a29864963573d7bb061691ff823b97dd
b7e529a8e9af2a2610182b3d3fc33698	02d3190ce0f08f32be33da6cc8ec8df8
64d9f86ed9eeac2695ec7847fe7ea313	01864d382accf1cdb077e42032b16340
b04d1a151c786ee00092110333873a37	a68d5b72c2f98613f511337a59312f78
65b029279eb0f99c0a565926566f6759	a68d5b72c2f98613f511337a59312f78
9bfbfab5220218468ecb02ed546e3d90	a68d5b72c2f98613f511337a59312f78
9bfbfab5220218468ecb02ed546e3d90	885ba57d521cd859bacf6f76fb37ef7c
9bfbfab5220218468ecb02ed546e3d90	17b8dff9566f6c98062ad5811c762f44
be41b6cfece7dfa1b4e4d226fb999607	a68d5b72c2f98613f511337a59312f78
9c158607f29eaf8f567cc6304ada9c6d	a68d5b72c2f98613f511337a59312f78
ca7e3b5c1860730cfd7b400de217fef2	60e1fa5bfa060b5fff1db1ca1bae4f99
8f4e7c5f66d6ee5698c01de29affc562	a29864963573d7bb061691ff823b97dd
f0bf2458b4c1a22fc329f036dd439f08	a29864963573d7bb061691ff823b97dd
25fa2cdf2be085aa5394db743677fb69	2894c332092204f7389275e1359f8e9b
32917b03e82a83d455dd6b7f8609532c	eaa57a9b4248ce3968e718895e1c2f04
0bcf509f7eb2db3b663f5782c8c4a86e	caac3244eefed8cffee878acae427e28
4ffc374ef33b65b6acb388167ec542c0	caac3244eefed8cffee878acae427e28
0c2277f470a7e9a2d70195ba32e1b08a	caac3244eefed8cffee878acae427e28
42c9b99c6b409bc9990658f6e7829542	caac3244eefed8cffee878acae427e28
bb51d2b900ba638568e48193aada8a6c	a29864963573d7bb061691ff823b97dd
92df3fd170b0285cd722e855a2968393	deb8040131c3f6a3caf6a616b34ac482
b20a4217acaf4316739c6a5f6679ef60	17b8dff9566f6c98062ad5811c762f44
b20a4217acaf4316739c6a5f6679ef60	10a17b42501166d3bf8fbdff7e1d52b6
b20a4217acaf4316739c6a5f6679ef60	deb8040131c3f6a3caf6a616b34ac482
34b1dade51ffdab56daebcf6ac981371	8c42e2739ed83a54e5b2781b504c92de
34b1dade51ffdab56daebcf6ac981371	bb9a7990e74371142d6f4f02353a0db0
9d57ebbd1d3b135839b78221388394a1	04ae76937270105919847d05aee582b4
9d57ebbd1d3b135839b78221388394a1	4cfbb125e9878528bab91d12421134d8
9d57ebbd1d3b135839b78221388394a1	d5a9c37bc91d6d5d55a3c2e38c3bf97d
1833e2cfde2a7cf621d60288da14830c	04ae76937270105919847d05aee582b4
1833e2cfde2a7cf621d60288da14830c	dcd00c11302e3b16333943340d6b4a6b
1833e2cfde2a7cf621d60288da14830c	d5a9c37bc91d6d5d55a3c2e38c3bf97d
1833e2cfde2a7cf621d60288da14830c	7b327f171695316c16ddca1843a81531
178227c5aef3b3ded144b9e19867a370	10a17b42501166d3bf8fbdff7e1d52b6
178227c5aef3b3ded144b9e19867a370	17b8dff9566f6c98062ad5811c762f44
351af29ee203c740c3209a0e0a8e9c22	7fa69773873856d74f68a6824ca4b691
b74881ac32a010e91ac7fcbcfebe210e	7fa69773873856d74f68a6824ca4b691
75cde58f0e5563f287f2d4afb0ce4b7e	17b8dff9566f6c98062ad5811c762f44
75cde58f0e5563f287f2d4afb0ce4b7e	10a17b42501166d3bf8fbdff7e1d52b6
bbdbdf297183a1c24be29ed89711f744	2df929d9b6150c082888b66e8129ee3f
bbdbdf297183a1c24be29ed89711f744	a29864963573d7bb061691ff823b97dd
6e512379810ecf71206459e6a1e64154	a29864963573d7bb061691ff823b97dd
6e512379810ecf71206459e6a1e64154	17b8dff9566f6c98062ad5811c762f44
6e512379810ecf71206459e6a1e64154	a68d5b72c2f98613f511337a59312f78
f3b65f675d13d81c12d3bb30b0190cd1	fd00614e73cb66fd71ab13c970a074d8
f3b65f675d13d81c12d3bb30b0190cd1	caac3244eefed8cffee878acae427e28
f3b65f675d13d81c12d3bb30b0190cd1	7b327f171695316c16ddca1843a81531
1918775515a9c7b8db011fd35a443b82	17b8dff9566f6c98062ad5811c762f44
1918775515a9c7b8db011fd35a443b82	1c800aa97116d9afd83204d65d50199a
15bf34427540dd1945e5992583412b2f	2336f976c6d510d2a269a746a7756232
ba8033b8cfb1ebfc91a5d03b3a268d9f	5515abb95e50f2f39c3072b4fef777e0
fd85bfffd5a0667738f6110281b25db8	17b8dff9566f6c98062ad5811c762f44
fd85bfffd5a0667738f6110281b25db8	caac3244eefed8cffee878acae427e28
6e4b91e3d1950bcad012dbfbdd0fff09	17b8dff9566f6c98062ad5811c762f44
6e4b91e3d1950bcad012dbfbdd0fff09	a29864963573d7bb061691ff823b97dd
32a02a8a7927de4a39e9e14f2dc46ac6	deb8040131c3f6a3caf6a616b34ac482
747f992097b9e5c9df7585931537150a	17b8dff9566f6c98062ad5811c762f44
747f992097b9e5c9df7585931537150a	10a17b42501166d3bf8fbdff7e1d52b6
19819b153eb0990c821bc106e34ab3e1	a29864963573d7bb061691ff823b97dd
19819b153eb0990c821bc106e34ab3e1	d5a9c37bc91d6d5d55a3c2e38c3bf97d
13c260ca90c0f47c9418790429220899	17b8dff9566f6c98062ad5811c762f44
b619e7f3135359e3f778e90d1942e6f5	a29864963573d7bb061691ff823b97dd
0ddd0b1b6329e9cb9a64c4d947e641a8	17b8dff9566f6c98062ad5811c762f44
30354302ae1c0715ccad2649da3d9443	1868ffbe3756a1c3f58300f45aa5e1d3
89eec5d48b8969bf61eea38e4b3cfdbf	9ba0204bc48d4b8721344dd83b832afe
703b1360391d2aef7b9ec688b00849bb	10a17b42501166d3bf8fbdff7e1d52b6
703b1360391d2aef7b9ec688b00849bb	17b8dff9566f6c98062ad5811c762f44
b4b46e6ce2c563dd296e8bae768e1b9d	a68d5b72c2f98613f511337a59312f78
5c8c8b827ae259b8e4f8cb567a577a3e	34d8a5e79a59df217c6882ee766c850a
5c8c8b827ae259b8e4f8cb567a577a3e	30a1a8d73498d142609138c37ac3b9f3
7f00429970ee9fd2a3185f777ff79922	61bb65b2791647f828d25a985a2e60fa
92e2cf901fe43bb77d99af2ff42ade77	8c42e2739ed83a54e5b2781b504c92de
92e2cf901fe43bb77d99af2ff42ade77	a68d5b72c2f98613f511337a59312f78
1a1bfb986176c0ba845ae4f43d027f58	273112316e7fab5a848516666e3a57d1
7ecdb1a0eb7c01d081acf2b7e11531c0	8c42e2739ed83a54e5b2781b504c92de
094caa14a3a49bf282d8f0f262a01f43	885ba57d521cd859bacf6f76fb37ef7c
094caa14a3a49bf282d8f0f262a01f43	156968bdeb9fd240ae047867022d703b
110cb86243320511676f788dbc46f633	17b8dff9566f6c98062ad5811c762f44
110cb86243320511676f788dbc46f633	a29864963573d7bb061691ff823b97dd
110cb86243320511676f788dbc46f633	d5a9c37bc91d6d5d55a3c2e38c3bf97d
8e9f5b1fc0e61f9a289aba4c59e49521	a29864963573d7bb061691ff823b97dd
014dbc80621be3ddc6dd0150bc6571ff	17b8dff9566f6c98062ad5811c762f44
014dbc80621be3ddc6dd0150bc6571ff	a29864963573d7bb061691ff823b97dd
536d1ccb9cce397f948171765c0120d4	65d1fb3d4d28880c964b985cf335e04c
536d1ccb9cce397f948171765c0120d4	885ba57d521cd859bacf6f76fb37ef7c
536d1ccb9cce397f948171765c0120d4	ea9565886c02dbdc4892412537e607d7
15b70a4565372e2da0d330568fe1d795	7fa69773873856d74f68a6824ca4b691
8e331f2ea604deea899bfd0a494309ba	7fa69773873856d74f68a6824ca4b691
46e1d00c2019ff857c307085c58e0015	7fa69773873856d74f68a6824ca4b691
46e1d00c2019ff857c307085c58e0015	deb8040131c3f6a3caf6a616b34ac482
6afdd78eac862dd63833a3ce5964b74b	7fa69773873856d74f68a6824ca4b691
6afdd78eac862dd63833a3ce5964b74b	e22aa8f4c79b6c4bbeb6bcc7f4e1eb26
fb5f71046fd15a0a22d7bda38971f142	1c800aa97116d9afd83204d65d50199a
fb5f71046fd15a0a22d7bda38971f142	17b8dff9566f6c98062ad5811c762f44
512914f31042dacd2a05bfcebaacdb96	17b8dff9566f6c98062ad5811c762f44
d96d9dac0f19368234a1fe2d4daf7f7c	7fa69773873856d74f68a6824ca4b691
5aa3856374df5daa99d3d33e6a38a865	10a17b42501166d3bf8fbdff7e1d52b6
5aa3856374df5daa99d3d33e6a38a865	17b8dff9566f6c98062ad5811c762f44
5aa3856374df5daa99d3d33e6a38a865	e3bae98a1c48ce980083c79f6416c0f6
e83655f0458b6c309866fbde556be35a	17b8dff9566f6c98062ad5811c762f44
92dd59a949dfceab979dd25ac858f204	17b8dff9566f6c98062ad5811c762f44
92dd59a949dfceab979dd25ac858f204	10a17b42501166d3bf8fbdff7e1d52b6
ee1bc524d6d3410e94a99706dcb12319	10a17b42501166d3bf8fbdff7e1d52b6
ee1bc524d6d3410e94a99706dcb12319	7fa69773873856d74f68a6824ca4b691
c09ffd48de204e4610d474ade2cf3a0d	10a17b42501166d3bf8fbdff7e1d52b6
c09ffd48de204e4610d474ade2cf3a0d	17b8dff9566f6c98062ad5811c762f44
bfff088b67e0fc6d1b80dbd6b6f0620c	d34d0c161bbb04228af45f99d2b407a6
bfff088b67e0fc6d1b80dbd6b6f0620c	6add228b14f132e14ae9da754ef070c5
3e7f48e97425d4c532a0787e54843863	353d5e79c4f0f22dc9fd189fb293b18c
233dedc0bee8bbdf7930eab3dd54daee	0ae61bd0474e04c9f1195d4baa0213a0
80f19b325c934c8396780d0c66a87c99	dcd00c11302e3b16333943340d6b4a6b
3ccca65d3d9843b81f4e251dcf8a3e8c	4cfbb125e9878528bab91d12421134d8
3ccca65d3d9843b81f4e251dcf8a3e8c	0ae61bd0474e04c9f1195d4baa0213a0
3ccca65d3d9843b81f4e251dcf8a3e8c	9a284efda4d46636bd9d5298dfea1335
9144b4f0da4c96565c47c38f0bc16593	da832711951e70811ef7533835637961
8b3d594047e4544f608c2ebb151aeb45	a29864963573d7bb061691ff823b97dd
ca03a570b4d4a22329359dc105a9ef22	a29864963573d7bb061691ff823b97dd
e83655f0458b6c309866fbde556be35a	a29864963573d7bb061691ff823b97dd
f5eaa9c89bd215868235b0c068050883	a68d5b72c2f98613f511337a59312f78
dcd3968ac5b1ab25328f4ed42cdf2e2b	a29864963573d7bb061691ff823b97dd
dcd3968ac5b1ab25328f4ed42cdf2e2b	17b8dff9566f6c98062ad5811c762f44
6e25aa27fcd893613fac13b0312fe36d	a29864963573d7bb061691ff823b97dd
6e25aa27fcd893613fac13b0312fe36d	17b8dff9566f6c98062ad5811c762f44
63e961dd2daa48ed1dade27a54f03ec4	17b8dff9566f6c98062ad5811c762f44
9f10d335198e90990f3437c5733468e7	17b8dff9566f6c98062ad5811c762f44
9f10d335198e90990f3437c5733468e7	885ba57d521cd859bacf6f76fb37ef7c
9f10d335198e90990f3437c5733468e7	0cf6ece7453aa814e08cb7c33bd39846
9f10d335198e90990f3437c5733468e7	9c093ec7867ba1df61e27a5943168b90
4cc6d79ef4cf3af13b6c9b77783e688b	01864d382accf1cdb077e42032b16340
4cc6d79ef4cf3af13b6c9b77783e688b	7a3808eef413b514776a7202fd2cb94f
da34d04ff19376defc2facc252e52cf0	7fa69773873856d74f68a6824ca4b691
eaf446aca5ddd602d0ab194667e7bec1	a68d5b72c2f98613f511337a59312f78
b34f0dad8c934ee71aaabb2a675f9822	885ba57d521cd859bacf6f76fb37ef7c
b34f0dad8c934ee71aaabb2a675f9822	17b8dff9566f6c98062ad5811c762f44
b34f0dad8c934ee71aaabb2a675f9822	1c800aa97116d9afd83204d65d50199a
c6458620084029f07681a55746ee4d69	a68d5b72c2f98613f511337a59312f78
c6458620084029f07681a55746ee4d69	a29864963573d7bb061691ff823b97dd
ee325100d772dd075010b61b6f33c82a	17b8dff9566f6c98062ad5811c762f44
950d43371e8291185e524550ad3fd0df	ea9565886c02dbdc4892412537e607d7
950d43371e8291185e524550ad3fd0df	17b8dff9566f6c98062ad5811c762f44
950d43371e8291185e524550ad3fd0df	10a17b42501166d3bf8fbdff7e1d52b6
2aa7757363ff360f3a08283c1d157b2c	17b8dff9566f6c98062ad5811c762f44
d71218f2abfdd51d95ba7995b93bd536	a68d5b72c2f98613f511337a59312f78
186aab3d817bd38f76c754001b0ab04d	585f02a68092351a078fc43a21a56564
186aab3d817bd38f76c754001b0ab04d	a29864963573d7bb061691ff823b97dd
12c0763f59f7697824567a3ca32191db	deb8040131c3f6a3caf6a616b34ac482
4e14f71c5702f5f71ad7de50587e2409	a279b219de7726798fc2497d48bc0402
4e14f71c5702f5f71ad7de50587e2409	d5a9c37bc91d6d5d55a3c2e38c3bf97d
4e14f71c5702f5f71ad7de50587e2409	a29864963573d7bb061691ff823b97dd
8f7d02638c253eb2d03118800c623203	2df929d9b6150c082888b66e8129ee3f
d2ec9ebbccaa3c6925b86d1bd528d12f	17b8dff9566f6c98062ad5811c762f44
2cca468dcaea0a807f756b1de2b3ec7b	a68d5b72c2f98613f511337a59312f78
2cca468dcaea0a807f756b1de2b3ec7b	17b8dff9566f6c98062ad5811c762f44
c8c012313f10e2d0830f3fbc5afca619	a68d5b72c2f98613f511337a59312f78
c8c012313f10e2d0830f3fbc5afca619	585f02a68092351a078fc43a21a56564
cf3ecbdc9b5ae9c5a87ab05403691350	a68d5b72c2f98613f511337a59312f78
cf3ecbdc9b5ae9c5a87ab05403691350	17b8dff9566f6c98062ad5811c762f44
9323fc63b40460bcb68a7ad9840bad5a	17b8dff9566f6c98062ad5811c762f44
9323fc63b40460bcb68a7ad9840bad5a	a29864963573d7bb061691ff823b97dd
6429807f6febbf061ac85089a8c3173d	17b8dff9566f6c98062ad5811c762f44
7b959644258e567b32d7c38e21fdb6fa	a68d5b72c2f98613f511337a59312f78
b08c5a0f666c5f8a83a7bcafe51ec49b	a68d5b72c2f98613f511337a59312f78
eb626abaffa54be81830da1b29a3f1d8	17b8dff9566f6c98062ad5811c762f44
dd663d37df2cb0b5e222614dd720f6d3	a68d5b72c2f98613f511337a59312f78
71aabfaa43d427516f4020c7178de31c	a29864963573d7bb061691ff823b97dd
71aabfaa43d427516f4020c7178de31c	01864d382accf1cdb077e42032b16340
32f27ae0d5337bb62c636e3f6f17b0ff	a68d5b72c2f98613f511337a59312f78
d9a6c1fcbafa92784f501ca419fe4090	276dd0e596bbc541942c8cd9cc2004e0
d9a6c1fcbafa92784f501ca419fe4090	a68d5b72c2f98613f511337a59312f78
afd755c6a62ac0a0947a39c4f2cd2c20	17b8dff9566f6c98062ad5811c762f44
afd755c6a62ac0a0947a39c4f2cd2c20	caac3244eefed8cffee878acae427e28
b69b0e9285e4fa15470b0969836ac5ae	a68d5b72c2f98613f511337a59312f78
79d924bae828df8e676ba27e5dfc5f42	04ae76937270105919847d05aee582b4
79d924bae828df8e676ba27e5dfc5f42	585f02a68092351a078fc43a21a56564
fe1f86f611c34fba898e4c90b71ec981	17b8dff9566f6c98062ad5811c762f44
92e67ef6f0f8c77b1dd631bd3b37ebca	17b8dff9566f6c98062ad5811c762f44
b5d1848944ce92433b626211ed9e46f8	17b8dff9566f6c98062ad5811c762f44
62165afb63fc004e619dff4d2132517c	17b8dff9566f6c98062ad5811c762f44
62165afb63fc004e619dff4d2132517c	8b7bdc272dd85d5058f8fbaa14e66002
84557a1d9eb96a680c0557724e1d0532	17b8dff9566f6c98062ad5811c762f44
84557a1d9eb96a680c0557724e1d0532	a29864963573d7bb061691ff823b97dd
ead662696e0486cb7a478ecd13a0b5c5	7fa69773873856d74f68a6824ca4b691
ead662696e0486cb7a478ecd13a0b5c5	10a17b42501166d3bf8fbdff7e1d52b6
8c22a88267727dd513bf8ca278661e4d	17b8dff9566f6c98062ad5811c762f44
541455f74d6f393174ff14b99e01b22d	fd00614e73cb66fd71ab13c970a074d8
90bebabe0c80676a4f6207ee0f8caa4c	1e612d6c48bc9652afeb616536fced51
ee8cde73a364c2b066f795edda1a303a	4cfbb125e9878528bab91d12421134d8
92e25f3ba88109b777bd65b3b3de28a9	17b8dff9566f6c98062ad5811c762f44
92e25f3ba88109b777bd65b3b3de28a9	a68d5b72c2f98613f511337a59312f78
3e3b4203ce868f55b084eb4f2da535d3	7fa69773873856d74f68a6824ca4b691
88ae6d397912fe633198a78a3b10f82e	caac3244eefed8cffee878acae427e28
d2ec80fcff98ecb676da474dfcb5fe5c	deb8040131c3f6a3caf6a616b34ac482
e31fabfff3891257949efc248dfa97e2	7fa69773873856d74f68a6824ca4b691
e31fabfff3891257949efc248dfa97e2	01864d382accf1cdb077e42032b16340
4f6ae7ce964e64fdc143602aaaab1c26	7fa69773873856d74f68a6824ca4b691
fe1fbc7d376820477e38b5fa497e4509	17b8dff9566f6c98062ad5811c762f44
fe1fbc7d376820477e38b5fa497e4509	10a17b42501166d3bf8fbdff7e1d52b6
fe1fbc7d376820477e38b5fa497e4509	01864d382accf1cdb077e42032b16340
fe1fbc7d376820477e38b5fa497e4509	7fa69773873856d74f68a6824ca4b691
b4087680a00055c7b9551c6a1ef50816	caac3244eefed8cffee878acae427e28
986a4f4e41790e819dc8b2a297aa8c87	82f71c08ea9ddc4fa9dfb06236a45ba1
e318f5bc96fd248b69f6a969a320769e	6e8e259537338c1ffacf0df56249227a
e318f5bc96fd248b69f6a969a320769e	7fa69773873856d74f68a6824ca4b691
56525146be490541a00c20a1dab0a465	7fa69773873856d74f68a6824ca4b691
56525146be490541a00c20a1dab0a465	10a17b42501166d3bf8fbdff7e1d52b6
2f39cfcedf45336beb2e966e80b93e22	6e8e259537338c1ffacf0df56249227a
2f39cfcedf45336beb2e966e80b93e22	7fa69773873856d74f68a6824ca4b691
51053ffab2737bd21724ed0b7e6c56f7	caac3244eefed8cffee878acae427e28
51053ffab2737bd21724ed0b7e6c56f7	1c800aa97116d9afd83204d65d50199a
51053ffab2737bd21724ed0b7e6c56f7	7fa69773873856d74f68a6824ca4b691
869d4f93046289e11b591fc7a740bc43	7fa69773873856d74f68a6824ca4b691
5b3c70181a572c8d92d906ca20298d93	caac3244eefed8cffee878acae427e28
be3c26bf034e9e62057314f3945f87be	a14c7f19780155d998b8c0d48c4f2f61
be3c26bf034e9e62057314f3945f87be	17b8dff9566f6c98062ad5811c762f44
37b93f83b5fe94e766346ef212283282	6e8e259537338c1ffacf0df56249227a
37b93f83b5fe94e766346ef212283282	7fa69773873856d74f68a6824ca4b691
dbde8de43043d69c4fdd3e50a72b859d	6e8e259537338c1ffacf0df56249227a
dbde8de43043d69c4fdd3e50a72b859d	7fa69773873856d74f68a6824ca4b691
dbde8de43043d69c4fdd3e50a72b859d	deb8040131c3f6a3caf6a616b34ac482
0f512371d62ae34741d14dde50ab4529	deb8040131c3f6a3caf6a616b34ac482
fd1bd629160356260c497da84df860e2	7fa69773873856d74f68a6824ca4b691
3dba6c9259786defe62551e38665a94a	7fa69773873856d74f68a6824ca4b691
9d969d25c9f506c5518bb090ad5f8266	6e8e259537338c1ffacf0df56249227a
9d969d25c9f506c5518bb090ad5f8266	7fa69773873856d74f68a6824ca4b691
34d29649cb20a10a5e6b59c531077a59	6e8e259537338c1ffacf0df56249227a
34d29649cb20a10a5e6b59c531077a59	7fa69773873856d74f68a6824ca4b691
c02f12329daf99e6297001ef684d6285	10a17b42501166d3bf8fbdff7e1d52b6
f64162c264d5679d130b6e8ae84d704e	01864d382accf1cdb077e42032b16340
f64162c264d5679d130b6e8ae84d704e	262770cfc76233c4f0d7a1e43a36cbf7
0674a20e29104e21d141843a86421323	17b8dff9566f6c98062ad5811c762f44
24dd5b3de900b9ee06f913a550beb64c	a68d5b72c2f98613f511337a59312f78
fe7838d63434580c47798cbc5c2c8c63	a68d5b72c2f98613f511337a59312f78
e47c5fcf4a752dfcfbccaab5988193ef	17b8dff9566f6c98062ad5811c762f44
e47c5fcf4a752dfcfbccaab5988193ef	a29864963573d7bb061691ff823b97dd
e47c5fcf4a752dfcfbccaab5988193ef	93cce11930403f5b3ce8938a2bde5efa
3d482a4abe7d814a741b06cb6306d598	262770cfc76233c4f0d7a1e43a36cbf7
3d482a4abe7d814a741b06cb6306d598	89089c3efdb2f18179df6d476e5759de
3d482a4abe7d814a741b06cb6306d598	01864d382accf1cdb077e42032b16340
856256d0fddf6bfd898ef43777a80f0c	01864d382accf1cdb077e42032b16340
b5bc9b34286d4d4943fc301fe9b46e46	a68d5b72c2f98613f511337a59312f78
589a30eb4a7274605385d3414ae82aaa	01864d382accf1cdb077e42032b16340
d79d3a518bd9912fb38fa2ef71c39750	7a3808eef413b514776a7202fd2cb94f
5ff09619b7364339a105a1cbcb8d65fd	17b8dff9566f6c98062ad5811c762f44
5ff09619b7364339a105a1cbcb8d65fd	a29864963573d7bb061691ff823b97dd
5ff09619b7364339a105a1cbcb8d65fd	01864d382accf1cdb077e42032b16340
2eb6fb05d553b296096973cb97912cc0	04ae76937270105919847d05aee582b4
e163173b9350642f7c855bf37c144ce0	aca2a3c07f76ae685ae818b312e025c5
e163173b9350642f7c855bf37c144ce0	39d9d9f9143880553c5e2da25c87f33d
e163173b9350642f7c855bf37c144ce0	59716c97497eb9694541f7c3d37b1a4d
e163173b9350642f7c855bf37c144ce0	273112316e7fab5a848516666e3a57d1
e163173b9350642f7c855bf37c144ce0	ead7038498db3f93ac79d28407a6d47c
e163173b9350642f7c855bf37c144ce0	cd841371c5cd35c94bb823be9f53cf2f
50681f5168e67b62daa1837d8f693001	9a284efda4d46636bd9d5298dfea1335
50681f5168e67b62daa1837d8f693001	0cb6959de39db97ee5fad81faa008d8f
50681f5168e67b62daa1837d8f693001	6add228b14f132e14ae9da754ef070c5
69af98a8916998443129c057ee04aec4	a68d5b72c2f98613f511337a59312f78
69af98a8916998443129c057ee04aec4	17b8dff9566f6c98062ad5811c762f44
57338bd22a6c5ba32f90981ffb25ef23	17b8dff9566f6c98062ad5811c762f44
48aeffb54173796a88ef8c4eb06dbf10	a29864963573d7bb061691ff823b97dd
48aeffb54173796a88ef8c4eb06dbf10	17b8dff9566f6c98062ad5811c762f44
ada3962af4845c243fcd1ccafc815b09	04ae76937270105919847d05aee582b4
07759c4afc493965a5420e03bdc9b773	17b8dff9566f6c98062ad5811c762f44
8989ab42027d29679d1dedc518eb04bd	f0095594f17b3793be8291117582f96b
8989ab42027d29679d1dedc518eb04bd	7a3808eef413b514776a7202fd2cb94f
54f89c837a689f7f27667efb92e3e6b1	01864d382accf1cdb077e42032b16340
266674d0a44a3a0102ab80021ddfd451	7a3808eef413b514776a7202fd2cb94f
266674d0a44a3a0102ab80021ddfd451	01864d382accf1cdb077e42032b16340
50e7b1ba464091976138ec6a57b08ba0	04ae76937270105919847d05aee582b4
a51211ef8cbbf7b49bfb27c099c30ce1	01864d382accf1cdb077e42032b16340
0dc9cb94cdd3a9e89383d344a103ed5b	17b8dff9566f6c98062ad5811c762f44
c45ca1e791f2849d9d11b3948fdefb74	d5a9c37bc91d6d5d55a3c2e38c3bf97d
c45ca1e791f2849d9d11b3948fdefb74	a29864963573d7bb061691ff823b97dd
c45ca1e791f2849d9d11b3948fdefb74	2e607ef3a19cf3de029e2c5882896d33
c45ca1e791f2849d9d11b3948fdefb74	bb273189d856ee630d92fbc0274178bb
edb40909b64e73b547843287929818de	7fa69773873856d74f68a6824ca4b691
897edb97d775897f69fa168a88b01c19	caac3244eefed8cffee878acae427e28
b05f3966288598b02cda4a41d6d1eb6b	7fa69773873856d74f68a6824ca4b691
c7d1a2a30826683fd366e7fd6527e79c	1868ffbe3756a1c3f58300f45aa5e1d3
6ff4735b0fc4160e081440b3f7238925	17b8dff9566f6c98062ad5811c762f44
100691b7539d5ae455b6f4a18394420c	17b8dff9566f6c98062ad5811c762f44
d5282bd6b63b4cd51b50b40d192f1161	a48199bd07eec68b1214594af75d7eb3
d5282bd6b63b4cd51b50b40d192f1161	aca2a3c07f76ae685ae818b312e025c5
d5282bd6b63b4cd51b50b40d192f1161	08cbc2781f56d15c2c374824c7428a8c
d5282bd6b63b4cd51b50b40d192f1161	0077c87e06d736b19d6b3978f5e5e6e2
d5282bd6b63b4cd51b50b40d192f1161	2a78330cc0de19f12ae9c7de65b9d5d5
5159fd46698ae21d56f1684c2041bd79	ff7aa8ca226e1b753b0a71d7f0f2e174
5159fd46698ae21d56f1684c2041bd79	7a3808eef413b514776a7202fd2cb94f
5159fd46698ae21d56f1684c2041bd79	f41da0c65a8fa3690e6a6877e7112afb
c63ecd19a0ca74c22dfcf3063c9805d2	01864d382accf1cdb077e42032b16340
e08f00b43f7aa539eb60cfa149afd92e	17b8dff9566f6c98062ad5811c762f44
793955e5d62f9b22bae3b59463c9ef63	01864d382accf1cdb077e42032b16340
e4f2a1b2efa9caa67e58fa9610903ef0	a68d5b72c2f98613f511337a59312f78
57f003f2f413eedf53362b020f467be4	a29864963573d7bb061691ff823b97dd
57f003f2f413eedf53362b020f467be4	585f02a68092351a078fc43a21a56564
5ef6a0f70220936a0158ad66fd5d9082	17b8dff9566f6c98062ad5811c762f44
25ebb3d62ad1160c96bbdea951ad2f34	a29864963573d7bb061691ff823b97dd
d97a4c5c71013baac562c2b5126909e1	ef5131009b7ced0b35ea49c8c7690cef
d97a4c5c71013baac562c2b5126909e1	5fa721b23d1df57306a710b77d7897d6
1ebe59bfb566a19bc3ce5f4fb6c79cd3	dcd00c11302e3b16333943340d6b4a6b
1ebe59bfb566a19bc3ce5f4fb6c79cd3	84caaa55a818fdacc56b1a78e3059e3b
5f572d201a24500b2db6eca489a6a620	de62af4f3af4adf9e8c8791071ddafe3
5f572d201a24500b2db6eca489a6a620	0cf6ece7453aa814e08cb7c33bd39846
ac6dc9583812a034be2f5aacbf439236	2df929d9b6150c082888b66e8129ee3f
7f499363c322c1243827700c67a7591c	7a3808eef413b514776a7202fd2cb94f
7f499363c322c1243827700c67a7591c	caac3244eefed8cffee878acae427e28
2040754b0f9589a89ce88912bcf0648e	7a3808eef413b514776a7202fd2cb94f
13cd421d8a1cb48800543b9317aa2f52	01864d382accf1cdb077e42032b16340
5c1a922f41003eb7a19b570c33b99ff4	86990837f323dde52a011a1f2d1eca0d
4b9f3b159347c34232c9f4b220cb22de	2df929d9b6150c082888b66e8129ee3f
81a17f1bf76469b18fbe410d8ec77da8	819de896b7c481c2b870bcf4ca7965fc
81a86312a4aa3660f273d6ed5e4a6c7d	4c4f4d32429ac8424cb110b4117036e4
15137b95180ccc986f6321acffb9cb6f	7fa69773873856d74f68a6824ca4b691
546f8a4844ac636dd18025dcc673a3ab	caac3244eefed8cffee878acae427e28
20d32d36893828d060096b2cd149820b	7a3808eef413b514776a7202fd2cb94f
20d32d36893828d060096b2cd149820b	caac3244eefed8cffee878acae427e28
692649c1372f37ed50339b91337e7fec	17b8dff9566f6c98062ad5811c762f44
692649c1372f37ed50339b91337e7fec	a29864963573d7bb061691ff823b97dd
692649c1372f37ed50339b91337e7fec	d5a9c37bc91d6d5d55a3c2e38c3bf97d
0646225016fba179076d7df56260d1b2	e8376ca6a0ac30b2ad0d64de6061adab
0646225016fba179076d7df56260d1b2	a68d5b72c2f98613f511337a59312f78
ce5e821f2dcc57569eae793f628c99cf	262770cfc76233c4f0d7a1e43a36cbf7
ce5e821f2dcc57569eae793f628c99cf	17b8dff9566f6c98062ad5811c762f44
cd11b262d721d8b3f35ad2d2af8431dd	17b8dff9566f6c98062ad5811c762f44
15cee64305c1b40a4fac10c26ffa227d	17b8dff9566f6c98062ad5811c762f44
3771bd5f354df475660a24613fcb7a8c	c7d1df50d4cb1e00b5b5b3a34a493b90
f43bb3f980f58c66fc81874924043946	cb6ef856481bc776bba38fbf15b8b3fb
f43bb3f980f58c66fc81874924043946	8c42e2739ed83a54e5b2781b504c92de
069cdf9184e271a3c6d45ad7e86fcac2	17b8dff9566f6c98062ad5811c762f44
069cdf9184e271a3c6d45ad7e86fcac2	a29864963573d7bb061691ff823b97dd
e9782409a3511c3535149cdfb5b76364	e22aa8f4c79b6c4bbeb6bcc7f4e1eb26
e9782409a3511c3535149cdfb5b76364	7fa69773873856d74f68a6824ca4b691
49f6021766f78bffb3f824eb199acfbc	17b8dff9566f6c98062ad5811c762f44
49f6021766f78bffb3f824eb199acfbc	a68d5b72c2f98613f511337a59312f78
f04de6fafc611682779eb2eb36bdbe25	4cfbb125e9878528bab91d12421134d8
f04de6fafc611682779eb2eb36bdbe25	eaa57a9b4248ce3968e718895e1c2f04
f7c31a68856cab2620244be2df27c728	02c4d46b0568d199466ef1baa339adc8
ae2056f2540325e2de91f64f5ac130b6	1c800aa97116d9afd83204d65d50199a
ae2056f2540325e2de91f64f5ac130b6	4c4f4d32429ac8424cb110b4117036e4
eced087124a41417845c0b0f4ff44ba9	51a0accd339e27727689fc781c4df015
eced087124a41417845c0b0f4ff44ba9	5bf88dc6f6501943cc5bc4c42c71b36b
edaf03c0c66aa548df3cebdae0f94545	a68d5b72c2f98613f511337a59312f78
9abdb4a0588186fc4425b29080e820a2	4cfbb125e9878528bab91d12421134d8
16cbdd4df5f89d771dccfa1111d7f4bc	2d1930ea91c39cb44ce654c634bd5113
06a4594d3b323539e9dc4820625d01b8	4cfbb125e9878528bab91d12421134d8
b5c7675d6faefd09e871a6c1157e9353	4cfbb125e9878528bab91d12421134d8
b5c7675d6faefd09e871a6c1157e9353	0ae61bd0474e04c9f1195d4baa0213a0
1683f5557c9db93b35d1d2ae450baa21	a68d5b72c2f98613f511337a59312f78
1683f5557c9db93b35d1d2ae450baa21	585f02a68092351a078fc43a21a56564
1683f5557c9db93b35d1d2ae450baa21	a29864963573d7bb061691ff823b97dd
ae653e4f46c5928cc4b4b171efbcf881	a68d5b72c2f98613f511337a59312f78
df8457281db2cba8bbcb4b3b80f2b9a3	04ae76937270105919847d05aee582b4
f85df6e18a73a6d1f5ccb59ee51558ae	4fb2ada7c5440a256ed0e03c967fce74
0308321fc4f75ddaed8208c24f2cb918	7fa69773873856d74f68a6824ca4b691
4ceb1f68d8a260c644c25799629a5615	17b8dff9566f6c98062ad5811c762f44
7acb475eda543ccd0622d546c5772c5a	e22aa8f4c79b6c4bbeb6bcc7f4e1eb26
7acb475eda543ccd0622d546c5772c5a	7fa69773873856d74f68a6824ca4b691
ba8d3efe842e0755020a2f1bc5533585	04ae76937270105919847d05aee582b4
5a154476dd67358f4dab8500076dece3	a29864963573d7bb061691ff823b97dd
5a154476dd67358f4dab8500076dece3	17b8dff9566f6c98062ad5811c762f44
b8e18040dc07eead8e6741733653a740	c56931e6d30371f655de27ecbf6c50f0
0bc244b6aa99080c3d37fea06d328193	9a9f894a69bab7649b304cb577a96566
b46e412d7f90e277a1b9370cfeb26abe	6add228b14f132e14ae9da754ef070c5
49920f80faa980ca10fea8f31ddd5fc9	4cfbb125e9878528bab91d12421134d8
fddfe79923a5373a44237e0e60f5c845	2a78330cc0de19f12ae9c7de65b9d5d5
fddfe79923a5373a44237e0e60f5c845	5f05cefd0f6a07508d21a1d2be16d9c7
277ce66a47017ca1ce55714d5d2232b2	04ae76937270105919847d05aee582b4
2ad8a3ceb96c6bf74695f896999019d8	262770cfc76233c4f0d7a1e43a36cbf7
fc4734cc48ce1595c9dbbe806f663af8	caac3244eefed8cffee878acae427e28
567ddbaeec9bc3c5f0348a21ebd914b1	bb273189d856ee630d92fbc0274178bb
25cde5325befa9538b771717514351fb	a29864963573d7bb061691ff823b97dd
25cde5325befa9538b771717514351fb	04ae76937270105919847d05aee582b4
cf2676445aa6abcc43a4b0d4b01b42a1	585f02a68092351a078fc43a21a56564
3005cc8298f189f94923611386015c78	4fb2ada7c5440a256ed0e03c967fce74
3005cc8298f189f94923611386015c78	585f02a68092351a078fc43a21a56564
7f2679aa5b1116cc22bab4ee10018f59	a68d5b72c2f98613f511337a59312f78
7f2679aa5b1116cc22bab4ee10018f59	585f02a68092351a078fc43a21a56564
8a1acf425fb1bca48fb543edcc20a90d	4fb2ada7c5440a256ed0e03c967fce74
8a1acf425fb1bca48fb543edcc20a90d	04ae76937270105919847d05aee582b4
8a1acf425fb1bca48fb543edcc20a90d	585f02a68092351a078fc43a21a56564
c2d7bbc06d62144545c45b9060b0a629	d5750853c14498dc264065bcf7e05a29
62254b7ab0a2b3d3138bde893dde64a3	a29864963573d7bb061691ff823b97dd
62254b7ab0a2b3d3138bde893dde64a3	585f02a68092351a078fc43a21a56564
f291caafeb623728ebf0166ac4cb0825	5bf88dc6f6501943cc5bc4c42c71b36b
1a46202030819f7419e300997199c955	a29864963573d7bb061691ff823b97dd
1f94ea2f8cb55dd130ec2254c7c2238c	07b91b89a1fd5e90b9035bf112a3e6e5
8d788b28d613c227ea3c87ac898a8256	8c42e2739ed83a54e5b2781b504c92de
5226c9e67aff4f963aea67c95cd5f3f0	01864d382accf1cdb077e42032b16340
5226c9e67aff4f963aea67c95cd5f3f0	4fb2ada7c5440a256ed0e03c967fce74
e58ecda1a7b9bfdff6a10d398f468c3f	a68d5b72c2f98613f511337a59312f78
e58ecda1a7b9bfdff6a10d398f468c3f	262770cfc76233c4f0d7a1e43a36cbf7
e58ecda1a7b9bfdff6a10d398f468c3f	01864d382accf1cdb077e42032b16340
183bea99848e19bdb720ba5774d216ba	a68d5b72c2f98613f511337a59312f78
495ddc6ae449bf858afe5512d28563f5	a68d5b72c2f98613f511337a59312f78
3b0b94c18b8d65aec3a8ca7f4dae720d	a68d5b72c2f98613f511337a59312f78
3b0b94c18b8d65aec3a8ca7f4dae720d	f829960b3a62def55e90a3054491ead7
3b0b94c18b8d65aec3a8ca7f4dae720d	d4fe504b565a2bcbec1bb4c56445e857
b2b4ae56a4531455e275770dc577b68e	a68d5b72c2f98613f511337a59312f78
b2b4ae56a4531455e275770dc577b68e	a29864963573d7bb061691ff823b97dd
f9d5d4c7b26c7b832ee503b767d5df52	a68d5b72c2f98613f511337a59312f78
f9d5d4c7b26c7b832ee503b767d5df52	17b8dff9566f6c98062ad5811c762f44
f291caafeb623728ebf0166ac4cb0825	7a09fdabda255b02b2283e724071944b
f9d5d4c7b26c7b832ee503b767d5df52	a29864963573d7bb061691ff823b97dd
f9030edd3045787fcbcfd47da5246596	17b8dff9566f6c98062ad5811c762f44
5d56713e4586c9b1920eb1a3d4597564	17b8dff9566f6c98062ad5811c762f44
215513a2c867f8b24d5aea58c9abfff6	2df929d9b6150c082888b66e8129ee3f
215513a2c867f8b24d5aea58c9abfff6	caac3244eefed8cffee878acae427e28
1ca632ac231052e4116239ccb8952dfe	7fa69773873856d74f68a6824ca4b691
62a40f6fa589c7007ded80d26ad1c3a9	caac3244eefed8cffee878acae427e28
62a40f6fa589c7007ded80d26ad1c3a9	fd00614e73cb66fd71ab13c970a074d8
62a40f6fa589c7007ded80d26ad1c3a9	2df929d9b6150c082888b66e8129ee3f
7d9488e60660507d0f88850245ddc7a5	caac3244eefed8cffee878acae427e28
7d9488e60660507d0f88850245ddc7a5	7fa69773873856d74f68a6824ca4b691
abb4decfc5a094f45911b94337e7e2c4	caac3244eefed8cffee878acae427e28
e061c04af9609876757f0b33d14c63e5	178c690e12310890294b6fefeb0c2442
ade72e999b4e78925b18cf48d1faafa4	f008a5f1cb81bcfa397f7c1987f2bf55
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.events (id_event, event, date_event, id_place, duration, price, persons) FROM stdin;
b1e4aa22275a6a4b3213b44fc342f9fe	Sepultura - Quadra Summer Tour - Europe 2022	2022-07-05	6d998a5f2c8b461a654f7f9e34ab4368	0	37.31	2
f10fa26efffb6c69534e7b0f7890272d	Rockfield Open Air 2018	2018-08-17	55ff4adc7d421cf9e05b68d25ee22341	2	0.00	2
5e651777820428286fde01ffe87cb4b7	Gutcity Deathfest 2024	2024-05-11	ca838f25ade35ddc0337a6f0ea710f4b	0	30.60	2
9e829f734a90920dd15d3b93134ee270	EMP Persistence Tour 2016	2016-01-22	427a371fadd4cce654dd30c27a36acb0	0	31.20	2
52b133bfecec2fba79ecf451de3cf3bb	Völkerball	2016-05-05	657d564cc1dbaf58e2f2135b57d02d99	0	23.50	2
8307a775d42c5bfbaab36501bf6a3f6c	Noche de los Muertos - 2017	2017-10-31	c5159d0425e9c5737c8884eb38d70dd9	0	15	2
45dbcc9d20cd0f431b1f4774cd0a0bf3	"The Tide of Death and fractured Dreams" European Tour 2024	2024-05-15	427a371fadd4cce654dd30c27a36acb0	0	36.0	2
cf8e56fdc88304e772838b2a47d8c23b	Thrash Metal Fest - 05.2024	2024-05-16	0b186d7eb0143e60ced4af3380f5faa8	0	30.0	2
ea99873fab477c85c634eec0fe139eaf	Open air Hamm 43.	2013-06-14	ea72b9f0db73025c8aaedae0f7b874f8	1	22.0	1
1f1a45b3cca4a65dae6fad7aa6cac17e	Open air Hamm 45.	2015-06-12	ea72b9f0db73025c8aaedae0f7b874f8	1	22.0	1
5c22297e2817e4a0c9ee608a67bcf297	Open air Hamm 47.	2017-07-07	ea72b9f0db73025c8aaedae0f7b874f8	1	25	2
ae89cc8a42502f057aa1d7cbdf5105a8	Profanation over Europe 2024	2024-03-20	427a371fadd4cce654dd30c27a36acb0	0	29.20	2
e3e419c6d94bb9333e21fbfa231367a0	Tribute Bathory mit	2024-03-23	8bb89006a86a427f89e49efe7f1635c1	0	15	2
fd4a13ab709b0975de3c7528ca3aab0e	Necromanteum EU/UK Tour 2024	2024-03-30	89c0549ca41bb77ccdf081193ca1e45f	0	43.55	2
573a39e7d69678efec23ba7a9e99f0f5	Taunus Metal Festival XIV	2024-04-05	1e9e26a0456c1694d069e119dae54240	0	30.00	2
b8fabad72c3fd0540815a6cd8d126a14	Thrash Attack - 06.04.2024	2024-04-06	6db34279cf6070892349b478135302e7	0	16.52	2
1d8cf922eebeba04d4aa27b8b5e412c3	Agrypnie 20 Jahre Jubiläums Set & Horresque Album Release Show	2024-04-12	446c20c5e383ff30350166d5ab741efb	0	22.0	2
31b7b744437a5b46fb982fcdf1b94851	Super Sweet 16 (Edition 36)	2024-04-20	14b82c93c42422209e5b5aad5b7b772e	0	0	2
2c6a917b013e933d5ef1aa0a6216e575	Fintroll + Metsatöll + Suotana Tour 2024	2024-04-22	c6e9ff60da2342ba2a0ce4d9b6fc6ff1	0	34.00	2
fd5ccee80a5d5a1a16944aefe2b840c5	Celebrating the music of Jimi Hendrix	2024-05-01	0b186d7eb0143e60ced4af3380f5faa8	0	24.20	2
73d6ec35ad0e4ef8f213ba89d8bfd7d7	New live rituals a COVID proof celebration of audial darkness	2021-07-23	6d488d592421aa8391ff259ef1c8b744	0	23.20	2
18ef7142c02d84033cc9d41687981691	Ravaging Europe 2023	2023-03-29	6d488d592421aa8391ff259ef1c8b744	0	28.70	2
220f8c4b62141ad5acd8b11d4d0f2bd3	Heretic Hordes I	2024-05-03	6d488d592421aa8391ff259ef1c8b744	0	35.00	2
6bc91856db67c4e90b455638fa43e0bd	Shades of Sorrow European Tour 2024	2024-05-04	0b186d7eb0143e60ced4af3380f5faa8	0	27.30	2
3eda085ef6acc8b084dda9440115af56	Back to the Roots Tour - 05.2024	2024-05-17	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	23.20	2
ac4ad77eed8faf4ef8d91fb1df7fe196	Fleshcrawl + Fleshsphere + Torment of Souls	2024-05-18	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	28.70	2
02ce1b3a6156c9f73724ea3efabde2e8	Angelus Apatrida - Tour 2022	2022-07-28	0b186d7eb0143e60ced4af3380f5faa8	0	16.50	2
c9a70f42ce4dcd82a99ed83a5117b890	Where Owls know my name EU|UK Tour 2019	2019-09-22	427a371fadd4cce654dd30c27a36acb0	0	24.70	2
d5cd210a82be3dd1a7879b83ba5657c0	15 Years New Evil Music, Festival	2019-10-12	4751a5b2d9992dca6e462e3b14695284	0	44.0	2
f853b43cbe11fe4cdef7009f0f98d4f2	Hate, Keep of Kalessin	2024-05-02	0b186d7eb0143e60ced4af3380f5faa8	0	25.30	2
372ca4be7841a47ba693d4de7d220981	NOAF XIII	2017-08-25	bb1bac023b4f02a5507f1047970d1aca	1	38.00	2
42c7a1c1e7836f74ced153a27d98cef0	Matapaloz Festival 2017	2017-06-16	d379f693135eefa77bc9732f97fcaaf1	1	170.99	2
8df16d3b3a2ca21ba921c310aadb7803	Night on the Living Thrash Tour 2023	2023-11-09	c6e9ff60da2342ba2a0ce4d9b6fc6ff1	0	39.50	2
dedb3aef6ecd0d48a7e7a41d8545a2d9	Slaugther Feast 2023	2023-11-10	94707aea9e845e5e0ec91cd63f5982d6	1	29.00	2
cc0c4b3208cad5143bf8aec2c74ac9df	Slice Me Nice 2023	2023-12-02	e5fe851ccb28deccc27178ac003727e2	0	33.91	2
5e65cc6b7435c63dac4b2baf17ab5838	Grill' Em All 2017	2017-09-23	29ae00a7e41558eb2ed8c0995a702d7a	0	0.00	2
fcbfd4ea93701414772acad10ad93a5f	Völkerball in Mainz	2018-07-27	19a1767aab9e93163ad90f2dfe82ec71	0	0.00	2
d8f74ab86e77455ffbd398065ee109a8	Slamming Annihilation European Tour 2018	2018-05-21	0b186d7eb0143e60ced4af3380f5faa8	0	18.00	2
3af7c6d148d216f13f66669acb8d5c59	Debauchery's Balgeroth	2018-11-03	0b186d7eb0143e60ced4af3380f5faa8	0	18.00	2
e471494f42d963b13f025c0636c43763	Knife, Exorcised Gods, World of Tomorrow, When Plages Collide	2018-09-15	d1ad016a5b257743ef75594c67c52935	0	7.60	2
f68790d8b2f82aad75f0c27be554ee48	The Path of Death 7	2018-10-20	620f9da22d73cc8d5680539a4c87402b	0	15.00	2
084c45f4c0bf86930df25ae1c59b3fe6	The Path of Death 6	2017-10-14	620f9da22d73cc8d5680539a4c87402b	0	14.00	2
f8ead2514f0df3c6e8ec84b992dd6e44	Hell over Europe II	2018-11-24	0b186d7eb0143e60ced4af3380f5faa8	0	24.00	2
9afc751ca7f2d91d23c453b32fd21864	The modern art of setting ablaze tour	2018-12-08	427a371fadd4cce654dd30c27a36acb0	0	23.20	2
85c434b11120b4ba2f116e89843a594e	Heidelberg Deathfest III	2018-03-24	828d35ecd5412f7bc1ba369d5d657f9f	0	35.00	2
e872b77ff7ac24acc5fa373ebe9bb492	Molotov	2016-07-25	427a371fadd4cce654dd30c27a36acb0	0	24.50	2
1fad423d9d1f48b7bd6d31c8d5cb17ed	EMP Persistence Tour 2017	2017-01-24	427a371fadd4cce654dd30c27a36acb0	0	32.30	2
bbce8e45250a239a252752fac7137e00	In Flames	2017-03-24	38085fa2d02ff7710a42a0c61ab311e2	0	57.45	2
663ea93736c204faee5f6c339203be3e	Death is just the beginning	2018-10-18	427a371fadd4cce654dd30c27a36acb0	0	32.10	2
c8ee19d8e2f21851dc16db65d7b138bc	Kreator, Sepultura, Soilwork, Aborted	2017-02-17	427a371fadd4cce654dd30c27a36acb0	0	42.00	2
e1baa5fa38e1e6c824f2011f89475f03	The Popestar Tour 2017	2017-04-09	427a371fadd4cce654dd30c27a36acb0	0	33.50	2
d3284558d8cda50eb33b5e5ce91da2af	Before we go Farewell Tour 2016	2016-02-11	427a371fadd4cce654dd30c27a36acb0	0	17.45	2
a61b878c2b563f289de2109fa0f42144	Conan	2017-03-08	427a371fadd4cce654dd30c27a36acb0	0	18.00	2
0aa506a505f1115202f993ee4d650480	MTV's Headbangers Ball Tour 2018	2018-12-11	427a371fadd4cce654dd30c27a36acb0	0	39.80	1
4c90356614158305d8527b80886d2c1e	Rock for Hille Benefiz	2018-10-27	875ec5037fe25fad96113c57da62f9fe	0	25.00	2
568177b2430c48380b6d8dab67dbe98c	Warfield / Purify / Sober Truth	2018-02-17	4e637199a58a4ff2ec4b956d06e472e8	0	10	2
26a40a3dc89f8b78c61fa31d1137482c	Worldwired Tour 2018	2018-02-16	7786a0fc094d859eb469868003b142db	0	115.15	2
939fec794a3b41bc213c4df0c66c96f5	Jomsviking European Tour 2016	2016-11-17	2a8f2b9aef561f19faad529d927dba17	0	40.40	2
eb2330cf8b87aa13aad89f32d6cfda18	Guido's Super Sweet 16 (30. jubilee)	2018-04-27	8bb89006a86a427f89e49efe7f1635c1	0	9.00	2
0e33f8fbbb12367a6e8159a3b096898a	Skindred, Zebrahead	2016-12-09	427a371fadd4cce654dd30c27a36acb0	0	25.70	2
3f15c445cb553524b235b01ab75fe9a6	Ministry	2018-08-06	427a371fadd4cce654dd30c27a36acb0	0	35.80	2
d1832e7b44502c04ec5819ef3085371a	Dia de los muertos Roadshow 2016	2016-11-11	427a371fadd4cce654dd30c27a36acb0	0	14.70	2
64896cd59778f32b1c61561a21af6598	Will to power tour 2018	2018-02-06	427a371fadd4cce654dd30c27a36acb0	0	36.70	2
63a722e7e0aa4866721305fab1342530	EMP Persistence Tour 2018	2018-01-23	427a371fadd4cce654dd30c27a36acb0	0	33.40	2
a626f2fb0794eeb25b074b4c43776634	Dia de los muertos Roadshow 2018	2018-11-02	427a371fadd4cce654dd30c27a36acb0	0	14.5	2
f5a56d2eb1cd18bf3059cc15519097ea	X-Mass in Hell Festival West Edition 2018	2018-12-15	4751a5b2d9992dca6e462e3b14695284	0	39	2
62f7101086340682e5bc58a86976cfb5	Darkness approaching	2019-05-10	620f9da22d73cc8d5680539a4c87402b	0	30.00	2
0dcd062f5beffeaae2efae21ef9f3755	Cannibal Corpse, European Summer Tour 2019	2019-06-30	c6e9ff60da2342ba2a0ce4d9b6fc6ff1	0	30.00	2
d0f1ffdb2d3a20a41f9c0f10df3b9386	Südpfalz Metalfest	2020-09-25	875ec5037fe25fad96113c57da62f9fe	0	30.00	2
20b7e40ecd659c47ca991e0d420a54eb	Rockfield Open Air 2017	2017-08-18	55ff4adc7d421cf9e05b68d25ee22341	2	0.00	2
7e2e7fa5ce040664bf7aaaef1cebd897	Rock-N-Pop Youngsters 2019	2019-03-15	620f9da22d73cc8d5680539a4c87402b	0	0.00	2
20cf9df7281c50060aaf023e04fd5082	Winter Hostilities 2019-Tour	2019-12-04	427a371fadd4cce654dd30c27a36acb0	0	23.70	2
dcda9434b422f9aa793f0a8874922306	A Tribute to ACDC 2020	2020-03-07	59c2a4862605f1128b334896c17cab7b	0	15.00	1
bb378a3687cc64953bf36ccea6eb5a27	Warfield - Café Central	2022-02-05	0b186d7eb0143e60ced4af3380f5faa8	0	0.00	2
fce1fb772d7bd71211bb915625ac11af	World needs mosh (Wiesbaden)	2021-11-19	427a371fadd4cce654dd30c27a36acb0	0	14.90	2
95f89582ba9dcfbed475ebb3c06162db	World needs mosh (Bonn)	2021-11-21	99d75d9948711c04161016c0d2280dd9	0	14.90	2
3c61b014201d6f62468d72d0363f7725	Crisix, Insanity Alert	2021-09-16	0b186d7eb0143e60ced4af3380f5faa8	0	19.70	2
13afebb96e2d2d27345bd3b1fefc4db0	Crossplane & Hängerbänd	2021-08-06	f3c1ffc50f4f8d0a857533164e8da867	0	18.60	2
441306dd21b61d9a52e04b9e177cc9b5	Jubiläumswoche 25 Jahre Hexenhaus	2021-07-31	012d8da36e8518d229988fe061f3c376	0	41.90	2
4bc4f9db3d901e8efe90f60d85a0420d	Descend into Madness Tour 2020	2020-03-11	427a371fadd4cce654dd30c27a36acb0	0	19.20	1
06e5f3d0d817c436d351a9cf1bf94dfa	The Gidim European Tour 2020	2020-03-05	427a371fadd4cce654dd30c27a36acb0	0	25.90	2
dd50d5dcc02ea12c31e0ff495891dc22	"Still Cyco Punk" World Wide Tour 2018	2018-11-04	c6e9ff60da2342ba2a0ce4d9b6fc6ff1	0	34.00	2
f861455af8364fc3fe01aef3fc597905	Sons of Rebellion Tour 2019	2019-11-01	4751a5b2d9992dca6e462e3b14695284	0	26.40	2
8368e0fd31972c67de1117fb0fe12268	Pagan Metal Festival	2019-11-03	0b186d7eb0143e60ced4af3380f5faa8	0	26.30	2
5e45d87cab8e0b30fba4603b4821bfcd	European Tour Summer 2019	2019-08-13	427a371fadd4cce654dd30c27a36acb0	0	23.70	2
d2a4c05671f768ba487ad365d2a0fb6e	Metallergrillen 2017	2017-09-01	d5c76ce146e0b3f46e69e870e9d48181	1	33.0	2
633f06bd0bd191373d667af54af0939b	Heidelberg Deathfest IV	2019-03-23	828d35ecd5412f7bc1ba369d5d657f9f	0	40.00	2
abefb7041d2488eadeedba9a0829b753	Taunus Metal Festival XI	2019-04-12	1e9e26a0456c1694d069e119dae54240	1	25.00	2
189f11691712600d4e1b0bdb4122e8aa	Metal Club Odinwald meets Ultimate Ruination Tour	2019-04-27	50bd324043e0b113bea1b5aa0422806f	0	9.00	2
1ea2f5c46c57c12dea2fed56cb87566f	1. Mainzer Rock & Metal Fastnachts-Party	2019-03-02	620f9da22d73cc8d5680539a4c87402b	0	5.00	2
cc4617b9ce3c2eee5d1e566eb2fbb1f6	Aversions Crown | Psycroptic	2019-02-21	427a371fadd4cce654dd30c27a36acb0	0	23.70	2
12e7b1918420daf69b976a5949f9ba85	Worldwired Tour 2019	2019-08-25	21760b1bbe36b4dae8fa9e0c274f76bf	0	98.65	2
00da417154f2da39e79c9dcf4d7502fa	Prayer Of Annihilation Tour 2019	2019-10-24	4751a5b2d9992dca6e462e3b14695284	0	23.10	2
c150d400f383afb8e8427813549a82d3	Guido's sassy 17 (30th edition)	2019-04-26	8bb89006a86a427f89e49efe7f1635c1	0	11.00	2
060fd8422f03df6eca94da7605b3a9cd	MTV's Headbangers Ball Tour 2019	2019-12-14	427a371fadd4cce654dd30c27a36acb0	0	40.75	2
1104831a0d0fe7d2a6a4198c781e0e0d	Dust Bolt	2019-03-07	427a371fadd4cce654dd30c27a36acb0	0	19.30	2
6d5c464f0c139d97e715c51b43983695	To Drink from the Night Itself, Europe 2019	2019-12-15	427a371fadd4cce654dd30c27a36acb0	0	38.50	2
8d821ce4aedb7300e067cfa9eb7f1eee	The Path of Death 9	2021-11-13	620f9da22d73cc8d5680539a4c87402b	0	25.00	2
d8f60019c8e6cdbb84839791fd989d81	The Path of Death 8	2019-10-26	620f9da22d73cc8d5680539a4c87402b	0	14.00	2
a71ac13634cd0b6d26e52d11c76f0a63	Warfield/Torment of Souls/Redgrin	2021-10-02	3611a0c17388412df8e42cf1858d5e99	0	10.00	2
8224efe45b1d8a1ebc0b9fb0a5405ac6	EMP Persistence Tour 2019	2019-01-24	427a371fadd4cce654dd30c27a36acb0	0	33.60	2
a122cd22f946f0c229745d88d89b05bd	Deserted Fear / Carnation / Hierophant	2019-03-22	427a371fadd4cce654dd30c27a36acb0	0	19.30	2
9418ebabb93c5c1f47a05666913ec6e4	Amorphis & Soilwork	2019-02-13	427a371fadd4cce654dd30c27a36acb0	0	36.90	2
a7ea7b6c1894204987ce4694c1febe03	Halloween Party 2019	2019-10-31	8bb89006a86a427f89e49efe7f1635c1	0	11.00	2
2a6b51056784227b35e412c444f54359	Metal Embrace Festival XII	2018-09-07	741ae9098af4e50aecf13b0ef08ecc47	1	25.00	2
488af8bdc554488b6c8854fae6ae8610	Downfall of Mankind Tour 2019	2019-05-07	4e592038a4c7b6cdc3e7b92d98867506	0	18.0	2
a2cc2bc245b90654e721d7040c028647	Ektomorf - The legion of fury tour 2019	2019-04-25	0b186d7eb0143e60ced4af3380f5faa8	0	26.40	2
f8549f73852c778caa3e9c09558739f2	Eis und Nacht Tour 2020	2020-01-24	0b186d7eb0143e60ced4af3380f5faa8	0	24.10	2
ff3bed6eb88bb82b3a77ddaf50933689	Doom over Mainz	2019-09-21	620f9da22d73cc8d5680539a4c87402b	0	10.0	2
0e4e0056244fb82f89e66904ad62fdaf	The Inmost Light Tatoo 2019	2019-02-01	427a371fadd4cce654dd30c27a36acb0	0	10.0	2
c3b4e4db5f94fac6979eb07371836e81	Heavy metal gegen Mikroplastik	2019-10-19	8bb89006a86a427f89e49efe7f1635c1	0	10.0	2
d1ee83d5951b1668e95b22446c38ba1c	Light to the blind, Slaughterra, All its Grace	2019-03-29	620f9da22d73cc8d5680539a4c87402b	0	10	2
7126a50ce66fe18b84a7bfb3defea15f	Rockbahnhof 2019	2019-05-18	bb1bac023b4f02a5507f1047970d1aca	0	0	2
54bf7e97edddf051b2a98b21b6d47e6a	Slaughterra - Darmstadt	2022-03-05	2898437c2420ae271ae3310552ad6d70	0	15	2
23fcfcbd4fa686b213960a04f49856f4	Dark Zodiak + Mortal Peril	2021-11-27	2898437c2420ae271ae3310552ad6d70	0	15	2
f3603438cf79ee848cb2f5e4a5884663	Alexander the Great in Exil	2021-09-11	14b82c93c42422209e5b5aad5b7b772e	0	11	2
be95780f2b4fba1a76846b716e69ed6d	Friendship & Love Metal Fest	2020-02-15	41b6f7fdc3453cc5f989c347d9b4b674	0	3.00	2
9f1a399c301132b273f595b1cfc5e99d	SARCOFAGO TRIBUTE (Fabio Jhasko)	2021-11-25	0b186d7eb0143e60ced4af3380f5faa8	0	20	2
40c1eb30fa7abc7fdb3d8e35c61f6a7c	Brutality Unleashed Tour 2022	2022-09-05	93a57b9586b3285867e6b87031559aea	0	30.00	2
320951dccf4030808c979375af8356b6	Wild Boar Wars III	2021-08-28	927ba3593d3a4597eac931a25b53a137	0	30.00	2
4eb278e51ecc7a4e052416dc604ad5c5	Metal Embrace Festival XIV	2022-09-09	741ae9098af4e50aecf13b0ef08ecc47	1	30.00	2
60bb0152f453d3f043b4dabee1a60513	Death Over Mainz 2023	2023-04-21	620f9da22d73cc8d5680539a4c87402b	0	30.00	2
6d7c6c981877a0dedcb276ef841e10aa	KILMINISTER - A Tribute to MOTÖRHEAD	2023-05-06	8bb89006a86a427f89e49efe7f1635c1	0	30.00	2
fc0dc52ba0b7a645c4d70c0df70abb40	Wacken Open Air 2022	2022-08-03	fbde8601308ae84be23d6de78e10d14c	3	238.00	2
9f348351c96df42bcc7496c2010d4d1d	Netherheaven Europe 2023	2023-01-19	427a371fadd4cce654dd30c27a36acb0	0	30.50	2
7fc85de86476aadededbf6716f2eebad	Heidelberg Deathfest VI	2023-03-18	828d35ecd5412f7bc1ba369d5d657f9f	0	55.21	2
31c3824b57ad0919df18a79978c701e9	Post Covid European Summer Madness 2022	2022-07-19	427a371fadd4cce654dd30c27a36acb0	0	26.00	2
d5fba38ea6078ea36b9ac0539a8d40c9	HateSphere, sign of death	2023-06-03	0b186d7eb0143e60ced4af3380f5faa8	0	18.70	2
9c697f7def422e3f6f885d3ec9741603	Grill' Em All 2022	2022-07-02	29ae00a7e41558eb2ed8c0995a702d7a	0	0.00	2
53812183e083ed8a87818371d6b3dbfb	Rockfield Open Air 2019	2019-08-09	55ff4adc7d421cf9e05b68d25ee22341	2	0.00	2
7c02da151320d3aa28b1e0f54b0264b0	Rockfield Open Air 2022	2022-08-13	55ff4adc7d421cf9e05b68d25ee22341	2	0.00	2
e1c9ae13502e64fd6fa4121f4af7fb0e	BLUTFEST 2022	2022-10-01	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	23.2	2
63cc3a7986e4e746cdb607be909b90d4	Campaing for musical destruction	2023-03-03	828d35ecd5412f7bc1ba369d5d657f9f	0	34.00	2
f10521a3f832fd2c698b1ac0319ea29a	Slice Me Nice 2022	2022-12-03	fa788dff4144faf1179fc82d60ccd571	0	37.22	2
cb155874b040e90a5653d5d13bab932b	Black Thunder Tour	2022-11-24	67eb541ae5d82ae8606697eba4119bf2	0	36.85	2
bf742e78e40e9b736c8f8cc47a37277c	Laud as Fuck Fest	2022-11-04	d8634af954a0d50828522b6c6a6053c2	0	21.69	2
57dc48deed395dc3a98caea535768d2f	Europe 2022	2022-10-30	427a371fadd4cce654dd30c27a36acb0	0	36.00	2
9922a07485d25c089f12792a50c5bfad	Infernum meets Porkcore Festevil 2022	2022-09-02	e16b7534e6149fb73a7c2d9b02b61a7d	1	67.35	2
824428dadd859deaf1af1916aea84cfc	Death Feast Open Air 2022	2022-08-25	0643057438c69f0c17bf84c9495d2b7e	2	66.50	2
6118dc6a9a96e892fa5bbaac3ccb6d99	Download Germany	2022-06-24	d379f693135eefa77bc9732f97fcaaf1	0	139.00	2
20970f44b43a10d7282a77eda20866e2	Necro Sapiens Tour 2022	2022-05-05	427a371fadd4cce654dd30c27a36acb0	0	19.65	2
808e3291422cea1b35c76af1b5ba5326	Doomsday Album Release Tour	2022-04-28	427a371fadd4cce654dd30c27a36acb0	0	23.80	2
0cd1c230352e99227f43acc46129d6b4	Morbidfest	2022-04-19	0b186d7eb0143e60ced4af3380f5faa8	0	33.00	2
43bcb284a3d1a0eea2c7923d45b7f14e	Berserker World Tour 2019	2019-12-03	a93597b8b03e112e11f4cda2c1587b6f	0	53.95	2
46ffa374af00ed2b76c1cfaa98b76e90	Heidelberg Deathfest V	2022-03-19	828d35ecd5412f7bc1ba369d5d657f9f	0	42.00	2
a7fe0b5f5ae6fbfa811d754074e03d95	Grabbenacht Festival 2018	2018-06-01	7adc966f52e671b15ea54075581c862b	1	23.00	2
0a85beacde1a467e23452f40b4710030	Way of Darkness 2019	2019-10-04	beeb45e34fe94369bed94ce75eb1e841	1	62.00	2
6b09e6ae26a0d03456b17df4c0964a2f	Metal Embrace Festival XIII	2019-09-06	741ae9098af4e50aecf13b0ef08ecc47	1	25.0	2
5c32c0f1d91f2c6579bb1e0b4da7d10c	Vikings and Lionhearts Tour 2022	2022-09-28	c2e2354512feb29acf171d655a159dd0	0	74.70	2
161882776281e759c9c63d385457ce2c	Servant of the Road World Tour	2022-11-29	c2e2354512feb29acf171d655a159dd0	0	86.20	2
fb40042479b7dab1545b6ff8b011e288	Sepultura - Quadra Tour Europe 2022	2022-11-21	427a371fadd4cce654dd30c27a36acb0	0	37.80	2
6b6bceac41ce67726a6218b1155f2e70	Easter Mosh	2023-04-12	4751a5b2d9992dca6e462e3b14695284	0	28.60	2
95cc14735b9cc969baa1fe1d8e4196ae	The Blackest Path	2022-10-08	620f9da22d73cc8d5680539a4c87402b	0	30.00	2
7712d7dceef5a521b4a554c431752979	29. Wave-Gotik-Treffen	2022-06-05	4a887b8a68acf9b04d9d027bddedb06b	1	130.00	2
dae84dc2587a374c667d0ba291f33481	Rockharz Open Air 2019	2019-07-03	3b0409f1b5830369aac22e3c5b9b9815	2	112.75	2
d45cf5e6b7af0cee99b37f15b13360ed	28. Wave-Gotik-Treffen	2019-06-08	4a887b8a68acf9b04d9d027bddedb06b	1	130.00	2
00f269da8a1eee6c08cebcc093968ee1	Grabbenacht Festival 2019	2019-05-30	7adc966f52e671b15ea54075581c862b	1	28.00	2
ec9a23a8132c85ca37af85c69a2743c5	NOAF XII	2016-08-26	bb1bac023b4f02a5507f1047970d1aca	1	35.00	2
a72c5a8b761c2fc1097f162eeda5d5db	NOAF XIV	2018-08-24	bb1bac023b4f02a5507f1047970d1aca	1	42.00	2
c5593cbec8087184815492eee880f9a8	Randy Hansen live in Frankfurt	2016-04-26	927ba3593d3a4597eac931a25b53a137	0	22.00	2
9feb9a9930d633ef18e1dae581b65327	Horresque & Guests	2022-05-13	620f9da22d73cc8d5680539a4c87402b	0	10.00	2
553a00f0c40ce1b1107f833da69988e4	We Are Not Your Kind World Tour	2020-01-29	c2e2354512feb29acf171d655a159dd0	0	80.40	2
ca69aebb5919e75661d929c1fbd39582	NOAF XV	2019-08-23	bb1bac023b4f02a5507f1047970d1aca	1	42.0	2
52270ed38759952c9cbd6487b265a3a7	REVEL IN FLESH support: TORMENT OF SOULS	2022-11-18	d8634af954a0d50828522b6c6a6053c2	0	18.02	2
0e94c08f1e572c5415f66d193fbc322a	Gorecrusher European Tour 2022	2022-11-19	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	25.2	2
b5b9346b4a9da4233b62daad23cf36ed	On Stage - 22.10.2022	2022-10-22	8bb89006a86a427f89e49efe7f1635c1	0	14	2
f87736b916e7d1ac60d0b7b1b7ca97b4	Dia de los muertos Roadshow 2015	2015-11-27	427a371fadd4cce654dd30c27a36acb0	0	12.25	2
6f14a4e8ecdf87e02d77cec09b6c98b9	50 Jahre Doktor Holzbein	2022-04-23	14b82c93c42422209e5b5aad5b7b772e	0	0	2
700b8ca4c946e01dc92ab6c33757cafb	Activate Europe 2022	2022-10-09	427a371fadd4cce654dd30c27a36acb0	0	23	2
8342e65069254a6fd6d2bbc87aff8192	Braincrusher in Hell 2020	2022-05-20	871568e58a911610979cadc2c1e94122	1	70.40	2
cb16e5f28a9e5532485fe35beca8d438	In Flammen Open Air 2023	2023-07-13	245dd888dae44ef00b3aa74214912f40	2	86.90	2
6f745abd8c203f0f0e821ceeb77e5d24	Morbide Klänge II	2023-05-12	620f9da22d73cc8d5680539a4c87402b	0	15	2
1be77f077186f07ab5b59287427b15c2	Oblivion European Tour 2023	2023-08-10	0b186d7eb0143e60ced4af3380f5faa8	0	30.00	2
ef91a35f7de705463fc18a852a0eaa9c	Halloween mit Hängerbänd und Hellbent on Rocking	2023-10-31	8bb89006a86a427f89e49efe7f1635c1	0	30.00	2
1ac607a573d595a27f07adef0073a8fd	Death Metal night - 10.2023	2023-11-04	620f9da22d73cc8d5680539a4c87402b	0	30.00	2
86726dd04d66ca3def8c4e2ccfbbf3e2	"Morbid Devastation"-Tour	2023-11-17	427a371fadd4cce654dd30c27a36acb0	0	30.00	2
95f435dc4c76d20082aafca8e5a394c9	On Stage - 09.03.2024	2024-03-09	8bb89006a86a427f89e49efe7f1635c1	0	14.0	2
0b305bfbd40df03ea4a962caa5bfc8f4	Heidelberg Deathfest Warm-Up-Show 2024	2024-02-24	0b186d7eb0143e60ced4af3380f5faa8	0	30.70	2
ddfe34c53312f205cb9ee1df3ee0cd0e	Boarstream Open Air 2023	2023-07-21	b26918c7403ba9006251abb5aed9b568	1	66.60	2
dad100b64679b43501647a37e886a148	40 Years of Destruction Europe Tour 2023	2023-10-27	427a371fadd4cce654dd30c27a36acb0	0	40.30	2
2d2f874ab54161fb8158d43487e77eb6	Swords into Flesh Europe Tour 2023	2023-11-07	0b186d7eb0143e60ced4af3380f5faa8	0	27.50	2
7e8a1347517055c0af14a3df27f42a4d	Breakdown4Tolerance Vol.1 Festival	2023-09-30	28b01417bfa80ac2a9d3521137485589	0	25.00	2
e59ace10fad0af976f723748e6fd2ea8	Summer in the City 2023	2023-06-30	f9b213d4a497239d3969131d12cb900d	0	0.00	2
d691b12bf758d4895b52dd338feb3a10	The young meatal attack	2024-03-02	e2b11d2fc694a779d25220b9e5cb88ad	0	12.00	2
2cd4ca525a2d7af5ffa5f6286998ceb0	Rumble of thunder	2023-06-27	5ef87fb605db6ba57e23c29fed883ac7	0	38.85	2
7d126fe510b243454713c0ac4cd66011	Grabbenacht Festival 2023	2023-06-09	7adc966f52e671b15ea54075581c862b	1	45.00	2
2200574eb6396407ec9fc642c91f0e5a	European Miserere 2023	2023-07-03	d6a89e194d2558258305d49f06856e57	0	15.00	2
0962c746a7d30ba0f037b21fb8e32858	A Goat Vomit Summer	2023-07-25	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	23.20	2
b4bc434cadf0eb32a339ac495a2268e8	40 Years of the Apocalypse Anniversary Tour 2023	2023-09-26	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	32.90	2
331460836901954849fb420c890f1c44	Horrible Death Tour 2023	2023-09-29	93a57b9586b3285867e6b87031559aea	0	13.00	2
3048f2df2a1969708f48957002d0ea46	Latin American Massacre	2023-10-20	620f9da22d73cc8d5680539a4c87402b	0	9.60	2
b8a9f22cb877ce0189a3ce04e105f0c1	European Fall 2023 Tour	2023-11-19	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	37.30	2
fa64fb0e05a9c0e32010d73760dfa53f	Rockfield Open Air 2023	2023-08-11	55ff4adc7d421cf9e05b68d25ee22341	2	0.00	2
89b8688929aebb711cffaa22561b1395	Summer in the City 2018	2018-07-08	f9b213d4a497239d3969131d12cb900d	0	0.00	2
b5b0b9a19e53b658857004f145d6a94f	Evil Obsession 2023	2023-12-28	828d35ecd5412f7bc1ba369d5d657f9f	0	48.50	2
85500121e0087db5354d72b484d1a90e	Motörblast Play Motörhead - 2023	2023-12-27	c6e9ff60da2342ba2a0ce4d9b6fc6ff1	0	18.60	2
ee46f6424a052ac12d2c76309c260a36	50 Jahre Geisler of Hell Festival	2024-01-12	a247cd14d4d2259d6f2bc87dcb3fdfb6	0	28.70	2
04fdcbd453ccdcfc343ffc7ab6b27a8d	Dread Reaver Europe 2024	2024-01-20	828d35ecd5412f7bc1ba369d5d657f9f	0	39.50	2
98bbd03f950cbc96d6639a4b7b43e76a	Death and Gore over Frankfurt	2023-10-28	d7925427b71cf5c69dea1361e790154e	0	9.00	2
379d64538f810914012edc9981039183	Eskalation im Oberhaus 2024	2024-02-03	f0a8e858b19385f9c627d8b752c81a6c	0	22.00	2
55feb5f143059bd9a7a647ba7daab977	Motörblast Play Motörhead - 2018	2018-12-27	c6e9ff60da2342ba2a0ce4d9b6fc6ff1	0	16.40	2
6a1b89e9076bdcb811ab7b4b6b5fbb23	Paganische Nacht - 2023	2023-11-24	46103b15f2a58bf3c7d03c4d9a954779	0	29.00	2
68884e33784d424fef2065652b743ee7	Hell over Aschaffenburg - 2023	2023-11-25	46103b15f2a58bf3c7d03c4d9a954779	0	35.00	2
97a06553981fd4531de6d5542136b854	30. Wave-Gotik-Treffen	2023-05-26	4a887b8a68acf9b04d9d027bddedb06b	3	170.00	2
0e4288f287e446bf417ba4e0664a1c26	The Path of Death 10	2023-10-14	620f9da22d73cc8d5680539a4c87402b	0	39.00	2
477a7e7627b4482929c215de7d3c4a76	Metal Embrace Festival XV	2023-09-08	741ae9098af4e50aecf13b0ef08ecc47	1	48.50	2
4454869140a41f593eb7d8575d0f97c8	Metal im M8 - 12.2023	2023-12-09	620f9da22d73cc8d5680539a4c87402b	0	8.00	2
180e57969fd1e8948ebdf21ff1b57d3d	15 Jahre live im GMZ Georg-Buch-Haus Wiesbaden	2014-10-04	5a90e8cdd17fb102f309e2bbd460e289	0	9.00	2
d3582717412a80f08b23f8add23a1f35	Hell over Aschaffenburg - 2019	2019-11-30	858d53d9bd193393481e4e8b24d10bba	0	30.00	2
91b0a2f2ba6b8909cc412bf37e35f779	Bands am Montag - 12.2023	2023-12-18	14b82c93c42422209e5b5aad5b7b772e	0	0.0	2
e396e5afb7cf4c68b9adce7af6adad8c	Death Feast Open Air 2023	2023-08-24	0643057438c69f0c17bf84c9495d2b7e	2	85.50	2
b0f45689c096147b963b998eccdbc19e	Hutkonzert - ATG - 19.10.2023	2023-10-19	8bb89006a86a427f89e49efe7f1635c1	0	10.0	2
8640cd270510da320a9dd71429b95531	NOAF XI	2015-08-28	bb1bac023b4f02a5507f1047970d1aca	1	15.0	2
7e834ee3aea78e49afb45728dbb63de2	On Stage - 16.09.2023	2023-09-16	8bb89006a86a427f89e49efe7f1635c1	0	14	2
3aa0df8e70b789a940e8a4df74c1c1de	Ton Steine Scherben - 2015	2015-10-01	427a371fadd4cce654dd30c27a36acb0	0	25	2
a1ba44498f1b706e9ec67d6c50842b42	Exorcised Gods/Harvest their Bodies/Call of Charon/Trennjaeger	2019-11-15	620f9da22d73cc8d5680539a4c87402b	0	9	2
9c553520982c65b603e9d741eaa56b09	57. Wernigeröder Rathausfest	2023-06-16	e1d73a013c55de0ebff0e36b7c07ee77	1	0	2
bc9dd8d4890a5523a876931328350747	Dortmund Deathfest 2023	2023-08-04	581032b233cfa02398169948de14c2dd	1	79	2
\.


--
-- Data for Name: generes; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.generes (id_genere, genere) FROM stdin;
17b8dff9566f6c98062ad5811c762f44	Death Metal
a29864963573d7bb061691ff823b97dd	Thrash Metal
a68d5b72c2f98613f511337a59312f78	Black Metal
04ae76937270105919847d05aee582b4	Heavy Metal
7fa69773873856d74f68a6824ca4b691	Brutal Death Metal
01864d382accf1cdb077e42032b16340	Melodic Death Metal
d5a9c37bc91d6d5d55a3c2e38c3bf97d	Groove Metal
7a3808eef413b514776a7202fd2cb94f	Metalcore
10a17b42501166d3bf8fbdff7e1d52b6	Grindcore
885ba57d521cd859bacf6f76fb37ef7c	Doom Metal
dcd00c11302e3b16333943340d6b4a6b	Hard Rock
caac3244eefed8cffee878acae427e28	Deathcore
585f02a68092351a078fc43a21a56564	Speed Metal
4fb2ada7c5440a256ed0e03c967fce74	Power Metal
2336f976c6d510d2a269a746a7756232	Hardcore Punk
1c800aa97116d9afd83204d65d50199a	Hardcore
ea9565886c02dbdc4892412537e607d7	Sludge Metal
2e607ef3a19cf3de029e2c5882896d33	Crossover
2df929d9b6150c082888b66e8129ee3f	Technical Death Metal
bb273189d856ee630d92fbc0274178bb	Alternative Metal
02d3190ce0f08f32be33da6cc8ec8df8	Nu Metal
4cfbb125e9878528bab91d12421134d8	Rock
eaa57a9b4248ce3968e718895e1c2f04	Metal
ff7aa8ca226e1b753b0a71d7f0f2e174	Alternative Rock
924ae2289369a9c1d279d1d59088be64	Slamming Brutal Death Metal
8c42e2739ed83a54e5b2781b504c92de	Folk Metal
f0095594f17b3793be8291117582f96b	Post-Hardcore
0cf6ece7453aa814e08cb7c33bd39846	Gothic Metal
f41da0c65a8fa3690e6a6877e7112afb	Progressive Metal
deb8040131c3f6a3caf6a616b34ac482	Goregrind
60e1fa5bfa060b5fff1db1ca1bae4f99	Post-Metal
7349da19c2ad6654280ecf64ce42b837	Oi!
ef5131009b7ced0b35ea49c8c7690cef	Punk Rock
34d8a5e79a59df217c6882ee766c850a	Industrial Metal
5bf88dc6f6501943cc5bc4c42c71b36b	Punk
9c093ec7867ba1df61e27a5943168b90	Gothic Rock
e8376ca6a0ac30b2ad0d64de6061adab	Viking Metal
d5d0458ada103152d94ff3828bf33909	Progressive Rock
36e61931478cf781e59da3b5ae2ee64e	Melodic Heavy Metal
2a78330cc0de19f12ae9c7de65b9d5d5	Psychedelic Rock
1396a3913454b8016ddf671d02e861b1	Stoner Rock
97a6395e2906e8f41d27e53a40aebae4	Symphonic Death Metal
de62af4f3af4adf9e8c8791071ddafe3	Symphonic Black Metal
6add228b14f132e14ae9da754ef070c5	Rock'n'Roll
239401e2c0d502df7c9009439bdb5bd3	Post-Black Metal
6de7f9aa9c912bf8c81a9ce2bfc062bd	Heavy Hardcore
2bd0f5e2048d09734470145332ecdd24	Epic Doom Metal
1d67aeafcd3b898e05a75da0fdc01365	Crust Metal
ed8e37bad13d76c6dbeb58152440b41e	Ambient
65d1fb3d4d28880c964b985cf335e04c	Stoner Metal
bbc90d6701da0aa2bf7f6f2acb79e18c	Blues Rock
1868ffbe3756a1c3f58300f45aa5e1d3	Blackened Death Metal
8dae638cc517185f1e6f065fcd5e8af3	Melodic Hardcore
a279b219de7726798fc2497d48bc0402	Southern Metal
b86219c2df5a0d889f490f88ff22e228	Avant-garde Black Metal
72616c6de7633d9ac97165fc7887fa3a	Rap Rock
781f547374aef3a99c113ad5a9c12981	Pornogrind
4c4f4d32429ac8424cb110b4117036e4	Beatdown
0138eefa704205fd48d98528ddcdd5bc	Melodic Thrash Metal
02c4d46b0568d199466ef1baa339adc8	Pop Punk
c1bfb800f95ae493952b6db9eb4f0209	Space Rock
1302a3937910e1487d44cec8f9a09660	Rap Metal
1eef6db16bfc0aaf8904df1503895979	Dark Rock
c08ed51a7772c1f8352ad69071187515	Post-Grunge
e7faf05839e2f549fb3455df7327942b	Ska Punk
2e9dfd2e07792b56179212f5b8f473e6	Funk Rock
8a055a3739ca4b38b9c5a188d6295830	Melodic Power Metal
262770cfc76233c4f0d7a1e43a36cbf7	Melodic Black Metal
f82c0cf1d80eca5ea2884bbc7bd04269	Medieval Rock
ba60b529061c0af9afe655b44957e41b	Extreme Gothic Metal
fc8e55855e2f474c28507e4db7ba5f13	Mathcore
d3fcef9d7f88d2a12ea460c604731cd5	German Punk
ad49b27a742fb199ab722bce67e9c7b2	Stoner Doom
4428b837e98e3cc023fc5cd583b28b20	Atmospheric Sludge Metal
5cbdaf6af370a627c84c43743e99e016	Modern Metal
bfd67ea5a2f5557126b299e33a435ab3	Comedy Rap
dfda7d5357bc0afc43a89e8ac992216f	Tribute to Rammstein
a379c6c3bf4b1a401ce748b34729389a	Viking Black Metal
7ac5b6239ee196614c19db6965c67b31	Post-Rock
f79873ac4ff0e556619b15d82f6da52c	Post-Punk
b6a0263862e208f05258353f86fa3318	Epic Power Metal
fd00614e73cb66fd71ab13c970a074d8	Progressive Death Metal
cb6ef856481bc776bba38fbf15b8b3fb	Pagan Black Metal
f224a37b854811cb14412ceeca43a6ad	Shoegaze
268a3b877b5f3694d5d1964c654ca91c	Irish Folk Punk
7886613ffb324e4e0065f25868545a63	Melodic Groove Metal
763a34aaa76475a926827873753d534f	Ambient Post-Black Metal
17095255b1df76ab27dd48f29b215a5f	Tribute to Rage against the Machine
d31813e8ef36490c57d4977e637efbd4	Street Punk
d93cf30d3eb53125668057b982b433a3	Technical Deathcore
0849fb9eb585f2c20b427a99f1231e40	Medieval Metal
887f0b9675f70bc312e17c93f248b5aa	Electronic Metal
7a09fdabda255b02b2283e724071944b	Black'n'Roll
9ba0204bc48d4b8721344dd83b832afe	Tribute to Motörhead
e6218d584a501be9b1c36ac5ed13f2db	Beatdown Hardcore
94876c8f843fa0641ed7bdf6562bdbcf	Tribute to Jimi Hendrix
273112316e7fab5a848516666e3a57d1	Folk
8472603ee3d6dea8e274608e9cbebb6b	Occult Rock
65805a3772889203be8908bb44d964b3	Stoner
57a1aaebe3e5e271aca272988c802651	Horror Punk
b45e0862060b7535e176f48d3e0b89f3	Electronic Body Music
6fa3bbbff822349fee0eaf8cd78c0623	Rapcore
ff3a5da5aa221f7e16361efcccf4cbaa	Alternativ Grunge
ad6296818a1cb902ac5d1a3950e79dbe	Comedy Rock
4895247ad195629fecd388b047a739b4	Industrial Rock
320094e3f180ee372243f1161e9adadc	Pop(p)core
5b412998332f677ddcc911605985ee3b	Tribute to ACDC
b7628553175256a081199e493d97bd3b	Fast Rock'n'Roll
93cce11930403f5b3ce8938a2bde5efa	Pagan Metal
4b3bb0b44a6aa876b9e125a2c2a5d6a2	Extreme Metal
fad6ee4f3b0aded7d0974703e35ae032	Trancecore
2894c332092204f7389275e1359f8e9b	Progressive Thrash Metal
fbe238aca6c496dcd05fb8d6d98f275b	Symphonic Melodic Death Metal
fa20a7164233ec73db640970dae420cf	Symphonic Power Metal
cbfeef2f0e2cd992e0ea65924a0f28a1	Avant-garde Metal
e22aa8f4c79b6c4bbeb6bcc7f4e1eb26	Slam Metal
8bbab0ae4d00ad9ffee6cddaf9338584	Hip Hop
4144b216bf706803a5f17d7d0a9cf4a3	Goth'n'Roll
6fb9bf02fc5d663c1de8c117382bed0b	Agressive Rock
bca74411b74f01449c61b29131bc545e	Proto Metal
f633e7b30932bbf60ed87e8ebc26839d	Tribute to Bathory
b7d08853c905c8cd1467f7bdf0dc176f	Tribute to Black Sabbath
2d4b3247824e58c3c9af547cce7c2c8f	Reggae Rock
eb182befdeccf17696b666b32eb5a313	Blackened Thrash Metal
1e612d6c48bc9652afeb616536fced51	Metal Covers
c3ee1962dffaa352386a05e845ab9d0d	Hard Pop
a178914dea39e23c117e164b05b43995	Drone
c5405146cd45f9d9b4f02406c35315a8	Atmospheric Post-Hardcore
64ec11b17b6f822930f9deb757fa59e8	Mariachi Punk
3770d5a677c09a444a026dc7434bff36	Progressive Metalcore
ecbff10e148109728d5ebce3341bb85e	Death'n'Roll
836ea59914cc7a8e81ee0dd63f7c21c1	Melodic Metalcore
ad38eede5e5edecd3903f1701acecf8e	Epic Metal
303d6389f4089fe9a87559515b84156d	Symphonic Metal
8de5a5b30fc3e013e9b52811fe6f3356	Epic Heavy Metal
0d1830fc8ac21dfabd6f33ab01578c0b	Thrashing Deathgrind
efe010f3a24895472e65b173e01b969d	Experimental Metal
9713131159f9810e6f5ae73d82633adb	Atmospheric Black Metal
564807fb144a93a857bfda85ab34068d	Melodic Gothic Metal
a46700f6342a2525a9fba12d974d786e	Neue Deutsche Härte
9d78e15bf91aef0090e0a37bab153d98	Dark Metal
2da00ba473acb055e8652437024c6fd4	Latin Metal
504724f4d7623c2a03384bd0f213e524	New Wave of British Heavy Metal
f22794f69ce5910cb4be68ff9026570d	Various
74d754b83e2656bcc0cb58033a03e6e4	Technical Brutal Death Metal
f008a5f1cb81bcfa397f7c1987f2bf55	Slamming Deathcore
b1ba0a25e72cac8ac1f43019f45edcc9	Brutal Deathcore
bb9a7990e74371142d6f4f02353a0db0	Hunnu Rock
7b327f171695316c16ddca1843a81531	Djent
5515abb95e50f2f39c3072b4fef777e0	Death-Gind
30a1a8d73498d142609138c37ac3b9f3	Electro Punk
61bb65b2791647f828d25a985a2e60fa	Viking Nordic Folk
156968bdeb9fd240ae047867022d703b	Medieval Folk Metal
e3bae98a1c48ce980083c79f6416c0f6	Crust Punk
d34d0c161bbb04228af45f99d2b407a6	Dark Country
353d5e79c4f0f22dc9fd189fb293b18c	Irish Folk
0ae61bd0474e04c9f1195d4baa0213a0	Pop
9a284efda4d46636bd9d5298dfea1335	Jazz
da832711951e70811ef7533835637961	Reggae
276dd0e596bbc541942c8cd9cc2004e0	Atmospheric Folk Metal
8b7bdc272dd85d5058f8fbaa14e66002	Crust
82f71c08ea9ddc4fa9dfb06236a45ba1	Brutal Technical Death Metal
6e8e259537338c1ffacf0df56249227a	Slam
a14c7f19780155d998b8c0d48c4f2f61	Technical Grindcore
89089c3efdb2f18179df6d476e5759de	Melodic Viking Metal
aca2a3c07f76ae685ae818b312e025c5	Blues
39d9d9f9143880553c5e2da25c87f33d	Calypso
59716c97497eb9694541f7c3d37b1a4d	Country
ead7038498db3f93ac79d28407a6d47c	Vaudeville
cd841371c5cd35c94bb823be9f53cf2f	Skiffle
0cb6959de39db97ee5fad81faa008d8f	Ska
a48199bd07eec68b1214594af75d7eb3	Folkrock
08cbc2781f56d15c2c374824c7428a8c	Plitrock
0077c87e06d736b19d6b3978f5e5e6e2	Protopunk
5fa721b23d1df57306a710b77d7897d6	Punk'n'Roll
84caaa55a818fdacc56b1a78e3059e3b	Heavy Rock
86990837f323dde52a011a1f2d1eca0d	Technical Brutal Deathcore
819de896b7c481c2b870bcf4ca7965fc	Slamdown
c7d1df50d4cb1e00b5b5b3a34a493b90	Atmospheric Post-Black Metal
51a0accd339e27727689fc781c4df015	Blackened Speed Metal
2d1930ea91c39cb44ce654c634bd5113	Tribute to Bolt Thrower
c56931e6d30371f655de27ecbf6c50f0	Tribute to Danzig
9a9f894a69bab7649b304cb577a96566	Tribute to Misfits
5f05cefd0f6a07508d21a1d2be16d9c7	Electronic
d5750853c14498dc264065bcf7e05a29	Tribute to Megadeth
07b91b89a1fd5e90b9035bf112a3e6e5	Blackened Folk Metal
f829960b3a62def55e90a3054491ead7	Middle Eastern Doom Metal
d4fe504b565a2bcbec1bb4c56445e857	Funeral Doom Metal
178c690e12310890294b6fefeb0c2442	Tribute to Slayer
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
-- Name: iso_639_3 iso_639_3_pkey; Type: CONSTRAINT; Schema: languages; Owner: -
--

ALTER TABLE ONLY languages.iso_639_3
    ADD CONSTRAINT iso_639_3_pkey PRIMARY KEY (iso639_3_id);


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
-- Name: bands_generes bands_generes_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_generes
    ADD CONSTRAINT bands_generes_pkey PRIMARY KEY (id_band, id_genere);


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
-- Name: generes generes_genere_key; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.generes
    ADD CONSTRAINT generes_genere_key UNIQUE (genere);


--
-- Name: generes generes_pkey; Type: CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.generes
    ADD CONSTRAINT generes_pkey PRIMARY KEY (id_genere);


--
-- Name: v_events_mod _RETURN; Type: RULE; Schema: music; Owner: -
--

CREATE OR REPLACE VIEW music.v_events_mod AS
 SELECT date_part('year'::text, e.date_event) AS year,
    to_char((e.date_event)::timestamp with time zone, 'DD.MM.YYYY'::text) AS date,
    e.event,
    p.place,
    count(DISTINCT be.id_band) AS bands,
    (e.duration + 1) AS days
   FROM ((music.events e
     JOIN geo.places p ON ((p.id_place = e.id_place)))
     JOIN music.bands_events be ON ((be.id_event = e.id_event)))
  GROUP BY e.event, p.place, e.date_event, e.id_event
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
    ADD CONSTRAINT bands_countries_id_band_fkey FOREIGN KEY (id_band) REFERENCES music.bands(id_band);


--
-- Name: bands_countries bands_countries_id_country_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_countries
    ADD CONSTRAINT bands_countries_id_country_fkey FOREIGN KEY (id_country) REFERENCES geo.countries(id_country) ON UPDATE CASCADE;


--
-- Name: bands_events bands_events_id_band_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_events
    ADD CONSTRAINT bands_events_id_band_fkey FOREIGN KEY (id_band) REFERENCES music.bands(id_band);


--
-- Name: bands_events bands_events_id_event_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_events
    ADD CONSTRAINT bands_events_id_event_fkey FOREIGN KEY (id_event) REFERENCES music.events(id_event);


--
-- Name: bands_generes bands_generes_id_band_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_generes
    ADD CONSTRAINT bands_generes_id_band_fkey FOREIGN KEY (id_band) REFERENCES music.bands(id_band);


--
-- Name: bands_generes bands_generes_id_genere_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_generes
    ADD CONSTRAINT bands_generes_id_genere_fkey FOREIGN KEY (id_genere) REFERENCES music.generes(id_genere);


--
-- Name: events events_id_place_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.events
    ADD CONSTRAINT events_id_place_fkey FOREIGN KEY (id_place) REFERENCES geo.places(id_place);


--
-- Name: mv_musical_info; Type: MATERIALIZED VIEW DATA; Schema: music; Owner: -
--

REFRESH MATERIALIZED VIEW music.mv_musical_info;


--
-- PostgreSQL database dump complete
--

