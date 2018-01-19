library(tidyquant)

tq_index("SP500")

x <- tq_exchange("NASDAQ")

x %>% 
  group_by(industry) %>% 
  summarise(avg_price = mean(last.sale.price), na.rm = TRUE) %>% 
  ggplot(aes(x = industry, y = avg_price)) + 
  geom_point() +
  coord_flip()


tq_get_options()


aapl_prices  <- tq_get("AAPL", get = "stock.prices", from = " 1990-01-01")

p1 <- aapl_prices %>%
  ggplot(aes(x = date, y = close)) +
  geom_line(aes(group = 1)) +
  theme_minimal() +
  ggtitle("AAPL closing prices")

library(patchwork)

p2 <-
  aapl_prices %>%
  ggplot(aes(x = date, y = volume)) +
  geom_col(color = "grey20")+
  theme_minimal() +
  ggtitle("AAPL volume")
  

p1 + p2 + plot_layout(ncol = 1, height = c(0.8, 0.2))

mean_clean <- purrr::partial(mean, na.rm = TRUE)


aapl_prices %>% 
  mutate(year = lubridate::year(date)) %>%
  group_by(year) %>%
  summarise(average_close = mean_clean(close),
           average_volume = mean_clean(volume)) %>%
  ggplot(aes(x = average_close, y = average_volume)) +
  geom_point() +
  geom_line() +
  theme_minimal() +
  geom_text(aes(label = year), hjust = 1)

aapl_divs <- tq_get("AAPL", get = "dividends", from = "1990-01-01")
p3 <- aapl_divs %>%
  ggplot(aes(x = date, y = dividends)) +
  geom_col() +
  theme_minimal() +
  ggtitle("AAPL dividends")

p1 + p2 + p3 + plot_layout(ncol = 1, heights = c(0.5, 0.25, 0.25))


aapl_key_ratios <- tq_get("AAPL", get = "key.ratios")


p4 <- aapl_key_ratios %>%
  filter(section == "Valuation Ratios") %>%
  unnest() %>%
  filter(category == "Price to Earnings") %>%
  ggplot(aes(x = date, y = value)) +
  ggtitle("P:E ratio") +
  geom_line() +
  theme_minimal() +
  scale_x_date(limits = c(as.Date('1990-01-01'), NA)) +
  ylim(c(0, NA))

p1 + p2 + p4 + plot_layout(ncol = 1, heights = c(0.5, 0.25, 0.25))

#####


wti_price_usd <- tq_get("DCOILWTICO", get = "economic.data")
wti_price_usd 



mortage_interest_rates <- tq_get("MORTGAGE30US", get = "economic.data")

(m1 <- mortage_interest_rates %>%
  ggplot(aes(x = date, y = price)) +
  geom_line() +
  ggtitle("mortgage interest rates") +
  theme_minimal()
)


x <- full_join(mortage_interest_rates, aapl_prices)

x %>% ggplot(aes( x = price, y = close)) +
  geom_point() +
  theme_minimal() +
  ylab("AAPL close") +
  xlab("mortage interest rate")


m2 <- x %>%
  filter(!is.na(price)) %>%
  ggplot(aes( x = date, y = price)) +
  geom_line() +
  ggtitle("interest rates") +
  theme_minimal() 

m3 <- x %>% 
  filter(!is.na(price)) %>%
  ggplot(aes( x = date, y = close)) +
  geom_line() +
  ggtitle("AAPL closing price") +
  theme_minimal() 

m2 + m3 + plot_layout(ncol = 1)


##### sliding windows
x <- x %>% 
  filter(!is.na(price)) %>%
  arrange(date)

# find the correlation between the two based on a sliding window

# find the mean of some sliding window
# window of 12 (3 months)


means <- vector(length = nrow(x))
for(i in 1:nrow(x)) {
  if((i-6) < 0) {
    means[i] <- mean_clean(x$price[0:i])
  } else{
    means[i] <- mean_clean(x$price[(i-6):(i+6)])
  }
  
}
means

x$mean_prices_12 <- means

ggplot(x, aes(x = date, y = price)) +
  geom_line(aes(y = mean_prices_12)) +
  theme_minimal() +
  geom_point()

## detrend by subtracting price from the rolling average
x <- x %>% 
  mutate(price_detrended = price - mean_prices_12)

d1 <- x %>% 
  ggplot(aes(x = date, y = price_detrended)) +
  geom_line() +
  theme_minimal()

