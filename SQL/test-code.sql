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


CREATE TABLE public."Book" (
    "BookNo" integer NOT NULL,
    "Version" text NOT NULL,
    "Language" integer NOT NULL,
    "ProjectName" text NOT NULL,
    "BookName" text NOT NULL,
    "Scenario" integer NOT NULL,
    "ScenName" text NOT NULL,
    "ColVar" text NOT NULL,
    "Weight" text,
    "Parameter" text,
    "Productive" timestamp without time zone
);



CREATE TABLE public."Col" (
    "BookNo" integer NOT NULL,
    "ColNo" integer NOT NULL,
    "HeadNo" integer NOT NULL,
    "ColTitle1" text,
    "ColTitle2" text,
    "ColVariable" text,
    "ColValue" double precision
);



CREATE TABLE public."Head" (
    "BookNo" integer NOT NULL,
    "HeadNo" integer NOT NULL,
    "HeadName" text,
    "HeadTitle" text,
    "HeadCount" integer
);



CREATE TABLE public."Quest" (
    "BookNo" integer NOT NULL,
    "QuestNo" character varying(10) NOT NULL,
    "QuestLine" integer NOT NULL,
    "Title" character varying,
    "Type" character varying NOT NULL,
    "RowVar" character varying NOT NULL,
    "Hash" character(32),
    "Parameters" character varying,
    "StartTime" timestamp without time zone,
    "EndTime" timestamp without time zone,
    "WarnLog" character varying,
    "ErrorLog" character varying,
    "CountRow" integer
);


CREATE TABLE public."Row" (
    "BookNo" integer NOT NULL,
    "QuestNo" text NOT NULL,
    "RowNo" integer NOT NULL,
    "TabNo" integer NOT NULL,
    "RowTypeS" text,
    "RowType" integer,
    "RowContent" text,
    "RowContentDetail" text,
    "RowAbsPercent" text,
    "RowWeighted" text,
    "RowTitle1" text,
    "RowTitle2" text,
    "RowTitle3" text,
    "RowDecimals" integer,
    "RowVariable" text,
    "RowValue" double precision,
    "RowFormat" integer,
    "RowValues" double precision[]
);



CREATE TABLE public."Tab" (
    "BookNo" integer NOT NULL,
    "QuestNo" text NOT NULL,
    "TabNo" integer NOT NULL,
    "TabName" text,
    "TabType" text,
    "TabTitle" text,
    "TabTitle1" text,
    "TabTitle2" text,
    "TabTitle3" text,
    "TabRowTypes" integer,
    "TabCaption" text,
    "TabCount" integer,
    "QuestLine" integer
);



CREATE VIEW public."Val" AS
 SELECT "Row"."BookNo",
    "Row"."QuestNo",
    "Row"."TabNo",
    "Row"."RowNo",
    ("Val"."ColNo" + 3) AS "ColNo",
    "Val"."Value"
   FROM public."Row",
    LATERAL unnest("Row"."RowValues") WITH ORDINALITY "Val"("Value", "ColNo");




CREATE TABLE public.dscmdlog (
    datano integer NOT NULL,
    sheet text,
    action text,
    "row" text,
    new_var text,
    raw text,
    error text,
    index integer
);

CREATE TABLE public.dsdataset (
    datano integer NOT NULL,
    version text NOT NULL,
    projectname text NOT NULL,
    filepath text NOT NULL,
    filedate timestamp with time zone,
    hash text NOT NULL
);



CREATE TABLE public.dslabel (
    datano integer NOT NULL,
    var text NOT NULL,
    nv double precision NOT NULL,
    vallab text,
    index integer
);


CREATE TABLE public.dsorigin (
    datano integer NOT NULL,
    origin integer NOT NULL
);


CREATE TABLE public.dsvariable (
    datano integer NOT NULL,
    var text NOT NULL,
    type text NOT NULL,
    varlab text NOT NULL,
    hash text NOT NULL,
    index integer
);



