DROP TABLE IF EXISTS reshare_derived.consortial_view;

CREATE TABLE reshare_derived.consortial_view AS
SELECT
    'NORTH' AS cv_requester,
    prr.prr_date_created AS cv_date_created,
    prr.prr_last_updated AS cv_last_updated,
    prr.prr_directory_id_fk AS cv_directory_id_fk,
    prr.prr_patron_request_fk AS cv_patron_request_fk,
    prr.prr_state_fk AS cv_state_fk,
    s.st_code AS cv_code
FROM
    reshare_reshare_north_rs.patron_request_rota prr
    JOIN reshare_reshare_north_rs.status s ON s.st_id = prr.prr_state_fk
WHERE
    s.st_code = 'REQ_REQUEST_COMPLETE'
    OR s.st_code = 'REQ_SHIPPED';

INSERT INTO reshare_derived.consortial_view
SELECT
    'EAST' AS cv_requester,
    prr.prr_date_created AS cv_date_created,
    prr.prr_last_updated AS cv_last_updated,
    prr.prr_directory_id_fk AS cv_directory_id_fk,
    prr.prr_patron_request_fk AS cv_patron_request_fk,
    prr.prr_state_fk AS cv_state_fk,
    s.st_code AS cv_code
FROM
    reshare_reshare_east_rs.patron_request_rota prr
    JOIN reshare_reshare_east_rs.status s ON s.st_id = prr.prr_state_fk
WHERE
    s.st_code = 'REQ_REQUEST_COMPLETE'
    OR s.st_code = 'REQ_SHIPPED';

INSERT INTO reshare_derived.consortial_view
SELECT
    'SOUTH' AS cv_requester,
    prr.prr_date_created AS cv_date_created,
    prr.prr_last_updated AS cv_last_updated,
    prr.prr_directory_id_fk AS cv_directory_id_fk,
    prr.prr_patron_request_fk AS cv_patron_request_fk,
    prr.prr_state_fk AS cv_state_fk,
    s.st_code AS cv_code
FROM
    reshare_reshare_south_rs.patron_request_rota prr
    JOIN reshare_reshare_south_rs.status s ON s.st_id = prr.prr_state_fk
WHERE
    s.st_code = 'REQ_REQUEST_COMPLETE'
    OR s.st_code = 'REQ_SHIPPED';

INSERT INTO reshare_derived.consortial_view
SELECT
    'WEST' AS cv_requester,
    prr.prr_date_created AS cv_date_created,
    prr.prr_last_updated AS cv_last_updated,
    prr.prr_directory_id_fk AS cv_directory_id_fk,
    prr.prr_patron_request_fk AS cv_patron_request_fk,
    prr.prr_state_fk AS cv_state_fk,
    s.st_code AS cv_code
FROM
    reshare_reshare_west_rs.patron_request_rota prr
    JOIN reshare_reshare_west_rs.status s ON s.st_id = prr.prr_state_fk
WHERE
    s.st_code = 'REQ_REQUEST_COMPLETE'
    OR s.st_code = 'REQ_SHIPPED';

CREATE INDEX ON reshare_derived.consortial_view (cv_requester);

CREATE INDEX ON reshare_derived.consortial_view (cv_date_created);

CREATE INDEX ON reshare_derived.consortial_view (cv_last_updated);

CREATE INDEX ON reshare_derived.consortial_view (cv_directory_id_fk);

CREATE INDEX ON reshare_derived.consortial_view (cv_patron_request_fk);

CREATE INDEX ON reshare_derived.consortial_view (cv_state_fk);

CREATE INDEX ON reshare_derived.consortial_view (cv_code);