SELECT
    *,
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) AS roadnt_pr,
    street_name ||
        RTRIM ( ' ' || street_type ) ||
        RTRIM ( ' ' || street_suffix ) || ' ' ||
        locality AS stjoin_pr,
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
        RTRIM ( ' ' || locality ) ) AS address_pr,
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
        RTRIM ( ' ' || propnum ) ) AS address_propnum_pr
FROM (
SELECT DISTINCT
    auprparc.ass_num AS propnum,
    CAST (auprparc.pcl_num AS VARCHAR) AS crefno,
    '' AS su_type,
    '' AS su_prefix_1,
    IFNULL ( auprstad.pcl_unt , '' ) AS su_no_1,
    IFNULL ( auprstad.unt_alp , '' ) AS su_suff_1,
    '' AS su_prefix_2,
    '' AS su_no_2,
    '' AS su_suff_2,
    '' AS fl_type,
    IFNULL ( auprstad.flo_pre , '' ) AS fl_prefix_1,
    IFNULL ( auprstad.flo_num , '' ) AS fl_no_1,
    '' AS fl_suff_1,
    '' AS fl_prefix_2,
    '' AS fl_no_2,
    '' AS fl_suff_2,
    IFNULL ( auprparc.ttl_nme , '' ) AS pr_name_1,
    '' AS pr_name_2,
    '' AS loc_des,
    '' AS house_prefix_1,
    IFNULL ( auprstad.hou_num , '' ) AS house_number_1,
    IFNULL ( auprstad.hou_alp , '' ) AS house_suffix_1,
    '' AS house_prefix_2,
    IFNULL ( auprstad.hou_end , '' ) AS house_number_2,
    IFNULL ( auprstad.end_alp , '' ) AS house_suffix_2,
    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,    
    CASE
        WHEN UPPER ( auprstad.str_nme ) = 'PARK AVENUE NORTH' THEN 'PARK'
        WHEN UPPER ( auprstad.str_nme ) = 'HILLSIDE (SOUTH)' THEN 'HILLSIDE'
        WHEN UPPER ( auprstad.str_nme ) like '%-LEFT ARM' THEN REPLACE (UPPER( auprstad.str_nme ),'-',' ')
        WHEN UPPER ( auprstad.str_nme ) like '%-RIGHT ARM' THEN REPLACE (UPPER( auprstad.str_nme ),'-',' ')
        WHEN UPPER ( auprstad.str_nme ) like '%-FIRST' THEN REPLACE (UPPER( auprstad.str_nme ),'-',' ')        
        ELSE UPPER ( auprstad.str_nme )
    END as street_name,
    CASE
        WHEN UPPER ( auprstad.str_nme ) like '% AVENUE NORTH' THEN 'AVENUE'
        WHEN auprstad.str_typ IN ( 'AV','AVE','AVEE','AVEN','AVES','AVEW','AVEX' ) THEN 'AVENUE'
        WHEN auprstad.str_typ = 'BND' THEN 'BEND'
        WHEN auprstad.str_typ = 'BVD' THEN 'BOULEVARD'
        WHEN auprstad.str_typ = 'CL' THEN 'CLOSE'
        WHEN auprstad.str_typ = 'CON' THEN 'CONNECTION'
        WHEN auprstad.str_typ = 'CRES' THEN 'CRESCENT'
        WHEN auprstad.str_typ = 'CR' THEN 'CRESCENT'
        WHEN auprstad.str_typ = 'CT' THEN 'COURT'
        WHEN auprstad.str_typ = 'DR' THEN 'DRIVE'
        WHEN auprstad.str_typ = 'GR' THEN 'GROVE'
        WHEN auprstad.str_typ = 'HTS' THEN 'HEIGHTS'
        WHEN auprstad.str_typ = 'HWY' THEN 'HIGHWAY'
        WHEN auprstad.str_typ = 'LA' THEN 'LANE'
        WHEN auprstad.str_typ = 'ML' THEN 'MALL'
        WHEN auprstad.str_typ = 'MW' THEN 'MEWS'
        WHEN auprstad.str_typ = 'PDE' THEN 'PARADE'
        WHEN auprstad.str_typ = 'PK' THEN 'PARK'
        WHEN auprstad.str_typ = 'PL' THEN 'PLACE'
        WHEN auprstad.str_typ IN ( 'RD','RDE','RDN','RDS','RDW','RDEX','RDX' ) THEN 'ROAD'
        WHEN auprstad.str_typ = 'RES' THEN 'RESERVE'
        WHEN auprstad.str_typ = 'RL' THEN 'RISE'
        WHEN auprstad.str_typ IN ( 'ST','STE','STN','STS','STW','STEX','STX','SSTH' ) THEN 'STREET'
        WHEN auprstad.str_typ = 'TCE' THEN 'TERRACE'
        WHEN auprstad.str_typ = 'TR' THEN 'TRACK'
        WHEN auprstad.str_typ = 'WK' THEN 'WALK'
        WHEN auprstad.str_typ = 'WY' THEN 'WAY'
        WHEN auprstad.str_typ = 'WYND' THEN 'WYND'
        WHEN auprstad.str_typ = 'WYD' THEN 'WYND'
        WHEN auprstad.str_typ = 'CH' THEN 'CHASE'
        WHEN auprstad.str_typ = 'RND' THEN 'ROUND'
        WHEN auprstad.str_typ = 'HILL' THEN 'HILL'
        ELSE ''
    END as street_type,
    CASE
        WHEN auprstad.str_typ IN ( 'AVEN' , 'RDN' , 'STN' ) THEN 'N'
        WHEN auprstad.str_typ IN ( 'AVES' , 'RDS' , 'STS' , 'SSTH' ) THEN 'S'
        WHEN auprstad.str_typ IN ( 'AVEE' , 'RDE' , 'STE' ) THEN 'E'
        WHEN auprstad.str_typ IN ( 'AVEW' , 'RDW' , 'STW' ) THEN 'W'
        WHEN auprstad.str_typ IN ( 'AVEX' , 'RDEX' , 'STEX' ) THEN 'EX'
        WHEN UPPER ( auprstad.str_nme ) like '% AVENUE NORTH' THEN 'N'
        WHEN UPPER ( auprstad.str_nme ) like '% (SOUTH)' THEN 'S'
        ELSE ''
    END AS street_suffix,
    UPPER ( auprstad.sbr_nme ) AS locality,
    '' AS postcode
FROM
    AUTHORITY_auprparc AS auprparc ,
    AUTHORITY_auprstad AS auprstad
WHERE
    auprparc.pcl_num = auprstad.pcl_num AND
    auprparc.pcl_flg in ( 'R' , 'P' ) AND
    auprparc.ass_num <> 0 AND
    auprstad.seq_num = 0
)