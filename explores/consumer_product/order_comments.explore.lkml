include: "/**/*.view"

explore: order_comments{
  label: "Order Delivery Notes"
  view_label: "Order Delivery Notes"
  group_label: "10) In-app tracking data"
  description: "Extends backend orders to count delivery notes"

  fields: [ALL_FIELDS*,
           -order_comments.years_time_between_hub_launch_and_order,
           -order_comments.quarters_time_between_hub_launch_and_order,
           -order_comments.months_time_between_hub_launch_and_order,
           -order_comments.weeks_time_between_hub_launch_and_order,
           -order_comments.days_time_between_hub_launch_and_order,
           -order_comments.hours_time_between_hub_launch_and_order,
           -order_comments.minutes_time_between_hub_launch_and_order,
           -order_comments.seconds_time_between_hub_launch_and_order
          ]
}
