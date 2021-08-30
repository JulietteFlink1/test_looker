include: "/views/bigquery_tables/curated_layer/orders.view.lkml"

view: order_comments {
  extends: [orders]

  dimension: has_customer_note {
    type: yesno
    sql: NOT(${customer_note} IS NULL OR ${customer_note}="" OR ${customer_note}=" ");;
  }

  measure: cnt_has_customer_notes {
    type: count
    filters: [has_customer_note: "yes"]
  }

  measure: cnt_unique_location_has_customer_notes {
    type: count_distinct
    sql: ${customer_location::latitude} || '-' || ${customer_location::longitude};;
    filters: [has_customer_note: "yes"]
  }

  measure: cnt_unique_location_no_customer_notes {
    type: count_distinct
    sql: ${customer_location::latitude} || '-' || ${customer_location::longitude};;
    filters: [has_customer_note: "no"]
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
