# Define custom function directory
ARG FUNCTION_DIR="/function"

FROM debian:12.5-slim as build-image

# Include global arg in this stage of the build
ARG FUNCTION_DIR

# Install build dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev \
    tini \
    nodejs \
    npm \
    autoconf \
    automake \
    libtool

# Copy function code
RUN mkdir -p ${FUNCTION_DIR}
COPY . ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

# Install Node.js dependencies
RUN npm install

# Install the runtime interface client
# this process need to cmake and more...
# (maybe build C lang source code)
RUN npm install aws-lambda-ric

# Grab a fresh slim copy of the image to reduce the final size
FROM debian:12.5-slim

# Required for Node runtimes which use npm@8.6.0+ because
# by default npm writes logs under /home/.npm and Lambda fs is read-only
ENV NPM_CONFIG_CACHE=/tmp/.npm

# Include global arg in this stage of the build
ARG FUNCTION_DIR

RUN useradd chrome

# Set working directory to function root directory
WORKDIR ${FUNCTION_DIR}

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium

# Copy in the built dependencies
COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}
# RUN chown -R chrome:chrome ${WORKDIR_PATH}

USER chrome
WORKDIR ${WORKDIR_PATH}

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

ENV CHROMIUM_FLAGS="--disable-software-rasterizer --disable-dev-shm-usage"

# Set runtime interface client as default command for the container runtime
ENTRYPOINT ["/usr/local/bin/npx", "aws-lambda-ric"]
# Pass the name of the function handler as an argument to the runtime
CMD ["index.handler"]
