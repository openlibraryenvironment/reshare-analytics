--metadb:report coldev_reqs

DROP FUNCTION IF EXISTS coldev_reqs;

CREATE FUNCTION coldev_reqs(
    institution text)
RETURNS TABLE(
    lpr_hrid text,
    lpr_title text,
    lpr_author text,
    lpr_isbn text,
    lpr_patron_identifier text,
    lpr_patron_email text,
    lpr_date_created timestamp,
    lpr_pub_date text,
    lpr_filled int8,
    lpr_bib_record_id text)
AS $$
SELECT DISTINCT ( lpr_hrid,
                  lpr_title,
                  lpr_author,
                  lpr_isbn,
                  lpr_patron_identifier,
                  lpr_patron_email,
                  lpr_date_created,
                  lpr_pub_date,
                  lpr_filled,
                  lpr_bib_record_id
                )
    FROM ( SELECT pr.pr_hrid AS lpr_hrid,
                  pr.pr_title AS lpr_title,
                  pr.pr_author AS lpr_author,
                  pr.pr_isbn AS lpr_isbn,
                  pr.pr_patron_identifier AS lpr_patron_identifier,
                  pr.pr_patron_email AS lpr_patron_email,
                  pr.pr_date_created AS lpr_date_created,
                  pr.pr_pub_date AS lpr_pub_date,
                  lrr.lrr_filled AS lpr_filled,
                  pr.pr_bib_record_id AS lpr_bib_record_id
           FROM reshare_rs.patron_request AS pr
               LEFT JOIN ( SELECT lrr_req_id::uuid, lrr_filled
                               FROM coldev_rr(institution)
                         ) AS lrr ON pr.pr_id = lrr.lrr_req_id
           WHERE pr.pr_is_requester AND pr.__origin = institution
         ) AS coldevdata
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;

COMMENT ON FUNCTION coldev_reqs IS 'Details of all requests placed by an institution''s users';
