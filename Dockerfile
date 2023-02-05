FROM docker/for-desktop-kernel:5.10.25-6594e668feec68f102a58011bb42bd5dc07a7a9b AS ksrc
# https://hub.docker.com/r/docker/for-desktop-kernel/tags
# https://developer.aliyun.com/article/798714
# https://github.com/denverdino/trace-runner-for-docker-desktop

FROM ubuntu:22.04
# docker buildx build -t feicong-ebpf-env-2204 -f Dockerfile .
# docker run -it --rm --privileged --cap-add=ALL -v /lib/modules:/lib/modules:ro -v /etc/localtime:/etc/localtime:ro --pid=host feicong-ebpf-env-2204
WORKDIR /
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

RUN apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt install -y wget lsb-release software-properties-common kmod python3-bpfcc vim bpftrace bison build-essential cmake flex git libedit-dev \
  libcap-dev zlib1g-dev libelf-dev libfl-dev python3 python3-pip python3-dev clang libclang-dev libbfd-dev

# RUN apt install -y wget lsb-release software-properties-common && wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh
# RUN ./llvm.sh 14
# ENV PATH "$PATH:/usr/lib/llvm-14/bin"

# RUN git clone https://github.com/iovisor/bcc.git && \
#     mkdir bcc/build && \
#     cd bcc/build && \
#     cmake .. && \
#     make && \
#     make install && \
#     cmake -DPYTHON_CMD=python3 .. && \
#     cd src/python/ && \
#     make && \
#     make install

# COPY hello_world.py /root

WORKDIR /root
CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash
