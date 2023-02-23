include: "/supply_chain/views/bigquery_curated/supplier_deliveries_received_at_hub.view"

# Owner: Andreas Stueber
# Created At: 2023-02-23
# Purpoae: Give the Hub-Tech team an overview over the events they create

explore: supplier_deliveries_received_at_hub {

  label: "Supplier Deliveries Received @Hub events"
  description: "This Explore provides information on the events, that track incoming supplier deliveries at our hubs. The related events are generated through the hub-staff and the HubOne app - the service was buidl by the Hub-Tech team."
  group_label: "Supply Chain"

  view_label: "Supplier Deliveries Received @Hub events"
  hidden: yes

  # ensure country-level protection of data
  access_filter: {
    field: supplier_deliveries_received_at_hub.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      supplier_deliveries_received_at_hub.delivery_timestamp_date: "last 7 days",
    ]
  }

  join: supplier_deliveries_received_at_hub__delivered_product_categories {
    view_label: "Supplier Deliveries Received @Hub events"
    # this is the auto-generated JOIN proposed by the Looker engine to handle nested records
    sql: LEFT JOIN UNNEST(${supplier_deliveries_received_at_hub.delivered_product_categories}) as supplier_deliveries_received_at_hub__delivered_product_categories ;;
    relationship: one_to_many
  }
}
