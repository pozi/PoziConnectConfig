# Knox

## Property Address Query

Copied from Nillumbik's Pozi Connect address query, adapted to suit.

Knox supplied the following SQL Server query to assist with interprestting hotel-style addressing:

```
SELECT TOP (100) PERCENT
    '' AS M1_LGACode,
    '' AS M1_NewSub,
    '' AS M1_PropertyPFI,
    '' AS M1_ParcelPFI,
    '' AS M1_AddressPFI,
    '' AS M1_SPI,
    (CASE
        WHEN (lpaparc.plancode) IS NULL OR lpaparc.plancode = '' THEN ''
        ELSE Upper(Rtrim(lpaparc.plancode))
    END) +
        (CASE
            WHEN (lpaparc.plannum) IS NULL OR lpaparc.plannum = '' THEN ''
            ELSE Upper(Rtrim(lpaparc.plannum))
        END) AS M1_PlanNumber,
    (CASE
        WHEN (lpaparc.parcelnum) IS NULL OR lpaparc.parcelnum = '' THEN ''
        ELSE Rtrim(lpaparc.parcelnum)
     END) AS M1_LotNumber,
    '' AS M1_BasePropnum,
    lraassm.assmnumber AS M1_Propnum,
    '' AS M1_Crefno,
    CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN 'Y'
        ELSE ''
    END AS M1_HSAFlag,
    CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN
            (CASE
                WHEN (lpaaddr.lvlprefix) IS NULL OR lpaaddr.lvlprefix = '' THEN ''
                ELSE Rtrim(lpaaddr.lvlprefix)
              END) +
                (CASE
                    WHEN (lpaaddr.strlvlnum) = 0 THEN ''
                    ELSE CAST(lpaaddr.strlvlnum AS varchar)
                 END) +
                (CASE
                    WHEN (lpaaddr.unitprefix) IS NULL OR lpaaddr.unitprefix = '' THEN ''
                    ELSE Rtrim(lpaaddr.unitprefix)
                 END) +
                (CASE
                    WHEN (lpaaddr.strunitnum) = 0 THEN ''
                    ELSE CAST(lpaaddr.strunitnum AS varchar)
                 END)
        ELSE ''
    END AS M1_HSAUnitId,
    '' AS M1_BlgUnitType,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.unitprefix) IS NULL OR lpaaddr.unitprefix = '' THEN ''
                ELSE Rtrim(lpaaddr.unitprefix)
            END)
     END) AS M1_BlgUnitPrefix1,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.strunitnum) = 0 THEN ''
                ELSE CAST(lpaaddr.strunitnum AS varchar)
            END)
     END) AS M1_BlgUnitId1,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.strunitsfx) IS NULL OR lpaaddr.strunitsfx = '' THEN ''
                ELSE Rtrim(lpaaddr.strunitsfx)
             END)
     END) AS M1_BlgUnitSuffix1,
    '' AS M1_BlgUnitPrefix2,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.endunitnum) = 0 THEN ''
                ELSE CAST(lpaaddr.endunitnum AS varchar)
             END)
     END) AS M1_BlgUnitId2,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.endunitsfx) IS NULL OR lpaaddr.endunitsfx = '' THEN ''
                ELSE Rtrim(lpaaddr.endunitsfx)
             END)
     END) AS M1_BlgUnitSuffix2,
    '' AS M1_FloorType,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.lvlprefix) IS NULL OR lpaaddr.lvlprefix = '' THEN ''
                ELSE Rtrim(lpaaddr.lvlprefix)
             END)
     END) AS M1_FloorPrefix1,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.strlvlnum) = 0 THEN ''
                ELSE CAST(lpaaddr.strlvlnum AS varchar)
             END)
     END) AS M1_FloorNo1,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.strlvlsfx) IS NULL OR lpaaddr.strlvlsfx = '' THEN ''
                ELSE Rtrim(lpaaddr.strlvlsfx)
             END)
     END) AS M1_FloorSuffix1,
    '' AS M1_FloorPrefix2,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.endlvlnum) = 0 THEN ''
                ELSE CAST(lpaaddr.endlvlnum AS varchar)
             END)
     END) AS M1_FloorNo2,
    (CASE lpaadfm.tpklpaadfm
        WHEN 46 THEN ''
        ELSE
            (CASE
                WHEN (lpaaddr.endlvlsfx) IS NULL OR lpaaddr.endlvlsfx = '' THEN ''
                ELSE Rtrim(lpaaddr.endlvlsfx)
             END)
     END) AS M1_FloorSuffix2,
    (CASE
        WHEN lpapnam.propname IS NULL THEN ''
        ELSE Upper(RTrim(lpapnam.propname))
     END) AS M1_BuildingName,
    '' AS M1_ComplexName,
    '' AS M1_LocationDescriptor,
    '' AS M1_HousePrefix1,
    (CASE
        WHEN (lpaaddr.strhousnum) = 0 OR (lpaaddr.strhousnum) IS NULL THEN ''
        ELSE CAST(lpaaddr.strhousnum AS varchar)
     END) AS M1_HouseNumber1,
    (CASE
        WHEN (lpaaddr.strhoussfx) IS NULL OR lpaaddr.strhoussfx = '' THEN ''
        ELSE Rtrim(lpaaddr.strhoussfx)
     END) AS M1_HouseSuffix1,
    '' AS M1_HousePrefix2,
    (CASE
        WHEN (lpaaddr.endhousnum) = 0 OR (lpaaddr.endhousnum) IS NULL THEN ''
        ELSE CAST(lpaaddr.endhousnum AS varchar)
     END) AS M1_HouseNumber2,
    (CASE
        WHEN (lpaaddr.endhoussfx) IS NULL OR lpaaddr.endhoussfx = '' THEN ''
        ELSE Rtrim(lpaaddr.endhoussfx)
     END) AS M1_HouseSuffix2,
    '' AS M1_AccessType,
    '' AS M1_NewRoad,
    (CASE
        WHEN (cnacomp.descr) IS NULL OR cnacomp.descr = '' THEN ''
        ELSE Upper(Rtrim(cnacomp.descr))
     END) AS M1_RoadName,
    (CASE
        WHEN (cnaqual.descr) IS NULL OR cnaqual.descr = '' THEN ''
        ELSE Upper(Rtrim(cnaqual.descr))
     END) AS M1_RoadType,
    '' AS M1_RoadSuffix,
    (CASE
        WHEN (lpaaddr.suburbkey) IS NULL OR lpaaddr.suburbkey = '' THEN ''
        ELSE Upper(Rtrim(lpaaddr.suburbkey))
     END) AS M1_LocalityName,
    '' AS M1_DistanceRelatedFlag,
    '' AS M1_IsPrimary, 
    '' AS M1_Easting,
    '' AS M1_Northing,
    '' AS M1_DatumProj,
    '' AS M1_OutsideProperty,
    'S' AS M1_EditCode,
    (CASE
        WHEN (lpaparc.plancode) IS NULL OR lpaparc.plancode = '' THEN ''
        ELSE Upper(Rtrim(lpaparc.plancode))
     END) +
        (CASE
            WHEN (lpaparc.plannum) IS NULL OR lpaparc.plannum = '' THEN ''
            ELSE Upper(Rtrim(lpaparc.plannum))
         END) AS Plan_Number,
    (CASE
        WHEN (lpaadfm.tpklpaadfm) IS NULL OR lpaadfm.tpklpaadfm = '' THEN ''
        ELSE Rtrim(lpaadfm.tpklpaadfm)
     END) AS PW_AddressFormatFlag
FROM
    pthdbo.lpaparc AS lpaparc INNER JOIN
    pthdbo.lpatipa AS lpatipa WITH (NOLOCK) ON lpaparc.tpklpaparc = lpatipa.tfklpaparc INNER JOIN
    pthdbo.lpaprti AS lpaprti WITH (NOLOCK) ON lpatipa.tfklpatitl = lpaprti.tfklpatitl INNER JOIN
    pthdbo.lpaprop AS lpaprop WITH (NOLOCK) ON lpaprti.tfklpaprop = lpaprop.tpklpaprop INNER JOIN
    pthdbo.lparole AS lparole WITH (NOLOCK) ON lpaprop.tpklpaprop = lparole.tfklocl INNER JOIN
    pthdbo.lraassm AS lraassm WITH (NOLOCK) ON lparole.tfkappl = lraassm.tpklraassm INNER JOIN
    pthdbo.lpaadpr AS lpaadpr WITH (NOLOCK) ON lpaprop.tpklpaprop = lpaadpr.tfklpaprop LEFT OUTER JOIN
    pthdbo.lpapnam AS lpapnam WITH (NOLOCK) ON lpaadpr.tfklpaprop = lpapnam.tfklpaprop INNER JOIN
    pthdbo.lpaaddr AS lpaaddr WITH (NOLOCK) ON lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr INNER JOIN
    pthdbo.lpastrt AS lpastrt WITH (NOLOCK) ON lpaaddr.tfklpastrt = lpastrt.tpklpastrt INNER JOIN
    pthdbo.cnacomp AS cnacomp WITH (NOLOCK) ON lpastrt.tfkcnacomp = cnacomp.tpkcnacomp INNER JOIN
    pthdbo.cnaqual AS cnaqual WITH (NOLOCK) ON cnacomp.tfkcnaqual = cnaqual.tpkcnaqual LEFT OUTER JOIN
    pthdbo.lpaadfm AS lpaadfm WITH (NOLOCK) ON lpaadpr.tfklpaadfm = lpaadfm.tpklpaadfm
GROUP BY
    lraassm.assmnumber, lpaparc.parcelnum, lparole.fklparolta, lpaparc.plancode, lpaparc.plannum, lpaaddr.strhousnum, lpaaddr.suburbkey, cnaqual.descr, 
                      cnacomp.descr, lpaaddr.endhoussfx, lpaaddr.strunitnum, lpaaddr.unitprefix, lpaaddr.strunitsfx, lpaparc.plannum, lpaadfm.tpklpaadfm, lpaaddr.lvlprefix, 
                      lpaaddr.strlvlnum, lpaaddr.endunitnum, lpaaddr.endunitsfx, lpaaddr.strlvlsfx, lpaaddr.endlvlnum, lpaaddr.endlvlsfx, lpapnam.propname, lpaaddr.strhoussfx, 
                      lpaaddr.endhousnum
HAVING
    (lparole.fklparolta = 'LRA')
ORDER BY
    M1_Propnum
```

## Parcel Query

Copied from Nillumbik's Pozi Connect parcel query, adapted to suit.
