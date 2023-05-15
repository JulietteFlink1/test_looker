# Owner: Lautaro Ruiz
# Description: It shows all those sku that are or going to be included in promotions.
# Team: Supply Chain and Commercial

# The name of this view in Looker is "SKU Promotions Airtable"
view: sku_promotions_airtable {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-dev.dbt_lruiz_reporting.sku_promotions_airtable`
    ;;

set: all_dim {
  fields: [all_dim*]
}

  dimension: table_uuid {
    label: "Table UUID"
    group_label: "Promotions Data"
    type: string
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

####################################################
############### Date Dimensions ####################
####################################################

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: airtable_created_at_timestamp {
    label: "Created at timestamp"
    group_label: "Promotions Data"
    type: time
    description: "The creation date and time of a record"
    timeframes: [
      date
    ]
    sql: ${TABLE}.airtable_created_at_timestamp ;;
    hidden: yes
  }

  dimension_group: airtable_last_modified_timestamp {
    label: "Last modified timestamp"
    group_label: "Promotions Data"
    type: time
    description: "Timestamp generated by the backend representing when some record/row in the raw data was updated the last time."
    timeframes: [
      date
    ]
    sql: ${TABLE}.airtable_last_modified_timestamp ;;
    hidden: yes
  }

  dimension_group: promotion_end {
    label: "Promotion Ends"
    group_label: "Promotions Data"
    type: time
    description: "Date when the promotion ends."
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.promotion_end_date ;;
  }

  dimension_group: promotion_start {
    label: "Promotion Starts"
    group_label: "Promotions Data"
    type: time
    description: "Date when the promotion starts."
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.promotion_start_date ;;
  }

####################################################
############ Geographic Dimensions #################
####################################################

  dimension: country_iso {
    label: "Country ISO (Promotion Applied)"
    group_label: "Promotions Data"
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: country_promotion_applied {
    label: "Country (Promotion Applied)"
    group_label: "Promotions Data"
    type: string
    description: "Country where the promotion is applied."
    sql: ${TABLE}.country_promotion_applied ;;
    hidden: yes
  }

  dimension: hub_code {
    label: "Hub Code (Promotion Applied)"
    group_label: "Promotions Data"
    type: string
    description: "Hub where the promotions is applied."
    sql: ${TABLE}.hub_code ;;
  }

####################################################
#################### Booleans ######################
####################################################

  dimension: is_promotion_nationally_applied {
    label: "Is Promotion nationally applied"
    group_label: "Promotions Data"
    type: yesno
    description: "True if the promotions is applied national wide."
    sql: ${TABLE}.is_promotion_nationally_applied ;;
  }

  dimension: is_promotional_sku {
    label: "Is Promotional SKU"
    group_label: "Promotions Data"
    type: yesno
    description: "True if an SKU/Hub combination is on promotion or not."
    sql: ${TABLE}.is_promotional_sku ;;
  }

####################################################
############ General Dimensions ####################
####################################################

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Airtable Last Modified Timestamp" in Explore.

  dimension: campaign_name {
    label: "Campaign Name"
    group_label: "Promotions Data"
    type: string
    description: "Name of the ongoing promotion according to the data provided in Airtable."
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_category {
    label: "Campaign Category"
    group_label: "Promotions Data"
    type: string
    description: "Shows where the promotion is displayed."
    sql: ${TABLE}.campaign_category ;;
  }

  dimension: campaign_class {
    label: "Campaign Class"
    group_label: "Promotions Data"
    type: string
    description: "Class of the discount applied in the promotion. It refers to what kind of discount is applied."
    sql: ${TABLE}.campaign_class ;;
  }

  dimension: campaign_type {
    label: "Campaign Type"
    group_label: "Promotions Data"
    type: string
    description: "Shows where the promotion is going to be marketed."
    sql: ${TABLE}.campaign_type ;;
  }

  dimension: discount_subtype {
    label: "Discount Subtype"
    group_label: "Promotions Data"
    type: string
    description: "Subtype discount value (e.g. range 1%-10%)."
    sql: ${TABLE}.discount_subtype ;;
  }

  dimension: discount_value {
    label: "Discount Value"
    group_label: "Promotions Data"
    type: string
    description: "Value of the discount applied."
    sql: ${TABLE}.discount_value ;;
  }

  dimension: expected_uplift {
    label: "Expected Uplift"
    group_label: "Promotions Data"
    type: string
    description: "Uplift, defined as the increase in sales, expected due to a promotion."
    sql: ${TABLE}.expected_uplift ;;
  }

  dimension: item_name {
    label: "Item Name"
    group_label: "Promotions Data"
    type: string
    description: "Name of the product, as specified in the backend."
    sql: ${TABLE}.item_name ;;
  }

  dimension: promotion_status {
    label: "Promotion Status"
    group_label: "Promotions Data"
    type: string
    description: "Status of the promotion."
    sql: ${TABLE}.promotion_status ;;
  }

  dimension: sku {
    label: "SKU"
    group_label: "Promotions Data"
    type: string
    description: "SKU of the product, as available in the backend."
    sql: ${TABLE}.sku ;;
  }

  dimension: parent_sku {
    label: "Parent SKU"
    group_label: "Promotions Data"
    type: string
    description: "Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    sql: ${TABLE}.parent_sku ;;
  }

####################################################
#################### Measures ######################
####################################################

  measure: count {
    type: count
    drill_fields: [item_name]
    hidden: yes
  }
}
