library(data.table)
library(ggplot2)
library(reshape2)
library(readr)


# Import data and scenarios
baseline_dir = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline"
folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output"

directories = list(#"C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Environ_only/MISG_exe3",
                    "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Environ_only/MISG_exe4",
                    #"C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Environ/MISG_exe3",
                    "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Environ/MISG_exe4",
                    "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/TMDL/MISG_exe4",
                    "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/CRP/MISG_exe4",
                    #"C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Weighted/20percent",
                    #"C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Weighted/25percent",
                    #"C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Weighted/30percent",
                    "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline")
                    


# Preprocess baseline outside of loop
osub_base <- read.table("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline/output.sub", skip = 9, header = FALSE)
osub_base = as.data.table(osub_base)
osub_tail_base <- tail(osub_base,45)
osub_tail_new_base <- osub_tail_base[, list(V2, V8, V9, V11, V12, V20)]
setnames(osub_tail_new_base, old = c("V2","V8", "V9","V11","V12","V20"), new = c("Subbasins", "ET", "SW", "SUR", "GW", "LAT"))
sub_data_base <- melt(osub_tail_new_base, id.vars = "Subbasins", variable.name = "Parameters", value.name = "Q_mmPeryear")


# Loop through scenario folders and preprocess and plot
for (dir in directories){

  osub <- read.table(file.path(dir, "output.sub"), skip = 9, header = FALSE)
  osub = as.data.table(osub)
  osub_tail <- tail(osub,45)
  osub_tailnew <- osub_tail[, list(V2, V8, V9, V11, V12, V20)]
  setnames(osub_tailnew, old = c("V2","V8", "V9","V11","V12","V20"), new = c("Subbasins", "ET", "SW", "SUR", "GW", "LAT"))
  sub_data <- melt(osub_tailnew, id.vars = "Subbasins", variable.name = "Parameters", value.name = "Q_mmPeryear")
  
  
  # Merge data from baseline and scenario
  sub_data_combined <- merge(sub_data, sub_data_base, by = c("Subbasins", "Parameters"))
  print(sub_data_combined)
  
  #-----------------------------------------------------------------------------------------#
  # Plotting Individual Comparisons ######################
  #-----------------------------------------------------------------------------------------#
#   y_axis_limit <- 900
#   
#   ggplot(data = sub_data_combined, 
#                       mapping = aes(x = Subbasins, colour = Parameters, shape = Parameters)) +
#     geom_point(aes(y = Q_mmPeryear.x), size = 1) +  # Adjust point size
#     geom_line(aes(y = Q_mmPeryear.x, linetype = "Comparison"), size = 0.5) +
#     geom_point(aes(y = Q_mmPeryear.y), size = 1) +  # Adjust point size
#     geom_line(aes(y = Q_mmPeryear.y, linetype = "Baseline"), size = 0.5, linetype = "dashed") +
#     ylim(0, y_axis_limit) +
#     ggtitle("Scatter Comparison of Parameters Yearly across Subbasins") +
#     theme_minimal() +
#     theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
#           text = element_text(size = 11))
#     labs(x = "Subbasins", y = "Q (mm/year)", color = "Parameters", linetype = "Dashed for Baseline")
#   
#   folder_name <- basename(dir)  # Extracting the folder name from the directory path
#   ggsave(paste0("Comparison_scatter_", folder_name, ".png"), 
#          path = folder_out, width = 10, height = 6, units = "in", dpi = 300)

  }

#-----------------------------------------------------------------------------------------#
# Plotting weighted comparisons together on the same plot
#-----------------------------------------------------------------------------------------#
# 
# # Define a list to store data frames for each scenario
# all_scenario_data <- list()
# 
# # Loop through scenario folders and preprocess and plot
# for (dir in directories){
#   osub <- read.table(file.path(dir, "output.sub"), skip = 9, header = FALSE)
#   osub = as.data.table(osub)
#   osub_tail <- tail(osub, 45)
#   osub_tailnew <- osub_tail[, list(V2, V8, V9, V11, V12, V20)]
#   setnames(osub_tailnew, old = c("V2", "V8", "V9", "V11", "V12", "V20"), new = c("Subbasins", "ET", "SW", "SUR", "GW", "LAT"))
#   sub_data <- melt(osub_tailnew, id.vars = "Subbasins", variable.name = "Parameters", value.name = "Q_mmPeryear")
#   
#   # Store scenario data in the list with scenario directory name as list element name
#   all_scenario_data[[dir]] <- sub_data
# }
# 
# # Combine all scenario data into a single data frame
# all_data <- do.call(rbind, all_scenario_data)
# 
# # Define scenario names
# #scenario_names <- c("20%", "25%", "30%", "Baseline")
# scenario_names <- c("Environ_bioenergy", "Environ", "TMDL", "CRP", "Baseline")
# 
# # Add scenario name to the data
# all_data$scenario_name <- rep(scenario_names, each = nrow(all_data) / length(scenario_names))
# 
# # Plotting all scenarios on the same plot with different line types
# y_axis_limit <- 900
# p <- ggplot(data = all_data, aes(x = Subbasins, y = Q_mmPeryear, color = Parameters, linetype = scenario_name)) +
#   geom_point(size = 1) +
#   geom_line(size = 0.75) +  # Increase line thickness
#   ylim(0, y_axis_limit) +
#   ggtitle("Scatter Comparison of Parameters Yearly across Subbasins") +
#   theme_minimal() +
#   theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
#         text = element_text(size = 11)) +
#   labs(x = "Subbasins", y = "Q (mm/year)", color = "Parameters", linetype = "Scenario") +
#   #scale_linetype_manual(values = c("20%" = "dotdash", "25%" = "dashed", "30%" = "dotted", "Baseline" = "solid"))  # Define line types for scenarios
#   scale_linetype_manual(values = c("Environ_bioenergy" = "longdash", "Environ" = "dashed","TMDL" = "dotted", "CRP" = "dotdash","Baseline" = "solid"))
# 
# 
# # Increase the size of the figure
#   ggsave(paste0("Comparison_plot.png"), path = folder_out, plot = p, width = 10, height = 6, units = "in", dpi = 600)
# 
# 

