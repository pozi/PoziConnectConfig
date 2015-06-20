select
    *,
    replace ( replace ( Road_Name_Mod , ' ' , '' ) , '-' , '' ) || replace ( upper ( Locality ) , ' ' , '' ) as road_index,
    upper ( replace ( replace ( replace ( [Start Node] , '''' , '' ) , ' ' , '' ) , '-' , '' ) ) as start_point,
    upper ( replace ( replace ( replace ( [End Node] , '''' , '' ) , ' ' , '' ) , '-' , '' ) ) as end_point
from
(
select
    *,
    replace ( replace ( case
        when [Road Name] like '% Av' then replace ( upper ( [Road Name] ) , ' AV' , ' AVENUE' )
        when [Road Name] like '% Cl' then replace ( upper ( [Road Name] ) , ' CL' , ' CLOSE' )
        when [Road Name] like '% CK Rd' then replace ( upper ( [Road Name] ) , ' CK RD' , ' CREEK ROAD' )
        when [Road Name] like '% Cr' then replace ( upper ( [Road Name] ) , ' CR' , ' CRESCENT' )
        when [Road Name] like '% Crt' then replace ( upper ( [Road Name] ) , ' CRT' , ' COURT' )
        when [Road Name] like '% Ct' then replace ( upper ( [Road Name] ) , ' CT' , ' COURT' )
        when [Road Name] like '% Dr' then replace ( upper ( [Road Name] ) , ' DR' , ' DRIVE' )
        when [Road Name] like '% Drv' then replace ( upper ( [Road Name] ) , ' DRV' , ' DRIVE' )
        when [Road Name] like '% Dve' then replace ( upper ( [Road Name] ) , ' DVE' , ' DRIVE' )
        when [Road Name] like '% Hwy' then replace ( upper ( [Road Name] ) , ' HWY' , ' HIGHWAY' )
        when [Road Name] like '% L' then replace ( upper ( [Road Name] ) , ' L' , ' LANE' )
        when [Road Name] like '% Ln' then replace ( upper ( [Road Name] ) , ' LN' , ' LANE' )
        when [Road Name] like '% Pde' then replace ( upper ( [Road Name] ) , ' PDE' , ' PARADE' )
        when [Road Name] like '% Pl' then replace ( upper ( [Road Name] ) , ' PL' , ' PLACE' )
        when [Road Name] like '% Rd' then replace ( upper ( [Road Name] ) , ' RD' , ' ROAD' )
        when [Road Name] like '% Rd West' then replace ( upper ( [Road Name] ) , ' RD WEST' , ' ROAD W' )
        when [Road Name] like '% St' then replace ( upper ( [Road Name] ) , ' ST' , ' STREET' )
        when [Road Name] like '% St East' then replace ( upper ( [Road Name] ) , ' ST EAST' , ' STREET E' )
        when [Road Name] like '% St Nth Bound' then replace ( upper ( [Road Name] ) , ' ST NTH BOUND' , ' STREET N' )
        when [Road Name] like '% St North' then replace ( upper ( [Road Name] ) , ' ST NORTH' , ' STREET N' )
        when [Road Name] like '% St Nth' then replace ( upper ( [Road Name] ) , ' ST NTH' , ' STREET N' )
        when [Road Name] like '% St Sth Bound' then replace ( upper ( [Road Name] ) , ' ST STH BOUND' , ' STREET S' )
        when [Road Name] like '% St South' then replace ( upper ( [Road Name] ) , ' ST SOUTH' , ' STREET S' )
        when [Road Name] like '% St Sth' then replace ( upper ( [Road Name] ) , ' ST STH' , ' STREET S' )
        when [Road Name] like '% St West' then replace ( upper ( [Road Name] ) , ' ST WEST' , ' STREET W' )
        when [Road Name] like '% Tk' then replace ( upper ( [Road Name] ) , ' TK' , ' TRACK' )
        else upper ( [Road Name] )
    end , ' & ' , ' AND ' ) , '''' , '' ) as Road_Name_Mod
from assetic_road
)