# Bendigo

Property Address query adapted from Bendigo's existing Common Ground address query, with updated syntax from Shepparton M1 query.

Changes:

* Removed lpaprtp table from original query
  ie, this line is no longer part of the query

```
pathway_lpaprtp as lpaprtp on lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp left join
```

* adjusted filter from `lpaaddr.addrtype = 'P'` to `lpaaddr.addrtype in ( 'P' , 'A' )`to make similar to Shepparton