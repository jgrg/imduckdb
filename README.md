# imduckdb

The [IMDB Non-Commercial Datasets](https://developer.imdb.com/non-commercial-datasets/)
in DuckDB.

Created after reading Jamie Brandon's blog post
[SQL needed structure](https://www.scattered-thoughts.net/writing/sql-needed-structure/).
I thought the example SQL could be nicer.

First, I needed a database to run the SQL on. The blog post uses PostgreSQL,
but my favourite thing is [DuckDB](https://duckdb.org). Using DuckDB I could
download and build the tables using DuckDB's SQL alone. To do this
(having istalled the DuckDB CLI)
run [`fetch_load_data.sql`](fetch_load_data.sql):

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

