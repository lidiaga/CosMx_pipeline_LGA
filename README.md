# CosMx™ SMI Data Analysis Pipeline

**Author:** Getino-Álvarez, Lidia\
**Date:** 04-Jun-2025

## Welcome to my Master's thesis repository

My name is Lidia Getino Álvarez and this repository, and its corresponding GitHub Pages website, serves the purpose of transparently sharing all the code, results and documentation of the final project of my Master's in Bioinformatics and Biostatistics of Universitat Oberta de Catalunya: ***"Implementation of a bioinformatics pipeline for the analysis of spatial transcriptomics data"***.

| **University:** Universitat Oberta de Catalunya  
| **Tutor:** Mireia Ferrer Almirall  
| **Developed at:** Statistics and Bioinformatics Unit (Vall d'Hebron Research Institute - VHIR)  

Here you will find a modular and reproducible pipeline for the analysis of spatial transcriptomics data generated with the CosMx™ SMI technology by Nanostring®. The pipeline begins from the AtoMx™ SIP exported flat files, although it is optimized to work with an AtoMx™ SIP exported Seurat object, too.

Hopefully, soon my thesis document will be available too, as a reference for a more profound insight into my work. For now, I hope what you find here is useful and interesting!

## Project directory structure

```         
CosMx_pipeline_LGA/
  ├── analysis/
  |     ├── 0.0_data_loading.Rmd
  |     ├── 1.0_qc_and_filtering.Rmd
  |     ├── 2.0_normalization.Rmd
  |     ├── 3.0_dimensional_reduction.Rmd
  |     ├── 4.0_insitutype_cell_typing.Rmd
  |     ├── 4.1_insitutype_unsup_clustering.Rmd
  |     ├── 4.2_seurat_unsup_clustering.Rmd
  |     ├── 5.0_RC_normalization.Rmd
  |     ├── 5.1_RC_dimensional_reduction.Rmd
  |     ├── 6.0_Log_normalization.Rmd
  |     ├── 6.1_Log_dimensional_reduction.Rmd
  |     ├── _site.yml
  |     ├── about.Rmd
  |     ├── clus_examples.Rmd
  |     ├── dataset.Rmd
  |     ├── index.Rmd
  |     ├── license.Rmd
  |     ├── norm_examples.Rmd
  |     └── pipeline.Rmd
  |
  ├── code/
  |     ├── aux_functions.R
  |     ├── total_time_mem_function.R
  |     └── utils.R
  |
  ├── data/
  │     ├── flatFiles/
  |     |     ├── CoronalHemisphere/
  |     |           └── README.md
  │     └── seuAtoMx/
  |           └── README.md
  |
  ├── docs/
  │     └── ... # resulting html files and figures
  |
  ├── output/
  │     ├── performance_reports/
  |     |     └── ... # resulting time and memory report files
  │     └── processed_data/
  |           └── README.md
  |
  ├── .gitattributes
  ├── .gitignore
  ├── .Rprofile
  ├── _workflowr.yml
  ├── CosMx_pipeline_LGA.Rproj
  ├── README.md
  └── workflowr_project_setup.R
```

## Requirements

All the code has been developed in R (v4.4.3), using the RStudio (v2024.12.1.563) environment. To reproduce the work, the following packages and versions will be needed\*:

|                    |                    |
|:------------------:|:------------------:|
|  rmarkdown v2.29   |   vecsets v1.4.    |
|  workflowr v1.7.1  |   ggplot2 v3.5.1   |
| data.table v1.17.0 |  patchwork v1.3.0  |
|   Matrix v1.7.2    |   viridis v0.6.5   |
|    here v1.0.1     |  pheatmap v1.0.12  |
|    dplyr v1.1.4    |  InSituType v2.0   |
| KableExtra v1.4.0  |  clustree v0.5.1   |
|   Seurat v4.4.0    | HGNChelper v0.8.15 |

*\*The complete set of dependencies and versions can be found in the Session Info section of each Rmarkdown file.*

## Workflowr and webpage

This repository and its associated webpage have been developed using the [workflowr](https://github.com/workflowr/workflowr) package. To know how this project was managed with this tool, check the `workflowr_project_setup.R` script above.

In the website, a dynamic presentation of the proposed pipeline, the methodology used, and an example of use with a public dataset can be found.

## Pipeline

The proposed pipeline consists of five main phases: data loading, QC and filtering, normalization, dimensional reduction and cell typing. These have been coded in independent RMarkdown documents, ensuring sequentiality through file naming:

```         
CosMx_pipeline_LGA/
  ├── analysis/
  |     ├── 0.0_data_loading.Rmd
  |     ├── 1.0_qc_and_filtering.Rmd
  |     ├── 2.0_normalization.Rmd
  |     ├── 3.0_dimensional_reduction.Rmd
  |     ├── 4.0_insitutype_cell_typing.Rmd
  |     ├── 4.1_insitutype_unsup_clustering.Rmd
  |     ├── 4.2_seurat_unsup_clustering.Rmd
  |     ...
  ...
```

To create a flexible pipeline, the documents have been parameterized, as far as possible, to allow for a variety of options without affecting their proper functioning (check [Usage](https://github.com/lidiaga/CosMx_pipeline_LGA/edit/master/README.md#usage)). However, the Cell typing phase is subdivided into three independent scripts, given the complexity of executing the different alternatives that the pipeline contemplates. Please check the website "Cell typing" section for more information.

## Usage

### Reproduce this project

1.  Clone the repository.

2.  Download the dataset and place the required files in the appropriate folder:

    1.  Follow the link from the [Dataset](https://github.com/lidiaga/CosMx_pipeline_LGA/edit/master/README.md#dataset) section and download the files and place the following files in the appropriate folder (data/flatFiles/CoronalHemisphere/): exprMat_file.csv, fov_positions_file.csv, and metadata_file.csv.

        ```         
        CosMx_pipeline_LGA/
          ├── analysis/...
          ├── code/
          ├── data/
          │     ├── flatFiles/
          |     |     └── CoronalHemisphere/
          |     |           ├── README.md
          |     |           ├── Run1000_S1_Half_exprMat_file.csv
          |     |           ├── Run1000_S1_Half_fov_positions_file.csv
          |     |           └── Run1000_S1_Half_metadata_file.csv
          │     ...
          ...
        ```

3.  Run the Rmarkdown documents (analysis/) in order:

    1.  Option 1: knit each Rmd file independently and in order.
    2.  Option 2: run all Rmd files in order using `worflowr`: run `wflow_build()` or `wflow_build(c("0.0_data_loading.Rmd", "1.0_qc_and_filtering.Rmd", "2.0_normalization.Rmd", "3.0_dimensional_reduction.Rmd", "4.0_insitutype_cell_typing.Rmd", "4.1_insitutype_unsup_clustering.Rmd", "4.2_seurat_unsup_clustering.Rmd"))`

### Use the pipeline with other data

1.  Clone the repository.

2.  Download the dataset and place the required files in the appropriate folder:

    1.  In the repository example, *CoronalHemisphere* is the name of the slide used, but if using a different dataset or multiple slides, place the exprMat_file.csv, fov_positions_file.csv and metadata_file.csv files of each slide in a slide-specific folder, like this:

        ```         
        CosMx_pipeline_LGA/
          ├── analysis/
          ├── code/
          ├── data/
          │     ├── flatFiles/
          |     |     ├── Slide1/
          |     |     |    ├── S1_exprMat_file.csv
          |     |     |    ├── S1_fov_positions_file.csv
          |     |     |    └── S1_metadata_file.csv
          |     |     └── Slide2/
          |     |     |    ├── S2_exprMat_file.csv
          |     |     |    ├── S2_fov_positions_file.csv
          |     |     |    └── S2_metadata_file.csv
          │     |     ...
          |     ...
          ...
        ```

    2.  Alternatively, if using the pipeline with an AtoMx™ SIP exported Seurat object, simply place the .RDS file inside the "seuAtoMx" folder (data/seuAtomx/).

3.  Run the Rmarkdown documents (analysis/) in order.

    1.  First, all Rmd files can be run manually in RStudio to select the appropriate parameters:

        1.  Two starting points are available:

            1.  If starting from the AtoMx™ SIP exported flat files (.csv): start in 0.0_data_loading.Rmd file.
            2.  If starting from the AtoMx™ SIP exported Seurat object: start in 1.0_qc_and_filtering.Rmd file.

        2.  Three normalization methods are available\*: follow the indications on 2.0_normalization.Rmd file and choose the preferred method. For more information, consult the "Normalization" section of the webpage.

        3.  Three cell typing methods are available\*:

            1.  Choose between supervised classification with InSituType, unsupervised clustering with InSitutype, or unsupervised clustering with Seurat. In both unsupervised clustering methods, cluster annotation is performed with ScType. However, this can be changed if desired.

            2.  Run the appropriate Rmd file: `4.0_insitutype_cell_typing.Rmd`, `4.1_insitutype_unsup_clustering.Rmd` or `4.2_seurat_unsup_clustering.Rmd`.

    2.  Then, to ensure reproducibility, the analysis can be run using `worflowr`, which automatically sets the same seed for all files and runs, and helps to keep version control with Git: run `wflow_build(c("0.0_data_loading.Rmd", "1.0_qc_and_filtering.Rmd", ...))` indicating the corresponding Rmd files to run.

*\*For more information, consult the "Normalization" and "Cell typing" sections of the webpage.*

## Dataset

The dataset used for the pipeline construction and generation of example vignettes corresponds to the Coronal Hemisphere sample from the CosMx SMI Mouse Brain FFPE Dataset. This dataset is publicly available for download from the NanoString® website and consists of samples from various sections of FFPE mouse brain tissue, analyzed using the CosMx™ SMI technology and the CosMx™ Mouse Neuroscience Panel, specifically designed to detect up to 1,000 genes in neuronal tissues.

The raw data has not been included in the GitHub repository, as it does not originate from this project and may be subject to third-party usage restrictions. For replication purposes, the original files can be accessed and downloaded from the Nanostring® website using the following links: <https://nanostring.com/resources/coronal-hemisphere-basic-data-files/>.

## License

### Code license

All code in this repository is licensed under the **MIT License**.

You can view the full license text by visiting [choosealicense.com/licenses/mit](https://choosealicense.com/licenses/mit/).

### Content license

All written content on this site is licensed under the **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)** license. For more details, see the [Creative Commons summary](https://creativecommons.org/licenses/by-nc-sa/4.0/) or read the full [legal code](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode.en).

## Citation

If you use or reference this work in academic or technical materials, please cite it as follows:

Getino-Álvarez, L. *Implementación de un pipeline bioinformático para análisis de datos de Spatial Transcriptomics*. GitHub repository, available at: https://github.com/lidiaga/CosMx_pipeline_LGA. Accessed on [Date].

## Acknowledgments

For this project, several vignettes were particularly valuable during the development of the pipeline. In particular, I want to make special mention of the [*Scratch Space Vignette: Basics of CosMx Analysis in R*](https://nanostring-biostats.github.io/CosMx-Analysis-Scratch-Space/posts/vignette-basic-analysis/) and the [*CosMxLite*](https://github.com/cancerbioinformatics/CosMx_Lite) vignette, which served as a key reference during the development of the pipeline. Additional references and acknowledgments can be found commented in the code and in my Master's Thesis manuscript.

## Contact

For questions, contributions, or suggestions, please open an issue or contact me through [my LinkedIn page](https://www.linkedin.com/in/lidiagetalv/).

------------------------------------------------------------------------

A [workflowr](https://github.com/workflowr/workflowr) project.
