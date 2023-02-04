# about

```
from sqlalchemy import create_engine
import pandas as pd

engine = create_engine('postgresql://postgres:postgres@postgres:5432/postgres', echo=False)
df = pd.read_sql(SQL, engine)
```

```
import os
import psycopg2 as ps
import pandas as pd
conn = ps.connect(
    host='postgres',
    port='5432',
    dbname='postgres',
    user='postgres',
    password='postgres')
df = pd.read_sql_query("select * from ais", con=conn)
```

```
from sqlalchemy.engine import URL
connection_string = "DRIVER={ODBC Driver 17 for SQL Server};SERVER=dagger;DATABASE=test;UID=user;PWD=password"
connection_url = URL.create("mssql+pyodbc", query={"odbc_connect": connection_string})

from sqlalchemy import create_engine
engine = create_engine(connection_url)
```