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
        CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix )) AS "address_pr",
    LTRIM ( su_prefix_1 || su_no_1 || su_suff_1 ||
        CASE WHEN su_no_2 <> '' THEN '-' ELSE '' END ||
        su_prefix_2 || su_no_2 || su_suff_2 ||
        CASE WHEN su_no_1 <> '' THEN '/' ELSE '' END ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        CASE WHEN house_number_2 <> '' THEN '-' ELSE '' END ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        RTRIM ( ' ' || street_name ) ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ||
        RTRIM ( ' ' || propnum ) ) AS "address_propnum_pr"

FROM (

SELECT DISTINCT

    lpaprop.tpklpaprop AS "propnum",
	CAST(lpaprop.tpklpaprop as integer)  AS "PROPNUM_INT",
    
	CASE
        WHEN UPPER ( lpaaddr.unitprefix ) = 'ATM' THEN 'ATM'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'CAR PARK' THEN 'CARP'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'FACTORY' THEN 'FCTY'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'FLAT' THEN 'FLAT'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'KIOSK' THEN 'KSK'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'OFFICE' THEN 'OFFC'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'SHED' THEN 'SHED'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'SHOP' THEN 'SHOP'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'SIGN' THEN 'SIGN'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'SUITE' THEN 'SE'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'UNIT' THEN 'UNIT'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'L' THEN 'LOT'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'LOT' THEN 'LOT'
        WHEN UPPER ( lpaaddr.unitprefix ) = 'ROOM' THEN 'ROOM'
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
    CASE
       WHEN TRIM ( lpaaddr.endunitsfx ) = '0' OR lpaaddr.endunitsfx IS NULL THEN ''
       ELSE TRIM ( lpaaddr.endunitsfx )
    END AS "su_suff_2",
    CASE
        WHEN UPPER ( lpaaddr.lvlprefix ) = 'BASEMENT' THEN 'B'
        WHEN UPPER ( lpaaddr.lvlprefix ) = 'LEVEL' THEN 'L'
        WHEN UPPER ( lpaaddr.lvlprefix ) = 'FLOOR' THEN 'FL'
        WHEN UPPER ( lpaaddr.lvlprefix ) = 'GRD FLOOR' THEN 'G'
        ELSE ''
    END AS "fl_type",
    '' AS "fl_prefix_1",
    CASE
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'FLOOR' , 'LEVEL' ) THEN TRIM ( lpaaddr.strlvlnum )
        ELSE ''
    END AS 'fl_no_1',
    '' AS "fl_suff_1",
    '' AS "fl_prefix_2",
    CASE
        WHEN UPPER ( lpaaddr.lvlprefix ) IN ( 'FLOOR' , 'LEVEL' ) AND TRIM ( lpaaddr.endlvlnum ) <> '0' THEN TRIM ( lpaaddr.endlvlnum )
        ELSE ''
    END AS 'fl_no_2',
    '' AS "fl_suff_2",
    IFNULL ( UPPER ( lpapnam.propname ) , '' ) AS "pr_name_1",
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
    UPPER (REPLACE ( cnacomp.descr,' - ','-' )) AS "street_name", 
    CASE
        WHEN cnaqual.descr like '% NORTH' or
            cnaqual.descr like '% SOUTH' or
            cnaqual.descr like '% EAST' or
            cnaqual.descr like '% WEST' THEN UPPER ( TRIM ( SUBSTR ( cnaqual.descr , 1 , LENGTH ( cnaqual.descr ) - 5 ) ) )
        ELSE UPPER ( cnaqual.descr )
    END AS "street_type",
    CASE
        WHEN UPPER ( cnaqual.descr ) like '% NORTH' THEN 'N'
        WHEN UPPER ( cnaqual.descr ) like '% SOUTH' THEN 'S'
        WHEN UPPER ( cnaqual.descr ) like '% EAST' THEN 'E'
        WHEN UPPER ( cnaqual.descr ) like '% WEST' THEN 'W'
        ELSE ''
    END AS "street_suffix", 
	
	CASE
        WHEN UPPER (lpasubr.suburbname) = 'GOLDEN POINT' THEN 'GOLDEN POINT (BALLARAT)'
        WHEN UPPER (lpasubr.suburbname) = 'ASCOT' THEN 'ASCOT (BALLARAT)'
		ELSE UPPER (lpasubr.suburbname)
    END AS "locality",
    '' AS "postcode"

FROM
    PATHWAY_lpaprop AS lpaprop LEFT JOIN 
    PATHWAY_lpaadpr AS lpaadpr ON lpaprop.tpklpaprop = lpaadpr.tfklpaprop
LEFT JOIN 
    PATHWAY_lpaaddr AS lpaaddr ON lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr
LEFT JOIN 
    PATHWAY_lpastrt AS lpastrt ON lpaaddr.tfklpastrt = lpastrt.tpklpastrt
LEFT JOIN 
    PATHWAY_cnacomp AS cnacomp ON lpastrt.tfkcnacomp = cnacomp.tpkcnacomp
LEFT JOIN 
    PATHWAY_cnaqual AS cnaqual ON cnacomp.tfkcnaqual = cnaqual.tpkcnaqual
LEFT JOIN 
    PATHWAY_lpaprtp AS lpaprtp ON lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp 
LEFT JOIN 
    PATHWAY_lpasubr AS lpasubr ON lpaaddr.tfklpasubr = lpasubr.tpklpasubr
LEFT JOIN
    PATHWAY_lpapnam AS lpapnam ON lpaprop.tpklpaprop = lpapnam.tfklpaprop 

WHERE
    lpaprop.status <> 'H' AND 
    lpaprop.tfklpacncl = 14 AND
    lpaaddr.addrtype = 'P' AND
    lpaprtp.abbrev <> 'OTH'

)