# Owner: Daniel Tancu
# Main Stakeholder:
# - Demand Planning team
# - Supply Chain team
#
# Questions that can be answered
# - All questions around Relex promotions for PLs

view: promotions {
  sql_table_name: `flink-supplychain-prod.curated.promotions`
    ;;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# =========  __main__   =========
  dimension: campaign_category_placement {
    type: string
    sql: ${TABLE}.campaign_category_placement ;;
    label: "Category Placement"
    group_label: ""
    description: "Shows the campaign category placement"
    hidden: no
  }

  dimension: campaign_class {
    type: string
    sql: ${TABLE}.campaign_class ;;
    label: "Campaign Class"
    group_label: ""
    description: "Shows the class of the campaign"
    hidden: no
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
    label: "Campaign Name"
    group_label: ""
    description: "Shows the name of the campaign "
    hidden: no
  }

  dimension: campaign_type_channel {
    type: string
    sql: ${TABLE}.campaign_type_channel ;;
    label: "Campaign Type Channel"
    group_label: ""
    description: "Shows the campaign type channel of product-location"
    hidden: no
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    label: "Country"
    group_label: ""
    description: "Geographical information of product-location"
    hidden: no
  }

  dimension: created_time {
    type: string
    sql: ${TABLE}.created_time ;;
    label: "Created Time"
    group_label: ""
    description: "Shows the created time of the promotion"
    hidden: no
  }

  dimension_group: end {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_date ;;
    label: "End Date"
    group_label: ""
    description: "Shows the end date of the promotion"
    hidden: no
  }

  dimension_group: end_date_with_shelf_life {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_date_with_shelf_life ;;
    label: "End Date with Shelf Life"
    group_label: ""
    description: "Shows the end date taking into addition the shelf life of the product"
    hidden: no
  }

  dimension: expected_uplift {
    type: string
    sql: ${TABLE}.Expected_uplift ;;
    label: "Expected Uplift"
    group_label: ""
    description: "Displays expected Uplift in percentage"
    hidden: no
  }

  dimension: hub_list {
    type: string
    sql: ${TABLE}.Hub_List ;;
    label: "Hub List"
    group_label: ""
    description: "Shows the hub list of promotion"
    hidden: no
  }

  dimension: national_list {
    type: string
    sql: ${TABLE}.National_List ;;
    label: "National List"
    group_label: ""
    description: "Displays if on national list"
    hidden: no
  }

  dimension: promo_max_waste_range {
    type: number
    sql: ${TABLE}.promo_max_waste_range ;;
    label: "Promo Max Waste Range"
    group_label: ""
    description: "Shows the promotion maximum waste range"
    hidden: no
  }


  dimension: promo_range_filter {
    type: string
    sql: ${TABLE}.Promo_range_filter ;;
    label: "Promo Range Filter"
    group_label: ""
    description: "Filter for displaying either pure or added shelf-life promotion"
    hidden: no
  }

  dimension: promotion_category {
    type: string
    sql: ${TABLE}.Promotion_category ;;
    label: "Promotion Category"
    group_label: ""
    description: "Shows the promotion category"
    hidden: no
  }

  dimension_group: report {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
    label: "Report Date"
    group_label: ""
    description: "Displays report date"
    hidden: no
  }

  dimension: requested_by {
    type: string
    sql: ${TABLE}.requested_by ;;
    label: "Requested By"
    group_label: ""
    description: "Shows the Flink person that has requested the promotion addition"
    hidden: no
  }

  dimension: shelf_life {
    type: number
    sql: ${TABLE}.shelf_life ;;
    label: "Shelf Life"
    group_label: ""
    description: "Shows shelf life"
    hidden: no
  }

  dimension: sku {
    type: string
    sql: cast(${TABLE}.SKU as string);;
    label: "SKU"
    group_label: ""
    description: "Shows SKU number"
    hidden: no
  }

  dimension_group: start {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.start_date ;;
    label: "Start Date"
    group_label: ""
    description: "Shows the start date of the promotion"
    hidden: no
  }

  dimension: status {
    type: string
    sql: ${TABLE}.Status ;;
    label: "Status"
    group_label: ""
    description: "Shows the status of promotion"
    hidden: no
  }

  dimension: sub_type_discount_value {
    type: string
    sql: ${TABLE}.sub_type_discountValue ;;
    label: "Sub Type Discount Value"
    group_label: ""
    description: "Shows the sub type discount value of the product location promotion"
    hidden: no
  }

  dimension: sub_type_discount_value_1 {
    type: string
    sql: ${TABLE}.sub_type_discountValue_1 ;;
    label: "Sub Type Discount Value 1"
    group_label: ""
    description: ""
    hidden: yes
    }

  measure: count {
    type: count
    drill_fields: [created_time, campaign_name]
  }
}
