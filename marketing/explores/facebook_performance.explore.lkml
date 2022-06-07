include: "/marketing/views/sql_derived_tables/facebook_campaigns_performance.view.lkml"

explore: facebook_campaigns_performance {
  hidden: yes
  view_name: facebook_campaigns_performance
  label: "Facebook Ads Performance"
  view_label: "Facebook Ads Performance"
  group_label: "11) Marketing"
  description: "Performance of Facebook Ads: CPI, CPC, CTR, ROI"
}
