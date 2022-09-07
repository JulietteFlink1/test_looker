view: oos_reason_bucketing {
  sql_table_name: `flink-data-dev.dbt_lruiz.oos_reason_bucketing`
    ;;


########################################################################
######################## Dates #########################################
########################################################################


  dimension_group: report_week {
    type: time
    timeframes: [
      week,
      month,
      year,
      week_of_year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_week ;;
  }

########################################################################
######################## IDs ###########################################
########################################################################

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    label: "Country ISO"
    group_label: "IDs"
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    label: "Hub Code"
    group_label: "IDs"
  }

  dimension: parent_sku {
    type: string
    sql: ${TABLE}.parent_sku ;;
    label: "Parent SKU"
    group_label: "IDs"
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
    hidden: yes
  }

########################################################################
######################## Buckets #######################################
########################################################################

  dimension: buckets {
    type: string
    sql: ${TABLE}.buckets ;;
    label: "Buckets Definition"
    description: "OOS Reasons based on buckets prioritazion.
            A product/location OOS could fall into different buckets, based on its relevance we assign an order."
  }

################################
######################## Standalone Buckets
################################


  dimension: is_dc_inactive_and_no_stock {
    type: yesno
    sql: ${TABLE}.is_dc_inactive_and_no_stock ;;
    group_label: "Standalone Buckets"
    label: "Is DC Inactive and No Stock"

    description: "Product/Location OOS and its supplied thru a distribution center which is Inactive and doesn't have stock available."
  }

  dimension: is_dc_inactive_and_stock {
    type: yesno
    sql: ${TABLE}.is_dc_inactive_and_stock ;;
    group_label: "Standalone Buckets"
    label: "Is DC Inactive and Stock"

    description: "Product/Location OOS and its supplied thru a distribution center which is Inactive and has stock available."
  }

  dimension: is_dc_other {
    type: yesno
    sql: ${TABLE}.is_dc_other ;;
    group_label: "Standalone Buckets"
    label: "Is DC Other"

    description: "Product/Location OOS and its supplied thru a distribution center."
  }

  dimension: is_delivery_issues {
    type: yesno
    sql: ${TABLE}.is_delivery_issues ;;
    group_label: "Standalone Buckets"
    label: "Is Delivery Issues"

    description: "Product/Location OOS and it has waste outbound due delivery damaged or delivery expired."
  }

  dimension: is_frequent_oos {
    type: yesno
    sql: ${TABLE}.is_frequent_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Frequent OOS"

    description: "Product/Location OOS and it fluctuates from In Stock to OOS more than 3 times within a week."
  }

  dimension: is_long_term_oos {
    type: yesno
    sql: ${TABLE}.is_long_term_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Long Term OOS Last Week"

    description: "Product/Location OOS current and previous week with Purchase Order (Units ordered) previous week as well."
  }

  dimension: is_really_long_term_oos {
    type: yesno
    sql: ${TABLE}.is_really_long_term_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Really Long Term OOS Last 2 Weeks"

    description: "Product/Location OOS current and previous 2 weeks with Purchase Order (Units ordered) previous 2 weeks as well."
  }

  dimension: is_really_long_term_oos_last_4_weeks {
    type: yesno
    sql: ${TABLE}.is_really_long_term_oos_last_4_weeks ;;
    group_label: "Standalone Buckets"
    label: "Is Really Long Term OOS Last 4 Weeks"

    description: "Product/Location OOS current and previous 4 weeks with Purchase Order (Units ordered) previous 4 weeks as well."

  }

  dimension: is_really_long_term_oos_last_6_weeks {
    type: yesno
    sql: ${TABLE}.is_really_long_term_oos_last_6_weeks ;;
    group_label: "Standalone Buckets"
    label: "Is Really Long Term OOS Last 6 Weeks"

    description: "Product/Location OOS current and previous 6 weeks with Purchase Order (Units ordered) previous 6 weeks as well."
  }


  dimension: is_long_term_supplier_oos {
    type: yesno
    sql: ${TABLE}.is_long_term_supplier_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Long Term Supplier OOS Last Week"

    description: "Product/Location OOS current and previous week with Purchase Order (Units ordered) previous week as well
                    and Handling units = 0 in dispatch notifications, meaning that our supplier is OOS."
  }

  dimension: is_really_long_term_supplier_oos {
    type: yesno
    sql: ${TABLE}.is_really_long_term_supplier_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Long Term Supplier OOS Last 2 Weeks"

    description: "Product/Location OOS current and previous 2 weeks with Purchase Order (Units ordered) previous 2 weeks as well
    and Handling units = 0 in dispatch notifications, meaning that our supplier is OOS."

  }

  dimension: is_new_product {
    type: yesno
    sql: ${TABLE}.is_new_product ;;
    group_label: "Standalone Buckets"
    label: "Is New Product Location"

    description: "Product/Location OOS and it was inbounded for the first time less than 2 weeks ago."
  }

  dimension: is_no_orders {
    type: yesno
    sql: ${TABLE}.is_no_orders ;;
    group_label: "Standalone Buckets"
    label: "Is No Orders"

    description: "Product/Location OOS and there is no order placed in the last week"
  }

  dimension: is_po_no_inbounds {
    type: yesno
    sql: ${TABLE}.is_po_no_inbounds ;;
    group_label: "Standalone Buckets"
    label: "Is Purchase Order (PO) with No Inbounds - Sent "

    description: "Product/Location OOS with Purchase Order (SENT) but no items inbounded (No matching PO<>Inbounds)."
  }


  dimension: is_not_sent_po_no_inbounds {
    type: yesno
    sql: ${TABLE}.is_not_sent_po_no_inbounds ;;
    group_label: "Standalone Buckets"
    label: "Is Technical Issue - PO no Inbounds"

    description: "Product/Location OOS with Purchase Order (NO SENT) but no items inbounded (No matching PO<>Inbounds)."
  }

  dimension: is_outbound_before_cutoff_hours_sl_1 {
    type: yesno
    sql: ${TABLE}.is_outbound_before_cutoff_hours_sl_1 ;;
    group_label: "Standalone Buckets"
    label: "Is Outbound Before Cutoff Hours SL 1"

    description: "Product/Location OOS (SL 1) and waste outbounded before the ending cutoff hours (Cutoff: Mandatory in stock Time Frame)."
  }

  dimension: is_too_late_inbound_sl_1 {
    type: yesno
    sql: ${TABLE}.is_too_late_inbound_sl_1 ;;
    group_label: "Standalone Buckets"
    label: "Is Too Late Inbound SL 1"

    description: "Product/Location OOS (SL 1) and inbounded after the starting cutoff hours (Cutoff: Mandatory in stock Time Frame)."
  }

  dimension: is_outbound_more_than_one_hour_before_closing_time_sl_1 {
    type: yesno
    sql: ${TABLE}.is_outbound_more_than_one_hour_before_closing_time_sl_1 ;;
    group_label: "Standalone Buckets"
    label: "Is Outbound more than 1 Hour before Closing Hub SL 1"

    description: "Product/Location OOS (SL 1) and and waste outbounded more than 1 hour before hub closing hour."
  }

  dimension: is_wrong_purchase_units {
    type: yesno
    sql: ${TABLE}.is_wrong_purchase_units ;;
    group_label: "Standalone Buckets"
    label: "Is Wrong Purchase Units"

    description:"Product/Location OOS and repeted behaviour of fill rate (PO<>Inbounds) less than 80% in more than 50% of the hubs"

  }

########################################################################
######################## Numeric Dimensions ############################
########################################################################

  dimension: number_of_hours_oos {
    type: number
    sql: ${TABLE}.number_of_hours_oos ;;
    label: "Total Hours OOS"
    group_label: "Numeric Dimensions"

    description: "Total amount of hours when a product was oos in a certain location"

    hidden: yes
  }

  dimension: number_of_hours_open {
    type: number
    sql: ${TABLE}.number_of_hours_open ;;
    label: "Total Hours Open"
    group_label: "Numeric Dimensions"

    description: "Total amount of hours when a hub was open"

    hidden: yes
  }

########################################################################
######################## Measures ######################################
########################################################################

  measure: sum_number_of_hours_oos {
    type: sum
    sql: ${number_of_hours_oos} ;;
    label: "# Hours OOS"
    group_label: "OOS Metrics"

    value_format_name: decimal_1
  }

  measure: sum_number_of_hours_open {
    type: sum
    sql: ${number_of_hours_open} ;;
    label: "# Hours Open"
    group_label: "OOS Metrics"

    value_format_name: decimal_1
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
