include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: base_orders {
  from: order_order
  extension: required # can not be used un-extended!
  view_name: base_orders # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: yes

  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: "",
      base_orders.is_internal_order: "no",
      base_orders.is_successful_order: "yes",
      base_orders.created_date: "after 2021-01-25"
    ]
  }
  access_filter: {
    field: base_orders.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  fields: [
    ALL_FIELDS*,
    -base_orders.exclude_dims_as_that_cross_reference*
  ]

  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${base_orders.country_iso}    = ${hubs.country_iso} AND
            ${base_orders.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
    fields: [
      hubs.city,
      hubs.country_iso,
      hubs.country,
      hubs.hub_code,
      hubs.hub_code_lowercase,
      hubs.hub_name
    ]
  }
  }
