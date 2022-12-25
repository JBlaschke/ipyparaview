FROM ubuntu:latest
LABEL Description="iPyParaView base container."

SHELL ["/bin/bash", "-c"]

USER root

WORKDIR /root

RUN apt-get update && \
    apt-get install -y --no-install-recommends libgl1-mesa-dev xvfb tini

# Install base utilities
RUN apt-get update && \
    apt-get install -y build-essential  && \
    apt-get install -y wget

# Install miniconda
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

RUN conda install --quiet --yes -c conda-forge \
    ipywidgets \
    jupyter \
    jupyterlab \
    ipython \
    pillow \
    paraview \
    nodejs \
    numpy \
    matplotlib \
    scipy

# https://github.com/NVIDIA/ipyparaview/issues/40
RUN conda install --quiet --yes -c conda-forge ipywidgets==7.7.1

COPY start_xvfb.sh /sbin/start_xvfb.sh
RUN chmod a+x /sbin/start_xvfb.sh

ENTRYPOINT ["tini", "-g", "--", "start_xvfb.sh"]
