# installation

- PostgreSQL: SQL Engine that stores data and reads queries and returns information.
- PgAdmin: Graphical User Interface for connecting with PostgreSQL

## download and install PostgreSQL and pgAdmin

See all the details for [PostgreSQL](https://www.postgresql.org/) and [pgAdmin](https://www.pgadmin.org/). Choose the best version on the [donwload page](https://www.postgresql.org/download/), and follow the instructions.

See also [issue on mapping between account names and Security Id](https://stackoverflow.com/questions/70665044/workgroup-user-no-mapping-between-account-names-and-security-id-was-done/74065107#74065107)

## download the archive/backup of the database

Do not open the TAR file directly as it might show error.

## restore the database

In pgAdmin, enter the Admin password and connect to Server:

1. go to `Databases`, the `postgres` database is the default one.
2. click right on `Databases` and select `Create > Database...`
   1. may need to add the path for all the executables in `File > Preferences`, in `Paths > Binary paths`, and then `PostgreSQL Binary Path`, find or paste the past for the corresponding PostgreSQL server.
3. in the new window, in the tab `Generam`, enter a name for the database to be created/restored; click `save` to add the database to the list of Databases
4. `Refresh` from the `Object` menu or by clicking left on the `Databases`
5. choose the new database, and restore the data archive that has been downloaded via the `Tools` menu and `Restore...` option
6. keep/choose the right format, and select the path to the data archive in `Filename`
7. may want to swith on the Sections `Pre-data`, `Data` and `Post-data` in the `Data/Objects` tab; all other options can be left as default
8. click on `Restore` and refresh the database list

## connect to Server and query

The new database is now part of the Databases list in the PostgreSQL engine/server. We can run `Query tool` to test if everything is working properly.

## customization

- go to `File > Preferences`, in `Miscellaneous > Themes`, choose the dark theme
- go to `File > Preferences`, in `Query Tool > Editor`, choose a different `Font size` ratio, e.g., 1.1
- there is a `Query History` tab available with the history of the queries, and a `Scratch Pad` which can be used to hold text snippets during editing
- have a look at the `Dashboard` tab which contains different technical details in the running server