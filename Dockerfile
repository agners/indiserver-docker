FROM arm32v7/ubuntu:bionic

ENV LANG C.UTF-8

COPY indi-launchpad.gpg /etc/apt/trusted.gpg.d/
COPY mutlaqja-ubuntu-ppa-bionic.list /etc/apt/sources.list.d/

RUN apt-get update && apt-get --no-install-recommends install -y \
     libindi1 \
     indi-bin \
  && rm -rf /var/lib/apt/lists/*

# Install pip3 and indiweb dependencies
RUN apt-get update && apt-get --no-install-recommends install -y \
     python3-pip python3-setuptools \
     python3-psutil python3-bottle python3-requests \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install indiweb

RUN useradd -ms /bin/bash -G dialout indi

RUN mkdir -p /indicfg && chown -R indi:indi /indicfg

USER indi
WORKDIR /home/indi

ENTRYPOINT [ "indi-web" ]
CMD [ "-v", "--conf", "/indicfg" ]
