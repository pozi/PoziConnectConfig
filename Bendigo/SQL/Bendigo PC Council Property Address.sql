
select
    cast ( lpaprop.tpklpaprop as varchar ) as propnum,
    '' as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when upper ( lpaaddr.prefix ) = 'ATM' then 'ATM'
        when rtrim ( lpaaddr.prefix ) = 'CAR PARK' then 'CP'
        when upper ( lpaaddr.prefix ) = 'FACTORY' then 'FY'
        when upper ( lpaaddr.prefix ) = 'FLAT' then 'FLAT'
        when upper ( lpaaddr.prefix ) = 'HOUSE' then 'HSE'
        when upper ( lpaaddr.prefix ) = 'KIOSK' then 'KSK'
        when upper ( lpaaddr.prefix ) = 'OFFICE' then 'OFFC'
        when upper ( lpaaddr.prefix ) = 'SHED' then 'SHED'
        when upper ( lpaaddr.prefix ) = 'SHOP' then 'SHOP'
        when upper ( lpaaddr.prefix ) = 'SITE' then 'SITE'
        
        when upper ( lpaaddr.prefix ) = 'SUITE' then 'SE'
        when upper ( lpaaddr.prefix ) = 'UNIT' then 'U'
        when upper ( lpaaddr.prefix ) = 'L' then 'LOT'
        when upper ( lpaaddr.prefix ) = 'ROOM' then 'ROOM'
        else ''
    end as blg_unit_type,   
    '' as blg_unit_prefix_1,
    case
        when lpaaddr.strunitnum = 0 or lpaaddr.strunitnum is null then ''
        else cast ( cast ( lpaaddr.strunitnum as integer ) as varchar )
    end as blg_unit_id_1,
    case
        when lpaaddr.strunitsfx = '0' or lpaaddr.strunitsfx is null then ''
        else cast ( lpaaddr.strunitsfx as varchar )
    end as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when lpaaddr.endunitnum = 0 or lpaaddr.endunitnum is null then ''
        else cast ( cast ( lpaaddr.endunitnum as integer ) as varchar )
    end as blg_unit_id_2,
    case
        when lpaaddr.endunitsfx = '0' or lpaaddr.endunitsfx is null then ''
        else cast ( lpaaddr.endunitsfx as varchar )
    end as blg_unit_suffix_2,

    case
      when lpaaddr.strhousnum = '0'
      then null
      else cast (lpaaddr.strhousnum as varchar(6))
   end as HOUSE_NUMBER_1,
   case
      when lpaaddr.strhoussfx = '0'
      then null
      else cast (lpaaddr.strhoussfx as varchar(2))
   end as HOUSE_SUFFIX_1,
   case
      when lpaaddr.endhousnum = '0'
      then null
      else cast (lpaaddr.endhousnum as varchar(6))
   end as HOUSE_NUMBER_2,
   case
      when lpaaddr.endhoussfx = '0'
      then null
      else cast (lpaaddr.endhoussfx as varchar )
   end as HOUSE_SUFFIX_2,
   case
      when lpaaddr.strlvlnum = '0'
      then null
      else cast (lpaaddr.strlvlnum as varchar )
   end as FLOOR_NO_1,
   cast (cnacomp.descr as varchar ) as STREET_NAME, 
   cast (cnaqual.descr as varchar ) as STREET_TYPE,
   cast (null as varchar(2)) as STREET_SUFFIX, 
   cast (lpasubr.suburbname as varchar ) as LOCALITY_NAME, 
   cast (lpaprtp.abbrev as varchar ) as Property_Type, 
   cast (lpaprop.tfklpaprop as varchar ) as Parent_Propnum
from
   ((((((Central.pthprod.pthdbo.lpaprop as lpaprop LEFT JOIN 
   Central.pthprod.pthdbo.lpaadpr as lpaadpr ON lpaprop.tpklpaprop = lpaadpr.tfklpaprop) LEFT JOIN 
   Central.pthprod.pthdbo.lpaaddr as lpaaddr ON lpaadpr.tfklpaaddr = lpaaddr.tpklpaaddr) LEFT JOIN 
   Central.pthprod.pthdbo.lpastrt as lpastrt ON lpaaddr.tfklpastrt = lpastrt.tpklpastrt) LEFT JOIN 
   Central.pthprod.pthdbo.cnacomp as cnacomp ON lpastrt.tfkcnacomp = cnacomp.tpkcnacomp) LEFT JOIN 
   Central.pthprod.pthdbo.cnaqual as cnaqual ON cnacomp.tfkcnaqual = cnaqual.tpkcnaqual) LEFT JOIN 
   Central.pthprod.pthdbo.lpaprtp as lpaprtp ON lpaprop.tfklpaprtp = lpaprtp.tpklpaprtp) LEFT JOIN 
   Central.pthprod.pthdbo.lpasubr as lpasubr ON lpaaddr.tfklpasubr = lpasubr.tpklpasubr
where
   lpaaddr.addrtype='P'

