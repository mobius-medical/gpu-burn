cmake_minimum_required(VERSION 3.18)

if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
  set(CMAKE_CUDA_ARCHITECTURES 30)
endif()

project(cuda_memtest LANGUAGES CUDA CXX)

find_package(Threads REQUIRED)
# list(APPEND LIBS ${CMAKE_THREAD_LIBS_INIT})

# if(NOT CMAKE_THREAD_LIBS_INIT)
#     list(APPEND LIBS "-pthread")
# endif()

# set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -Xcompiler=-pthread")

add_executable(gpu_burn
    compare.cu
    gpu_brun-drv.cpp
)

# target_link_libraries(cuda_memtest STATIC cuda ${LIBS})
target_link_libraries(gpu_burn STATIC ${CUDA_LIBRARIES} ${CUDA_CUBLAS_LIBRARIES})

# install(TARGETS cuda_memtest RUNTIME DESTINATION bin)
