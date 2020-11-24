FROM camptocamp/mapserver:7.2

ENV BM_BRANCH=capc-test
ENV BM_COMMIT=a3d108d15b09c21609a524c444f0bf65fcb3f521

RUN apt-get update && \
    apt-get install --assume-yes --no-install-recommends git make python gcc curl unzip wget

COPY . /etc/mapserver && \
     chown -R www-data /etc/mapserver

RUN make -C /etc/mapserver/ data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/start-server"]

ENV STYLE=cagc
ENV DEBUG=1
ENV LAYERDEBUG=1
