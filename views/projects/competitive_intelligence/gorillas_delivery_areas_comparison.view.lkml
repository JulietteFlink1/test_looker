# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: gorillas_delivery_areas_comparison {
  derived_table: {
    explore_source: gorillas_v1_delivery_areas {
      column: time_scraped_date {}
      column: country {}
      column: city {}
      column: count {}
      filters: {
        field: gorillas_v1_delivery_areas.time_scraped_date
        value: "today"
      }
    }
  }

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: concat(${time_scraped_date}, ${country},${count}) ;;
  }

  dimension: time_scraped_date {
    label: "Gorillas Delivery Areas Time Scraped Date"
    description: "bq-datetime"
    type: date
  }
  dimension: country {
    label: "Gorillas Delivery Areas Country"
  }
  dimension: city {
    label: "Gorillas Delivery Areas City"
  }
  dimension: count {
    label: "Gorillas Delivery Areas Count"
    type: number
  }

  dimension: city_mapping {
    case: {
      when: {
        sql: ${TABLE}.city = "Cologne";;
        label: "Köln"
        }
      when: {
        sql: ${TABLE}.city = "Frankfurt am Main";;
        label: "Frankfurt"
      }
      when: {
        sql: ${TABLE}.city = "Nürnberg";;
        label: "Nuremberg"
      }
      when: {
        sql: ${TABLE}.city = "Offenbach am Main";;
        label: "Offenbach"
      }

        else: ""
        }
  }

  dimension: city_cleaned {
    label: "City Cleaned"
    sql: if(${city_mapping} = "", ${city}, ${city_mapping}) ;;
  }
}
