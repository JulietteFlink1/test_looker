view: products_hub_assignment {
  sql_table_name: `flink-data-prod.curated.products_hub_assignment`
    ;;
  view_label: "* Product-Hub Assignment *"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: is_most_recent_record {
    description: "Indicates, that the hub-sku assigment shown is either the most recent assignment (Yes) or shows historical assignments of skus to hubs (No)"
    type: yesno
    sql: ${TABLE}.is_most_recent_record ;;
  }

  dimension: is_sku_assigned_to_hub {
    description: "Indicates, that a selected sku is assigned to a selected hub (both need to be visible in the visualisation).
    This flag shows not only the most recent sku-hub assignment, but also historical assignments. Please use either

    * Is Most Recent Record (Yes/No) or
    * Valid From and Valid To to determine, when the shown assignment is valid
    "
    type: yesno
    sql: ${TABLE}.is_sku_assigned_to_hub ;;
  }

  dimension: valid_from {
    type: date_time
    sql: ${TABLE}.valid_from ;;
  }

  dimension: valid_to {
    type: date_time
    sql: ${TABLE}.valid_to ;;
  }


  # =========  hidden   =========

  dimension: products_assignment_uuid {
    type: string
    sql: ${TABLE}.products_assignment_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: current_status_change_count {
    type: number
    sql: ${TABLE}.current_status_change_count ;;
    hidden: yes
  }

  dimension: max_status_change_count {
    type: number
    sql: ${TABLE}.max_status_change_count ;;
    hidden: yes
  }


}
