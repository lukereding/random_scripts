## source this when starting R to access nice default theme, new color scales

##########
### theme_mod is a clear theme that is similar to the cowplot theme with larger text
### `+ add_axes()` is used to add axes to the theme in a ggplot. Width of the line is an optional argument
### `+ rotate_labels()` is used to rotate the x axis labels if the are too long or if the plot width is too narrow. Takes the angle to rotate as an optional argument



require(tidyverse)
require(viridis)
require(RColorBrewer)


# Functions for converting between effect sizes ===================

# make sure arguments are of the correct type and not NULL
check_args <- function(x, type){
  if (!is.null(x) && class(x) == type)
    invisible()
  else
    stop(paste0("incorrect type or null argument: ", x))
}


d_to_r <- function(d = NULL, n1 = NULL, n2 = NULL) {
  
  # based on https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
  
  # check arguments
  args <- as.list(match.call())
  missing_args <- setdiff(c("d", "n1", "n2"), names(args))
  if (length(missing_args) > 1) {
    stop(paste0("missing arguments "), paste0(missing_args, collapse = ", "))
  }
  
  # mapply(check_args, args[2:length(args)], rep("numeric", length(args) - 1))
  
  a <- ((n1 + n2)^2) / (n1 * n2)
  
  d / sqrt((d^2) + a)
  
}

logodds_to_d <- function(log_odds = NULL) {
  
  # based on https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
  
  # check arguments
  args <- as.list(match.call())
  missing_args <- setdiff(c("log_odds"), names(args))
  
  if (length(missing_args) > 1) {
    stop(paste0("missing arguments "), paste0(missing_args, collapse = ", "))
  }
  
  # mapply(check_args, args[2:length(args)], rep("numeric", length(args) - 1))
  
  log_odds * sqrt(3) / pi
  
}

r_to_d <- function(r = NULL) {
  
  # based on https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
  
  # check arguments
  args <- as.list(match.call())
  missing_args <- setdiff(c("r"), names(args))
  
  if (length(missing_args) > 1) {
    stop(paste0("missing arguments "), paste0(missing_args, collapse = ", "))
  }
  
  if (r > 1L | r < -1L) {
    stop("the correlation coefficent must be in the range [-1, 1]")
  }
  
  # mapply(check_args, args[2:length(args)], rep("numeric", length(args) - 1))
  
  (2 * r) / sqrt(1 - (r^2))
  
}






# for exploratory data analysis

plot_histograms <- function(data){
  data %>%
    select_if(is.numeric) %>%
    gather(variable, value) %>%
    ggplot(aes(x = value)) +
    geom_histogram() +
    facet_wrap(~variable, scale = "free")+
    theme_minimal()
}

plot_counts <- function(data){
  data %>%
    select_if(function(x) is.factor(x) || is.character(x)) %>%
    gather(variable, value) %>%
    ggplot(aes(x = value)) +
    geom_bar() +
    facet_wrap(~variable, scale = "free")+
    theme_minimal()
}

plot_cat_relationship <- function(data, categorical_variable) {

  numeric_cols <- names(data)[map_lgl(data, is.numeric)]
  enquo_cat <- enquo(categorical_variable)

  data %>%
    select(!!enquo_cat, numeric_cols) %>%
    gather(variable, value, -!!enquo_cat) %>%
    ggplot(aes_string(x = quo_name(enquo_cat), y = "value", color = quo_name(enquo_cat))) +
    geom_boxplot() +
    facet_wrap(~variable, scales = "free") +
    coord_flip() +
    scale_color_brewer(type = "qual", palette = "Dark2", guide = F) +
    ggtitle(paste0("relationships with ", quo_name(enquo_cat))) +
    theme_minimal()
}

# theme for ggplot
theme_mod <- function(font_size = 12, font_family = "", line_size = .5) {
  half_line <- 9
  small_rel <- 0.67
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
      strip.background = element_blank(),
      plot.background   = element_blank(),
      plot.title        = element_text(size = font_size*1.2, hjust = 0 )
    )
}

# helper functions to change theme options
add_axes <- function(width = 0.4){theme(axis.line = element_line(colour = "black", size = width))}
remove_axes <- function(width = 0.6){theme(axis.line =element_blank())}
rotate_labels <- function(an = 45){theme(axis.text.x = element_text(angle = an, hjust=1))}
remove_ticks_x <- function(){theme(axis.ticks.x = element_blank())}
move_ticks_inside_x <- function(){theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=margin(10,5,15,5,"pt")))}
move_ticks_inside_y <- function(){theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.y = element_text(margin=margin(10,10,15,5,"pt")))}
# theme_set(theme_mod())


