include: "/competitive_intelligence/views/**/*.view.lkml"

explore: gorillas_hubs_hist {
  view_name: gorillas_hubs_hist
  label: "Gorillas Hubs Hist"
  view_label: "Gorillas Hubs Hist"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Gorillas Hubs Historical Data"
  always_filter: {
    filters: [gorillas_hubs_hist.time_scraped_time: "yesterday"]
  }
}
