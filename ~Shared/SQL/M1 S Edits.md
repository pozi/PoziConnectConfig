# Edit Code ‘S’

DEPI:
>Edit Code S updates address details for a given record. It requires that the Address – Road and Locality Information columns are populated as required including the Address – Location attributes for creating spatially located address points.

Comparing primary Vicmap Property Addresses against non-secondary Council Property Addresses based on a common `propnum` value:

* where Vicmap `num_road_address` is not equal to Council `num_road_address`, then update with Council address values

Looking at all non-secondary Council Property Addresses:

* where `propnum` value does not exist in Vicmap Property and the value exists in M1_P_Edit or M1_A_Edit, then update with Council address values

Note: the use of the terminology 'non-secondary' when referring to council addresses is based on the assumption that all council addresses are "primary" _unless otherwise stated_. For any council property systems that can handle and correctly identify addresses as being secondary, the `is_primary` field of the affected records will be populated with an 'N' value.

## Q&A with DEPI

Can we update the address of an existing property using the existing propnum (not prop_pfi)?

> It is my understanding that an existing propnum can be used as the mapbase locator for a street address update.

## Development notes:

* still to add functionality to update addresses for propnums that are flogged for P or A edits
