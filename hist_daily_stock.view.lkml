view: hist_daily_stock {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql:
    SELECT
      capture_date,
      warehouse_id,
      substitute_group,
      noos_group,
      slug,
      quantity_per_substitute_group

      FROM `flink-backend.saleor_db_hist.warehouse_stock_with_attributes`
      where noos_group = 'TRUE'

      group by 1,2,3,4,5,6
      order by 1,2,3
       ;;
  }

  dimension: capture_date {
    type: date
    datatype: date
    sql: ${TABLE}.capture_date ;;
  }

  dimension: warehouse_id {
    type: string
    sql: ${TABLE}.warehouse_id ;;
  }

  dimension: substitute_group {
    type: string
    sql: ${TABLE}.substitute_group ;;
  }

  dimension: noos_group {
    type: string
    sql: ${TABLE}.noos_group ;;
  }

  dimension: slug {
    type: string
    sql: CASE WHEN ${TABLE}.slug = 'hamburg-oellkersallee' THEN 'de_ham_alto'
              WHEN ${TABLE}.slug = 'münchen-leopoldstraße' THEN 'de_muc_schw'
              ELSE ${TABLE}.slug END;;
  }

  dimension: quantity_per_substitute_group {
    type: number
    sql: ${TABLE}.quantity_per_substitute_group ;;
  }

####### Measures ########


  measure: count {
    type: count
  }

  measure: cnt_noos_group_out_of_stock {
    type: count
    label: "# Substitute Groups with 0 Inventory"
    filters: [quantity_per_substitute_group: "0"]
  }

  measure: sum_quantity_per_noos_group {
    type: sum
    label: "# Total Inventory within Substitute Group"
    description: "Sum of Inventory of SKUs within Substitute Group"
    sql: ${quantity_per_substitute_group} ;;
    value_format: "0"
  }

  measure: pct_noos_out_of_stock{
    label: "% NooS Group out of Stock"
    description: "Share of NooS Groups which were out of stock (EOD)"
    hidden:  no
    type: number
    sql: ${cnt_noos_group_out_of_stock} / NULLIF(${count}, 0);;
    value_format: "0%"
  }

}