## add themes from https://github.com/kassambara/ggpubr/blob/master/R/theme_pubr.R
theme_pubr <- function (base_size = 12, base_family = "",
                        border = FALSE, margin = TRUE,
                        legend = c("top", "bottom", "left", "right", "none"),
                        x.text.angle = 0)
{
  half_line <- base_size/2
  if(!is.numeric(legend)) legend <- match.arg(legend)
  if(x.text.angle > 5) xhjust <- 1 else xhjust <- NULL

  if(border){
    panel.border <- element_rect(fill = NA, colour = "black", size = 0.7)
    axis.line <- element_blank()
  }
  else{
    panel.border <- element_blank()
    axis.line = element_line(colour = "black", size = 0.5)
  }


  if(margin)
    plot.margin <- margin(half_line, half_line, half_line,
                          half_line)
  else plot.margin <- unit(c(0.5,0.3,0.3,0.3),"mm")

  .theme <- theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(panel.border = panel.border,
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.line = axis.line, axis.text = element_text(color = "black"),
          legend.key = element_blank(),
          strip.background = element_rect(fill = "#F2F2F2", colour = "black", size = 0.7),
          plot.margin = plot.margin,
          legend.position = legend,
          complete = TRUE)

  if(x.text.angle!=0)
    .theme <- .theme + theme(axis.text.x = element_text(angle = x.text.angle, hjust = xhjust))

  .theme
}


labs_pubr <- function(base_size = 14, base_family = ""){
  theme(
    text = element_text(family = base_family,
                        face = "plain", colour = "black", size = base_size, lineheight = 0.9,
                        hjust = 0.5, vjust = 0.5, angle = 0, margin = margin(),
                        debug = FALSE),
    # Tick labels
    axis.text.x = element_text(size = rel(0.86), colour = "black", face = "bold"),
    axis.text.y = element_text(size = rel(0.86), colour = "black", face = "bold"),

    # Axis labels
    axis.title = element_text(size = rel(1), colour = "black", face = "bold"),

    # Main title
    plot.title = element_text(size = rel(1), colour = "black" ,
                              lineheight=1.0, face = "bold"),
    legend.title = element_text(size = rel(0.7), face = "bold", colour = "black"),
    legend.text = element_text(size = rel(0.7), face = "plain", colour = "black")
  )
}


##################
# color palettes #####
#########################

## discrete
palette_carto <- function(n) {
  cols <- c('#5F4690','#1D6996','#38A6A5','#0F8554','#73AF48','#EDAD08','#E17C05','#CC503E','#94346E','#6F4070','#994E95','#666666')
  cols <- cols[c(2,3,6,7,8,9,1,4,5,10)]
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  
  cols[1:n]
  
}
scale_color_carto <- function(...) discrete_scale("colour", "carto", palette_carto, ...)
scale_fill_carto <- function(...) discrete_scale("fill", "carto", palette_carto, ...)



palette_warm <- function(n) {
  cols <- c("#722E95", "#FD397B", "#FF6678", "#FE9C5D", "#FFC102", "#FFD775", "#969698", "#4C4C4E", "#D1C1DB", "#9A6CB5")
  cols <- cols[c(3, 5, 8, 1, 4, 6, 9, 7, 2, 10)]
  
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  
  cols[1:n]
  
}
scale_color_warm <- function(...) discrete_scale("colour", "warm", palette_warm, ...)
scale_fill_warm <- function(...) discrete_scale("fill", "warm", palette_warm, ...)


palette_pt <- function(n) {
  cols <- c("#44AAAA", "#AA4455", "#4477AA", "#AA4488", "#44AA77", "#AA7744", "#AAAA44")

  if (length(cols) < n)
    cols <- rep(cols, length.out = n)

  cols[1:n]

}
scale_color_pt <- function(...) discrete_scale("colour", "pt", palette_pt, ...)
scale_fill_pt <- function(...) discrete_scale("fill", "pt", palette_pt, ...)


palette_ds <- function(n) {
  pal2 <- c("#ECD078", "#D95B43", "#C02942", "#542437", "#53777A")
  pal2 <- pal2[c(3,5,2,4,1)]

  if (length(pal2) < n)
    pal2 <- rep(pal2, length.out = n)

  pal2[1:n]

}
scale_color_ds <- function(...) discrete_scale("colour", "ds", palette_ds, ...)
scale_fill_ds <- function(...) discrete_scale("fill", "ds", palette_ds, ...)


