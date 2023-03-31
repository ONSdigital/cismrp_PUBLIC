# cismrp
[![R](https://github.com/ONSdigital/cismrp_PUBLIC/actions/workflows/r.yaml/badge.svg?branch=main)](https://github.com/ONSdigital/cismrp_PUBLIC/actions/workflows/r.yaml)
[![codecov](https://codecov.io/gh/ONSdigital/cismrp_PUBLIC/branch/main/graph/badge.svg?token=grjGrslGVD)](https://codecov.io/gh/ONSdigital/cismrp_PUBLIC)
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
 
### 2. Install devtools
 1. Open a console an run `install.packages(devtools)`

### 3. Install `cismrp`
 1. run the  `devtools::install_github("ONSdigital/cismrp_PUBLIC")`

  
## Synthetic Data

Because not all users will have access to the internal systems, we have created dummy and synthetic data within the cismrp package [(read more about synthetic and dumy data here)](https://syntheticus.ai/guide-everything-you-need-to-know-about-synthetic-data#:~:text=Synthetic%20and%20dummy%20data%20are,typically%20create%20dummy%20data%20manually). This data can be called from the package by first installing the cismrp package into your environment, and then calling `synthetic_` or `dummy_` prefix infront of the name of the data object, e.g. `dummy_config` for the dummy version of main config, or `synthetic_prevalence_time_series` for the synthetic version of the final output. This data has been predominantly used for unit testing within the package, but it could also be useful for anyone looking to visualise what the data looks like at each of the processing stages. 
<br> **Disclaimer: Synthetic and dummy data is not real data, so should only be used for testing purposes.**

## Public Repositories
To improve transparency of how we produce our official statistics and to support future pandemic preparedness, we have cloned our active repositories and made them available to the public. We have removed the commit history for security purposes. 
- [cismrp_PUBLIC - the package](https://github.com/ONSdigital/cismrp_PUBLIC)
- [CIS_MRP_PUBLIC - the pipeline](https://github.com/ONSdigital/CIS_MRP_PUBLIC)
- [gcptools_PUBLIC - an additional support package](https://github.com/ONSdigital/gcptools_PUBLIC)

## Further Reading
 1. How to contribute development changes to the repo - `CONTRIBUTING.md`
 2. Methodology for the pipeline - `METHODOLOGY.md`
 3. Most recent changes to the package code - `CHANGELOG.md`
 
