#' ---
#' title: "Raw data cleaning and processing to generate Health Canada diet simulation data"
#' author: "Didier Brassard"
#' date: "`r Sys.Date()`"
#' code checked by:
#' code checked date:
#' run time: <1min
#' output:
#'  html_document:
#'    code_folding: "show"
#' ---

#'
#### Set-up and Library ####
# *********************************************************************** #
#                           Set-up and Library                            #
# *********************************************************************** #

#'
# ********************************************** #
#                    Library                     #
# ********************************************** #

## data
library(dplyr)
library(tidylog)
library(readxl)
library(janitor)
library(hefi2019) # Install with <devtools::install_github("didierbrassard/hefi2019")>

## presentation
library(gt)

## project
library(here)

## suppress scientific notation
options(scipen = 9999)

#'
# ********************************************** #
#                  Directories                   #
# ********************************************** #

## Local directory
dir_scripts <- here::here("scripts")
dir_metadata <- here::here("data", "metadata")
dir_processed <- here::here("data", "processed")
dir_raw <- here::here("data","raw")
dir_results <- here::here("data", "results")
dir_temp <- here::here("data","temp")
if(dir.exists(dir_temp)==FALSE){
  dir.create(dir_temp)
}


#'
# ********************************************** #
#            Load functions and data             #
# ********************************************** #

source(file.path(dir_scripts, "save_and_summarize_data.R"))

#'
#### Preparing Health Canada diet simulation ####
# *********************************************************************** #
#                Preparing Health Canada diet simulation                  #
# *********************************************************************** #

# Objective:
# 1) read and format simulation data;
# 2) output table of dietary constituents and nutrients (1 diet = wide format)

#'
##### 1) Download/read data #####
# ********************************************** #
#               Download/read data               #
# ********************************************** #

# Omnivore
  if(file.exists(file.path(dir_raw,"HC_simulated_omni.xlsx"))==FALSE){
  download.file("https://open.canada.ca/data/dataset/0490749d-b0b0-410a-9577-a903c6cec2be/resource/94064331-b1b9-41f5-9ba8-1bf77b880053/download/simulated-composite-diets-omnivore.xlsx",
                destfile =file.path(dir_raw,"HC_simulated_omni.xlsx"))
  } else {
    message("dir_raw/HC_simulated_omni.xlsx found. Date modified:", file.info(file.path(dir_raw,"HC_simulated_omni.xlsx"))$mtime)
  }

# Omnivore, no beverages
  if(file.exists(file.path(dir_raw,"HC_simulated_omni_nobev.xlsx"))==FALSE){
  download.file("https://open.canada.ca/data/dataset/0490749d-b0b0-410a-9577-a903c6cec2be/resource/66919cac-5d2d-4617-be01-9faafd539f2f/download/simulated-composite-diets-omnivore-no-healthy-beverages.xlsx",
                destfile =file.path(dir_raw,"HC_simulated_omni_nobev.xlsx"))
  } else {
    message("dir_raw/HC_simulated_omni_nobev.xlsx found. Date modified:", file.info(file.path(dir_raw,"HC_simulated_omni_nobev.xlsx"))$mtime)
  }

# Lacto-ovo-vege
  if(file.exists(file.path(dir_raw,"HC_simulated_vege.xlsx"))==FALSE){
  download.file("https://open.canada.ca/data/dataset/0490749d-b0b0-410a-9577-a903c6cec2be/resource/3813380e-9978-4d19-995b-c4617ad58019/download/simulated-composite-diets-lacto-ovo-vegetarian.xlsx",
                destfile =file.path(dir_raw,"HC_simulated_vege.xlsx"))
  } else {
    message("dir_raw/HC_simulated_vege.xlsx found. Date modified:", file.info(file.path(dir_raw,"HC_simulated_vege.xlsx"))$mtime)
  }

#'
##### 2) Function to read and output data #####
# ********************************************** #
#        Function to read and output data        #
# ********************************************** #

