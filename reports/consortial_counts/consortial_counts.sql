--metadb:function consortial_counts

DROP FUNCTION IF EXISTS consortial_counts;

CREATE FUNCTION consortial_counts(
    start_date date DEFAULT '2020-01-01',
    end_date date DEFAULT '2030-01-01')
RETURNS TABLE(
     requester text,
     supplier text,
     count_of_requests bigint)
AS $$
SELECT
    cv_requester_nice_name AS requester,
    cv_supplier_nice_name AS supplier,
    count(*) AS count_of_requests
FROM
    reshare_derived.consortial_view cv
WHERE
    cv.cv_date_created >= start_date
    AND cv.cv_date_created < end_date
GROUP BY
    cv.cv_requester_nice_name,
    cv.cv_supplier_nice_name
ORDER BY
    cv.cv_requester_nice_name
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
