WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    supplier,
    avg(date_diff) AS avg_time_to_ship,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) AS med_time_to_ship
FROM (
    SELECT
        nss.ss_supplier_nice_name AS supplier,
        nss.ss_date_created AS t_start,
        nss2.ss_date_created AS t_end,
        nss.ss_req_id,
        nss2.ss_req_id,
        nss.ss_from_status AS one_from,
        nss.ss_to_status AS one_to,
        nss2.ss_from_status AS two_from,
        nss2.ss_to_status AS two_to,
        nss.ss_message AS one_message,
        nss2.ss_message AS two_message,
        (nss2.ss_date_created - nss.ss_date_created) AS date_diff
    FROM
        reshare_derived.sup_stats nss,
        reshare_derived.sup_stats nss2
    WHERE
        nss.ss_req_id = nss2.ss_req_id
        AND (((nss.ss_from_status = 'RES_AWAIT_PICKING'
                    AND nss.ss_to_status = 'RES_AWAIT_SHIP')
                OR (nss.ss_from_status = 'RES_AWAIT_PICKING'
                    AND nss.ss_to_status = 'RES_ITEM_SHIPPED'))
            AND ((nss2.ss_from_status = 'RES_AWAIT_SHIP'
                    AND nss2.ss_to_status = 'RES_ITEM_SHIPPED')
                OR (nss2.ss_from_status = 'RES_AWAIT_PICKING'
                    AND nss2.ss_to_status = 'RES_ITEM_SHIPPED')))
        AND nss.ss_date_created >= (
            SELECT
                start_date
            FROM
                parameters)
            AND nss.ss_date_created < (
                SELECT
                    end_date
                FROM
                    parameters)) AS data
GROUP BY
    data.supplier;

