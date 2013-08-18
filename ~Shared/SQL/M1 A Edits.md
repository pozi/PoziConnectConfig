# Edit Code ‘A’

DEPI:
>Edit Code A is only used to add a property to either create a Multi Assessment or add a further multi assessment record.

Comparing Vicmap Parcel against Council Parcel based on a common `spi` value:

* where Vicmap `propnum` is null or doesn't exist in any Council Parcel, and more than one Council parcels have a populated `propnum`, then update with the _second and subsequent_ Council `propnum` values

## Q&A with DEPI

Can we add a multi-assessment using the parcel’s SPI (not prop_pfi or parcel_pfi)?

> Current M1 loading software doesn’t use SPI as a Mapbase Locator attribute. You can use the Lot and Plan numbers to add a multi assessment. The loading software will then identify the Parcel_PFI and its associated Property_PFI and add another property record.

In adding a multi-assessment using either a spi or parcel_pfi, and the parcel is already included in a multi-parcel property, is this a valid edit?

> As I indicated earlier the current M1 loading software doesn’t use SPI but can locate the parcel using lot and plan details. Logic (not Logica) tells me that you should be able to use the lot on plan to identify the parcel_pfi and a related property_pfi. The the ‘A’ edit code should add a property record as a multi assessment on the shape of the identified property.

> The only caution I have is that there is a load report message that says the following when using an edit code ‘A’:

>> ‘Parcel is part of a mulit parcel property. Please remove all parcel identifiers to add to whole property’

> I am not sure what Logica are referring to here but there is a chance that what you are suggesting will be returned in the load report.

## Developer notes:

