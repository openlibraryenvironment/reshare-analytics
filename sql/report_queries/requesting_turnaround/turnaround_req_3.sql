SELECT
    requester,
    avg(date_diff) AS avg_time_total,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY date_diff) AS med_time_total
FROM (
    SELECT
        nrs.rs_requester AS requester,
        nrs.rs_date_created AS t_start,
        nrs2.rs_date_created AS t_end,
        nrs.rs_req_id,
        nrs2.rs_req_id,
        nrs.rs_to_status,
        nrs2.rs_to_status,
        (nrs2.rs_date_created - nrs.rs_date_created) AS date_diff
    FROM
        reshare_derived.req_stats nrs,
        reshare_derived.req_stats nrs2
    WHERE
        nrs.rs_req_id = nrs2.rs_req_id
        AND (nrs.rs_to_status = 'REQ_VALIDATED'
            AND nrs2.rs_to_status = 'REQ_CHECKED_IN')) AS data
GROUP BY
    data.requester;

