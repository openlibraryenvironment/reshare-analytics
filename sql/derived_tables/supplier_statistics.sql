DROP TABLE IF EXISTS reshare_reporting.north_sup_stats;

-- Create a derived table containing information about supplier statistics

CREATE TABLE reshare_reporting.north_sup_stats AS
SELECT
    pra.pra_id AS ss_id,
    pra.pra_patron_request_fk AS ss_req_id,
    pra.pra_date_created AS ss_date_created,
    s2.st_code AS ss_from_status,
    s.st_code AS ss_to_status,
    pra.pra_message AS ss_message
FROM
    reshare_reshare_north_rs.patron_request_audit pra
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_to_status_fk = s.st_id
    LEFT JOIN reshare_reshare_north_rs.status s2 ON pra.pra_from_status_fk = s2.st_id
WHERE
    s.st_code LIKE 'RES_%' and (s2.st_code LIKE 'RES_%' or s2.st_code is null)
ORDER BY
    pra.pra_patron_request_fk,
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_reporting.north_sup_stats (ss_id);

CREATE INDEX ON reshare_reporting.north_sup_stats (ss_req_id);

CREATE INDEX ON reshare_reporting.north_sup_stats (ss_date_created);

CREATE INDEX ON reshare_reporting.north_sup_stats (ss_from_status);

CREATE INDEX ON reshare_reporting.north_sup_stats (ss_to_status);

CREATE INDEX ON reshare_reporting.north_sup_stats (ss_message);