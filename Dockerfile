FROM continuumio/anaconda3

WORKDIR /var/data
RUN apt-get -qqy update \
    && apt-get -qqy upgrade \
    && apt-get -y --no-install-recommends install \
        build-essential \
        libmecab2 \
        libmecab-dev \
        mecab \
        mecab-ipadic \
        mecab-ipadic-utf8 \
        mecab-utils \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && mkdir -p `mecab-config --dicdir`"/mecab-ipadic-neologd" \
    && ./bin/install-mecab-ipadic-neologd -n -y -a \
    && pip install mecab-python3

# RUN conda install -y numpy scipy \
#    && conda install -y gensim
# HACK: Intel MKL FATAL ERROR: Cannot load libmkl_avx2.so or libmkl_def.so.
RUN pip install -U numpy scipy \
    && pip install -U gensim
