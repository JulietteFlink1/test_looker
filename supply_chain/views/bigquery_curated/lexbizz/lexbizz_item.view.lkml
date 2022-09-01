view: lexbizz_item {
  sql_table_name: `flink-data-prod.curated.lexbizz_item`
    ;;

  dimension: base_uom {
    type: string
    sql: ${TABLE}.base_uom ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: handling_unit_height {
    type: number
    sql: ${TABLE}.handling_unit_height ;;
  }

  dimension: handling_unit_length {
    type: number
    sql: ${TABLE}.handling_unit_length ;;
  }

  dimension: handling_unit_width {
    type: number
    sql: ${TABLE}.handling_unit_width ;;
  }

  dimension: hub_type {
    type: string
    sql: ${TABLE}.hub_type ;;
  }

  dimension_group: ingestion {
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ingestion_date ;;
  }

  dimension_group: introduction_timestamp {
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.introduction_timestamp ;;
  }

  dimension: item_category {
    type: string
    sql: ${TABLE}.item_category ;;
  }

  dimension: item_height {
    type: number
    sql: ${TABLE}.item_height ;;
  }

  dimension: item_length {
    type: number
    sql: ${TABLE}.item_length ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: item_replenishment_substitute_group {
    type: string
    sql: ${TABLE}.item_replenishment_substitute_group ;;
  }

  dimension: similar_rsg {
    type: string
    sql: lower(left(${item_replenishment_substitute_group}, 10)) ;;
  }

  dimension: item_safety_stock {
    type: number
    sql: ${TABLE}.item_safety_stock ;;
  }

  dimension: item_status {
    type: string
    sql: ${TABLE}.item_status ;;
  }

  dimension: item_substitute_group {
    type: string
    sql: ${TABLE}.item_substitute_group ;;
  }

  dimension: item_type {
    type: string
    sql: ${TABLE}.item_type ;;
  }


  dimension: item_class {
    type: string
    sql: ${TABLE}.item_class ;;
  }

  dimension: item_volumne {
    type: number
    sql: ${TABLE}.item_volumne ;;
  }

  dimension: item_weight {
    type: number
    sql: ${TABLE}.item_weight ;;
  }

  dimension: item_width {
    type: number
    sql: ${TABLE}.item_width ;;
  }

  dimension_group: last_modified_timestamp {
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.last_modified_timestamp ;;
  }

  dimension_group: item_status_modified {
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.item_status_update ;;
  }

  dimension: max_shelf_life_days {
    type: number
    sql: ${TABLE}.max_shelf_life_days ;;
  }

  dimension: msrp {
    type: number
    sql: ${TABLE}.msrp ;;
  }

  dimension: noos_item {
    type: yesno
    sql: ${TABLE}.noos_item ;;
  }

  dimension: noos_leading_product {
    type: yesno
    sql: ${TABLE}.noos_leading_product ;;
  }

  dimension: purchase_unit {
    type: string
    sql: ${TABLE}.purchase_unit ;;
  }

  dimension: purchase_uom {
    type: string
    sql: ${TABLE}.purchase_uom ;;
  }

  dimension: sales_uom {
    type: string
    sql: ${TABLE}.sales_uom ;;
  }

  dimension: seasonality {
    type: string
    sql: ${TABLE}.seasonality ;;
  }

  dimension: min_days_to_best_before_date {
    type: string
    sql: ${TABLE}.min_days_to_best_before_date ;;
  }

  dimension: ean {
    type: string
    sql: ${TABLE}.ean ;;
  }

  dimension: ean_length {
    type: string
    sql: length(${ean}) ;;
  }

  dimension: ean_matching_digits {
    type: yesno
    sql: (${ean_length} = 8 or ${ean_length} = 13) ;;
  }


  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: is_leading_sku {
    type: yesno
    sql: left(${sku},1) = '9' ;;
  }

  measure: cnt_leading_skus  {
    type: count_distinct
    sql: ${sku} ;;
    filters: [is_leading_sku: "yes"]
  }




  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: tax_category {
    type: string
    sql: ${TABLE}.tax_category ;;
  }

  dimension_group: termination_timestamp {
    type: time
    timeframes: [
      time,
      date
    ]
    sql: ${TABLE}.termination_timestamp ;;
  }

  dimension: valuation_method {
    type: string
    sql: ${TABLE}.valuation_method ;;
  }



  dimension: erp_ct_sync_check {
    type: yesno

    sql:
      lower(${base_uom})             = lower(${products.unit_of_measure})
      and replace(lower(${item_category}),' ', '')  = concat(lower(${products.erp_category}), lower(${products.erp_subcategory}))
      and ${item_name} = ${products.product_name}
      and ((${item_status} = 'Active' and ${products.is_published} is true) or (${item_status} != 'Active' and ${products.is_published} is false))
      and ((${item_substitute_group} = ${products.substitute_group}) or (${item_substitute_group} is null and ${products.substitute_group} is null))
      and ((${item_weight} = ${products.weight}) or (${item_weight} is null and ${products.weight} is null))
      and ${noos_item} = ${products.is_noos_group}
      and ${noos_leading_product} = ${products.is_leading_product}

    ;;
  }

  dimension: group_company {
    label: "Group Company"
    description: "The manufacturing company of a product. A group company entails a set of brands, which in turn eintail a set of products."

    type: string
    sql: ${TABLE}.group_company ;;
  }

  measure: count {
    type: count
    drill_fields: [item_name]
  }

  measure: cnt_skus {

    label: "# unique SKUs"

    type: count_distinct
    sql: ${sku} ;;
  }
}
