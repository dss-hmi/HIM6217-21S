SELECT
  SCHEMA_NAME(schema_id)    as source
  ,lower(t.name)             as table_name
  ,sum(p.rows)               as row_count
FROM
  sys.tables                as t
  inner join sys.partitions as p on
    t.object_id = p.object_id
    and
    p.index_id in ( 0, 1 )
 -- WHERE
--   SCHEMA_NAME(schema_id) <> 'dbo'
   -- SCHEMA_NAME(schema_id) = @source
GROUP BY  SCHEMA_NAME(schema_id), t.name
ORDER BY  SCHEMA_NAME(schema_id), t.name;
