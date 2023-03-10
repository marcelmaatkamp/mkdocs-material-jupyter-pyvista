ARG MKDOCS_MATERIAL_VERSION
FROM ghcr.io/marcelmaatkamp/mkdocs-material-jupyter:${MKDOCS_MATERIAL_VERSION}

USER root
RUN \
 apt-get update -y &&\
 apt-get -y install \
    xvfb \
    libgl1-mesa-dev \
    gnupg \
    ca-certificates \
    curl \
    zip &&\
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

WORKDIR /docs/
COPY material /docs/material 
COPY docs /docs/docs 
COPY mkdocs.yml /docs/mkdocs.yml

RUN \
  git config --global --add safe.directory /docs

RUN \
  curl -s "https://get.sdkman.io" | bash &&\
  source "$HOME/.sdkman/bin/sdkman-init.sh" &&\
  sdk install java 19.0.2.fx-zulu &&\
# sdk install java 19.0.2-open &&\
# sdk install java 19.0.2-open &&\
# sdk install java 11.0.18-zulu &&\
  sdk install maven &&\
  source "$HOME/.sdkman/bin/sdkman-init.sh" &&\
  python -c 'import imagej; ij = imagej.init("2.5.0"); print(ij.getVersion())'

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
