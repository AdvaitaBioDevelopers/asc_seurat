# Ubuntu latest
FROM kirstlab/asc_seurat:dynverse_v2.2

# Owner
LABEL Wendell Jacinto Pereira <wendelljpereira@gmail.com>
SHELL ["/bin/bash", "-c"]

# Set workdir
WORKDIR /app
COPY www /app/www
COPY R /app/R
COPY configuration_file_for_integration_analysis.csv /app/configuration_file_for_integration_analysis.csv

# Get server files
COPY global.R /app/global.R
COPY server.R /app/server.R
COPY ui.R /app/ui.R
COPY /scripts/bscripts/init_app.sh /app/init_app.sh

## Remove all unstable and testing entries
RUN sed -i 's/testing/bookworm/' /etc/apt/apt.conf.d/default
RUN rm -rf /etc/apt/sources.list.d/debian-unstable.list
RUN sed -i 's/testing/bookworm/' /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get remove -y binutils
RUN apt-get update --allow-releaseinfo-change
RUN apt-get install -y binutils xml2 libxml2-dev libssl-dev libcurl4-openssl-dev unixodbc-dev libhdf5-dev libcairo2-dev libxt-dev libfontconfig1-dev build-essential libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev libgsl-dev libfftw3-dev libv8-dev gdal-bin libgdal-dev
RUN apt-get update && apt-get clean


# Install CRAN packages
## set cores assuming that users are using a computer with 4 cores minimum
RUN echo 'options(Ncpus = 4)' >> ~/.Rprofile

# biocmanager
RUN R -e 'install.packages("BiocManager", dep = T, version = "3.12")'
RUN R -e 'library(BiocManager)'

# Tidyverse
RUN R -e 'install.packages("tidyverse", dep = T)'
RUN R -e 'library(tidyverse)'


# Check for packages 2 methods
# method 1
# if(!library(dplyr, logical.return = T)){
#             quit(status = 10)
#         }

# method 2
# if (!requireNamespace("package")) {
#   stop("Please install package.")
# }

# littler
RUN R -e 'install.packages("littler", dep = T)'
RUN R -e 'library(littler)'

# seurat
# * added gfortran overide to build-essential for newer package - tidyverse uses the older version
RUN apt-get install -y gfortran
RUN R -e 'install.packages("Seurat")'
RUN R -e 'library(Seurat)'

# Seuratobject is compiled when seurat is compiled
# RUN R -e 'install.packages("SeuratObject", dep = T)'
# Built during Seurat installation
RUN R -e 'library(SeuratObject)'

# patchwork comment: built while installing Seurat
# RUN R -e 'install.packages("patchwork", dep = T)'
RUN R -e 'library(patchwork)'

# vroom
RUN R -e 'install.packages("vroom", dep = T)'
RUN R -e 'library(vroom)'

# poorly
RUN R -e 'install.packages("plotly", dep = T)'
RUN R -e 'library(plotly)'

# ggplot2 - comment: built by seurat already
# RUN R -e 'install.packages("ggplot2", dep = T)'
RUN R -e 'library(ggplot2)'
# svglite
RUN R -e 'install.packages("svglite", dep = T)'
RUN R -e 'library(svglite)'
# circlize
RUN R -e 'install.packages("circlize", dep = T)'
RUN R -e 'library(circlize)'
# reactable
RUN R -e 'install.packages("reactable", dep = T, Ncpus = 4)'
RUN R -e 'library(reactable)'
# sctransform comment: built while compiling Seurat
# RUN R -e 'install.packages("sctransform", dep = T)'
RUN R -e 'library(sctransform)'
# shiny
# shiny is built when seurat is compiled
# RUN R -e 'install.packages("shiny", dep = T)'
RUN R -e 'library(shiny)'
RUN R -e 'install.packages("shinyWidgets", dep = T)'
RUN R -e 'library(shinyWidgets)'
RUN R -e 'install.packages("shinyFeedback", dep = T)'
RUN R -e 'library(shinyFeedback)'
RUN R -e 'install.packages("shinycssloaders", dep = T)'
RUN R -e 'library(shinycssloaders)'
# rclipboard
RUN R -e 'install.packages("rclipboard", dep = T)'
RUN R -e 'library(rclipboard)'
# future
RUN R -e 'install.packages("future", dep = T)'
RUN R -e 'library(future)'
# ggthemes
RUN R -e 'install.packages("ggthemes", dep = T)'
RUN R -e 'library(ggthemes)'
# multtest
RUN R -e 'BiocManager::install("multtest")'
RUN R -e 'library(multtest)'
# DT
RUN R -e 'install.packages("DT", dep = T)'
RUN R -e 'library(DT)'
# hdf5r
RUN R -e 'install.packages("hdf5r", dep = T)'
RUN R -e 'library(hdf5r)'

# metap - multtest must be installed first
RUN R -e 'install.packages("metap", dep = T)'
RUN R -e 'library(metap)'

# ComplexHeatmap
RUN R -e 'BiocManager::install("ComplexHeatmap")'
RUN R -e 'library(ComplexHeatmap)'
# tradeseq
RUN R -e 'BiocManager::install("tradeSeq", Ncpus = 4)'
RUN R -e 'library(tradeSeq)'
# single cell experiment
RUN R -e 'BiocManager::install("SingleCellExperiment")'
RUN R -e 'library(SingleCellExperiment)'
# slingshot
RUN R -e 'BiocManager::install("slingshot")'
RUN R -e 'library(slingshot)'
# biomart
RUN R -e 'BiocManager::install("biomaRt", Ncpus = 4)'
RUN R -e 'library(biomaRt)'
# topgo
RUN R -e 'BiocManager::install("topGO")'
RUN R -e 'library(topGO)'
# glmGamPoi
RUN R -e 'BiocManager::install("glmGamPoi", Ncpus = 4)'
RUN R -e 'library(glmGamPoi)'

# DESeq2
RUN R -e 'BiocManager::install("DESeq2")'
RUN R -e 'library(DESeq2)'

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
	apt update && \
 	apt install -y docker-ce

## Copy edited Seurat
COPY  Seurat.tar.gz /app/
RUN R CMD INSTALL /app/Seurat.tar.gz

#Configuring Docker
RUN usermod -aG docker root

# expose port
EXPOSE 3838

# # Fix permissions
RUN chmod a+rwx -R /app/*
RUN chmod a+rwx -R /app

# # Init image
CMD ./init_app.sh
