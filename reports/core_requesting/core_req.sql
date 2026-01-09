
--metadb:function core_req

DROP FUNCTION IF EXISTS core_req;

CREATE FUNCTION core_req(
    start_date date DEFAULT '2020-01-01',
    end_date date DEFAULT '2030-01-01')
RETURNS TABLE(
    requester text,
    reqs bigint,
    cancelled bigint,
    unfilled bigint,
    filled_locally bigint,
    received bigint,
    filled_ratio numeric)
AS $$
SELECT
    requester,
    reqs,
    cancelled,
    unfilled,
    filled_locally,
    received,
    filled_ratio
    
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
        report.req_stats()
    WHERE
        rs_date_created >= start_date
            AND rs_date_created < end_date
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
                report.req_stats()
            WHERE
                rs_date_created >= start_date
                AND rs_date_created < end_date
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
                                report.req_stats() rs
                            WHERE
                                rs_date_created >= start_date
				AND rs_date_created < end_date)) AS core_req
--should there be 3 )))  ?
ORDER BY
    (
        CASE WHEN core_req.requester = 'Consortium' THEN
            0
        ELSE
            1
        END),
core_req.requester
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
