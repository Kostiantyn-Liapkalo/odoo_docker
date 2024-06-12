FROM debian:bookworm AS download
RUN apt-get update && apt-get install -y curl
RUN curl -Ls https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -o wait-for-it.sh && \
    chmod +x wait-for-it.sh


FROM odoo:${VERSION:-17.0} AS base-odoo
COPY docker/docker-entrypoint.sh /usr/bin/docker-entrypoint
COPY --from=download /wait-for-it.sh /usr/bin/wait-for-it


FROM base-odoo AS debug-odoo
USER root
RUN pip install debugpy
USER odoo

ENTRYPOINT [ "bash", "/usr/bin/docker-entrypoint", "debug" ]

FROM base-odoo AS test-odoo
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3-pip
RUN mkdir -p /coverage/all && mkdir -p /coverage/local && chown -R odoo /coverage
RUN pip3 install pytest-odoo coverage pytest-html
USER odoo

ENTRYPOINT [ "bash", "/usr/bin/docker-entrypoint", "test" ]