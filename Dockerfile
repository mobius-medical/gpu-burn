FROM nvidia/cuda:11.1.1-devel AS build-stage

WORKDIR /build
COPY . /build/
RUN make

RUN mkdir /build/libs
RUN ldd ./gpu_burn | grep "=> /" | awk '{print $3}' | xargs -I '{}' cp -v '{}' /build/libs


FROM scratch as export-stage
COPY --from=build-stage /build/gpu_burn /
COPY --from=build-stage /build/compare.ptx /
COPY --from=build-stage /build/run_gpu_burn /
COPY --from=build-stage /build/libs /libs


FROM nvidia/cuda:11.1.1-runtime
COPY --from=artifact / /app/
WORKDIR /app
CMD ["./gpu_burn", "60"]
