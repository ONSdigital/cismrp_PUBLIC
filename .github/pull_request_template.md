# Pull request description

**Add pull request description HERE**

# Pull request checklist
- [ ] Have you described your pull request?
- [ ] Have you linked any relevant issues?
- [ ] Have you used labels/projects (if relevant)?
- [ ] Have all necessary people been included as reviewers? e.g. other teams using the package (if applicable)
- [ ] Have you checked you are merging into the correct branch?

# Reviewer checklist
  
  ## Checks for functionality:
  
  - [ ] Read pull request description and check/ask about linked issues
  - [ ] Pulled branch, manually tested
  - [ ] Verified requirements/acceptance criteria described in the issue are met
  - [ ] Has the output been tested and compared with the previous output? (if applicable)
  - [ ] Have all necessary people been included as reviewers? e.g. other teams using the package (if applicable)
  
  ## Checks for style/documentation and quality assurance:
  
  - [ ] Do objects have intuitive human readable names?
  - [ ] Has the code been formatted/indented? i.e `styler::style_file("main.R")`
  - [ ] Has the code been commented sufficiently?
  - [ ] Are all parameters included and explained in the documentation?
  - [ ] Is the code running without any errors?
  - [ ] Run `devtools::check("package_name")`
  
