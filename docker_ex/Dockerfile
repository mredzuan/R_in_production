FROM rocker/r-ver:3.4.4

ARG WHEN

RUN mkdir /home/analysis

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('tidystringdist')"

COPY myscript.R /home/analysis/myscript.R

CMD cd /home/analysis \
  && R -e "source('myscript.R')" \
  && mv /home/analysis/p.csv /home/results/p.csv

