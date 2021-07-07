include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: base_order_hub_level {
  extends: [base_orders]
  # view_name: base_order_hub_level
  extension: required
  fields: [
    ALL_FIELDS*,
    -base_orders.exclude_dims_as_that_cross_reference*
  ]
}
