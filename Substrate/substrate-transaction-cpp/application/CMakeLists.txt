cmake_minimum_required(VERSION 3.10)

project(substrate-transaction-cpp C CXX)

# Set compiler flags
set(CMAKE_C_FLAGS "-g")
# set(CMAKE_BUILD_TYPE Debug)
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

set (WEBSOCKETPP_BOOST_LIBS system thread)
set (Boost_FIND_REQUIRED TRUE)
set (Boost_FIND_QUIETLY TRUE)
set (Boost_DEBUG FALSE)
set (Boost_USE_MULTITHREADED TRUE)
set (Boost_ADDITIONAL_VERSIONS "1.39.0" "1.40.0" "1.41.0" "1.42.0" "1.43.0" "1.44.0" "1.46.1") # todo: someone who knows better specify these!
find_package (Boost 1.39.0 COMPONENTS ${WEBSOCKETPP_BOOST_LIBS})
if (NOT Boost_FOUND)
    message (FATAL_ERROR "Failed to find required dependency: boost")
endif ()

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

find_package(OpenSSL REQUIRED)
include_directories (${OPENSSL_INCLUDE_DIR})

# LINK_DIRECTORIES("/usr/lib/polkacpp")
# include_directories ("/usr/include/polkacpp")
# include_directories (${Boost_INCLUDE_DIR})

# set(XXHASH_BUILD_ENABLE_INLINE_API OFF) #optional
# add_subdirectory(xxHash-0.8.0/cmake_unofficial xxHash/build/ EXCLUDE_FROM_ALL)

# set(DEPENDENCY_LIBS  ${Boost_LIBRARIES} ${OPENSSL_SSL_LIBRARY} ${OPENSSL_CRYPTO_LIBRARY} Threads::Threads sr25519crust dl xxHash::xxhash) 
set(DEPENDENCY_LIBS  ${Boost_LIBRARIES} ${OPENSSL_SSL_LIBRARY} ${OPENSSL_CRYPTO_LIBRARY} Threads::Threads sr25519crust dl) 

# add the executable
add_executable(substrate-transaction-cpp main.cpp)

target_link_libraries(substrate-transaction-cpp  /usr/lib/polkacpp/libpolkacpp.a )
target_link_libraries(substrate-transaction-cpp  ${DEPENDENCY_LIBS} )