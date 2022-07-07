DROP TABLE IF EXISTS symbol_directory_entry;

CREATE TABLE symbol_directory_entry AS
SELECT
    s.sym_id,
    s.version AS sym_version,
    s.sym_priority,
    s.sym_authority_fk,
    s.sym_owner_fk,
    s.sym_symbol,
    d.de_id,
    d.version AS de_version,
    d.custom_properties_id AS de_custom_properties_id,
    d.de_slug,
    d.de_foaf_timestamp,
    d.de_foaf_url,
    d.de_name,
    d.de_status_fk,
    d.de_desc,
    d.de_parent,
    d.de_lms_location_code,
    d.de_entry_url,
    d.de_phone_number,
    d.de_email_address,
    d.de_contact_name,
    d.de_type_rv_fk,
    d.de_published_last_update,
    d.de_branding_url
FROM
    reshare_rs.symbol AS s
    LEFT JOIN reshare_rs.directory_entry AS d ON s.sym_owner_fk = d.de_id;

CREATE INDEX ON symbol_directory_entry (sym_id);

CREATE INDEX ON symbol_directory_entry (sym_version);

CREATE INDEX ON symbol_directory_entry (sym_priority);

CREATE INDEX ON symbol_directory_entry (sym_authority_fk);

CREATE INDEX ON symbol_directory_entry (sym_owner_fk);

CREATE INDEX ON symbol_directory_entry (sym_symbol);

CREATE INDEX ON symbol_directory_entry (de_id);

CREATE INDEX ON symbol_directory_entry (de_version);

CREATE INDEX ON symbol_directory_entry (de_custom_properties_id);

CREATE INDEX ON symbol_directory_entry (de_slug);

CREATE INDEX ON symbol_directory_entry (de_foaf_timestamp);

CREATE INDEX ON symbol_directory_entry (de_foaf_url);

CREATE INDEX ON symbol_directory_entry (de_name);

CREATE INDEX ON symbol_directory_entry (de_status_fk);

CREATE INDEX ON symbol_directory_entry (de_desc);

CREATE INDEX ON symbol_directory_entry (de_parent);

CREATE INDEX ON symbol_directory_entry (de_lms_location_code);

CREATE INDEX ON symbol_directory_entry (de_entry_url);

CREATE INDEX ON symbol_directory_entry (de_phone_number);

CREATE INDEX ON symbol_directory_entry (de_email_address);

CREATE INDEX ON symbol_directory_entry (de_contact_name);

CREATE INDEX ON symbol_directory_entry (de_type_rv_fk);

CREATE INDEX ON symbol_directory_entry (de_published_last_update);

CREATE INDEX ON symbol_directory_entry (de_branding_url);

VACUUM ANALYZE symbol_directory_entry;
