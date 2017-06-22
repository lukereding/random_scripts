
require(magrittr)
require(tidyverse)
require(ggmap)
source("https://raw.githubusercontent.com/lukereding/random_scripts/master/plotting_functions.R")

us <- c(left = -122.55, bottom = 37.73, right = -122.35, top = 37.825)
map <- get_stamenmap(us, zoom = 14, maptype = "toner-lite")

ggmap(map)

df <- tibble::frame_data(~long, ~lat, ~site, ~type,
                         -122.485806, 37.769005, "Golden Gate Park", "run",
                         -122.478436, 37.819909, "Golden Gate Bidge", "run",
                         -122.447736, 37.751909, "Twin Peaks", "run",
                         -122.500908, 37.781512, "Lands End", "run",
                         -122.419077,37.752022, "La Major Bakery", "food :: beer",
                         -122.424104, 37.761444, "Tartine", "food :: beer",
                         -122.393289, 37.795553, "Ferry Building", "food :: beer",
                         -122.431203, 37.771896, "Tornado Bar", "food :: beer",
                         -122.411354, 37.790006, "HopWater", "food :: beer",
                         -122.422929, 37.805885, "GHIRARDELLI SQUARE", "food :: beer",
                         -122.411540, 37.752565, "Precita Eyes Muralists", "arts :: sciences",
                         -122.468636, 37.771516, "de Young Museum", "arts :: sciences",
                         -122.466105, 37.769907, "California Academy of Sciences", "arts :: sciences",
                         -122.500668, 37.784648, "Legion of Honor", "arts :: sciences",
                         -122.400986, 37.785693, "SFMOMA", "arts :: sciences",
                         -122.408025, 37.802983, "North Beach", "explore",
                         -122.513661, 37.780437, "Sutro Baths", "explore",
                         -122.433235, 37.861350, "Angel Island", "explore",
                         -122.395570, 37.797016, "Embarcadero", "explore",
                         -122.415817, 37.758819, "Mission District", "explore",
                         -122.415386, 37.808924, "Fishermans Wharf", "explore",
                         -122.398716, 37.800809, "The Exploratorium", "arts :: sciences"
)

library(ggthemes)
ggmap(map) +
  geom_point(data = df, aes(x = long, y = lat, col = type, shape = type), size = 4) +
  theme_mod() +
  scale_color_pen() +
  xlab("longitude") +
  scale_shape_stata() +
  ylab("latitude") +
  ggtitle("overview of things to do in SF")
