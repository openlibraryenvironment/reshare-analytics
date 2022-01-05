# Supplying Turnaround Time

## Report Details

Brief description: This report provides time calculations (average and median) for time to fill, time to ship, time to receipt, and total time for requests per supplying institution.  Also provides time calculations for each request.

### Definitions

- Time to fill: time between supplier assignment and request filled 
- Time to ship: time between request filled and item shipped
- Time to receipt: time between item shipped and item received
- Time total: time between supplier assignment and item received 

All times are formatted as: D days, HH:MM:SS.sssssss

NOTE: The data are broken up across multiple SQL files.  8 reports can be generated.

**Report 1: Average and Median Time to Fill**
The turnaround_sup_1.sql file will generate data in the following format:

|supplier|avg\_time\_to\_fill|med\_time\_to\_fill|
|------------|------------|------------|
| East University | 18:57:50.631783 | 9:31:30.783500 |
| West University | 1 day, 6:30:12.150416 | 20:13:41.811500 |

**Report 2: Average and Median Time to Shipment**
The turnaround_sup_2.sql file will generate data in the following format:

|supplier|avg\_time\_to\_ship|med\_time\_to\_ship|
|------------|------------|------------|
| East University | 0:01:42.407762 | 0:00:03.057500 |
| West University | 1:07:37.461209 | 0:00:05.375500 |

**Report 3: Average and Median Time to Receipt**
The turnaround_sup_3.sql file will generate data in the following format:

|supplier|avg\_time\_to\_receipt|med\_time\_to\_receipt|
|------------|------------|------------|
| East University | 4 days, 11:59:22.478636 | 4 days, 3:34:49.967000 |
| West University | 4 days, 1:34:49.845859 | 3 days, 1:01:58.067000 |

**Report 4: Number of Requests Received in less than 48 hours**
The turnaround_sup_4.sql file will generate data in the following format:

|supplier|reqs\_under\_48|
|------------|------------|
| East University | 5 |
| West University | 169 |

**Report 5: Number of Requests Received in 48-72 hours**
The turnaround_sup_5.sql file will generate data in the following format:

|supplier|reqs\_btwn\_48\_72|
|------------|------------|
| East University | 12 |
| West University | 321 |

**Report 6: Number of Requests Received in more than 72 hours**
The turnaround_sup_6.sql file will generate data in the following format:

|supplier|reqs\_over\_72|
|------------|------------|
| East University | 192 |
| West University | 1159 |

**Report 7: Average and Median Total Turnaround Time**  
The turnaround_sup_7.sql file will generate data in the following format:

|supplier|avg\_time\_total|med\_time\_total|
|------------|------------|------------|
| East University | 5 days, 7:39:16.085110 | 5 days, 5:14:27.978000 |
| West University | 5 days, 6:37:01.722511 | 4 days, 17:22:00.379000 |

**Report 8: Detailed turnaround time report - all requests**
The turnaround_sup_8.sql file will generate data in the following format:

|supplier|request\_id|request\_url|requester|title|call\_number|barcode|assigned|filled|shipped|received|time\_to\_fill|time\_to\_ship|time\_to\_receipt|total\_time|
|--------|------------|------------|------------|-----------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|------------|
| East University | WEST-33 |[RESHARE URL] /request/requests/view/80cc0637-6f62-40b5-8515-9c6b9974292a/flow | US-WESTU | Lot's wife : salt and the human condition | 612.015 T524 L | 33768005462919 | 2021-08-19 15:57:40.687000 |	2021-08-19 18:14:56.753000 | 2021-08-19 18:15:42.443000 | 2021-08-24 12:24:33.074000 | 	2:17:16.066000 | 2:18:01.756000	| 4 days, 20:26:52.387000 | 4 days, 20:26:52.387000 |
| West University | EAST-64 | [RESHARE URL]/request/requests/view/53d162ff-de1b-4ea0-b58c-040291e96eb9/flow | US-EASTU | Who speaks for Wales? : nation, culture, identity | 	DA722.W55 2003 | 39030031240262	| 2021-08-19 16:06:46.040000 | 2021-08-19 19:18:04.174000 |	2021-08-19 19:18:08.717000 | 2021-08-26 16:41:43.179000	| 3:11:18.134000 | 3:11:22.677000	 | 7 days, 0:34:57.139000 | 7 days, 0:34:57.139000 |

Users may want to replace [RESHARE URL] with their system's actual base ReShare URL.

### Data Dictionary ###
- **Average time to fill**: Average time elapsed between supplier assignment and filled.
- **Median time to fill**: Median time elapsed between supplier assignment and filled.
- **Average time to ship**: Average time elapsed between filled and shipped.
- **Median time to ship**: Median time elapsed between filled and shipped.
- **Average time to receipt**: Average time elapsed between shipped and received.
- **Median time to receipt**: Median time elapsed between shipped and received.
- **Average time total**: Average time elapsed between supplier assigned and received.
- **Median time total**: Median time elapsed between supplier assigned and received.
- **Supplier**: Supplying institution.
- **Request ID**: The request identifier, which specifies the requesting institution. 
- **Request URL**: URL for the request in the requester's ReShare tenant.  
	  QUESTION: why not supplier URL in the supplying report?
- **Requester**: Requesting institution symbol, formatted US-PV.
- **Title**: Title of requested item.
- **Call Number**: Supplier's call number.
- **Barcode**: Supplier's barcode number.
- **Assigned**: Date/time request assigned to supplier.
- **Filled**: Date/time request marked as filled by supplier.
- **Shipped**: Date/time item shipped by supplier.
- **Received**: Date/time item received by requester.
