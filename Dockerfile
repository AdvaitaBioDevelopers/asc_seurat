# Ubuntu latest
FROM kirstlab/asc_seurat:dynverse_v2.2

# Owner
LABEL Wendell Jacinto Pereira <wendelljpereira@gmail.com>
SHELL ["/bin/bash", "-c"]

# Set workdir
WORKDIR /app
COPY www /app/www
COPY R /app/R

RUN apt-get update --allow-releaseinfo-change && apt-get upgrade -y && apt-get clean
RUN apt-get remove -y binutils && apt-get clean
RUN apt-get install -y xml2 libxml2-dev libssl-dev && apt-get clean
RUN apt-get install -y libcurl4-openssl-dev unixodbc-dev && apt-get clean
RUN apt-get update --allow-releaseinfo-change && apt-get clean
RUN apt-get install -y libhdf5-dev
RUN apt-get -y install libcairo2-dev libxt-dev libfontconfig1-dev
# support libraries added tested with buld on mac, addresses tidyverse build issue, fftw3 added for "metap"
RUN apt-get install -y build-essential
RUN apt-get install -y libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev
RUN apt-get install -y libgsl-dev
RUN apt-get update && apt-get clean


# Install CRAN packages
# biocmanager
RUN R -e 'install.packages("BiocManager", dep = T, version = "3.12")'
RUN R -e 'library(BiocManager)'
# tidyverse
RUN R -e 'install.packages("tidyverse", dep = T)'
RUN R -e 'library(tidyverse)'
# seurat
# * added gfortran overide to build-essential for newer package - tidyverse uses the older version
RUN apt-get install -y gfortran
RUN R -e 'install.packages("Seurat", dep = T)'
RUN R -e 'library(Seurat)'
RUN R -e 'install.packages("SeuratObject", dep = T)'
RUN R -e 'library(SeuratObject)'
# patchwork
RUN R -e 'install.packages("patchwork", dep = T)'
RUN R -e 'library(patchwork)'
# vroom
RUN R -e 'install.packages("vroom", dep = T)'
RUN R -e 'library(vroom)'
# ggplot2
RUN R -e 'install.packages("ggplot2", dep = T)'
RUN R -e 'library(ggplot2)'
# svglite
RUN R -e 'install.packages("svglite", dep = T)'
RUN R -e 'library(svglite)'
# circlize
RUN R -e 'install.packages("circlize", dep = T)'
RUN R -e 'library(circlize)'
# reactable
RUN R -e 'install.packages("reactable", dep = T)'
RUN R -e 'library(reactable)'
# sctransform
RUN R -e 'install.packages("sctransform", dep = T)'
RUN R -e 'library(sctransform)'
# shiny
RUN R -e 'install.packages("shiny", dep = T)'
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
# dplyr
RUN R -e 'install.packages("dplyr", dep = T)'
RUN R -e 'library(dplyr)'
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
RUN R -e 'BiocManager::install("tradeSeq")'
RUN R -e 'library(tradeSeq)'
# single cell experiment
RUN R -e 'BiocManager::install("SingleCellExperiment")'
RUN R -e 'library(SingleCellExperiment)'
# slingshot
RUN R -e 'BiocManager::install("slingshot")'
RUN R -e 'library(slingshot)'
# biomart
RUN R -e 'BiocManager::install("biomaRt")'
RUN R -e 'library(biomaRt)'
# topgo
RUN R -e 'BiocManager::install("topGO")'
RUN R -e 'library(topGO)'
# glmGamPoi
RUN R -e 'BiocManager::install("glmGamPoi")'
RUN R -e 'library(glmGamPoi)'

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
	apt update && \
 	apt install -y docker-ce

# Configuring Docker
RUN usermod -aG docker root

 # Get server files
COPY global.R /app/global.R
COPY server.R /app/server.R
COPY ui.R /app/ui.R
COPY /scripts/bscripts/init_app.sh /app/init_app.sh

# expose port
EXPOSE 3838

# Fix permissions
RUN chmod a+rwx -R /app/*
RUN chmod a+rwx -R /app

# Init image
CMD ./init_app.sh

# The error is caused by the fact that the 'tidyverse' package is not installed in the system. You can fix it by modifying the Dockerfile to include the installation of the 'tidyverse' package before calling the 'library' function. Here is an updated version of the Dockerfile:
# 
# ```
# FROM rocker/tidyverse:latest
# 
# # install dependencies
# RUN apt-get update && apt-get install -y git-core libssl-dev libcurl4-gnutls-dev
# 
# # install packages
# RUN R -e 'install.packages(c("tidyverse", "Seurat"), dependencies = TRUE)'
# 
# # set working directory
# WORKDIR /app
# 
# # copy files
# COPY . /app
# 
# # run analysis
# CMD ["Rscript", "analysis.R"]
# ```
# 
# Note that we have added the installation of the 'tidyverse' package, along with the 'Seurat' package, using the same R command. This should fix the issue and allow you to run the Docker container without errors.
# 
