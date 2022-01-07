FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y install make libopenmpi-dev libfftw3-dev

ARG RUNNER=runner
RUN adduser --disabled-password ${RUNNER}
RUN echo "${RUNNER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN chown -R ${RUNNER}:${RUNNER} /home/${RUNNER}
WORKDIR /home/${RUNNER}
USER ${RUNNER}
