FROM camptocamp/mapserver:7.2

RUN apt-get update && \
    apt-get install --assume-yes --no-install-recommends git make python gcc curl unzip wget


COPY . /etc/mapserver
RUN chown -R www-data /etc/mapserver


RUN make -C /etc/mapserver/ data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/start-server"]

ENV STYLE=cagc
ENV DEBUG=1
ENV LAYERDEBUG=1
