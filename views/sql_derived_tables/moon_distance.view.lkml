view: moon_distance {
  derived_table: {
    sql:
          with total_travel_dist as(
SELECT  country,
        count(distinct order_uuid) * avg(case when hub.longitude is not null then ST_Distance(ST_GeogPoint(hub.longitude, hub.latitude), ST_GeogPoint(customer_longitude, customer_latitude))/1000 end)*2 AS total_dist

FROM `flink-data-prod.curated.orders`  as orders
left join flink-data-prod.curated.hubs as hub on lower(orders.hub_code) = lower(hub.hub_code)
where is_successful_order = True and country is not null
group by 1
)
select  country,
        total_dist/384400 as times_taveled_to_moon,
        total_dist/5460000 as times_taveled_to_mars
from total_travel_dist
       ;;
  }

  dimension: country {
    type: string
    hidden: no
    sql: ${TABLE}.country ;;
    html:🚀 {{ rendered_value }} 🚀 ;;
  }

  measure: times_taveled_to_moon {
    type: sum
    label: "# Times Traveled to The Moon and Back"
    value_format: "0.0"
    sql: ${TABLE}.times_taveled_to_moon/2;;
    html: {{ rendered_value }} 🚲🚀🌑 ;;
  }

  measure: times_taveled_to_mars {
    type: sum
    label: "# Times Traveled to Mars and Back"
    value_format: "0.0"
    sql: ${TABLE}.times_taveled_to_mars/2;;
    html: {{ rendered_value }} 🚲🚀🌖 ;;
  }


}
