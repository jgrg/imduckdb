-- name.basics.tsv.gz
--   nconst (string) - alphanumeric unique identifier of the name/person
--   primaryName (string)– name by which the person is most often credited
--   birthYear – in YYYY format
--   deathYear – in YYYY format if applicable, else '\N'
--   primaryProfession (array of strings)– the top-3 professions of the person
--   knownForTitles (array of tconsts) – titles the person is known for

CREATE OR REPLACE TABLE person AS
  WITH parse AS (
    FROM read_csv(
      'https://datasets.imdbws.com/name.basics.tsv.gz',
      nullstr='\N',
      types = {
        'birthYear': 'SMALLINT',
        'deathYear': 'SMALLINT',
      }
    )
  )
  SELECT nconst
    , primaryName
    , birthYear
    , deathYear
    , split(primaryProfession, ',') AS primaryProfession
    , split(knownForTitles, ',') AS knowForTitles
  FROM parse;


-- title.akas.tsv.gz
--   titleId (string) - a tconst, an alphanumeric unique identifier of the title
--   ordering (integer) – a number to uniquely identify rows for a given titleId
--   title (string) – the localized title
--   region (string) - the region for this version of the title
--   language (string) - the language of the title
--   types (array) - Enumerated set of attributes for this alternative title.
--     One or more of the following:
--       "alternative", "dvd", "festival", "tv", "video", "working", "original", "imdbDisplay".
--     New values may be added in the future without warning
--   attributes (array) - Additional terms to describe this alternative title, not enumerated
--   isOriginalTitle (boolean) – 0: not original title; 1: original title

CREATE OR REPLACE TABLE aka AS
  WITH parse AS (
    FROM read_csv(
      'https://datasets.imdbws.com/title.akas.tsv.gz',
      nullstr = '\N',
      types = {
        'isOriginalTitle': 'BOOLEAN',
      }
    )
  )
  SELECT titleId AS tconst  -- Rename or it's the only title ID column not named `tconst`
    , ordering
    , title
    , region
    , language
    -- Split on the weird ASCII 0x02 separator for the types and attirbutes columns!
    , split(types, chr(2)) AS types
    , split(attributes, chr(2)) AS attributes
    , isOriginalTitle
  FROM parse;


-- title.basics.tsv.gz
--   tconst (string) - alphanumeric unique identifier of the title
--   titleType (string) – the type/format of the title (e.g. movie, short, tvseries, tvepisode, video, etc)
--   primaryTitle (string) – the more popular title / the title used by the filmmakers on promotional materials at the point of release
--   originalTitle (string) - original title, in the original language
--   isAdult (boolean) - 0: non-adult title; 1: adult title
--   startYear (YYYY) – represents the release year of a title. In the case of TV Series, it is the series start year
--   endYear (YYYY) – TV Series end year. '\N' for all other title types
--   runtimeMinutes – primary runtime of the title, in minutes
--   genres (string array) – includes up to three genres associated with the title

CREATE OR REPLACE TABLE title AS
  WITH parse AS (
    FROM read_csv(
      'https://datasets.imdbws.com/title.basics.tsv.gz',
      nullstr = '\N',
      types = {
        'isAdult': 'BOOLEAN',
        'startYear': 'SMALLINT',
        'endYear': 'SMALLINT',
        'runtimeMinutes': 'INT',
      }
    )
  )
  SELECT tconst
    , titleType
    , primaryTitle
    , originalTitle
    , isAdult
    , startYear
    , endYear
    , runtimeMinutes
    , split(genres, ',') AS genres
  FROM parse;


-- title.crew.tsv.gz
--   tconst (string) - alphanumeric unique identifier of the title
--   directors (array of nconsts) - director(s) of the given title
--   writers (array of nconsts) – writer(s) of the given title

CREATE OR REPLACE TABLE crew AS
  WITH parse AS (
    FROM read_csv(
      'https://datasets.imdbws.com/title.crew.tsv.gz',
      nullstr = '\N'
    )
  )
  SELECT tconst
    , split(directors, ',') AS directors
    , split(writers, ',') AS writers
  FROM parse;


-- title.episode.tsv.gz
--   tconst (string) - alphanumeric identifier of episode
--   parentTconst (string) - alphanumeric identifier of the parent TV Series
--   seasonNumber (integer) – season number the episode belongs to
--   episodeNumber (integer) – episode number of the tconst in the TV series

CREATE OR REPLACE TABLE episode AS
  FROM read_csv(
    'https://datasets.imdbws.com/title.episode.tsv.gz',
    nullstr = '\N',
    types = {
      'seasonNumber': 'SMALLINT',
      'episodeNumber': 'INT',
    }
  );


-- title.principals.tsv.gz
--   tconst (string) - alphanumeric unique identifier of the title
--   ordering (integer) – a number to uniquely identify rows for a given titleId
--   nconst (string) - alphanumeric unique identifier of the name/person
--   category (string) - the category of job that person was in
--   job (string) - the specific job title if applicable, else '\N'
--   characters (string) - the name of the character played if applicable, else '\N'

CREATE OR REPLACE TABLE principal AS
  WITH parse AS (
    FROM read_csv(
      'https://datasets.imdbws.com/title.principals.tsv.gz',
      nullstr = '\N',
      types = {
        'ordering': 'TINYINT',
      }
    )
  )
  SELECT tconst
    , ordering
    , nconst
    , category
    , job
    -- The characters column is actually an array in JSON format, so we cast it to varchar[]
    , characters::JSON::VARCHAR[] AS characters
  FROM parse;


-- title.ratings.tsv.gz
--   tconst (string) - alphanumeric unique identifier of the title
--   averageRating – weighted average of all the individual user ratings
--   numVotes - number of votes the title has received

CREATE OR REPLACE TABLE rating AS
  FROM read_csv(
    'https://datasets.imdbws.com/title.ratings.tsv.gz',
    nullstr = '\N',
    types = {
      'averageRating': 'FLOAT',
      'numVotes': 'INT',
    }
  );
