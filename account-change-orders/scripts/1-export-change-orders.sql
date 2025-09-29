select
  aco.order_number,
  aco.subscription_id,
  aco.teacher_seats,
  aco.student_seats,
  s.district_id,
  s.start_date,
  s.end_date,
  aco.state,
  d.name,
  d.district_city,
  d.district_state
FROM
  account_change_orders aco
JOIN
  subscriptions s ON s.id = aco.subscription_id
JOIN
  districts d ON d.id = s.district_id

