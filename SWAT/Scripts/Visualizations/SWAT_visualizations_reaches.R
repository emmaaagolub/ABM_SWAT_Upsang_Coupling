library(data.table)
library(ggplot2)
library(reshape2)
library(readr)
library(RColorBrewer)
library(patchwork)
library(gridExtra)
library(viridis)
library(dplyr)


# Initialize data sources
baseline_dir = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/baseline"
folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output"

directories = list("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ_only/MISG_exe4",
                "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ/MISG_exe4",
                "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/TMDL/MISG_exe4",
                "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/CRP/MISG_exe4",
                "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/baseline")

# directories = list("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/20percent",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/25percent",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/30percent",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/baseline")

# Data pre-processing
oreach_baseline <- read_csv(file.path(baseline_dir, "ReachAverageAnnual.csv"))
flow_baseline <- oreach_baseline[, c("RCH","FLOW_INcms", "FLOW_OUTcms")]
nutrients_baseline <- oreach_baseline[, c("RCH", "NO3_INkg", "NO3_OUTkg")]
nutrients_yield_baseline <- oreach_baseline[, c("RCH", "NitrateYiledkgha", "TPYiledkgha")]
chla_baseline <- oreach_baseline[, c("RCH", "CHLA_INkg","CHLA_OUTkg")]
cbod_baseline <- oreach_baseline[, c("RCH", "CBOD_INkg","CBOD_OUTkg")]
melted_nutrients_baseline <- melt(nutrients_baseline, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kg") 
melted_nutrients_yield_baseline <- melt(nutrients_yield_baseline, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kgha") # Melt the data for better plotting
melted_flow_baseline <- melt(flow_baseline, id.vars = "RCH", variable.name = "Variable", value.name = "Flow_cms")
melted_chla_baseline <- melt(chla_baseline, id.vars = "RCH", variable.name = "Variable", value.name = "CHLA_kg")
melted_cbod_baseline <- melt(cbod_baseline, id.vars = "RCH", variable.name = "Variable", value.name = "CBOD_kg")

for (dir in directories){
  oreach <- read_csv(file.path(dir, "ReachAverageAnnual.csv"))
  flow <- oreach[, c("RCH","FLOW_INcms", "FLOW_OUTcms")]
  nutrients <- oreach[, c("RCH", "NO3_INkg", "NO3_OUTkg")]
  nutrients_yield <- oreach[, c("RCH", "NitrateYiledkgha", "TPYiledkgha")]
  chla <- oreach[, c("RCH", "CHLA_INkg","CHLA_OUTkg")]
  cbod <- oreach[, c("RCH", "CBOD_INkg","CBOD_OUTkg")]
}
melted_nutrients <- melt(nutrients, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kg") 
melted_nutrients_yield <- melt(nutrients_yield, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kgha") # Melt the data for better plotting
melted_flow <- melt(flow, id.vars = "RCH", variable.name = "Variable", value.name = "Flow_cms")
melted_chla <- melt(chla, id.vars = "RCH", variable.name = "Variable", value.name = "CHLA_kg")
melted_cbod <- melt(cbod, id.vars = "RCH", variable.name = "Variable", value.name = "CBOD_kg")


#-----------------------------------------------------------------------------------------#
# PLOTTING INDIVIDUAL REACH
#-----------------------------------------------------------------------------------------#
# create_comparison_plot <- function(data, baseline_data, variable, y_label, filename) {
#   p <- ggplot() +
#     geom_line(data = data, aes(x = RCH, y = !!sym(variable), color = Variable, linetype = "Comparison"), size = 0.5) +
#     geom_line(data = baseline_data, aes(x = RCH, y = !!sym(variable), color = Variable, linetype = "Baseline"), size = 0.5, linetype = "dashed") +
#     labs(title = paste("Annual", variable, "Values by Reach"),
#          x = "Reach",
#          y = y_label) +
#     theme_minimal() +
#     theme(panel.grid.major = element_line(color = "gray", linetype = "dashed"),
#           axis.text.x = element_text(angle = 45, hjust = 1)) +
#     scale_x_discrete(breaks = seq(1, max(as.numeric(data$RCH)), by = 5)) +
#     facet_wrap(~ Variable, scales = "free_y")
#   
#   ggsave(filename, plot = p, width = 10, height = 6, units = "in", dpi = 300)
# }
# 
# # Create comparison plots
# create_comparison_plot(melted_nutrients, melted_nutrients_baseline, "Nutrients_kg", "Load (kg)", paste0(dir, "Reach_comparison_nutrients.png"))
# create_comparison_plot(melted_flow, melted_flow_baseline, "Flow_cms", "Flow (cms)", paste0(dir, "Reach_comparison_flow.png"))
# create_comparison_plot(melted_chla, melted_chla_baseline, "CHLA_kg", "Load (kg)", paste0(dir, "Reach_comparison_chla.png"))
# 

# #-----------------------------------------------------------------------------------------#
# # PLOTTING COMPARISON REACHES GROUPED ACROSS SCENARIO
# #-----------------------------------------------------------------------------------------#
# # Define a list to store data frames for each scenario
# all_scenario_flow_data <- list()
# all_scenario_nutrients_data <- list()
# all_scenario_nutrients_yield_data <- list()
# all_scenario_chla_data <- list()
# all_scenario_cbod_data <- list()
# 
# # Loop through scenario folders and preprocess and plot
# for (dir in directories){
#   oreach <- read_csv(file.path(dir, "ReachAverageAnnual.csv"))
#   flow <- oreach[, c("RCH","FLOW_INcms", "FLOW_OUTcms")]
#   nutrients <- oreach[, c("RCH", "NO3_INkg", "NO3_OUTkg")]
#   nutrients_yield <- oreach[, c("RCH", "NitrateYiledkgha", "TPYiledkgha")]
#   chla <- oreach[, c("RCH", "CHLA_INkg","CHLA_OUTkg")]
#   cbod <- oreach[, c("RCH", "CBOD_INkg","CBOD_OUTkg")]
#   melted_nutrients <- melt(nutrients, id.vars = "RCH", variable.name = "Variable_Nutrients_kg", value.name = "Nutrients_kg") 
#   melted_nutrients_yield <- melt(nutrients_yield, id.vars = "RCH", variable.name = "Variable_Nutrients_kgha", value.name = "Nutrients_kgha") # Melt the data for better plotting
#   melted_flow <- melt(flow, id.vars = "RCH", variable.name = "Variable_Flow_cms", value.name = "Flow_cms")
#   melted_chla <- melt(chla, id.vars = "RCH", variable.name = "Variable_CHLA_kg", value.name = "CHLA_kg")
#   melted_cbod <- melt(cbod, id.vars = "RCH", variable.name = "Variable_CBOD_kg", value.name = "CBOD_kg")
#   # Store scenario data in the list with scenario directory name as list element name
#   all_scenario_flow_data[[dir]] <- melted_flow
#   all_scenario_nutrients_data[[dir]] <- melted_nutrients
#   all_scenario_nutrients_yield_data[[dir]] <- melted_nutrients_yield
#   all_scenario_chla_data[[dir]] <- melted_chla
#   all_scenario_cbod_data[[dir]] <- melted_cbod
#   
# }
# # Combine all scenario data into a single data frame
# all_data_flow <- do.call(rbind, all_scenario_flow_data)
# all_data_nutrients <- do.call(rbind, all_scenario_nutrients_data)
# all_data_nutrients_yield <- do.call(rbind, all_scenario_nutrients_yield_data)
# all_data_chla <- do.call(rbind, all_scenario_chla_data)
# all_data_cbod <- do.call(rbind, all_scenario_cbod_data)
# 
# # Define scenario names #*********************************************************************************************************************************************
# #scenario_names <- c("20%", "25%", "30%", "Baseline")
# scenario_names <- c("Environ", "Environ_bioenergy", "TMDL", "CRP", "Baseline")
# 
# # Add scenario name to the data
# all_data_flow$scenario_name <- rep(scenario_names, each = nrow(all_data_flow) / length(scenario_names))
# all_data_nutrients$scenario_name <- rep(scenario_names, each = nrow(all_data_nutrients) / length(scenario_names))
# all_data_nutrients_yield$scenario_name <- rep(scenario_names, each = nrow(all_data_nutrients_yield) / length(scenario_names))
# all_data_chla$scenario_name <- rep(scenario_names, each = nrow(all_data_chla) / length(scenario_names))
# all_data_cbod$scenario_name <- rep(scenario_names, each = nrow(all_data_cbod) / length(scenario_names))
# 
# # Plotting function
# plot_data <- function(data, title, ylab, filename) {
#   set3_palette <- brewer.pal(12, "Paired")[1:10] # Extract first 10 colors from Set3 palette
#   color_mapping <- c("FLOW_INcms" = set3_palette[1], 
#                      "FLOW_OUTcms" = set3_palette[2],
#                      "NO3_INkg" = set3_palette[3],
#                      "NO3_OUTkg" = set3_palette[4],
#                      "NitrateYiledkgha" = set3_palette[5],
#                      "TPYiledkgha" = set3_palette[6],
#                      "CHLA_INkg" = set3_palette[7],
#                      "CHLA_OUTkg" = set3_palette[8],
#                      "CBOD_INkg" = set3_palette[9],
#                      "CBOD_OUTkg" = set3_palette[10])
#     ggplot(data) +
#     geom_line(aes(x = RCH, y = .data[[ylab]], color = .data[[paste0("Variable_", ylab)]], linetype = scenario_name), size = 0.5) +
#     labs(title = title,
#          x = "Reach",
#          y = ylab) +
#     theme_minimal() +
#     theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
#           text = element_text(size = 11)) +
#     scale_x_discrete(breaks = seq(1, max(as.numeric(data$RCH)), by = 5)) +
#     scale_color_manual(values = color_mapping) +  # Manually assign colors based on variables
#     #scale_linetype_manual(values = c("20%" = "dotdash", "25%" = "dashed", "30%" = "dotted", "Baseline" = "solid")) +
#     scale_linetype_manual(values = c("Environ" = "dotdash", "Environ_bioenergy" = "dashed", "TMDL" = "dotted", "CRP" = "longdash", "Baseline" = "solid")) +
#     facet_wrap(~ .data[[paste0("Variable_", ylab)]], scales = "free_y")  # Facet by variable name
# }
# 
# 
# # Create plots
# plot1 <- plot_data(all_data_nutrients, "Annual Nutrient Values by Reach", "Nutrients_kg", "Reach_comparison_nutrients_grouped.png")
# plot2 <- plot_data(all_data_nutrients_yield, "Annual Nutrient Yield Values by Reach", "Nutrients_kgha", "Reach_comparison_nutrients_yield_grouped.png")
# plot3 <- plot_data(all_data_flow, "Annual Flow Values by Reach", "Flow_cms", "Reach_comparison_flow_grouped.png")
# plot4 <- plot_data(all_data_chla, "Annual CHLA Values by Reach", "CHLA_kg", "Reach_comparison_chla_grouped.png")
# plot5 <- plot_data(all_data_cbod, "Annual CBOD Values by Reach", "CBOD_kg", "Reach_comparison_cbod_grouped.png")
# 
# # Combine plots into subplots
# combined_plots <- grid.arrange(plot1, plot2, plot3, plot4, plot5, ncol = 3)
# 
# # Save combined plot #*********************************************************************************************************************************************
# ggsave(paste0(dir, "combined_plots_policy_scenarios.png"), combined_plots, width = 25, height = 10, units = "in", dpi = 600)
# #ggsave(paste0(dir, "combined_plots_weighted.png"), combined_plots, width = 25, height = 10, units = "in", dpi = 600)
# 
# # ALSO
# plot1 <- plot_data(all_data_nutrients, "Annual Nutrient Values by Reach", "Nutrients_kg")
# plot2 <- plot_data(all_data_nutrients_yield, "Annual Nutrient Yield Values by Reach", "Nutrients_kgha")
# plot3 <- plot_data(all_data_flow, "Annual Flow Values by Reach", "Flow_cms")
# plot4 <- plot_data(all_data_chla, "Annual CHLA Values by Reach", "CHLA_kg")
# plot5 <- plot_data(all_data_cbod, "Annual CBOD Values by Reach", "CBOD_kg")
# 
# # Arrange the plots
# combined_plots2 <- (
#   (plot1 / plot2) /
#     plot3
# ) /
#   plot4 +
#   plot5
# 
# # Save combined plot
# ggsave(paste0(dir, "combined_plots_policy_scenarios2.png"), combined_plots2, width = 20, height = 20, units = "in", dpi = 600)
# #ggsave(paste0(dir, "combined_plots_policy_weighted2.png"), combined_plots2, width = 20, height = 20, units = "in", dpi = 600)

#-----------------------------------------------------------------------------------------#
# PLOTTING COMPARISON REACHES GROUPED ACROSS SCENARIO V2
#-----------------------------------------------------------------------------------------#

# Define a list to store data frames for each scenario
all_scenario_flow_data <- list()
all_scenario_nutrients_data <- list()
all_scenario_nutrients_yield_data <- list()
all_scenario_chla_data <- list()
all_scenario_cbod_data <- list()

# Loop through scenario folders and preprocess and plot
for (dir in directories) {
  oreach <- read_csv(file.path(dir, "ReachAverageAnnual.csv"))
  flow <- oreach[, c("RCH", "FLOW_INcms", "FLOW_OUTcms")]
  nutrients <- oreach[, c("RCH", "NO3_INkg", "NO3_OUTkg")]
  nutrients_yield <- oreach[, c("RCH", "NitrateYiledkgha", "TPYiledkgha")]
  chla <- oreach[, c("RCH", "CHLA_INkg", "CHLA_OUTkg")]
  cbod <- oreach[, c("RCH", "CBOD_INkg", "CBOD_OUTkg")]
  melted_nutrients <- melt(nutrients, id.vars = "RCH", variable.name = "Variable_Nutrients_kg", value.name = "Nutrients_kg")
  melted_nutrients_yield <- melt(nutrients_yield, id.vars = "RCH", variable.name = "Variable_Nutrients_kgha", value.name = "Nutrients_kgha") # Melt the data for better plotting
  melted_flow <- melt(flow, id.vars = "RCH", variable.name = "Variable_Flow_cms", value.name = "Flow_cms")
  melted_chla <- melt(chla, id.vars = "RCH", variable.name = "Variable_CHLA_kg", value.name = "CHLA_kg")
  melted_cbod <- melt(cbod, id.vars = "RCH", variable.name = "Variable_CBOD_kg", value.name = "CBOD_kg")
  # Store scenario data in the list with scenario directory name as list element name
  all_scenario_flow_data[[dir]] <- melted_flow
  all_scenario_nutrients_data[[dir]] <- melted_nutrients
  all_scenario_nutrients_yield_data[[dir]] <- melted_nutrients_yield
  all_scenario_chla_data[[dir]] <- melted_chla
  all_scenario_cbod_data[[dir]] <- melted_cbod
  
}
# Combine all scenario data into a single data frame
all_data_flow <- do.call(rbind, all_scenario_flow_data)
all_data_nutrients <- do.call(rbind, all_scenario_nutrients_data)
all_data_nutrients_yield <- do.call(rbind, all_scenario_nutrients_yield_data)
all_data_chla <- do.call(rbind, all_scenario_chla_data)
all_data_cbod <- do.call(rbind, all_scenario_cbod_data)

# Define scenario names
scenario_names <- c("Environ", "Environ_bioenergy", "TMDL", "CRP", "Baseline")
#scenario_names <- c("20%", "25%", "30%", "Baseline")

# Add scenario name to the data
all_data_flow$scenario_name <- rep(scenario_names, each = nrow(all_data_flow) / length(scenario_names))
all_data_nutrients$scenario_name <- rep(scenario_names, each = nrow(all_data_nutrients) / length(scenario_names))
all_data_nutrients_yield$scenario_name <- rep(scenario_names, each = nrow(all_data_nutrients_yield) / length(scenario_names))
all_data_chla$scenario_name <- rep(scenario_names, each = nrow(all_data_chla) / length(scenario_names))
all_data_cbod$scenario_name <- rep(scenario_names, each = nrow(all_data_cbod) / length(scenario_names))

# Plotting function
plot_data <- function(data, ylab, filename) {
  palette <- brewer.pal(8, "Set2")[1:10] # Extract first 10 colors from Set3 palette
  color_mapping <- c("Environ" = palette[1],
                     "Environ_bioenergy" = palette[2],
                     "TMDL" = palette[3],
                     "CRP" = palette[4],
                    "Baseline" = palette[5])
  # color_mapping <- c("20%" = palette[6],
  #                    "25%" = palette[7],
  #                    "30%" = palette[8],
  #                    "Baseline" = palette[5])
  
  ggplot(data) +
    geom_line(aes(x = RCH, y = .data[[ylab]], color = scenario_name), size = 0.75) +
    labs(x = " ",
         y = ylab) +
    theme_minimal() +
    theme(axis.text.x = element_text(hjust = 0.5),  # Center x-axis labels
          strip.text = element_blank(),  # Remove strip labels
          text = element_text(size = 11)) +
    scale_x_continuous(breaks = unique(data$RCH)) +  # Include tick marks along the x-axis
    scale_color_manual(values = color_mapping) +  # Manually assign colors based on scenario
    #facet_wrap(~ .data[[paste0("Variable_", ylab)]], scales = "free_y")  # Facet by variable name
    facet_wrap(~ .data[[paste0("Variable_", ylab)]], scales = "free_y") 
}

# Create plots
plot1 <- plot_data(all_data_nutrients, "Nutrients_kg", "Reach_comparison_nutrients_grouped.png")
plot2 <- plot_data(all_data_nutrients_yield, "Nutrients_kgha", "Reach_comparison_nutrients_yield_grouped.png")
plot3 <- plot_data(all_data_flow, "Flow_cms", "Reach_comparison_flow_grouped.png")
plot4 <- plot_data(all_data_chla, "CHLA_kg", "Reach_comparison_chla_grouped.png")
plot5 <- plot_data(all_data_cbod, "CBOD_kg", "Reach_comparison_cbod_grouped.png")

# Rename y-axis labels manually
plot1 <- plot1 + ylab("kg") + labs(color = "Scenario Name")
plot2 <- plot2 + ylab("kg/ha") + labs(color = "Scenario Name")
plot3 <- plot3 + ylab("cms") + labs(color = "Scenario Name")
plot4 <- plot4 + ylab("kg") + labs(color = "Scenario Name")
plot5 <- plot5 + ylab("kg") + labs(color = "Scenario Name")

# Add titles to each subplot
plot1 <- plot1 + ggtitle("NO3 In                                                                                                                                                                                      NO3 Out") + theme(plot.title = element_text(hjust = 0.5, size = 12))
plot2 <- plot2 + ggtitle("NO3 Yield                                                                                                                                                                                      TP Yield") + theme(plot.title = element_text(hjust = 0.5, size = 12))
plot3 <- plot3 + ggtitle("Flow In                                                                                                                                                                                      Flow Out") + theme(plot.title = element_text(hjust = 0.5, size = 12))
plot4 <- plot4 + ggtitle("CHLA In                                                                                                                                                                                       CHLA Out") + theme(plot.title = element_text(hjust = 0.5, size = 12))
plot5 <- plot5 + ggtitle("CBOD In                                                                                                                                                                                      CBOD Out") + theme(plot.title = element_text(hjust = 0.5, size = 12))

# Arrange the plots
combined_plots <- (
  (plot1 / plot2) /
    plot3
) /
  plot4 +
  plot5 +
  labs(x = "Reach") + # Add an overarching x-label at the bottom
  theme(axis.title.x = element_text(size = 20, hjust = 0.5))  # Adjust x-axis label size and centering

# Save combined plot
ggsave(paste0(dir, "combined_plots_policy_scenarios.png"), combined_plots, width = 20, height = 20, units = "in", dpi = 600)
#ggsave(paste0(dir, "combined_plots_weighted_scenarios.png"), combined_plots, width = 20, height = 20, units = "in", dpi = 600)


# # ------------------------------------------------------------------------------
# # BOX PLOTS by SCENARIO (so each figure is for each scenario)
# # ------------------------------------------------------------------------------
# library(data.table)
# library(ggplot2)
# library(reshape2)
# library(readr)
# library(stringr)
# 
# # Initialize data sources
# baseline_dir <- "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/baseline"
# folder_out <- "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output"
# 
# directories <- list(
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ_only/MISG_exe4",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ/MISG_exe4",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/TMDL/MISG_exe4",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/CRP/MISG_exe4",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/20percent",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/25percent",
#   "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/30percent",
#   baseline_dir
# )
# 
# all_boxplot_data <- data.frame()
# 
# # Loop through scenario folders and preprocess and plot
# for (dir in directories){
#   oreach <- read_csv(file.path(dir, "ReachAverageAnnual.csv"))
#   boxplot_data <- oreach[, c("RCH", "FLOW_INcms", "FLOW_OUTcms", "NO3_INkg", "NO3_OUTkg", "TPYiledkgha", "CHLA_INkg", "CHLA_OUTkg", "CBOD_INkg", "CBOD_OUTkg")]
#   melted_boxplot_data <- melt(boxplot_data, id.vars = "RCH", variable.name = "Parameter", value.name = "Value") 
#   # Extract scenario name from directory path
#   scenario_name <- tail(unlist(strsplit(dir, "/")), 1)[1]
#   
#   # Check if scenario is one of the predefined scenarios and is not "output"
#   if (scenario_name %in% c("baseline", "20percent", "25percent", "30percent") && scenario_name != "output") {
#     melted_boxplot_data$Scenario <- scenario_name
#     all_boxplot_data <- rbind(all_boxplot_data, melted_boxplot_data)
#   }
#   
#   # Extract scenario name from directory path
#   scenario_name <- tail(unlist(strsplit(dir, "/")), 2)[1]
#   
#   # Check if scenario is one of the predefined scenarios and is not "output"
#   if (any(scenario_name %in% c("Environ_only", "Environ", "TMDL", "CRP"))) {
#     melted_boxplot_data$Scenario <- scenario_name
#     all_boxplot_data <- rbind(all_boxplot_data, melted_boxplot_data)
#   }
# }
# # Define parameters for subboxplots
# parameters <- c("FLOW_INcms", "FLOW_OUTcms", "NO3_INkg", "NO3_OUTkg", "TPYiledkgha", "CHLA_INkg", "CHLA_OUTkg", "CBOD_INkg", "CBOD_OUTkg")
# 
# # Define color mapping
# palette <- brewer.pal(12, "Set3")[1:8] # Extract first 5 colors from Set3 palette
# color_mapping <- c("Environ_only" = palette[1], 
#                    "Environ" = palette[2],
#                    "TMDL" = palette[3],
#                    "CRP" = palette[4],
#                    "baseline" = palette[5],
#                    "20percent" = palette[6],
#                    "25percent" = palette[7],
#                    "30percent" = palette[8])
# 
# # Function to calculate maximum non-outlier value for a parameter
# calculate_max_non_outlier <- function(parameter_name, boxplot_data) {
#   # Extract data for the parameter
#   parameter_data <- boxplot_data[boxplot_data$Parameter == parameter_name, "Value"]
#   # Calculate outliers
#   outliers <- boxplot.stats(parameter_data)$out
#   # Calculate maximum non-outlier value
#   max_non_outlier <- max(parameter_data[!parameter_data %in% outliers])
#   return(max_non_outlier)
# }
# 
# # Create a list to store plots for each parameter
# plots <- list()
# 
# # Loop through parameters and create subboxplots
# for (param in parameters) {
#   p <- ggplot(all_boxplot_data[all_boxplot_data$Parameter == param,], aes(x = RCH, y = Value, fill = Scenario)) +
#     geom_boxplot(width = 0.5, outlier.shape = NA) +  # Remove outliers
#     #geom_boxplot(width = 0.5) +
#     labs(title = param,             # Use parameter name as title
#          fill = NULL,              # No legend title
#          y = "", x = "") +        # Remove axis labels
#     theme_minimal() +
#     theme(axis.text.x = element_blank(),  # Remove x-axis labels
#           legend.position = "bottom") +
#     scale_fill_manual(values = color_mapping) +  # Use custom color palette
#     scale_y_continuous(labels = scales::scientific) + # Scientific notation for y-axis
#     #facet_wrap(~ Null, scales = "free")  # Add x-axis labels for each scenario
#     coord_cartesian(ylim = c(0, calculate_max_non_outlier(param, all_boxplot_data)))
#   
#   
#   plots[[param]] <- p
# }
# 
# # Arrange subboxplots in line
# final_plot <- wrap_plots(plots, axes_titles = collect)
# 
# ggsave(paste0(folder_out, "/comparison_boxplot_no_outliers.png"),
#        final_plot, width = 15, height = 10, units = "in", dpi = 600)


# ------------------------------------------------------------------------------
# BOX PLOTS by SCENARIO v2 (so each figure is for each scenario), axes adjusted
# ------------------------------------------------------------------------------
library(data.table)
library(ggplot2)
library(reshape2)
library(readr)
library(stringr)
library(cowplot)

# Initialize data sources
baseline_dir <- "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/baseline"
folder_out <- "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output"

directories <- list(
  "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ_only/MISG_exe4",
  "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ/MISG_exe4",
  "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/TMDL/MISG_exe4",
  "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/CRP/MISG_exe4",
  "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/20percent",
  "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/25percent",
  "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Weighted/30percent",
  baseline_dir
)

all_boxplot_data <- data.frame()

# Loop through scenario folders and preprocess and plot
for (dir in directories){
  oreach <- read_csv(file.path(dir, "ReachAverageAnnual.csv"))
  boxplot_data <- oreach[, c("RCH", "FLOW_INcms", "FLOW_OUTcms", "NO3_INkg", "NO3_OUTkg", "TPYiledkgha", "CHLA_INkg", "CHLA_OUTkg", "CBOD_INkg", "CBOD_OUTkg")]
  melted_boxplot_data <- melt(boxplot_data, id.vars = "RCH", variable.name = "Parameter", value.name = "Value") 
  # Extract scenario name from directory path
  scenario_name <- tail(unlist(strsplit(dir, "/")), 1)[1]
  
  # Check if scenario is one of the predefined scenarios and is not "output"
  if (scenario_name %in% c("baseline", "20percent", "25percent", "30percent") && scenario_name != "output") {
    melted_boxplot_data$Scenario <- scenario_name
    all_boxplot_data <- rbind(all_boxplot_data, melted_boxplot_data)
  }
  
  # Extract scenario name from directory path
  scenario_name <- tail(unlist(strsplit(dir, "/")), 2)[1]
  
  # Check if scenario is one of the predefined scenarios and is not "output"
  if (any(scenario_name %in% c("Environ_only", "Environ", "TMDL", "CRP"))) {
    melted_boxplot_data$Scenario <- scenario_name
    all_boxplot_data <- rbind(all_boxplot_data, melted_boxplot_data)
  }
}
# Define parameters for subboxplots
parameters <- c("FLOW_INcms", "FLOW_OUTcms", "NO3_INkg", "NO3_OUTkg", "TPYiledkgha", "CHLA_INkg", "CHLA_OUTkg", "CBOD_INkg", "CBOD_OUTkg")

# Define color mapping
palette <- brewer.pal(8, "Set2")[1:8] 
color_mapping <- c("Environ_only" = palette[1], 
                   "Environ" = palette[2],
                   "TMDL" = palette[3],
                   "CRP" = palette[4],
                   "baseline" = palette[5],
                   "20percent" = palette[6],
                   "25percent" = palette[7],
                   "30percent" = palette[8])

# Function to calculate maximum non-outlier value for a parameter
calculate_max_non_outlier <- function(parameter_name, boxplot_data) {
  # Extract data for the parameter
  parameter_data <- boxplot_data[boxplot_data$Parameter == parameter_name, "Value"]
  # Calculate outliers
  outliers <- boxplot.stats(parameter_data)$out
  # Calculate maximum non-outlier value
  max_non_outlier <- max(parameter_data[!parameter_data %in% outliers])
  return(max_non_outlier)
}

# Create a list to store plots for each parameter
plots <- list()

# Loop through parameters and create subboxplots
for (param in parameters) {
  p <- ggplot(all_boxplot_data[all_boxplot_data$Parameter == param,], aes(x = RCH, y = Value, fill = Scenario)) +
    geom_boxplot(width = 0.5, outlier.shape = NA) +  # Remove outliers
    #geom_boxplot(width = 0.5) +
    labs(title = param,             # Use parameter name as title
         fill = NULL,              # No legend title
         y = "", x = "") +        # Remove axis labels
    theme_minimal() +
    theme(axis.text.x = element_blank(),  # Remove x-axis labels
          legend.position = "none") +
    scale_fill_manual(values = color_mapping) +  # Use custom color palette
    scale_y_continuous(labels = scales::scientific) + # Scientific notation for y-axis
    #facet_wrap(~ Null, scales = "free")  # Add x-axis labels for each scenario
    coord_cartesian(ylim = c(0, calculate_max_non_outlier(param, all_boxplot_data)))
  
  
  plots[[param]] <- p
}



# Define the titles for the subboxplots
titles <- c("Flow In", "Flow Out", "NO3 In", "NO3 Out", "TP Yield", "CHLA In", "CHLA Out", "CBOD In", "CBOD Out")
units <- c("cms", "cms", "kg", "kg", "kg/ha", "kg", "kg", "kg", "kg")

# Loop through the plots and rename the titles
for (i in seq_along(plots)) {
  plots[[i]] <- plots[[i]] + labs(title = titles[i])
}

for (i in seq_along(plots)) {
  plots[[i]] <- plots[[i]] + ylab(units[i])
}

x_axis_labels <- c("Environ_only" = "Environ", 
                   "Environ" = "Environ Bioenergy",
                   "TMDL" = "TMDL",
                   "CRP" = "CRP",
                   "baseline" = "Baseline",
                   "20percent" = "20% Weighted",
                   "25percent" = "25% Weighted",
                   "30percent" = "30% Weighted")

final_plot <- wrap_plots(plots, axes_titles = collect)

# Add a manual legend to the final plot
final_plot <- final_plot +
  theme(legend.position = "bottom",         # Position legend at the bottom
        legend.justification = "center",    # Center the legend horizontally
        legend.direction = "horizontal",   # Display legend in a single row
        legend.box.just = "center",        # Center the legend box horizontally
        legend.key.size = unit(2, "lines")) +  # Enlarge the legend key 
  scale_x_discrete(labels = x_axis_labels) +
  scale_fill_manual(values = color_mapping, labels = x_axis_labels)

final_plot
ggsave(paste0(folder_out, "/comparison_boxplot_no_outliers.png"),
       final_plot, width = 18, height = 10, units = "in", dpi = 600)

# # ------------------------------------------------------------------------------
# # BARPLOTS
# # ------------------------------------------------------------------------------
# # Define color mapping
# palette <- brewer.pal(8, "Set2")[1:8] 
# color_mapping <- c("Environ_only" = palette[1], 
#                    "Environ" = palette[2],
#                    "TMDL" = palette[3],
#                    "CRP" = palette[4],
#                    "baseline" = palette[5],
#                    "20percent" = palette[6],
#                    "25percent" = palette[7],
#                    "30percent" = palette[8])
# 
# data <- "ReachAverageAnnualAverages	FLOW_INcms	FLOW_OUTcms	NO3_INkg	NO3_OUTkg	CHLA_INkg	CHLA_OUTkg	CBOD_INkg	CBOD_OUTkg	WaterYiledmm	NitrateYiledkgha	TPYiledkgha
# Baseline	6.224112528	6.199260986	1481500.106	1482473.017	2515.694038	1446.044452	261258.8226	102840.49	299.1420078	25.2131562	1.046029929
# Environ	6.106937278	6.082181236	1330458.159	1331050.821	2243.42894	1296.850401	203465.1374	79081.42278	292.5914573	22.22125536	0.937566807
# EnvironOnly	6.105379444	6.080452875	1334431.38	1335079.489	2263.983024	1309.109301	210887.0188	82618.14319	293.0080556	22.40411636	0.949844387
# CRP	6.102882125	6.077998694	1313296.989	1314012.426	2257.920778	1308.107088	210563.8788	82019.80389	291.9598435	21.60041409	0.948476812
# TMDL	6.104849931	6.079979986	1318917.766	1319623.997	2266.292801	1311.607901	211750.9054	82393.75847	292.06224	21.76282126	0.94783441
# Weighted20%	5.993714972	5.969035639	1159105.191	1159387.486	2092.371828	1212.83328	202212.8528	78770.27458	288.1156537	19.61876542	0.897965008
# Weighted25%	5.953596306	5.928929639	1104478.588	1104654.752	1993.900775	1165.066046	183335.5781	72095.22939	285.7619805	18.43866829	0.865015045
# Weighted30%	5.945211389	5.920507681	1083597.498	1083788.305	1982.686281	1159.897035	189653.7069	75419.55518	285.6382334	18.15020673	0.87699788"
# 
# # Convert the data to a data frame
# data_df <- read.table(text=data, header=TRUE, sep="\t")
# 
# # Melt the data to long format for plotting
# data_long <- melt(data_df, id.vars = "ReachAverageAnnualAverages", variable.name = "Parameter", value.name = "Value")
# 
# ggplot(data_long, aes(x = ReachAverageAnnualAverages, y = Value, fill = Parameter)) +
#   geom_bar(data = subset(data_long, ReachAverageAnnualAverages != "Baseline"), stat = "identity", position = "dodge") +
#   geom_hline(data = subset(data_long, ReachAverageAnnualAverages == "Baseline"), aes(yintercept = Value, linetype = "Baseline"), color = "black") +
#   scale_linetype_manual(values = "dashed", guide = FALSE) +  # Ensure dashed linetype
#   facet_wrap(~Parameter, scales = "free_y") +
#   theme(axis.text.x = element_text(angle = 45, hjust = 1),
#         strip.background = element_blank()) +
#   labs(x = "Scenario", y = "Average Annual Value") +
#   scale_y_continuous(labels = scales::scientific) +
#   scale_color_manual(values = color_mapping) +  # Use custom color palette
#   guides(fill = FALSE, linetype = guide_legend(title = "Baseline", override.aes = list(fill = NA)))
# 
# ggsave(paste0(folder_out, "/Reach_avg_ann_avg_scenario_barplots.png"),
#          width = 17, height = 10, units = "in", dpi = 600)
# 

# ------------------------------------------------------------------------------
# BARPLOTS V2 combining In/Out barplots
# ------------------------------------------------------------------------------
data <- "ReachAverageAnnualAverages	FLOW_INcms	FLOW_OUTcms	NO3_INkg	NO3_OUTkg	CHLA_INkg	CHLA_OUTkg	CBOD_INkg	CBOD_OUTkg	WaterYiledmm	NitrateYiledkgha	TPYiledkgha
Baseline	6.224112528	6.199260986	1481500.106	1482473.017	2515.694038	1446.044452	261258.8226	102840.49	299.1420078	25.2131562	1.046029929
Environ	6.106937278	6.082181236	1330458.159	1331050.821	2243.42894	1296.850401	203465.1374	79081.42278	292.5914573	22.22125536	0.937566807
EnvironOnly	6.105379444	6.080452875	1334431.38	1335079.489	2263.983024	1309.109301	210887.0188	82618.14319	293.0080556	22.40411636	0.949844387
CRP	6.102882125	6.077998694	1313296.989	1314012.426	2257.920778	1308.107088	210563.8788	82019.80389	291.9598435	21.60041409	0.948476812
TMDL	6.104849931	6.079979986	1318917.766	1319623.997	2266.292801	1311.607901	211750.9054	82393.75847	292.06224	21.76282126	0.94783441
Weighted20%	5.993714972	5.969035639	1159105.191	1159387.486	2092.371828	1212.83328	202212.8528	78770.27458	288.1156537	19.61876542	0.897965008
Weighted25%	5.953596306	5.928929639	1104478.588	1104654.752	1993.900775	1165.066046	183335.5781	72095.22939	285.7619805	18.43866829	0.865015045
Weighted30%	5.945211389	5.920507681	1083597.498	1083788.305	1982.686281	1159.897035	189653.7069	75419.55518	285.6382334	18.15020673	0.87699788"

# Convert the data to a data frame
data_df <- read.table(text=data, header=TRUE, sep="\t")

# Melt the data to long format for plotting
data_long <- melt(data_df, id.vars = "ReachAverageAnnualAverages", variable.name = "Parameter", value.name = "Value")

# Extract "In" or "Out" from Parameter
data_long$InOut <- gsub(".*(IN|OUT).*", "\\1", data_long$Parameter)
data_long$Parameter <- gsub("_INkg|_OUTkg", "", data_long$Parameter)
data_long$Parameter <- gsub("_INcms|_OUTcms", "", data_long$Parameter)
data_long$InOut <- factor(data_long$InOut, levels = c("IN", "OUT"))

data_long_filtered <- subset(data_long, Parameter != "WaterYiledmm")

# Custom color palette
palette <- brewer.pal(8, "Set2")[1:8] 
color_mapping <- c("EnvironOnly" = palette[1], 
                   "Environ" = palette[2],
                   "TMDL" = palette[3],
                   "CRP" = palette[4],
                   "Baseline" = palette[5],
                   "Weighted20%" = palette[6],
                   "Weighted25%" = palette[7],
                   "Weighted30%" = palette[8])
color_mapping2 <- c("OUT" = "black")

ggplot(data_long_filtered, aes(x = ReachAverageAnnualAverages, y = Value, color = InOut, fill = ReachAverageAnnualAverages)) +
  #geom_bar(data = subset(data_long_filtered, ReachAverageAnnualAverages != "Baseline"), stat = "identity", position = "dodge") +
  geom_bar(data = subset(data_long_filtered), stat = "identity", position = "dodge") +
  geom_hline(data = subset(data_long_filtered, ReachAverageAnnualAverages == "Baseline"), aes(yintercept = Value, linetype = "Baseline"), color = "black") +
  scale_linetype_manual(values = "dashed", guide = "none") +  # Ensure dashed linetype
  facet_grid(Parameter ~ ., scales = "free_y", drop = TRUE, labeller = labeller(Parameter = c(
    "CBOD" = "CBOD (kg)",
    "CHLA" = "CHLA (kg)",
    "FLOW" = "Flow (cms)",
    "NitrateYiledkgha" = "NO3 Yield (kg/ha)",
    "NO3" = "NO3 (kg)",
    "TPYiledkgha" = "TP Yield (kg/ha)"))) +   
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        strip.background = element_blank()) +
  labs(x = "Scenario", y = "Reach-Averaged Annually Averaged Value") +
  scale_y_continuous(labels = scales::scientific) +
  scale_color_manual(values = color_mapping2, guide = "none") +  # Set outline colors
  scale_fill_manual(values = color_mapping) +  # Set fill colors based on color_mapping
  guides(fill = FALSE, linetype = "none") + #guide_legend(title = "Baseline", override.aes = list(fill = NA))) +
  scale_x_discrete(labels = c("Baseline","CRP","Environ Bioenergy", "Environ","TMDL", "20% Weighted", "25% Weighted", "30% Weighted"))

# Save the plot
ggsave(paste0(folder_out, "/Reach_avg_ann_avg_scenario_barplots.png"),
       width = 15, height = 15, units = "in", dpi = 600)


