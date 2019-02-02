FROM arm32v7/ubuntu:bionic

ENV LANG C.UTF-8

COPY indi-launchpad.gpg /etc/apt/trusted.gpg.d/
COPY mutlaqja-ubuntu-ppa-bionic.list /etc/apt/sources.list.d/

RUN apt-get update && apt-get --no-install-recommends install -y \
     libindi1 \
     indi-bin \
     dumb-init \
     ser2net \
  && rm -rf /var/lib/apt/lists/*

COPY ser2net.conf /etc/

# Install pip3 and indiweb dependencies
RUN apt-get update && apt-get --no-install-recommends install -y \
     python3-pip python3-setuptools \
     python3-psutil python3-bottle python3-requests \
  && rm -rf /var/lib/apt/lists/*

COPY indiweb-0.1.6-py3-none-any.whl /tmp/

RUN pip3 install /tmp/indiweb-0.1.6-py3-none-any.whl

RUN useradd -ms /bin/bash -G dialout indi

RUN mkdir -p /indicfg && chown -R indi:indi /indicfg

USER indi
WORKDIR /home/indi

ENTRYPOINT [ "dumb-init", "--" ]
CMD [ "indi-web", "-v", "--conf", "/indicfg" ]