palette_lr <- function(n) {
  cols <- c("#FFBC00", "#FF7B35", "#FF5555", "#C55981", "#8E6DA2", "#525D6B", "#2E3838", "grey50")
  cols <- cols[c(3,6,2,7,4,1,8,5)]

  if (length(cols) < n)
    cols <- rep(cols, length.out = n)

  cols[1:n]

}
scale_color_lr <- function(...) discrete_scale("colour", "lr", palette_lr, ...)
scale_fill_lr <- function(...) discrete_scale("fill", "lr", palette_lr, ...)


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


palette_pen <- function(n, random_order = FALSE) {
  cols <- c("#E84F22","#F2C500", "#37454B", "#82BAC5", "#8B8B8B", "#d36f6f")
  # cols <- cols[c(3,2,4,1,5)]
  cols <- cols[c(1,4,3,2,5, 6)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_pen <- function(...) discrete_scale("colour", "pen", palette_pen, ...)
scale_fill_pen <- function(...) discrete_scale("fill", "pen", palette_pen, ...)



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


palette_classic <- function(n, random_order = FALSE) {
  cols <- c("#eaab00", "#004165","#236d01", "#eacb77", "#4686aa", "#65aa46" ,"#ea5d00", "#f29354")
  if (isTRUE(random_order))
    cols <- sample(cols)

  if (length(cols) < n)
    cols <- rep(cols, length.out = n)

  cols[1:n]

}
scale_color_classic <- function(...) discrete_scale("colour", "classic", palette_classic, ...)
scale_fill_classic <- function(...) discrete_scale("fill", "classic", palette_classic, ...)


palette_cool<- function(n, random_order = FALSE) {
  cols <- c("#1F1B29", "#00D6B1", "#339EFF", "#FFFB39", "#FD4A2E")
  if (isTRUE(random_order))
    cols <- sample(cols)

  if (length(cols) < n)
    cols <- rep(cols, length.out = n)

  cols[1:n]

}
scale_color_cool <- function(...) discrete_scale("colour", "cool", palette_cool, ...)
scale_fill_cool<- function(...) discrete_scale("fill", "cool", palette_cool, ...)


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
  cols <- c("#e39d25", "#d16050","#5cb3e7","#4676b1","#1E824C", "#4DAF7C", "#818b98","#4c4c4c")
  cols <- cols[c(2,3,8,1,4,7,6, 5)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_world <- function(...) discrete_scale("colour", "world", palette_world, ...)
scale_fill_world <- function(...) discrete_scale("fill", "world", palette_world, ...)


palette_alpine <- function(n, random_order = FALSE) {
  cols <- c("#302A5B", "#B93529","#BB6A2C","#6D7897","#5E5A6E", "#4DAF7C", "#421810")
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_alpine <- function(...) discrete_scale("colour", "alpine", palette_alpine, ...)
scale_fill_alpine <- function(...) discrete_scale("fill", "alpine", palette_alpine, ...)


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


palette_puz <- function(n, random_order = FALSE) {
  cols <- c("#525164", "#A4C3B1", "#DB868C", "#4A6851", "#714738", "#FBDD93", "#C04839", "#D8924F","#EBA758")
  cols <- cols[c(1,4,2,5,9,6,3,7,8)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_puz <- function(...) discrete_scale("colour", "puz", palette_puz, ...)
scale_fill_puz <- function(...) discrete_scale("fill", "puz", palette_puz, ...)



palette_brew <- function(n, random_order = FALSE) {
  cols <- c("#4C9889", "#5E3F27", "#708CB0", "#2A534D", "#FFF55E", "#313752", "#FC6C64", "#FFAF4F", "#88211C")
  cols <- cols[c(1,4,2,5,9,6,3,7,8)]
  if (isTRUE(random_order))
    cols <- sample(cols)
  if (length(cols) < n)
    cols <- rep(cols, length.out = n)
  cols[1:n]
}
scale_color_brew <- function(...) discrete_scale("colour", "brew", palette_brew, ...)
scale_fill_brew <- function(...) discrete_scale("fill", "brew", palette_brew, ...)



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
  # cols <- c("#8A0E38", "#1B95CF","#4D4768","#1B827F", "#C80E38", "#1E6496", "#64AA9D")
  cols <- c("#8A0E38", "#52B3D9","#674172","#16A085", "#CF000F", "#34495E", "#65C6BB")
  cols <- cols[c(6,7,4,1,5,3,2)]
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
#ggthemr::colour_plot(br(12))

coord_radar <- function (theta = "x", start = 0, direction = 1)
{
  theta <- match.arg(theta, c("x", "y"))
  r <- if (theta == "x")
    "y"
  else "x"
  ggproto("CordRadar", CoordPolar, theta = theta, r = r, start = start,
          direction = sign(direction),
          is_linear = function(coord) TRUE)
}
