library(tidyverse)

# sample data

df <- data.frame(group= rep(c("a", "b"), each = 20), value = c(rnorm(20, mean = 5), rnorm(20, mean = 6)))

permutate_oldest <- function(df, n = 9999, group = NULL, var = NULL){
  
  new_df <- data.frame(replicate = 1:n)
  
  group_enquo <- enquo(group)
  var_enquo <- enquo(var)
  
  return_diff <- function(df, g) {
    df$group_perm <- sample(dplyr::pull(df, !!g), replace = FALSE)
    Reduce(`-`, tapply(df[, "value"], df[, "group_perm"], mean, simplify = FALSE))
  }
  
  observed_diff <- Reduce(`-`, tapply(df[, "value"], df[, "group"], mean, simplify = FALSE))
  
  # write a function that quotes all args # from `getAnywhere(select.data.frame)`
  # vars <- lapply(list(group = group, var = var), function(x) assign(paste0(as.character(x), "_enquo"), enquo(x)))
  
  # df$shuf <- sample(dplyr::pull(df, !!group_enquo))
  
  # tapply(df[, "value"], df[, "shuf"], mean, simplify = FALSE)
  
  new_df$diff <- unlist(replicate(n, 
            return_diff(df, group_enquo), 
            simplify = FALSE))
  
  new_df
  
  # list(permuted_differences = new_df, observed_differences = data.frame(replicate = 1, diff = observed_diff))
  
}

differences <- permutate_oldest(df, n = 999, group, value)

observed = Reduce(`-`, tapply(df[, "value"], df[, "group"], mean, simplify = FALSE))

differences %>%
  ggplot() +
  geom_histogram(aes(x = diff)) +
  geom_vline(xintercept = observed, color = "red")








permutate_old <- function(df, group = NULL, var = NULL){
  
  group_enquo <- enquo(group)
  var_enquo <- enquo(var)
  
  # write a function that quotes all args # from `getAnywhere(select.data.frame)`
  # vars <- lapply(list(group = group, var = var), function(x) assign(paste0(as.character(x), "_enquo"), enquo(x)))
  
  # df$shuf <- sample(dplyr::pull(df, !!group_enquo))
  
  # tapply(df[, "value"], df[, "shuf"], mean, simplify = FALSE)
  
  attr(df, "shuf") <- replicate(10, 
                                   sample(dplyr::pull(df, !!group_enquo), replace = FALSE), 
                                   simplify = FALSE)
  attr(df, "vars") <- list(quote(replicate))
  attr(df, "labels") <- data.frame(replicate = 1:10)
  
  df
}

permutate_old(df, group, value)

