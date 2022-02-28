# Gearman 1.1.19.1 Containerfile
# Maintained by Ernani Azevedo <azevedo@voipdomain.io>
FROM ubi8/ubi:8.3

LABEL description="Gearman 1.1.19.1 base on a RHEL8 image"

MAINTAINER Ernani Azevedo <azevedo@voipdomain.io>

# Install packages and startup file
COPY ./RPMS/ /tmp/
COPY ./gearman-start.sh /usr/local/sbin/
RUN cd /tmp \
    && dnf install -y boost-program-options-1.66.0-10.el8.x86_64.rpm boost-system-1.66.0-10.el8.x86_64.rpm gearmand-1.1.19.1-18.el8.x86_64.rpm libgearman-1.1.19.1-18.el8.x86_64.rpm \
    && rm -f boost-program-options-1.66.0-10.el8.x86_64.rpm boost-system-1.66.0-10.el8.x86_64.rpm gearmand-1.1.19.1-18.el8.x86_64.rpm libgearman-1.1.19.1-18.el8.x86_64.rpm \
    && dnf clean all \
    && chmod 755 /usr/local/sbin/gearman-start.sh \
    && chown root:root /usr/local/sbin/gearman-start.sh

# Expose Gearman port
EXPOSE 4730/tcp

# Running Gearman
ENTRYPOINT ["gearman-start.sh"]