CREATE TABLE public.mfsheets (
    mappingfile text NOT NULL,
    sheet text NOT NULL,
    csv text,
    "timestamp" integer NOT NULL
);



ALTER TABLE ONLY public."Book"
    ADD CONSTRAINT "Book_pkey" PRIMARY KEY ("BookNo");

ALTER TABLE ONLY public."Col"
    ADD CONSTRAINT "Col_pkey" PRIMARY KEY ("BookNo", "ColNo");


ALTER TABLE ONLY public."Head"
    ADD CONSTRAINT "Head_pkey" PRIMARY KEY ("BookNo", "HeadNo");

ALTER TABLE ONLY public."Quest"
    ADD CONSTRAINT "Quest_pkey" PRIMARY KEY ("BookNo", "QuestNo");


ALTER TABLE ONLY public."Row"
    ADD CONSTRAINT "Row_pkey" PRIMARY KEY ("BookNo", "QuestNo", "TabNo", "RowNo");


ALTER TABLE ONLY public."Tab"
    ADD CONSTRAINT "Tab_pkey" PRIMARY KEY ("BookNo", "QuestNo", "TabNo");


ALTER TABLE ONLY public.dsdataset
    ADD CONSTRAINT dsdataset_pkey PRIMARY KEY (datano);

ALTER TABLE ONLY public.dslabel
    ADD CONSTRAINT dslabelpkey PRIMARY KEY (datano, var, nv);

ALTER TABLE ONLY public.dsvariable
    ADD CONSTRAINT dsvariablepkey PRIMARY KEY (datano, var);


ALTER TABLE ONLY public.mfsheets
    ADD CONSTRAINT mfsheets_pkey PRIMARY KEY (mappingfile, sheet, "timestamp");


CREATE INDEX "fki_Head_fkey" ON public."Head" USING btree ("BookNo");


CREATE INDEX "fki_Quest_fkey" ON public."Quest" USING btree ("BookNo");

CREATE INDEX "fki_Row_fkey" ON public."Row" USING btree ("BookNo", "QuestNo", "TabNo");

CREATE INDEX "fki_Tab_fkey" ON public."Tab" USING btree ("QuestNo", "BookNo");

CREATE INDEX fki_o ON public."Col" USING btree ("BookNo", "HeadNo");

ALTER TABLE ONLY public."Col"
    ADD CONSTRAINT "Col_fkey" FOREIGN KEY ("BookNo", "HeadNo") REFERENCES public."Head"("BookNo", "HeadNo") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


ALTER TABLE ONLY public."Head"
    ADD CONSTRAINT "Head_fkey" FOREIGN KEY ("BookNo") REFERENCES public."Book"("BookNo") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


ALTER TABLE ONLY public."Quest"
    ADD CONSTRAINT "Quest_fkey" FOREIGN KEY ("BookNo") REFERENCES public."Book"("BookNo") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


ALTER TABLE ONLY public."Row"
    ADD CONSTRAINT "Row_fkey" FOREIGN KEY ("BookNo", "QuestNo", "TabNo") REFERENCES public."Tab"("BookNo", "QuestNo", "TabNo") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;

ALTER TABLE ONLY public."Tab"
    ADD CONSTRAINT "Tab_fkey" FOREIGN KEY ("QuestNo", "BookNo") REFERENCES public."Quest"("QuestNo", "BookNo") ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;

ALTER TABLE ONLY public.dslabel
    ADD CONSTRAINT dslabelfkey FOREIGN KEY (datano, var) REFERENCES public.dsvariable(datano, var) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE ONLY public.dscmdlog
    ADD CONSTRAINT dsvariablefkey FOREIGN KEY (datano) REFERENCES public.dsdataset(datano) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ONLY public.dsvariable
    ADD CONSTRAINT dsvariablefkey FOREIGN KEY (datano) REFERENCES public.dsdataset(datano) ON UPDATE CASCADE ON DELETE CASCADE;


