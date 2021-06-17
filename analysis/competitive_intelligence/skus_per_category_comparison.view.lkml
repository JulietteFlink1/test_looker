view: skus_per_category_comparison {
  # If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"
    derived_table: {
      explore_source: product_product {
        column: country_iso { field: product_category.country_iso }
        column: parent_id { field: parent_category.id }
        column: parent_name { field: parent_category.name }
        column: id { field: product_category.id }
        column: name { field: product_category.name }
        column: cnt_sku_published {}
        column: warehouse_id { field: warehouse_stock.warehouse_id }
        filters: {
          field: product_product.is_published
          value: "yes"
        }
        filters: {
          field: order_orderline_facts.is_internal_order
          value: "no"
        }
        filters: {
          field: order_orderline_facts.is_successful_order
          value: "yes"
        }
      }
    }


    dimension: unique_id {
      group_label: "* IDs *"
      primary_key: yes
      type: string
      sql: concat(${country_iso}, ${parent_id},${id}) ;;
    }
    dimension: country_iso {
      label: "Country Iso"
    }
    dimension: parent_id {
      label: "Parent Category ID"
      type: number
    }
    dimension: parent_name {
      label: "Parent Category Name"
    }
    dimension: id {
      label: "Category ID"
      type: number
    }
    dimension: name {
      label: "Category Name"
    }
    dimension: warehouse_id {
    label: "Warehouse ID"
    }

    measure: cnt_sku_published {
      label: "* Product / SKU Data * # SKUs (Published)"
      type: count_distinct
      description: "Count of published SKUs in Assortment"
      value_format: "0"
    }

    # measure: avg_cnt_sku_per_warehouse {
    #   label: "AVG # of SKUs per Warehouse"
    #   type: average
    #   sql: ${cnt_sku_published} ;;
    #   sql_distinct_key: ${warehouse_id} ;;
    # }
  }
