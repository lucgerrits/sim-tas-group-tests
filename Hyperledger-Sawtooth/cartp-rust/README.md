# cartp in Rust


## Deps for local builds

- sudo apt install libzmq3-dev
- sudo apt install protobuf-compiler

<!-- curl -XPOST "http://localhost:8086/query" --data-urlencode "q=CREATE DATABASE metrics" -u admin:admin -->

<!-- sudo -u $USER ./build.sh && docker-compose -f docker-compose-local-test.yaml up -->
<!-- docker-compose -f docker-compose-local-test.yaml down -->

<!-- docker-compose -f docker-compose-local-test.yaml down && sudo -u $USER ./build.sh && docker-compose -f docker-compose-local-test.yaml up --scale cartp-tp-rust-0=10 --scale cartp-tp-rust-1=10 --scale cartp-tp-rust-2=10 --scale cartp-tp-rust-3=10 --scale cartp-tp-rust-4=10 -->

<!-- docker build -f examples/cartp_rust/Dockerfile -t projetsim/cartp-tp-rust . -->