#-----------------------------------------------------------------------------------------#
# Plotting grouped comparison plots across weighted scenarios but for different parameters for increased clarity 
#-----------------------------------------------------------------------------------------#
# Split the data into three subsets based on parameters
et_data <- all_data[all_data$Parameters == "ET", ]
sw_sur_data <- all_data[all_data$Parameters %in% c("SW", "SUR"), ]
gw_lat_data <- all_data[all_data$Parameters %in% c("GW", "LAT"), ]

# Function to create comparison plots

# Get the default color palette used by ggplot2
default_colors <- scales::hue_pal()(length(unique(all_data$Parameters)))

# Create a named vector with parameter names and corresponding default colors
parameter_colors <- setNames(default_colors, unique(all_data$Parameters))

create_comparison_plot <- function(data, title) {
  max_y <- max(data$Q_mmPeryear, na.rm = TRUE)  # Calculate the maximum value of Q_mmPeryear
  min_y <- min(data$Q_mmPeryear, na.rm = TRUE)  # Calculate the minimum value of Q_mmPeryear
  y_range <- c(min_y, max_y)  # Create a vector with minimum and maximum y values
  
  ggplot(data = data, aes(x = Subbasins, y = Q_mmPeryear, color = Parameters, linetype = scenario_name)) +
    geom_point(size = 1) +
    geom_line(size = 0.5) +
    ylim(y_range) +  # Set y-axis limit to include both minimum and maximum values
    ggtitle(title) +
    theme_minimal() +
    theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
          text = element_text(size = 11)) +
    labs(x = "Subbasins", y = "Q (mm/year)", color = "Parameters", linetype = "Scenario") +
    scale_color_manual(values = parameter_colors) +  # Set consistent colors for each parameter
    #scale_linetype_manual(values = c("20%" = "dotdash", "25%" = "dashed", "30%" = "dotted", "Baseline" = "solid"))
    scale_linetype_manual(values = c("Environ_bioenergy" = "longdash", "Environ" = "dashed","TMDL" = "dotted", "CRP" = "dotdash","Baseline" = "solid"))
}

# Create and save plots for each parameter
ggsave(paste0("ET_comparison_plot.png"), path = folder_out, plot = create_comparison_plot(et_data, "ET Comparison"), width = 10, height = 6, units = "in", dpi = 600)
ggsave(paste0("SW_SUR_comparison_plot.png"), path = folder_out, plot = create_comparison_plot(sw_sur_data, "SW and SUR Comparison"), width = 10, height = 6, units = "in", dpi = 600)
ggsave(paste0("GW_LAT_comparison_plot.png"), path = folder_out, plot = create_comparison_plot(gw_lat_data, "GW and LAT Comparison"), width = 10, height = 6, units = "in", dpi = 600)





# Combining into one figure
library(patchwork)

create_comparison_plot <- function(data, title) {
  max_y <- max(data$Q_mmPeryear, na.rm = TRUE)  # Calculate the maximum value of Q_mmPeryear
  min_y <- min(data$Q_mmPeryear, na.rm = TRUE)  # Calculate the minimum value of Q_mmPeryear
  y_range <- c(min_y, max_y)  # Create a vector with minimum and maximum y values
  
  ggplot(data = data, aes(x = Subbasins, y = Q_mmPeryear, color = Parameters, linetype = scenario_name)) +
    geom_point(size = 1) +
    geom_line(size = 0.5) +
    ylim(y_range) +  # Set y-axis limit to include both minimum and maximum values
    ggtitle(title) +
    theme_minimal() +
    theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
          text = element_text(size = 11)) +
    labs(x = "Subbasins", y = "Q (mm/year)", color = "Parameters", linetype = "Scenario") +
    scale_color_manual(values = parameter_colors) +  # Set consistent colors for each parameter
    scale_linetype_manual(values = c("Environ_bioenergy" = "longdash", "Environ" = "dashed","TMDL" = "dotted", "CRP" = "dotdash","Baseline" = "solid"))
}

et_plot <- create_comparison_plot(et_data, "ET Comparison") + theme(aspect.ratio = 1) + theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"))
sw_sur_plot <- create_comparison_plot(sw_sur_data, "SW and SUR Comparison") + theme(aspect.ratio = 1) + theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"))
gw_lat_plot <- create_comparison_plot(gw_lat_data, "GW and LAT Comparison") + theme(aspect.ratio = 1) + theme(plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"))

# Combine plots into one figure with subplots
combined_plot <- (et_plot / sw_sur_plot) / gw_lat_plot + plot_layout(ncol = 2)
ggsave("combined_comparison_plots.png", path = folder_out, plot = combined_plot, width = 20, height = 20, units = "in", dpi = 600)

