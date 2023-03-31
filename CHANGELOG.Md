# cismrp

## 1.1.31 (minor amendment)
- Removed lab_id fixed effect from model formula

## 1.1.30 (minor amendment)
- Updated poststrat tables to 2021 Census/2021 mid year population estimates

## 1.1.29 (minor amendment)
- Added CIS disco script to MRP repository

## 1.1.28 (minor amendment)
- Added BB lab as factor level for analysis

## 1.1.27 (minor amendment)
- Changed legend on variant plots
- changed source bucket for download QA report function to review bucket

## 1.1.26 (minor amendment)
- Reistated variant overlay plots in QA docs and updated make_qa.R to work with latest package updates

## 1.1.25 (minor amendment)
- Amended function for overlay plots in QA doc, to create dataframe from environment object rather than csv in review bucket

## 1.1.24 (minor amendment)
- changed seed value to 42 instead of 12345 (to ensure reproducible/identical results for model)
- Added secondary test function to main config to allow tests to be run with both short and long config

## 1.1.23 (minor amendment)
- Added gcptools dependencies update

## 1.1.22 (minor amendment)
- Fixed replication of rows issue in pos_swabs_by_day table in the QA doc. 

## 1.1.21 (minor amendments)
-Have added mean estimates to daily underlying counts tables in QA doc 

## 1.1.20 (minor amendments)
- commented out code chunk for variant plots in the QA docs, 
  so that these no longer show in the documents.

## 1.1.19 (minor amendments)
- Added (%) units to prevalance graphs
- Changed Y axis labelling on raw data plots 

## 1.1.18 (minor amendments)
- Make tests automatically pick up short config
- Legend change on variant plots
 
## 1.1.17 (minor amendments)
- Changed region name order for QA docs
- making sure tests only save to wip
- added headline summary to QA documents 


## 1.1.16 (minor amendments)
- Changed previous trend label
- Pull request template added

## 1.1.15 (clearing old code/updating labels)
- Removing plot_ct_mean
- Changing probabilities labelling

### 1.1.14 (minor amendments/QA report changes)
- Add sums 7-14 day to QA Report
- Changed post strat file to correct version

### 1.1.13 (minor amendments)
- Reverted population totals

### 1.1.12 (minor amendments)
- Updated population totals
- removed redundant columns from probabilities CSV

### 1.1.11 (QA report changes)
- Change to variant labels in Rmarkdown
- Fixed variant region overlay plots

### 1.1.10 (Function amendments/QA report changes)
- Wrapping fit all models in TryCatchlog
- Amend grep search for previous probabilities file
- Test 'get prob below percent' function
- Add conditional formatting to probabilities tables
- Updated make_qa_mrp.R script

### 1.1.9 (QA report changes)
-Change ct7 variant to include ct5 and ct6 counts
-QA report: Under model settings, remove all except adapt_delta and iterations

### 1.1.8 (QA report changes)
-Deleted percentage column from pos swabs by day
-Added variant descriptions to variant overlay legend

### 1.1.7 (QA report changes)
-Added tables for regions to swab poss by day table
-Added previous run estimates to the QA report

### 1.1.6 (QA report changes)
- Added previous run trends

### 1.1.5 (QA report changes)
- Changed variant overlays legend
- Added percentage draws to post_stratify_draws

### 1.1.4 (QA report changes)
- Raw and modelled data at bottom of QA report were overlaid
- "Previous run" in legend for overlay graphs now includes the datarun date
 
### 1.1.3 (QA report changes)
 - Added vertical lines to spaghetti plot to show reference days (make_figures.R amended)
 - Added parameter to main_config to allow reruns (functions_to_port_to_GCP_tool and save_outputs amended)
 - Added parameters to main_config to allow users to specify previous datarun dates for overlay plot previous run line (make_figures.R amended)
 - Added checks for testing whether test and rerun are null, and whether model being run is incidence or MRP (save_MRP_QA_reports.R amended)

### 1.1.2 (Add Tictoc)
 - We have added tictoc to the main script in order to time different sections of the pipeline.
 - We have added save_mrp_qa_reports to tidy the code in `main.R`.
 - We have adapted `fit_model` and the configs, so now the pipeline will run if knots and prior_smooth$location are set to `null`. 
 - We have corrected various typos and improved the standard of documentation.

### 1.1.1 (Documentation Updates)

- We have updated the readme.md
- We have updated the contributing.md
- We have removed an unused parameter from render_qa_report.
- We have removed save_plot.
- We have removed dependencies(reshape2, plotly, reproducible, haven, rlist).
- We have corrected various typo.


### 1.1.0 (Modularisation of R/)

- We have restructured the R/ folder into a smaller number of modules each containing multiple functions please see [Wiki](https://github.com/ONSdigital/CIS_MRP/wiki/Code-Map-(WIP)) for details
- We have added new tests for the Map wrapper functions
- We have added a new plot to the QA showing CT means and removed the tables of weekly tests. 

### 1.0.0 (First working release)

See [link](https://semver.org/) for information on the meaning of R version numbers. Where possible please try to stick to this pattern when updating the changelog.

We are now confident that the core RAP product is stable, i.e. that existing functions will not change in a way that is backwards incompatible. Future changes are likely to include patches i.e. changes to the third number or the development of new feature changes to the second number.

For example: If you find a bug a and fix it you would create a new heading above in the change log with `### 1.0.1` and then describe what the bug you fixed was in the text below. for a new feature you'd add `### 1.1.0` and describe the new feature.

### 0.0.0.9999  
cismrp is about to roll on to 1.0.0
