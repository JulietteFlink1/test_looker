view: hub_leaderboard_current {
  derived_table: {
    explore_source: hub_level_kpis {
      column: score_hub_leaderboard {}
      column: hub_code {}
      filters: {
        field: hub_level_kpis.is_current_7d
        value: "Yes"
      }
    }
  }
  measure: score_hub_leaderboard {
    label: "Hub Leaderboard Score (Current Period)"
    group_label: ">> YoY metrics"
    value_format: "#,##0"
    type: max
  }
  dimension: hub_code {}
}
