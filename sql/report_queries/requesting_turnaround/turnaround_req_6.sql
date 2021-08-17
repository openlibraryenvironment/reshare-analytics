SELECT
    nrs.rs_requester,
    count(*) AS reqs_over_72
FROM
    reshare_derived.req_stats nrs,
    reshare_derived.req_stats nrs2
WHERE
    nrs.rs_req_id = nrs2.rs_req_id
    AND (nrs.rs_to_status = 'REQ_VALIDATED'
        AND nrs2.rs_to_status = 'REQ_CHECKED_IN')
    AND (nrs2.rs_date_created - nrs.rs_date_created) > '3 days'
GROUP BY
    nrs.rs_requester;

