DROP TABLE IF EXISTS req_stats;

-- Create a derived table containing information about requester statistics
CREATE TABLE req_stats AS
SELECT
    pra."__origin" AS rs_requester,
    pra.pra_id AS rs_id,
    pra.pra_patron_request_fk AS rs_req_id,
    pra.pra_date_created AS rs_date_created,
    s2.st_code AS rs_from_status,
    s.st_code AS rs_to_status,
    pra.pra_message AS rs_message
FROM
    reshare_rs.patron_request_audit pra
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
    LEFT JOIN reshare_rs.status s2 ON pra.pra_from_status_fk = s2.st_id
WHERE
    s.st_code LIKE 'REQ_%'
    OR s2.st_code LIKE 'REQ_%'
ORDER BY
    pra.pra_patron_request_fk,
    pra.pra_date_created ASC;

CREATE INDEX ON req_stats (rs_requester);

CREATE INDEX ON req_stats (rs_id);

CREATE INDEX ON req_stats (rs_req_id);

CREATE INDEX ON req_stats (rs_date_created);

CREATE INDEX ON req_stats (rs_from_status);

CREATE INDEX ON req_stats (rs_to_status);

VACUUM ANALYZE req_stats;
