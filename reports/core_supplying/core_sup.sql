--metadb:function core_sup

DROP FUNCTION IF EXISTS core_sup;

CREATE FUNCTION core_sup(
    start_date date DEFAULT '2020-01-01',
    end_date date DEFAULT '2030-01-01')
RETURNS TABLE(
    supplier text,
    reqs bigint,
    unfilled bigint,
    filled bigint,
    shipped bigint,
    cancels bigint,
    filled_ratio numeric,
    supplied_ratio numeric)
AS $$
SELECT
    supplier,
    reqs,
    unfilled,
    filled,
    shipped,
    cancels,
    filled_ratio,
    supplied_ratio
FROM (
    SELECT
        ss_supplier_nice_name AS supplier,
        sum(
            CASE WHEN ss_from_status IS NULL
                AND ss_to_status = 'RES_IDLE' THEN
                1
            ELSE
                0
            END) AS reqs,
        sum(
            CASE WHEN ss_to_status = 'RES_UNFILLED' THEN
                1
            ELSE
                0
            END) AS unfilled,
        sum(
            CASE WHEN ((ss_to_status = 'RES_AWAIT_SHIP')
                OR (ss_to_status = 'RES_ITEM_SHIPPED'
                    AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
                1
            ELSE
                0
            END) AS filled,
        sum(
            CASE WHEN ((ss_to_status = 'RES_ITEM_SHIPPED'
                AND ss_from_status = 'RES_AWAIT_SHIP')
                OR (ss_to_status = 'RES_ITEM_SHIPPED'
                    AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
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
        round(coalesce((cast(sum(
                        CASE WHEN ((ss_to_status = 'RES_AWAIT_SHIP')
                            OR (ss_to_status = 'RES_ITEM_SHIPPED'
                                AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
                            1
                        ELSE
                            0
                        END) AS decimal) / nullif (sum(
                        CASE WHEN ss_from_status IS NULL
                            AND ss_to_status = 'RES_IDLE' THEN
                            1
                        ELSE
                            0
                        END), 0)), 0), 2) AS filled_ratio,
        round(coalesce((cast(sum(
                        CASE WHEN ((ss_to_status = 'RES_ITEM_SHIPPED'
                            AND ss_from_status = 'RES_AWAIT_SHIP')
                            OR (ss_to_status = 'RES_ITEM_SHIPPED'
                                AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
                            1
                        ELSE
                            0
                        END) AS decimal) / nullif (sum(
                        CASE WHEN ss_from_status IS NULL
                            AND ss_to_status = 'RES_IDLE' THEN
                            1
                        ELSE
                            0
                        END), 0)), 0), 2) AS supplied_ratio
    FROM
        report.sup_stats()
    WHERE
        ss_date_created >= start_date
            AND ss_date_created < end_date
            GROUP BY
                supplier
            UNION
            SELECT
                'Consortium' AS supplier,
                sum(
                    CASE WHEN ss_from_status IS NULL
                        AND ss_to_status = 'RES_IDLE' THEN
                        1
                    ELSE
                        0
                    END) AS reqs,
                sum(
                    CASE WHEN ss_to_status = 'RES_UNFILLED' THEN
                        1
                    ELSE
                        0
                    END) AS unfilled,
                sum(
                    CASE WHEN ((ss_to_status = 'RES_AWAIT_SHIP')
                        OR (ss_to_status = 'RES_ITEM_SHIPPED'
                            AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
                        1
                    ELSE
                        0
                    END) AS filled,
                sum(
                    CASE WHEN ((ss_to_status = 'RES_ITEM_SHIPPED'
                        AND ss_from_status = 'RES_AWAIT_SHIP')
                        OR (ss_to_status = 'RES_ITEM_SHIPPED'
                            AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
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
                round(coalesce((cast(sum(
                                CASE WHEN ((ss_to_status = 'RES_AWAIT_SHIP')
                                    OR (ss_to_status = 'RES_ITEM_SHIPPED'
                                        AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
                                    1
                                ELSE
                                    0
                                END) AS decimal) / nullif (sum(
                                CASE WHEN ss_from_status IS NULL
                                    AND ss_to_status = 'RES_IDLE' THEN
                                    1
                                ELSE
                                    0
                                END), 0)), 0), 2) AS filled_ratio,
                round(coalesce((cast(sum(
                                CASE WHEN ((ss_to_status = 'RES_ITEM_SHIPPED'
                                    AND ss_from_status = 'RES_AWAIT_SHIP')
                                    OR (ss_to_status = 'RES_ITEM_SHIPPED'
                                        AND ss_from_status = 'RES_AWAIT_PICKING')) THEN
                                    1
                                ELSE
                                    0
                                END) AS decimal) / nullif (sum(
                                CASE WHEN ss_from_status IS NULL
                                    AND ss_to_status = 'RES_IDLE' THEN
                                    1
                                ELSE
                                    0
                                END), 0)), 0), 2) AS supplied_ratio
            FROM
                report.sup_stats()
            WHERE
                ss_date_created >= start_date
                    AND ss_date_created < end_date
                    GROUP BY
                        supplier
                    UNION
                    SELECT
                        de_name,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0
                    FROM
                        reshare_rs.directory_entry de
                    WHERE
                        de.de_parent IS NULL
                        AND de.de_status_fk IS NOT NULL
                        AND de.de_name NOT IN (
                            SELECT
                                ss.ss_supplier_nice_name
                            FROM
                                report.sup_stats() ss
                            WHERE
                                ss_date_created >= start_date
                                    AND ss_date_created < end_date)) AS core_sup
ORDER BY
    (
        CASE WHEN core_sup.supplier = 'Consortium' THEN
            0
        ELSE
            1
        END),
core_sup.supplier
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
