view: shyftplan_riders_pickers_hours {
  derived_table: {
    sql:
    with all_data as
    (
        select
        date(shift.starts_at, 'Europe/Berlin') as date,
        location.name as hub_name,
        lower(position.name) as position_name,
        sum(evaluation_duration / 60) as hours,
        count(distinct employment_id) as cnt_employees
        from `flink-data-dev.shyftplan.evaluations` evaluations
        where
        date(shift.starts_at, 'Europe/Berlin') < current_date() and
        (lower(position.name) like '%rider%' or lower(position.name) like '%picker%')
        group by 1, 2, 3
        order by 1 desc, 2, 3
    ),

    orders_per_hub as
    (
        select date(created, 'Europe/Berlin') as date,
        CASE WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') IN ('hamburg-oellkersallee', 'hamburg-oelkersallee') THEN 'de_ham_alto'
              WHEN JSON_EXTRACT_SCALAR(metadata, '$.warehouse') = 'münchen-leopoldstraße' THEN 'de_muc_schw'
              ELSE JSON_EXTRACT_SCALAR(metadata, '$.warehouse') end as warehouse,
              count(distinct orders.id) as orders
        from `flink-backend.saleor_db_global.order_order` orders
        where orders.status in ('fulfilled', 'partially fulfilled') and
              orders.user_email NOT LIKE '%goflink%' AND orders.user_email NOT LIKE '%pickery%' AND LOWER(orders.user_email) NOT IN ('christoph.a.cordes@gmail.com', 'jfdames@gmail.com', 'oliver.merkel@gmail.com', 'alenaschneck@gmx.de', 'saadsaeed354@gmail.com', 'saadsaeed353@gmail.com', 'fabian.hardenberg@gmail.com', 'benjamin.zagel@gmail.com')
        group by 1, 2
    ),

    rider_hours as
    (
        select date, hub_name, hours as rider_hours, cnt_employees as riders
        from all_data
        where position_name = 'rider'
    ),

    picker_hours as
    (
        select date, hub_name, hours as picker_hours, cnt_employees as pickers
        from all_data
        where position_name = 'picker'
    )

    select distinct all_data.date,
    all_data.hub_name,
    orders_per_hub.orders,
    case when rider_hours.rider_hours > 0 then orders_per_hub.orders else 0 end as adjusted_orders_riders,
    case when picker_hours.picker_hours > 0 then orders_per_hub.orders else 0 end as adjusted_orders_pickers,
    rider_hours.rider_hours,
    rider_hours.riders,
    picker_hours.picker_hours,
    picker_hours.pickers
    from all_data
    left join rider_hours
    on all_data.date = rider_hours.date and all_data.hub_name  = rider_hours.hub_name
    left join picker_hours
    on all_data.date = picker_hours.date and all_data.hub_name  = picker_hours.hub_name
    left join orders_per_hub
    on lower(all_data.hub_name) = orders_per_hub.warehouse and all_data.date=orders_per_hub.date
    order by 1 desc, 2
       ;;
  }

  dimension: id {
    type: string
    sql: concat(${TABLE}.date, ${TABLE}.hub_name) ;;
    primary_key: yes
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  #dimension: rider_hours {
  #  type: number
  #  sql: ${TABLE}.rider_hours ;;
  #}

  #dimension: riders {
  #  type: number
  #  sql: ${TABLE}.riders ;;
  #}

  #dimension: picker_hours {
  #  type: number
  #  sql: ${TABLE}.picker_hours ;;
  #}

  #dimension: pickers {
  #  type: number
  #  sql: ${TABLE}.pickers ;;
  #}

  ######## Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: rider_hours {
    type: sum
    sql: ${TABLE}.rider_hours ;;
  }

  measure: riders {
    type: sum
    sql: ${TABLE}.riders ;;
  }

  measure: picker_hours {
    type: sum
    sql: ${TABLE}.picker_hours ;;
  }

  measure: pickers {
    type: sum
    sql: ${TABLE}.pickers ;;
  }

  measure: shift_orders {
    type: sum
    sql: ${TABLE}.orders ;;
  }

  measure: adjusted_orders_riders {
    type: sum
    sql: ${TABLE}.adjusted_orders_riders ;;
  }

  measure: adjusted_orders_pickers {
    type: sum
    sql: ${TABLE}.adjusted_orders_pickers ;;
  }

  measure: rider_utr {
    label: "Rider UTR"
    type: number
    sql: ${adjusted_orders_riders} / NULLIF(${rider_hours}, 0);;
  }

  measure: picker_utr {
    label: "Picker UTR"
    type: number
    sql: ${adjusted_orders_pickers} / NULLIF(${picker_hours}, 0);;
  }

  set: detail {
    fields: [
      date,
      hub_name
    ]
  }
}