#' Read Nutrient Data and Output
#'
#' This function reads diet simulation data from an Excel file, performs some cleaning
#' operations, and outputs a list containing serving data, total nutrients, and
#' composite food-specific nutrients.
#'
#' @param hc_file Character string, the name of the Excel file.
#' @param dri_group Character string, the sheet name in the Excel file.
#' @param total_rownb Numeric, the total number of rows to read from the table in the `dri_group`-specific sheet
#'
#' @return A list containing serving data, total nutrients, and composite food-specific nutrients.
#'
#' @examples
#' \dontrun{
#' read_n_output("example_file.xlsx", "sheet_name", 20)
#' }
#'
#' @import readxl
#' @import janitor
#' @import stringr
#' @import dplyr
#'
#' @export
read_n_output <- function(hc_file, dri_group, total_rownb = 20) {
  
  message(paste0("Reading: ",hc_file, "; sheet: ", dri_group))
  # Helper function for reading Excel data
  read_excel_data <- function(range) {
    readxl::read_excel(
      file.path(dir_raw, hc_file),
      sheet = dri_group,
      range = range
    )
  }
  cat("Composite food serving ...\n")
  # Composite servings
  serving <- read_excel_data(paste0("A3:C", total_rownb-1)) |>
    janitor::clean_names() |>
    select(-x3) |>
    setNames(c("NB_RA", "COMPOSITE")) |>
    mutate(COMPOSITE = stringr::str_squish(COMPOSITE)) |>
    select(COMPOSITE, NB_RA)
  
  # Total nutrients
  cat("Total nutrient ...\n")
  varnames_nut <- read_excel_data("E2:AJ3") |> names()
  total_nut <- read_excel_data(paste0("E3:AJ", total_rownb)) |>
    janitor::clean_names() |>
    setNames(varnames_nut) 
  
  # Composite food-specific nutrients
  cat("Composite food-specific nutrients ...\n")
  composite_nut <- read_excel_data(paste0("A3:AJ", total_rownb-1)) |>
    janitor::clean_names() |>
    janitor::remove_empty(which = "cols") |>
    setNames(c("NB_RA", "COMPOSITE", varnames_nut)) |>
    mutate(COMPOSITE = stringr::str_squish(COMPOSITE))
  
  return(list(serving, total_nut, composite_nut))  
}

#'
##### 3) Apply function to each DRI group #####
# ********************************************** #
#        Apply function to each DRI group        #
# ********************************************** #

# note: using omnivore diets with beverage as most likely reflect majority of Canadians

hc_file <- "HC_simulated_omni.xlsx"

drig12 <- 
  read_n_output(
    hc_file  ,
    dri_group   = "M 51-70",
    total_rownb = 19
  )

drig14 <- 
  read_n_output(
    hc_file  ,
    dri_group   = "M 70 +",
    total_rownb = 22
  )

drig13 <- 
  read_n_output(
    hc_file  ,
    dri_group   = "F 51-70",
    total_rownb = 20
  )

drig15 <- 
  read_n_output(
    hc_file ,
    dri_group   = "F 70 +",
    total_rownb = 20
  )


#'
##### 4) Calculate total intakes for each DRI group #####
# ********************************************** #
#   Calculate total intakes for each DRI group   #
# ********************************************** #

#' Calculate DRI group Nutrients
#'
#' This function calculates nutrient summary for a specific DRI group.
#'
#' @param drig A list containing DRI group data.
#' @param drig_suffix Numeric, the DRI group suffix (e.g., 12).
#' @param nut_list Character, vector of nutrients (i.e., variable names) for which totals should be calculated
#'
#' @return A data frame containing the calculated nutrient summary for the specified DRI group.
#'
#' @examples
#' \dontrun{
#' drig12_nutrients <- calculate_drig_nutrients(drig12, 12)
#' }
#'
#' @import dplyr
#'
#' @export

calculate_drig_nutrients <- function(drig, drig_suffix, nut_list = c("EKC","FSUG","FAS","FAM","FAP","SOD","PRO")) {
  
  # Output detailed summary to calculate fat intake (missing)
  all_but_total <- drig[[2]][1:nrow(drig[[2]])-1,]
  
  drig_nut <-
    drig[[2]] |>
    select(all_of(nut_list)) |>
    slice_tail() |>
    mutate(
      # add missing nutrients
      FAM = sum(all_but_total$FAM, na.rm = TRUE),
      FAP = sum(all_but_total$FAP, na.rm = TRUE),
      # add drig id
      drig = drig_suffix
    )
  
    return(drig_nut)
}

