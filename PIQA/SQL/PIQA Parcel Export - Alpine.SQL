
SELECT
	auprparc.ass_num AS propnum,
	auprparc.pcl_num AS crefno,
	auprparc.fmt_ttl as parcel_desc

FROM
	authority_auprparc auprparc

WHERE
	auprparc.pcl_flg in ( 'R' , 'P' ) AND
	auprparc.ass_num <> ''

ORDER BY
	auprparc.ass_num