DROP TABLE IF EXISTS reshare_derived.rtat_rec;

CREATE TABLE reshare_derived.rtat_rec AS
SELECT
    pra."__origin" AS rtre_requester,
    pra.pra_date_created AS rtre_date_created,
    pra.pra_patron_request_fk AS rtre_req_id,
    s.st_code AS rtre_status
FROM
    reshare_rs.patron_request_audit__ pra
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    s.st_code = 'REQ_CHECKED_IN'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.rtat_rec (rtre_requester);

CREATE INDEX ON reshare_derived.rtat_rec (rtre_date_created);

CREATE INDEX ON reshare_derived.rtat_rec (rtre_req_id);

CREATE INDEX ON reshare_derived.rtat_rec (rtre_status);

