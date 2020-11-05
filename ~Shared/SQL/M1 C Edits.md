# Edit Code ‘C’

## DELWP

### Rule

Edit Code C is used for only updating the parcel based Council Reference number (Crefno). This edit code can be used to populate or null a Crefno.

### Q&A

##### If more than one C edit record is supplied for a single parcel, will any of them succeed (or will they all fail)?

If the details are the same, the first one will be loaded and the second tagged as a duplicate otherwise all records will fail to be loaded.

## Logic

Where Vicmap `crefno` value is blank or doesn't exist in any Council record that shares the same `spi` value, then update with `crefno` value from Council which has the same `spi` value (only one).

Note this will never replace an existing Vicmap `crefno` with a blank one, even if the Vicmap one does not exist in Council. The soltuion to this is for the council to have a valid `spi` with the desired `crefno` value.

## SQL

### Complete SQL

[M1 C Edits.sql](https://github.com/pozi/PoziConnectConfig/blob/master/~Shared/SQL/M1%20C%20Edits.sql)

### Explanation

Include only Vicmap parcels with a valid parcel description.

```sql
vp.spi <> ''
```

Match the Vicmap and Council parcels on parcel description.

```sql
vp.spi = cp.spi
```

Exclude parcels where the `crefno` values already match.

```sql
vp.crefno <> cp.crefno
```

Exclude parcels where Council `crefno` value is blank.

```sql
cp.crefno <> ''
```

Include only parcels where the Vicmap `crefno` value is blank or does not exist in any Council parcel with the same simplified parcel description.

```sql
( vp.crefno = '' or
  vp.crefno not in ( select cpx.crefno from pc_council_parcel cpx where cpx.simple_spi = vp.simple_spi ) )
```

Include only parcels where the Vicmap `plan_number` field is populated (due to the higher standard of plan descriptions rather then crown description) OR where the Vicmap and Council `propnum` values already match (which is a good indicator that the correct parcel is matched, despite it being only a crown description).

```sql
( vp.plan_number <> '' or
  vp.propnum = cp.propnum )
```

Include only one record per parcel

```sql
group by vp.spi
```
