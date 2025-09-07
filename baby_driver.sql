-- CTEs (common table expressions) avoid nesting, flattening the sturcture of
-- the query and making it more readable.

-- When the column name is the same on both sides of the join, joining by
-- `USING (colname)` is cleaner.

-- No `table.colname` qualifiers are required because there are no (to DuckDB)
-- ambiguous columns in the SELECT clauses.

COPY (
  WITH directors AS (
    SELECT tconst
      , array_agg(
          primaryName ORDER BY ordering
        ) AS director
    FROM principal
    JOIN person USING (nconst)
    WHERE category = 'director'
    GROUP BY tconst
  ),
  writers AS (
    SELECT tconst
      , array_agg(
          primaryName ORDER BY ordering
        ) AS writer
    FROM principal
    JOIN person USING (nconst)
    WHERE category = 'writer'
    GROUP BY tconst
  ),
  actor_characters AS (
    SELECT tconst
      , array_agg(
          {
           'name': primaryName,
           'characters': characters,
          }
          ORDER BY ordering
        ) AS actors
    FROM principal
    JOIN person USING (nconst)
    WHERE characters IS NOT NULL
    GROUP BY tconst
  )
  SELECT primaryTitle AS title
    , director
    , genres
    , writer
    , actors
  FROM title
  LEFT JOIN directors USING (tconst)
  LEFT JOIN writers USING (tconst)
  LEFT JOIN actor_characters USING (tconst)
  WHERE tconst = 'tt3890160'
) TO '/dev/stdout' (FORMAT JSON);
