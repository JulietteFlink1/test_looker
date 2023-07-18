include: "/**/*.view"

  # this explore was created by Bruno Wolfram - July.23
  # it is based on the ticket https://goflink.atlassian.net/browse/DATA-6001
  # ... and aims to make it easier to check and compare for promotion performance

explore: product_discounts_results {

  group_label: "Pricing"
  label: "Product Discounts Results"
  hidden: no

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${product_discounts_results.valid_from} {% endcondition %};;

  access_filter: {
    field: product_discounts_results.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      product_discounts_results.country_iso: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

  # ~~~~~~~~~~~~~~~~~~~~~~ Hub Tiers  ~~~~~~~~~~~~~~~~~~~~~~ #
  join: geographic_pricing_hub_cluster {

    view_label: "Geographic Pricing"


    sql_on:
        ${geographic_pricing_hub_cluster.hub_code} = ${product_discounts_results.hub_code}
        ;;
    type: left_outer
    relationship: many_to_one
  }


  # ~~~~~~~~~~~~~~~~~~~~~~ SKU Tiers  ~~~~~~~~~~~~~~~~~~~~~~ #
  join: geographic_pricing_sku_cluster {

    view_label: "Geographic Pricing"


    sql_on:
        ${geographic_pricing_sku_cluster.sku}           = ${product_discounts_results.sku} and
        ${geographic_pricing_sku_cluster.country_iso}   = ${product_discounts_results.country_iso}
        ;;
    relationship: many_to_one
  }


  # ~~~~~~~~~~~~~~~~~~~~~~ SKU attributes  ~~~~~~~~~~~~~~~~~~~~~~ #
  join: products {

    view_label: "Product Data"

    sql_on:
        ${products.product_sku} = ${product_discounts_results.sku} and
        ${products.country_iso} = ${product_discounts_results.country_iso}
        ;;
    relationship: many_to_one
    type: left_outer
  }


  # ~~~~~~~~~~~~~~~~~~~~~~ Hub attributes  ~~~~~~~~~~~~~~~~~~~~~~ #
  join: hubs_ct {

    view_label: "Hubs"

    sql_on:
      ${hubs_ct.hub_code} = ${product_discounts_results.hub_code}
    ;;
    relationship: many_to_one
    type: left_outer
  }

    }
