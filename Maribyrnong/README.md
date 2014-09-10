

# Maribyrnong

## Authority Configuration

### Property Address

Copied from Bayside

Street Types

﻿
""	416
AVE	2613
BVD	370
CCT	94
CL	190
CR	952
CT	991
DR	1174
GR	166
LA	310
PDE	937
PKY	49
PL	556
RD	10405
RI	36
SQ	43
ST	43348
TCE	57
VW	12
WK	115
WY	448

##### Street names that needed a workaround
Ordinance Reserve missing street suffix

Austin Crescent West and East have no street suffix

Magnolia path no suffix

O'Farrell Street

The crescent

The grand

The boulevard

The esplanade

##### Units with a G prefix for Ground Floor

units with a g prefix are stored in the unit suffix column along with the number, split out the field to get the numbers and the G into the correct fields. although i think they mean to use G as in floor. 

it looks like they use G for the units are on the ground floor but don't describe other units and they don't always use the G in the unit Suffix field sometimes its in the floor prefix field. with only one recorded with 'G01\' in the floor field. there is no other floor data stored in there database. and apart from the 'G' no other unit prefix data. so i would assume the G isn't a unit prefix

looking at existing data in vicmap the G is used sometimes in the unit prefix field and sometimes in the floor type field also with 2 instance of it in the floor suffix field.





### Parcel
Copied from Bayside aswell


1 Parish

code  count
2478  624

6 Townships (only recorded for less then 10 parcles in the section field)


township_code | count(*)
------------- | -------------
2478A | 157
2478B | 7
2478C | 21
2478D | 4
5106 | 43
5502 |26




##### Parcel Types

authority_auprparc.ttl_cde

1 = TP Title Plan
2 = TP Part Lot on Title Plan
3 = PS Plan of Subdivision
4 = PS Part Lot on Plan of Subdivision
5 = LP Lodged Plan
6 = LP Part Lot on Lodged Plan
7 = CA Crown Allotments
8 = CA Part Crown Allotments
9 = ??? section information perhaps crown land
10 = ??? Part Section crown land or NUA?
11 = PC Plan of Consolidation
12 = PC Part Plan of Consolidation
13 = RP Registered Plan
14 = RP Part Registered Plan
15 = SP Strata Plan
16 = CS Cluster Subdivision
17 = CP Consolidated Plan
50 = Road parcels? all PS pending?
99 = TBA ? perhaps pending





