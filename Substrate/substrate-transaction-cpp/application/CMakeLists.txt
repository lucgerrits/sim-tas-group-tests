cmake_minimum_required(VERSION 3.10)

project(substrate-transaction-cpp C CXX)

# Set compiler flags
set(CMAKE_C_FLAGS "-g")
set(CMAKE_BUILD_TYPE Debug)
if (CMAKE_VERSION VERSION_LESS "3.1")
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")
	endif ()
else ()
    set (CMAKE_CXX_STANDARD 11)
endif ()

# set(CURL_LIBRARY "-lcurl") 
# find_package(CURL REQUIRED)
# include_directories(${CURL_INCLUDE_DIR})

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_package(OpenSSL REQUIRED)
include_directories (${OPENSSL_INCLUDE_DIR})

# set(DEPENDENCY_LIBS ${Boost_LIBRARIES} ${OPENSSL_SSL_LIBRARY} ${OPENSSL_CRYPTO_LIBRARY} Threads::Threads sr25519crust dl) 
set(DEPENDENCY_LIBS ${OPENSSL_SSL_LIBRARY} ${OPENSSL_CRYPTO_LIBRARY} Threads::Threads sr25519crust dl) 


# add the executable
add_executable(substrate-transaction-cpp main.cpp)

target_link_libraries(substrate-transaction-cpp /usr/lib/polkacpp/libpolkacpp.a)
target_link_libraries(substrate-transaction-cpp  ${DEPENDENCY_LIBS} )