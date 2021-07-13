view: account_user {
  sql_table_name: `flink-backend.saleor_db_global.account_user`
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
    hidden: yes
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: avatar {
    type: string
    hidden: yes
    sql: ${TABLE}.avatar ;;
  }

  dimension_group: date_joined {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.date_joined ;;
  }

  dimension: default_billing_address_id {
    type: number
    hidden: yes
    sql: ${TABLE}.default_billing_address_id ;;
  }

  dimension: default_shipping_address_id {
    type: number
    hidden: yes
    sql: ${TABLE}.default_shipping_address_id ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: is_active {
    type: yesno
    hidden: yes
    sql: ${TABLE}.is_active ;;
  }

  dimension: is_staff {
    type: yesno
    hidden: yes
    sql: ${TABLE}.is_staff ;;
  }

  dimension: is_superuser {
    type: yesno
    hidden: yes
    sql: ${TABLE}.is_superuser ;;
  }

  dimension: jwt_token_key {
    type: string
    hidden: yes
    sql: ${TABLE}.jwt_token_key ;;
  }

  dimension_group: last_login {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_login ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.metadata ;;
  }

  dimension: note {
    type: string
    hidden: yes
    sql: ${TABLE}.note ;;
  }

  dimension: password {
    type: string
    hidden: yes
    sql: ${TABLE}.password ;;
  }

  dimension: private_metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.private_metadata ;;
  }

}
