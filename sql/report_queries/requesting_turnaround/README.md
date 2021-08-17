# Requesting Turnaround Time

## Report Details

Brief description: This report provides time calculations (average and median) for time to ship, time to receipt, and total time for requests per institution.  Also provides time calculations for each request.

### Definitions

- Time to ship: time between request creation and material shipment
- Time to receipt: time between material shipment and material receipt
- Time total: time between request creation and material receipt 

NOTE: The data are broken up across multiple SQL files.

The turnaround_req_1.sql file will generate data in the following format:

|requester|avg\_time\_to\_ship|med\_time\_to\_ship|
|------------|------------|------------|
reshare_east|03:31:43.353075|00:05:16.5585


The turnaround_req_2.sql file will generate data in the following format:

|requester|avg\_time\_to\_receipt|med\_time\_to\_receipt|
|------------|------------|------------|
reshare_east|00:45:32.210818|00:00:10.789

The turnaround_req_3.sql file will generate data in the following format:

|requester|avg\_time\_total|med\_time\_total|
|------------|------------|------------|
reshare_east|01:13:41.425583|00:06:47.147


The turnaround_req_4.sql file will generate data in the following format:

|requester|reqs\_under\_48|
|------------|------------|
reshare_east|12|

The turnaround_req_5.sql file will generate data in the following format:

|requester|reqs\_btwn\_48\_72|
|------------|------------|
reshare_east|7|

The turnaround_req_6.sql file will generate data in the following format:

|requester|reqs\_over\_72|
|------------|------------|
reshare_east|3|

The turnaround_req_7.sql file will generate data in the following format:

|request\_id|request\_url|supplier|title|call\_number|barcode|created|shipped|received|time\_to\_ship|time\_to\_receipt|total\_time|
|------------|------------|------------|-----------------|------------|------------|------------|------------|------------|------------|------------|------------|
EAST-15|[RESHARE URL]/request/requests/view/2de31ff0-8611-48e8-a850-349e3e64156b/flow|US-WEST|Hamlet: father and son||39151001847314|2021-08-05 17:29:55|2021-08-05 18:48:30|2021-08-05 18:49:24|01:18:35.585|00:00:53.308|01:19:28.893|

Users may want to replace [RESHARE URL] with their system's actual base ReShare URL.
