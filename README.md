Gearman container image
=======================

Gearman 1.1.19.1 status:[![Docker Repository on Quay](https://quay.io/repository/ernaniaz/gearman-1.1.19.1/status "Docker Repository on Quay")](https://quay.io/repository/ernaniaz/gearman-1.1.19.1)

This repository contains Dockerfiles for Gearman container image.
The image was created using pre-built RPM packages and a start script.
The RPM files are available at RPMS/ and their source packages at SRPMS/.

To build the Kubertnets image, just run:
podman build --layers --force-rm --tag gearmand-1:1.1.19.1 .


Running Gearman
---------------

To run a container of this image, just run:
podman run -p 4730:4730 localhost/gearmand-1:1.1.19.1

You can use a long list of environment variables, as follow:

* GEARMAN_LISTEN: Set address the server should listen on. Default is 0.0.0.0.
* GEARMAN_PORT: Set port the server should listen on. Default is 4730.
* GEARMAN_VERBOSE: Set verbosity level. Deault is INFO. Available options are FATAL, ALERT, CRITICAL, ERROR, WARNING, NOTICE, INFO and DEBUG.
* GEARMAN_QUEUE_TYPE: Set persistent queue type of use. Default is builtin.
* GEARMAN_THREADS: Set number of I/O threads to use. Default is 4.
* GEARMAN_BACKLOG: Set number of backlog connections for listen. Default is 32.
* GEARMAN_FILE_DESCRIPTORS: Set number of file descriptors to allow for the process (total connections will be slightly less). Default is max allowed for user.
* GEARMAN_JOB_RETRIES: Set number of attempts to run the job before server removes it. This is helpful to ensure a bad job does not crash all available workers. Default is no limit.
* GEARMAN_ROUND_ROBIN: Set assign work in round-robin order per worker connection. The default is to assign work in the order of functions added by the worker. To enable, set to anything other than 0.
* GEARMAN_WORKER_WAKEUP: Set number of workers to wakeup for each job received. The default is to wakeup all available workers. Default is 0.
* GEARMAN_KEEPALIVE: Set enable keepalive on sockets. Default is disable. To enable, set to anything other than 0.
* GEARMAN_KEEPALIVE_IDLE: If keepalive is enabled, set the value for TCP_KEEPIDLE. Default is 30.
* GEARMAN_KEEPALIVE_INTERVAL: If keepalive is enabled, set the value for TCP_KEEPINTVL. Default is 10.
* GEARMAN_KEEPALIVE_COUNT: If keepalive is enabled, set the value for TCP_KEEPCNT. Default is 5.

If you're using a MySQL/MariaDB backend, you can (and should) also use those environment variables:

* GEARMAN_MYSQL_HOST: The MySQL/MariaDB server address. Default is localhost.
* GEARMAN_MYSQL_PORT: The MySQL/MariaDB server port. Default is 3306.
* GEARMAN_MYSQL_USER: The MySQL/MariaDB username. Default is root.
* GEARMAN_MYSQL_PASSWORD: The MySQL/MariaDB password. Default is password.
* GEARMAN_MYSQL_DB: The MySQL/MariaDB database name. Default is gearmand.
* GEARMAN_MYSQL_TABLE: The MySQL/MariaDB database table name. Default is gearman_queue.


Example usage
-------------

You can start a Gearman container for debugging purposes using:
podman run -p 4730:4730 -e GEARMAN_VERBOSE=DEBUG localhost/gearmand-1:1.1.19.1
