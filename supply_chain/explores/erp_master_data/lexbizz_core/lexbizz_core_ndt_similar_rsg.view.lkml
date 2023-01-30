# If necessary, uncomment the line below to include explore_source.
# include: "lexbizz_core.explore.lkml"

view: lexbizz_core_ndt_similar_rsg {
  derived_table: {
    explore_source: lexbizz_core {
      column: similar_rsg { field: stock_item.similar_rsg }
      column: cnt_skus { field: stock_item.cnt_skus }
      filters: {
        field: stock_item.ingestion_date
        value: "today"
      }
      filters: {
        field: stock_item.sku
        value: "9%"
      }
    }
  }
  dimension: similar_rsg {}
  dimension: cnt_skus {
    label: "Stock Item # unique SKUs"
    type: number
  }
}
