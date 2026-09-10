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




