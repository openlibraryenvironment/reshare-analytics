SELECT
    ss_supplier AS supplier,
    count(DISTINCT ss_req_id) AS reqs,
    sum(
        CASE WHEN ss_to_status = 'RES_UNFILLED' THEN
            1
        ELSE
            0
        END) AS unfilled,
    sum(
        CASE WHEN ss_to_status = 'RES_AWAIT_SHIP' THEN
            1
        ELSE
            0
        END) AS filled,
    sum(
        CASE WHEN ss_to_status = 'RES_ITEM_SHIPPED'
            AND ss_from_status = 'RES_AWAIT_SHIP' THEN
            1
        ELSE
            0
        END) AS shipped,
    sum(
        CASE WHEN ss_to_status = 'RES_CANCELLED' THEN
            1
        ELSE
            0
        END) AS cancels,
    cast(sum(
            CASE WHEN ss_to_status = 'RES_AWAIT_SHIP' THEN
                1
            ELSE
                0
            END) AS decimal) / count(DISTINCT ss_req_id) AS filled_ratio,
    cast(sum(
            CASE WHEN ss_to_status = 'RES_ITEM_SHIPPED'
                AND ss_from_status = 'RES_AWAIT_SHIP' THEN
                1
            ELSE
                0
            END) AS decimal) / count(DISTINCT ss_req_id) AS supplied_ratio
FROM
    reshare_derived.sup_stats
GROUP BY
    supplier
UNION
SELECT
    'constorium' AS supplier,
    count(DISTINCT ss_req_id) AS reqs,
    sum(
        CASE WHEN ss_to_status = 'RES_UNFILLED' THEN
            1
        ELSE
            0
        END) AS unfilled,
    sum(
        CASE WHEN ss_to_status = 'RES_AWAIT_SHIP' THEN
            1
        ELSE
            0
        END) AS filled,
    sum(
        CASE WHEN ss_to_status = 'RES_ITEM_SHIPPED'
            AND ss_from_status = 'RES_AWAIT_SHIP' THEN
            1
        ELSE
            0
        END) AS shipped,
    sum(
        CASE WHEN ss_to_status = 'RES_CANCELLED' THEN
            1
        ELSE
            0
        END) AS cancels,
    cast(sum(
            CASE WHEN ss_to_status = 'RES_AWAIT_SHIP' THEN
                1
            ELSE
                0
            END) AS decimal) / count(DISTINCT ss_req_id) AS filled_ratio,
    cast(sum(
            CASE WHEN ss_to_status = 'RES_ITEM_SHIPPED'
                AND ss_from_status = 'RES_AWAIT_SHIP' THEN
                1
            ELSE
                0
            END) AS decimal) / count(DISTINCT ss_req_id) AS supplied_ratio
FROM
    reshare_derived.sup_stats;

