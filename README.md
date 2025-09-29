# Import Change Orders and Subscriptions to Netsuite

1. First export data from a fresh production copy

```
$ bash account-change-orders/scripts/1-export-dr-change-orders.sh > account-change-orders/netsuite.csv

$ bash account-change-orders/scripts/2-export-subscriptions.sh > account-change-orders/dr-subscriptions.csv
```

2. Prepare the data for Netsuite import

```
$ ruby 1-link-change-orders.rb
# => ./import/1-customer-district-ids.csv

$ ruby 2-link-subscriptions.rb
# => ./import/2-subscriptions.csv
```

3. Import csv files

* Customer import mapping dr_district_id:
import/1-customer-district-ids.csv
* Custom Record (DR Subscription) import
import/2-subscriptions.csv
