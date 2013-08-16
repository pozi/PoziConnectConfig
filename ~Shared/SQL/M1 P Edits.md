# Edit Code ‘P’

DEPI:
>Edit Code P updates property details for a given record. It requires that the Property Details are populated as required including propnum and Crefno (if used by LGA). If Crefno is left blank the existing CREFNO value in the parcel table will be retained.

Comparing Vicmap Parcel against Council Parcel based on a common `spi` value:

* where Vicmap `propnum` is null or doesn't exist in any Council Parcel, and one or more Council records have a populated `propnum`, then update with the *first* Council `propnum` value

## Regarding Nulling Invalid/Bad/Old Property Numbers

Looking at all Vicmap Parcels:

* where Vicmap `propnum` value doesn't exist in any Council Property, and its `spi` doesn't match any Council Property with a populated `propnum`, then null the `propnum`

Note: the second part deliberately checks for the existence of the propnum in the Council _Property Address_ table, rather than the seemingly more precise Council _Parcel_ table. Council property information is traditionally more reliable than its parcel information, so we want to check if the propnum exists at all in the property table before potentially nulling out a valid property that just isn't recorded properly by the council in its parcel table.

The seemingly related issue of updating a property number with a null requires the use of a different edit code 'E'...

## Q&A with DEPI

When nulling out an existing property number by supplying an empty propnum, does this remove any existing address on that property?

> The fact that you are using the edit code ’P’ you are only editing the property details. The addressing won’t be looked at. So the simple answer is no the existing address won’t be removed.

If more than one P edit record is supplied for a single property, will any of them succeed (or will they all fail)?

> Where all the records contain the exact same details for any particular edit code, the first record will be loaded and the second tagged as a duplicate and returned in the load report with the following message

>> ‘Duplicate record – row not required’

> Where you have two records that contain different details, both records will be returned as the maintainer cannot determine which record is the correct one to load (which is part of the issue with Pozi Connect placing in a blank Propnum and then a record with the propnum – current software not looking for the ‘null’ and just identifying that they are different).

## Development notes:

* still to implement _first_ only rule
* check logic
* output `lot_number` and `plan_number` instead of spi
* do we need to consider P edits on multi-parcel properties at all?
* move any notes above regarding the nulling scenario to the E edit documentation