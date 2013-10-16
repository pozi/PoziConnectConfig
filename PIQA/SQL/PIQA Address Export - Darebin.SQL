SELECT
    *,
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) AS "roadnt_pr",
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) || ' ' ||
        locality AS "stjoin_pr",
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN TRIM ( su_prefix_2 || su_no_2 || su_suff_2 ) <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN TRIM ( su_prefix_1 || su_no_1 || su_suff_1 ) <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN TRIM ( house_prefix_2 || house_number_2 || house_suffix_2 ) <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ) AS "address_pr",
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN TRIM ( su_prefix_2 || su_no_2 || su_suff_2 ) THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN TRIM ( su_prefix_1 || su_no_1 || su_suff_1 ) <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN TRIM ( house_prefix_2 || house_number_2 || house_suffix_2 ) <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ||
        RTRIM ( ' ' || propnum ) ) AS "address_propnum_pr"
FROM (
SELECT
    lpaprop.tpklpaprop AS "propnum",
    CASE
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'ATM' ) THEN 'ATM'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'CARP' ) THEN 'CARP'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'KIOSK' ) THEN 'KSK'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'LOT' ) THEN 'LOT'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'RESERVE' ) THEN 'RESV'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'STORAGE' ) THEN 'STOR'
        ELSE ''
    END AS "su_type",
    CASE
        WHEN LENGTH ( lpaaddr.prefix ) IN ( 1 , 2 ) THEN UPPER ( lpaaddr.prefix )
        ELSE ''
    END AS "su_prefix_1",
    CASE
        WHEN UPPER ( cnacomp.descr ) IN ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' , 'NORTHCOTE PLAZA' , 'NORTHCOTE CENTRAL' ) THEN
            CASE
                WHEN lpaaddr.strhousnum = 0 OR lpaaddr.strhousnum IS NULL THEN ''
                ELSE CAST ( CAST ( lpaaddr.strhousnum AS INTEGER ) AS VARCHAR )                
            END
        WHEN lpaaddr.strunitnum = 0 OR lpaaddr.strunitnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.strunitnum AS INTEGER ) AS VARCHAR )
    END AS "su_no_1",
    CASE 
        WHEN UPPER ( cnacomp.descr ) IN ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' , 'NORTHCOTE PLAZA' , 'NORTHCOTE CENTRAL' ) THEN IFNULL ( lpaaddr.strhoussfx , '' )
        ELSE IFNULL ( lpaaddr.strunitsfx , '' )
    END AS "su_suff_1",
    '' AS "su_prefix_2",
    CASE
        WHEN lpaaddr.endunitnum = 0 OR lpaaddr.endunitnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.endunitnum AS INTEGER ) AS VARCHAR )
    END AS "su_no_2",
    IFNULL ( lpaaddr.endunitsfx , '' ) AS "su_suff_2",
    CASE
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'BASEMENT' ) THEN 'B'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'LEVEL' ) THEN 'L'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'FLOOR' ) THEN 'FL'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'GROUND' ) THEN 'G'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'LWRGROUND' ) THEN 'LG'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'MEZZANINE' ) THEN 'M'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'PODIUM' ) THEN 'PDM'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'ROOFTOP' ) THEN 'RT'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'UPRGROUND' ) THEN 'UG'
        ELSE ''
    END AS "fl_type",
    '' AS "fl_prefix_1",
    CASE
        WHEN lpaaddr.strlvlnum = 0 OR lpaaddr.strlvlnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.strlvlnum AS INTEGER ) AS VARCHAR )
    END AS "fl_no_1",
    '' AS "fl_suff_1",
    '' AS "fl_prefix_2",
    CASE
        WHEN lpaaddr.endlvlnum = 0 OR lpaaddr.endlvlnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.endlvlnum AS INTEGER ) AS VARCHAR )
    END AS "fl_no_2",
    '' AS "fl_suff_2",
    '' AS "pr_name_1",
    '' AS "pr_name_2",
    CASE
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'BETWEEN' , 'FRONT OF' , 'OPPOSITE' , 'REAR OF' ) THEN UPPER ( lpaaddr.prefix )
        ELSE ''
    END AS "loc_des",
    '' AS "house_prefix_1",
    CASE
        WHEN UPPER ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' THEN '2'
        WHEN UPPER ( cnacomp.descr ) = 'PRESTON MARKET' THEN ''
        WHEN UPPER ( cnacomp.descr ) = 'NORTHCOTE PLAZA' THEN '25'
        WHEN UPPER ( cnacomp.descr ) = 'NORTHCOTE CENTRAL' THEN '5'
        WHEN lpaaddr.strhousnum = 0 OR lpaaddr.strhousnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.strhousnum AS INTEGER ) AS VARCHAR )
    END AS "house_number_1",
    CASE 
        WHEN UPPER ( cnacomp.descr ) IN ( 'NORTHLAND SHOPPING CENTRE' , 'PRESTON MARKET' , 'NORTHCOTE PLAZA' , 'NORTHCOTE CENTRAL' ) THEN ''
        ELSE IFNULL ( lpaaddr.strhoussfx , '' )
    END AS "house_suffix_1",
    '' AS "house_prefix_2",
    CASE
        WHEN UPPER ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' THEN '50'
        WHEN UPPER ( cnacomp.descr ) IN ( 'PRESTON MARKET' , 'NORTHCOTE PLAZA' , 'NORTHCOTE CENTRAL' ) THEN ''
        WHEN lpaaddr.endhousnum = 0 OR lpaaddr.endhousnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.endhousnum AS INTEGER ) AS VARCHAR )
    END AS "house_number_2",
    IFNULL ( lpaaddr.endhoussfx , '' ) AS "house_suffix_2",
    '' AS "display_prefix_1",
    '' AS "display_no_1",
    '' AS "display_suffix_1",
    '' AS "display_prefix_2",
    '' AS "display_no_2",
    '' AS "display_suffix_2",
    CASE
        WHEN UPPER ( cnacomp.descr ) = 'HIGH' AND UPPER ( cnaqual.descr ) = 'STREET CLOSE' THEN 'HIGH STREET'
        WHEN UPPER ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' THEN 'MURRAY'
        WHEN UPPER ( cnacomp.descr ) = 'PRESTON MARKET' THEN 'CRAMER'
        WHEN UPPER ( cnacomp.descr ) = 'NORTHCOTE PLAZA' THEN 'SEPARATION'
        WHEN UPPER ( cnacomp.descr ) = 'NORTHCOTE CENTRAL' THEN 'SEPARATION'
        WHEN UPPER ( cnacomp.descr ) = 'THE AGORA LA TROBE UNIVERSITY' THEN 'THE AGORA'
        ELSE UPPER ( cnacomp.descr )
    END AS "street_name",
    CASE
        WHEN UPPER ( cnaqual.descr ) = 'STREET CLOSE' THEN 'CLOSE'
        WHEN UPPER ( cnacomp.descr ) = 'NORTHLAND SHOPPING CENTRE' THEN 'ROAD'
        WHEN UPPER ( cnacomp.descr ) IN ( 'PRESTON MARKET' , 'NORTHCOTE PLAZA' , 'NORTHCOTE CENTRAL' ) THEN 'STREET'
        WHEN cnaqual.descr LIKE '% NORTH' OR
            cnaqual.descr LIKE '% SOUTH' OR
            cnaqual.descr LIKE '% EAST' OR
            cnaqual.descr LIKE '% WEST' THEN UPPER ( TRIM ( SUBSTR ( cnaqual.descr , 1 , LENGTH ( cnaqual.descr ) - 5 ) ) )
        WHEN cnaqual.descr LIKE '% EXTENSION' THEN UPPER ( TRIM ( SUBSTR ( cnaqual.descr , 1 , LENGTH ( cnaqual.descr ) - 9 ) ) )
        ELSE IFNULL ( UPPER ( cnaqual.descr ) , '' )
    END AS "street_type",
    CASE
        WHEN UPPER ( cnaqual.descr ) LIKE '% NORTH' OR UPPER ( cnaqual.descr ) = 'NORTH' THEN 'N'
        WHEN UPPER ( cnaqual.descr ) LIKE '% SOUTH' OR UPPER ( cnaqual.descr ) = 'SOUTH' THEN 'S'
        WHEN UPPER ( cnaqual.descr ) LIKE '% EAST' OR UPPER ( cnaqual.descr ) = 'EAST' THEN 'E'
        WHEN UPPER ( cnaqual.descr ) LIKE '% WEST' OR UPPER ( cnaqual.descr ) = 'WEST' THEN 'W'
        WHEN UPPER ( cnaqual.descr ) LIKE '% EXTENSION' OR UPPER ( cnaqual.descr ) = 'EXTENSION' THEN 'EX'
        ELSE ''
    END AS "street_suffix",
    UPPER(lpasubr.suburbname) AS "locality",
    '' AS "postcode"
