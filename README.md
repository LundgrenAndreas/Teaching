This is a script and example data set designed for use in the course Soil Biology and Biogeochemical Cycles (SLU)

Data

The data consists of CO2 measurements from an IRGA (Infra-Red Gas Analyser) for 5 different soil samples.

The measurements are taken every 15 seconds for 195 seconds (a total of 13 measurements per sample).

The measurements done during the course may differ somewhat in number of measurements and/or timining of measurements but the script should work the same.

For the script to work without problems, remember the following:

You need 1 column specifying the time of the measurement (in seconds from the start of IRGA analysis) and 1 column specifying the amount of CO2 in the system at the given time of measurement (see example data set).

Also, if you do calculations for several different soil samples, remember to name the ID of one sample the same way in all measurements. For example, ID "one" and "One" will be treated as two different samples because R is case sensitive

Script
The script is written for the R-language. You can download R and Rstudio (a more convenient way of working in R) here: https://www.r-project.org/
You do not have to learn the R-language to run the script but it will help you understand what the script does.
To run the script on your own data, you have to change some of code. All these changes are highlighted by # Change "X"
In R, everything written after a hashtag # is a comment and does not run as code.
The easiest way to run the code is to make sure that you have your data and the script in the same folder (that way the script can more easily load your data).

To begin:
Download R and Rstudio
Download the files "IRGA_data.csv" and "IRGA_script.R"
Double-click IRGA_script.R and Rstudio should open
From there, every line is a piece of code that needs to be run in order (i.e. start with the top one and go down)
In R, a line of code is run by pressing "CTRL + ENTER" or by pressing the "RUN" button in the top right
R can take a while to get used to but it is a great tool for analysis when you've gotten used to it!
