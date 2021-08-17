# Consortial View of Supplying

## Report Details

Brief description: This report provides numbers of fills between institutions across the consortium.

NOTE: The display format does not match the SME mockup, but the data are there.

The consortial_supplier.sql file will generate data in the following format:

|supplier|requester|count\_of\_requests|
|------------|------------|------------|
|RESHARE:US-EAST|reshare_west|2|
|RESHARE:US-EAST|reshare_south|3|
|RESHARE:US-WEST|reshare_east|14|


The consortial_total_by_supplier.sql file will generate data in the following format:

|supplier|count\_of\_requests|
|------------|------------|
|RESHARE:US-EAST|5|
|RESHARE:US-WEST|14|