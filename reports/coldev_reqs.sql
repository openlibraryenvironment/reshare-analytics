--metadb:report coldev_reqs
--metadb:param institution text -- Name of institution as used in __origin columns

CREATE FUNCTION coldev_reqs (institution text)
    RETURNS TABLE (
        lpr_hrid text,
        lpr_title text,
        lpr_author text,
        lpr_isbn text,
        lpr_patron_identifier text,
        lpr_patron_email text,
        lpr_date_created timestamp,
        lpr_pub_date text,
        lpr_filled int8,
        lpr_bib_record_id text
    )
    AS $$
    SELECT DISTINCT
        *
    FROM (
        SELECT
            pr.pr_hrid AS lpr_hrid,
            pr.pr_title AS lpr_title,
            pr.pr_author AS lpr_author,
            pr.pr_isbn AS lpr_isbn,
            pr.pr_patron_identifier AS lpr_patron_identifier,
            pr.pr_patron_email AS lpr_patron_email,
            pr.pr_date_created AS lpr_date_created,
            pr.pr_pub_date AS lpr_pub_date,
            lrr.lrr_filled AS lpr_filled,
            pr.pr_bib_record_id AS lpr_bib_record_id
        FROM
            reshare_rs.patron_request pr
        LEFT JOIN (SELECT * FROM coldev_rr(institution)) AS lrr ON pr.pr_id = lrr.lrr_req_id::uuid
    WHERE
        pr.pr_is_requester = TRUE
        AND pr."__origin" = institution) AS coldevdata
$$
LANGUAGE SQL;
