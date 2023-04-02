FROM python:3.9-buster

RUN apt-get update && \
    apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9

RUN pip install --upgrade pip && \
    curl -sSL https://install.python-poetry.org | python -
ENV PATH /root/.local/bin:$PATH

# Create Jupyter Notebook config file
RUN mkdir -p /root/.jupyter \
  && echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

# Install MeCab
RUN apt install -y --no-install-recommends mecab libmecab-dev mecab-ipadic-utf8 sudo \
  && pip install mecab-python3

# Install mecab-ipadic-NEologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /tmp/neologd \
  && /tmp/neologd/bin/install-mecab-ipadic-neologd -n -a -y \
  && sed -i -e "s|^dicdir.*$|dicdir = /usr/lib/mecab/dic/mecab-ipadic-neologd|" /etc/mecabrc \
  && rm -rf /tmp/neologd
