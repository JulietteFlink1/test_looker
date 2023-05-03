# Owner: Lautaro Ruiz
# Description: It shows all those sku that are or going to be included in promotions.
# Team: Supply Chain and Commercial

# The name of this view in Looker is "SKU Promotions Valid Dates Definition"
view: sku_promotions_valid_dates_definition {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `flink-data-dev.dbt_lruiz_curated.sku_promotions_valid_dates_new_definition`
    ;;

####################################################
############ General Dimensions ####################
####################################################

  dimension: table_uuid {
    label: "Table UUID"
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    group_label: "Promotions Data"
    type: string
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
    hidden: yes
  }

  dimension: country_iso {
    label: "Country ISO"
    description: "Country ISO based on 'hub_code'."
    group_label: "Promotions Data"
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: hub_code {
    label: "Hub Code"
    description: "Hub where the promotions is applied."
    group_label: "Promotions Data"
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: parent_sku {
    label: "Parent SKU"
    description: "Parent SKU of a product. This groups several child SKUs that belongs to the same replenishment substitute group."
    group_label: "Promotions Data"
    type: string
    sql: ${TABLE}.parent_sku ;;
    hidden: yes
  }

  dimension: is_promotional_sku {
    label: "Is Promotional SKU"
    description: "True if an SKU/Hub combination is on promotion or not."
    group_label: "Promotions Data"
    type: yesno
    sql: ${TABLE}.is_promotional_sku ;;
    hidden: no
  }

####################################################
############### Date Dimensions ####################
####################################################



  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: valid_from {
    label: "Promotion valid from"
    description: "Date when the promotion starts."
    group_label: "Promotions Data"
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_from_date ;;
  }

  dimension_group: valid_to {
    label: "Promotion valid to"
    description: "Date when the promotion ends."
    group_label: "Promotions Data"
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_to_date ;;
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
