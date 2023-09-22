createdb -h psql -U postgres --no-password source
# TODO permit a dump
SOURCE_DUMP=/scripts/source.sql
if test -f "$SOURCE_DUMP"; then
  psql -h psql -U postgres -d source < $SOURCE_DUMP
fi
MIGRATION=/scripts/migration.sql
if test -f "$MIGRATION"; then
  psql -h psql -U postgres -d source < $MIGRATION
fi
createdb -h psql -U postgres --no-password target
TARGET_DUMP=/scripts/target.sql
if test -f "$TARGET_DUMP"; then
  psql -h psql -U postgres -d target < $TARGET_DUMP
fi

pgquarrel/pgquarrel --source-host=psql --source-username=postgres --source-no-password \
                        --source-dbname=source --source-user=$USER \
                        --target-host=psql --target-username=postgres --target-no-password \
                        --target-dbname=target --target-user=$USER > ./scripts/result.sql

echo prout > ./scripts/prout.txt

dropdb -h psql -U postgres --no-password source
dropdb -h psql -U postgres --no-password target
