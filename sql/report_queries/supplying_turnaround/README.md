# Supplying Turnaround Time

## Report Details

Brief description: This report provides time calculations (average and median) for time to fill, time to ship, time to receipt, and total time for requests per supplying institution.  Also provides time calculations for each request.

### Definitions

- Time to fill: time between supplier assignment and request fill
- Time to ship: time between request fill and material shipment
- Time to receipt: time between material shipment and material receipt
- Time total: time between supplier assignment and material receipt 

NOTE: The data are broken up across multiple SQL files.

The turnaround_sup_1.sql file will generate data in the following format:

|supplier|avg\_time\_to\_fill|med\_time\_to\_fill|
|------------|------------|------------|
(adding examples here)


The turnaround_sup_2.sql file will generate data in the following format:

|supplier|avg\_time\_to\_ship|med\_time\_to\_ship|
|------------|------------|------------|
reshare_west|00:00:27.093786|00:00:25.85|


The turnaround_sup_3.sql file will generate data in the following format:

|supplier|avg\_time\_to\_receipt|med\_time\_to\_receipt|
|------------|------------|------------|
reshare_west|00:01:02.7108|00:00:18.3705|


The turnaround_sup_4.sql file will generate data in the following format:

|supplier|reqs\_under\_48|
|------------|------------|
reshare_east|12|

The turnaround_sup_5.sql file will generate data in the following format:

|supplier|reqs\_btwn\_48\_72|
|------------|------------|
reshare_east|7|

The turnaround_sup_6.sql file will generate data in the following format:

|supplier|reqs\_over\_72|
|------------|------------|
reshare_east|3|

The turnaround_sup_7.sql file will generate data in the following format:

|supplier|avg\_time\_total|med\_time\_total|
|------------|------------|------------|
reshare_west|00:13:09.7858|00:04:28.6565|

The turnaround_sup_8.sql file will generate data in the following format:

|supplier|request\_id|request\_url|requester|title|call\_number|barcode|assigned|filled|shipped|received|time\_to\_fill|time\_to\_ship|time\_to\_receipt|total\_time|
|--------|------------|------------|------------|-----------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|
reshare_west|EAST-15|[RESHARE URL]/request/requests/view/6635f627-c049-4f14-b153-1f320a993d33/flow|US-EAST|Hamlet: father and son|PR2807.A873|39151001847314|2021-08-05 17:29:55|2021-08-05 18:48:25|2021-08-05 18:48:30|2021-08-05 18:49:24|01:18:30.178|01:18:35.314|01:19:28.672|01:19:28.672|

Users may want to replace [RESHARE URL] with their system's actual base ReShare URL.
