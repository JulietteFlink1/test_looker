view: warehouse_warehouse {
  sql_table_name: `flink-backend.saleor_db_global.warehouse_warehouse`
    ;;
  drill_fields: [id]
  view_label: "* Hubs *"

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
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: address_id {
    type: number
    hidden: yes
    sql: ${TABLE}.address_id ;;
  }

  dimension: company_name {
    type: string
    hidden: yes
    sql: ${TABLE}.company_name ;;
  }

  dimension: email {
    type: string
    hidden: yes
    sql: ${TABLE}.email ;;
  }

  dimension: name {
    type: string
    hidden: yes
    sql: ${TABLE}.name ;;
  }

  dimension: slug {
    type: string
    label: "Slug (Saleor hub code)"
    sql: CASE WHEN ${TABLE}.slug = 'hamburg-oellkersallee' THEN 'de_ham_alto'
              WHEN ${TABLE}.slug = 'münchen-leopoldstraße' THEN 'de_muc_schw'
              ELSE ${TABLE}.slug END
              ;;
  }

}
