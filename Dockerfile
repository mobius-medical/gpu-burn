FROM nvidia/cuda:9.1-devel-ubuntu16.04 AS builder
# FROM nvidia/cuda:11.1.1-devel AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    lsb-release
    
# Setup CMake (KitWare) PPA
RUN curl https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
    | gpg --dearmor - > /usr/share/keyrings/kitware-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(lsb_release -sc) main" \
    > /etc/apt/sources.list.d/cmake.list

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    cmake-data \
    # cmake=3.19.5-0kitware1 \
    # cmake-data=3.19.5-0kitware1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . /src/

WORKDIR /build/
RUN cmake ../src
RUN cmake --build .
# RUN nvcc ../src/t1752.cu -o t1752 -lcublas_static -lcublasLt_static -lculibos
RUN nvcc ../src/t1752.cu -o t1752 -lcublas_static -lculibos


FROM scratch as artifact
COPY --from=builder /build/gpu_burn /
COPY --from=builder /build/CMakeFiles/compare.ptx.dir/compare.ptx /
COPY --from=builder /build/t1752 /

FROM nvidia/cuda:11.1.1-runtime
COPY --from=artifact / /app/
WORKDIR /app
CMD ["./gpu_burn", "60"]
