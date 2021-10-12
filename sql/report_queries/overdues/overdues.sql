SELECT
    ro.ro_hrid AS request_hrid,
    ro.ro_title AS title,
    ro.ro_requester_nice_name AS requester,
    ro.ro_requester_url AS requester_url,
    so.so_supplier_nice_name AS supplier,
    so.so_supplier_url AS supplier_url,
    ro.ro_req_state AS request_state,
    so.so_res_state AS supply_state,
    ro.ro_due_date_rs AS due_date,
    ro.ro_return_shipped_date AS return_shipped_date,
    so.so_local_call_number AS call_number,
    so.so_item_barcode AS item_barcode
FROM
    reshare_derived.req_overdue ro
    JOIN reshare_derived.sup_overdue so ON ro.ro_hrid = so.so_hrid;

