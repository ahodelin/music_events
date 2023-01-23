--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Debian 13.7-0+deb11u1)
-- Dumped by pg_dump version 13.7 (Debian 13.7-0+deb11u1)

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
-- Name: subjects; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA subjects;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: semester; Type: TABLE; Schema: subjects; Owner: -
--

CREATE TABLE subjects.semester (
    id_semester character varying NOT NULL,
    semester character varying NOT NULL
);


--
-- Name: subject; Type: TABLE; Schema: subjects; Owner: -
--

CREATE TABLE subjects.subject (
    id_subject integer NOT NULL,
    subject character varying NOT NULL,
    note numeric DEFAULT 0.0 NOT NULL,
    id_semester character varying,
    ects integer DEFAULT 5 NOT NULL,
    CONSTRAINT subject_note_check CHECK (((note >= 0.0) AND (note <= (5)::numeric)))
);


--
-- Name: subject_id_subject_seq; Type: SEQUENCE; Schema: subjects; Owner: -
--

CREATE SEQUENCE subjects.subject_id_subject_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subject_id_subject_seq; Type: SEQUENCE OWNED BY; Schema: subjects; Owner: -
--

ALTER SEQUENCE subjects.subject_id_subject_seq OWNED BY subjects.subject.id_subject;


--
-- Name: subjects_note; Type: VIEW; Schema: subjects; Owner: -
--

CREATE VIEW subjects.subjects_note AS
 SELECT su.id_subject,
    su.subject,
    round(su.note, 1) AS note,
    se.semester
   FROM (subjects.subject su
     JOIN subjects.semester se ON (((su.id_semester)::text = (se.id_semester)::text)))
  WHERE (su.note <> 0.0)
UNION
 SELECT (count(subject.id_subject) + 1) AS id_subject,
    'Average Note'::character varying AS subject,
    round((sum((subject.note * (subject.ects)::numeric)) / (sum(subject.ects))::numeric), 2) AS note,
    ''::character varying AS semester
   FROM subjects.subject
  WHERE (subject.note <> 0.0)
  ORDER BY 1, 3;


--
-- Name: subject id_subject; Type: DEFAULT; Schema: subjects; Owner: -
--

ALTER TABLE ONLY subjects.subject ALTER COLUMN id_subject SET DEFAULT nextval('subjects.subject_id_subject_seq'::regclass);


--
-- Data for Name: semester; Type: TABLE DATA; Schema: subjects; Owner: -
--

COPY subjects.semester (id_semester, semester) FROM stdin;
ws2021	Winter Semester 2020 2021
ss21	Sommer Semester 2021
ws2122	Winter Semester 2021 2022
ss22	Sommer Semester 2022
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: subjects; Owner: -
--

COPY subjects.subject (id_subject, subject, note, id_semester, ects) FROM stdin;
1	Krankheitslehre: Herz-Kreislauferkrankungen	2.0	ws2021	5
2	Krankheitslehre: Onkologie	1.0	ws2021	5
3	Datenmanagement und Archivierung im Umfeld der Forschung	1.7	ws2021	5
4	Forschungsdatenmanagement	1.7	ws2021	5
5	IT-Infrastrukturen für die medizinische Forschung	1.0	ss21	5
6	Bioinformatik und Systembiologie	1.0	ss21	5
8	Wissenschaftliches Arbeiten	1.7	ss21	5
7	Konflikt-, Fehler- und Qualitätsmanagement sowie Patientensicherheit	2	ss21	5
9	Projektarbeit	2	ws2122	5
11	Biostatistik und Studiendesign	2.3	ws2122	5
10	Angewandte Molekulardiagnostik und Systemmedizin	1.3	ws2122	5
13	Master-Thesis	0	ss22	27
14	Master-Kolloquium	0	ss22	3
12	Projektmanagement und Personalführung	3.7	ws2122	5
\.


--
-- Name: subject_id_subject_seq; Type: SEQUENCE SET; Schema: subjects; Owner: -
--

SELECT pg_catalog.setval('subjects.subject_id_subject_seq', 1, false);


--
-- Name: semester semester_pkey; Type: CONSTRAINT; Schema: subjects; Owner: -
--

ALTER TABLE ONLY subjects.semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (id_semester);


--
-- Name: semester semester_semester_key; Type: CONSTRAINT; Schema: subjects; Owner: -
--

ALTER TABLE ONLY subjects.semester
    ADD CONSTRAINT semester_semester_key UNIQUE (semester);


--
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: subjects; Owner: -
--

ALTER TABLE ONLY subjects.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id_subject);


--
-- Name: subject subject_subject_key; Type: CONSTRAINT; Schema: subjects; Owner: -
--

ALTER TABLE ONLY subjects.subject
    ADD CONSTRAINT subject_subject_key UNIQUE (subject);


--
-- Name: subject subject_id_semester_fkey; Type: FK CONSTRAINT; Schema: subjects; Owner: -
--

ALTER TABLE ONLY subjects.subject
    ADD CONSTRAINT subject_id_semester_fkey FOREIGN KEY (id_semester) REFERENCES subjects.semester(id_semester);


--
-- PostgreSQL database dump complete
--

