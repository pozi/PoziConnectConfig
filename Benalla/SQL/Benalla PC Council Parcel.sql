select
    *,
    replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( replace ( spi , 'CP' , '' ) , 'CS' , '' ) , 'LP' , '' ) , 'PC' , '' ) , 'PS' , '' ) , 'RP' , '' ) , 'SP' , '' ) , 'TP' , '' ) , 'PP' , '' ) as simple_spi
from
(
select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi
from
(
select distinct
    assess as propnum,
    '' as status,
    dola_pin as crefno,
    '' as internal_spi,
    case
        when [pt_lot/ca] like 'P%T%' then 'P'
        else ''
    end as part,
    '' as summary,
    case
        when plan_number = 'PP' then ''
        else replace ( plan_number , ' ' , '' )
    end as plan_number,
    case
        when plan_number = 'PP' then ''
        else substr ( plan_number , 1 , 2 )
    end as plan_prefix,
    case
        when plan_number = 'PP' then ''
        else substr ( plan_number , 4 , 99 )
    end as plan_numeral,
    case
        when plan_number = 'PP' then ''
        else replace ( replace ( replace ( [lot/ca_no] , 'NO' , '' ) , 'RESERVE' , 'RES' ) , ' ' , '' )
    end as lot_number,
    case
        when plan_number = 'PP' then [lot/ca_no]
        else ''
    end as allotment,
    [section] as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    case
        when plan_number <> 'PP' then ''
        else
            case upper ( parish )
                when 'BENALLA' then '2113'
                when 'BOHO' then '2166'
                when 'BOWEYA' then '2214'
                when 'BUNGEET' then '2282'
                when 'VILLAGE OF BUNGEET' then '2282'
                when 'DEVENISH' then '2519'
                when 'DUERAN' then '2556'
                when 'GLENROWAN' then '2685'
                when 'GLENROWEN' then '2685'
                when 'GOOMALIBEE' then '2698'
                when 'GOORAMBAT' then '2704'
                when 'GRETA' then '2726'
                when 'KARRABUMET' then '2844'
                when 'KELFEERA' then '2858'
                when 'KILLAWARRA' then '2876'
                when 'LIMA' then '2998'
                when 'LURG' then '3022'
                when 'MOKOAN' then '3141'
                when 'MOORNGAG' then '3174'
                when 'MYRRHEE' then '3248'
                when 'NILLAHCOOTIE' then '3309'
                when 'ROTHESAY' then '3459'
                when 'ST. JAMES' then '3466'
                when 'SAMARIA' then '3471'
                when 'STEWARTON' then '3501'
                when 'TALLANGALLOOK' then '3529'
                when 'TAMINICK' then '3537'
                when 'TATONG' then '3565'
                when 'TOOMBULLUP' then '3623'
                when 'TOOMBULLUP NORTH' then '3624'
                when 'TOO-ROUR' then '3633'
                when 'TOOROUR' then '3633'
                when 'UPOTIPOTPON' then '3684'
                when 'WAGGARANDALL' then '3697'
                when 'WARRENBAYNE' then '3759'
                when 'WINTON' then '3843'
                else ''
            end
    end as parish_code,
    case
        when plan_number <> 'PP' then ''
        else
            case upper ( parish )
                when 'BADDAGINNIE T/SHIP' then '5026'
                when 'BENALLA T/SHIP' then '5066'
                when 'BUNGEET T/SHIP' then '5133'
                when 'DEVENISH WEST T/SHIP' then '5240'
                when 'T/SHIP DEVENISH WEST' then '5240'
                when 'GLENROWEN T/SHIP' then '5327'
                when 'MOLYULLAH T/SHIP' then '5545'
                when 'SWANPOOL T/SHIP' then '5748'
                when 'TATONG T/SHIP' then '5771'
                when 'TOWNSHIP TATONG' then '5771'
                when 'THOONA T/SHIP' then '5782'
                when 'WINTON T/SHIP' then '5867'
                else ''
            end
    end as township_code,
    '381' as lga_code,
    assess as assnum
from
    synergysoft
where
    curr_assess <> 'X' and
    type not in ( 'D' , 'Z' )
)
)