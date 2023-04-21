-- NOTE: This is intended to be run on a per-institution basis, as not all institutions need or want it. The SCHEMA value needs to be defined in whatever script is being used to generate these data.  The institution's origin value is to be used as the input value when calling the functions.
DROP TABLE IF EXISTS req_result;

CREATE FUNCTION coldev_rr (institution text)
    RETURNS TABLE (
        lrr_req_id varchar,
        lrr_filled int8
    )
    AS $$
    SELECT
        rs.rs_req_id AS lrr_req_id,
        sum(
            CASE WHEN (rs_from_status = 'REQ_SHIPPED'
                AND rs_to_status = 'REQ_CHECKED_IN')
                OR rs_to_status = 'REQ_FILLED_LOCALLY' THEN
                1
            ELSE
                0
            END) AS lrr_filled
    FROM
        reshare_derived.req_stats rs
    WHERE
        rs.rs_requester = institution
    GROUP BY
        rs.rs_req_id
$$
LANGUAGE SQL;

CREATE TABLE req_result AS
SELECT
    *
FROM
    coldev_rr ();

CREATE INDEX ON req_result (lrr_req_id);

CREATE INDEX ON req_result (lrr_filled);

DROP TABLE IF EXISTS pat_reqs;

CREATE FUNCTION coldev_reqs (institution text)
    RETURNS TABLE (
        lpr_hrid varchar,
        lpr_title varchar,
        lpr_author varchar,
        lpr_isbn varchar,
        lpr_patron_identifier varchar,
        lpr_patron_email varchar,
        lpr_date_created timestamp,
        lpr_pub_date varchar,
        lpr_filled int8,
        lpr_bib_record_id varchar
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
        LEFT JOIN req_result lrr ON pr.pr_id = lrr.lrr_req_id::uuid
    WHERE
        pr.pr_is_requester = TRUE
        AND pr."__origin" = institution) AS coldevdata
$$
LANGUAGE SQL;

CREATE TABLE pat_reqs AS
SELECT
    *
FROM
    coldev_reqs ();

CREATE INDEX ON pat_reqs (lpr_hrid);

CREATE INDEX ON pat_reqs (lpr_title);

CREATE INDEX ON pat_reqs (lpr_author);

CREATE INDEX ON pat_reqs (lpr_isbn);

CREATE INDEX ON pat_reqs (lpr_patron_identifier);

CREATE INDEX ON pat_reqs (lpr_patron_email);

CREATE INDEX ON pat_reqs (lpr_date_created);

CREATE INDEX ON pat_reqs (lpr_pub_date);

CREATE INDEX ON pat_reqs (lpr_filled);

CREATE INDEX ON pat_reqs (lpr_bib_record_id);

