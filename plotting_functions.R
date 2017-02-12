## source this when starting R to access nice default theme, new color scales

##########
### theme_mod is a clear theme that is similar to the cowplot theme with larger text
### `+ add_axes()` is used to add axes to the theme in a ggplot. Width of the line is an optional argument
### `+ rotate_labels()` is used to rotate the x axis labels if the are too long or if the plot width is too narrow. Takes the angle to rotate as an optional argument



require(tidyverse)
require(viridis)
require(RColorBrewer)


# theme for ggplot
theme_mod <- function(font_size = 14, font_family = "", line_size = .5) {
  half_line <- 9
  small_rel <- 0.857
  small_size <- small_rel * font_size
  
  theme_grey(base_size = font_size, base_family = font_family) %+replace%
    theme(
      rect              = element_rect(fill = "transparent", colour = NA, color = NA, size = 0, linetype = 0),
      text              = element_text(family = font_family, face = "plain", colour = "black",
                                       size = font_size, hjust = 0.5, vjust = 0.5, angle = 0, lineheight = .9,
                                       margin = ggplot2::margin(), debug = FALSE),
      axis.text         = element_text(colour = "black", size = small_size),
      #axis.title        = element_text(face = "bold"),
      axis.text.x       = element_text(margin = ggplot2::margin(t = small_size / 4), vjust = 1),
      axis.text.y       = element_text(margin = ggplot2::margin(r = small_size / 4), hjust = 1),
      axis.title.x      = element_text(
        margin = ggplot2::margin(t = small_size / 2, b = small_size / 4)
      ),
      axis.title.y      = element_text(angle = 90,margin = ggplot2::margin(r = small_size / 2, l = small_size / 4)),
      axis.ticks        = element_line(colour = "black", size = line_size),
      # axis.line = ifelse(axes == TRUE, element_line(colour = "black", size = line_size), element_blank()),
      axis.line = element_blank(),
      legend.key        = element_blank(),
      legend.spacing     = grid::unit(0.1, "cm"),
      legend.key.size   = grid::unit(1, "lines"),
      legend.text       = element_text(size = rel(small_rel)),
      #    legend.position   = c(-0.03, 1.05),
      # legend.justification = c("left", "right"),
      panel.background  = element_blank(),
      panel.border      = element_blank(),
      panel.grid.major  = element_blank(),
      panel.grid.minor  = element_blank(),
      strip.text        = element_text(size = rel(small_rel)),
      strip.background  = element_blank(),
      plot.background   = element_blank(),
      plot.title        = element_text(size = font_size*1.2, hjust = 0)
    )
}

# helper functions to change theme options
add_axes <- function(width = 0.6){theme(axis.line = element_line(colour = "black", size = width))}
remove_axes <- function(width = 0.6){theme(axis.line =element_blank())}
rotate_labels <- function(an = 45){theme(axis.text.x = element_text(angle = an, hjust=1))}


theme_set(theme_mod())


##################
# color palettes #####
#########################

## discrete

