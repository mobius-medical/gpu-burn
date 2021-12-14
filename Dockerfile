ARG CUDA_VERSION=10.0
ARG UBUNTU_VERSION=16.04
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu${UBUNTU_VERSION} AS build-stage

WORKDIR /build
COPY . /build/
RUN make


FROM scratch as export-stage
COPY --from=build-stage /build/gpu_burn /
COPY --from=build-stage /build/compare.ptx /


FROM nvidia/cuda:${CUDA_VERSION}-runtime-ubuntu${UBUNTU_VERSION}
COPY --from=artifact / /app/
WORKDIR /app
CMD ["./gpu_burn", "60"]
