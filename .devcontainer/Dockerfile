FROM ubuntu:24.04

# Set the locale.
ENV LANG=C.UTF-8

ENV DEBIAN_FRONTEND=noninteractive

ARG ARM_COMPILER_VERSION=13.3.rel1
ARG ARM_COMPILER_PATH=/opt/arm

RUN apt-get clean && apt-get update -y && \
    apt-get install -y \
        make \
        wget \
        xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Download & install arm compiler
RUN wget -O /tmp/arm-gnu-none-eabi-${ARM_COMPILER_VERSION}.tar.xz \
    "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_COMPILER_VERSION}/binrel/arm-gnu-toolchain-${ARM_COMPILER_VERSION}-x86_64-arm-none-eabi.tar.xz"

# Create a directory for the compiler and extract the tar.xz file
RUN mkdir -p ${ARM_COMPILER_PATH} && \
    tar -xJf /tmp/arm-gnu-none-eabi-${ARM_COMPILER_VERSION}.tar.xz -C ${ARM_COMPILER_PATH} --strip-components=1 && \
    rm /tmp/arm-gnu-none-eabi-${ARM_COMPILER_VERSION}.tar.xz
