SELECT DISTINCT
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
        RTRIM ( ' ' || street_suffix ) ||
        RTRIM ( ' ' || locality ) ) AS "address_pr",
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

SELECT 
    IFNULL(assess,'') AS "propnum",
    IFNULL (unit_type , '' ) AS "su_type",   
    '' AS "su_prefix_1",
    IFNULL ( unit_number , '' ) AS su_no_1,
    IFNULL ( unit_suffix , '' ) AS "su_suff_1",
    '' AS "su_prefix_2",
    '' AS "su_no_2",
    '' AS "su_suff_2",
    '' AS "fl_type",
    '' AS "fl_prefix_1",
    '' AS "fl_no_1",
    '' AS "fl_suff_1",
    '' AS "fl_prefix_2",
    '' AS "fl_no_2",
    '' AS "fl_suff_2",
    '' AS "pr_name_1",
    '' AS "pr_name_2",
    '' AS "loc_des",
    '' AS "house_prefix_1",
    IFNULL ( num_from , '' ) AS "house_number_1",
    IFNULL ( num_from_suffix , '' ) AS "house_suffix_1",
    '' AS "house_prefix_2",
    IFNULL ( num_to , '' ) AS "house_number_2",
    IFNULL ( num_to_suffix , '' ) AS "house_suffix_2",
    '' AS "display_prefix_1",
    '' AS "display_no_1",
    '' AS "display_suffix_1",
    '' AS "display_prefix_2",
    '' AS "display_no_2",
    '' AS "display_suffix_2",
    IFNULL(CASE WHEN REGEXP_REPLACE(street_part,'(THE ).*','\1')='THE ' THEN street_part ELSE
	    COALESCE(REGEXP_REPLACE(street_part,'(.*)\s+(STREET|AVENUE|LANE|ROAD|TRACK|DRIVE|PARADE|HIGHWAY|CLOSE|COURT|PLACE|CRESCENT|GROVE|WAY|BOULEVARD|TRAIL|RIDGE|RISE|STRIP|RUN)\s*(NORTH|SOUTH|EAST|WEST|)$','\1'),street_part)
    END,'') AS "street_name",
    IFNULL(CASE WHEN REGEXP_REPLACE(street_part,'(THE ).*','\1')='THE ' THEN '' ELSE   
 	   REGEXP_REPLACE(street_part,'(.*)\s+(STREET|AVENUE|LANE|ROAD|TRACK|DRIVE|PARADE|HIGHWAY|CLOSE|COURT|PLACE|CRESCENT|GROVE|WAY|BOULEVARD|TRAIL|RIDGE|RISE|STRIP|RUN)\s*(NORTH|SOUTH|EAST|WEST|)$','\2') 
    END,'') AS "street_type",
    IFNULL(REGEXP_REPLACE(street_part,'(.*)\s+(STREET|AVENUE|LANE|ROAD|TRACK|DRIVE|PARADE|HIGHWAY|CLOSE|COURT|PLACE|CRESCENT|GROVE|WAY|BOULEVARD|TRAIL|RIDGE|RISE|STRIP|RUN)\s*(NORTH|SOUTH|EAST|WEST|)$','\3'),'') AS "street_suffix",
    IFNULL(COALESCE(REGEXP_REPLACE(locality_state,'(.*) VIC','\1'),locality_state),'') AS "locality",
    IFNULL ( postcode , '' ) AS "postcode"

FROM
(
    SELECT 
        assess,
        COALESCE(
	        REGEXP_REPLACE(address1,'^(\d*)([A-Z]*)/.*$','UNIT'), 
	        REGEXP_REPLACE(address1,'^(UNIT|SHOP|OFFICE).*','\1')
	) AS "unit_type",
        REPLACE(
            COALESCE(
                REGEXP_REPLACE(address1,'^(\d*)([A-Z]*)/.*$','\1'),
                REGEXP_REPLACE(address1,'^(UNIT|SHOP|OFFICE) (\d+).*$','\2')
                )
            ,'/','') AS "unit_number",
        COALESCE(
                REGEXP_REPLACE(address1,'^(\d*)([A-Z])/.*$','\2'),
                REGEXP_REPLACE(address1,'^(UNIT|SHOP|OFFICE) (\d+)([A-Z]).*$','\3')
                ) AS "unit_suffix",
        REGEXP_REPLACE(address1,'^(\d*[A-Z]*/|UNIT(.*)#|SHOP(.*)#|OFFICE(.*)#|LOT |)((\d+)(\w?)-?(\d*)(\w?))\s+(.*)$','\6') AS "num_from",
        REGEXP_REPLACE(address1,'^(\d*[A-Z]*/|UNIT(.*)#|SHOP(.*)#|OFFICE(.*)#|LOT |)((\d+)(\w?)-?(\d*)(\w?))\s+(.*)$','\7') AS "num_from_suffix",
        REGEXP_REPLACE(address1,'^(\d*[A-Z]*/|UNIT(.*)#|SHOP(.*)#|OFFICE(.*)#|LOT |)((\d+)(\w?)-?(\d*)(\w?))\s+(.*)$','\8') AS "num_to",
        REGEXP_REPLACE(address1,'^(\d*[A-Z]*/|UNIT(.*)#|SHOP(.*)#|OFFICE(.*)#|LOT |)((\d+)(\w?)-?(\d*)(\w?))\s+(.*)$','\9') AS "num_to_suffix",
        REGEXP_REPLACE(address1,'^(\d*[A-Z]*/|UNIT(.*)#|SHOP(.*)#|OFFICE(.*)#|LOT |)(\d+\w?-?\d*\w?|)\s*(.*)$','\6') AS "street_part",
        RTRIM(LTRIM(REGEXP_REPLACE(REGEXP_REPLACE(address2,'^(.*)(\d{4})$','\1'),'\s+',' '))) AS "locality_state",
        REGEXP_REPLACE(address2,'^(.*)(\d{4})$','\2') AS "postcode",
        address1,
	address2
        FROM
        (
        	select  
        		assess,
        		CASE WHEN REGEXP_REPLACE(address1,'^(UNIT|SHOP|OFFICE).*','\1')<>'' THEN address1||'#'||address2 ELSE address1 END as address1,
        		CASE WHEN REGEXP_REPLACE(address1,'^(UNIT|SHOP|OFFICE).*','\1')<>'' THEN address3 ELSE address2 END as address2
	       	from
		(
    		    	select  ASSESS as assess,
    		    		RTRIM(LTRIM(UPPER(Address__1))) as address1,
    		    		RTRIM(LTRIM(UPPER(Address__2))) as address2,    		    		
    		    		RTRIM(LTRIM(UPPER(Address__3))) as address3
    		    	from 	
    		   	 	SynergySoft
			WHERE 
				CURR_ASSESS NOT IN ( 'X' ) AND
				Type NOT IN ( 'Z' )
		)
        )
)
)