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

* where Vicmap property number is blank or doesn't exist in any Council Parcel, and one or more Council records have a populated property number, then update with the *first* Council property number

## SQL

[M1 P Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20P%20Edits.sql)

Include only Vicmap parcels that have a valid parcel description.

```sql
vp.spi <> ''
```

Include only parcels that are not multi-assessments. (Multi-assessment edits are handled by the 'A' and 'R' edits.)

```sql
vp.multi_assessment <> 'Y'
```

Include only parcels whose property status is the same as the parcel status (or whose property status is null due to Vicmap not having a parcel-property join). Sometimes a non-multi-assessment parcel has multiple properties because it is linked to both approved and proposed properties. This ensures that the match applies to only the property that reflects the current status of the parcel.

```sql
vp.status = vp.property_status or vp.property_status = ''
```

Include only valid council property numbers.

```sql
cp.propnum <> ''
```

Include only parcels whose property number has a corresponding record in the Council property table. (Ideally the council data extract would include only these parcels anyway.)

```sql
cp.propnum in ( select propnum from pc_council_property_address )
```

Include only parcels where Vicmap and Council agree on the parcel description.

```sql
vp.spi = cp.spi
```

Include only parcels from Vicmap whose `spi` is not in Council with the same `propnum`.

```sql
vp.spi not in ( select spi from pc_council_parcel where propnum = vp.propnum )
```

Include only parcels where the Vicmap and Council property numbers are different.

```sql
vp.propnum <> cp.propnum
```

Include only parcels where the Vicmap `propnum` value:

* is either blank or NCPR, or
* doesn't exist in Council, or
* is matched to more than one parcel, or
* the property being replaced can be matched to another parcel

This is a conservative approach that ensures that we are don't completely remove valid property numbers from Vicmap.

(We check for the existence of the propnum in the Council _Property Address_ table, rather than the seemingly more precise Council _Parcel_ table. Council property information is typically more reliable than its parcel information, so we want to check if the propnum exists at all in the property table before potentially replacing a valid property that just isn't recorded properly by the council in its parcel table.)

```sql
( vp.propnum in ( '' , 'NCPR' ) or
  vp.propnum not in ( select pc_council_property_address.propnum from pc_council_property_address )  or
  ( select num_parcels from pc_vicmap_property_parcel_count where pc_vicmap_property_parcel_count.propnum = vp.propnum ) > 1 or
  vp.propnum in ( select propnum from pc_council_parcel cpx where cpx.spi in ( select spi from pc_vicmap_parcel where spi <> '' ) ) )
```

Exclude matches where Vicmap parcels status is proposed and the Council property number has multiple parcels associated with it (because these could get merged in Vicmap).

```sql
not ( vp.status = 'P' and ( select cppc.num_parcels from pc_council_property_parcel_count cppc where cppc.propnum = cp.propnum ) > 1 )
```

Exclude properties being matched to an approved parcel if the number is already matched to a proposed parcel.

```sql
not ( vp.status = 'A' and cp.propnum in ( select propnum from pc_vicmap_parcel vpx where vpx.status = 'P' ) )
```

Include only parcels whose SPI is not already matched to the same property number. (Mornington Peninsula has a lot of parcels that aren't multi-assessments, but still have duplicate SPIs. If one of these parcels is already matched to the desired propnum, we shouldn't try to match it again.)

```sql
vp.spi not in ( select spi from pc_vicmap_parcel vpx where vpx.propnum = cp.propnum )
```

Exclude matches where the Vicmap parcel type is 13 (ie, road parcel) and there is no record in the Vicmap parcel-property look-up table (because DELWP has indicated that they will not create new property polygons for these parcels).

```sql
not ( vp.desc_type = '13' and vp.parcel_pfi not in ( select parcel_pfi from vmprop_parcel_property ) )
```

Exclude matches where the existing property is NCPR which has an house number. (This is an interim measure to consider the possibility to exclude all NCPR from being replaced.)

```sql
not ( vp.propnum = 'NCPR' and ( select num_address from pc_vicmap_property_address vpa where vpa.property_pfi = vp.property_pfi and vpa.is_primary <> 'N' ) <> '' )
```

Return only one record per parcel.

```sql
group by vp.spi
```
