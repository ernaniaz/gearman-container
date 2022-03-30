# Gearman 1.1.19.1 Containerfile
# Maintained by Ernani Azevedo <azevedo@voipdomain.io>
FROM ubi8/ubi:8.5

# Add some useful environment variables
ENV NAME=gearman \
    GEARMAN_VERSION=1.1.19.1 \
    GEARMAN_SHORT_VERSION=1 \
    VERSION=1.1.19.1

# Add a summary and a description
ENV SUMMARY="Container for running Gearman ${GEARMAN_VERSION}" \
    DESCRIPTION="Gearman provides a generic application framework to farm out work to other \
machines or processes that are better suited to do the work. It allows you to do \
work in parallel, to load balance processing, and to call functions between \
languages. It can be used in a variety of applications, from high-availability \
web sites to the transport of database replication events. In other words, it is \
the nervous system for how distributed processing communicates. \
Please refer to https://github.com/ernaniaz/gearman-container for the build scripts and to \
https://quay.io/repository/rhn_support_eazevedo/gearman for the image repository."

# Add label and maintainer
LABEL description="Gearman ${GEARMAN_VERSION} base on an UBI8 image"
MAINTAINER Ernani Azevedo <azevedo@voipdomain.io>

# Install packages and startup file
ADD https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/boost-program-options-1.66.0-10.el8.x86_64.rpm \
    https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/boost-system-1.66.0-10.el8.x86_64.rpm \
    https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/gearmand-${GEARMAN_VERSION}-18.el8.x86_64.rpm \
    https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/libgearman-${GEARMAN_VERSION}-18.el8.x86_64.rpm \
    /tmp/
ADD https://raw.githubusercontent.com/ernaniaz/gearman-container/main/gearman-start.sh /usr/local/sbin/

# Install package and fix permissions
RUN cd /tmp \
    && dnf install -y boost-program-options-1.66.0-10.el8.x86_64.rpm boost-system-1.66.0-10.el8.x86_64.rpm gearmand-${GEARMAN_VERSION}-18.el8.x86_64.rpm libgearman-${GEARMAN_VERSION}-18.el8.x86_64.rpm \
    && rm -f boost-program-options-1.66.0-10.el8.x86_64.rpm boost-system-1.66.0-10.el8.x86_64.rpm gearmand-${GEARMAN_VERSION}-18.el8.x86_64.rpm libgearman-${GEARMAN_VERSION}-18.el8.x86_64.rpm \
    && dnf clean all \
    && chmod 755 /usr/local/sbin/gearman-start.sh \
    && chown root:root /usr/local/sbin/gearman-start.sh

# Expose Gearman port
EXPOSE 4730/tcp

# Execute as unprivileged user
USER gearmand

# Running Gearman
ENTRYPOINT ["gearman-start.sh"]
