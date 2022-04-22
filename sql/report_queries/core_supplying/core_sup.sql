WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    *
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
        round(coalesce((cast(sum(
                        CASE WHEN ss_to_status = 'RES_AWAIT_SHIP' THEN
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
                        CASE WHEN ss_to_status = 'RES_ITEM_SHIPPED'
                            AND ss_from_status = 'RES_AWAIT_SHIP' THEN
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
        reshare_derived.sup_stats
    WHERE
        ss_date_created >= (
            SELECT
                start_date
            FROM
                parameters)
            AND ss_date_created < (
                SELECT
                    end_date
                FROM
                    parameters)
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
                round(coalesce((cast(sum(
                                CASE WHEN ss_to_status = 'RES_AWAIT_SHIP' THEN
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
                                CASE WHEN ss_to_status = 'RES_ITEM_SHIPPED'
                                    AND ss_from_status = 'RES_AWAIT_SHIP' THEN
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
                reshare_derived.sup_stats
            WHERE
                ss_date_created >= (
                    SELECT
                        start_date
                    FROM
                        parameters)
                    AND ss_date_created < (
                        SELECT
                            end_date
                        FROM
                            parameters)
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
                                reshare_derived.sup_stats ss
                            WHERE
                                ss_date_created >= (
                                    SELECT
                                        start_date
                                    FROM
                                        parameters)
                                    AND ss_date_created < (
                                        SELECT
                                            end_date
                                        FROM
                                            parameters))) AS core_sup
ORDER BY
    (
        CASE WHEN core_sup.supplier = 'Consortium' THEN
            0
        ELSE
            1
        END),
core_sup.supplier;

