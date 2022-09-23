DROP TABLE IF EXISTS consortial_view;

CREATE TABLE consortial_view AS SELECT DISTINCT
    prr.__origin AS cv_requester,
    prr.__start AS cv_start,
    names.de_name AS cv_requester_nice_name,
    prr.prr_date_created AS cv_date_created,
    prr.prr_last_updated AS cv_last_updated,
    de.de_name AS cv_supplier_nice_name,
    prr.prr_patron_request_fk AS cv_patron_request_fk,
    prr.prr_state_fk AS cv_state_fk,
    s.st_code AS cv_code
FROM
    reshare_rs.patron_request_rota prr
    JOIN reshare_rs.status s ON s.st_id = prr.prr_state_fk
        AND prr.__origin = s.__origin
    JOIN reshare_rs.symbol s2 ON prr.prr_peer_symbol_fk::uuid = s2.sym_id
        AND prr.__origin = s2.__origin
    JOIN reshare_rs.directory_entry de ON s2.sym_owner_fk = de.de_id
        AND s2.__origin = de.__origin
    JOIN (
        SELECT
            de2.__origin,
            de2.de_name
        FROM
            reshare_rs.directory_entry de2
        WHERE
            de2.de_parent IS NULL
            AND de2.de_status_fk IS NOT NULL) AS names ON prr.__origin = names.__origin
WHERE
    s.st_code = 'REQ_REQUEST_COMPLETE'
    OR s.st_code = 'REQ_SHIPPED';

CREATE INDEX ON consortial_view (cv_requester);

CREATE INDEX ON consortial_view (cv_start);

CREATE INDEX ON consortial_view (cv_requester_nice_name);

CREATE INDEX ON consortial_view (cv_date_created);

CREATE INDEX ON consortial_view (cv_last_updated);

CREATE INDEX ON consortial_view (cv_supplier_nice_name);

CREATE INDEX ON consortial_view (cv_patron_request_fk);

CREATE INDEX ON consortial_view (cv_state_fk);

CREATE INDEX ON consortial_view (cv_code);

VACUUM ANALYZE consortial_view;

