#Owner: Lauti Ruiz
#Main Stakeholder: Supply Chain Team
#Main use case: It assigns different reasons to Underdeliveries/Overdeliveries.

view: advanced_supplier_matching_wims_definition {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-prod.reporting.advanced_supplier_matching_wims_definition`
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

  dimension: country_iso {
    label: "Country ISO"
    group_label: "WIMS Buckets"
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
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

  dimension: supplier_location_id {
    label: "Supplier Location ID"
    group_label: "WIMS Buckets"
    type: string
    description: "Site ID of the supplier/vendor of a product."
    sql: ${TABLE}.supplier_location_id ;;
    hidden: yes
  }

  dimension: number_of_items_inbounded {
    label: "Total Quantity Inbounded"
    group_label: "WIMS Buckets"
    type: number
    description: "Total amount of items inbounded during the inbounding process."
    sql: ${TABLE}.number_of_items_inbounded ;;
    hidden: yes
  }

  dimension: number_of_items_ordered_or_delivered_combined {
    label: "Total Quantity Ordered/Delivered (PO - DESADVs)"
    group_label: "WIMS Buckets"
    type: number
    description: "Number of selling units of a product that have been delivered/ordered"
    sql: ${TABLE}.number_of_items_ordered_or_delivered_combined ;;
    hidden: yes
  }

  dimension: wims_buckets_clasification {
    label: "WIMS Buckets Clasification"
    type: string
    description: "This field classifies data points into distinct buckets based on various conditions and its prioritization."
    sql: ${TABLE}.wims_buckets_clasification ;;
  }

  dimension: number_of_items_in_wims_buckets {
    label: "WIMS Buckets Quantity"
    group_label: "WIMS Buckets"
    type: number
    description: "This field shows the total quantities that fall into the different buckets."
    sql: ${TABLE}.number_of_items_in_wims_buckets ;;
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

  dimension: number_of_items_in_hub_status_issue_bucket {
    label: "MD - Hub Status"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to hub status issues (Master Data Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_hub_status_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_incorrect_ean_hei_wrong_scanning_issue_bucket {
    label: "MD/HE - Incorrect EAN/Wrong Scanning"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to either wrong EANs codes or wrong scanning at the hub (Master Data / Human Error Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_incorrect_ean_hei_wrong_scanning_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_incorrect_pack_factor_issue_bucket {
    label: "MD - Incorrect Pack Factor"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong quantity per handling units issue(Master Data Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_incorrect_pack_factor_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_introduction_date_issue_bucket {
    label: "MD - Incorrect Introduction Date"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong ERP item-location introduction date (Master Data Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_introduction_date_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_lead_time_issue_bucket {
    label: "MD - Incorrect Lead Time"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong lead times definition between purchase orders and inbounds (Master Data Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_lead_time_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_missing_ean_hu_issue_bucket {
    label: "MD - Missing EAN HU"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to missing EAN handling unit (Master Data Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_missing_ean_hu_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_purchase_order_issue_bucket {
    label: "MD/SI - Purchase Order"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong purchase order attributes that causes mismatches issues (Master Data Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_purchase_order_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_similar_ean_and_ean_hu_issue_bucket {
    label: "MD - Similar EAN & EAN HU"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to similar EAN and EAN handling unit issue (Master Data Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_similar_ean_and_ean_hu_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_inbounding_issue_bucket {
    label: "HE - Incorrect Inbound"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to wrong inbounds caused by ops associates at the hub (Human Error Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_inbounding_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_overdeliveries_issue_bucket {
    label: "SI - Overdeliveries"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering more than ordered/expected (Supplier Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_overdeliveries_issue_bucket ;;
    hidden: yes
  }

  dimension: number_of_items_in_underdeliveries_issue_bucket {
    label: "SI - Underdeliveries"
    group_label: "WIMS Buckets"
    type: number
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering less than ordered/expected (Supplier Issue) - in selling units."
    sql: ${TABLE}.number_of_items_in_underdeliveries_issue_bucket ;;
    hidden: yes
  }

###############################################################
####################### Buckets Measures ######################
###############################################################

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: sum_of_items_in_hub_status_issue_bucket {
    label: "# Items in Hub Status Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to hub status issues (Master Data Issue) - in selling units."
    sql: ${number_of_items_in_hub_status_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_incorrect_ean_hei_wrong_scanning_issue_bucket {
    label: "# Items in Incorrect EAN/Wrong Scanning Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to either wrong EANs codes or wrong scanning at the hub (Master Data / Human Error Issue) - in selling units."
    sql: ${number_of_items_in_incorrect_ean_hei_wrong_scanning_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_incorrect_pack_factor_issue_bucket {
    label: "# Items in Incorrect Pack Factor Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong quantity per handling units issue(Master Data Issue) - in selling units."
    sql: ${number_of_items_in_incorrect_pack_factor_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_introduction_date_issue_bucket {
    label: "# Items in Incorrect Introduction Date Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong ERP item-location introduction date (Master Data Issue) - in selling units."
    sql: ${number_of_items_in_introduction_date_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_lead_time_issue_bucket {
    label: "# Items in Incorrect Lead Time Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong lead times definition between purchase orders and inbounds (Master Data Issue) - in selling units."
    sql: ${number_of_items_in_lead_time_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_missing_ean_hu_issue_bucket {
    label: "# Items in Missing EAN HU Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to missing EAN handling unit (Master Data Issue) - in selling units."
    sql: ${number_of_items_in_missing_ean_hu_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_purchase_order_issue_bucket {
    label: "# Items in Purchase Order Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong purchase order attributes that causes mismatches issues (Master Data Issue) - in selling units."
    sql: ${number_of_items_in_purchase_order_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_similar_ean_and_ean_hu_issue_bucket {
    label: "# Items in Similar EAN & EAN HU Bucket"
    group_label: "Master Data Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to similar EAN and EAN handling unit issue (Master Data Issue) - in selling units."
    sql: ${number_of_items_in_similar_ean_and_ean_hu_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_inbounding_issue_bucket {
    label: "# Items in Incorrect Inbound Bucket"
    group_label: "Human Error Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to wrong inbounds caused by ops associates at the hub (Human Error Issue) - in selling units."
    sql: ${number_of_items_in_inbounding_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_overdeliveries_issue_bucket {
    label: "# Items in Overdeliveries Bucket"
    group_label: "Supplier Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering more than ordered/expected (Supplier Issue) - in selling units."
    sql: ${number_of_items_in_overdeliveries_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_underdeliveries_issue_bucket {
    label: "# Items in Underdeliveries Bucket"
    group_label: "Supplier Issues"
    type: sum
    description: "Bucket that shows possible over/under deliveries due to suppliers delivering less than ordered/expected (Supplier Issue) - in selling units."
    sql: ${number_of_items_in_underdeliveries_issue_bucket} ;;
    value_format_name: decimal_1
  }

  measure: sum_of_items_in_wims_buckets {
    label: "# Items in WIMS Buckets"
    type: sum
    description: "This field shows the total quantities that fall into the different buckets."
    sql: ${number_of_items_in_wims_buckets} ;;
    value_format_name: decimal_1
  }


  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
