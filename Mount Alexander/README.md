# Mount Alexander

## Parcel Query

There is a SPI field in Property.Gov, but it's auto generated, and there's not much confidence that the query that generates it does the best job. Therefore Pozi Connect ignores it and generates its own SPI.

## Property Address Query

The council has a list of property numbers it does not want included in M1s.

 1525,1527,1529,1533,1535,1555,2194,2195,2196,2197,2198,2199,2237,2238,2239,2240,3502,3503,3504,3505,4024,4026,4027,4028,4029,4030,4031,4032,4033,4034,4035,4036,9961,9962,9963,9964,9965,9966,9967,9968,9969,9970,9971,10169,10171,10172,10173,10207,11969,11970,11971,12341,12342,12343,12344,12346,12347,12351,12352,12354,12355,12357,12358,12359,12360,12361,12362,12363,12364,12365,12366,12367,12368,12369,12370,12371,12372,12373,12374,12375,12376,12377,12378,12380,12381,12382,12383,12384

 However, we can't exclude them within the Pozi Connect queries because Pozi Connect will subsequently assume these properties need to be removed from the map base. The council's intention is that they remain in the map base, but not be subjected to further M1 edits. The council has implemented their own procedure to remove them from the M1 after Pozi Connect generates the M1.
