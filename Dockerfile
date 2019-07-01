## Dockerfile
FROM quay.io/biocontainers/kobas:3.0.3--py27_1
MAINTAINER Amanda Cooksey
LABEL Description="kobas_wrapper"

#USER root

# Install all the updates and download dependencies
#RUN apt-get update && apt-get install -y git

# ADD the wrapper script
ADD wrapper.sh /usr/bin

# Change the permissions and the path for the script
RUN chmod +x /usr/bin/wrapper.sh

# Entrypoint
ENTRYPOINT ["/usr/bin/wrapper.sh"]

#USER biodocker

RUN mkdir /work-dir /data

WORKDIR /work-dir
