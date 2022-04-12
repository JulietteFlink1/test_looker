include: "/**/test_funnel_recruitment.view.lkml"

explore: recruitment_funnel {
  from: test_funnel_recruitment
  hidden: yes

  group_label: "People"
  label: "Recruitment Funnel"
  description: "SR Data"



}
