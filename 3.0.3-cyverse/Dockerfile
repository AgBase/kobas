## Dockerfile
FROM quay.io/biocontainers/kobas:3.0.3--py27_1
MAINTAINER Amanda Cooksey
LABEL Description="kobas_wrapper"

# ADD the wrapper script
ADD wrapper.sh /usr/bin
ADD kobasrc /etc


# Change the permissions and the path for the script
RUN chmod +x /usr/bin/wrapper.sh
RUN chmod a+r /etc/kobasrc

# Entrypoint
ENTRYPOINT ["/usr/bin/wrapper.sh"]

RUN mkdir /work-dir /seq_pep /sqlite3

WORKDIR /work-dir
