# Flat Files (.csv)

The dataset used for the pipeline construction and generation of example vignettes corresponds to the *Coronal Hemisphere* sample from the [*CosMx SMI Mouse Brain FFPE Dataset*](https://nanostring.com/products/cosmx-spatial-molecular-imager/ffpe-dataset/cosmx-smi-mouse-brain-ffpe-dataset/). This dataset is publicly available for download from the Nanostring® website and consists of samples from various sections of FFPE mouse brain tissue, analyzed using the CosMx™ SMI technology and the CosMx™ Mouse Neuroscience Panel, specifically designed to detect up to 1,000 genes in neuronal tissues.

The raw data has not been included in the GitHub repository, as it does not originate from this project and may be subject to third-party usage restrictions. For replication purposes, the original files can be accessed and download from the Nanostring® website using the following links: <https://nanostring.com/resources/coronal-hemisphere-basic-data-files/>.

Once the data is downloaded, place the *exprMat_file.csv*, *fov_positions_file.csv* and *metadata_file.csv* files in this folder.

For using the pipeline with a different dataset or multiple slides, place the corresponding *exprMat_file.csv*, *fov_positions_file.csv* and *metadata_file.csv* files of each slide in a slide-specific folder, like in this example:

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
