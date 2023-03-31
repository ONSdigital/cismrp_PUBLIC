# cismrp
[![R](https://github.com/ONSdigital/cismrp/actions/workflows/r.yaml/badge.svg?branch=main)](https://github.com/ONSdigital/cismrp/actions/workflows/r.yaml)
[![codecov](https://codecov.io/gh/ONSdigital/cismrp/branch/main/graph/badge.svg?token=N70MPthEj1)](https://codecov.io/gh/ONSdigital/cismrp)
## Description
cismrp is the package that contains the functions to run a reproducible analytical pipeline (RAP) for generating headline covid positivity estimates using a multi-level regression model with poststratification. The pipeline has been set up to run on the Google Cloud Platform (GCP). 

## Repo contents
  
 1. root (.)
    1. `.github/`  GitHub templates and GitHub Workflows (invisible in GCP)
    2. `R/` Functional code with a seperate file for each exported function
    3. `data-raw/`   Code to produce the package data objects
    4. `data/`  Package data objects produced in data-raw
    5. `man/`  Function documentation automatically produced by `devtools::document()`
    6. `tests/` Unit tests for the functions
    7. `.Rbuildignore` File extensions to ignore when cloning this repo (invisible in GCP)
    8. `.gitignore` File extensions to ignore when pushing to GitHub (invisible in GCP)
    9. `CHANGELOG.Md` Log of all of the changes made to the package
    10. `CODEOWNERS` Protected files and github username of owners
    11. `CONTRIBUTING.md` Instructions on how to contribute to the cismrp package
    12. `DESCRIPTION` Pacakge description including contributors & dependencies
    13. `LICENCE` Licence for the package
    14. `NAMESPACE` Automatically generated list of functions to export
    15. `README.md` Important information about this package



## Installation
  
### 1. Prerequisites 
 1. A GitHub Account
 2. A Personal Access Token for authentication to GitHub
 3. Membership of the ONS Digital organisation and the cis_methods_analysis team

### 2. Cloning the repo
 1. Use git clone button (see slidedeck [here](https://officenationalstatistics.sharepoint.com/:p:/r/sites/covid19/CISA_Analysis/Polestar/User_Guidance/Screenshot%20walk%20throughs.pptx?d=w6fd6a1ec9fe847848e07d962b76da5bf&csf=1&web=1&e=H1XX7g))
 2. Copy the repo address to your clipboard
 3. Paste the address into the user interface
 4. Use your PAT to authenticate to GitHub.
 
### 3. Install devtools
 1. Open a console an run `install.packages(devtools)`

### 4. Install `cismrp`
 1. Ensure you are on the master branch and at the top level directory in the repository.
 2. Install the latest `cismrp` package by executing the command `devtools::install("cismrp", upgrade = FALSE)` from the console.
 3. Test installation is sucessful by running `library("cismrp")` - No errors should be returned


## Regular production
 1. Use the Jupyter Notebook interface or a terminal to navigate to your local CIS_MRP repo
 2. Ensure you are in the master branch and `git pull`
 3. Check package is up to date by running `devtools::install("cismrp", upgrade = FALSE)` in console
 4. Create a new branch from master/main called prod_run/<datarun date>_mrp 
 5. Check main_config.yaml has the latest dates and setting, press ctrl + s to save.
 6. Check <country>_config.yamls have the correct model settings, press ctrl + s to save.
 7. `Commit` your changes.
 8. Run the pipeline using the line `source("main.R")` in console.
 9. Check your outputs, if the run has completed sucessfully `push` your commits.
 10. Raise a pull request to `config_history` and merge then delete your branch.
 11. If you are no longer working in Polestar close your notebook

## Any extra functionality

e.g. Functions that can be run in isolation

## Further Reading
 1. See Wiki - [Code Map](https://github.com/ONSdigital/CIS_MRP/wiki/Code-Map-(WIP)) 
 2. How to contribute development changes to the repo - `CONTRIBUTING.md`
 3. Methodology for the pipeline - `METHODOLOGY.md`
 4. Most recent changes to the package code - `CHANGELOG.md`
 
