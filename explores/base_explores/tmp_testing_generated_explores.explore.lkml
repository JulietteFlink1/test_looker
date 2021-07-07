include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

# IMPORTANT
# the base explores have set the flag extension:required making them not available unextended

explore: test_base_orders {
  extends: [base_order_orderline]
  fields: [
    ALL_FIELDS*,
    -base_orders.exclude_dims_as_that_cross_reference*
  ]
}
