FROM registry.redhat.io/rhoar-nodejs/nodejs-10
# This image provides a Node.JS environment you can use to run your
# Node.JS applications.
EXPOSE 8080
# This image will be initialized with "npm run $NPM_RUN"
# See https://docs.npmjs.com/misc/scripts, and your repo's package.json
# file for possible values of NPM_RUN
ENV NODE_VERSION=10.13.0 \
    NPM_VERSION=6.4.1 
ENV NPM_RUN=start \
    NODE_LTS=false \
    NPM_CONFIG_LOGLEVEL=info \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    NPM_CONFIG_TARBALL=/usr/share/node/node-v${NODE_VERSION}-headers.tar.gz \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    DEBUG_PORT=5858 \
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    SUMMARY="Platform for building and running Node.js $NODE_VERSION applications" \
    DESCRIPTION="Node.js $NODE_VERSION available as a container is a base platform for \
building and running various Node.js $NODE_VERSION applications and frameworks. \
Node.js is a platform built on Chrome's JavaScript runtime for easily building \
fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model \
that makes it lightweight and efficient, perfect for data-intensive real-time applications \
that run across distributed devices."
LABEL io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Node.js $NODE_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs,nodejs-$NODE_VERSION" \
      com.redhat.deployments-dir="/opt/app-root/src" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858" \
      maintainer="Lance Ball <lball@redhat.com>" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      version="$NODE_VERSION" \
      name="rhoar-nodejs" \
      com.redhat.component="rhoar-nodejs-container" \
      name="rhoar-nodejs/nodejs-10" \
      release="0"
USER root
RUN subscription-manager register --username cvicensa@redhat.com --password "!N0str0m075." --auto-attach
RUN INSTALL_PKGS="rhoar-nodejs10 npm nss_wrapper " && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum install -y  httpd24-libcurl && \
    yum clean all -y
#RUN ldconfig -n /opt/rh/httpd24/root/usr/lib64/ && ldconfig -p | head -5 
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rh/httpd24/root/usr/lib64
RUN chown -R 1001:1001 /opt/app-root

USER 1001

COPY ./s2i/ $STI_SCRIPTS_PATH
COPY --chown=1001:1001 ./contrib/ /opt/app-root

# Set the default CMD to print the usage
CMD ${STI_SCRIPTS_PATH}/usage