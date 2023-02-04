ARG JUPYTER_VERSION
FROM marcelmaatkamp/mkdocs-jupyter-example-jupyter:${JUPYTER_VERSION}

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

RUN pip install  \
    mkdocs-minify-plugin>=0.3 \
    mkdocs-redirects>=1.0 \
    pillow>=9.0 \
    cairosvg>=2.5 \
    jinja2>=3.0 \
    markdown>=3.2 \
    mkdocs>=1.4.2 \
    mkdocs-material-extensions>=1.1 \
    pygments>=2.14 \
    pymdown-extensions>=9.9.1 \
    colorama>=0.4 \
    regex>=2022.4.24 \
    requests>=2.26 \
    material

RUN pip uninstall -y mkdocs  &&\
    pip install mkdocs

EXPOSE 8000
ENTRYPOINT ["mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]