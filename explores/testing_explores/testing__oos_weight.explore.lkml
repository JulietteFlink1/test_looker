include: "/**/*.explore"
include: "/**/*.view"

explore: testing__oos_weight {
    hidden: yes
    view_label: "* Day-Hourly Importance Score *"
    from: stg_out_of_stock_weights
    view_name: stg_out_of_stock_weights

    always_filter: {
      filters:  [
        hubs.country_iso: "DE",
        hubs.hub_name: ""
      ]
    }
    access_filter: {
      field: hubs.country_iso
      user_attribute: country_iso
    }

    access_filter: {
      field: hubs.city
      user_attribute: city
    }

    join: hubs {
      from:  hubs_ct
      view_label: "* Hubs *"
      type: left_outer
      relationship: many_to_one
      sql_on: ${hubs.hub_code} = ${stg_out_of_stock_weights.hub_code} ;;
    }

    join: products {
      sql_on: ${stg_out_of_stock_weights.sku}         = ${products.product_sku} ;;
      relationship: many_to_one
      type: left_outer
    }

}
