
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


# # Things to do in San Francisco

# ### runs

# - Golden Gate park is close by and has [a lot of running paths](https://goldengatepark.com/wp-content/uploads/2011/03/map_of_golden_gate_park.pdf) 
# - run across the golden gate bridge (~4 miles from the Airbnb) 🌉
# - for a hill workout, [Twin Peaks](http://sfrecpark.org/destination/twin-peaks/) w/ excellent view
# - [land's end trial](https://www.nps.gov/goga/planyourvisit/landsend.htm) — looks awesome

# ### food :: drink

# - La Mejor Bakery for breakfast? 🥖
# - [Tartine](http://www.tartinebakery.com/menus-ordering/) might be a cool place to check out, possibly for breakfast
# - Ferry Building Farmer's market (3x a week)
# - go to [Tornado bar](http://www.toronado.com), which has a large selection of craft beer 🍻
# - [HopWater](http://www.hopwaterdistribution.com) also seems cool but is more downtown
# - GHIRARDELLI SQUARE has chocolate chips cookies 🍪 and a new beer garden with ping pong 🏓 and corn hole

# ### arts :: sciences

# - Precita Eyes — neighborhood arts assocation that leads tours of the street art
# - de Young Museum in Golden Gate Park
# - [California Academy of Sciences](http://www.sftravel.com/explore/arts-culture/california-academy-sciences)—"the only place on the planet with an aquarium, a planetarium, a natural history museum, and a four-story rainforest all under one roof" 🐠
# - Legion of Honor — fine art 👩🏻‍🎨
# - SFMOMA — modern art ($25 though)

# ### explore

# - North Beach — cool neighborghod with bars and restaurants
# - Suthro baths + Land's End. There's a labrinth there too
# - Ferry to Angel Island — hike
# - Fisherman's Wharf has sea lions 
# - walk along the Embarcadero
# - walk around the Mission District



# ### time-sensitive

# - [The Exploratorium](https://www.exploratorium.edu/visit/free-days-and-reduced-rates) is free on Friday from 5 - 10pm (usually $30)
