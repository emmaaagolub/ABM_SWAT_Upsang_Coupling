library(data.table)
library(ggplot2)
library(reshape2)
library(readr)
library(RColorBrewer)
library(patchwork)


# Function to read data from CSV
read_reach_data <- function(directory) {
  oreach <- read_csv(file.path(directory, "ReachAverageAnnual.csv"))
  return(oreach)
}

# Function to preprocess data
preprocess_data <- function(data) {
  flow <- data[, c("RCH","FLOW_INcms", "FLOW_OUTcms")]
  nutrients <- data[, c("RCH", "NO3_INkg", "NO3_OUTkg")]
  nutrients_yield <- data[, c("RCH", "NitrateYiledkgha", "TPYiledkgha")]
  chla <- data[, c("RCH", "CHLA_INkg","CHLA_OUTkg")]
  cbod <- data[, c("RCH", "CBOD_INkg","CBOD_OUTkg")]
  
  melted_nutrients <- melt(nutrients, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kg") 
  melted_nutrients_yield <- melt(nutrients_yield, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kgha")
  melted_flow <- melt(flow, id.vars = "RCH", variable.name = "Variable", value.name = "Flow_cms")
  melted_chla <- melt(chla, id.vars = "RCH", variable.name = "Variable", value.name = "CHLA_kg")
  melted_cbod <- melt(cbod, id.vars = "RCH", variable.name = "Variable", value.name = "CBOD_kg")
  
  return(list(melted_flow = melted_flow,
              melted_nutrients = melted_nutrients,
              melted_nutrients_yield = melted_nutrients_yield,
              melted_chla = melted_chla,
              melted_cbod = melted_cbod))
}

# Function to plot grouped comparisons
plot_grouped_comparison <- function(data, title, x_label, y_label, filename) {
  p <- ggplot(data) +
    geom_line(aes(x = RCH, y = value, color = Variable, linetype = scenario_name), size = 0.3) +
    labs(title = title,
         x = x_label,
         y = y_label) +
    theme_minimal() +
    theme(axis.text.x = element_text(hjust = 1), 
          text = element_text(size = 11)) +
    scale_x_discrete(breaks = seq(1, max(as.numeric(data$RCH)), by = 5)) +
    scale_linetype_manual(values = c("Environ_bioenergy" = "solid", "Environ" = "dashed","TMDL" = "dotted", "CRP" = "dotdash","Baseline" = "longdash")) +
    facet_wrap(~ Variable, scales = "free_y")
  
  ggsave(filename, plot = p, width = 10, height = 6, units = "in", dpi = 600)
}

# Function to create individual boxplot for each parameter
create_boxplot <- function(parameter_name, boxplot_data, baseline_data, folder_out) {
  baseline_parameter_data <- baseline_data[baseline_data$Parameter == parameter_name, ]
  y_limits <- c(min(baseline_parameter_data$Value), max(baseline_parameter_data$Value))
  
  p <- ggplot(boxplot_data, aes(x = RCH, y = Value, fill = Parameter)) +
    geom_boxplot(width = 0.5) +
    labs(title = NULL, 
         fill = NULL, 
         y = "", x = "") +
    theme_minimal() +
    theme(axis.text.x = element_blank(), 
          legend.position = "bottom") +
    scale_fill_manual(values = parameter_colors) +
    scale_y_continuous(labels = scales::scientific, limits = y_limits)
  
  ggsave(paste0(folder_out, "/Reach_comparison_boxplot_", scenario, ".png"),
         plot = p, width = 20, height = 6, units = "in", dpi = 300)
}




process_directory <- function(directory) {
  # Import data from the specified directory
  oreach <- read_csv(file.path(directory, "ReachAverageAnnual.csv"))
  
  # Extract relevant columns
  flow <- oreach[, c("RCH", "FLOW_INcms", "FLOW_OUTcms")]
  nutrients <- oreach[, c("RCH", "NO3_INkg", "NO3_OUTkg")]
  nutrients_yield <- oreach[, c("RCH", "NitrateYiledkgha", "TPYiledkgha")]
  chla <- oreach[, c("RCH", "CHLA_INkg", "CHLA_OUTkg")]
  cbod <- oreach[, c("RCH", "CBOD_INkg", "CBOD_OUTkg")]
  
  # Melt the data for better plotting
  melted_nutrients <- melt(nutrients, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kg") 
  melted_nutrients_yield <- melt(nutrients_yield, id.vars = "RCH", variable.name = "Variable", value.name = "Nutrients_kgha")
  melted_flow <- melt(flow, id.vars = "RCH", variable.name = "Variable", value.name = "Flow_cms")
  melted_chla <- melt(chla, id.vars = "RCH", variable.name = "Variable", value.name = "CHLA_kg")
  melted_cbod <- melt(cbod, id.vars = "RCH", variable.name = "Variable", value.name = "CBOD_kg")
  
  # Perform actions based on the directory
  switch(directory,
         baseline = {
           # Code specific to the baseline directory
           # For example, you can save plots or perform analysis
         },
         "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ_only/MISG_exe4" = {
           # Create boxplots for directory 1
           create_boxplot("parameter_name", boxplot_data, baseline_data, folder_out)
         },
         "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/Environ/MISG_exe4" = {
           # Create boxplots for directory 2
           create_boxplot("parameter_name", boxplot_data, baseline_data, folder_out)
         },
         "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/TMDL/MISG_exe4" = {
           # Create boxplots for directory 3
           create_boxplot("parameter_name", boxplot_data, baseline_data, folder_out)
         },
         "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/CRP/MISG_exe4" = {
           # Create boxplots for directory 4
           create_boxplot("parameter_name", boxplot_data, baseline_data, folder_out)
         },
         "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/baseline" = {
           # Code specific to the baseline directory
         },
         stop("Invalid directory provided.")  # Handle invalid directories
  )
}

# Process each directory
for (dir in directories) {
  process_directory(dir)
}