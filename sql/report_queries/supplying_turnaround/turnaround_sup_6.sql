WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    nsts.stst_supplier AS supplier,
    count(*) AS reqs_over_72
FROM
    report.sup_tat_stats() AS nsts,
    report.sup_tat_stats() AS nsts2
WHERE
    nsts.stst_req_id = nsts2.stst_req_id
    AND (nsts.stst_from_status IS NULL
        AND nsts.stst_to_status = 'RES_IDLE'
        AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
        AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
        AND nsts2.stst_message = 'Shipment received by requester')
    AND (nsts2.stst_date_created - nsts.stst_date_created) > '3 days'
    AND nsts.stst_date_created >= (
        SELECT
            start_date
        FROM
            parameters)
    AND nsts.stst_date_created < (
        SELECT
            end_date
        FROM
            parameters)
GROUP BY
    nsts.stst_supplier;

