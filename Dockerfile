ARG MKDOCS_MATERIAL_VERSION
FROM FROM ghcr.io/marcelmaatkamp/mkdocs-material-jupyter:${MKDOCS_MATERIAL_VERSION}

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

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
