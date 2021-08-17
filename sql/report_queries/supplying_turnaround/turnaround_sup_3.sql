SELECT
    supplier,
    avg(date_diff) AS avg_time_to_receipt,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) AS med_time_to_receipt
FROM (
    SELECT
        nsts.stst_supplier AS supplier,
        nsts.stst_date_created AS t_start,
        nsts2.stst_date_created AS t_end,
        nsts.stst_req_id,
        nsts2.stst_req_id,
        nsts.stst_from_status AS one_from,
        nsts.stst_to_status AS one_to,
        nsts2.stst_from_status AS two_from,
        nsts2.stst_to_status AS two_to,
        nsts.stst_message AS one_message,
        nsts2.stst_message AS two_message,
        (nsts2.stst_date_created - nsts.stst_date_created) AS date_diff
    FROM
        reshare_derived.sup_tat_stats nsts,
        reshare_derived.sup_tat_stats nsts2
    WHERE
        nsts.stst_req_id = nsts2.stst_req_id
        AND (nsts.stst_from_status = 'RES_AWAIT_SHIP'
            AND nsts.stst_to_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_message = 'Shipment received by requester')) AS data
GROUP BY
    data.supplier;

