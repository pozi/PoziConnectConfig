# M1 E Edits

The E edit is used to update property and address information in a single edit.

Pozi Connect generally handles its property, parcel and address edits using the appropriate single-purpose edit codes (C for parcels; P, A and R for properties; S for addresses).

Only in the case when trying to null an unwanted property number will Pozi Connect use E, in order to get rid of the associated address.

## Logic

Looking at all Vicmap Parcels:

* where Vicmap `propnum` value doesn't exist in any Council Property, and its `spi` doesn't match any Council Property with a populated `propnum`, then null the `propnum`

Note: the second part deliberately checks for the existence of the propnum in the Council _Property Address_ table, rather than the seemingly more precise Council _Parcel_ table. Council property information is traditionally more reliable than its parcel information, so we want to check if the propnum exists at all in the property table before potentially nulling out a valid property that just isn't recorded properly by the council in its parcel table.

## Q&A with DEPI

DEPI:
>Edit Code E updates both property and address details for a given record. It requires that the Property Details and Address – Road and Locality Information columns are populated as required.

Can we replace a typical E edit with a separate P/A edit followed by an S edit?

> A ‘P’ edit followed by a ‘S’ edit in the same M1 will load as there isn’t any duplication of information provided. The first is loading property details and the second Address (and vis-a-versa ie the address record could be loaded first.)

> This also applies for ‘A’ edit code record followed by a ‘S’ edit code record.

> Although I would like to caution the use of this practice as I’m sure this method is more prone to errors occurring. 

When nulling out an existing property number by supplying an empty propnum, does this remove any existing address on that property?

> The fact that you are using the edit code ’P’ you are only editing the property details. The addressing won’t be looked at. So the simple answer is no the existing address won’t be removed.

## Development notes:

* get any P edits that are nulling property numbers and move them here to E edits
* ensure E edits can never be created for properties that don't already have a property number - we don't want SPEAR addresses nulled out
* ensure it's only looking at non multi-assessments


## SQL
This is where we'll explain individual parts of the query that may not be easy to interpret from the raw SQL.

```sql
select * from table
    where this = '8'
```

