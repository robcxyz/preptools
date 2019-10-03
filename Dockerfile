FROM python:3.7.4-buster
# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

COPY requirements.txt .

RUN set -ex \
    && buildDeps=' \
        freetds-dev \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        libpq-dev \
        git \
    ' \
    && apt-get update -yqq \
    && apt-get upgrade -yqq \
    && apt-get install -yqq --no-install-recommends \
    libssl-dev \
    build-essential \
    automake \
    pkg-config \
    libtool \
    libffi-dev \
    libgmp-dev \
    libyaml-cpp-dev \
    python3.7-dev \
    libsecp256k1-dev \
    python3-pip \
    && pip install -r requirements.txt

COPY preptools /preptools
COPY tests /tests

COPY setup.py .
COPY setup.cfg .
COPY entrypoint.sh .

COPY ./build.sh .
RUN ./build.sh
RUN python setup.py install

ENTRYPOINT ["/entrypoint.sh"]
