
## Calculations for CO2 soil respiration

### Quick R introduction
#
# Anything that is written after a hashtag (#) is a comment
# Everything NOT written after (#) is a piece of code that can be run
# Whenever a comment says "Change "X"", you need to change something in the code to make it fit your specific data
# This code is made to run on data in "long format" which means that the csv or xlsx file will need the following columns:
# 1. Soil_ID = Your specified ID for different soils (you can have any number of soil samples analyzed)
# 2. Time = At which time interval your data has been gathered (generally this will be done on an interval of 15 seconds, thus making the rows of this column = 0, 15, 30, 45 etc.)
# 3. CO2_ppm = The CO2 in your sample at any given time
# Additional optional columns are: temperature, pressure, volume
# Try to load the example dataframe to get a better view of how the data can be formatted



#### 1. Read data - If you have all soil measurements in the same file ####
# Find directory OR write the whole path
library(rstudioapi)
library(readxl)
dir <- dirname(getActiveDocumentContext()$path)                         # This gives you path to your script's folder
# dir <- ".../folder/"                                                  # Or you can use this by adding path to your folder containing the data
setwd(paste0(dir))                                                      # Set your working directory

df <- as.data.frame(read.csv(paste0(dir, "/IRGA_data.csv")))            # Change "read.csv" to "read_excel" if your files are .xlsx AND ".csv" to filetype, e.g. ".xlsx"
                                                                        

#### 2. Examine data and linearity ####
# Look at the data to make sure everything seems to be in order
View(df)
# Plot the data to have a look at the linearity of your measurements
library(ggplot2)
ggplot(df, aes(x=Time, y=CO2_ppm)) +                                    # Change "Time" and "CO2_ppm" based on what your columns are called
  facet_wrap(~Soil_ID, scales = "free") +                               # Change "Soil_ID" based on what your column is called
  geom_point() +
  geom_smooth(method = lm, se = F) +
  stat_cor(r.accuracy = 0.0001, aes(label = after_stat(rr.label)))

# Note the plateau in Soil_4
# there will be a better linear fit if we remove the last 4 points of measurement
df$CO2_ppm <- ifelse(df$Soil_ID==4 & df$Time>135, NA, df$CO2_ppm)       # Here we remove all data from Soil_ID 4 that occurs after 135 seconds

# Now try the plot again
# Soil_4 should now be linear(ish) and we are ready to calculate the umol CO2


#### 3. Calculate ppm CO2 change over time ####
# Split the data based on the Soil ID to make individual calculations
split_df <- split(df, df$Soil_ID)                                       # Change "Soil_ID" based on what your column is called

int <- 1:13                                                             # Make "int" into as many times you have recorded CO2 per sample
slope.fun.lin <- function (x) {
  if(nrow(x) >1) {ll <-lm(x[int, "CO2_ppm"]~x[int, "Time"] )}           # Change "Time" and "CO2_ppm" based on what your columns are called
  else {NA}
  return(ll)
}
mods.lin <- lapply(split_df,  FUN = slope.fun.lin)                      # Here we calculate the linear slope for each sample
coefy <- lapply(mods.lin, function (x) if(!(is.na(x[1]))) {coef(x)[2]}) # Here we extract the delta-y value of each sample

# If all measurements share the same pressure, volume, temperature; do the following
p <- 1                 #Pressure in atm
v <- 0.0002            #Volume in m3
R <- 8.21 * 10^-5      #Gas constant
TK <- 293              #Temperature in kelvin

# If the measurements have individual pressure, volume, temperature; do the following
# TK <- aggregate(df$Temperature_C, list(df$Soil_ID), FUN=mean)           # Change "Temperature_C" based on what your column is called
# TK <- TK[,2]
# p <- aggregate(df$Pressure, list(df$Soil_ID), FUN=mean)                 # Change "Pressure" based on what your column is called
# p <- p[,2]
# v <- aggregate(df$Volume, list(df$Soil_ID), FUN=mean)                   # Change "Volume" based on what your column is called
# v <- v[,2]

# Calculate umol CO2 second-1
CO2_umol <- (unlist(coefy)) * ((p * v) / (R * TK))                      # Here we apply the equation to our data
result <- as.data.frame(cbind(unique(df$Soil_ID), CO2_umol))            # Here the output called "V1" = Soil ID
colnames(result) <- c("Soil_ID", "CO2_umol")
View(result)
