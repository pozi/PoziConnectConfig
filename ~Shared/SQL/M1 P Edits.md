# Edit Code ‘P’

## DEPI

### Rule

Edit Code P updates property details for a given record. It requires that the Property Details are populated as required including propnum and Crefno (if used by LGA). If Crefno is left blank the existing CREFNO value in the parcel table will be retained.

### Q&A

##### When nulling out an existing property number by supplying an empty propnum, does this remove any existing address on that property?

The fact that you are using the edit code ’P’ you are only editing the property details. The addressing won’t be looked at. So the simple answer is no the existing address won’t be removed.

##### If more than one P edit record is supplied for a single property, will any of them succeed (or will they all fail)?

Where all the records contain the exact same details for any particular edit code, the first record will be loaded and the second tagged as a duplicate and returned in the load report with the following message

> ‘Duplicate record – row not required’

Where you have two records that contain different details, both records will be returned as the maintainer cannot determine which record is the correct one to load (which is part of the issue with Pozi Connect placing in a blank Propnum and then a record with the propnum – current software not looking for the ‘null’ and just identifying that they are different).

## Logic

Comparing Vicmap Parcel against Council Parcel based on a common `spi` value:

* where Vicmap `propnum` is null or doesn't exist in any Council Parcel, and one or more Council records have a populated `propnum`, then update with the *first* Council `propnum` value

## SQL

[M1 P Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20P%20Edits.sql)

Include only Vicmap parcels that have a valid parcel description (`spi`).

```sql
vp.spi <> ''
```

Include only parcels that are associated to only one property. (Multi-assessment edits are handled by the 'A' and 'R' edits.) We will use our parcel count table here rather than the `multi_assessment` field because there are scenarios where Vicmap has multiple properties associated to a single property and are still not classed as multi-assessment. Eg 2\PS400861 at Stonnington.

```sql
vp.spi in ( select vppc.spi from PC_Vicmap_Parcel_Property_Count vppc where vppc.num_props = 1 )
```

Include only valid council property numbers.

```sql
cp.propnum <> ''
```

Include only parcels where Vicmap and Council agree on the parcel description (`spi`).

```sql
vp.spi = cp.spi
```

Include only parcels where the `propnum` values are different.

```sql
vp.propnum <> cp.propnum
```

Include only parcels where the existing property number is blank or NCPR, *OR* where the Vicmap `propnum` doesn't actually exist in Council. This is a conservative approach that ensures that we are don't replace property numbers that are still valid, even if the council has not recorded parcel descriptions correctly.

We check for the existence of the propnum in the Council _Property Address_ table, rather than the seemingly more precise Council _Parcel_ table. Council property information is traditionally more reliable than its parcel information, so we want to check if the propnum exists at all in the property table before potentially replacing a valid property that just isn't recorded properly by the council in its parcel table.

```sql
    ( vp.propnum in ( '' , 'NCPR' ) or
      vp.propnum not in ( select PC_Council_Property_Address.propnum from PC_Council_Property_Address ) )
```

Return only one record per `spi` value

```sql
group by vp.spi
```



