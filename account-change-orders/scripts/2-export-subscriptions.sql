select
  s.id as subscription_id,
  s.district_id,
  s.start_date,
  s.end_date
FROM
  subscriptions s
WHERE
  s.state = 'Active';
