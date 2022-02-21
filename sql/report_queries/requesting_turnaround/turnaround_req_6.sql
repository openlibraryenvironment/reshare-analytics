WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    nrs.rs_requester_nice_name,
    count(*) AS reqs_over_72
FROM
    reshare_derived.req_stats nrs,
    reshare_derived.req_stats nrs2
WHERE
    nrs.rs_req_id = nrs2.rs_req_id
    AND (nrs.rs_to_status = 'REQ_VALIDATED'
        AND nrs2.rs_from_status = 'REQ_SHIPPED'
        AND nrs2.rs_to_status = 'REQ_CHECKED_IN')
    AND (nrs2.rs_date_created - nrs.rs_date_created) > '3 days'
    AND nrs.rs_date_created >= (
        SELECT
            start_date
        FROM
            parameters)
    AND nrs.rs_date_created < (
        SELECT
            end_date
        FROM
            parameters)
GROUP BY
    nrs.rs_requester_nice_name;

