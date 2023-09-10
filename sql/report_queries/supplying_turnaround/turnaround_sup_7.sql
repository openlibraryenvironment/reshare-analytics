WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    supplier,
    avg(date_diff) AS avg_time_total,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) AS med_time_total
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
        report.sup_tat_stats() AS nsts,
        report.sup_tat_stats() AS nsts2
    WHERE
        nsts.stst_req_id = nsts2.stst_req_id
        AND (nsts.stst_from_status IS NULL
            AND nsts.stst_to_status = 'RES_IDLE'
            AND nsts2.stst_from_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_to_status = 'RES_ITEM_SHIPPED'
            AND nsts2.stst_message = 'Shipment received by requester')
        AND nsts.stst_date_created >= (
            SELECT
                start_date
            FROM
                parameters)
            AND nsts.stst_date_created < (
                SELECT
                    end_date
                FROM
                    parameters)) AS data
GROUP BY
    data.supplier;

