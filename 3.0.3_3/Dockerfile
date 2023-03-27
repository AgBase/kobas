## Dockerfile
FROM ubuntu:18.04


ENV DEBIAN_FRONTEND noninteractive

# Install all the updates and download dependencies
RUN apt-get update && \
    apt-get install -y \
    locales \
    git \
    wget \
    bzip2 \
    nano \
    python-dev \
    sqlite3 \
    libsqlite3-dev \
    build-essential \
    python-pip \
    python-numpy \
    python-pandas \
    r-base \
    python-matplotlib

WORKDIR /usr/bin/

#INSTALL BLAST
RUN wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/ncbi-blast-2.13.0+-x64-linux.tar.gz && \
    tar -xvzf ncbi-blast-2.13.0+-x64-linux.tar.gz

#INSTALL BIOPYTHON
RUN wget http://biopython.org/DIST/biopython-1.76.tar.gz && \
    tar -xzvpf biopython-1.76.tar.gz && \
    cd biopython-1.76 && \
    python setup.py build && \
    python setup.py test && \
    python setup.py install 

#INSTALL QVALUE (BIOCONDUCTOR)
RUN R -e "install.packages('BiocManager')"
RUN R -e 'BiocManager::install("qvalue")'

#INSTALL RPY2
RUN pip install rpy2==2.8.6

# Set the locale
RUN locale-gen en_US.UTF-8
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# ADD KOBAS STANDALONE DOWNLOAD
# IF YOU WANT TO BUILD THE CONTAINER YOU WILL HAVE TO DOWNLOAD THE TAR FILE INDENPENDENTLY FROM HERE: http://kobas.cbi.pku.edu.cn/download/
ADD kobas-3.0.3.tar_*.gz /usr/bin/

#ADD the wrapper script
ADD wrapper.sh /usr/bin/
ADD kobasrc /etc
#RUN mv /etc/kobasrc /etc/.kobasrc
RUN chmod a+r /etc/kobasrc

ADD create_KOBAS_pathway_tsv.pl /usr/bin/

RUN mkdir -p /work-dir
RUN rm -r /usr/bin/kobas-3.0/seq_pep /usr/bin/kobas-3.0/sqlite3

# Change the permissions and the path for the script
RUN chmod +x /usr/bin/wrapper.sh

ENV PATH=/usr/bin/kobas-3.0/scripts:/usr/bin/ncbi-blast-2.13.0+/bin/:/usr/bin/kobas-3.0/src/kobas/scripts/:$PATH
ENV PYTHONPATH=/usr/bin/kobas-3.0/src/:$PYTHONPATH

WORKDIR /work-dir

# Entrypoint
ENTRYPOINT ["/usr/bin/wrapper.sh"]

