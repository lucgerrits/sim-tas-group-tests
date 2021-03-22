FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install curl
RUN apt-get -y install git
RUN apt-get -y install g++
RUN apt-get -y install libssl-dev
RUN apt-get -y install build-essential 
RUN apt-get -y install libboost-all-dev
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install cmake

# build polkdot deps manually
#ENV to solve deps issue with rust compiler
WORKDIR /root/
RUN git clone https://github.com/zaphoyd/websocketpp wpp
RUN rm -rf /usr/local/include/websocketpp
RUN mv wpp/websocketpp /usr/local/include/websocketpp
RUN git clone https://github.com/Warchant/sr25519-crust.git sr25519
WORKDIR /root/sr25519
RUN git checkout e86eeea0508038efb1ab7d7fe4a8cb79b4cd6152
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup install nightly
RUN rustup default nightly
RUN mkdir build
WORKDIR /root/sr25519/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make install


######################build polkadot api cpp
COPY ./application/ /substrate-transaction-cpp/
WORKDIR /substrate-transaction-cpp/polkadot_api_cpp/
RUN cmake .
RUN make
RUN make install
RUN make clip
######################end build polkadot api cpp

#build application
WORKDIR /substrate-transaction-cpp/


CMD echo "substrate-transaction-cpp build OK"