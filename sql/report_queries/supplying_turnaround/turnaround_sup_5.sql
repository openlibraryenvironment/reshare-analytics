SELECT
    nsts.stst_supplier AS supplier,
    count(*) AS reqs_btwn_48_72
FROM
    reshare_derived.sup_tat_stats nsts,
    reshare_derived.sup_tat_stats nsts2
WHERE
    nsts.stst_req_id = nsts2.stst_req_id
    AND (nsts.stst_from_status IS NULL
        AND nsts.stst_to_status = 'RES_IDLE'
        AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
        AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
        AND nsts2.stst_message = 'Shipment received by requester')
    AND ((nsts2.stst_date_created - nsts.stst_date_created) > '2 days'
        AND (nsts2.stst_date_created - nsts.stst_date_created) < '3 days')
GROUP BY
    nsts.stst_supplier;

