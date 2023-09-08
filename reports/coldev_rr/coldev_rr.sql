--metadb:function coldev_rr

DROP FUNCTION IF EXISTS coldev_rr;

CREATE FUNCTION coldev_rr(
    institution text)
RETURNS TABLE(
    lrr_req_id text,
    lrr_filled int8)
AS $$
SELECT rs.rs_req_id AS lrr_req_id,
       sum( CASE WHEN (rs_from_status = 'REQ_SHIPPED' AND rs_to_status = 'REQ_CHECKED_IN') OR rs_to_status = 'REQ_FILLED_LOCALLY'
                     THEN 1
                 ELSE 0
            END
          ) AS lrr_filled
    FROM req_stats() AS rs
    WHERE rs.rs_requester = institution
    GROUP BY rs.rs_req_id
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;

COMMENT ON FUNCTION coldev_rr IS 'All requests placed by an institution''s users and if the request was fulfilled';