## ...



######
### can we find the autocorrelation function on our own?
find_leading_correlation <- function(df, lag_length) {
  x <- df %>%
    mutate(lagged = lag(price, lag_length))
  
  cor(x$price, x$lagged, use= "complete.obs")
    
}
find_leading_correlation(x, 4)

# to find the highest correlation
possible_lags <- 1:40
map_dbl(possible_lags, ~ find_leading_correlation(x, .x) ) %>%
  set_names(possible_lags) %>%
  as_tibble %>%
  rownames_to_column(var = "lag") %>%
  mutate(lag = as.integer(lag)) %>%
  ggplot(aes(x = lag, y = data)) +
  ylab("correlation") +
  geom_point()

## that's pretty cool

## try with aapl stock
find_leading_correlation <- function(df, lag_length) {
  x <- df %>%
    mutate(lagged_close = lag(close, lag_length))
  
  cor(x$close, x$lagged_close, use= "complete.obs")
  
}
find_leading_correlation(x, 4)

# to find the highest correlation
possible_lags <- 1:40
map_dbl(possible_lags, ~ find_leading_correlation(x, .x) ) %>%
  set_names(possible_lags) %>%
  as_tibble %>%
  rownames_to_column(var = "lag") %>%
  mutate(lag = as.integer(lag)) %>%
  ggplot(aes(x = lag, y = data)) +
  ylab("correlation") +
  geom_point()

# or use
tibble(possible_lags = possible_lags) %>%
  mutate(correlation = map_dbl(possible_lags, ~ find_leading_correlation(x, .x)))

##############

# find extreme events in the apple stock

x %>%
  mutate(diff = close - lag(close,1), 
         extreme = if_else(abs(diff) > 5, "extreme", "normal")) %>%
  ggplot(aes(x = date, y = lagged)) +
  geom_point(aes(color = extreme))

## percent change per week

x %>%
  mutate(change = close / lag(close, 7) * 100) %>%
  mutate(ma = forecast::ma(change, order = 7)) %>%
  ggplot(aes(x = date, y = change)) +
  # geom_line() +
  geom_line(aes(y = ma), color = "orangered") +
  geom_hline(yintercept = 100, linetype = 2)





#### are stock and bond prices correlated?

df <- read_csv("~/Downloads/econ_data.csv")

df <- df %>% mutate(date = readr::parse_date(date, format = "%Y"))

# yearly percent growth of stocks and bonds
df %>%
  mutate(percent_growth_stocks = sp / lag(sp) * 100,
         percent_growth_bonds = bond_yield / lag(bond_yield) * 100) %>%
  select(date, percent_growth_stocks, percent_growth_bonds) %>% 
  gather("index", "growth", percent_growth_stocks, percent_growth_bonds) %>%
  ggplot(aes(x = date, y = growth)) +
  geom_line(aes(color = index)) +
  ggtitle("growth of stocks and bonds") +
  scale_color_manual(values = c("firebrick1", "dodgerblue")) +
  theme_minimal()

## better way of looking at it
c1 <- df %>%
  mutate(percent_growth_stocks = (sp / lag(sp) * 100) - 100) %>%
  select(date, percent_growth_stocks, bond_yield) %>% 
  gather("index", "growth", percent_growth_stocks, bond_yield) %>%
  ggplot(aes(x = date, y = growth)) +
  geom_line(aes(color = index)) +
  ggtitle("growth of stocks and bonds") +
  scale_color_manual(values = c("firebrick1", "dodgerblue")) +
  theme_minimal()

## compute rolling correlation
get_cor <- function(x, window_size) {
  cors <- vector(length = nrow(x))
  for(i in 1:nrow(x)) {
    if((i + window_size) < nrow(x)) {
      y <- x %>% 
        mutate(percent_growth_stocks = (sp / lag(sp) * 100) - 100) %>% 
        slice(i: (i + window_size))
      cors[i] <- cor(y$percent_growth_stocks, y$bond_yield, use = "complete.obs")
    }
  }
  names(cors) <- x$date
  cors
}

get_cor(df, 3)

c2 <- tibble(correlation_3 = get_cor(df, 3), 
       year = names(get_cor(df, 3))) %>%
  mutate(year = as_date(year)) %>%
  ggplot(aes(x = year, y =  correlation_3)) +
  geom_line(aes(y = correlation_3), color = "firebrick2") +
  theme_minimal() +
  scale_x_date() +
  geom_hline(yintercept = 0, linetype = 2, color = "grey")

