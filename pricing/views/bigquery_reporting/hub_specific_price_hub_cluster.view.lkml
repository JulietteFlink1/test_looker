view: geographic_pricing_hub_cluster {
  sql_table_name: `flink-data-prod.google_sheets.geographic_pricing_hub_cluster`;;



  dimension: price_hub_cluster {
    type: string
    sql: ${TABLE}.price_hub_cluster ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  parameter: hub_granularity {
    type: unquoted
    allowed_value: { value: "price_hub_cluster" }
    allowed_value: { value: "hub_code" }
    allowed_value: {  label: "No granularity"
      value: "" }
    default_value: ""
  }

  dimension: hub_dimension {
    sql:
    {% if hub_granularity._parameter_value == 'price_hub_cluster' %}
      ${price_hub_cluster}
    {% elsif hub_granularity._parameter_value == 'hub_code' %}
      ${hub_code}
    {% else %}
      ""
    {% endif %};;
  }

}
