
select ad.BLGUNTTYP AS su_type
, ad.[BUNIT_PRE1] AS su_prefix_1
, [ad].[BUNIT_ID1] AS [su_no_1]
, ad.[BUNIT_SUF1] AS su_suff_1
, ad.[BUNIT_PRE2] AS su_prefix_2
, [ad].[BUNIT_ID2] AS [su_no_2]
, ad.[BUNIT_SUF2] AS su_suff_2
, ad.[FLOOR_TYPE] AS fl_type
, ad.[FL_PREF1] AS fl_prefix_1
, [ad].[FLOOR_NO_1] AS [fl_no_1]
, ad.[FL_SUF1] AS fl_suff_1
, ad.[FL_PREF2] AS fl_prefix_2
, [ad].[FLOOR_NO_2] AS [fl_no_2]
, ad.[BUILDING] AS pr_name_1
, ad.[COMPLEX] AS pr_name_2
, ad.[LOCALITY] AS loc_desc
, ad.[HSE_PREF1] AS house_prefix_1
, [ad].[HSE_NUM1] AS [house_number_1]
, ad.[HSE_SUF1] AS house_suffix_1
, ad.[HSE_PREF2] AS house_prefix_2
, [ad].[HSE_NUM2] AS [house_number_2]
, ad.[HSE_SUF2] AS house_suffix_2
, ad.[DISP_PREF1] AS display_prefix_1
, [ad].[DISP_NUM1] AS [display_no_1]
, ad.[DISP_SUF1] AS display_suffix_1
, ad.[DISP_PREF2] AS display_prefix_2
, [ad].[DISP_NUM2] AS [display_no_2]
, ad.[DISP_SUF2] AS display_suffix_2
, ad.[ROAD_NAME] AS street_name
, ad.[ROAD_TYPE] AS street_type
, ad.[RD_SUF] AS street_suffix
, ad.[LOCALITY] as Locality
, ad.[POSTCODE] AS Postcode
,pr.PROP_PFI as Pr_PFI
,ad.PR_PFI as Ad_PFI
,pr.PR_LGAC AS LGA_CODE
,pr.PR_MULTASS as PR_MULTASS
,pr.PR_PTYPE as PR_PTYPE
,pr.[PR_PROPNUM] as PROPNUM
,ad.NUM_ADD as HOUSE_NUMBER
, ad.[EZI_ADD] AS EZI_ADD
, LTRIM (IFNULL(HSE_PREF1,'') || CASE WHEN BUNIT_ID1= 0 THEN '' ELSE BUNIT_ID1 END || ifnull(BUNIT_SUF1,'')||
          CASE WHEN BUNIT_ID2 <> 0 THEN '-' ELSE '' END || 
          IFNULL(BUNIT_PRE2,'') || CASE WHEN BUNIT_ID2=0 THEN '' ELSE BUNIT_ID2 END || IFNULL(BUNIT_SUF2,'') ||          
          CASE WHEN BUNIT_ID1 <> 0 THEN '/' ELSE '' END ||          
          IFNULL(HSE_PREF1,'') || CASE WHEN HSE_NUM1=0 THEN '' ELSE HSE_NUM1 END || IFNULL(HSE_SUF1,'') ||         
          CASE WHEN HSE_NUM2 <> 0 THEN '-' ELSE '' END ||          
          IFNULL(HSE_PREF2,'') || CASE WHEN HSE_NUM2=0 THEN '' ELSE HSE_NUM2 END || IFNULL(HSE_SUF2,'') ||          
    RTRIM ( ' ' || IFNULL(ROAD_NAME,''),'' ) ||
        RTRIM ( ' ' || IFNULL(ROAD_TYPE,'') ) ||
        RTRIM ( ' ' || IFNULL(RD_SUF,'') ) ||
        RTRIM ( ' ' || IFNULL(LOCALITY,'') ))  AS EZI_ADD_CONCAT
                                      

, CASE WHEN ad.[ROAD_TYPE] is null THEN TRIM (IFNULL (ad.[NUM_ADD],'')||' '||REPLACE(ad.[ROAD_NAME],'-',' ')||' '||[LOCALITY] )
       WHEN ad.[RD_SUF] is not null THEN TRIM (IFNULL (ad.[NUM_ADD],'')||' '||REPLACE(ad.[ROAD_NAME],'-',' ')||' '||ad.[ROAD_TYPE]||' '||ad.[RD_SUF]||' '||[LOCALITY])
       ELSE TRIM (IFNULL (ad.[NUM_ADD],'')||' '||REPLACE(ad.[ROAD_NAME],'-',' ')||' '||ad.[ROAD_TYPE]||' '||[LOCALITY]) 
   END  AS EZI_ADD_NO_PC






FROM         DSE_VMPROP_PROPERTY pr  
          LEFT OUTER JOIN DSE_VMADD_ADDRESS ad
          ON pr.PROP_PFI = ad.PR_PFI

           

WHERE pr.PR_PTYPE = 'O' and pr.PV_FTYPE in ('5721','5741','27721','27741') and pr.PR_LGAC =366 and ad.Is_primary='Y'

