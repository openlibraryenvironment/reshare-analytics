DROP TABLE IF EXISTS reshare_derived.north_rtat_reqs;

CREATE TABLE reshare_derived.north_rtat_reqs AS SELECT DISTINCT
    pr.pr_hrid AS rtr_hrid,
    pr.pr_title AS rtr_title,
    pr.pr_local_call_number AS rtr_call_number,
    pr.pr_selected_item_barcode AS rtr_barcode,
    pr.pr_resolved_sup_inst_symbol_fk AS rtr_supplier,
    pr.pr_date_created AS rtr_date_created,
    pr.pr_id AS rtr_id
FROM
    reshare_reshare_north_rs.patron_request pr
    LEFT JOIN reshare_reshare_north_rs.patron_request_audit__ pra ON pr.pr_id = pra.pra_patron_request_fk
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    pr.pr_hrid LIKE 'NORTH%'
ORDER BY
    pr.pr_date_created ASC;

CREATE INDEX ON reshare_derived.north_rtat_reqs (rtr_hrid);

CREATE INDEX ON reshare_derived.north_rtat_reqs (rtr_title);

CREATE INDEX ON reshare_derived.north_rtat_reqs (rtr_call_number);

CREATE INDEX ON reshare_derived.north_rtat_reqs (rtr_barcode);

CREATE INDEX ON reshare_derived.north_rtat_reqs (rtr_supplier);

CREATE INDEX ON reshare_derived.north_rtat_reqs (rtr_date_created);

CREATE INDEX ON reshare_derived.north_rtat_reqs (rtr_id);

DROP TABLE IF EXISTS reshare_derived.north_rtat_ship;

CREATE TABLE reshare_derived.north_rtat_ship AS
SELECT
    pra.pra_date_created AS rts_date_created,
    pra.pra_patron_request_fk AS rts_req_id,
    s.st_code AS rts_status
FROM
    reshare_reshare_north_rs.patron_request_audit__ pra
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    s.st_code = 'REQ_SHIPPED'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.north_rtat_ship (rts_date_created);

CREATE INDEX ON reshare_derived.north_rtat_ship (rts_req_id);

CREATE INDEX ON reshare_derived.north_rtat_ship (rts_status);

DROP TABLE IF EXISTS reshare_derived.north_rtat_rec;

CREATE TABLE reshare_derived.north_rtat_rec AS
SELECT
    pra.pra_date_created AS rtre_date_created,
    pra.pra_patron_request_fk AS rtre_req_id,
    s.st_code AS rtre_status
FROM
    reshare_reshare_north_rs.patron_request_audit__ pra
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    s.st_code = 'REQ_CHECKED_IN'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.north_rtat_rec (rtre_date_created);

CREATE INDEX ON reshare_derived.north_rtat_rec (rtre_req_id);

CREATE INDEX ON reshare_derived.north_rtat_rec (rtre_status);