# South Gippsland

copied from Glen Erira

## Notes

Import of lparole table from Pathway takes a long time (several minutes). The table contains 1.4M records.

We now apply a filter during the import to reduce the time taken for the import:

```sql
SELECT * FROM {Pathway_Table_Prefix}lparole WITH (NOLOCK) WHERE fklparolta = 'LRA' AND fklparoltn = 0
```

The imported table now contains only 67K records.

If the Glen Eira queries are to be reused at other sites, the same import filter must be applied, or the queries must be modified to include the filter.

Note: out of the four Pathway sites implemented as at Feb 2014, Glen Eira is the only one to use the lparole table.