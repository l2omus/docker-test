FROM julia:0.4.1
MAINTAINER "Romain Pauli" gromainpauligmail.com
RUN apt-get update && \
    apt-get install -y curl cmake gettext gfortran pkg-config libgnutls28-dev \
    && rm -rf /var/lib/apt/lists/*

ENV JULIA_VER v0.4
ENV JULIA_PKG_DIR /root/.julia/${JULIA_VER}

RUN julia -e 'Pkg.update(); Pkg.add("Escher")'
RUN julia -e 'Pkg.add("Compose"); Pkg.add("Gadfly")'
RUN julia -e 'Pkg.add("SQLite"); Pkg.add("Roots")'
# RUN julia -e 'Pkg.checkout("Lazy"); Pkg.checkout("Patchwork"); Pkg.checkout("Mux")'
RUN ln -s ${JULIA_PKG_DIR}/Escher/bin/escher /usr/local/bin
RUN cd usr/

RUN git clone http://github.com/l2omus/vinum-analytics.git
VOLUME ["/usr/vinum-analytics"]

EXPOSE 5555
WORKDIR usr/vinum-analytics
CMD escher --serve
