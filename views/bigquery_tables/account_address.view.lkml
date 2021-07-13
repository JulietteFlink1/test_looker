view: account_address {
  sql_table_name: `flink-backend.saleor_db_global.account_address`
    ;;
  drill_fields: [id]
  view_label: "* Customer Address *"

  dimension: id {
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_area {
    type: string
    hidden: yes
    sql: ${TABLE}.city_area ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: country {
    type: string
    hidden: yes
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: country_area {
    type: string
    hidden: yes
    sql: ${TABLE}.country_area ;;
  }

  dimension: first_name {
    type: string
    sql: INITCAP(${TABLE}.first_name) ;;
  }

  dimension: last_name {
    type: string
    sql: INITCAP(${TABLE}.last_name) ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: street_address_1 {
    type: string
    sql: ${TABLE}.street_address_1 ;;
  }

  dimension: street_address_2 {
    type: string
    sql: ${TABLE}.street_address_2 ;;
  }

}
