--metadb:table sup_stats

DROP TABLE IF EXISTS sup_stats;

-- Create a derived table containing information about supplier statistics
CREATE TABLE sup_stats AS
SELECT
    pra.__origin AS ss_supplier,
    pra.__start AS ss_start,
    names.de_name AS ss_supplier_nice_name,
    pra.pra_id AS ss_id,
    pra.pra_patron_request_fk AS ss_req_id,
    pra.pra_date_created AS ss_date_created,
    s2.st_code AS ss_from_status,
    s.st_code AS ss_to_status,
    pra.pra_message AS ss_message
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
    s.st_code LIKE 'RES_%'
    AND (s2.st_code LIKE 'RES_%'
        OR s2.st_code IS NULL);
