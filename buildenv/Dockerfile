FROM ubuntu:19.10

ENV TZ=Europe/Prague
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y \
  texlive \
  texlive-latex-base  \
  texlive-latex-extra \
  texlive-extra-utils \
  texlive-bibtex-extra \
  texlive-lang-czechslovak

RUN apt install -y git git-lfs