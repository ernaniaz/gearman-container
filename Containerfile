# Gearman 1.1.20 Containerfile
# Maintained by Ernani Azevedo <azevedo@voipdomain.io>
FROM registry.access.redhat.com/ubi9:9.1.0

# Add some useful environment variables
ENV NAME=gearman \
    GEARMAN_VERSION=1.1.20 \
    GEARMAN_SHORT_VERSION=1 \
    VERSION=1.1.20

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
LABEL description="Gearman ${GEARMAN_VERSION} base on an UBI9 image"
MAINTAINER Ernani Azevedo <azevedo@voipdomain.io>

# Install packages and startup file
ADD https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/boost-system-1.75.0-8.el9.x86_64.rpm \
    https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/boost-program-options-1.75.0-8.el9.x86_64.rpm \
    https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/gearmand-${GEARMAN_VERSION}-1.el9.x86_64.rpm \
    https://raw.githubusercontent.com/ernaniaz/gearman-container/main/RPMS/libgearman-${GEARMAN_VERSION}-1.el9.x86_64.rpm \
    /tmp/
ADD https://raw.githubusercontent.com/ernaniaz/gearman-container/main/gearman-start.sh /usr/local/sbin/

# Install package and fix permissions
RUN cd /tmp \
    && dnf install -y boost-system-1.75.0-8.el9.x86_64.rpm boost-program-options-1.75.0-8.el9.x86_64.rpm gearmand-${GEARMAN_VERSION}-1.el9.x86_64.rpm libgearman-${GEARMAN_VERSION}-1.el9.x86_64.rpm \
    && rm -f boost-system-1.75.0-8.el9.x86_64.rpm boost-program-options-1.75.0-8.el9.x86_64.rpm gearmand-${GEARMAN_VERSION}-1.el9.x86_64.rpm libgearman-${GEARMAN_VERSION}-1.el9.x86_64.rpm \
    && dnf clean all \
    && rm -rf /var/cache/yum/* \
    && chmod 755 /usr/local/sbin/gearman-start.sh \
    && chown root:root /usr/local/sbin/gearman-start.sh

# Health check
HEALTHCHECK --interval=5m --timeout=3s --retries=2 \
    CMD test $(supervisorctl status gearmand | awk '{print $2}' | grep 'RUNNING' | wc -l) -eq 1 || exit 1

# Expose Gearman port
EXPOSE 4730/tcp

# Execute as unprivileged user
USER gearmand

# Running Gearman
ENTRYPOINT ["gearman-start.sh"]
