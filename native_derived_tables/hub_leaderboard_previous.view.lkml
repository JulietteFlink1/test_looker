view: hub_leaderboard_previous {
  derived_table: {
    explore_source: hub_leaderboard {
      column: score_hub_leaderboard {}
      column: hub_code_lowercase {}
      filters: {
        field: hub_leaderboard.is_previous_7d
        value: "Yes"
      }
    }

  }
  measure: score_hub_leaderboard {
    label: "Hub Leaderboard Score (Previous Period)"
    value_format: "#,##0"
    type: max
  }

  dimension: hub_code_lowercase {}
}
