# asterisk_config_file_to_sql
Script to generate SQL instruction to load Asterisk configuration from a database

This script transforms an Asterisk configuration file to SQL instruction in order to be used in a static Asterisk Realtime Architecture.
See: https://wiki.asterisk.org/wiki/display/AST/Realtime+Database+Configuration

## Usage
```
./asterisk_config_file_to_sql.pl /etc/asterisk/modules.conf
```

## Example

```
;
; Asterisk configuration file
;

[modules]
autoload=yes
; An example of loading ODBC support would be:
;preload => res_odbc.so
;preload => res_config_odbc.so
;
noload => pbx_gtkconsole.so
load => res_musiconhold.so
noload => chan_alsa.so
noload => chan_console.so

```

is converted into:

```sql
INSERT INTO ast_config (cat_metric, var_metric, filename, category, var_name, var_val) VALUES (1 1 modules.conf modules load res_musiconhold.so);
INSERT INTO ast_config (cat_metric, var_metric, filename, category, var_name, var_val) VALUES (1 2 modules.conf modules noload pbx_gtkconsole.so);
INSERT INTO ast_config (cat_metric, var_metric, filename, category, var_name, var_val) VALUES (1 3 modules.conf modules noload chan_alsa.so);
INSERT INTO ast_config (cat_metric, var_metric, filename, category, var_name, var_val) VALUES (1 4 modules.conf modules noload chan_console.so);
INSERT INTO ast_config (cat_metric, var_metric, filename, category, var_name, var_val) VALUES (1 5 modules.conf modules autoload yes);
```

## SQL table format

```sql
CREATE TABLE ast_config
(
  id serial NOT NULL,
  cat_metric int4 NOT NULL DEFAULT 0,
  var_metric int4 NOT NULL DEFAULT 0,
  filename varchar(128) NOT NULL DEFAULT ''::character varying,
  category varchar(128) NOT NULL DEFAULT 'default'::character varying,
  var_name varchar(128) NOT NULL DEFAULT ''::character varying,
  var_val varchar(128) NOT NULL DEFAULT ''::character varying,
  commented int2 NOT NULL DEFAULT 0,
  CONSTRAINT ast_config_id_pk PRIMARY KEY (id)
) 
WITHOUT OIDS;
```

## See:
* https://www.safaribooksonline.com/library/view/asterisk-the-future/9780596510480/ch12.html
