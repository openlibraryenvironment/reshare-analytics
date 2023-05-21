--metadb:table req_stats

DROP TABLE IF EXISTS req_stats;

-- Create a derived table containing information about requester statistics
CREATE TABLE req_stats AS
SELECT
    pra.__origin AS rs_requester,
    pra.__start AS rs_start,
    names.de_name AS rs_requester_nice_name,
    pra.pra_id AS rs_id,
    pra.pra_patron_request_fk AS rs_req_id,
    pra.pra_date_created AS rs_date_created,
    s2.st_code AS rs_from_status,
    s.st_code AS rs_to_status,
    pra.pra_message AS rs_message
FROM
    reshare_rs.patron_request_audit pra
    LEFT JOIN reshare_rs.status s ON pra.pra_to_status_fk = s.st_id
        AND pra.__origin = s.__origin
    LEFT JOIN reshare_rs.status s2 ON pra.pra_from_status_fk::uuid = s2.st_id
        AND pra.__origin = s2.__origin
    JOIN (
        SELECT
            de.__origin,
            de.de_name
        FROM
            reshare_rs.directory_entry de
        WHERE
            de.de_parent IS NULL
            AND de.de_status_fk IS NOT NULL) AS names ON pra.__origin = names.__origin
WHERE
    s.st_code LIKE 'REQ_%'
    OR s2.st_code LIKE 'REQ_%';

CREATE INDEX ON req_stats (rs_requester);

CREATE INDEX ON req_stats (rs_start);

CREATE INDEX ON req_stats (rs_requester_nice_name);

CREATE INDEX ON req_stats (rs_id);

CREATE INDEX ON req_stats (rs_req_id);

CREATE INDEX ON req_stats (rs_date_created);

CREATE INDEX ON req_stats (rs_from_status);

CREATE INDEX ON req_stats (rs_to_status);
