# Make sure to run in interactive mode so that user input is prompted to select a case

library(data.table)
library(ggplot2)
library(reshape2)
library(readr)

# Check if running interactively
is_interactive <- identical(interactive(), TRUE)

# Get user input for Baseline folder choice
if (is_interactive) {
  cat("Choose Baseline Folder:\n")
  cat("1. Baseline\n")
  cat("2. Baseline_SWSH_exe2\n")
  cat("3. Baseline_MISG_exe2\n")
  cat("4. Baseline_MISG_exe3\n")
  cat("5. Baseline_MISG_exe4\n")
  cat("6. Baseline_MISGv2_exe2\n")
  
  choice <- as.integer(readline(prompt = "Enter your choice (1 or 2 or 3 or 4 or 5 or 6): "))
} else {
  # If not running interactively, use command line arguments
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) >= 1) {
    choice <- as.integer(args[1])
  } else {
    stop("No command line argument provided. Please provide a choice (1 or 2 or 3 or 4 or 5 or 6).")
  }
}

######################### SELECT UP UNTIL HERE TO REQUEST R PROMPT  ############################## 
# input your switch case...

# then proceed to run the rest here:


# Choose the Baseline folder based on user input
switch(
  choice,
  "1" = {
    setwd("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline")
    folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/baseline"
  },
  "2" = {
    setwd("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline_SWSH_exe2")
    folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/SWSH_exe2"
  },
  "3" = {
    setwd("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline_MISG_exe2")
    folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/MISG_exe2"
  },
  "4" = {
    setwd("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline_MISG_exe3")
    folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/MISG_exe3"
  },
  "5" = {
    setwd("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline_MISG_exe4")
    folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/MISG_exe4"
  },
  "6" = {
    setwd("C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Model/Baseline/Baseline_MISGv2_exe2")
    folder_out = "C:/SWAT/SWATprojects/SWAT_Sundar/SWAT2012-Usang_Baseline/SWAT2012-Usang_Baseline/Scripts/Visualization_Scripts/output/MISGv2_exe2"
  }
)


############################### PLOTTING SUBBASIN VALUES ###########################
#system("SWAT_64rel.exe")

#create table for subbasin data
sboptab <- read.table("output.sub", skip = 9, header = FALSE)
sboptab = as.data.table(sboptab)

#split 45 subbasin data from that table
sbdttab <- tail(sboptab,45)

#split column data from the table and make new table
sbdttabnew <- sbdttab[, list(V2, V8, V9, V11, V12, V20)]

#setting the column name
setnames(sbdttabnew, old = c("V2","V8", "V9","V11","V12","V20"), new = c("Subbasins", "ET", "SW", "SUR", "GW", "LAT"))

#change table to longer form from wider form
sbpartab <- melt(sbdttabnew, id.vars = "Subbasins", variable.name = "Parameters", value.name = "Q_mmPeryear")


# Set y limit
y_axis_limit <- 800

# outlier removal
#outliers <- boxplot.stats(sbpartab$Q_mmPeryear)$out
#sbpartab_no_outliers <- sbpartab[!(sbpartab$Q_mmPeryear %in% outliers), ]

# Stackedbar graph
ggplot(data = sbpartab, mapping = aes(x = Subbasins, y = Q_mmPeryear, fill = Parameters)) +
  geom_bar(stat = "identity") +
  ggtitle("Stacked Comparison of Parameters Yearly across Subbasins") +
  theme_minimal() +
  theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
        text = element_text(size = 10))  # Increase text size
ggsave("SubbasinParameters_yearly_stacked.png", path = folder_out, width = 10, height = 6, units = "in", dpi = 300)

# Scatterplot
ggplot(data = sbpartab, mapping = aes(x = Subbasins, y = Q_mmPeryear, colour = Parameters, shape = Parameters)) +
  geom_point(size = 1) +  # Adjust point size
  geom_line(size = 0.5) +  # Adjust line thickness
  ylim(0, y_axis_limit) +
  ggtitle("Scatter Comparison of Parameters Yearly across Subbasins") +
  theme_minimal() +
  theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
        text = element_text(size = 10))
ggsave("SubbasinParameters_yearly_scatter.png", path = folder_out, width = 10, height = 6, units = "in", dpi = 300)

# Boxplot with outlier removal
ggplot(data = sbpartab, mapping = aes(x = Parameters, y = Q_mmPeryear)) +
  geom_boxplot(width = 0.5, outlier.shape = NA) +  # Adjust boxplot width and remove outlier points
  ggtitle("Boxplot Comparison of Parameters Yearly across Subbasins") +
  theme_minimal() +
  theme(axis.text.x = element_text(hjust = 1),  # Rotate x-axis labels for better readability
        text = element_text(size = 10))
ggsave("SubbasinParameters_yearly_box.png", path = folder_out, width = 8, height = 6, units = "in", dpi = 300)





