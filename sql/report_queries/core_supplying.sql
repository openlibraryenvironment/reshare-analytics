SELECT
    'NORTH' AS requestor,
    count(DISTINCT ss_req_id) AS reqs,
    count(*) FILTER (WHERE ss_to_status = 'RES_UNFILLED') AS unfilled,
    count(*) FILTER (WHERE ss_to_status = 'RES_AWAIT_SHIP') AS filled,
    count(*) FILTER (WHERE ss_to_status = 'RES_ITEM_SHIPPED'
        AND ss_from_status = 'RES_AWAIT_SHIP') AS shipped,
    count(*) FILTER (WHERE ss_to_status = 'RES_CANCELLED') AS cancels,
    cast(count(*) FILTER (WHERE ss_to_status = 'RES_AWAIT_SHIP') AS decimal) / count(DISTINCT ss_req_id) AS filled_ratio,
    cast(count(*) FILTER (WHERE ss_to_status = 'RES_ITEM_SHIPPED'
            AND ss_from_status = 'RES_AWAIT_SHIP') AS decimal) / count(DISTINCT ss_req_id) AS supplied_ratio
FROM
    reshare_reporting.north_sup_stats;