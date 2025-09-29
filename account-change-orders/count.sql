select
  count(aco.*)
FROM
  account_change_orders aco
JOIN
  subscriptions s ON s.id = aco.subscription_id
JOIN
  districts d ON d.id = s.district_id


select
  aco.order_number,
  aco.created_at,
  aco.subscription_id
FROM
  account_change_orders aco
WHERE
  NOT EXISTS (
    SELECT 1 FROM subscriptions s JOIN districts d ON d.id = s.district_id WHERE s.id = aco.subscription_id
  )
