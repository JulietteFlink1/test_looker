# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team

view: oos_reason_bucketing {
  sql_table_name: `flink-data-prod.reporting.oos_reason_bucketing`
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
######################## Dimension #####################################
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
    sql: ${TABLE}.oos_reason_buckets ;;
    label: "Buckets Definition"
    description: "This dimension refers to the reasons (bucket) that an SKU on a particular location could
            fall among all its possible OOS reasons and the bucketing prioritization."

  }

################################
######################## Standalone Buckets
################################


  dimension: is_dc_inactive_and_no_stock {
    type: yesno
    sql: ${TABLE}.is_dc_inactive_and_no_stock ;;
    group_label: "Standalone Buckets"
    label: "Is DC Inactive and No Stock"

    description: "This flag shows if an SKU on a particular location is being delivered thru a Distribution Center that is Inactive in ERP (Lexbizz)
              and doesn't have stock available of this SKU in the Distribution Center."

  }

  dimension: is_dc_inactive_and_stock {
    type: yesno
    sql: ${TABLE}.is_dc_inactive_and_stock ;;
    group_label: "Standalone Buckets"
    label: "Is DC Inactive and Stock"

    description: "This flag shows if an SKU on a particular location is being delivered thru a Distribution Center that is Inactive in ERP (Lexbizz)
            and has stock available of this SKU in the Distribution Center."

  }

  dimension: is_dc_active {
    type: yesno
    sql: ${TABLE}.is_dc_active ;;
    group_label: "Standalone Buckets"
    label: "Is DC Active"

    description: "This flag shows if an SKU on a particular location is being delivered thru an Active Distribution Center"

  }

  dimension: is_delivery_issues {
    type: yesno
    sql: ${TABLE}.is_delivery_issues ;;
    group_label: "Standalone Buckets"
    label: "Is Delivery Issues"
    description: "This flag shows if an SKU on a particular location was outbounded as waste due delivery issues, such as:
            Product Delivery-Damaged or Product Delivery-Expired"

  }

  dimension: is_frequent_oos {
    type: yesno
    sql: ${TABLE}.is_frequent_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Frequent OOS"

    description: "This flag shows if an SKU on a particular location fluctuates
            from 'In stock' to 'Out of Stock' very often (specifically more than 3 times per week)"

  }

  dimension: is_long_term_oos {
    type: yesno
    sql: ${TABLE}.is_long_term_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Long Term OOS Last Week"

    description: "This flag shows if an SKU on a particular location has been OOS in the last week, but it has been ordered (existing PO).
              This means that we are waiting for this SKU to be delivered soon."

  }

  dimension: is_really_long_term_oos {
    type: yesno
    sql: ${TABLE}.is_really_long_term_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Really Long Term OOS Last 2 Weeks"

    description: "This flag shows if an SKU on a particular location has been OOS in the last 2 weeks, but it has been ordered (existing PO).
             This means that we are waiting for this SKU to be delivered soon."

  }

  dimension: is_really_long_term_oos_last_4_weeks {
    type: yesno
    sql: ${TABLE}.is_really_long_term_oos_last_4_weeks ;;
    group_label: "Standalone Buckets"
    label: "Is Really Long Term OOS Last 4 Weeks"

    description: "This flag shows if an SKU on a particular location has been OOS in the last 4 weeks, but it has been ordered (existing PO).
            This means that we are waiting for this SKU to be delivered soon."

  }

  dimension: is_really_long_term_oos_last_6_weeks {
    type: yesno
    sql: ${TABLE}.is_really_long_term_oos_last_6_weeks ;;
    group_label: "Standalone Buckets"
    label: "Is Really Long Term OOS Last 6 Weeks"

    description: "This flag shows if an SKU on a particular location has been OOS in the last 6 weeks, but it has been ordered (existing PO).
            This means that we are waiting for this SKU to be delivered soon."

  }

  dimension: is_supplier_oos {
    type: yesno
    sql: ${TABLE}.is_supplier_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Supplier OOS"

    description: "This flag shows if an SKU on a particular location, our suppliers comunicated to us that it doesn't
                  have stock available of this SKU (Handling units = 0 in DESADVs).
                  This means that we won't receive this SKU soon since the Supplier is OOS."

  }

  dimension: is_really_long_term_supplier_oos {
    type: yesno
    sql: ${TABLE}.is_really_long_term_supplier_oos ;;
    group_label: "Standalone Buckets"
    label: "Is Long Term Supplier OOS Last 2 Weeks"

    description: "This flag shows if an SKU on a particular location has been OOS in the last 2 weeks, there is a purchase order in place (existing PO)
              but our supplier comunicated to us that it doesn't have stock available of this SKU (Handling units = 0 in DESADVs).
              This means that we won't receive this SKU soon since the Supplier is OOS."

  }

  dimension: is_new_product {
    type: yesno
    sql: ${TABLE}.is_new_product ;;
    group_label: "Standalone Buckets"
    label: "Is New Product Location"

    description: "This flag shows if an SKU on a particular location has been inbounded for the first time, less than 2 weeks ago."

  }

  dimension: is_no_orders {
    type: yesno
    sql: ${TABLE}.is_no_orders ;;
    group_label: "Standalone Buckets"
    label: "Is No Orders"

    description: "This flag shows if an SKU on a particular location doesn't have a purchase order in placed in the last week"

  }

  dimension: is_po_no_inbounds {
    type: yesno
    sql: ${TABLE}.is_po_no_inbounds ;;
    group_label: "Standalone Buckets"
    label: "Is Purchase Order (PO) with No Inbounds - Sent "

    description: "This flag shows if an SKU on a particular location has a purchase order with status 'SENT' in placed (existing PO),
              but there is no actual inbounds (No matches between PO<>Inbounds)"

  }


  dimension: is_not_sent_po_no_inbounds {
    type: yesno
    sql: ${TABLE}.is_not_sent_po_no_inbounds ;;
    group_label: "Standalone Buckets"
    label: "Is Technical Issue - PO no Inbounds"

    description: "This flag shows if an SKU on a particular location has a purchase order with status 'NOT SENT' in placed (existing PO),
              but there is no actual inbounds (No matches between PO<>Inbounds) - Usually when we have PO with status 'Not Sent' we have its indentical twin
              with status 'Sent'. In case we don't, we consider them as 'Sent', that is why we call this flag 'Technical issue'"

  }

  dimension: is_outbound_before_cutoff_hours_sl_1 {
    type: yesno
    sql: ${TABLE}.is_outbound_before_cutoff_hours_sl_1 ;;
    group_label: "Standalone Buckets"
    label: "Is Outbound Before Cutoff Hours SL 1"

    description: "This flag shows if an SKU on a particular location with Shelf Life = 1,
              was outbounded as waste before the 'ending' timestamp of the cutoff hours range (Cutoff: Mandatory in stock Time Frame)."

  }

  dimension: is_too_late_inbound_sl_1 {
    type: yesno
    sql: ${TABLE}.is_too_late_inbound_sl_1 ;;
    group_label: "Standalone Buckets"
    label: "Is Too Late Inbound SL 1"

    description: "This flag shows if an SKU on a particular location with Shelf Life = 1,
              was inbounded after the 'starting' timestamp of the cutoff hours range (Cutoff: Mandatory in stock Time Frame)."

  }

  dimension: is_outbound_more_than_one_hour_before_closing_time_sl_1 {
    type: yesno
    sql: ${TABLE}.is_outbound_more_than_one_hour_before_closing_time_sl_1 ;;
    group_label: "Standalone Buckets"
    label: "Is Outbound more than 1 Hour before Closing Hub SL 1"

    description: "This flag shows if an SKU on a particular location with Shelf Life = 1,
              was outbounded as waste more than 1 hour before the closing hub hour."

  }

  dimension: is_wrong_purchase_units {
    type: yesno
    sql: ${TABLE}.is_wrong_purchase_units ;;
    group_label: "Standalone Buckets"
    label: "Is Wrong Purchase Units"

    description:"This flag shows if an SKU on a particular location has a fill rate (PO<>Inbounds)
              less than 80%, and this SKU repeats this behaviour (%Fill rate < 80%) in more than 50% of the hubs.
              This probably means that purchase units (PK) are wrong."

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
