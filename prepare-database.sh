createdb source
# TODO permit a dump
SOURCE_DUMP=/scripts/source.sql
if test -f "$SOURCE_DUMP"; then
  psql -d source < $SOURCE_DUMP
fi
MIGRATION=/scripts/migration.sql
if test -f "$MIGRATION"; then
  psql -d source < $MIGRATION
fi
createdb target
TARGET_DUMP=/scripts/target.sql
if test -f "$TARGET_DUMP"; then
  psql -d target < $TARGET_DUMP
fi
