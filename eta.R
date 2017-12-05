find_type <- function(x) {
  case_when(
    is.factor(x) ~ "factor",
    is.character(x) ~ "character",
    is.numeric(x) ~ "numeric",
    TRUE ~ "not sure"
  )
}

eda <- function(x) {
  require("GoodmanKruskal")
  
  num_rows <- ncol(x)^2 - ncol(x)
  df <- tibble(var1 = vector(mode = "character", length = 1),
               var2 = vector(mode = "character", length = 1),
               statistic = vector(mode = "character", length = 1),
               value = vector(mode = "double", length = 1),
               p_value = vector(mode = "double", length = 1),
               n = vector(mode = "integer", length = 1))
  
  for(i in seq_along(1:ncol(iris)))
    for(j in seq_along(1:ncol(iris))) {
      if(i != j){
        # get type of columns i and j
        var_1_type <- find_type(x[,i])
        var_2_type <- find_type(x[,j])
        
        if(var_1_type == "numeric" & var_2_type == "numeric") {
          # run a correlation
          result <- cor.test(x[,i], x[,j])
          df <- add_row(df, 
                  var1 = names(x[i]),
                  var2 = names(x[j]),
                  statistic = "r",
                  value = result$estimate,
                  p_value = result$p.value,
                  n = NA_integer_
                  )
        } else if(var_1_type == "factor" & var_2_type == "numeric") {
          # run an ANOVA or t-test, depending on number of levels
          num_levels <- length(levels(x[,i]))
          result <- aov(x[,j] ~ x[,i])
          df <- add_row(df, 
                        var1 = names(x[i]),
                        var2 = names(x[j]),
                        statistic = "F",
                        value = summary(result) %>% map("F value") %>% unlist %>% .[1],
                        p_value = summary(result) %>% map("Pr(>F)") %>% unlist %>% .[1],
                        n = NA_integer_
          )
        } else if(var_1_type == "numeric" & var_2_type == "factor") {
          # run an ANOVA or t-test, depending on number of levels
          num_levels <- length(levels(x[,j]))
          result <- aov(x[,i] ~ x[,j])
          df <- add_row(df, 
                        var1 = names(x[i]),
                        var2 = names(x[j]),
                        statistic = "F",
                        value = summary(result) %>% map("F value") %>% unlist %>% .[1],
                        p_value = summary(result) %>% map("Pr(>F)") %>% unlist %>% .[1],
                        n = NA_integer_
          )
        } else if(var_1_type == "factor" & var_2_type == "factor") {
            # compute the GKtau statistic
          stat <- GKtau(x[,i], x[,j])$tauxy
          df <- add_row(df, 
                        var1 = names(x[i]),
                        var2 = names(x[j]),
                        statistic = "tau",
                        value = stat,
                        p_value = NA_real_,
                        n = NA_integer_
          )
        } else{
            # return an empty row
          df <- add_row(df, 
                        var1 = names(iris[i]),
                        var2 = names(iris[j]),
                        statistic = NA_character_,
                        value = NA_integer_,
                        p_value = NA_real_,
                        n = NA_integer_
          )
          }
      }
    }
  arrange(df[-1,], desc(p_value))
}

iris$interval <- cut(iris$Sepal.Length, 4)

eda(iris)

eda(iris) %>% 
  unite(variables, var1, var2) %>%
  ggplot(aes(y = abs(value), x = variables)) +
  geom_point() +
  coord_flip() +
  facet_wrap(~statistic, scales = "free") +
  theme_minimal()

