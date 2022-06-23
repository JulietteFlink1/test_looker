include: "/views/projects/consumer_product/ab_test_experiments.view.lkml"

explore: ab_test_experiments {
  hidden: yes
  view_name:  ab_test_experiments
  label: "A/B test experiments"
  view_label: "A/B test experiments"
  group_label: "Consumer Product"
  description: "A/B test experiments - mulitple tests"
}
