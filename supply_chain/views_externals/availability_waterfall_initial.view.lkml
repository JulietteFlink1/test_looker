  explore: availability_waterfall {
    hidden: yes
  }

  view: availability_waterfall {
    view_label: "*Availability Waterfall Output*"
    sql_table_name: `flink-supplychain-prod.curated.availability_waterfall`
      ;;
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # =========  __main__   =========
    dimension: country_iso {
      type: string
      sql: ${TABLE}.country_iso ;;
    }
    dimension: hub_code {
      type: string
      sql: ${TABLE}.hub_code ;;
    }
    dimension: category_master {
      type: string
      sql: ${TABLE}.hub_code ;;
    }
    dimension: sku {
      type: string
      sql: cast(${TABLE}.sku as string) ;;
    }
    dimension: ingestion_date {
      type: date
      datatype: date
      sql: ${TABLE}.ingestion_date ;;
    }
    dimension: supplier_id {
      type: string
      sql: ${TABLE}.supplier_id ;;
    }
    dimension: oos_hours {
      type: number
      sql: ${TABLE}.oos_hours ;;
    }
    dimension: opening_hours {
      type: number
      sql: ${TABLE}.opening_hours ;;
    }
    dimension: promotion_filter {
      type: string
      sql: ${TABLE}.promotion_filter ;;
    }
    dimension: newly_reactivated_flag {
      type: number
      sql: ${TABLE}.newly_reactivated_flag ;;
    }

    dimension: bucket {
      type: string
      sql: ${TABLE}.bucket ;;
    }
    dimension: parent_bucket {
      type: string
      sql: ${TABLE}.parent_bucket ;;
    }
    dimension: report_week {
      type: date
      datatype: date
      sql: ${TABLE}.report_week ;;
    }
  }
