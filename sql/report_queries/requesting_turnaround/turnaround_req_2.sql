WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    requester,
    avg(date_diff) AS avg_time_to_receipt,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) AS med_time_to_receipt
FROM (
    SELECT
        nrs.rs_requester_nice_name AS requester,
        nrs.rs_date_created AS t_start,
        nrs2.rs_date_created AS t_end,
        nrs.rs_req_id,
        nrs2.rs_req_id,
        nrs.rs_to_status,
        nrs2.rs_to_status,
        (nrs2.rs_date_created - nrs.rs_date_created) AS date_diff
    FROM
        report.req_stats() AS nrs,
        report.req_stats() AS nrs2
    WHERE
        nrs.rs_req_id = nrs2.rs_req_id
        AND (nrs.rs_from_status = 'REQ_EXPECTS_TO_SUPPLY'
            AND nrs.rs_to_status = 'REQ_SHIPPED'
            AND nrs2.rs_from_status = 'REQ_SHIPPED'
            AND nrs2.rs_to_status = 'REQ_CHECKED_IN')
        AND nrs.rs_date_created >= (
            SELECT
                start_date
            FROM
                parameters)
            AND nrs.rs_date_created < (
                SELECT
                    end_date
                FROM
                    parameters)) AS data
GROUP BY
    data.requester;

