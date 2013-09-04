# M1 E Edits

## DEPI

### Rule

Edit Code E updates both property and address details for a given record. It requires that the Property Details and Address – Road and Locality Information columns are populated as required.

## Logic

The E edit was designed to update property and address information in a single edit.

However Pozi Connect generally handles its property, parcel and address edits using the appropriate single-purpose edit codes (C for parcels; P, A and R for properties; S for addresses).

Only in the case when trying to null an unwanted property number (and its address) will Pozi Connect use E.

Looking at all Vicmap Parcels:

* where Vicmap `propnum` value doesn't exist in any Council Property, and its `spi` doesn't match any Council Property with a populated `propnum`, then null the `propnum`

Note: the second part deliberately checks for the existence of the propnum in the Council _Property Address_ table, rather than the seemingly more precise Council _Parcel_ table. Council property information is traditionally more reliable than its parcel information, so we want to check if the propnum exists at all in the property table before potentially nulling out a valid property that just isn't recorded properly by the council in its parcel table.

## SQL

### Complete SQL

[M1 E Edits.sql](https://github.com/groundtruth/PoziConnectConfig/blob/master/~Shared/SQL/M1%20E%20Edits.sql)

### Explanation

Note: all records here are essentially retirements. The explanations below are based on including or excluding records from being submitted as retirements.

Retire only records with a valid parcel description.

```sql
vp.spi <> ''
```

Retire only those records that are populated with a property number.

```sql
vp.propnum not in ( '' , 'NCPR' )
```
Exclude from retirement those records where the property number exists in Council.

```sql
vp.propnum not in ( select cpa.propnum from PC_Council_Property_Address cpa )
```

Exclude from retirement any multi-assessment records (because these are dealt with by the R edit).

```sql
vp.multi_assessment <> 'Y'
```

Eliminate duplicate records.

```sql
group by property_pfi, plan_number, lot_number
```