# ************************** #
#   Apply function on list   #
# ************************** #

drig_all <- list(drig12, drig14, drig13, drig15)
drig_suffix_all <- c(12, 14, 13, 15)

drig_nut_all <- 
  Map(calculate_drig_nutrients, drig_all, drig_suffix_all) |>
  purrr::reduce(rbind)

# ************************** #
#   Males, 51-70: drig=12    #
# ************************** #

drig12_ra <- 
  drig12[[1]] |>
  mutate(drig=12)

# ************************** #
#    Males, 71 +: drig=14    #
# ************************** #

drig14_ra <- 
  drig14[[1]] |>
  mutate(drig=14)

# ************************** #
#  Females, 51-70: drig=13   #
# ************************** #

drig13_ra <- 
  drig13[[1]] |>
  mutate(drig=13)

# ************************** #
#    Males, 71 +: drig=15    #
# ************************** #

drig15_ra <- 
  drig15[[1]] |>
  mutate(drig=15)

#'
##### 5) Append data together #####
# ********************************************** #
#              Append data together              #
# ********************************************** #

dietsim_bydrig <-
  rbind(
    drig12_ra , drig14_ra , drig13_ra , drig15_ra) |>
  mutate(
    # Add HEFI-2019 classification
    hefi2019subgrp =
      case_when(
        grepl("TOTAL VEGETABLES",COMPOSITE)>0 ~ "vf",
        grepl("TOTAL WHOLE",COMPOSITE)>0 ~ "wg",
        grepl("ANIMAL-BASED",COMPOSITE)>0 ~ "pfab",
        grepl("PLANT-BASED",COMPOSITE)>0 ~ "pfpb",
        grepl("HEALTHY BEVERAGES",COMPOSITE)>0 ~ "milk_plantbev",
        grepl("UNSATURATED OILS",COMPOSITE)>0 ~ "ufa"
      ) # end of case_when
  ) |> # end of mutate
  # remove non-hefi food groups (i.e., subclassification)
  filter(is.na(hefi2019subgrp)==FALSE) |>
  # Transpose long data to wide
  select(-COMPOSITE) |>
  pivot_wider(
    names_from  = "hefi2019subgrp",
    values_from = "NB_RA"
  ) |>
  # add hefi-2019 nutrients
  full_join(
    drig_nut_all,
    by = "drig"
  ) |>
  # ensure variable names are not capital letters
  janitor::clean_names()

# Generate an 'overall' row
dietsim_drig0 <- 
  dietsim_bydrig |>
  # calculate mean
  summarise(
    across(.cols=all_of(names(dietsim_bydrig[-1])),
           function(x) mean(x),
           .names ="{col}" )
  ) |>
  mutate(
    drig=0
  )

dim(dietsim_drig0); head(dietsim_drig0)

# Add 'overall' row to drig-specific rows
dietsim <- 
  rbind(dietsim_bydrig, dietsim_drig0) |>
  arrange(drig) |>
  mutate(
    drig_f = 
      factor(drig,
             levels = c(0, 12, 13, 14, 15),
             labels = c("Male and female, 51 y or older",
                        "Male, 51-70 y",
                        "Female, 51-70 y",
                        "Male, 71y+",
                        "Female, 71y+"))
  )

dim(dietsim); names(dietsim); head(dietsim)

# ************************** #
#         Add labels         #
# ************************** #

labelled::var_label(dietsim) <-
list(
  drig          = "DRI age and sex group",
  drig_f        = "DRI age and sex group",
  vf            = "Vegetables and fruits, RA/d",
  wg            = "Whole-grain foods, RA/d",
  pfpb          = "Protein foods, plant-based, RA/d",
  pfab          = "Protein foods, animal-based, RA/d",
  milk_plantbev = "Unsweetened milk and plant beverage with protein, RA/d",
  ufa           = "Unsaturated fats, RA/d",
  ekc           = "Total energy intake, kcal/d",
  fsug          = "Free sugars, grams/d",
  fas           = "Saturated fats, grams/d",
  fam           = "Monounsaturated fats, grams/d",
  fap           = "Polyunsaturated fats, grams/d",
  sod           = "Sodium, mg/d",
  pro           = "Protein, grams/d")

