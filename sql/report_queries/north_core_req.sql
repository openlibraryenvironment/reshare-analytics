SELECT
    'NORTH' AS requestor,
    sum(1) FILTER (WHERE rs_to_status = 'REQ_VALIDATED') AS reqs,
    sum(1) FILTER (WHERE rs_to_status = 'REQ_CANCELLED') AS cancelled,
    sum(1) FILTER (WHERE rs_to_status = 'REQ_END_OF_ROTA') AS unfilled,
    sum(1) FILTER (WHERE rs_to_status = 'REQ_CHECKED_IN'
        OR rs_to_status = 'REQ_FILLED_LOCALLY') AS received,
    (sum(1) FILTER (WHERE rs_to_status = 'REQ_CHECKED_IN') / cast(sum(1) FILTER (WHERE rs_to_status = 'REQ_VALIDATED') AS decimal)) AS filled_ratio
FROM
    reshare_derived.north_req_stats;
