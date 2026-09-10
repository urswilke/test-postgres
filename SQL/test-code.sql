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
