include: "/**/*.view"
include: "/**/*.explore"


explore: nps_comments_old {
  #from: nps_comments
  view_name: nps_comments  # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: yes

  # group_label: "01) Performance"
  # label: "Orders"
  # description: "General Business Performance - Orders, Revenue, etc."

  # view_label: "* Orders *"

  }
