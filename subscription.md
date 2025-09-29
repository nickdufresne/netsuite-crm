# Netsuite steps

## DR District ID

(1) New Customer entity field (_pvb_dr_district_id_ / DR DIstrict ID / Integer)
Apply to customer

(2) Import the CSV to link up
============
Internal ID => Customer :: Internal ID
District ID => DR District ID

(3) Update the Scripts => Customers => customer-load-scripts.js

## DR Subscription

(1) Save record and then create fields:
===========

1. Customer field "Record is parent"
2. Start Date
3. End Date
(uncheck) inculde name field

(2) Import subscriptions
================

Run 2-export-subscription.sh
Run 2-link-subscriptions
Import results (Customer field linked to internal id)

Customize DR Subscription Search Results

(3) Add transaction body field: DR Subscription
===============================
1. Add "DR Subscription Customer" (custbody_pvb_dr_subscription_customer) custom field to the transaction
2. sales_order_cli.js will populate that with the current customer or the parent customer if they HAVE a DR District ID
3. Add DR Subscription transaction field (type list/record = DR Subscription) (source from DR Subscription Customer) source from Customer
4. add DR seats (bool), dr_teacher_seats (int), dr_student_seats (int)
5. Upload dr-seats.js
7. add script


DR subscription could be filled with customer's => DR ACCOUNT ID
If customer is a child, default DR ACCOUNT ID to parent's
Subscription is attached to a customer and the account ID is filled in.

ALTERNATIVELY

DR change order SELECT's customer, sales order


# Link up accounts

Downloads Search [Nick] DR Sales/Quotes All: Results
Ruby script to loop through all changes orders and look up in Netsuite table to connect DR-ID => Customer ID

Export account-change-orders

1. s3-pull-prod-copy.sh
2. start docker-postgres
3. cd ~/dev/docker-postgres ./restore-scrubbed
4. ./account-change-orders/export-dr-change-orders.sh

# import customer.internal_id => digital_reader_disctrict_id

# Use opportunities / quotes for FREE TRIALS -~-~-~---

[x] Activate DR Change Order

Transaction (Subscription ID)

Subscription Customer
Subscription_ID



subscription
  customer
  start_date
  end_date

change_orders
  transaction
  teacher_seats
  student_seats

customer
  Digital Reader Tab
    subsriptions

DR Itmes


Export all changes orders and look at the customer_ids?

Search sales orders with DR ... get all the customer/sales order numbers



See how many DR-IDs have multiple customer IDS (root customer or not)
See how many Customer IDs have multiple DR IDs

