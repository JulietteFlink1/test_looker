view: warehouse_warehouse {
  sql_table_name: `flink-backend.saleor_db_global.warehouse_warehouse`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: no
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: slug {
    type: string
    sql: CASE WHEN ${TABLE}.slug = 'hamburg-oellkersallee' THEN 'de_ham_alto'
              WHEN ${TABLE}.slug = 'münchen-leopoldstraße' THEN 'de_muc_schw'
              ELSE ${TABLE}.slug END
              ;;
  }

  measure: count {
    type: count
    drill_fields: [id, company_name, name]
  }
}
