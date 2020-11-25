installed.packages()

## ----- INSTALL THE PACKAGE SEGOPTIM---- ##

#I get an error as I try to install from GitHub:(converted from warning) package ‘raster’ is in use and will not be installed
##Then , I run the following:

detach("package:raster", unload = TRUE)

#PROTOCOL:  First, install remotes to conect to GitHUB
#Check if devtools package is installed and install it if not

if(!requireNamespace("remotes")){
  install.packages("remotes")
}

# Run the installation, from repository in GitHub . I have chosen ALL installation
#
remotes::install_github("joaofgoncalves/SegOptim")


## installed succcesfully, but WITHOUT selecting any of the packages listed. If required, I include a script to install /update

update.packages(ask = FALSE)
##install.packages(c('tools', 'raster',, 'rgdal', 'rgeos','RColorBrewer', 'devtools', 'tools','sp',))
##install.packages(c('pillar', 'cli', 'vctrs', 'rprojroot','rstudioapi'))
"pillar" %in% rownames(installed.packages()) ## Install if it doesn't exist --> TRUE ? -> DOESN'T INSTALL
"cli" %in% rownames(installed.packages()) ## Install if it doesn't exist --> TRUE ? -> DOESN'T INSTALL
"vctrs" %in% rownames(installed.packages()) ## Install if it doesn't exist --> TRUE ? -> DOESN'T INSTALL
"rprojroot" %in% rownames(installed.packages()) ## Install if it doesn't exist --> TRUE ? -> DOESN'T INSTALL
"rstudioapi" %in% rownames(installed.packages()) ## Install if it doesn't exist --> TRUE ? -> DOESN'T INSTALL

# list all packages where an update is available
update.packages(old.packages()) ## Update packages which are not updated yet.

## ----- END OF INSTALLATION OF PACKAGE SEGOPTIM---- ##

##install.packages("rstudioapi") -- I HAD TO INSTALL SOME PACKAGES INDIVIDUALLY

library(SegOptim)
library(tools)
library(raster)
library(rgdal)
library(rgeos)
library(sp)
library(RColorBrewer)
library(pillar)
library(cli)
library(vctrs)
library(rprojroot) 
library(rstudioapi)

#Remove existing variables
rm(list = ls())

# A function providing CLI access to TerraLib 5 Baatz-Shcape segmentation 
##and optimize its parameters using genetic algorithms.
###Source of information: https://rdrr.io/github/joaofgoncalves/SegOptim/man/segmentation_Terralib_Baatz.html
#HELP: ??segmentation_Terralib_Baatz

##Create multi layered Raster (input bands)

allBands <- list.files("D:/_PhD_/_y_2020_n_2021/Studies/02_Methodology/_Data_/Original_Data/MATSALU/multispectral/hosby",pattern = "tif$",full.names = TRUE)
#1. stack bands and save them
stackBands <- stack(allBands)
writeRaster(stackBands, filename = "D:/_PhD_/_y_2020_n_2021/Studies/02_Methodology/_Data_/Process_Data/Stacks/Stack_Hosby.tif")

#Check the bands
brikBands_br <- brick(stackBands)
#find the band indexes

print(brikBands_br[[4]])##RED EDGRE
print("/n")
print(brikBands_br[[3]])## RED
print("/n")
print(brikBands_br[[2]])##NIR
print("/n")
print(brikBands_br[[1]])##GREEN

ImgSegment <- segmentation_Terralib_Baatz(
c(5,3,20,500),
"D:/_PhD_/_y_2020_n_2021/Studies/02_Methodology/_Data_/Process_Data/Stacks/Stack_Hosby.tif",
outputSegmRst = "D:/_PhD_/_y_2020_n_2021/Studies/02_Methodology/_Data_/Process_Data/Segmentations/Hosby/aaa.tif",
CompactnessWeight = NULL,
SpectralWeight = NULL,
Threshold = NULL,
MinSize = NULL, # Minimum size of 8 because oour training samples have 8 pixels (Pol -> Ras) 
verbose = TRUE, # I want to see messages
TerraLib.path = "C:/terralib-5.2.1-TISA-win_x64/terralib-5.2.1-TISA/lib" #input for argument path
) 

# Check out the result
rstSegm <- raster(ImgSegment$segm)

print(rstSegm)

plot(rstSegm)