#'
#### Calculate HEFI-2019 scores ####
# ********************************************** #
#           Calculate HEFI-2019 scores           #
# ********************************************** #

# Apply the hefi-2019 scoring algorithm
 
dietsim_hefi <-
  dietsim |>
  mutate(
    # Change milk_plantbev RA to grams
    milk_plantbev = milk_plantbev*258,
    # Without further information for milk_plantbev = split half/half
    milk = milk_plantbev/2,
    plantbev = milk_plantbev/2
  ) |>
  hefi2019::hefi2019(#indata      = dietsim,
    vegfruits          = vf,
    wholegrfoods       = wg,
    nonwholegrfoods    = 0,
    profoodsanimal     = pfab,
    profoodsplant      = pfpb,
    otherfoods         = 0,
    waterhealthybev    = 0,
    unsweetmilk        = milk,
    unsweetplantbevpro = plantbev,
    otherbeverages     = 0 ,
    mufat              = fam ,
    pufat              = fap ,
    satfat             = fas ,
    freesugars         = fsug,
    sodium             = sod,
    energy             = ekc
  )

# ************************** #
#         Add labels         #
# ************************** #

labelled::var_label(dietsim_hefi) <-
  list(
    drig          = "DRI age and sex group",
    drig_f        = "DRI age and sex group",
    vf            = "Vegetables and fruits, RA/d",
    wg            = "Whole-grain foods, RA/d",
    pfpb          = "Protein foods, plant-based, RA/d",
    pfab          = "Protein foods, animal-based, RA/d",
    milk_plantbev = "Unsweetened milk and plant beverage with protein, RA/d",
    ufa           = "Unsaturated fats, RA/d",
    ekc           = "Total energy intake, kcal/d",
    fsug          = "Free sugars, grams/d",
    fas           = "Saturated fats, grams/d",
    fam           = "Monounsaturated fats, grams/d",
    fap           = "Polyunsaturated fats, grams/d",
    sod           = "Sodium, mg/d",
    pro           = "Protein, grams/d")

#' 
#### Summary and save ####
# ********************************************** #
#                Summary and save                #
# ********************************************** #

# summary
dietsim |>
  select(-c("drig", "ekc":"pro")) |>
  gt::gt() |>
  gt::cols_move_to_start("drig_f") |>
  gt::fmt_number(columns = everything(), decimals = 1) |>
  gt::tab_header("Intakes of major food categories in Health Canada simulated diets, by DRI group") |>
  gt::tab_source_note(source_note = "Data from Health Canada. (2022). Simulated composite diets. Available at https://open.canada.ca/data/dataset/0490749d-b0b0-410a-9577-a903c6cec2be")

dietsim |>
  select("drig_f", "ekc":"pro") |>
  gt::gt() |>
  gt::cols_move_to_start("drig_f") |>
  gt::fmt_number(columns = everything(), decimals = 1) |>
  gt::tab_header("Intakes of major nutrients in Health Canada simulated diets, by DRI group") |>
  gt::tab_source_note(source_note = "Data from Health Canada. (2022). Simulated composite diets. Available at https://open.canada.ca/data/dataset/0490749d-b0b0-410a-9577-a903c6cec2be")


dietsim_hefi |>
  select(starts_with("HEFI2019")) |>
  gt::gt() |>
  gt::fmt_number(columns = everything(), decimals = 1) |>
  gt::tab_header("HEFI-2019 scores of Health Canada simulated diets, by DRI group") |>
  gt::tab_source_note(source_note = "Based on data from Health Canada. (2022). Simulated composite diets. Available at https://open.canada.ca/data/dataset/0490749d-b0b0-410a-9577-a903c6cec2be")

# save intake only
save_and_summarize_data(
  dietsim,
  dir = dir_processed,
  dir_metadata = dir_metadata
)

# save intake + hefi
save_and_summarize_data(
  dietsim_hefi,
  dir = dir_processed,
  dir_metadata = dir_metadata
)

# *********************************************************************** #
#                              End of code                                #
# *********************************************************************** #

sessionInfo()
