####### WORKFLOWR PROJECT IMPLEMENTATION -  #######


# Pre-requisites ----------------------------------------------------------

R.version.string # R (necessary)
RStudio.Version()$version # RStudio (optional)
utils::packageVersion("workflowr") # workflowr library (necessary)
system2("git", "--version") # Git (optional, bur recommended)


# Upload workflowr library and  Configure Git -----------------------------

library(workflowr)
wflow_git_config()


# Start new project and first steps ---------------------------------------

# Start new project
wflow_start("CosMx_pipeline_LGA") # Creates directory and Git local repo
wflow_status() # Check initial status

# Create internal folder structure for this project

## data/
dir.create("data/flatFiles") # For AtoMx flat files
dir.create("data/flatFiles/CoronalHemisphere") # Slide specific folder
dir.create("data/seuAtoMx") # For AtoMx Seurat object

## output/
dir.create("output/processed_data") # For intermediate/processed data files
dir.create("output/performance_reports") # For performance reports

# Remove unnecessary README.md files
file.remove("code/README.md")
file.remove("data/README.md")
file.remove("output/README.md")

# Commit changes to Git repo
wflow_status() # Check status
wflow_git_commit(all = TRUE,
                 message = "Change directory structure and delete README files")


# Add data files ----------------------------------------------------------

# First, manually add the data into "/data/flatFiles/CoronalHemisphere"

# Second, modify .gitignore, to avoid Git tracking this files
## Add: "data/flatFiles/CoronalHemisphere/*csv" into .gitignore

# Third, create README.md files for "data/flatFiles/CoronalHemisphere/" and
# "data/seuAtoMx/" to explain the purpose of those folders
file.create("data/flatFiles/CoronalHemisphere/README.md")
file.create("data/seuAtoMx/README.md")

# Commit changes to Git repo
wflow_status() # Check status
wflow_git_commit("data/",
                 all = TRUE,
                 message = "Add input data, modify .gitignore and add README.md files in data folders")


# Add auxiliary code scripts ----------------------------------------------

# Manually add the scripts "aux_functions.R" and "utils.R" into "code/"

# Commit changes to Git repo
wflow_status() # Check status
wflow_git_commit("code/",
                 message = "Add auxiliary code")


# Add analysis Rmd files --------------------------------------------------

# First, manually add the Rmd scripts into "analysis/":

## MAIN PIPELINE SCRIPTS, FROM DATA LOADING TO DIMENSIONAL REDUCTION
## 0.0_data_loading.Rmd --> MAIN PIPELINE
## 1.0_qc_and_filtering.Rmd --> MAIN PIPELINE
## 2.0_normalization.Rmd --> MAIN PIPELINE
## 3.0_dimensional_reduction.Rmd --> MAIN PIPELINE

## MAIN PIPELINE SCRIPTS, ALTERNATIVES FOR CELL TYPING
## 4.0_insitutype_cell_typing.Rmd --> MAIN PIPELINE: OPTION SUPERVISED CLASSIFICATION
## 4.1_insitutype_unsup_clustering.Rmd --> MAIN PIPELINE: OPTION UNSUPERVISED CLUSTERING 1
## 4.2_seurat_unsup_clustering.Rmd --> MAIN PIPELINE: OPTION UNSUPERVISED CLUSTERING 2

## NOT MAIN PIPELINE SCRIPTS, INCLUDED TO SHOW AS EXAMPLE IN RESULTS WEBSITE
## 5.0_RC_normalization.Rmd
## 5.1_RC_dimensional_reduction.Rmd
## 6.0_Log_normalization.Rmd
## 6.1_Log_dimensional_reduction.Rmd

# Commit changes to Git repo
wflow_status() # Check status
wflow_git_commit("analysis/",
                 message = "Add Rmds files in analysis")

# Second, modify .gitignore, to avoid Git tracking the intermediate/processed
# data of the analysis. Add the following to .gitignore:
## "output/processed_data/*RDS"
## "output/processed_data/RC/*RDS"
## "output/processed_data/Log/*RDS"
## "output/processed_data/SCT/*RDS"
## "NBClust-Plots"

# Third, create a README.md file for "output/processed_data/" to explain the
# purpose of this folder
file.create("output/processed_data/README.md")

# Commit changes to Git repo
wflow_status() # Check status
wflow_git_commit("output",
                 all = TRUE,
                 message = "Modify .gitignore and add processed_data/README.md")


# Customize website files -------------------------------------------------

# First, modify about.Rmd, index.Rmd and license.Rmd files

# Second, add additional Rmd files to complement my website:
## dataset.Rmd
## pipeline.Rmd
## clus_examples.Rmd
## norm_examples.Rmd

# Modify _site.yml to customize website navbar

# Modify general README.md of the project to present repo and instructions of use

# Commit changes to Git repo
wflow_status() # Check status
wflow_git_commit(c("analysis/clus_examples.Rmd",
                   "analysis/dataset.Rmd",
                   "analysis/norm_examples.Rmd",
                   "analysis/pipeline.Rmd"),
                 all = TRUE,
                 message = "Edit website files")

# Manually add the script "total_time_mem_function.R" into "code/", needed for
# the website results presentation

# Commit changes to Git repo
wflow_status() # Check status
wflow_git_commit("code/total_time_mem_function.R",
                 message = "Add total_time_mem function to auxiliary code")


