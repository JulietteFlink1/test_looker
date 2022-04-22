view: affected_by_impression_users {
    derived_table: {
      explore_source: daily_events {
        column: event_date {}
        column: anonymous_id {}
        filters: {
          field: daily_events.event_name
          value: "\"product_impression\""
        }
      }
    }
    dimension: event_date {
      label: "Event Date"
      hidden: yes
      description: "Timestamp of when an event happened"
      type: date
    }
    dimension: anonymous_id {
      label: "Anonymous ID"
      hidden: yes
      description: "User ID set by Segment"
    }
  }
