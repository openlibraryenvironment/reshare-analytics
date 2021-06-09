DROP TABLE IF EXISTS reshare_derived.north_stat_reqs;

CREATE TABLE reshare_derived.north_stat_reqs AS SELECT DISTINCT
    pr.pr_hrid AS str_hrid,
    pr.pr_title AS str_title,
    pr.pr_local_call_number AS str_call_number,
    pr.pr_selected_item_barcode AS str_barcode,
    pr.pr_resolved_req_inst_symbol_fk AS str_requester,
    pr.pr_date_created AS str_date_created,
    pr.pr_id AS str_id
FROM
    reshare_reshare_north_rs.patron_request pr
    LEFT JOIN reshare_reshare_north_rs.patron_request_audit__ pra ON pr.pr_id = pra.pra_patron_request_fk
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    pr.pr_hrid NOT LIKE 'NORTH%'
ORDER BY
    pr.pr_date_created ASC;

CREATE INDEX ON reshare_derived.north_stat_reqs (str_hrid);

CREATE INDEX ON reshare_derived.north_stat_reqs (str_title);

CREATE INDEX ON reshare_derived.north_stat_reqs (str_call_number);

CREATE INDEX ON reshare_derived.north_stat_reqs (str_barcode);

CREATE INDEX ON reshare_derived.north_stat_reqs (str_requester);

CREATE INDEX ON reshare_derived.north_stat_reqs (str_date_created);

CREATE INDEX ON reshare_derived.north_stat_reqs (str_id);

DROP TABLE IF EXISTS reshare_derived.north_stat_assi;

CREATE TABLE reshare_derived.north_stat_assi AS
SELECT
    pra.pra_date_created AS sta_date_created,
    pra.pra_patron_request_fk AS sta_req_id,
    s.st_code AS sta_status
FROM
    reshare_reshare_north_rs.patron_request_audit__ pra
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    s.st_code = 'RES_IDLE'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.north_stat_assi (sta_date_created);

CREATE INDEX ON reshare_derived.north_stat_assi (sta_req_id);

CREATE INDEX ON reshare_derived.north_stat_assi (sta_status);

DROP TABLE IF EXISTS reshare_derived.north_stat_fill;

CREATE TABLE reshare_derived.north_stat_fill AS
SELECT
    pra.pra_date_created AS stf_date_created,
    pra.pra_patron_request_fk AS stf_req_id,
    s.st_code AS stf_status
FROM
    reshare_reshare_north_rs.patron_request_audit__ pra
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_to_status_fk = s.st_id
WHERE
    s.st_code = 'RES_AWAIT_SHIP'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.north_stat_fill (stf_date_created);

CREATE INDEX ON reshare_derived.north_stat_fill (stf_req_id);

CREATE INDEX ON reshare_derived.north_stat_fill (stf_status);

DROP TABLE IF EXISTS reshare_derived.north_stat_ship;

CREATE TABLE reshare_derived.north_stat_ship AS
SELECT
    pra.pra_date_created AS sts_date_created,
    pra.pra_patron_request_fk AS sts_req_id,
    s.st_code AS sts_from_status,
    s2.st_code AS sts_to_status
FROM
    reshare_reshare_north_rs.patron_request_audit__ pra
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_from_status_fk = s.st_id
    LEFT JOIN reshare_reshare_north_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
WHERE
    s.st_code = 'RES_AWAIT_SHIP'
    AND s2.st_code = 'RES_ITEM_SHIPPED'
ORDER BY
    pra.pra_date_created ASC;

CREATE INDEX ON reshare_derived.north_stat_ship (sts_date_created);

CREATE INDEX ON reshare_derived.north_stat_ship (sts_req_id);

CREATE INDEX ON reshare_derived.north_stat_ship (sts_from_status);

CREATE INDEX ON reshare_derived.north_stat_ship (sts_to_status);

-- Not sure if listagg in redshift can mimic the array_agg functionality, won't know until we can test. Necessary because an item can be received multiple times, see SOUTH-6.
DROP TABLE IF EXISTS reshare_derived.north_stat_rec;

CREATE TABLE reshare_derived.north_stat_rec AS
SELECT
    (array_agg(pra.pra_date_created ORDER BY pra.pra_date_created ASC))[1] AS stre_date_created,
    pra.pra_patron_request_fk AS stre_req_id,
    s.st_code AS stre_from_status,
    s2.st_code AS stre_to_status
FROM
    reshare_reshare_north_rs.patron_request_audit__ pra
    LEFT JOIN reshare_reshare_north_rs.status s ON pra.pra_from_status_fk = s.st_id
    LEFT JOIN reshare_reshare_north_rs.status s2 ON pra.pra_to_status_fk = s2.st_id
WHERE
    s.st_code = 'RES_ITEM_SHIPPED'
    AND s2.st_code = 'RES_ITEM_SHIPPED'
GROUP BY
    pra.pra_patron_request_fk,
    s.st_code,
    s2.st_code;

CREATE INDEX ON reshare_derived.north_stat_rec (stre_date_created);

CREATE INDEX ON reshare_derived.north_stat_rec (stre_req_id);

CREATE INDEX ON reshare_derived.north_stat_rec (stre_from_status);

CREATE INDEX ON reshare_derived.north_stat_rec (stre_to_status);

DROP TABLE IF EXISTS reshare_derived.north_sup_tat_stats;

CREATE TABLE reshare_derived.north_sup_tat_stats AS SELECT DISTINCT
    (array_agg(ss_date_created ORDER BY ss_date_created ASC))[1] AS stst_date_created,
    ss_req_id AS stst_req_id,
    ss_from_status AS stst_from_status,
    ss_to_status AS stst_to_status,
    ss_message AS stst_message
FROM
    reshare_derived.north_sup_stats
GROUP BY
    stst_req_id,
    stst_from_status,
    stst_to_status,
    stst_message;

CREATE INDEX ON reshare_derived.north_sup_tat_stats (stst_date_created);

CREATE INDEX ON reshare_derived.north_sup_tat_stats (stst_req_id);

CREATE INDEX ON reshare_derived.north_sup_tat_stats (stst_from_status);

CREATE INDEX ON reshare_derived.north_sup_tat_stats (stst_to_status);

CREATE INDEX ON reshare_derived.north_sup_tat_stats (stst_message);