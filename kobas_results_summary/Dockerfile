## Dockerfile
FROM ubuntu:22.04
LABEL Description=""

# Install all the updates and download dependencies
RUN apt-get update && \
    apt-get install -y \
    locales \
    git \
    wget \
    bzip2

#RUN locale-gen en_US.UTF-8
# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ADD create_KOBAS_pathway_tsv.pl /usr/bin/

# Entrypoint
ENTRYPOINT ["/usr/bin/create_KOBAS_pathway_tsv.pl"]


# Add path to working directory
WORKDIR /workdir
