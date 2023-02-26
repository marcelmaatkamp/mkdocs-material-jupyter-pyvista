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
    zip \
    libx11-xcb-dev \
    libglu1-mesa-dev \
    libxrender-dev \
    libxi-dev \
    libxkbcommon-dev \
    libxkbcommon-x11-dev \
    libxcb-xinerama0 \
    qt6-base-dev \
    pkg-config \
    libglib2.0-dev \
    libgtk-3-dev \
&&\
 rm -rf \
   /var/lib/apt/lists/* \
   /var/cache/apt/*
USER jovyan

COPY requirements.in requirements.in
RUN \
  pip install attrdict3 &&\
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

ENV QT_QPA_PLATFORM offscreen

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
