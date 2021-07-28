include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

# IMPORTANT - used in Investor Relations reports

explore: gorillas_hub_counts {
  from: hub_counts
  hidden: yes
}
