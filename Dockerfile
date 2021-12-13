FROM nvidia/cuda:11.1.1-devel AS builder

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



FROM scratch as artifact
COPY --from=builder /build/gpu_burn /



FROM nvidia/cuda:11.1.1-runtime
COPY --from=artifact / /app/
WORKDIR /app
CMD ["./gpu_burn", "60"]
