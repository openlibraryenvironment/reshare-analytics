--metadb:table rtat_rec

DROP TABLE IF EXISTS rtat_rec;

CREATE TABLE rtat_rec AS SELECT DISTINCT
    pra.__origin AS rtre_requester,
    pra.__start AS rtre_start,
    pra.pra_date_created AS rtre_date_created,
    pra.pra_patron_request_fk AS rtre_req_id,
    s.st_code AS rtre_status
FROM
    reshare_rs.patron_request_audit pra
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
        AND pra.__origin = s.__origin
WHERE
    s.st_code = 'REQ_CHECKED_IN';

CREATE INDEX ON rtat_rec (rtre_requester);

CREATE INDEX ON rtat_rec (rtre_start);

CREATE INDEX ON rtat_rec (rtre_date_created);

CREATE INDEX ON rtat_rec (rtre_req_id);

CREATE INDEX ON rtat_rec (rtre_status);

VACUUM ANALYZE rtat_rec;

