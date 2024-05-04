--
-- PostgreSQL database dump
--

-- Dumped from database version 15.6 (Ubuntu 15.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.6 (Ubuntu 15.6-1.pgdg22.04+1)

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
-- Name: insert_bands_to_generes(character varying, character varying); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_bands_to_generes(ban character varying, gene character varying) RETURNS text
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
-- Name: insert_bands_to_generes_test(character varying, character varying); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_bands_to_generes_test(ban character varying, gene character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$ 
declare 
  i_band varchar;
  i_gene varchar;
begin 
	
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
 
  select id_genere, id_band into i_gene, i_band
  from music.bands_generes bg 
  where id_band = md5(ban) and id_genere = md5(gene)  for update;
  
  if not found then
    insert into music.bands_generes
    values(md5(ban), md5(gene));
    return 'Band - Genere added';
  else
    return 'This combination of band and genere exist';
  end if;
end;
$$;


--
-- Name: insert_events(character varying, date, character varying, integer); Type: FUNCTION; Schema: music; Owner: -
--

CREATE FUNCTION music.insert_events(eve character varying, dat date, plac character varying, dur integer) RETURNS text
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
    values (md5(eve), eve, dat, md5(plac), dur);
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
    duration integer DEFAULT 0,
    price numeric DEFAULT 30.00,
    persons integer DEFAULT 1
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
            WHEN ((vb.band)::text ~* 'Apey|Booze|Nordic'::text) THEN (regexp_replace((vb.band)::text, '\&'::text, '\\&'::text))::character varying
            WHEN ((vb.band)::text ~* 'Auðn'::text) THEN (regexp_replace((vb.band)::text, 'ð'::text, '\\dh '::text))::character varying
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
  ORDER BY (count(DISTINCT bc.id_band)) DESC;


--
-- Name: v_eu_board_german_black_death_thrash; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_eu_board_german_black_death_thrash AS
 SELECT DISTINCT b.band,
    c.country
   FROM ((((((music.bands b
     JOIN music.bands_events be ON ((b.id_band = be.id_band)))
     JOIN music.events e ON ((be.id_event = e.id_event)))
     JOIN music.bands_generes bg ON ((bg.id_band = b.id_band)))
     JOIN music.generes g ON ((g.id_genere = bg.id_genere)))
     JOIN music.bands_countries bc ON ((bc.id_band = b.id_band)))
     JOIN geo.countries c ON ((c.id_country = bc.id_country)))
  WHERE ((b.likes = 'y'::bpchar) AND (((g.genere)::text ~~ '%Death%'::text) OR ((g.genere)::text ~~ '%Thrash%'::text) OR ((g.genere)::text ~~ '%Speed%'::text) OR ((g.genere)::text ~~ '%Black%'::text)) AND ((c.country)::text = ANY (ARRAY[('Germany'::character varying)::text, ('France'::character varying)::text, ('Austria'::character varying)::text, ('Belgium'::character varying)::text, ('Switzerland'::character varying)::text, ('Czech Republic'::character varying)::text, ('Denmark'::character varying)::text, ('Poland'::character varying)::text, ('Netherlands'::character varying)::text, ('Luxembourg'::character varying)::text])))
  ORDER BY c.country, b.band;


--
-- Name: v_eu_to_metalembrace; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_eu_to_metalembrace AS
 SELECT DISTINCT b.band AS "Band",
    cou.country AS "Country"
   FROM ((((((music.bands b
     JOIN music.bands_countries bc ON ((b.id_band = bc.id_band)))
     JOIN geo.countries cou ON ((bc.id_country = cou.id_country)))
     JOIN geo.countries_continents cc ON (((cc.id_country)::bpchar = cou.id_country)))
     JOIN geo.continents con ON (((con.id_continent)::text = (cc.id_continent)::text)))
     JOIN music.bands_generes bg ON ((b.id_band = bg.id_band)))
     JOIN music.generes g ON ((bg.id_genere = g.id_genere)))
  WHERE (((con.continent)::text = 'Europe'::text) AND ((g.genere)::text = ANY ((ARRAY['Death Metal'::character varying, 'Thrash Metal'::character varying, 'Speed Metal'::character varying, 'Black Metal'::character varying, 'Melodic Death Metal'::character varying, 'Groove Metal'::character varying, 'Viking Metal'::character varying, 'Ambient'::character varying, 'Blackened Death Metal'::character varying, 'Avant-garde Black Metal'::character varying, 'Melodic Thrash Metal'::character varying, 'Melodic Black Metal'::character varying, 'Viking Black Metal'::character varying, 'Pagan Black Metal'::character varying, 'Ambient Post-Black Metal'::character varying, 'Pagan Metal'::character varying, 'Blackened Thrash Metal'::character varying, 'Atmospheric Black Metal'::character varying])::text[])) AND b.active)
  ORDER BY cou.country, b.band;


--
-- Name: v_eu_metalembrace_to_tex; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_eu_metalembrace_to_tex AS
 SELECT ((((v_eu_to_metalembrace."Band")::text || ' & '::text) || (v_eu_to_metalembrace."Country")::text) || ' \\ \hline'::text) AS "?column?"
   FROM music.v_eu_to_metalembrace;


--
-- Name: v_events; Type: VIEW; Schema: music; Owner: -
--

CREATE VIEW music.v_events AS
 SELECT e.id_event,
    date_part('year'::text, e.date_event) AS year,
    ((((
        CASE
            WHEN (date_part('day'::text, e.date_event) < (10)::double precision) THEN ('0'::text || (date_part('day'::text, e.date_event))::text)
            ELSE (date_part('day'::text, e.date_event))::text
        END || '.'::text) ||
        CASE
            WHEN (date_part('month'::text, e.date_event) < (10)::double precision) THEN ('0'::text || (date_part('month'::text, e.date_event))::text)
            ELSE (date_part('month'::text, e.date_event))::text
        END) || '.'::text) || date_part('year'::text, e.date_event)) AS date,
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
  ORDER BY (count(e.id_event)) DESC;


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
f5cd262901883dff68d06b215fb0f28e	Africa
154a67340e8c14dd5253dc4ff6120197	Asia
912d59cdf1d3f551fae21f6f0062258f	Europe
5ffec2d87ab548202f8b549af380913a	North America
aab422acb3d2334a6deca0e1495745c2	South America
c9d402d0280088a8c803e108bf31449b	Antartica
2d8836190888267b97ce332cad2aa247	Oceania
\.


--
-- Data for Name: countries; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.countries (id_country, country, flag) FROM stdin;
00247297c394dd443dc97067830c35f4	Slovenia	si
0309a6c666a7a803fdb9db95de71cf01	France	fr
06630c890abadde9228ea818ce52b621	Luxembourg	lu
0c7d5ae44b2a0be9ebd7d6b9f7d60f20	Romania	ro
1007e1b7f894dfbf72a0eaa80f3bc57e	Italy	it
21fc68909a9eb8692e84cf64e495213e	Iran	ir
2e6507f70a9cc26fb50f5fd82a83c7ef	Chile	cl
2ff6e535bd2f100979a171ad430e642b	Serbia	rs
33cac763789c407f405b2cf0dce7df89	Cuba	cu
3536be57ce0713954e454ae6c53ec023	Argentina	ar
3ad08396dc5afa78f34f548eea3c1d64	Switzerland	ch
424214945ba5615eca039bfe5d731c09	Denmark	dk
42537f0fb56e31e20ab9c2305752087d	Brazil	br
4442e4af0916f53a07fb8ca9a49b98ed	Australia	au
445d337b5cd5de476f99333df6b0c2a7	Canada	ca
4647d00cf81f8fb0ab80f753320d0fc9	Indonesia	id
51802d8bb965d0e5be697f07d16922e8	Czech Republic	cz
53a577bb3bc587b0c28ab808390f1c9b	Japan	jp
5882b568d8a010ef48a6896f53b6eddb	Costa Rica	cr
5feb168ca8fb495dcc89b1208cdeb919	Russia	ru
6542f875eaa09a5c550e5f3986400ad9	Belarus	by
6b718641741f992e68ec3712718561b8	Greece	gr
6bec347f256837d3539ad619bd489de7	Panama	pa
6c1674d14bf5f95742f572cddb0641a7	Belgium	be
6f781c6559a0c605da918096bdb69edf	Finland	fi
76423d8352c9e8fc8d7d65f62c55eae9	UK	gb
8189ecf686157db0c0274c1f49373318	International	un
8dbb07a18d46f63d8b3c8994d5ccc351	Mexico	mx
907eba32d950bfab68227fd7ea22999b	Spain	es
94880bda83bda77c5692876700711f15	Poland	pl
9891739094756d2605946c867b32ad28	Austria	at
a67d4cbdd1b59e0ffccc6bafc83eb033	Netherlands	nl
ae54a5c026f31ada088992587d92cb3a	China	cn
b78edab0f52e0d6c195fd0d8c5709d26	Iceland	is
c51ed580ea5e20c910d951f692512b4d	New Zealand	nz
c8f4261f9f46e6465709e17ebea7a92b	Sweden	se
d5b9290a0b67727d4ba1ca6059dc31a6	Norway	no
d8b00929dec65d422303256336ada04f	Germany	de
ea71b362e3ea9969db085abfccdeb10d	Portugal	pt
ef3388cc5659bccb742fb8af762f1bfd	Colombia	co
f01fc92b23faa973f3492a23d5a705c5	Ukraine	ua
f75d91cdd36b85cc4a8dfeca4f24fa14	USA	us
fa79c3005daec47ecff84a116a0927a1	Hungary	hu
7d31e0da1ab99fe8b08a22118e2f402b	India	in
76b88e7899abb3bfdd4b55b8c52726b0	Faroe Islands	fo
560d4c6ff431c86546f3fcec72c748c7	Croatia	hr
77dab2f81a6c8c9136efba7ab2c4c0f2	Philippines	ph
06e415f918c577f07328a52e24f75d43	Ireland	ie
a27b7b9f728d4b9109f95e8ee1040c68	Türkiye	tr
92468e8a62373add2b9caefddbcf1303	Malta	mt
bb6a72b6a93150d4181e50496fc15f5a	Mongolia	mn
23b998b19b5f60dbbc4eedc53328b0c7	Dubai	ae
1add2eb41fcae9b2a15b4a7d68571409	Jamaica	jm
5a548c2f5875f10bf5614b7c258876cf	Israel	il
e31959fe2842dacea4d16d36e9813620	Egypt	eg
7755415a9fe7022060b98a689236ccd2	Estonia	ee
\.


--
-- Data for Name: countries_continents; Type: TABLE DATA; Schema: geo; Owner: -
--

COPY geo.countries_continents (id_country, id_continent) FROM stdin;
445d337b5cd5de476f99333df6b0c2a7	5ffec2d87ab548202f8b549af380913a
f75d91cdd36b85cc4a8dfeca4f24fa14	5ffec2d87ab548202f8b549af380913a
8dbb07a18d46f63d8b3c8994d5ccc351	5ffec2d87ab548202f8b549af380913a
1add2eb41fcae9b2a15b4a7d68571409	5ffec2d87ab548202f8b549af380913a
33cac763789c407f405b2cf0dce7df89	5ffec2d87ab548202f8b549af380913a
5882b568d8a010ef48a6896f53b6eddb	5ffec2d87ab548202f8b549af380913a
6bec347f256837d3539ad619bd489de7	5ffec2d87ab548202f8b549af380913a
3536be57ce0713954e454ae6c53ec023	aab422acb3d2334a6deca0e1495745c2
42537f0fb56e31e20ab9c2305752087d	aab422acb3d2334a6deca0e1495745c2
2e6507f70a9cc26fb50f5fd82a83c7ef	aab422acb3d2334a6deca0e1495745c2
ef3388cc5659bccb742fb8af762f1bfd	aab422acb3d2334a6deca0e1495745c2
ae54a5c026f31ada088992587d92cb3a	154a67340e8c14dd5253dc4ff6120197
7d31e0da1ab99fe8b08a22118e2f402b	154a67340e8c14dd5253dc4ff6120197
4647d00cf81f8fb0ab80f753320d0fc9	154a67340e8c14dd5253dc4ff6120197
21fc68909a9eb8692e84cf64e495213e	154a67340e8c14dd5253dc4ff6120197
5a548c2f5875f10bf5614b7c258876cf	154a67340e8c14dd5253dc4ff6120197
53a577bb3bc587b0c28ab808390f1c9b	154a67340e8c14dd5253dc4ff6120197
bb6a72b6a93150d4181e50496fc15f5a	154a67340e8c14dd5253dc4ff6120197
77dab2f81a6c8c9136efba7ab2c4c0f2	154a67340e8c14dd5253dc4ff6120197
5feb168ca8fb495dcc89b1208cdeb919	154a67340e8c14dd5253dc4ff6120197
a27b7b9f728d4b9109f95e8ee1040c68	154a67340e8c14dd5253dc4ff6120197
4442e4af0916f53a07fb8ca9a49b98ed	2d8836190888267b97ce332cad2aa247
c51ed580ea5e20c910d951f692512b4d	2d8836190888267b97ce332cad2aa247
5feb168ca8fb495dcc89b1208cdeb919	912d59cdf1d3f551fae21f6f0062258f
00247297c394dd443dc97067830c35f4	912d59cdf1d3f551fae21f6f0062258f
0309a6c666a7a803fdb9db95de71cf01	912d59cdf1d3f551fae21f6f0062258f
06630c890abadde9228ea818ce52b621	912d59cdf1d3f551fae21f6f0062258f
0c7d5ae44b2a0be9ebd7d6b9f7d60f20	912d59cdf1d3f551fae21f6f0062258f
1007e1b7f894dfbf72a0eaa80f3bc57e	912d59cdf1d3f551fae21f6f0062258f
2ff6e535bd2f100979a171ad430e642b	912d59cdf1d3f551fae21f6f0062258f
3ad08396dc5afa78f34f548eea3c1d64	912d59cdf1d3f551fae21f6f0062258f
424214945ba5615eca039bfe5d731c09	912d59cdf1d3f551fae21f6f0062258f
51802d8bb965d0e5be697f07d16922e8	912d59cdf1d3f551fae21f6f0062258f
6542f875eaa09a5c550e5f3986400ad9	912d59cdf1d3f551fae21f6f0062258f
6b718641741f992e68ec3712718561b8	912d59cdf1d3f551fae21f6f0062258f
6c1674d14bf5f95742f572cddb0641a7	912d59cdf1d3f551fae21f6f0062258f
6f781c6559a0c605da918096bdb69edf	912d59cdf1d3f551fae21f6f0062258f
76423d8352c9e8fc8d7d65f62c55eae9	912d59cdf1d3f551fae21f6f0062258f
907eba32d950bfab68227fd7ea22999b	912d59cdf1d3f551fae21f6f0062258f
94880bda83bda77c5692876700711f15	912d59cdf1d3f551fae21f6f0062258f
9891739094756d2605946c867b32ad28	912d59cdf1d3f551fae21f6f0062258f
a67d4cbdd1b59e0ffccc6bafc83eb033	912d59cdf1d3f551fae21f6f0062258f
b78edab0f52e0d6c195fd0d8c5709d26	912d59cdf1d3f551fae21f6f0062258f
c8f4261f9f46e6465709e17ebea7a92b	912d59cdf1d3f551fae21f6f0062258f
d5b9290a0b67727d4ba1ca6059dc31a6	912d59cdf1d3f551fae21f6f0062258f
d8b00929dec65d422303256336ada04f	912d59cdf1d3f551fae21f6f0062258f
ea71b362e3ea9969db085abfccdeb10d	912d59cdf1d3f551fae21f6f0062258f
f01fc92b23faa973f3492a23d5a705c5	912d59cdf1d3f551fae21f6f0062258f
fa79c3005daec47ecff84a116a0927a1	912d59cdf1d3f551fae21f6f0062258f
76b88e7899abb3bfdd4b55b8c52726b0	912d59cdf1d3f551fae21f6f0062258f
560d4c6ff431c86546f3fcec72c748c7	912d59cdf1d3f551fae21f6f0062258f
06e415f918c577f07328a52e24f75d43	912d59cdf1d3f551fae21f6f0062258f
92468e8a62373add2b9caefddbcf1303	912d59cdf1d3f551fae21f6f0062258f
8189ecf686157db0c0274c1f49373318	912d59cdf1d3f551fae21f6f0062258f
8189ecf686157db0c0274c1f49373318	5ffec2d87ab548202f8b549af380913a
8189ecf686157db0c0274c1f49373318	aab422acb3d2334a6deca0e1495745c2
8189ecf686157db0c0274c1f49373318	2d8836190888267b97ce332cad2aa247
8189ecf686157db0c0274c1f49373318	154a67340e8c14dd5253dc4ff6120197
8189ecf686157db0c0274c1f49373318	f5cd262901883dff68d06b215fb0f28e
23b998b19b5f60dbbc4eedc53328b0c7	154a67340e8c14dd5253dc4ff6120197
e31959fe2842dacea4d16d36e9813620	f5cd262901883dff68d06b215fb0f28e
7755415a9fe7022060b98a689236ccd2	912d59cdf1d3f551fae21f6f0062258f
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
b67af931a5d0322adc7d56846dca86dc	Leipzig (Felsenkeller / Naumanns)
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
827250c5a7445093119fab43fb959d04	Leipzig (Westbad)
fb5fce8ee7e869a708fa21aba0b8ebbf	Leipzig (Heidnisches Dorf)
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
\.


--
-- Data for Name: bands_countries; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.bands_countries (id_band, id_country) FROM stdin;
8b427a493fc39574fc801404bc032a2f	6b718641741f992e68ec3712718561b8
721c28f4c74928cc9e0bb3fef345e408	6c1674d14bf5f95742f572cddb0641a7
0a7ba3f35a9750ff956dca1d548dad12	d8b00929dec65d422303256336ada04f
54b72f3169fea84731d3bcba785eac49	d8b00929dec65d422303256336ada04f
d05a0e65818a69cc689b38c0c0007834	d8b00929dec65d422303256336ada04f
dcabc7299e2b9ed5b05c33273e5fdd19	d8b00929dec65d422303256336ada04f
5ce10014f645da4156ddd2cd0965986e	f75d91cdd36b85cc4a8dfeca4f24fa14
a332f1280622f9628fccd1b7aac7370a	d8b00929dec65d422303256336ada04f
249789ae53c239814de8e606ff717ec9	1007e1b7f894dfbf72a0eaa80f3bc57e
b1bdad87bd3c4ac2c22473846d301a9e	d8b00929dec65d422303256336ada04f
fe5b73c2c2cd2d9278c3835c791289b6	d8b00929dec65d422303256336ada04f
942c9f2520684c22eb6216a92b711f9e	c8f4261f9f46e6465709e17ebea7a92b
7cd7921da2e6aab79c441a0c2ffc969b	6f781c6559a0c605da918096bdb69edf
948098e746bdf1c1045c12f042ea98c2	ea71b362e3ea9969db085abfccdeb10d
59d153c1c2408b702189623231b7898a	907eba32d950bfab68227fd7ea22999b
06efe152a554665e02b8dc4f620bf3f1	f75d91cdd36b85cc4a8dfeca4f24fa14
14ab730fe0172d780da6d9e5d432c129	d8b00929dec65d422303256336ada04f
449b4d758aa7151bc1bbb24c3ffb40bb	33cac763789c407f405b2cf0dce7df89
5df92b70e2855656e9b3ffdf313d7379	c8f4261f9f46e6465709e17ebea7a92b
3e75cd2f2f6733ea4901458a7ce4236d	fa79c3005daec47ecff84a116a0927a1
108c58fc39b79afc55fac7d9edf4aa2a	c8f4261f9f46e6465709e17ebea7a92b
28bc31b338dbd482802b77ed1fd82a50	d8b00929dec65d422303256336ada04f
49c4097bae6c6ea96f552e38cfb6c2d1	424214945ba5615eca039bfe5d731c09
e3f0bf612190af6c3fad41214115e004	76423d8352c9e8fc8d7d65f62c55eae9
fb47f889f2c7c4fee1553d0f817b8aaa	a67d4cbdd1b59e0ffccc6bafc83eb033
264721f3fc2aee2d28dadcdff432dbc1	d8b00929dec65d422303256336ada04f
9a322166803a48932356586f05ef83c7	c8f4261f9f46e6465709e17ebea7a92b
75ab0270163731ee05f35640d56ef473	d5b9290a0b67727d4ba1ca6059dc31a6
9d3ac6904ce73645c6234803cd7e47ca	d8b00929dec65d422303256336ada04f
d1fb4e47d8421364f49199ee395ad1d3	4442e4af0916f53a07fb8ca9a49b98ed
44012166c6633196dc30563db3ffd017	d8b00929dec65d422303256336ada04f
905a40c3533830252a909603c6fa1e6a	907eba32d950bfab68227fd7ea22999b
aed85c73079b54830cd50a75c0958a90	d8b00929dec65d422303256336ada04f
da2110633f62b16a571c40318e4e4c1c	d8b00929dec65d422303256336ada04f
529a1d385b4a8ca97ea7369477c7b6a7	6f781c6559a0c605da918096bdb69edf
d3ed8223151e14b936436c336a4c7278	94880bda83bda77c5692876700711f15
ce2caf05154395724e4436f042b8fa53	d8b00929dec65d422303256336ada04f
be20385e18333edb329d4574f364a1f0	94880bda83bda77c5692876700711f15
ee69e7d19f11ca58843ec2e9e77ddb38	76423d8352c9e8fc8d7d65f62c55eae9
925bd435e2718d623768dbf1bc1cfb60	0309a6c666a7a803fdb9db95de71cf01
ad01952b3c254c8ebefaf6f73ae62f7d	d8b00929dec65d422303256336ada04f
7c7ab6fbcb47bd5df1e167ca28220ee9	0309a6c666a7a803fdb9db95de71cf01
e8afde257f8a2cbbd39d866ddfc06103	9891739094756d2605946c867b32ad28
8f1f10cb698cb995fd69a671af6ecd58	f75d91cdd36b85cc4a8dfeca4f24fa14
bbddc022ee323e0a2b2d8c67e5cd321f	d8b00929dec65d422303256336ada04f
74b3b7be6ed71b946a151d164ad8ede5	76423d8352c9e8fc8d7d65f62c55eae9
d9ab6b54c3bd5b212e8dc3a14e7699ef	d8b00929dec65d422303256336ada04f
679eaa47efb2f814f2642966ee6bdfe1	d8b00929dec65d422303256336ada04f
e1db3add02ca4c1af33edc5a970a3bdc	d8b00929dec65d422303256336ada04f
1c6987adbe5ab3e4364685e8caed0f59	c8f4261f9f46e6465709e17ebea7a92b
cf4ee20655dd3f8f0a553c73ffe3f72a	d8b00929dec65d422303256336ada04f
348bcdb386eb9cb478b55a7574622b7c	a67d4cbdd1b59e0ffccc6bafc83eb033
b3ffff8517114caf70b9e70734dbaf6f	6f781c6559a0c605da918096bdb69edf
a4cbfb212102da21b82d94be555ac3ec	d5b9290a0b67727d4ba1ca6059dc31a6
10d91715ea91101cfe0767c812da8151	d8b00929dec65d422303256336ada04f
1209f43dbecaba22f3514bf40135f991	d8b00929dec65d422303256336ada04f
dcff9a127428ffb03fc02fdf6cc39575	d8b00929dec65d422303256336ada04f
6c00bb1a64f660600a6c1545377f92dc	d5b9290a0b67727d4ba1ca6059dc31a6
55159d04cc4faebd64689d3b74a94009	76423d8352c9e8fc8d7d65f62c55eae9
b6da055500e3d92698575a3cfc74906c	a67d4cbdd1b59e0ffccc6bafc83eb033
1e9413d4cc9af0ad12a6707776573ba0	d8b00929dec65d422303256336ada04f
b01fbaf98cfbc1b72e8bca0b2e48769c	d8b00929dec65d422303256336ada04f
4b98a8c164586e11779a0ef9421ad0ee	d8b00929dec65d422303256336ada04f
897edb97d775897f69fa168a88b01c19	445d337b5cd5de476f99333df6b0c2a7
eeaeec364c925e0c821660c7a953546e	76423d8352c9e8fc8d7d65f62c55eae9
7533f96ec01fd81438833f71539c7d4e	c8f4261f9f46e6465709e17ebea7a92b
11635778f116ce6922f6068638a39028	f75d91cdd36b85cc4a8dfeca4f24fa14
d449a9b2eed8b0556dc7be9cda36b67b	76423d8352c9e8fc8d7d65f62c55eae9
7eaf9a47aa47f3c65595ae107feab05d	d8b00929dec65d422303256336ada04f
7463543d784aa59ca86359a50ef58c8e	76423d8352c9e8fc8d7d65f62c55eae9
c4f0f5cedeffc6265ec3220ab594d56b	c8f4261f9f46e6465709e17ebea7a92b
63bd9a49dd18fbc89c2ec1e1b689ddda	f75d91cdd36b85cc4a8dfeca4f24fa14
63ae1791fc0523f47bea9485ffec8b8c	a67d4cbdd1b59e0ffccc6bafc83eb033
c4c7cb77b45a448aa3ca63082671ad97	3ad08396dc5afa78f34f548eea3c1d64
5435326cf392e2cd8ad7768150cd5df6	6c1674d14bf5f95742f572cddb0641a7
828d51c39c87aad9b1407d409fa58e36	d8b00929dec65d422303256336ada04f
d2ff1e521585a91a94fb22752dd0ab45	d8b00929dec65d422303256336ada04f
77f2b3ea9e4bd785f5ff322bae51ba07	6f781c6559a0c605da918096bdb69edf
6f199e29c5782bd05a4fef98e7e41419	3ad08396dc5afa78f34f548eea3c1d64
b0ce1e93de9839d07dab8d268ca23728	d8b00929dec65d422303256336ada04f
6830afd7158930ca7d1959ce778eb681	d5b9290a0b67727d4ba1ca6059dc31a6
a61b878c2b563f289de2109fa0f42144	76423d8352c9e8fc8d7d65f62c55eae9
e67e51d5f41cfc9162ef7fd977d1f9f5	f75d91cdd36b85cc4a8dfeca4f24fa14
3d2ff8abd980d730b2f4fd0abae52f60	f75d91cdd36b85cc4a8dfeca4f24fa14
ffa7450fd138573d8ae665134bccd02c	6f781c6559a0c605da918096bdb69edf
faabbecd319372311ed0781d17b641d1	445d337b5cd5de476f99333df6b0c2a7
51fa80e44b7555c4130bd06c53f4835c	76423d8352c9e8fc8d7d65f62c55eae9
9f19396638dd8111f2cee938fdf4e455	d8b00929dec65d422303256336ada04f
fdcbfded0aaf369d936a70324b39c978	d8b00929dec65d422303256336ada04f
47b23e889175dde5d6057db61cb52847	f75d91cdd36b85cc4a8dfeca4f24fa14
1056b63fdc3c5015cc4591aa9989c14f	d8b00929dec65d422303256336ada04f
b5d9c5289fe97968a5634b3e138bf9e2	445d337b5cd5de476f99333df6b0c2a7
2876f7ecdae220b3c0dcb91ff13d0590	d8b00929dec65d422303256336ada04f
1734b04cf734cb291d97c135d74b4b87	d8b00929dec65d422303256336ada04f
7d6b45c02283175f490558068d1fc81b	0309a6c666a7a803fdb9db95de71cf01
8d7a18d54e82fcfb7a11566ce94b9109	d8b00929dec65d422303256336ada04f
dddb04bc0d058486d0ef0212c6ea0682	0309a6c666a7a803fdb9db95de71cf01
0e2ea6aa669710389cf4d6e2ddf408c4	d8b00929dec65d422303256336ada04f
63ad3072dc5472bb44c2c42ede26d90f	d8b00929dec65d422303256336ada04f
2aae4f711c09481c8353003202e05359	d8b00929dec65d422303256336ada04f
28f843fa3a493a3720c4c45942ad970e	d8b00929dec65d422303256336ada04f
9bc2ca9505a273b06aa0b285061cd1de	6b718641741f992e68ec3712718561b8
9138c2cc0326412f2515623f4c850eb3	d8b00929dec65d422303256336ada04f
44b7bda13ac1febe84d8607ca8bbf439	f75d91cdd36b85cc4a8dfeca4f24fa14
d857ab11d383a7e4d4239a54cbf2a63d	d8b00929dec65d422303256336ada04f
c74b5aa120021cbe18dcddd70d8622da	9891739094756d2605946c867b32ad28
3af7c6d148d216f13f66669acb8d5c59	d8b00929dec65d422303256336ada04f
522b6c44eb0aedf4970f2990a2f2a812	94880bda83bda77c5692876700711f15
f4219e8fec02ce146754a5be8a85f246	d8b00929dec65d422303256336ada04f
c5f022ef2f3211dc1e3b8062ffe764f0	3ad08396dc5afa78f34f548eea3c1d64
0ab20b5ad4d15b445ed94fa4eebb18d8	d8b00929dec65d422303256336ada04f
7fc454efb6df96e012e0f937723d24aa	d8b00929dec65d422303256336ada04f
8edfa58b1aedb58629b80e5be2b2bd92	d8b00929dec65d422303256336ada04f
8589a6a4d8908d7e8813e9a1c5693d70	f75d91cdd36b85cc4a8dfeca4f24fa14
947ce14614263eab49f780d68555aef8	c8f4261f9f46e6465709e17ebea7a92b
7c83727aa466b3b1b9d6556369714fcf	33cac763789c407f405b2cf0dce7df89
71e32909a1bec1edfc09aec09ca2ac17	06630c890abadde9228ea818ce52b621
3d01ff8c75214314c4ca768c30e6807b	d8b00929dec65d422303256336ada04f
7771012413f955f819866e517b275cb4	0309a6c666a7a803fdb9db95de71cf01
36f969b6aeff175204078b0533eae1a0	4442e4af0916f53a07fb8ca9a49b98ed
1bc1f7348d79a353ea4f594de9dd1392	f75d91cdd36b85cc4a8dfeca4f24fa14
2082a7d613f976e7b182a3fe80a28958	d5b9290a0b67727d4ba1ca6059dc31a6
d9bc1db8c13da3a131d853237e1f05b2	d8b00929dec65d422303256336ada04f
9cf73d0300eea453f17c6faaeb871c55	d8b00929dec65d422303256336ada04f
4dddd8579760abb62aa4b1910725e73c	a67d4cbdd1b59e0ffccc6bafc83eb033
d6de9c99f5cfa46352b2bc0be5c98c41	d8b00929dec65d422303256336ada04f
5194c60496c6f02e8b169de9a0aa542c	d8b00929dec65d422303256336ada04f
8654991720656374d632a5bb0c20ff11	d8b00929dec65d422303256336ada04f
6a0e9ce4e2da4f2cbcd1292fddaa0ac6	f75d91cdd36b85cc4a8dfeca4f24fa14
fe228019addf1d561d0123caae8d1e52	d8b00929dec65d422303256336ada04f
1104831a0d0fe7d2a6a4198c781e0e0d	d8b00929dec65d422303256336ada04f
889aaf9cd0894206af758577cf5cf071	76423d8352c9e8fc8d7d65f62c55eae9
410d913416c022077c5c1709bf104d3c	d8b00929dec65d422303256336ada04f
c5dc33e23743fb951b3fe7f1f477b794	d5b9290a0b67727d4ba1ca6059dc31a6
97ee29f216391d19f8769f79a1218a71	d8b00929dec65d422303256336ada04f
b885447285ece8226facd896c04cdba2	fa79c3005daec47ecff84a116a0927a1
3614c45db20ee41e068c2ab7969eb3b5	9891739094756d2605946c867b32ad28
c4ddbffb73c1c34d20bd5b3f425ce4b1	1007e1b7f894dfbf72a0eaa80f3bc57e
f07c3eef5b7758026d45a12c7e2f6134	d8b00929dec65d422303256336ada04f
9d969d25c9f506c5518bb090ad5f8266	6b718641741f992e68ec3712718561b8
0b6e98d660e2901c33333347da37ad36	3ad08396dc5afa78f34f548eea3c1d64
6d3b28f48c848a21209a84452d66c0c4	d8b00929dec65d422303256336ada04f
8c69497eba819ee79a964a0d790368fb	d8b00929dec65d422303256336ada04f
1197a69404ee9475146f3d631de12bde	d8b00929dec65d422303256336ada04f
d730e65d54d6c0479561d25724afd813	c8f4261f9f46e6465709e17ebea7a92b
457f098eeb8e1518008449e9b1cb580d	1007e1b7f894dfbf72a0eaa80f3bc57e
ac94d15f46f10707a39c4bc513cd9f98	f75d91cdd36b85cc4a8dfeca4f24fa14
37f02eba79e0a3d29dfd6a4cf2f4d019	a67d4cbdd1b59e0ffccc6bafc83eb033
39e83bc14e95fcbc05848fc33c30821f	51802d8bb965d0e5be697f07d16922e8
f0c051b57055b052a3b7da1608f3039e	d8b00929dec65d422303256336ada04f
e08383c479d96a8a762e23a99fd8bf84	c8f4261f9f46e6465709e17ebea7a92b
ff5b48d38ce7d0c47c57555d4783a118	d8b00929dec65d422303256336ada04f
8945663993a728ab19a3853e5b820a42	6c1674d14bf5f95742f572cddb0641a7
28a95ef0eabe44a27f49bbaecaa8a847	f75d91cdd36b85cc4a8dfeca4f24fa14
0cdf051c93865faa15cbc5cd3d2b69fb	f75d91cdd36b85cc4a8dfeca4f24fa14
ade72e999b4e78925b18cf48d1faafa4	d8b00929dec65d422303256336ada04f
4b503a03f3f1aec6e5b4d53dd8148498	6542f875eaa09a5c550e5f3986400ad9
887d6449e3544dca547a2ddba8f2d894	d8b00929dec65d422303256336ada04f
2672777b38bc4ce58c49cf4c82813a42	d8b00929dec65d422303256336ada04f
832dd1d8efbdb257c2c7d3e505142f48	d8b00929dec65d422303256336ada04f
f37ab058561fb6d233b9c2a0b080d4d1	d8b00929dec65d422303256336ada04f
3be3e956aeb5dc3b16285463e02af25b	d8b00929dec65d422303256336ada04f
42563d0088d6ac1a47648fc7621e77c6	d8b00929dec65d422303256336ada04f
7df8865bbec157552b8a579e0ed9bfe3	f75d91cdd36b85cc4a8dfeca4f24fa14
c883319a1db14bc28eff8088c5eba10e	d8b00929dec65d422303256336ada04f
6b7cf117ecf0fea745c4c375c1480cb5	d8b00929dec65d422303256336ada04f
187ebdf7947f4b61e0725c93227676a4	1007e1b7f894dfbf72a0eaa80f3bc57e
4276250c9b1b839b9508825303c5c5ae	d8b00929dec65d422303256336ada04f
7462f03404f29ea618bcc9d52de8e647	d8b00929dec65d422303256336ada04f
5efb7d24387b25d8325839be958d9adf	d8b00929dec65d422303256336ada04f
9db9bc745a7568b51b3a968d215ddad6	c8f4261f9f46e6465709e17ebea7a92b
cddf835bea180bd14234a825be7a7a82	a67d4cbdd1b59e0ffccc6bafc83eb033
fdc90583bd7a58b91384dea3d1659cde	0309a6c666a7a803fdb9db95de71cf01
401357e57c765967393ba391a338e89b	c8f4261f9f46e6465709e17ebea7a92b
e64b94f14765cee7e05b4bec8f5fee31	a67d4cbdd1b59e0ffccc6bafc83eb033
d0a1fd0467dc892f0dc27711637c864e	a67d4cbdd1b59e0ffccc6bafc83eb033
e271e871e304f59e62a263ffe574ea2d	d8b00929dec65d422303256336ada04f
a8d9eeed285f1d47836a5546a280a256	d8b00929dec65d422303256336ada04f
abbf8e3e3c3e78be8bd886484c1283c1	d8b00929dec65d422303256336ada04f
87f44124fb8d24f4c832138baede45c7	c8f4261f9f46e6465709e17ebea7a92b
ed24ff8971b1fa43a1efbb386618ce35	c8f4261f9f46e6465709e17ebea7a92b
33b6f1b596a60fa87baef3d2c05b7c04	6f781c6559a0c605da918096bdb69edf
426fdc79046e281c5322161f011ce68c	907eba32d950bfab68227fd7ea22999b
988d10abb9f42e7053450af19ad64c7f	d8b00929dec65d422303256336ada04f
dd18fa7a5052f2bce8ff7cb4a30903ea	51802d8bb965d0e5be697f07d16922e8
b89e91ccf14bfd7f485dd7be7d789b0a	f75d91cdd36b85cc4a8dfeca4f24fa14
87ded0ea2f4029da0a0022000d59232b	4442e4af0916f53a07fb8ca9a49b98ed
2a024edafb06c7882e2e1f7b57f2f951	d8b00929dec65d422303256336ada04f
2fa2f1801dd37d6eb9fe4e34a782e397	d8b00929dec65d422303256336ada04f
e0c2b0cc2e71294cd86916807fef62cb	d8b00929dec65d422303256336ada04f
52ee4c6902f6ead006b0fb2f3e2d7771	d8b00929dec65d422303256336ada04f
4f48e858e9ed95709458e17027bb94bf	76423d8352c9e8fc8d7d65f62c55eae9
e0de9c10bbf73520385ea5dcbdf62073	f75d91cdd36b85cc4a8dfeca4f24fa14
065b56757c6f6a0fba7ab0c64e4c1ae1	f75d91cdd36b85cc4a8dfeca4f24fa14
952dc6362e304f00575264e9d54d1fa6	d8b00929dec65d422303256336ada04f
5cd1c3c856115627b4c3e93991f2d9cd	f75d91cdd36b85cc4a8dfeca4f24fa14
0903a7e60f0eb20fdc8cc0b8dbd45526	1007e1b7f894dfbf72a0eaa80f3bc57e
32af59a47b8c7e1c982ae797fc491180	d8b00929dec65d422303256336ada04f
fb8be6409408481ad69166324bdade9c	f01fc92b23faa973f3492a23d5a705c5
bd4184ee062e4982b878b6b188793f5b	76423d8352c9e8fc8d7d65f62c55eae9
0020f19414b5f2874a0bfacd9d511b84	d8b00929dec65d422303256336ada04f
de12bbf91bc797df25ab4ae9cee1946b	d8b00929dec65d422303256336ada04f
237e378c239b44bff1e9a42ab866580c	1007e1b7f894dfbf72a0eaa80f3bc57e
89adcf990042dfdac7fd23685b3f1e37	d8b00929dec65d422303256336ada04f
44f2dc3400ce17fad32a189178ae72fa	ea71b362e3ea9969db085abfccdeb10d
3bd94845163385cecefc5265a2e5a525	d8b00929dec65d422303256336ada04f
0b0d1c3752576d666c14774b8233889f	4442e4af0916f53a07fb8ca9a49b98ed
a4902fb3d5151e823c74dfd51551b4b0	c8f4261f9f46e6465709e17ebea7a92b
99bd5eff92fc3ba728a9da5aa1971488	d8b00929dec65d422303256336ada04f
24ff2b4548c6bc357d9d9ab47882661e	d8b00929dec65d422303256336ada04f
776da10f7e18ffde35ea94d144dc60a3	c8f4261f9f46e6465709e17ebea7a92b
829922527f0e7d64a3cfda67e24351e3	d8b00929dec65d422303256336ada04f
bfc9ace5d2a11fae56d038d68c601f00	f75d91cdd36b85cc4a8dfeca4f24fa14
443866d78de61ab3cd3e0e9bf97a34f6	9891739094756d2605946c867b32ad28
b570e354b7ebc40e20029fcc7a15e5a7	f75d91cdd36b85cc4a8dfeca4f24fa14
7492a1ca2669793b485b295798f5d782	424214945ba5615eca039bfe5d731c09
63d7f33143522ba270cb2c87f724b126	424214945ba5615eca039bfe5d731c09
aa86b6fc103fc757e14f03afe6eb0c0a	d8b00929dec65d422303256336ada04f
6c607fc8c0adc99559bc14e01170fee1	f75d91cdd36b85cc4a8dfeca4f24fa14
91a337f89fe65fec1c97f52a821c1178	76423d8352c9e8fc8d7d65f62c55eae9
5ec1e9fa36898eaf6d1021be67e0d00c	d8b00929dec65d422303256336ada04f
8ce896355a45f5b9959eb676b8b5580c	d8b00929dec65d422303256336ada04f
bbce8e45250a239a252752fac7137e00	c8f4261f9f46e6465709e17ebea7a92b
baa9d4eef21c7b89f42720313b5812d4	76423d8352c9e8fc8d7d65f62c55eae9
2414366fe63cf7017444181acacb6347	0309a6c666a7a803fdb9db95de71cf01
1ac0c8e8c04cf2d6f02fdb8292e74588	9891739094756d2605946c867b32ad28
5f992768f7bb9592bed35b07197c87d0	d8b00929dec65d422303256336ada04f
ca5a010309ffb20190558ec20d97e5b2	d5b9290a0b67727d4ba1ca6059dc31a6
f644bd92037985f8eb20311bc6d5ed94	d8b00929dec65d422303256336ada04f
a825b2b87f3b61c9660b81f340f6e519	0309a6c666a7a803fdb9db95de71cf01
891a55e21dfacf2f97c450c77e7c3ea7	f75d91cdd36b85cc4a8dfeca4f24fa14
ef6369d9794dbe861a56100e92a3c71d	c8f4261f9f46e6465709e17ebea7a92b
73affe574e6d4dc2fa72b46dc9dd4815	f01fc92b23faa973f3492a23d5a705c5
649db5c9643e1c17b3a44579980da0ad	a67d4cbdd1b59e0ffccc6bafc83eb033
1e8563d294da81043c2772b36753efaf	d8b00929dec65d422303256336ada04f
362f8cdd1065b0f33e73208eb358991d	d8b00929dec65d422303256336ada04f
820de5995512273916b117944d6da15a	445d337b5cd5de476f99333df6b0c2a7
6d57b25c282247075f5e03cde27814df	d8b00929dec65d422303256336ada04f
bbb668ff900efa57d936e726a09e4fe8	6f781c6559a0c605da918096bdb69edf
2501f7ba78cc0fd07efb7c17666ff12e	a67d4cbdd1b59e0ffccc6bafc83eb033
76700087e932c3272e05694610d604ba	6c1674d14bf5f95742f572cddb0641a7
9b1088b616414d0dc515ab1f2b4922f1	d8b00929dec65d422303256336ada04f
dfdef9b5190f331de20fe029babf032e	d8b00929dec65d422303256336ada04f
4cfab0d66614c6bb6d399837656c590e	a67d4cbdd1b59e0ffccc6bafc83eb033
5b22d1d5846a2b6b6d0cf342e912d124	d8b00929dec65d422303256336ada04f
4261335bcdc95bd89fd530ba35afbf4c	d8b00929dec65d422303256336ada04f
2cfe35095995e8dd15ab7b867e178c15	0309a6c666a7a803fdb9db95de71cf01
2cf65e28c586eeb98daaecf6eb573e7a	6f781c6559a0c605da918096bdb69edf
3cdb47307aeb005121b09c41c8d8bee6	d8b00929dec65d422303256336ada04f
53407737e93f53afdfc588788b8288e8	d8b00929dec65d422303256336ada04f
006fc2724417174310cf06d2672e34d2	d8b00929dec65d422303256336ada04f
7db066b46f48d010fdb8c87337cdeda4	f75d91cdd36b85cc4a8dfeca4f24fa14
a3f5542dc915b94a5e10dab658bb0959	c8f4261f9f46e6465709e17ebea7a92b
2ac79000a90b015badf6747312c0ccad	d8b00929dec65d422303256336ada04f
eb2c788da4f36fba18b85ae75aff0344	c8f4261f9f46e6465709e17ebea7a92b
626dceb92e4249628c1e76a2c955cd24	d8b00929dec65d422303256336ada04f
8fda25275801e4a40df6c73078baf753	d5b9290a0b67727d4ba1ca6059dc31a6
3a2a7f86ca87268be9b9e0557b013565	d8b00929dec65d422303256336ada04f
ac03fad3be179a237521ec4ef2620fb0	d8b00929dec65d422303256336ada04f
8b0ee5a501cef4a5699fd3b2d4549e8f	f75d91cdd36b85cc4a8dfeca4f24fa14
7e2b83d69e6c93adf203e13bc7d6f444	d8b00929dec65d422303256336ada04f
0fbddeb130361265f1ba6f86b00f0968	d8b00929dec65d422303256336ada04f
3f15c445cb553524b235b01ab75fe9a6	f75d91cdd36b85cc4a8dfeca4f24fa14
656d1497f7e25fe0559c6be81a4bccae	f75d91cdd36b85cc4a8dfeca4f24fa14
f60ab90d94b9cafe6b32f6a93ee8fcda	f75d91cdd36b85cc4a8dfeca4f24fa14
8775f64336ee5e9a8114fbe3a5a628c5	424214945ba5615eca039bfe5d731c09
e872b77ff7ac24acc5fa373ebe9bb492	8dbb07a18d46f63d8b3c8994d5ccc351
f0e1f32b93f622ea3ddbf6b55b439812	d8b00929dec65d422303256336ada04f
53a0aafa942245f18098ccd58b4121aa	d8b00929dec65d422303256336ada04f
0780d2d1dbd538fec3cdd8699b08ea02	d8b00929dec65d422303256336ada04f
4a45ac6d83b85125b4163a40364e7b2c	ea71b362e3ea9969db085abfccdeb10d
58db028cf01dd425e5af6c7d511291c1	d8b00929dec65d422303256336ada04f
2252d763a2a4ac815b122a0176e3468f	d8b00929dec65d422303256336ada04f
11d396b078f0ae37570c8ef0f45937ad	d8b00929dec65d422303256336ada04f
585b13106ecfd7ede796242aeaed4ea8	d8b00929dec65d422303256336ada04f
6c1fcd3c91bc400e5c16f467d75dced3	d8b00929dec65d422303256336ada04f
a7f9797e4cd716e1516f9d4845b0e1e2	f75d91cdd36b85cc4a8dfeca4f24fa14
7d878673694ff2498fbea0e5ba27e0ea	d8b00929dec65d422303256336ada04f
0844ad55f17011abed4a5208a3a05b74	76423d8352c9e8fc8d7d65f62c55eae9
6738f9acd4740d945178c649d6981734	6c1674d14bf5f95742f572cddb0641a7
33f03dd57f667d41ac77c6baec352a81	d8b00929dec65d422303256336ada04f
3509af6be9fe5defc1500f5c77e38563	d8b00929dec65d422303256336ada04f
0640cfbf1d269b69c535ea4e288dfd96	d8b00929dec65d422303256336ada04f
a716390764a4896d99837e99f9e009c9	42537f0fb56e31e20ab9c2305752087d
e74a88c71835c14d92d583a1ed87cc6c	c8f4261f9f46e6465709e17ebea7a92b
3d6ff25ab61ad55180a6aee9b64515bf	f75d91cdd36b85cc4a8dfeca4f24fa14
36648510adbf2a3b2028197a60b5dada	d8b00929dec65d422303256336ada04f
eb3bfb5a3ccdd4483aabc307ae236066	d8b00929dec65d422303256336ada04f
1ebd63d759e9ff532d5ce63ecb818731	d8b00929dec65d422303256336ada04f
1c06fc6740d924cab33dce73643d84b9	4442e4af0916f53a07fb8ca9a49b98ed
4a2a0d0c29a49d9126dcb19230aa1994	0309a6c666a7a803fdb9db95de71cf01
059792b70fc0686fb296e7fcae0bda50	d8b00929dec65d422303256336ada04f
7dfe9aa0ca5bb31382879ccd144cc3ae	d8b00929dec65d422303256336ada04f
a650d82df8ca65bb69a45242ab66b399	6f781c6559a0c605da918096bdb69edf
3dda886448fe98771c001b56a4da9893	3ad08396dc5afa78f34f548eea3c1d64
d73310b95e8b4dece44e2a55dd1274e6	c8f4261f9f46e6465709e17ebea7a92b
fb28e62c0e801a787d55d97615e89771	d8b00929dec65d422303256336ada04f
652208d2aa8cdd769632dbaeb7a16358	d8b00929dec65d422303256336ada04f
660813131789b822f0c75c667e23fc85	f75d91cdd36b85cc4a8dfeca4f24fa14
b5f7b25b0154c34540eea8965f90984d	d5b9290a0b67727d4ba1ca6059dc31a6
a7a9c1b4e7f10bd1fdf77aff255154f7	f75d91cdd36b85cc4a8dfeca4f24fa14
e64d38b05d197d60009a43588b2e4583	76423d8352c9e8fc8d7d65f62c55eae9
88711444ece8fe638ae0fb11c64e2df3	76423d8352c9e8fc8d7d65f62c55eae9
278c094627c0dd891d75ea7a3d0d021e	d8b00929dec65d422303256336ada04f
0a56095b73dcbd2a76bb9d4831881cb3	d8b00929dec65d422303256336ada04f
ff578d3db4dc3311b3098c8365d54e6b	d8b00929dec65d422303256336ada04f
80fcd08f6e887f6cfbedd2156841ab2b	0309a6c666a7a803fdb9db95de71cf01
db38e12f9903b156f9dc91fce2ef3919	5feb168ca8fb495dcc89b1208cdeb919
90d127641ffe2a600891cd2e3992685b	3ad08396dc5afa78f34f548eea3c1d64
2e7a848dc99bd27acb36636124855faf	0c7d5ae44b2a0be9ebd7d6b9f7d60f20
79566192cda6b33a9ff59889eede2d66	f75d91cdd36b85cc4a8dfeca4f24fa14
3964d4f40b6166aa9d370855bd20f662	9891739094756d2605946c867b32ad28
4548a3b9c1e31cf001041dc0d166365b	d8b00929dec65d422303256336ada04f
450948d9f14e07ba5e3015c2d726b452	3ad08396dc5afa78f34f548eea3c1d64
c4678a2e0eef323aeb196670f2bc8a6e	a67d4cbdd1b59e0ffccc6bafc83eb033
c1923ca7992dc6e79d28331abbb64e72	4442e4af0916f53a07fb8ca9a49b98ed
5842a0c2470fe12ee3acfeec16c79c57	d8b00929dec65d422303256336ada04f
96682d9c9f1bed695dbf9176d3ee234c	d8b00929dec65d422303256336ada04f
7f29efc2495ce308a8f4aa7bfc11d701	f75d91cdd36b85cc4a8dfeca4f24fa14
12e93f5fab5f7d16ef37711ef264d282	d8b00929dec65d422303256336ada04f
4094ffd492ba473a2a7bea1b19b1662d	d8b00929dec65d422303256336ada04f
6429807f6febbf061ac85089a8c3173d	c8f4261f9f46e6465709e17ebea7a92b
02d44fbbe1bfacd6eaa9b20299b1cb78	a67d4cbdd1b59e0ffccc6bafc83eb033
9ab8f911c74597493400602dc4d2b412	d8b00929dec65d422303256336ada04f
11f8d9ec8f6803ea61733840f13bc246	6542f875eaa09a5c550e5f3986400ad9
54f0b93fa83225e4a712b70c68c0ab6f	d8b00929dec65d422303256336ada04f
1cdd53cece78d6e8dffcf664fa3d1be2	d8b00929dec65d422303256336ada04f
1e88302efcfc873691f0c31be4e2a388	d8b00929dec65d422303256336ada04f
2af9e4497582a6faa68a42ac2d512735	f75d91cdd36b85cc4a8dfeca4f24fa14
13caf3d14133dfb51067264d857eaf70	d8b00929dec65d422303256336ada04f
1e14d6b40d8e81d8d856ba66225dcbf3	2ff6e535bd2f100979a171ad430e642b
5b20ea1312a1a21beaa8b86fe3a07140	f75d91cdd36b85cc4a8dfeca4f24fa14
fa03eb688ad8aa1db593d33dabd89bad	51802d8bb965d0e5be697f07d16922e8
7a4fafa7badd04d5d3114ab67b0caf9d	d8b00929dec65d422303256336ada04f
4cabe475dd501f3fd4da7273b5890c33	3ad08396dc5afa78f34f548eea3c1d64
f8e7112b86fcd9210dfaf32c00d6d375	76423d8352c9e8fc8d7d65f62c55eae9
91c9ed0262dea7446a4f3a3e1cdd0698	6f781c6559a0c605da918096bdb69edf
79ce9bd96a3184b1ee7c700aa2927e67	6c1674d14bf5f95742f572cddb0641a7
218f2bdae8ad3bb60482b201e280ffdc	76423d8352c9e8fc8d7d65f62c55eae9
4927f3218b038c780eb795766dfd04ee	d8b00929dec65d422303256336ada04f
0a97b893b92a7df612eadfe97589f242	d8b00929dec65d422303256336ada04f
31d8a0a978fad885b57a685b1a0229df	9891739094756d2605946c867b32ad28
7ef36a3325a61d4f1cff91acbe77c7e3	d8b00929dec65d422303256336ada04f
5b709b96ee02a30be5eee558e3058245	42537f0fb56e31e20ab9c2305752087d
19baf8a6a25030ced87cd0ce733365a9	ea71b362e3ea9969db085abfccdeb10d
4ee21b1371ba008a26b313c7622256f8	d8b00929dec65d422303256336ada04f
91b18e22d4963b216af00e1dd43b5d05	0309a6c666a7a803fdb9db95de71cf01
6bd19bad2b0168d4481b19f9c25b4a9f	1007e1b7f894dfbf72a0eaa80f3bc57e
53369c74c3cacdc38bdcdeda9284fe3c	5feb168ca8fb495dcc89b1208cdeb919
6bafe8cf106c32d485c469d36c056989	f75d91cdd36b85cc4a8dfeca4f24fa14
66599a31754b5ac2a202c46c2b577c8e	f75d91cdd36b85cc4a8dfeca4f24fa14
4453eb658c6a304675bd52ca75fbae6d	d8b00929dec65d422303256336ada04f
5e4317ada306a255748447aef73fff68	f75d91cdd36b85cc4a8dfeca4f24fa14
65976b6494d411d609160a2dfd98f903	76423d8352c9e8fc8d7d65f62c55eae9
360c000b499120147c8472998859a9fe	d8b00929dec65d422303256336ada04f
e62a773154e1179b0cc8c5592207cb10	445d337b5cd5de476f99333df6b0c2a7
4bb93d90453dd63cc1957a033f7855c7	d8b00929dec65d422303256336ada04f
121189969c46f49b8249633c2d5a7bfa	f75d91cdd36b85cc4a8dfeca4f24fa14
f29d276fd930f1ad7687ed7e22929b64	06630c890abadde9228ea818ce52b621
249229ca88aa4a8815315bb085cf4d61	f75d91cdd36b85cc4a8dfeca4f24fa14
c05d504b806ad065c9b548c0cb1334cd	d8b00929dec65d422303256336ada04f
b96a3cb81197e8308c87f6296174fe3e	d8b00929dec65d422303256336ada04f
8edf4531385941dfc85e3f3d3e32d24f	c8f4261f9f46e6465709e17ebea7a92b
90d523ebbf276f516090656ebfccdc9f	b78edab0f52e0d6c195fd0d8c5709d26
94ca28ea8d99549c2280bcc93f98c853	a67d4cbdd1b59e0ffccc6bafc83eb033
076365679712e4206301117486c3d0ec	f75d91cdd36b85cc4a8dfeca4f24fa14
abd7ab19ff758cf4c1a2667e5bbac444	51802d8bb965d0e5be697f07d16922e8
0af74c036db52f48ad6cbfef6fee2999	6f781c6559a0c605da918096bdb69edf
095849fbdc267416abc6ddb48be311d7	d8b00929dec65d422303256336ada04f
72778afd2696801f5f3a1f35d0e4e357	d8b00929dec65d422303256336ada04f
5c0adc906f34f9404d65a47eea76dac0	d8b00929dec65d422303256336ada04f
fdcf3cdc04f367257c92382e032b6293	d8b00929dec65d422303256336ada04f
8bc31f7cc79c177ab7286dda04e2d1e5	f75d91cdd36b85cc4a8dfeca4f24fa14
88dd124c0720845cba559677f3afa15d	d8b00929dec65d422303256336ada04f
2df8905eae6823023de6604dc5346c29	6b718641741f992e68ec3712718561b8
7e0d5240ec5d34a30b6f24909e5edcb4	f75d91cdd36b85cc4a8dfeca4f24fa14
f4f870098db58eeae93742dd2bcaf2b2	d8b00929dec65d422303256336ada04f
d433b7c1ce696b94a8d8f72de6cfbeaa	d8b00929dec65d422303256336ada04f
28bb59d835e87f3fd813a58074ca0e11	d8b00929dec65d422303256336ada04f
bbc155fb2b111bf61c4f5ff892915e6b	33cac763789c407f405b2cf0dce7df89
f953fa7b33e7b6503f4380895bbe41c8	f75d91cdd36b85cc4a8dfeca4f24fa14
cafe9e68e8f90b3e1328da8858695b31	d8b00929dec65d422303256336ada04f
ad62209fb63910acf40280cea3647ec5	d8b00929dec65d422303256336ada04f
0a267617c0b5b4d53e43a7d4e4c522ad	a67d4cbdd1b59e0ffccc6bafc83eb033
058fcf8b126253956deb3ce672d107a7	f75d91cdd36b85cc4a8dfeca4f24fa14
b14814d0ee12ffadc8f09ab9c604a9d0	f75d91cdd36b85cc4a8dfeca4f24fa14
5447110e1e461c8c22890580c796277a	f75d91cdd36b85cc4a8dfeca4f24fa14
9e84832a15f2698f67079a3224c2b6fb	d8b00929dec65d422303256336ada04f
4a7d9e528dada8409e88865225fb27c4	d8b00929dec65d422303256336ada04f
d3e98095eeccaa253050d67210ef02bb	d8b00929dec65d422303256336ada04f
c3490492512b7fe65cdb0c7305044675	d8b00929dec65d422303256336ada04f
e61e30572fd58669ae9ea410774e0eb6	d8b00929dec65d422303256336ada04f
990813672e87b667add44c712bb28d3d	ea71b362e3ea9969db085abfccdeb10d
8143ee8032c71f6f3f872fc5bb2a4fed	9891739094756d2605946c867b32ad28
485065ad2259054abf342d7ae3fe27e6	d8b00929dec65d422303256336ada04f
278606b1ac0ae7ef86e86342d1f259c3	d8b00929dec65d422303256336ada04f
a538bfe6fe150a92a72d78f89733dbd0	d8b00929dec65d422303256336ada04f
c127f32dc042184d12b8c1433a77e8c4	b78edab0f52e0d6c195fd0d8c5709d26
e4b3296f8a9e2a378eb3eb9576b91a37	2e6507f70a9cc26fb50f5fd82a83c7ef
09d8e20a5368ce1e5c421a04cb566434	d8b00929dec65d422303256336ada04f
4366d01be1b2ddef162fc0ebb6933508	d8b00929dec65d422303256336ada04f
46174766ce49edbbbc40e271c87b5a83	ef3388cc5659bccb742fb8af762f1bfd
4fa857a989df4e1deea676a43dceea07	d8b00929dec65d422303256336ada04f
36cbc41c1c121f2c68f5776a118ea027	6f781c6559a0c605da918096bdb69edf
da867941c8bacf9be8e59bc13d765f92	f75d91cdd36b85cc4a8dfeca4f24fa14
6ee2e6d391fa98d7990b502e72c7ec58	d8b00929dec65d422303256336ada04f
a4977b96c7e5084fcce21a0d07b045f8	c8f4261f9f46e6465709e17ebea7a92b
1da77fa5b97c17be83cc3d0693c405cf	f75d91cdd36b85cc4a8dfeca4f24fa14
e0f39406f0e15487dd9d3997b2f5ca61	d8b00929dec65d422303256336ada04f
399033f75fcf47d6736c9c5209222ab8	d8b00929dec65d422303256336ada04f
6f195d8f9fe09d45d2e680f7d7157541	b78edab0f52e0d6c195fd0d8c5709d26
2113f739f81774557041db616ee851e6	c8f4261f9f46e6465709e17ebea7a92b
32814ff4ca9a26b8d430a8c0bc8dc63e	d8b00929dec65d422303256336ada04f
e29ef4beb480eab906ffa7c05aeec23d	94880bda83bda77c5692876700711f15
2447873ddeeecaa165263091c0cbb22f	d8b00929dec65d422303256336ada04f
86482a1e94052aa18cd803a51104cdb9	f75d91cdd36b85cc4a8dfeca4f24fa14
fcd1c1b547d03e760d1defa4d2b98783	d8b00929dec65d422303256336ada04f
6369ba49db4cf35b35a7c47e3d4a4fd0	d8b00929dec65d422303256336ada04f
935b48a84528c4280ec208ce529deea0	76423d8352c9e8fc8d7d65f62c55eae9
52b133bfecec2fba79ecf451de3cf3bb	d8b00929dec65d422303256336ada04f
559ccea48c3460ebc349587d35e808dd	c8f4261f9f46e6465709e17ebea7a92b
8e11b2f987a99ed900a44aa1aa8bd3d0	a67d4cbdd1b59e0ffccc6bafc83eb033
59f06d56c38ac98effb4c6da117b0305	f75d91cdd36b85cc4a8dfeca4f24fa14
804803e43d2c779d00004a6e87f28e30	f75d91cdd36b85cc4a8dfeca4f24fa14
f042da2a954a1521114551a6f9e22c75	d8b00929dec65d422303256336ada04f
b1d465aaf3ccf8701684211b1623adf2	8189ecf686157db0c0274c1f49373318
4f840b1febbbcdb12b9517cd0a91e8f4	6c1674d14bf5f95742f572cddb0641a7
c2855b6617a1b08fed3824564e15a653	f75d91cdd36b85cc4a8dfeca4f24fa14
405c7f920b019235f244315a564a8aed	d8b00929dec65d422303256336ada04f
8e62fc75d9d0977d0be4771df05b3c2f	6f781c6559a0c605da918096bdb69edf
cd9483c1733b17f57d11a77c9404893c	f75d91cdd36b85cc4a8dfeca4f24fa14
3656edf3a40a25ccd00d414c9ecbb635	d8b00929dec65d422303256336ada04f
6d89517dbd1a634b097f81f5bdbb07a2	d8b00929dec65d422303256336ada04f
db46d9a37b31baa64cb51604a2e4939a	00247297c394dd443dc97067830c35f4
5af874093e5efcbaeb4377b84c5f2ec5	d8b00929dec65d422303256336ada04f
8a6f1a01e4b0d9e272126a8646a72088	6f781c6559a0c605da918096bdb69edf
5037c1968f3b239541c546d32dec39eb	d8b00929dec65d422303256336ada04f
3e52c77d795b7055eeff0c44687724a1	3ad08396dc5afa78f34f548eea3c1d64
5952dff7a6b1b3c94238ad3c6a42b904	f75d91cdd36b85cc4a8dfeca4f24fa14
deaccc41a952e269107cc9a507dfa131	d8b00929dec65d422303256336ada04f
bb4cc149e8027369e71eb1bb36cd98e0	f75d91cdd36b85cc4a8dfeca4f24fa14
754230e2c158107a2e93193c829e9e59	907eba32d950bfab68227fd7ea22999b
a29c1c4f0a97173007be3b737e8febcc	d8b00929dec65d422303256336ada04f
4fab532a185610bb854e0946f4def6a4	d8b00929dec65d422303256336ada04f
e25ee917084bdbdc8506b56abef0f351	0309a6c666a7a803fdb9db95de71cf01
e6fd7b62a39c109109d33fcd3b5e129d	d8b00929dec65d422303256336ada04f
da29e297c23e7868f1d50ec5a6a4359b	d8b00929dec65d422303256336ada04f
96048e254d2e02ba26f53edd271d3f88	d8b00929dec65d422303256336ada04f
c2275e8ac71d308946a63958bc7603a1	d8b00929dec65d422303256336ada04f
dde3e0b0cc344a7b072bbab8c429f4ff	42537f0fb56e31e20ab9c2305752087d
b785a5ffad5e7e36ccac25c51d5d8908	d8b00929dec65d422303256336ada04f
3bcbddf6c114327fc72ea06bcb02f9ef	8189ecf686157db0c0274c1f49373318
63c0a328ae2bee49789212822f79b83f	d8b00929dec65d422303256336ada04f
f03bde11d261f185cbacfa32c1c6538c	51802d8bb965d0e5be697f07d16922e8
f6540bc63be4c0cb21811353c0d24f69	a67d4cbdd1b59e0ffccc6bafc83eb033
e4f0ad5ef0ac3037084d8a5e3ca1cabc	a67d4cbdd1b59e0ffccc6bafc83eb033
ea16d031090828264793e860a00cc995	a67d4cbdd1b59e0ffccc6bafc83eb033
5eed658c4b7b68a0ecc49205b68d54e7	d8b00929dec65d422303256336ada04f
a0fb30950d2a150c1d2624716f216316	9891739094756d2605946c867b32ad28
4ad6c928711328d1cf0167bc87079a14	94880bda83bda77c5692876700711f15
96e3cdb363fe6df2723be5b994ad117a	0309a6c666a7a803fdb9db95de71cf01
c8d551145807972d194691247e7102a2	f75d91cdd36b85cc4a8dfeca4f24fa14
45b568ce63ea724c415677711b4328a7	424214945ba5615eca039bfe5d731c09
145bd9cf987b6f96fa6f3b3b326303c9	d8b00929dec65d422303256336ada04f
c238980432ab6442df9b2c6698c43e47	d8b00929dec65d422303256336ada04f
39a25b9c88ce401ca54fd7479d1c8b73	9891739094756d2605946c867b32ad28
8cadf0ad04644ce2947bf3aa2817816e	d8b00929dec65d422303256336ada04f
85fac49d29a31f1f9a8a18d6b04b9fc9	d8b00929dec65d422303256336ada04f
b81ee269be538a500ed057b3222c86a2	d8b00929dec65d422303256336ada04f
cf71a88972b5e06d8913cf53c916e6e4	d8b00929dec65d422303256336ada04f
5518086aebc9159ba7424be0073ce5c9	d8b00929dec65d422303256336ada04f
2c4e2c9948ddac6145e529c2ae7296da	0309a6c666a7a803fdb9db95de71cf01
c9af1c425ca093648e919c2e471df3bd	a67d4cbdd1b59e0ffccc6bafc83eb033
0291e38d9a3d398052be0ca52a7b1592	6c1674d14bf5f95742f572cddb0641a7
8852173e80d762d62f0bcb379d82ebdb	76423d8352c9e8fc8d7d65f62c55eae9
000f49c98c428aff4734497823d04f45	c8f4261f9f46e6465709e17ebea7a92b
dea293bdffcfb292b244b6fe92d246dc	6f781c6559a0c605da918096bdb69edf
302ebe0389198972c223f4b72894780a	d8b00929dec65d422303256336ada04f
ac62ad2816456aa712809bf01327add1	d8b00929dec65d422303256336ada04f
470f3f69a2327481d26309dc65656f44	d8b00929dec65d422303256336ada04f
e254616b4a5bd5aaa54f90a3985ed184	d8b00929dec65d422303256336ada04f
3c5c578b7cf5cc0d23c1730d1d51436a	d8b00929dec65d422303256336ada04f
eaeaed2d9f3137518a5c8c7e6733214f	d8b00929dec65d422303256336ada04f
8ccd65d7f0f028405867991ae3eaeb56	d8b00929dec65d422303256336ada04f
781acc7e58c9a746d58f6e65ab1e90c4	9891739094756d2605946c867b32ad28
e5a674a93987de4a52230105907fffe9	d8b00929dec65d422303256336ada04f
a2459c5c8a50215716247769c3dea40b	c8f4261f9f46e6465709e17ebea7a92b
e285e4ecb358b92237298f67526beff7	d8b00929dec65d422303256336ada04f
d832b654664d104f0fbb9b6674a09a11	d8b00929dec65d422303256336ada04f
2aeb128c6d3eb7e79acb393b50e1cf7b	d8b00929dec65d422303256336ada04f
213c449bd4bcfcdb6bffecf55b2c30b4	d8b00929dec65d422303256336ada04f
4ea353ae22a1c0d26327638f600aeac8	d8b00929dec65d422303256336ada04f
66244bb43939f81c100f03922cdc3439	c8f4261f9f46e6465709e17ebea7a92b
d399575133268305c24d87f1c2ef054a	d8b00929dec65d422303256336ada04f
6ff24c538936b5b53e88258f88294666	f75d91cdd36b85cc4a8dfeca4f24fa14
a5a8afc6c35c2625298b9ce4cc447b39	b78edab0f52e0d6c195fd0d8c5709d26
5588cb8830fdb8ac7159b7cf5d1e611e	445d337b5cd5de476f99333df6b0c2a7
9fc7c7342d41c7c53c6e8e4b9bc53fc4	ea71b362e3ea9969db085abfccdeb10d
071dbd416520d14b2e3688145801de41	76423d8352c9e8fc8d7d65f62c55eae9
2d1f30c9fc8d7200bdf15b730c4cd757	f75d91cdd36b85cc4a8dfeca4f24fa14
a1cebab6ecfd371779f9c18e36cbba0c	f75d91cdd36b85cc4a8dfeca4f24fa14
57eba43d6bec2a8115e94d6fbb42bc75	6f781c6559a0c605da918096bdb69edf
9ee30f495029e1fdf6567045f2079be1	42537f0fb56e31e20ab9c2305752087d
17bcf0bc2768911a378a55f42acedba7	f75d91cdd36b85cc4a8dfeca4f24fa14
f9f57e175d62861bb5f2bda44a078df7	d5b9290a0b67727d4ba1ca6059dc31a6
3921cb3f97a88349e153beb5492f6ef4	ea71b362e3ea9969db085abfccdeb10d
6a8538b37162b23d68791b9a0c54a5bf	d5b9290a0b67727d4ba1ca6059dc31a6
2654d6e7cec2ef045ca1772a980fbc4c	06630c890abadde9228ea818ce52b621
57b9fe77adaac4846c238e995adb6ee2	b78edab0f52e0d6c195fd0d8c5709d26
8259dc0bcebabcb0696496ca406dd672	6b718641741f992e68ec3712718561b8
ab7b69efdaf168cbbe9a5b03d901be74	6bec347f256837d3539ad619bd489de7
3041a64f7587a6768d8e307b2662785b	4647d00cf81f8fb0ab80f753320d0fc9
32921081f86e80cd10138b8959260e1a	8dbb07a18d46f63d8b3c8994d5ccc351
4d79c341966242c047f3833289ee3a13	2e6507f70a9cc26fb50f5fd82a83c7ef
c58de8415b504a6ffa5d0b14967f91bb	76423d8352c9e8fc8d7d65f62c55eae9
03022be9e2729189e226cca023a2c9bf	d5b9290a0b67727d4ba1ca6059dc31a6
f17c7007dd2ed483b9df587c1fdac2c7	7d31e0da1ab99fe8b08a22118e2f402b
1bb6d0271ea775dfdfa7f9fe1048147a	3ad08396dc5afa78f34f548eea3c1d64
743c89c3e93b9295c1ae6e750047fb1e	06e415f918c577f07328a52e24f75d43
93f4aac22b526b5f0c908462da306ffc	ea71b362e3ea9969db085abfccdeb10d
c2e88140e99f33883dac39daee70ac36	4442e4af0916f53a07fb8ca9a49b98ed
368ff974da0defe085637b7199231c0a	76b88e7899abb3bfdd4b55b8c52726b0
ccff6df2a54baa3adeb0bddb8067e7c0	3536be57ce0713954e454ae6c53ec023
26830d74f9ed8e7e4ea4e82e28fa4761	560d4c6ff431c86546f3fcec72c748c7
02f36cf6fe7b187306b2a7d423cafc2c	77dab2f81a6c8c9136efba7ab2c4c0f2
71e720cd3fcc3cdb99f2f4dc7122e078	f75d91cdd36b85cc4a8dfeca4f24fa14
54c09bacc963763eb8742fa1da44a968	d8b00929dec65d422303256336ada04f
e563e0ba5dbf7c9417681c407d016277	1007e1b7f894dfbf72a0eaa80f3bc57e
1745438c6be58479227d8c0d0220eec5	c51ed580ea5e20c910d951f692512b4d
7e5550d889d46d55df3065d742b5da51	7d31e0da1ab99fe8b08a22118e2f402b
0870b61c5e913cb405d250e80c9ba9b9	6c1674d14bf5f95742f572cddb0641a7
393a71c997d856ed5bb85a9695be6e46	6c1674d14bf5f95742f572cddb0641a7
20f0ae2f661bf20e506108c40c33a6f3	f75d91cdd36b85cc4a8dfeca4f24fa14
96604499bfc96fcdb6da0faa204ff2fe	a27b7b9f728d4b9109f95e8ee1040c68
3ed0c2ad2c9e6e7b161e6fe0175fe113	5882b568d8a010ef48a6896f53b6eddb
fd9a5c27c20cd89e4ffcc1592563abcf	92468e8a62373add2b9caefddbcf1303
a5475ebd65796bee170ad9f1ef746394	76423d8352c9e8fc8d7d65f62c55eae9
1fda271217bb4c043c691fc6344087c1	0309a6c666a7a803fdb9db95de71cf01
cba95a42c53bdc6fbf3ddf9bf10a4069	d8b00929dec65d422303256336ada04f
fe2c9aea6c702e6b82bc19b4a5d76f90	0309a6c666a7a803fdb9db95de71cf01
bb66c20c42c26f1874525c3ab956ec41	6c1674d14bf5f95742f572cddb0641a7
aad365e95c3d5fadb5fdf9517c371e89	51802d8bb965d0e5be697f07d16922e8
88a51a2e269e7026f0734f3ef3244e89	d8b00929dec65d422303256336ada04f
5c1a922f41003eb7a19b570c33b99ff4	907eba32d950bfab68227fd7ea22999b
de506362ebfcf7c632d659aa1f2b465d	6f781c6559a0c605da918096bdb69edf
1a8780e5531549bd454a04630a74cd4d	76423d8352c9e8fc8d7d65f62c55eae9
c0d7362d0f52d119f1beb38b12c0b651	a67d4cbdd1b59e0ffccc6bafc83eb033
edd506a412c4f830215d4c0f1ac06e55	1007e1b7f894dfbf72a0eaa80f3bc57e
dde31adc1b0014ce659a65c8b4d6ce42	d8b00929dec65d422303256336ada04f
4267b5081fdfb47c085db24b58d949e0	907eba32d950bfab68227fd7ea22999b
8f7de32e3b76c02859d6b007417bd509	92468e8a62373add2b9caefddbcf1303
83d15841023cff02eafedb1c87df9b11	c8f4261f9f46e6465709e17ebea7a92b
332d6b94de399f86d499be57f8a5a5ca	d8b00929dec65d422303256336ada04f
b73377a1ec60e58d4eeb03347268c11b	d8b00929dec65d422303256336ada04f
e3419706e1838c7ce6c25a28bef0c248	d8b00929dec65d422303256336ada04f
382ed38ecc68052678c5ac5646298b63	06630c890abadde9228ea818ce52b621
213c302f84c5d45929b66a20074075df	d8b00929dec65d422303256336ada04f
22c030759ab12f97e941af558566505e	d8b00929dec65d422303256336ada04f
f5507c2c7beee622b98ade0b93abb7fe	d8b00929dec65d422303256336ada04f
41bee031bd7d2fdb14ff48c92f4d7984	d8b00929dec65d422303256336ada04f
39a464d24bf08e6e8df586eb5fa7ee30	d8b00929dec65d422303256336ada04f
f7c3dcc7ba01d0ead8e0cfb59cdf6afc	d8b00929dec65d422303256336ada04f
4b42093adfc268ce8974a3fa8c4f6bca	d8b00929dec65d422303256336ada04f
70d0b58ef51e537361d676f05ea39c7b	d8b00929dec65d422303256336ada04f
6f0eadd7aadf134b1b84d9761808d5ad	9891739094756d2605946c867b32ad28
6896f30283ad47ceb4a17c8c8d625891	d8b00929dec65d422303256336ada04f
25118c5df9a2865a8bc97feb4aff4a18	d8b00929dec65d422303256336ada04f
5a53bed7a0e05c2b865537d96a39646f	d8b00929dec65d422303256336ada04f
29b7417c5145049d6593a0d88759b9ee	d8b00929dec65d422303256336ada04f
4176aa79eae271d1b82015feceb00571	1007e1b7f894dfbf72a0eaa80f3bc57e
c81794404ad68d298e9ceb75f69cf810	d8b00929dec65d422303256336ada04f
d0386252fd85f76fc517724666cf59ae	d8b00929dec65d422303256336ada04f
0cddbf403096e44a08bc37d1e2e99b0f	d8b00929dec65d422303256336ada04f
0b9d35d460b848ad46ec0568961113bf	d8b00929dec65d422303256336ada04f
546bb05114b78748d142c67cdbdd34fd	d8b00929dec65d422303256336ada04f
4ac863b6f6fa5ef02afdd9c1ca2a5e24	d8b00929dec65d422303256336ada04f
1e2bcbb679ccfdea27b28bd1ea9f2e67	d8b00929dec65d422303256336ada04f
1c62394f457ee9a56b0885f622299ea2	c8f4261f9f46e6465709e17ebea7a92b
b7e529a8e9af2a2610182b3d3fc33698	f75d91cdd36b85cc4a8dfeca4f24fa14
64d9f86ed9eeac2695ec7847fe7ea313	d8b00929dec65d422303256336ada04f
b04d1a151c786ee00092110333873a37	424214945ba5615eca039bfe5d731c09
65b029279eb0f99c0a565926566f6759	d8b00929dec65d422303256336ada04f
9bfbfab5220218468ecb02ed546e3d90	d8b00929dec65d422303256336ada04f
be41b6cfece7dfa1b4e4d226fb999607	d8b00929dec65d422303256336ada04f
9c158607f29eaf8f567cc6304ada9c6d	76423d8352c9e8fc8d7d65f62c55eae9
ca7e3b5c1860730cfd7b400de217fef2	6c1674d14bf5f95742f572cddb0641a7
8f4e7c5f66d6ee5698c01de29affc562	3ad08396dc5afa78f34f548eea3c1d64
f0bf2458b4c1a22fc329f036dd439f08	3ad08396dc5afa78f34f548eea3c1d64
25fa2cdf2be085aa5394db743677fb69	a67d4cbdd1b59e0ffccc6bafc83eb033
32917b03e82a83d455dd6b7f8609532c	d8b00929dec65d422303256336ada04f
4ffc374ef33b65b6acb388167ec542c0	76423d8352c9e8fc8d7d65f62c55eae9
0c2277f470a7e9a2d70195ba32e1b08a	a67d4cbdd1b59e0ffccc6bafc83eb033
42c9b99c6b409bc9990658f6e7829542	f75d91cdd36b85cc4a8dfeca4f24fa14
0bcf509f7eb2db3b663f5782c8c4a86e	445d337b5cd5de476f99333df6b0c2a7
bb51d2b900ba638568e48193aada8a6c	f75d91cdd36b85cc4a8dfeca4f24fa14
92df3fd170b0285cd722e855a2968393	1007e1b7f894dfbf72a0eaa80f3bc57e
b20a4217acaf4316739c6a5f6679ef60	d8b00929dec65d422303256336ada04f
34b1dade51ffdab56daebcf6ac981371	bb6a72b6a93150d4181e50496fc15f5a
9d57ebbd1d3b135839b78221388394a1	424214945ba5615eca039bfe5d731c09
1833e2cfde2a7cf621d60288da14830c	f75d91cdd36b85cc4a8dfeca4f24fa14
178227c5aef3b3ded144b9e19867a370	d8b00929dec65d422303256336ada04f
75cde58f0e5563f287f2d4afb0ce4b7e	d8b00929dec65d422303256336ada04f
b74881ac32a010e91ac7fcbcfebe210e	d8b00929dec65d422303256336ada04f
351af29ee203c740c3209a0e0a8e9c22	1007e1b7f894dfbf72a0eaa80f3bc57e
bbdbdf297183a1c24be29ed89711f744	f75d91cdd36b85cc4a8dfeca4f24fa14
6e512379810ecf71206459e6a1e64154	f75d91cdd36b85cc4a8dfeca4f24fa14
f3b65f675d13d81c12d3bb30b0190cd1	f75d91cdd36b85cc4a8dfeca4f24fa14
1918775515a9c7b8db011fd35a443b82	f75d91cdd36b85cc4a8dfeca4f24fa14
15bf34427540dd1945e5992583412b2f	f75d91cdd36b85cc4a8dfeca4f24fa14
ba8033b8cfb1ebfc91a5d03b3a268d9f	f75d91cdd36b85cc4a8dfeca4f24fa14
fd85bfffd5a0667738f6110281b25db8	d8b00929dec65d422303256336ada04f
6e4b91e3d1950bcad012dbfbdd0fff09	d8b00929dec65d422303256336ada04f
32a02a8a7927de4a39e9e14f2dc46ac6	d8b00929dec65d422303256336ada04f
747f992097b9e5c9df7585931537150a	d8b00929dec65d422303256336ada04f
13c260ca90c0f47c9418790429220899	9891739094756d2605946c867b32ad28
19819b153eb0990c821bc106e34ab3e1	4442e4af0916f53a07fb8ca9a49b98ed
b619e7f3135359e3f778e90d1942e6f5	0309a6c666a7a803fdb9db95de71cf01
0ddd0b1b6329e9cb9a64c4d947e641a8	d8b00929dec65d422303256336ada04f
30354302ae1c0715ccad2649da3d9443	424214945ba5615eca039bfe5d731c09
89eec5d48b8969bf61eea38e4b3cfdbf	d8b00929dec65d422303256336ada04f
703b1360391d2aef7b9ec688b00849bb	d8b00929dec65d422303256336ada04f
b4b46e6ce2c563dd296e8bae768e1b9d	d8b00929dec65d422303256336ada04f
5c8c8b827ae259b8e4f8cb567a577a3e	0309a6c666a7a803fdb9db95de71cf01
7f00429970ee9fd2a3185f777ff79922	1007e1b7f894dfbf72a0eaa80f3bc57e
92e2cf901fe43bb77d99af2ff42ade77	9891739094756d2605946c867b32ad28
1a1bfb986176c0ba845ae4f43d027f58	d8b00929dec65d422303256336ada04f
7ecdb1a0eb7c01d081acf2b7e11531c0	d8b00929dec65d422303256336ada04f
094caa14a3a49bf282d8f0f262a01f43	c8f4261f9f46e6465709e17ebea7a92b
110cb86243320511676f788dbc46f633	424214945ba5615eca039bfe5d731c09
8e9f5b1fc0e61f9a289aba4c59e49521	d8b00929dec65d422303256336ada04f
014dbc80621be3ddc6dd0150bc6571ff	23b998b19b5f60dbbc4eedc53328b0c7
536d1ccb9cce397f948171765c0120d4	d8b00929dec65d422303256336ada04f
15b70a4565372e2da0d330568fe1d795	d8b00929dec65d422303256336ada04f
8e331f2ea604deea899bfd0a494309ba	a67d4cbdd1b59e0ffccc6bafc83eb033
46e1d00c2019ff857c307085c58e0015	d8b00929dec65d422303256336ada04f
6afdd78eac862dd63833a3ce5964b74b	3ad08396dc5afa78f34f548eea3c1d64
fb5f71046fd15a0a22d7bda38971f142	d8b00929dec65d422303256336ada04f
512914f31042dacd2a05bfcebaacdb96	d8b00929dec65d422303256336ada04f
d96d9dac0f19368234a1fe2d4daf7f7c	d8b00929dec65d422303256336ada04f
5aa3856374df5daa99d3d33e6a38a865	d8b00929dec65d422303256336ada04f
e83655f0458b6c309866fbde556be35a	560d4c6ff431c86546f3fcec72c748c7
c09ffd48de204e4610d474ade2cf3a0d	94880bda83bda77c5692876700711f15
92dd59a949dfceab979dd25ac858f204	f75d91cdd36b85cc4a8dfeca4f24fa14
ee1bc524d6d3410e94a99706dcb12319	8dbb07a18d46f63d8b3c8994d5ccc351
bfff088b67e0fc6d1b80dbd6b6f0620c	d8b00929dec65d422303256336ada04f
3e7f48e97425d4c532a0787e54843863	d8b00929dec65d422303256336ada04f
233dedc0bee8bbdf7930eab3dd54daee	f75d91cdd36b85cc4a8dfeca4f24fa14
80f19b325c934c8396780d0c66a87c99	f75d91cdd36b85cc4a8dfeca4f24fa14
3ccca65d3d9843b81f4e251dcf8a3e8c	76423d8352c9e8fc8d7d65f62c55eae9
9144b4f0da4c96565c47c38f0bc16593	1add2eb41fcae9b2a15b4a7d68571409
ca03a570b4d4a22329359dc105a9ef22	4442e4af0916f53a07fb8ca9a49b98ed
8b3d594047e4544f608c2ebb151aeb45	d8b00929dec65d422303256336ada04f
f5eaa9c89bd215868235b0c068050883	424214945ba5615eca039bfe5d731c09
dcd3968ac5b1ab25328f4ed42cdf2e2b	2ff6e535bd2f100979a171ad430e642b
6e25aa27fcd893613fac13b0312fe36d	f75d91cdd36b85cc4a8dfeca4f24fa14
63e961dd2daa48ed1dade27a54f03ec4	f75d91cdd36b85cc4a8dfeca4f24fa14
9f10d335198e90990f3437c5733468e7	c8f4261f9f46e6465709e17ebea7a92b
4cc6d79ef4cf3af13b6c9b77783e688b	1007e1b7f894dfbf72a0eaa80f3bc57e
da34d04ff19376defc2facc252e52cf0	51802d8bb965d0e5be697f07d16922e8
eaf446aca5ddd602d0ab194667e7bec1	d8b00929dec65d422303256336ada04f
b34f0dad8c934ee71aaabb2a675f9822	d8b00929dec65d422303256336ada04f
c6458620084029f07681a55746ee4d69	d8b00929dec65d422303256336ada04f
ee325100d772dd075010b61b6f33c82a	51802d8bb965d0e5be697f07d16922e8
950d43371e8291185e524550ad3fd0df	d8b00929dec65d422303256336ada04f
2aa7757363ff360f3a08283c1d157b2c	424214945ba5615eca039bfe5d731c09
d71218f2abfdd51d95ba7995b93bd536	c8f4261f9f46e6465709e17ebea7a92b
186aab3d817bd38f76c754001b0ab04d	d8b00929dec65d422303256336ada04f
12c0763f59f7697824567a3ca32191db	907eba32d950bfab68227fd7ea22999b
4e14f71c5702f5f71ad7de50587e2409	c8f4261f9f46e6465709e17ebea7a92b
8f7d02638c253eb2d03118800c623203	1007e1b7f894dfbf72a0eaa80f3bc57e
d2ec9ebbccaa3c6925b86d1bd528d12f	f75d91cdd36b85cc4a8dfeca4f24fa14
2cca468dcaea0a807f756b1de2b3ec7b	1007e1b7f894dfbf72a0eaa80f3bc57e
c8c012313f10e2d0830f3fbc5afca619	f75d91cdd36b85cc4a8dfeca4f24fa14
cf3ecbdc9b5ae9c5a87ab05403691350	42537f0fb56e31e20ab9c2305752087d
9323fc63b40460bcb68a7ad9840bad5a	f75d91cdd36b85cc4a8dfeca4f24fa14
7b959644258e567b32d7c38e21fdb6fa	8dbb07a18d46f63d8b3c8994d5ccc351
b08c5a0f666c5f8a83a7bcafe51ec49b	0309a6c666a7a803fdb9db95de71cf01
eb626abaffa54be81830da1b29a3f1d8	c8f4261f9f46e6465709e17ebea7a92b
dd663d37df2cb0b5e222614dd720f6d3	94880bda83bda77c5692876700711f15
71aabfaa43d427516f4020c7178de31c	9891739094756d2605946c867b32ad28
32f27ae0d5337bb62c636e3f6f17b0ff	d8b00929dec65d422303256336ada04f
d9a6c1fcbafa92784f501ca419fe4090	76423d8352c9e8fc8d7d65f62c55eae9
afd755c6a62ac0a0947a39c4f2cd2c20	d8b00929dec65d422303256336ada04f
b69b0e9285e4fa15470b0969836ac5ae	76423d8352c9e8fc8d7d65f62c55eae9
79d924bae828df8e676ba27e5dfc5f42	445d337b5cd5de476f99333df6b0c2a7
84557a1d9eb96a680c0557724e1d0532	c8f4261f9f46e6465709e17ebea7a92b
ead662696e0486cb7a478ecd13a0b5c5	d8b00929dec65d422303256336ada04f
62165afb63fc004e619dff4d2132517c	d8b00929dec65d422303256336ada04f
b5d1848944ce92433b626211ed9e46f8	a67d4cbdd1b59e0ffccc6bafc83eb033
92e67ef6f0f8c77b1dd631bd3b37ebca	42537f0fb56e31e20ab9c2305752087d
fe1f86f611c34fba898e4c90b71ec981	c8f4261f9f46e6465709e17ebea7a92b
8c22a88267727dd513bf8ca278661e4d	f75d91cdd36b85cc4a8dfeca4f24fa14
541455f74d6f393174ff14b99e01b22d	f75d91cdd36b85cc4a8dfeca4f24fa14
90bebabe0c80676a4f6207ee0f8caa4c	d8b00929dec65d422303256336ada04f
ee8cde73a364c2b066f795edda1a303a	d8b00929dec65d422303256336ada04f
92e25f3ba88109b777bd65b3b3de28a9	d8b00929dec65d422303256336ada04f
3e3b4203ce868f55b084eb4f2da535d3	f75d91cdd36b85cc4a8dfeca4f24fa14
88ae6d397912fe633198a78a3b10f82e	f75d91cdd36b85cc4a8dfeca4f24fa14
d2ec80fcff98ecb676da474dfcb5fe5c	94880bda83bda77c5692876700711f15
e31fabfff3891257949efc248dfa97e2	f75d91cdd36b85cc4a8dfeca4f24fa14
4f6ae7ce964e64fdc143602aaaab1c26	d8b00929dec65d422303256336ada04f
fe1fbc7d376820477e38b5fa497e4509	51802d8bb965d0e5be697f07d16922e8
b4087680a00055c7b9551c6a1ef50816	51802d8bb965d0e5be697f07d16922e8
986a4f4e41790e819dc8b2a297aa8c87	f75d91cdd36b85cc4a8dfeca4f24fa14
e318f5bc96fd248b69f6a969a320769e	d5b9290a0b67727d4ba1ca6059dc31a6
56525146be490541a00c20a1dab0a465	5a548c2f5875f10bf5614b7c258876cf
2f39cfcedf45336beb2e966e80b93e22	d8b00929dec65d422303256336ada04f
51053ffab2737bd21724ed0b7e6c56f7	0309a6c666a7a803fdb9db95de71cf01
869d4f93046289e11b591fc7a740bc43	1007e1b7f894dfbf72a0eaa80f3bc57e
edb40909b64e73b547843287929818de	9891739094756d2605946c867b32ad28
5b3c70181a572c8d92d906ca20298d93	d8b00929dec65d422303256336ada04f
be3c26bf034e9e62057314f3945f87be	f75d91cdd36b85cc4a8dfeca4f24fa14
37b93f83b5fe94e766346ef212283282	1007e1b7f894dfbf72a0eaa80f3bc57e
dbde8de43043d69c4fdd3e50a72b859d	6f781c6559a0c605da918096bdb69edf
0f512371d62ae34741d14dde50ab4529	a67d4cbdd1b59e0ffccc6bafc83eb033
fd1bd629160356260c497da84df860e2	76423d8352c9e8fc8d7d65f62c55eae9
3dba6c9259786defe62551e38665a94a	76423d8352c9e8fc8d7d65f62c55eae9
34d29649cb20a10a5e6b59c531077a59	76423d8352c9e8fc8d7d65f62c55eae9
c02f12329daf99e6297001ef684d6285	d8b00929dec65d422303256336ada04f
f64162c264d5679d130b6e8ae84d704e	d8b00929dec65d422303256336ada04f
0674a20e29104e21d141843a86421323	d8b00929dec65d422303256336ada04f
24dd5b3de900b9ee06f913a550beb64c	d8b00929dec65d422303256336ada04f
fe7838d63434580c47798cbc5c2c8c63	d8b00929dec65d422303256336ada04f
e47c5fcf4a752dfcfbccaab5988193ef	d8b00929dec65d422303256336ada04f
3d482a4abe7d814a741b06cb6306d598	d8b00929dec65d422303256336ada04f
856256d0fddf6bfd898ef43777a80f0c	6b718641741f992e68ec3712718561b8
b5bc9b34286d4d4943fc301fe9b46e46	d8b00929dec65d422303256336ada04f
589a30eb4a7274605385d3414ae82aaa	d8b00929dec65d422303256336ada04f
d79d3a518bd9912fb38fa2ef71c39750	5a548c2f5875f10bf5614b7c258876cf
5ff09619b7364339a105a1cbcb8d65fd	92468e8a62373add2b9caefddbcf1303
2eb6fb05d553b296096973cb97912cc0	d8b00929dec65d422303256336ada04f
e163173b9350642f7c855bf37c144ce0	76423d8352c9e8fc8d7d65f62c55eae9
50681f5168e67b62daa1837d8f693001	d8b00929dec65d422303256336ada04f
57338bd22a6c5ba32f90981ffb25ef23	0309a6c666a7a803fdb9db95de71cf01
69af98a8916998443129c057ee04aec4	0309a6c666a7a803fdb9db95de71cf01
48aeffb54173796a88ef8c4eb06dbf10	51802d8bb965d0e5be697f07d16922e8
ada3962af4845c243fcd1ccafc815b09	d8b00929dec65d422303256336ada04f
07759c4afc493965a5420e03bdc9b773	d8b00929dec65d422303256336ada04f
8989ab42027d29679d1dedc518eb04bd	d8b00929dec65d422303256336ada04f
54f89c837a689f7f27667efb92e3e6b1	8189ecf686157db0c0274c1f49373318
266674d0a44a3a0102ab80021ddfd451	d8b00929dec65d422303256336ada04f
50e7b1ba464091976138ec6a57b08ba0	d8b00929dec65d422303256336ada04f
a51211ef8cbbf7b49bfb27c099c30ce1	d8b00929dec65d422303256336ada04f
0dc9cb94cdd3a9e89383d344a103ed5b	9891739094756d2605946c867b32ad28
c45ca1e791f2849d9d11b3948fdefb74	d8b00929dec65d422303256336ada04f
b05f3966288598b02cda4a41d6d1eb6b	d8b00929dec65d422303256336ada04f
c7d1a2a30826683fd366e7fd6527e79c	e31959fe2842dacea4d16d36e9813620
6ff4735b0fc4160e081440b3f7238925	d8b00929dec65d422303256336ada04f
100691b7539d5ae455b6f4a18394420c	6f781c6559a0c605da918096bdb69edf
d5282bd6b63b4cd51b50b40d192f1161	d8b00929dec65d422303256336ada04f
5159fd46698ae21d56f1684c2041bd79	d8b00929dec65d422303256336ada04f
c63ecd19a0ca74c22dfcf3063c9805d2	d8b00929dec65d422303256336ada04f
e08f00b43f7aa539eb60cfa149afd92e	d8b00929dec65d422303256336ada04f
793955e5d62f9b22bae3b59463c9ef63	2e6507f70a9cc26fb50f5fd82a83c7ef
e4f2a1b2efa9caa67e58fa9610903ef0	2e6507f70a9cc26fb50f5fd82a83c7ef
57f003f2f413eedf53362b020f467be4	f75d91cdd36b85cc4a8dfeca4f24fa14
5ef6a0f70220936a0158ad66fd5d9082	d8b00929dec65d422303256336ada04f
25ebb3d62ad1160c96bbdea951ad2f34	d8b00929dec65d422303256336ada04f
d97a4c5c71013baac562c2b5126909e1	d8b00929dec65d422303256336ada04f
1ebe59bfb566a19bc3ce5f4fb6c79cd3	d8b00929dec65d422303256336ada04f
5f572d201a24500b2db6eca489a6a620	424214945ba5615eca039bfe5d731c09
ac6dc9583812a034be2f5aacbf439236	6c1674d14bf5f95742f572cddb0641a7
7f499363c322c1243827700c67a7591c	d8b00929dec65d422303256336ada04f
2040754b0f9589a89ce88912bcf0648e	d8b00929dec65d422303256336ada04f
13cd421d8a1cb48800543b9317aa2f52	d8b00929dec65d422303256336ada04f
4b9f3b159347c34232c9f4b220cb22de	d8b00929dec65d422303256336ada04f
81a17f1bf76469b18fbe410d8ec77da8	d8b00929dec65d422303256336ada04f
81a86312a4aa3660f273d6ed5e4a6c7d	51802d8bb965d0e5be697f07d16922e8
15137b95180ccc986f6321acffb9cb6f	d8b00929dec65d422303256336ada04f
20d32d36893828d060096b2cd149820b	d8b00929dec65d422303256336ada04f
546f8a4844ac636dd18025dcc673a3ab	d8b00929dec65d422303256336ada04f
692649c1372f37ed50339b91337e7fec	f75d91cdd36b85cc4a8dfeca4f24fa14
0646225016fba179076d7df56260d1b2	d5b9290a0b67727d4ba1ca6059dc31a6
ce5e821f2dcc57569eae793f628c99cf	d8b00929dec65d422303256336ada04f
cd11b262d721d8b3f35ad2d2af8431dd	d8b00929dec65d422303256336ada04f
15cee64305c1b40a4fac10c26ffa227d	d8b00929dec65d422303256336ada04f
3771bd5f354df475660a24613fcb7a8c	d8b00929dec65d422303256336ada04f
f43bb3f980f58c66fc81874924043946	d8b00929dec65d422303256336ada04f
069cdf9184e271a3c6d45ad7e86fcac2	d8b00929dec65d422303256336ada04f
e9782409a3511c3535149cdfb5b76364	8189ecf686157db0c0274c1f49373318
49f6021766f78bffb3f824eb199acfbc	d8b00929dec65d422303256336ada04f
f04de6fafc611682779eb2eb36bdbe25	d8b00929dec65d422303256336ada04f
f7c31a68856cab2620244be2df27c728	d8b00929dec65d422303256336ada04f
ae2056f2540325e2de91f64f5ac130b6	d8b00929dec65d422303256336ada04f
eced087124a41417845c0b0f4ff44ba9	d8b00929dec65d422303256336ada04f
edaf03c0c66aa548df3cebdae0f94545	d8b00929dec65d422303256336ada04f
16cbdd4df5f89d771dccfa1111d7f4bc	d8b00929dec65d422303256336ada04f
9abdb4a0588186fc4425b29080e820a2	d8b00929dec65d422303256336ada04f
06a4594d3b323539e9dc4820625d01b8	d8b00929dec65d422303256336ada04f
b5c7675d6faefd09e871a6c1157e9353	d8b00929dec65d422303256336ada04f
1683f5557c9db93b35d1d2ae450baa21	f75d91cdd36b85cc4a8dfeca4f24fa14
ae653e4f46c5928cc4b4b171efbcf881	d5b9290a0b67727d4ba1ca6059dc31a6
df8457281db2cba8bbcb4b3b80f2b9a3	d8b00929dec65d422303256336ada04f
f85df6e18a73a6d1f5ccb59ee51558ae	d8b00929dec65d422303256336ada04f
0308321fc4f75ddaed8208c24f2cb918	d8b00929dec65d422303256336ada04f
4ceb1f68d8a260c644c25799629a5615	6c1674d14bf5f95742f572cddb0641a7
7acb475eda543ccd0622d546c5772c5a	d8b00929dec65d422303256336ada04f
ba8d3efe842e0755020a2f1bc5533585	d8b00929dec65d422303256336ada04f
5a154476dd67358f4dab8500076dece3	d8b00929dec65d422303256336ada04f
b8e18040dc07eead8e6741733653a740	d8b00929dec65d422303256336ada04f
0bc244b6aa99080c3d37fea06d328193	d8b00929dec65d422303256336ada04f
b46e412d7f90e277a1b9370cfeb26abe	d8b00929dec65d422303256336ada04f
49920f80faa980ca10fea8f31ddd5fc9	d8b00929dec65d422303256336ada04f
277ce66a47017ca1ce55714d5d2232b2	6b718641741f992e68ec3712718561b8
2ad8a3ceb96c6bf74695f896999019d8	d8b00929dec65d422303256336ada04f
fc4734cc48ce1595c9dbbe806f663af8	f75d91cdd36b85cc4a8dfeca4f24fa14
567ddbaeec9bc3c5f0348a21ebd914b1	76423d8352c9e8fc8d7d65f62c55eae9
25cde5325befa9538b771717514351fb	d8b00929dec65d422303256336ada04f
cf2676445aa6abcc43a4b0d4b01b42a1	d8b00929dec65d422303256336ada04f
3005cc8298f189f94923611386015c78	1007e1b7f894dfbf72a0eaa80f3bc57e
7f2679aa5b1116cc22bab4ee10018f59	6c1674d14bf5f95742f572cddb0641a7
8a1acf425fb1bca48fb543edcc20a90d	a67d4cbdd1b59e0ffccc6bafc83eb033
fddfe79923a5373a44237e0e60f5c845	5a548c2f5875f10bf5614b7c258876cf
c2d7bbc06d62144545c45b9060b0a629	d8b00929dec65d422303256336ada04f
62254b7ab0a2b3d3138bde893dde64a3	d8b00929dec65d422303256336ada04f
f291caafeb623728ebf0166ac4cb0825	d8b00929dec65d422303256336ada04f
1a46202030819f7419e300997199c955	d8b00929dec65d422303256336ada04f
1f94ea2f8cb55dd130ec2254c7c2238c	6f781c6559a0c605da918096bdb69edf
8d788b28d613c227ea3c87ac898a8256	7755415a9fe7022060b98a689236ccd2
5226c9e67aff4f963aea67c95cd5f3f0	6f781c6559a0c605da918096bdb69edf
e58ecda1a7b9bfdff6a10d398f468c3f	d5b9290a0b67727d4ba1ca6059dc31a6
183bea99848e19bdb720ba5774d216ba	d8b00929dec65d422303256336ada04f
495ddc6ae449bf858afe5512d28563f5	94880bda83bda77c5692876700711f15
3b0b94c18b8d65aec3a8ca7f4dae720d	21fc68909a9eb8692e84cf64e495213e
b2b4ae56a4531455e275770dc577b68e	76423d8352c9e8fc8d7d65f62c55eae9
f9d5d4c7b26c7b832ee503b767d5df52	6c1674d14bf5f95742f572cddb0641a7
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
ade72e999b4e78925b18cf48d1faafa4	d78332cc62698da3fa12331d9846e0a8
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
f291caafeb623728ebf0166ac4cb0825	0e67c2c71665c073ae6e51d2a82dc311
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
f9d5d4c7b26c7b832ee503b767d5df52	a29864963573d7bb061691ff823b97dd
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: music; Owner: -
--

COPY music.events (id_event, event, date_event, id_place, duration, price, persons) FROM stdin;
b1e4aa22275a6a4b3213b44fc342f9fe	Sepultura - Quadra Summer Tour - Europe 2022	2022-07-05	6d998a5f2c8b461a654f7f9e34ab4368	0	37.31	2
f10fa26efffb6c69534e7b0f7890272d	Rockfield Open Air 2018	2018-08-17	55ff4adc7d421cf9e05b68d25ee22341	2	0.00	2
9e829f734a90920dd15d3b93134ee270	EMP Persistence Tour 2016	2016-01-22	427a371fadd4cce654dd30c27a36acb0	0	31.20	2
52b133bfecec2fba79ecf451de3cf3bb	Völkerball	2016-05-05	657d564cc1dbaf58e2f2135b57d02d99	0	23.50	2
8307a775d42c5bfbaab36501bf6a3f6c	Noche de los Muertos - 2017	2017-10-31	c5159d0425e9c5737c8884eb38d70dd9	0	15	2
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
d78332cc62698da3fa12331d9846e0a8	Slamimng Deathcore
819de896b7c481c2b870bcf4ca7965fc	Slamdown
c7d1df50d4cb1e00b5b5b3a34a493b90	Atmospheric Post-Black Metal
51a0accd339e27727689fc781c4df015	Blackened Speed Metal
2d1930ea91c39cb44ce654c634bd5113	Tribute to Bolt Thrower
c56931e6d30371f655de27ecbf6c50f0	Tribute to Danzig
9a9f894a69bab7649b304cb577a96566	Tribute to Misfits
5f05cefd0f6a07508d21a1d2be16d9c7	Electronic
d5750853c14498dc264065bcf7e05a29	Tribute to Megadeth
0e67c2c71665c073ae6e51d2a82dc311	Black 'n' Roll
07b91b89a1fd5e90b9035bf112a3e6e5	Blackened Folk Metal
f829960b3a62def55e90a3054491ead7	Middle Eastern Doom Metal
d4fe504b565a2bcbec1bb4c56445e857	Funeral Doom Metal
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
    ((((
        CASE
            WHEN (date_part('day'::text, e.date_event) < (10)::double precision) THEN ('0'::text || (date_part('day'::text, e.date_event))::text)
            ELSE (date_part('day'::text, e.date_event))::text
        END || '.'::text) ||
        CASE
            WHEN (date_part('month'::text, e.date_event) < (10)::double precision) THEN ('0'::text || (date_part('month'::text, e.date_event))::text)
            ELSE (date_part('month'::text, e.date_event))::text
        END) || '.'::text) || date_part('year'::text, e.date_event)) AS date,
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
    ADD CONSTRAINT countries_continents_id_continent_fkey FOREIGN KEY (id_continent) REFERENCES geo.continents(id_continent);


--
-- Name: countries_continents countries_continents_id_country_fkey; Type: FK CONSTRAINT; Schema: geo; Owner: -
--

ALTER TABLE ONLY geo.countries_continents
    ADD CONSTRAINT countries_continents_id_country_fkey FOREIGN KEY (id_country) REFERENCES geo.countries(id_country);


--
-- Name: bands_countries bands_countries_id_band_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_countries
    ADD CONSTRAINT bands_countries_id_band_fkey FOREIGN KEY (id_band) REFERENCES music.bands(id_band);


--
-- Name: bands_countries bands_countries_id_country_fkey; Type: FK CONSTRAINT; Schema: music; Owner: -
--

ALTER TABLE ONLY music.bands_countries
    ADD CONSTRAINT bands_countries_id_country_fkey FOREIGN KEY (id_country) REFERENCES geo.countries(id_country);


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

