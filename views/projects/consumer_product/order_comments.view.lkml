include: "/views/bigquery_tables/curated_layer/orders.view.lkml"

view: order_comments {
  extends: [orders]

  dimension: is_customer_note_null {
    type: yesno
    sql: ${customer_note} IS NULL ;;
  }

  measure: cnt_customer_notes_null {
    type: count
    filters: [customer_note: "NULL,'',' '"] #"NOT NULL" doesn't give the intended result
  }

  measure: cnt_unique_order_locations {
    type: count_distinct
    sql: ${customer_location::latitude} || '-' || ${customer_location::longitude};;
  }

  ## these dimensions are automatically generated from orders dimensions and will trigger errors if not defined
  dimension: hubs.latitude {
    hidden: yes
  }

  dimension: hubs.longitude {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.rider_utr {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.picker_utr {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.picker_hours {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.rider_hours {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.pickers {
    hidden: yes
  }

  dimension: shyftplan_riders_pickers_hours.riders {
    hidden: yes
  }
}
