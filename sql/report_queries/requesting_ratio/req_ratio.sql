SELECT
    reqct.de_name AS institution,
    resct.sup_count AS lending_requests,
    reqct.req_count AS borrowing_requests,
    round(coalesce((cast(resct.sup_count AS decimal) / nullif (cast(reqct.req_count AS decimal), 0)), 0), 2) AS lending_to_borrowing_request_ratio
FROM (
    SELECT
        rs.rs_requester,
        names.de_name,
        count(*) AS req_count
    FROM
        reshare_derived.req_stats rs
        JOIN (
            SELECT
                *
            FROM
                reshare_rs.directory_entry de
            WHERE
                de.de_parent IS NULL
                AND de.de_status_fk IS NOT NULL) AS names ON rs.rs_requester = names.__origin
        WHERE
            rs.rs_to_status = 'REQ_VALIDATED'
        GROUP BY
            rs.rs_requester,
            names.de_name) AS reqct
    JOIN (
        SELECT
            ss.ss_supplier,
            count(DISTINCT ss_req_id) AS sup_count
        FROM
            reshare_derived.sup_stats ss
        GROUP BY
            ss.ss_supplier) AS resct ON reqct.rs_requester = resct.ss_supplier;

