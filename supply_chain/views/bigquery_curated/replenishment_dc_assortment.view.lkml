view: replenishment_dc_assortment {
  sql_table_name: `flink-data-prod.curated.replenishment_dc_assortment`
    ;;



# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~   Date Dimensions   ~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension_group: last_assortment {
    group_label: "* Date Dimensions *"
    type: time
    timeframes: [
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.last_assortment_date ;;
  }

  dimension_group: last_assortment_timestamp {
    type: time
    group_label: "* Date Dimensions *"
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
    sql: ${TABLE}.last_assortment_timestamp ;;
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~  SKU Dimensions   ~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: table_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
    primary_key: yes
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: sku_name {
    hidden: yes
    type: string
    sql: ${TABLE}.sku_name ;;
  }

  dimension: stock_type {
    type: string
    sql: ${TABLE}.stock_type ;;
  }


  dimension: gln {
    hidden: yes
    type: string
    sql: ${TABLE}.gln ;;
  }

  dimension: line_type {
    hidden: yes
    type: string
    sql: ${TABLE}.line_type ;;
  }

  dimension: organic {
    type: string
    sql: ${TABLE}.organic ;;
  }

  dimension: pick_order {
    hidden: yes
    type: number
    sql: ${TABLE}.pick_order ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~ Hidden  Dimensions   ~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# We can easily include them at anytime


  dimension: gtin_hu {
    hidden: yes
    type: string
    sql: ${TABLE}.gtin_hu ;;
  }

  dimension: gtin_pu {
    hidden: yes
    type: string
    sql: ${TABLE}.gtin_pu ;;
  }

  dimension: hu_height {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_height ;;
  }

  dimension: hu_layer {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_layer ;;
  }

  dimension: hu_length {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_length ;;
  }

  dimension: hu_palette {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_palette ;;
  }

  dimension: hu_type {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_type ;;
  }

  dimension: hu_weight_gross {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_weight_gross ;;
  }

  dimension: hu_weight_net {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_weight_net ;;
  }

  dimension: hu_weight_unit {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_weight_unit ;;
  }

  dimension: hu_width {
    hidden: yes
    type: string
    sql: ${TABLE}.hu_width ;;
  }


  dimension: palette_height {
    hidden: yes
    type: string
    sql: ${TABLE}.palette_height ;;
  }

  dimension: palette_type {
    hidden: yes
    type: string
    sql: ${TABLE}.palette_type ;;
  }


  dimension: pu_per_hu {
    label: "Units per Handling Unit"
    hidden: no
    type: string
    sql: ${TABLE}.pu_per_hu ;;
  }

  dimension: pu_type {
    hidden: yes
    type: string
    sql: ${TABLE}.pu_type ;;
  }

  dimension: shelf_life {
    hidden: yes
    type: string
    sql: ${TABLE}.shelf_life ;;
  }

  dimension: alternative_shelf_life {
    hidden: yes
    type: string
    sql: ${TABLE}.alternative_shelf_life ;;
  }

  dimension: arvetm {
    hidden: yes
    type: number
    sql: ${TABLE}.arvetm ;;
  }

  dimension: arvetm_1 {
    hidden: yes
    type: number
    sql: ${TABLE}.arvetm_1 ;;
  }

  dimension: weigh_yes_no {
    hidden: yes
    type: string
    sql: ${TABLE}.weigh_yes_no ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~   Measures   ~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  measure: count {
    hidden: yes
    type: count
    drill_fields: [sku_name]
  }
}
