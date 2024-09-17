ARG CUDA_VERSION=11.2.2
ARG IMAGE_DISTRO=ubuntu16.04


FROM nvidia/cuda:${CUDA_VERSION}-devel-${IMAGE_DISTRO} AS builder
WORKDIR /build
COPY . /build/
RUN make


FROM scratch as exporter
COPY --from=builder /build/gpu_burn /
COPY --from=builder /build/compare.ptx /


FROM nvidia/cuda:${CUDA_VERSION}-runtime-${IMAGE_DISTRO}
COPY --from=exporter / /app/
WORKDIR /app
CMD ["./gpu_burn", "60"]