# Execute all Rmd files and fix errors ------------------------------------

wflow_build() # Executes all, as they have never been executed before
wflow_status() # Check status

# Review hmtl results and web preview
wflow_status() # Check status

# Fix links in _site.yml
wflow_git_commit("analysis/_site.yml",
                 message = "Fix links in navbar")

# Fix plot sizes in clus_examples.Rmd
wflow_git_commit("analysis/_site.yml",
                 message = "Fix plot sizes in clus_examples.Rmd")

# Add image in docs/ to display in website section: pipelines.Rmd
dir.create("docs/images") # Manually add image here
wflow_git_commit("analysis/pipeline.Rmd",
                 message = "Add pipeline diagram image")

# Change number of selected PCs in scripts 3.0, 5.1 y 6.1
wflow_git_commit(c("analysis/3.0_dimensional_reduction.Rmd",
                   "analysis/5.1_RC_dimensional_reduction.Rmd",
                   "analysis/6.1_Log_dimensional_reduction.Rmd"),
                 message = "Modify number of selected PCs for UMAP")

# Re-execute modified scripts and all the rest downstream
wflow_build(c("analysis/3.0_dimensional_reduction.Rmd",
              "analysis/4.0_insitutype_cell_typing.Rmd",
              "analysis/4.1_insitutype_unsup_clustering.Rmd",
              "analysis/4.2_seurat_unsup_clustering.Rmd",
              "analysis/5.1_RC_dimensional_reduction.Rmd",
              "analysis/6.1_Log_dimensional_reduction.Rmd",
              "analysis/clus_examples.Rmd",
              "analysis/pipeline.Rmd"))

# Review hmtl results and web preview
wflow_status() # Check status

# Fix pipeline diagram positioning and description in pipeline.Rmd
wflow_git_commit("analysis/pipeline.Rmd",
                 message = "Fix pipeline diagram positioning and caption")

# Add performance reports to git tracking
wflow_git_commit("output/performance_reports",
                 message = "Add performance reports to git tracking")


# Publish the website -----------------------------------------------------

wflow_publish(files = c("analysis/0.0_data_loading.Rmd",
                        "analysis/1.0_qc_and_filtering.Rmd",
                        "analysis/2.0_normalization.Rmd",
                        "analysis/3.0_dimensional_reduction.Rmd",
                        "analysis/4.0_insitutype_cell_typing.Rmd",
                        "analysis/4.1_insitutype_unsup_clustering.Rmd",
                        "analysis/4.2_seurat_unsup_clustering.Rmd",
                        "analysis/5.0_RC_normalization.Rmd",
                        "analysis/5.1_RC_dimensional_reduction.Rmd",
                        "analysis/6.0_Log_normalization.Rmd",
                        "analysis/6.1_Log_dimensional_reduction.Rmd",
                        "analysis/about.Rmd",
                        "analysis/clus_examples.Rmd",
                        "analysis/dataset.Rmd",
                        "analysis/index.Rmd",
                        "analysis/license.Rmd",
                        "analysis/norm_examples.Rmd",
                        "analysis/pipeline.Rmd"),
              message = "Publish all for the first time")


# Fixes to website errors--------------------------------------------------

# Fix some formatting error in website Rmd files
wflow_status() # Check status
wflow_git_commit(c("analysis/pipeline.Rmd",
                   "analysis/clus_examples.Rmd",
                   "analysis/norm_examples.Rmd"),
                 message = "Fix formatting errors in web sections")

# Re-publish modified files
wflow_publish(files = c("analysis/clus_examples.Rmd",
                        "analysis/norm_examples.Rmd",
                        "analysis/pipeline.Rmd"),
              message = "Re-publish modified web sections")

wflow_git_commit("output/performance_reports",
                 message = "Include performance_reports after publishing")


# Final fixes to grammatical and formatting errors ------------------------

# Fix grammatical and format errors in website and repo README file
wflow_status() # Check status
wflow_git_commit(c("README.md",
                   "analysis/_site.yml",
                   "analysis/clus_examples.Rmd",
                   "analysis/index.Rmd",
                   "analysis/pipeline.Rmd",
                   "docs/images"), # Track pipeline diagram to appear in web
                 message = "Fix grammatical and format errors in web and README")

# Re-publish all, as changes have been made to _site.yml that affects all
wflow_publish(republish = TRUE,
              message = "Re-publish the whole web to include changes in navbar")

wflow_git_commit(c("analysis/_site.yml",
                   "output/performance_reports"),
                 message = "Include performance_reports and _site.yml after publishing")

# Add final executing times in pipeline.Rmd and publish it
wflow_publish("analysis/pipeline.Rmd",
              message = "Add final executing times in pipeline.Rmd")



# Add this document to the project directory ------------------------------

wflow_status() # Check status
wflow_git_commit(c("analysis/_site.yml",
                   "output/performance_reports"),
                 message = "Include performance_reports and _site.yml after publishing")



# Link local repo to remote GitHub repo -----------------------------------

wflow_use_github() # Creates remote repo and links GitHub account
system("git push -u origin master") # Push local repo to remote repo


# Activate GitHub Pages ---------------------------------------------------

# Go to remote GitHub repository > Settings > Pages > Set "branch" to "master/docs"
