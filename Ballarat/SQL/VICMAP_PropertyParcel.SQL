
select pa.parcel_pfi as parcel_pfi
, pa.PC_CREFNO as PC_CREFNO
, pa.parcel_spi as parcel_spi
, pa.PC_PLANNO as PC_PLANNO
,pa.pc_lotno as pc_lotno
,pa.PC_STAT As pc_status 
,pr.PR_LGAC as LGA_code
,pr.PROP_PFI as Pr_PFI
,pr.PR_MULTASS as PR_MULTASS
,pr.PR_PTYPE as PR_PTYPE
,pr.PV_FTYPE as PV_FTYPE
,pr.[PR_PROPNUM] as PR_PROPNUM
,pac.PACount as VM_MultiParcelCount
,addr.ezi_add as ezi_add
,pr.GEOMETRY as GEOMETRY


FROM         DSE_VMPROP_PARCEL pa INNER JOIN DSE_VMPROP_PARCEL_PROPERTY papr 
		ON  pa.PARCEL_PFI = papr.PARCEL_PFI
			   INNER JOIN DSE_VMPROP_PROPERTY pr
			ON papr.PR_PFI = pr.PROP_PFI
					INNER JOIN VM_Parcel_Count pac
				 ON pr.PROP_PFI = pac.PR_PFI	
						left outer JOIN DSE_VMADD_ADDRESS addr
				     ON pr.PROP_PFI = addr.PR_PFI

           

WHERE pr.PR_PTYPE = 'O' and pr.PV_FTYPE in ('5721','5741','27721','27741') and pr.PR_LGAC =302
