palette_ras <- function(n, random_order = FALSE) {
  cols <- c("#b33f62",
            "#0c0a3e",
            "#f9564f",
            "#7b1e7a",
            "#f3c677")
  cols <- cols[c(2,4,1,3,5)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  
  cols[1:n]
  
}
scale_color_ras <- function(...) discrete_scale("colour", "ras", palette_ras, ...)
scale_fill_ras <- function(...) discrete_scale("fill", "ras", palette_ras, ...)

palette_powder <- function(n, random_order = FALSE) {
  cols <- c("#2c0703",
            "#890620",
            "#b6465f",
            "#da9f93",
            "#ebd4cb")
  if (isTRUE(random_order))
    cols <- sample(cols)
  
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  
  cols[1:n]
  
}
scale_color_powder <- function(...) discrete_scale("colour", "powder", palette_powder, ...)
scale_fill_powder <- function(...) discrete_scale("fill", "powder", palette_powder, ...)


# base colors
palette_base <- function(n, random_order = FALSE) {
  cols <- c("#ac4142",
            "#d28445",
            "#f4bf75",
            "#90a959",
            "#75b5aa",
            "#6a9fb5",
            "#aa759f",
            "#8f5536",
            "black")
  cols <- cols[c(1,6,5,2,7,4,8,3)]
  
  if (isTRUE(random_order))
    cols <- sample(cols)
  
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  
  cols[1:n]
  
}
scale_color_base<- function(...) discrete_scale("colour", "base", palette_base, ...)
scale_fill_base <- function(...) discrete_scale("fill", "base", palette_base, ...)


palette_charted <- function(n, random_order = FALSE) {
  cols2 <- c('#6DCC73', '#1D7775', '#4FCFD5', '#FCE651', '#FF7050', '#FFC050', '#999999')
  cols2 <- cols2[c(1,2,3,5,6,7,4)]
  
  if (isTRUE(random_order))
    cols2 <- sample(cols2)
  
  if (length(cols2) < n)
    cols2 <- rep(cols2, length.out = n)
  
  cols2[1:n]
  
}
scale_color_charted<- function(...) discrete_scale("colour", "charted", palette_charted, ...)
scale_fill_charted <- function(...) discrete_scale("fill", "charted", palette_charted, ...)

palette_world <- function(n, random_order = FALSE) {
  cols <- c("#e39d25", "#d16050","#5cb3e7","#4676b1","#818b98","#4c4c4c")
  cols <- cols[c(3,4,1,2,5,6)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_world <- function(...) discrete_scale("colour", "world", palette_world, ...)
scale_fill_world <- function(...) discrete_scale("fill", "world", palette_world, ...)


palette_dark <- function(n, random_order = FALSE) {
  cols <- c("#3c2a21", "#a37c26","#a99b92","#1C4C68","#812e2c")
  cols <- cols[c(5,4,2,1,3)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_dark <- function(...) discrete_scale("colour", "dark", palette_dark, ...)
scale_fill_dark<- function(...) discrete_scale("fill", "dark", palette_dark, ...)



palette_brr <- function(n, random_order = FALSE) {
  # red, lighter purple, raspberry, orange, dark blue, orange,flesh, ice
  cols <- c("#D84541", "#783D6D", "#B44361", "#4E3759", "#D7D9D6", "#322E41", "#E46B4A", "#D4F2EB")
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_brr <- function(...) discrete_scale("colour", "brr", palette_brr, ...)
scale_fill_brr <- function(...) discrete_scale("fill", "brr", palette_brr, ...)

palette_bright <- function(n, random_order = FALSE) {
  cols <- c("#eec589", "#573a3b","#55bbb1","#3c4a68","#6399b4", "#969696")
  cols <- cols[c(5,4,2,6,1,3)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_bright <- function(...) discrete_scale("colour", "bright", palette_bright, ...)
scale_fill_bright <- function(...) discrete_scale("fill", "bright", palette_bright, ...)


palette_blues <- function(n, random_order = FALSE) {
  cols <- c("#8A0E38", "#1B95CF","#4D4768","#1B827F", "#C80E38", "#1E6496", "#64AA9D")
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_blues <- function(...) discrete_scale("colour", "blues", palette_blues, ...)
scale_fill_blues <- function(...) discrete_scale("fill", "blues", palette_blues, ...)


palette_cb <- function(n, random_order = FALSE) {
  cols <- c("#44AA99",
            "#6699CC",
            "#332288",
            "#117733",
            "#88CCEE",
            "#661100",
            "#DDCC77",
            "#999933",
            "#CC6677",
            "#AA4466",
            "#882255",
            "#AA4499")
  cols <- cols[c(3,2,5,1,4,6:12)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  
  cols[1:n]
  
}
scale_color_cb<- function(...) discrete_scale("colour", "cb", palette_cb, ...)
scale_fill_cb <- function(...) discrete_scale("fill", "cb", palette_cb, ...)



####################
# continuous 

g <- c(0.8423298817793848, 0.8737404427964184, 0.7524954030731037,
       0.7161563289278935, 0.8232880086631527, 0.6542005475652726,
       0.5815252468131623, 0.7703468311289211, 0.5923205247665932,
       0.4576142801317438, 0.7057950454122253, 0.5634791991994519,
       0.35935359003014994, 0.6245622005326175, 0.554154071059354,
       0.2958858732022419, 0.532095403269888, 0.5458447574597934,
       0.25744332683867743, 0.42368146872794976, 0.5191691971789514,
       0.23607359470828057, 0.3125354171874312, 0.4605854787435648,
       0.21392162678343224, 0.20848424698401846, 0.3660805512579508,
       0.17250549177124488, 0.11951843162770594, 0.24320155229883056)

greens <- c()
for(i in seq(1, length(g), by = 3)){
  greens <- greens %>% c(rgb(g[i], g[1+i], g[2+i]))
}
greens <- colorRampPalette(greens)
scale_color_greens <- function (..., alpha = 1, begin = 0, end = 1, direction = 1) 
{
  if (direction == -1) {
    tmp <- begin
    begin <- end
    end <- tmp
  }
  scale_color_gradientn(colours = greens(256), ...)
}

# green / blue
b <- c(0.21697808798621682, 0.32733564601225013, 0.36941176807179171,
       0.23442778952760632, 0.45820839330261826, 0.54352941859002213,
       0.25140587751382315, 0.58554403931486831, 0.7129411866618138,
       0.32480841754308709, 0.68493145540648814, 0.7899474686267329,
       0.45066770474895151, 0.75099834881576832, 0.77038576275694604,
       0.58002308326608998, 0.81890043370863974, 0.75028067616855398)
gb <- c()
for(i in seq(1, length(b), by = 3)){
  gb <- gb %>% c(rgb(b[i], b[1+i], b[2+i]))
}
gb <- colorRampPalette(gb)
# create scale
scale_color_gb <- function (..., alpha = 1, begin = 0, end = 1, direction = 1) 
{
  if (direction == -1) {
    tmp <- begin
    begin <- end
    end <- tmp
  }
  scale_color_gradientn(colours = gb(256), ...)
}

# purples
p <- c(0.9537199587873054, 0.8839852653958624, 0.8572137883283991,
       0.903348395924016, 0.7454993373667652, 0.7391619965768441,
       0.8399541228445281, 0.6129917738874731, 0.6602115774420979,
       0.7513505093364804, 0.48945565575763195, 0.6018942098123031,
       0.6294330293285846, 0.3759488961295364, 0.5449881320264003,
       0.4874367518814018, 0.2815561055972257, 0.4759723295956624,
       0.326803151203735, 0.1959385410144846, 0.3750675408906117,
       0.1750865648952205, 0.11840023306916837, 0.24215989137836502)
purples <- c()
for(i in seq(1, length(p), by = 3)){
  purples <- purples %>% c(rgb(p[i], p[1+i], p[2+i]))
}
purples <- colorRampPalette(purples)
scale_color_purples <- function (..., alpha = 1, begin = 0, end = 1, direction = 1) 
{
  if (direction == -1) {
    tmp <- begin
    begin <- end
    end <- tmp
  }
  scale_color_gradientn(colours = purples(256), ...)
}


b <- c("#2A2A38", "#53395C", "#793E6E", "#A24169", "#C24456", "#E34C30", "#E47C61", "#E19F91", "#DAC2BE", "#D8DAD7", "#D2F8EF")
br <- colorRampPalette(b)
scale_color_brrr <- function (..., alpha = 1, begin = 0, end = 1, direction = 1) 
{
  if (direction == -1) {
    tmp <- begin
    begin <- end
    end <- tmp
  }
  scale_color_gradientn(colours = br(256), ...)
}
ggthemr::colour_plot(br(12))