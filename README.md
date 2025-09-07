# imduckdb

The [IMDB Non-Commercial Datasets](https://developer.imdb.com/non-commercial-datasets/)
in DuckDB.

Created after reading Jamie Brandon's blog post
[SQL needed structure](https://www.scattered-thoughts.net/writing/sql-needed-structure/).
I thought the example SQL could be nicer.

First, I needed a database to run the SQL on. The blog post uses PostgreSQL,
but I'm always looking for an excuse to throw [DuckDB](https://duckdb.org) at
something new. Using DuckDB I could download and build the tables using
its SQL alone. To do this (having istalled the DuckDB CLI) run
[`fetch_load_data.sql`](fetch_load_data.sql):

```sh
duckdb -echo -f fetch_load_data.sql imduckdb.duckdb
```

This script splits the IMDB datasets' comma-separated fields into DuckDB's
native array types. It specifies particular column types which DuckDB's CSV
parser won't guess.

You can now explore the data in a web browser:

```sh
duckdb -ui imduckdb.duckdb
```

The desired query output from the blog post is:

```json
{
  "title": "Baby Driver",
  "director": ["Edgar Wright"],
  "writer": ["Edgar Wright"]
  "genres": ["Action", "Crime", "Drama"],
  "actors": [
    {"name": "Ansel Elgort", "characters": ["Baby"]},
    {"name": "Jon Bernthal", "characters": ["Griff"]},
    {"name": "Jon Hamm", "characters": ["Buddy"]},
    {"name": "Eiza González", "characters": ["Darling"]},
    {"name": "Micah Howard", "characters": ["Barista"]},
    {"name": "Lily James", "characters": ["Debora"]},
    {"name": "Morgan Brown", "characters": ["Street Preacher"]},
    {"name": "Kevin Spacey", "characters": ["Doc"]},
    {"name": "Morse Diggs", "characters": ["Morse Diggs"]},
    {"name": "CJ Jones", "characters": ["Joseph"]}
  ],
}
```

To generate this using DuckDB's `COPY TO ... (FORMAT JSON)` on the above
database, run [`baby_driver.sql`](baby_driver.sql):

```sh
duckdb -f baby_driver.sql imduckdb.duckdb
```
