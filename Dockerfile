# Build from the base image so that we can develop and test rapidly
# This will have ParaView and conda all set up properly
FROM ipp_base

WORKDIR /root
COPY . ./ipyparaview/
WORKDIR /root/ipyparaview

RUN conda update --quiet --yes -c conda-forge nodejs

# Install ipyparaview
RUN pip install -e .
RUN jupyter nbextension install --py --symlink --sys-prefix ipyparaview
RUN jupyter nbextension enable --py --sys-prefix ipyparaview
RUN jupyter labextension install js

RUN apt-get install -y libxcursor-dev

# Set up for use
WORKDIR /root/ipyparaview/notebooks

ENTRYPOINT ["tini", "-g", "--", "start_xvfb.sh"]
# CMD ["/bin/bash"]
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
