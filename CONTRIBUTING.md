# Contributing to cismrp

Please read this markdown before you make your first changes to the cismrp package.
It has important information to help you make useful additions to the MRP code base while ensuring the master production code remains constantly operational.

When contributing to this repository, please raise an issue as your first action before making any changes.

*If in doubt ask!*

## TOC
 - [Git Workflow](#git-workflow)
 - [Templates](#templates)  
 - [Code style](#code-style)  
 - [Making changes to the package](#making-changes-to-the-package)

## Pull/merge request process

## Git Workflow

See the agreed GitHub working conventions for developing in this repo [here](https://officenationalstatistics.sharepoint.com/:p:/r/sites/covid19/CISA_Analysis/Polestar/User_Guidance/GitHub%20Working%20Convention.pptx?d=w2b107791ef6443a7a88a0d824b989f8a&csf=1&web=1&e=gNbdbL)

Do not push any files that may contain data, such as .ipynb, ipynb checkpoints. .RData files or .RHistory files. 
If you do, you should notify the owner of the repository. Do not push "broken" code, i.e. code that produces an error when executed. 


## Templates
  
### [issue template](https://github.com/ONSdigital/CIS_MRP/tree/master/.github/ISSUE_TEMPLATE)
  Templates for new issues are stored in the folder linked above. Add new ones if you need or edit the following two options to meet your needs.
* `bug_report.md`  
* `feature_request.md`  
  
  
## Code style

The following style rules help make the code base easier to read and understand. You should stick to these rules wherever possible.

- We name variables using few **nouns** in [snake_case](https://en.wikipedia.org/wiki/Snake_case), e.g. `mapping_names`
or `increment`.
- We name functions using **verbs** in [snake_case](https://en.wikipedia.org/wiki/Snake_case), e.g. `map_variables_to_names` or
`change_values`.
- We avoid full stops in column and object names, as this can be confusing to users of other programming languages such as python where full stops cannot be used in this way.
- With a few exceptions, we do not load whole packages by using the `library()` function. Instead, we reference the namespace directly, e.g. `rstanarm::stan_gamm4()`. The exceptions to this are packages that use custom operators, such as the use of the + operator in `ggplot2`, or the pipe (`%>%`) in magrittr. You may reference magrittr pipes and ggplot2 functions without referring to the namespace directly, within the `cismrp` package. 
- Functions that are likely to be used directly by end-users are marked for export and housed in their own R script. Similarly, functions that are not used directly, but are used by multiple functions are also marked for export and housed in their own scripts. Child functions which are only used by one parent are contained within the parent function's script. 

In general, we also aim to follow the rules set out in the [tidyverse style guide](https://style.tidyverse.org/index.html). Code that deviates from this guidance without good reason should be amended.

## Making changes to the package

Adding new functionality or amending existing functions should always be done in the package rather than in separate scripts. You should also prioritise writing unit tests and documentation in roxygen format for any new functionality. You can find more information on writing R packages in the [R packages book](https://r-pkgs.org/).

You can install the package and its dependencies by executing the following command from the console, from the top level directory of this repository:

`
devtools::install("cismrp")
`

If you made any changes to the documentation in the package, run the following command in an R console:

`
devtools::document("cismrp")
`

You should always run checks and tests before pushing changes or installing the package:

`
devtools::check("cismrp")
`

# Notes
This pipeline is set up for use in GCP and will not work on other platforms without changes to the package and main.R. However, this should only affect data ingestion and saving outputs. You should be able to re-use the main functionality within the package on other platforms.

# Future Development
Please check the GitHub issues on this repository.


