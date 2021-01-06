import::from("magrittr", "%>%")

y <- yaml::read_yaml("data-public/exercises/exercise-1.yml")

dput(y)

# 
# list(
#   list(prompt = "How many unique customers does Rexon Metal have?", 
#     requirements = c("must use `SELECT`", "must use `count`"), 
#     code = "SELECT\n  count(distinct(customer_id))\nFROM customer\n", 
#     answers = list(5L, "five")),
#   
#   list(prompt = "How many unique customers does Rexon Metal have?", 
#     requirements = c("must use `SELECT`", "must use `count`"), 
#     code = "SELECT\n  count(distinct(customer_id))\nFROM customer\n", 
#     answers = list(5L, "five"))
# )

