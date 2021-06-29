view: hub_leaderboard_current {
  derived_table: {
    explore_source: hub_leaderboard {
      column: score_hub_leaderboard {}
      column: hub_code_lowercase {}
      filters: {
        field: hub_leaderboard.is_current_7d
        value: "Yes"
      }
    }
  }
  measure: score_hub_leaderboard {
    label: "Hub Leaderboard Score (Current Period)"
    value_format: "#,##0"
    type: max
  }
  dimension: hub_code_lowercase {}
}
