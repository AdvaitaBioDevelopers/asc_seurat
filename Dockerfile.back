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

