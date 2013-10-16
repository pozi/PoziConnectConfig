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
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'LOT' ) THEN 'LOT'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'RESERVE' ) THEN 'RESERVE'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'SHOP' ) THEN 'SHOP'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'STORAGE' ) THEN 'STORAGE'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'STABLE' ) THEN 'STABLE'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'TOILET' ) THEN 'TOILET'
        ELSE ''
    END AS "su_type",
    '' AS "su_prefix_1",
    CASE
        WHEN lpaaddr.strunitnum = 0 OR lpaaddr.strunitnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.strunitnum AS INTEGER ) AS VARCHAR )
    END AS "su_no_1",
    IFNULL ( lpaaddr.strunitsfx , '' ) AS "su_suff_1",
    '' AS "su_prefix_2",
    CASE
        WHEN lpaaddr.endunitnum = 0 OR lpaaddr.endunitnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.endunitnum AS INTEGER ) AS VARCHAR )
    END AS "su_no_2",
    IFNULL ( lpaaddr.endunitsfx , '' ) AS "su_suff_2",
    CASE
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'BASEMENT' ) THEN 'B'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'LEVEL' , 'LEVEL NO.' ) THEN 'L'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'FLOOR' ) THEN 'FL'
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'GRD FLOOR' , 'GRD/LEVEL' , 'GROUND FLR' , 'GROUND FL' ) THEN 'G'
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
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'ABOVE' ) THEN 'ABOVE'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'BELOW' , 'UNDER' ) THEN 'BELOW'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'FRONT' ) THEN 'FRONT'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'OFF' ) THEN 'OFF'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'OPPOSITE' ) THEN 'OPPOSITE'
        WHEN UPPER ( lpaaddr.prefix ) IN ( 'REAR' , 'REAR OF' ) THEN 'REAR'
        ELSE ''
    END AS "loc_des",
    '' AS "house_prefix_1",
    CASE
        WHEN lpaaddr.strhousnum = 0 OR lpaaddr.strhousnum IS NULL THEN ''
        ELSE CAST ( CAST ( lpaaddr.strhousnum AS INTEGER ) AS VARCHAR )
    END AS "house_number_1",
    IFNULL ( lpaaddr.strhoussfx , '' ) AS "house_suffix_1",
    '' AS "house_prefix_2",
    CASE
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
    UPPER ( cnacomp.descr ) AS "street_name",
    CASE
        WHEN cnaqual.descr like '% NORTH' or
            cnaqual.descr like '% SOUTH' or
            cnaqual.descr like '% EAST' or
            cnaqual.descr like '% WEST' THEN UPPER ( TRIM ( SUBSTR ( cnaqual.descr , 1 , LENGTH ( cnaqual.descr ) - 5 ) ) )
        ELSE IFNULL ( UPPER ( cnaqual.descr ) , '' )
    END AS "street_type",
    CASE
        WHEN UPPER ( cnaqual.descr ) like '% NORTH' THEN 'N'
        WHEN UPPER ( cnaqual.descr ) like '% SOUTH' THEN 'S'
        WHEN UPPER ( cnaqual.descr ) like '% EAST' THEN 'E'
        WHEN UPPER ( cnaqual.descr ) like '% WEST' THEN 'W'
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
    lpaprop.tfklpacncl = 12 AND
    lpaaddr.addrtype = 'P'

)