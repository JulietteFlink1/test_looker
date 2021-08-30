view: customer_address {
  sql_table_name: `flink-data-prod.curated.customer_address`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
    hidden: no
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    hidden: no
  }

  dimension: street_name {
    type: string
    sql: ${TABLE}.street_name ;;
  }

  dimension: additional_street_info {
    type: string
    sql: ${TABLE}.additional_street_info ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: company {
    type: string
    sql: ${TABLE}.company ;;
  }


  # =========  hidden   =========
  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
    hidden: yes
  }


  # =========  IDs   =========
  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




}
