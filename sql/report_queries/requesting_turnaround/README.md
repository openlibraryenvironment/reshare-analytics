# Requesting Turnaround Time

## Report Details

Brief description: This report provides time calculations (average and median) for time to ship, time to receipt, and total time for requests per institution.  Also provides time calculations for each request.

### Definitions

- Time to ship: time between request creation and material shipment
- Time to receipt: time between material shipment and material receipt
- Time total: time between request creation and material receipt 

NOTE: The data are broken up across multiple SQL files; 7 reports can be generated.

**Report 1: Average and Median Time to Shipment**
The turnaround_req_1.sql file will generate data in the following format:

|requester|avg\_time\_to\_ship|med\_time\_to\_ship|
|------------|------------|------------|
|West University| 3 days, 19:18:12.769899 | 2 days, 22:09:44.699000 |
|East University| 3 days, 6:41:21.900339	| 2 days, 17:40:28.436000 |

**Report 2: Average and Median Time to Receipt**
The turnaround_req_2.sql file will generate data in the following format:

|requester|avg\_time\_to\_receipt|med\_time\_to\_receipt|
|------------|------------|------------|
|West University| 2 days, 14:00:23.417798|	23:24:13.808000 |
|East University| 1 day, 19:14:27.326411	| 0:27:09.129500 |

**Report 3: Average and Median Total Turnaround Time**
The turnaround_req_3.sql file will generate data in the following format:

|requester|avg\_time\_total|med\_time\_total|
|------------|------------|------------|
|East University  	| 4 days, 22:05:47.767811	| 4 days, 18:20:25.933000 |
|West University 	| 6 days, 6:53:39.169698	| 5 days, 10:29:32.210000 |

**Report 4: Number of Requests Received in less than 48 Hours**
The turnaround_req_4.sql file will generate data in the following format:

|requester|reqs\_under\_48|
|------------|------------|
| East University |	6 |
| West University	| 82 |

**Report 5: Number of Requests Received in 48-72 Hours**
The turnaround_req_5.sql file will generate data in the following format:

|requester|reqs\_btwn\_48\_72|
|------------|------------|
| East University 	| 33 |
| West University  | 301 |

**Report 6: Number of Requests Received in more than 72 hours**
The turnaround_req_6.sql file will generate data in the following format:

|requester|reqs\_over\_72|
|------------|------------|
| East University	| 136 |
| West University | 1800 |

**Report 7: Detailed turnaround time report - all requests**
The turnaround_req_7.sql file will generate data in the following format:

|request\_id|request\_url|supplier|title|call\_number|barcode|created|shipped|received|time\_to\_ship|time\_to\_receipt|total\_time|
|------------|------------|------------|-----------------|------------|------------|------------|------------|------------|------------|------------|------------|
|EAST-21|[RESHARE URL]/request/requests/view/8612d9cb-bc65-41de-883f-1066a96e5345/flow|US-WESTU|Let dogs be dogs|None|31735063437119|2021-08-12 13:47:58.509000 |2021-08-12 14:49:50.642000	| 2021-08-16 17:37:06.537000 |1:01:52.133000 |4 days, 2:47:15.895000 |4 days, 3:49:08.028000 |
|WEST-221|[RESHARE URL]/request/requests/view/e109f199-9a34-4260-8107-df733643559d/flow|US-EASTU|Anthony Bourdain's hungry ghosts|None|31198052034381|2021-08-13 16:30:41.149000 |2021-08-13 19:24:17.724000|2021-08-18 13:50:41.182000|2:53:36.575000|4 days, 18:26:23.458000|4 days, 21:20:00.033000|

Users may want to replace [RESHARE URL] with their system's actual base ReShare URL.

### Data Dictionary ###
- **Average time to ship**: Average time elapsed between request created and request shipped.
- **Median time to ship**: Median time elapsed between request created and request shipped.
- **Average time to receipt**: Average time elapsed between request shipped and request received.
- **Median time to receipt**: Median time elapsed between request shipped and request received.
- **Average time total**: Average time elapsed between request created and request received.
- **Median time total**: Median time elapsed between request created and request received.
- **Request ID**: The request identifier, which specifies the requesting institution.
- **Requester**: Requesting institution.
- **Request URL**:  URL for the request in the requester's ReShare tenant.
- **Supplier**: Supplying institution symbol, formatted: US-PV.  
- **Title**: Title of requested item. 
- **Call Number**:  ?Supplier's call number? 
- **Barcode**: (Supplier's) barcode number.  
- **Created**: Date/time request created. 
- **Shipped**: Date/time item shipped by supplier.
- **Received**: Date/time item received by requester. 

 QUESTION:	The Call Number column is "None" for all rows.  No obvious typo in query -- should the column be deleted for now?
