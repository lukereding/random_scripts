## source this when starting R to access nice default theme, new color scales

##########
### theme_mod is a clear theme that is similar to the cowplot theme with larger text
### `+ add_axes()` is used to add axes to the theme in a ggplot. Width of the line is an optional argument
### `+ rotate_labels()` is used to rotate the x axis labels if the are too long or if the plot width is too narrow. Takes the angle to rotate as an optional argument



require(tidyverse)
require(viridis)
require(RColorBrewer)


# theme for ggplot
theme_mod <- function(font_size = 14, font_family = "", line_size = .5, axes = F) {
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
      axis.title.y      = element_text(
        angle = 90,
        margin = ggplot2::margin(r = small_size / 2, l = small_size / 4),
      ),
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
      plot.title        = element_text(size = font_size*1.2,
                                       hjust = 0)
    )
}

# helper functions to change theme options
add_axes <- function(width = 0.6){theme(axis.line = element_line(colour = "black", size = width))}
rotate_labels <- function(an = 45){theme(axis.text.x = element_text(angle = an, hjust=1))}


theme_set(theme_mod())

# color palettes


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

