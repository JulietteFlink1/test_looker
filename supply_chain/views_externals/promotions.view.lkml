view: promotions {
  sql_table_name: `flink-supplychain-prod.curated.promotions`
    ;;

  dimension: campaign_category_placement {
    type: string
    sql: ${TABLE}.campaign_category_placement ;;
  }

  dimension: campaign_class {
    type: string
    sql: ${TABLE}.campaign_class ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_type_channel {
    type: string
    sql: ${TABLE}.campaign_type_channel ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: created_time {
    type: string
    sql: ${TABLE}.created_time ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_date ;;
  }

  dimension_group: end_date_with_shelf_life {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_date_with_shelf_life ;;
  }

  dimension: expected_uplift {
    type: string
    sql: ${TABLE}.Expected_uplift ;;
  }

  dimension: hub_list {
    type: string
    sql: ${TABLE}.Hub_List ;;
  }

  dimension: national_list {
    type: string
    sql: ${TABLE}.National_List ;;
  }

  dimension: promo_max_waste_range {
    type: number
    sql: ${TABLE}.promo_max_waste_range ;;
  }

  dimension: promo_range_filter {
    type: string
    sql: ${TABLE}.Promo_range_filter ;;
  }

  dimension: promotion_category {
    type: string
    sql: ${TABLE}.Promotion_category ;;
  }

  dimension_group: report {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }

  dimension: requested_by {
    type: string
    sql: ${TABLE}.requested_by ;;
  }

  dimension: shelf_life {
    type: number
    sql: ${TABLE}.shelf_life ;;
  }

  dimension: sku {
    type: string
    sql: cast(${TABLE}.SKU as string);;
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.start_date ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.Status ;;
  }

  dimension: sub_type_discount_value {
    type: string
    sql: ${TABLE}.sub_type_discountValue ;;
  }

  dimension: sub_type_discount_value_1 {
    type: string
    sql: ${TABLE}.sub_type_discountValue_1 ;;
  }

  measure: count {
    type: count
    drill_fields: [created_time, campaign_name]
  }
}
