FROM mcr.microsoft.com/vscode/devcontainers/base:0-bullseye

RUN echo "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-15 main" >> /etc/apt/sources.list\
 && curl -sL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -\
 && apt-get update\
 && apt-get -y install --no-install-recommends\
    llvm-15-dev\
    libclang-15-dev\
    clang-15\
    liblld-15-dev\
    zlib1g-dev \
    cmake\
    make\
    gdb\
    strace\
    valgrind
