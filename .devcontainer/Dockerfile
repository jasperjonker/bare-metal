FROM ubuntu:22.04

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG ARM_COMPILER_VERSION=13.3.rel1

# Set the locale.
ENV LANG=C.UTF-8

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Add ARM compiler to path
ENV ARM_COMPILER_PATH=/opt/arm/${ARM_COMPILER_VERSION}
ENV PATH=${ARM_COMPILER_PATH}/bin:$PATH

RUN apt-get clean && apt-get update -y && \
    apt-get install -y --no-install-recommends \
        make \
        wget \
        ca-certificates \
        xz-utils \
        stlink-tools \
        libnewlib-arm-none-eabi \
        git \
        zsh \
        ssh \
        gdb \
        libncursesw5 \
        sudo \
        gnupg2 && \
    rm -rf /var/lib/apt/lists/* && \
    # Add sudo support
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Download & install arm compiler
RUN wget -O /tmp/arm-gnu-none-eabi-${ARM_COMPILER_VERSION}.tar.xz \
    "https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_COMPILER_VERSION}/binrel/arm-gnu-toolchain-${ARM_COMPILER_VERSION}-x86_64-arm-none-eabi.tar.xz"

# Create a directory for the compiler and extract the tar.xz file
RUN mkdir -p ${ARM_COMPILER_PATH} && \
    tar -xJf /tmp/arm-gnu-none-eabi-${ARM_COMPILER_VERSION}.tar.xz -C ${ARM_COMPILER_PATH} --strip-components=1 && \
    rm /tmp/arm-gnu-none-eabi-${ARM_COMPILER_VERSION}.tar.xz

# NOTE: All user configuration (e.g. zshrc, nvim) should be done using dotfiles and added to vscode settings.json

# Create a user. This can be removed in ubuntu 24.04, as ubuntu is default user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Set default username
USER $USERNAME
