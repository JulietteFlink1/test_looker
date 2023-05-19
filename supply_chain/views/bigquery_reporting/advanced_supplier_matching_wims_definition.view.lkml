#Owner: Lauti Ruiz
#Main Stakeholder: Supply Chain Team
#Main use case: It assigns different reasons to Underdeliveries/Overdeliveries.

view: advanced_supplier_matching_wims_definition {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-dev.dbt_lruiz_reporting.advanced_supplier_matching_wims_definition`
    ;;

###############################################################
##################### General Dimensions ######################
###############################################################

  dimension: table_uuid {
    label: "Table UUID"
    group_label: "WIMS Buckets"
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: hub_code {
    label: "Hub Code"
    group_label: "WIMS Buckets"
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: parent_sku {
    label: "Parent SKU"
    group_label: "WIMS Buckets"
    type: string
    description: "Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku ;;
    hidden: yes
  }

  dimension: total_quantity_inbounded {
    label: "Total Quantity Inbounded"
    group_label: "WIMS Buckets"
    type: number
    description: "Total amount of items inbounded during the inbounding process."
    sql: ${TABLE}.total_quantity_inbounded ;;
    hidden: yes
  }

  dimension: total_quantity_po_or_desadvs {
    label: "Total Quantity Ordered/Delivered (PO - DESADVs)"
    group_label: "WIMS Buckets"
    type: number
    description: "Number of selling units of a product that have been delivered/ordered"
    sql: ${TABLE}.total_quantity_po_or_desadvs ;;
    hidden: yes
  }

  dimension: wims_buckets {
    label: "WIMS Buckets Clasification"
    group_label: "WIMS Buckets"
    type: string
    description: "This field classifies data points into distinct buckets based on various conditions and its prioritization."
    sql: ${TABLE}.wims_buckets ;;
  }

  dimension: wims_buckets_quantities {
    label: "WIMS Buckets Quantity"
    group_label: "WIMS Buckets"
    type: number
    description: "This field shows the total quantities that fall into the different buckets."
    sql: ${TABLE}.wims_buckets_quantities ;;
    hidden: yes
  }

###############################################################
##################### Dates Dimensions ########################
###############################################################

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: report {
    label: "Report"
    group_label: "WIMS Buckets"
    type: time
    description: "Combined date between Promised Delivery Date Combined (DESADVs - PO) and Inbounded date, so:
    In case there is DESADVs then DESADVs delivery date,
    else purchase orders promised delivery date (PO),
    else Inbounded date."
    timeframes: [
      date,
      week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
    hidden: yes
  }


###############################################################
##################### Buckets Dimensions ######################
###############################################################

  dimension: md_hub_status {
    label: "MD - Hub Status"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to Hub status issues (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_hub_status ;;
    hidden: yes
  }

  dimension: md_incorrect_ean_hei_wrong_scanning {
    label: "MD/HE - Incorrect EAN/Wrong Scanning"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to either wrong EANs codes or wrong scanning at the hub (Master Data / Human error issue) - In Selling Units."
    sql: ${TABLE}.md_incorrect_ean_hei_wrong_scanning ;;
    hidden: yes
  }

  dimension: md_incorrect_pack_factor {
    label: "MD - Incorrect Pack Factor"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong quantity per handling units issue(Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_incorrect_pack_factor ;;
    hidden: yes
  }

  dimension: md_introduction_date_issue {
    label: "MD - Incorrect Introduction Date"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong ERP item-location introduction date (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_introduction_date_issue ;;
    hidden: yes
  }

  dimension: md_lead_time_issue {
    label: "MD - Incorrect Lead Time"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong lead times definition between PO and Inbounds (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_lead_time_issue ;;
    hidden: yes
  }

  dimension: md_missing_ean_hu {
    label: "MD - Missing EAN HU"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to missing EAN Handling Unit (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_missing_ean_hu ;;
    hidden: yes
  }

  dimension: md_purchase_order_issue {
    label: "MD/SI - Purchase Order"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong purchase order attributes that causes mismatches issues (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_purchase_order_issue ;;
    hidden: yes
  }

  dimension: md_similar_ean_and_ean_hu {
    label: "MD - Similar EAN & EAN HU"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to similar EAN and EAN handling unit issue (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_similar_ean_and_ean_hu ;;
    hidden: yes
  }

  dimension: hei_inbound {
    label: "HE - Incorrect Inbound"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong inbounds caused by Ops associates at the hub (Human Error Issue) - In Selling Units."
    sql: ${TABLE}.hei_inbound ;;
    hidden: yes
  }

  dimension: si_overdeliveries {
    label: "SI - Overdeliveries"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering more than ordered/expected (Supplier Issue) - In Selling Units."
    sql: ${TABLE}.si_overdeliveries ;;
    hidden: yes
  }

  dimension: si_underdeliveries {
    label: "SI - Underdeliveries"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering less than ordered/expected (Supplier Issue) - In Selling Units."
    sql: ${TABLE}.si_underdeliveries ;;
    hidden: yes
  }

###############################################################
####################### Buckets Measures ######################
###############################################################

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: sum_of_md_hub_status_quantities {
    label: "# Units in MD - Hub Status Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to Hub status issues (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_hub_status ;;
  }

  measure: sum_of_md_incorrect_ean_hei_wrong_scanning {
    label: "# Units in MD/HE - Incorrect EAN/Wrong Scanning Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to either wrong EANs codes or wrong scanning at the hub (Master Data / Human error issue) - In Selling Units."
    sql: ${TABLE}.md_incorrect_ean_hei_wrong_scanning ;;
  }

  measure: sum_of_md_incorrect_pack_factor {
    label: "# Units in MD - Incorrect Pack Factor Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong quantity per handling units issue(Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_incorrect_pack_factor ;;
  }

  measure: sum_of_md_introduction_date_issue {
    label: "# Units in MD - Incorrect Introduction Date Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong ERP item-location introduction date (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_introduction_date_issue ;;
  }

  measure: sum_of_md_lead_time_issue {
    label: "# Units in MD - Incorrect Lead Time Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong lead times definition between PO and Inbounds (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_lead_time_issue ;;
  }

  measure: sum_of_md_missing_ean_hu {
    label: "# Units in MD - Missing EAN HU Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to missing EAN Handling Unit (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_missing_ean_hu ;;
  }

  measure: sum_of_md_purchase_order_issue {
    label: "# Units in MD/SI - Purchase Order Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong purchase order attributes that causes mismatches issues (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_purchase_order_issue ;;
  }

  measure: sum_of_md_similar_ean_and_ean_hu {
    label: "# Units in MD - Similar EAN & EAN HU Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to similar EAN and EAN handling unit issue (Master Data Issue) - In Selling Units."
    sql: ${TABLE}.md_similar_ean_and_ean_hu ;;
  }

  measure: sum_of_hei_inbound {
    label: "# Units in HE - Incorrect Inbound Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong inbounds caused by Ops associates at the hub (Human Error Issue) - In Selling Units."
    sql: ${TABLE}.hei_inbound ;;
  }

  measure: sum_of_si_overdeliveries {
    label: "# Units in SI - Overdeliveries Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering more than ordered/expected (Supplier Issue) - In Selling Units."
    sql: ${TABLE}.si_overdeliveries ;;
  }

  measure: sum_of_si_underdeliveries {
    label: "# Units in SI - Underdeliveries Bucket"
    group_label: "WIMS Buckets"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering less than ordered/expected (Supplier Issue) - In Selling Units."
    sql: ${TABLE}.si_underdeliveries ;;
  }

  measure: sum_of_total_wims_buckets_quantities {
    label: "# WIMS Buckets Quantity"
    group_label: "WIMS Buckets"
    type: sum
    description: "This field shows the total quantities that fall into the different buckets."
    sql: ${TABLE}.wims_buckets_quantities ;;
  }


  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
