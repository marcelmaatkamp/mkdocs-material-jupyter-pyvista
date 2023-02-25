ARG MKDOCS_MATERIAL_VERSION
FROM ghcr.io/marcelmaatkamp/mkdocs-material-jupyter:${MKDOCS_MATERIAL_VERSION}

USER root
RUN \
 apt-get update -y &&\
 apt-get -y install \
    xvfb \
    libgl1-mesa-dev&&\
 rm -rf \
   /var/lib/apt/lists/* \
   /var/cache/apt/*
USER jovyan

COPY requirements.in requirements.in
RUN \
  pip install --upgrade \
    pip \
    pip-tools &&\
  pip-compile requirements.in  --resolver=backtracking --max-rounds 20 --verbose &&\
  pip install -r requirements.txt

RUN \
 conda install -c \
  beakerx beakerx_all

WORKDIR /docs/
COPY material /docs/material 
COPY docs /docs/docs 
COPY mkdocs.yml /docs/mkdocs.yml

RUN \
  git config --global --add safe.directory /docs

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