FROM
    ((((((((PATHWAY_lpaprop AS lpaprop LEFT JOIN 
    PATHWAY_lpaadpr AS lpaadpr ON lpaprop.tpklpaprop = lpaadpr.tfklpaprop)
LEFT JOIN 
    PATHWAY_lpaaddr AS lpaaddr ON lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr)
LEFT JOIN 
    PATHWAY_lpastrt AS lpastrt ON lpaaddr.tfklpastrt = lpastrt.tpklpastrt)
LEFT JOIN 
    PATHWAY_cnacomp AS cnacomp ON lpastrt.tfkcnacomp = cnacomp.tpkcnacomp)
LEFT JOIN 
    PATHWAY_cnaqual AS cnaqual ON cnacomp.tfkcnaqual = cnaqual.tpkcnaqual)
LEFT JOIN 
    PATHWAY_lpaprtp AS lpaprtp ON lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp)
LEFT JOIN 
    PATHWAY_lpasubr AS lpasubr ON lpaaddr.tfklpasubr = lpasubr.tpklpasubr)
LEFT JOIN
    PATHWAY_lpapnam AS lpapnam ON lpaprop.tpklpaprop = lpapnam.tfklpaprop)
WHERE
    lpaprop.status <> 'H' AND 
    lpaprop.tfklpacncl = 14 AND
    lpaaddr.addrtype = 'P' AND
    lpaprtp.abbrev <> 'MASTER'
)