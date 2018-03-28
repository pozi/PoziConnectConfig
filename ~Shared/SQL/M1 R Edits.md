# Edit Code ‘R’

## DELWP

### Rule

Edit Code R is only used to remove a property from a Multi Assessment. The last record on a multi assessment cannot be retired.

#### Question to DELWP: If a multi-assessment contains five properties, and we submit R edits records for all five, will the first four succeed (or will they all fail)?

The current M1 loading software will identify that you are trying to retire all instances which fails validation rules and therefore no edits will occur ie all five edits will fail.

## Logic

Retire multi-assessment properties whose property number does not exist in Council, except the last record in the multi-assessment.

Note: This will not remove incorrectly matched properties - only ones that do not exist at all in Council. For a more aggressive approach, see the section below titled *Alternative 'Aggressive' Retirement*.

## SQL

### Complete SQL

[M1 R Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20R%20Edits.sql)

### Explanation

Retire only properties that are multi-assessment.

```sql
multi_assessment = 'Y'
```

Retire only properties that are not NCPR. NCPR properties may have valid address information that is maintained by authorities other than the council (eg, retirement villages, universities).

```sql
propnum <> 'NCPR'
```

Include only parcels where the property number is not a correct match for one of the property's parcels. (Introduced after Baw Baw discovered a property (18153) being removed even though one of its parcels was correctly matched to one of the multi-assessment's parcels.)...

```sql
spi not in ( select spi from pc_vicmap_parcel vpx where vpx.propnum in ( select propnum from pc_council_parcel cpx where cpx.spi = vp.spi ) )
```

...or where every parcel in the multi-assessment only belongs to one property.

```sql
( select spi from pc_council_parcel_property_count where spi in ( select spi from pc_vicmap_parcel where propnum = vp.propnum ) and num_props > 1 ) is null
```

Each month, alternate between excluding the first and last record in the multi-assessment. This will ensure that the not all the records are retired at once, which is not allowed in the M1.

```sql
case cast ( strftime ( '%m' , 'now' ) as integer ) % 2
    when 0 then property_pfi not in ( select min ( t.property_pfi ) from pc_vicmap_parcel t group by t.parcel_pfi )
    when 1 then property_pfi not in ( select max ( t.property_pfi ) from pc_vicmap_parcel t group by t.parcel_pfi )
end
```

Include only those properties that either don't exist in Council...

```sql
propnum not in ( select cpa.propnum from pc_council_property_address cpa )
```
...or where the parcel's spi exists somewhere in Council (and its property has at least one parcel record).

```sql
( vp.spi in ( select cp.spi from pc_council_parcel cp ) and ( select count(*) from pc_council_parcel cp where cp.propnum = vp.propnum ) > 0 )

```

Include only those properties that have a valid spi. (Properties that don't have a valid spi shouldn't be retired from their existing multi-assessment because they can't be automatically matched anywhere else in Vicmap.)

```
propnum not in ( select propnum from pc_council_parcel cp where spi not in ( select x.spi from pc_vicmap_parcel x where spi <> '' ) )
```

In addition to above conditions, include any multi-assessment whose propnum is invalid.

```
vp.propnum not in ( select propnum from pc_council_property_address )
```

Eliminate duplicate records.

```sql
group by property_pfi
```

# Alternative 'Aggressive' Retirement

The alternative approach detailed below retires not only properties that do not exist in Council, but also any properties where the parcel descriptions do not match. This approach has been put on hold due to it generating excessive records caused by the inevitable dodgy parcel descriptions in Council.

At Stonnington, replacing this aggressive approach with the conservative approach reduced R records from 1130 to 109.

## Logic

Retire any multi-assessment associated with Vicmap Parcels where Vicmap `propnum` doesn't exist in Council Parcel with the same `spi`, except the last one.

## SQL

[M1 R Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/99b5717932971dfe1676319670c6d1fc57008030/~Shared/SQL/M1%20R%20Edits.sql) as at 04 Sep 2013

### Explanation

Include only parcels that are actually multi-assessments.

```sql
multi_assessment = 'Y'
```

Include only records where parcels have a valid parcel description.

```sql
spi <> ''
```

Retire only records where the parcels that don't have a corresponding matching property number and simplified parcel description in Council. The use of the *simplified* parcel description `simple_spi` (as opposed to the standard `spi`) means that if the council has the wrong plan prefix recorded, it will not be included in the results to be retired.

```sql
propnum not in ( select cp.propnum from pc_council_parcel cp where cp.simple_spi = vp.simple_spi )
```

Exclude from retirement properties whose parcel descriptions in Council are not found at all in Vicmap (because we don't want to retire any property that has no other chance of being matched correctly).

```sql
propnum not in ( select cp.propnum from pc_council_parcel cp where cp.spi not in ( select vpx.spi from pc_vicmap_parcel vpx ) )
```

Exclude from retirement the last record in the multi-assessment. This will ensure that the not all the records can be retired at once. Unfortunately this prevents us from targeting the last record for retirement.

```sql
property_pfi not in ( select max ( t.property_pfi ) from pc_vicmap_parcel t group by t.parcel_pfi )
```

Retire only records where the parcel description exists in Council (because we don't want to remove the record if there is nothing to replace it) or where propnum doesn't exist in Council.

```sql
( spi in ( select cp.spi from pc_council_parcel cp ) or propnum not in ( select cpa.propnum from pc_council_property_address cpa ) )
```