bonds_only <- df %>%
  ggplot(aes(x = date, y = bond_yield)) +
  geom_line()+
  theme_minimal()

stocks_only <- df %>%
  mutate(percent_growth_stocks = (sp / lag(sp) * 100) - 100) %>%
  ggplot(aes(x = date, y = percent_growth_stocks)) +
  geom_line()+
  theme_minimal()

c1 + c2 + plot_layout(ncol = 1)

stocks_only + bonds_only + c2 + plot_layout(ncol = 1)

##### get inflation data

cpi <- tq_get("CPIAUCSL", get = "economic.data")

c2 <- cpi %>% ggplot(aes(x = date, y = price)) + geom_line()

## change in inflation rate
## rolling window of 1 year (= 12 steps)

c1 <- cpi %>%
  mutate(lagged = lag(price, 12)) %>%
  mutate(percent_change = price / lagged * 100) %>%
  ggplot(aes(x = date, y = percent_change)) +
  geom_line() +
  ggtitle("% change in CPI")

c2 + c1 + plot_layout(ncol= 1)









########

sim <- function(n = 100) {
  x <- vector(length = n, mode = "double")
  x[1] = 1
  for(i in 2:length(x)){
    print(i)
    x[i] <- x[i-1] + rnorm(1, mean = 1, sd = 5) 
  }
  x
}

## compute rolling correlation
get_cor <- function(x, window_size) {
  cors <- vector(length = nrow(x))
  for(i in 1:nrow(x)) {
    if((i + window_size) < nrow(x)) {
      y <- x %>% 
        slice(i: (i + window_size))
      cors[i] <- cor(y$x, y$y, use = "complete.obs")
    }
  }
  names(cors) <- x$date
  cors
}


test_tibble <- tibble(date = 1:100, x = sim(), y = sim())

full <- test_tibble %>%
  gather("type", "number", x, y) %>%
  ggplot(aes(x = date, y = number, color = type)) +
  geom_line() +
  theme_minimal()

correlation <- tibble(date = names(get_cor(test_tibble, 5)),
       correlation = get_cor(test_tibble, 5)) %>%
  mutate(date = as.integer(date)) %>%
  ggplot(aes(x =date, y = correlation)) +
  geom_line() +
  theme_minimal() +
  geom_hline(yintercept = 0, linetype = 2, color = "grey")

full + correlation + plot_layout(ncol = 1)


#################

df <- read_csv("~/Downloads/dataPermit_full.csv", na = "null")

df %>% sample_n(10)

df <- df %>%
  mutate(date = parse_date(date, format = "%m/%Y"))

df <- df %>%
  mutate(month = lubridate::month(date), year = year(date))

df <- df %>%
  select(-ends_with("change")) %>%
  filter(year > 2000)

df %>% count(year)

df %>% count(area)

ggplot(df, aes(x = date, y = f1units)) +
  geom_line(aes(group = area))

# only take the most popular cities

top_10 <- df %>% 
  group_by(area) %>% 
  summarise(num = mean(f1units)) %>% 
  arrange(desc(num)) %>% 
  slice(1:10) %>% 
  pull(area)


df %>% 
  filter(area %in% top_10) %>%
  mutate(area = factor(area)) %>%
  ggplot(aes(x = date, y = f1units, color = fct_reorder2(area, date, f1units))) +
  geom_line()


big <- df %>% 
  filter(area %in% top_10) %>%
  mutate(area = factor(area))

big %>%
  ggplot(aes(x = date, y = f1units)) +
  geom_line(aes(group = area)) +
  geom_smooth(se = FALSE, color = "orangered")

library(modelr)

mod <- lm(f1units ~ factor(month) * area, data = big)

big %>%
  add_predictions(mod) %>%
  ggplot(aes(month, pred, color = area)) +
  geom_line()
  


by_area <- big %>%
  group_by(area) %>% 
  nest


get_model <- function(x){
  lm(f1units ~ factor(month), data = x)
}

by_area %>%
  mutate(mod = map(data, get_model)) %>%
  mutate(resids = map2(data, mod, add_residuals)) %>%
  unnest(resids) %>%
  ggplot(aes(x = date, y = resid, color = area)) +
  geom_line()











