FROM public.ecr.aws/lambda/provided

ENV R_VERSION=4.0.5
ENV SNOWFLAKE_ODBC_VERSION=2.25.3

RUN yum -y install wget git tar

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
  && wget https://cdn.rstudio.com/r/centos-7/pkgs/R-${R_VERSION}-1-1.x86_64.rpm \
  && yum -y install R-${R_VERSION}-1-1.x86_64.rpm \
  && rm R-${R_VERSION}-1-1.x86_64.rpm

ENV PATH="${PATH}:/opt/R/${R_VERSION}/bin/"

# Install unixODBC
RUN yum install -y unixODBC unixODBC-devel

# Install Snowflake ODBC driver
RUN wget https://sfc-repo.snowflakecomputing.com/odbc/linux/${SNOWFLAKE_ODBC_VERSION}/snowflake-odbc-${SNOWFLAKE_ODBC_VERSION}.x86_64.rpm \
  && yum install -y snowflake-odbc-${SNOWFLAKE_ODBC_VERSION}.x86_64.rpm \
  && rm snowflake-odbc-${SNOWFLAKE_ODBC_VERSION}.x86_64.rpm

# System requirements for R packages
RUN yum -y install openssl-devel

RUN Rscript -e "install.packages(c('httr', 'jsonlite', 'logger', 'remotes', 'odbc'), repos = 'https://packagemanager.rstudio.com/all/__linux__/centos7/latest')"
RUN Rscript -e "remotes::install_github('mdneuzerling/lambdr')"

RUN mkdir /lambda
COPY runtime.R /lambda
RUN chmod 755 -R /lambda

RUN printf '#!/bin/sh\ncd /lambda\nRscript runtime.R' > /var/runtime/bootstrap \
  && chmod +x /var/runtime/bootstrap

CMD ["list_snowflake_drivers"]
