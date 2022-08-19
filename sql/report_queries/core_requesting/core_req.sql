-- Switch from FILTER to CASE for RedShift compatibility.
WITH parameters AS (
    SELECT
        '2020-01-01'::date AS start_date,
        '2030-01-01'::date AS end_date
)
SELECT
    *
FROM (
    SELECT
        rs_requester_nice_name AS requester,
        sum(
            CASE WHEN (rs_from_status = 'REQ_IDLE'
                OR rs_from_status = 'REQ_INVALID_PATRON')
                AND rs_to_status = 'REQ_VALIDATED' THEN
                1
            ELSE
                0
            END) AS reqs,
        sum(
            CASE WHEN rs_to_status = 'REQ_CANCELLED' THEN
                1
            ELSE
                0
            END) AS cancelled,
        sum(
            CASE WHEN rs_to_status = 'REQ_END_OF_ROTA' THEN
                1
            ELSE
                0
            END) AS unfilled,
        sum(
            CASE WHEN rs_to_status = 'REQ_FILLED_LOCALLY' THEN
                1
            ELSE
                0
            END) AS filled_locally,
        sum(
            CASE WHEN (rs_from_status = 'REQ_SHIPPED'
                AND rs_to_status = 'REQ_CHECKED_IN') THEN
                1
            ELSE
                0
            END) AS received,
        round(coalesce((sum(
                    CASE WHEN (rs_from_status = 'REQ_SHIPPED'
                        AND rs_to_status = 'REQ_CHECKED_IN') THEN
                        1
                    WHEN rs_to_status = 'REQ_FILLED_LOCALLY' THEN
                        1
                    ELSE
                        0
                    END) / nullif (cast(sum(
                            CASE WHEN (rs_from_status = 'REQ_IDLE'
                                OR rs_from_status = 'REQ_INVALID_PATRON')
                                AND rs_to_status = 'REQ_VALIDATED' THEN
                                1
                            ELSE
                                0
                            END) AS decimal), 0)), 0), 2) AS filled_ratio
    FROM
        reshare_derived.req_stats
    WHERE
        rs_date_created >= (
            SELECT
                start_date
            FROM
                parameters)
            AND rs_date_created < (
                SELECT
                    end_date
                FROM
                    parameters)
            GROUP BY
                requester
            UNION
            SELECT
                'Consortium' AS requester,
                sum(
                    CASE WHEN (rs_from_status = 'REQ_IDLE'
                        OR rs_from_status = 'REQ_INVALID_PATRON')
                        AND rs_to_status = 'REQ_VALIDATED' THEN
                        1
                    ELSE
                        0
                    END) AS reqs,
                sum(
                    CASE WHEN rs_to_status = 'REQ_CANCELLED' THEN
                        1
                    ELSE
                        0
                    END) AS cancelled,
                sum(
                    CASE WHEN rs_to_status = 'REQ_END_OF_ROTA' THEN
                        1
                    ELSE
                        0
                    END) AS unfilled,
                sum(
                    CASE WHEN rs_to_status = 'REQ_FILLED_LOCALLY' THEN
                        1
                    ELSE
                        0
                    END) AS filled_locally,
                sum(
                    CASE WHEN (rs_from_status = 'REQ_SHIPPED'
                        AND rs_to_status = 'REQ_CHECKED_IN') THEN
                        1
                    ELSE
                        0
                    END) AS received,
                round(coalesce((sum(
                            CASE WHEN (rs_from_status = 'REQ_SHIPPED'
                                AND rs_to_status = 'REQ_CHECKED_IN') THEN
                                1
                            WHEN rs_to_status = 'REQ_FILLED_LOCALLY' THEN
                                1
                            ELSE
                                0
                            END) / nullif (cast(sum(
                                    CASE WHEN (rs_from_status = 'REQ_IDLE'
                                        OR rs_from_status = 'REQ_INVALID_PATRON')
                                        AND rs_to_status = 'REQ_VALIDATED' THEN
                                        1
                                    ELSE
                                        0
                                    END) AS decimal), 0)), 0), 2) AS filled_ratio
            FROM
                reshare_derived.req_stats
            WHERE
                rs_date_created >= (
                    SELECT
                        start_date
                    FROM
                        parameters)
                    AND rs_date_created < (
                        SELECT
                            end_date
                        FROM
                            parameters)
                    GROUP BY
                        requester
                    UNION
                    SELECT
                        de_name,
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
                                rs.rs_requester_nice_name
                            FROM
                                reshare_derived.req_stats rs
                            WHERE
                                rs_date_created >= (
                                    SELECT
                                        start_date
                                    FROM
                                        parameters)
                                    AND rs_date_created < (
                                        SELECT
                                            end_date
                                        FROM
                                            parameters))) AS core_req
ORDER BY
    (
        CASE WHEN core_req.requester = 'Consortium' THEN
            0
        ELSE
            1
        END),
core_req.requester;

