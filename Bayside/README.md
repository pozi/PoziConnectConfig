# Bayside

### Parcel query

Copied from Melton, adjusted by inspection


Correspondence with Chrissie about the use of the auprparc.ttl_cde field:

> I agree with your analysis of the auprparc.ttl_cde.  My understanding is that they used 1 for just about everything and then use ttl_no2 field to put in the actual plan_code.  Unfortunately, this has been inconsistent.

> I have met with Peter from Revenue this morning and he suggests that you can trust the ttl_cde as follows:

> 2 = Registered Plan - RP
> 3 = Plan of Subdivision - PS
> 4 = Plan of Consolidation - CP
> 5 = Proposed plan only used internally for plans not yet registered.  Suggest you do not use this one.
> 6 = Lodged Plan - LP
> 7 = Cluster Subdvision - CS
> 8 = Title Plan - TP
> 9 = Strata Plan - SP
> 10 = Consolidated Plan - CP
> 11 = Crown Allotment - CA

> 1 is the wildcard and if 1 is used, then should look at ttl_no2 for the variations although there is dirty data in there which we can fix up readily enough but do not trust the value 'PS'.  As mentioned earlier, staff through the LPs were PS's and systematically changed them as they found them.  So a lot of 'PS' codes are really Lodged Plans and the number range will tell us which ones are wrong.

> Do you use the plan numbers to help you determine what the plan type or plan_code field should be???

> Another tip.  If the ttl_cde is anything but 11 (CA) or 1(wildcard), there should be nothing in the ttl_no2 field.

Also:

> ttl_no5 is where Revenue Services key in the pure plan number, no plancode and the ttl_no1 field is where they key in the lot number in the majority of cases.

> Do not take any notice of the plan code in ttl_no as this has been consistently keyed incorrectly as revenue staff mistakenly thought that a Lodged Plan 'LP' was a Plan of Subdivision hence 'PS' was keyed.

### Property Address query

Copied from Melton, adjusted using Bayside's PIQA query

