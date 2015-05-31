# Indigo

Configuration copied from Towong, then customised for Indigo.

At the time of implementation, Lynx had less then 2000 parcel records (compared to over 19,000 in Vicmap).

In response, the following changes have been made to Indigo's configuration:

* Vicmap is loaded before Lynx
* any Vicmap parcels with a property number that doesn't already exist in the Lynx parcel table are appended to the Lynx table