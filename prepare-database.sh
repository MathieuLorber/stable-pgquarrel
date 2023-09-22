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
