createdb -h psql -U postgres --no-password source

# TODO permit a binary dump
createdb -h psql -U postgres --no-password target
TARGET_DUMP=/scripts/target.sql
if test -f "$TARGET_DUMP"; then
  psql -h psql -U postgres -d target < $TARGET_DUMP
fi
TARGET_DUMP_COMPRESSED=/scripts/target-compressed.sql
if test -f "$TARGET_DUMP_COMPRESSED"; then
  pg_restore -h psql -U postgres -d target --format=c --no-acl --no-owner $TARGET_DUMP_COMPRESSED
fi

SOURCE_DUMP=/scripts/source.sql
if test -f "$SOURCE_DUMP"; then
  psql -h psql -U postgres -d source < $SOURCE_DUMP
fi

MIGRATION=/scripts/migration.sql
if test -f "$MIGRATION"; then
  psql -h psql -U postgres -d target < $MIGRATION
fi

pgquarrel/pgquarrel --source-host=psql --source-user=postgres --source-no-password --source-dbname=source \
                    --target-host=psql --target-user=postgres --target-no-password --target-dbname=target \
                    > ./result/pgquarrel.sql

dropdb -h psql -U postgres --no-password source
dropdb -h psql -U postgres --no-password target
