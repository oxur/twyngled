PROJ = twyngled
BIN_DIR = ./bin
BIN = target/release/$(PROJ)

default: all

all: clean deps build lint test examples

auth:
	@echo "Copy and paste the following in the terminal where you"
	@echo "will be executing cargo commands:"
	@echo
	@echo '    eval $$(ssh-agent -s) && ssh-add'
	@echo

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

build: $(BIN_DIR)
	@cargo build --release
	@rm -f $(BIN_DIR)/*
	@cargo install --path . --root .

clean:
	@cargo clean
	@rm -f $(BIN_DIR)/$(PROJ)

clean-all: clean
	@rm .crates.toml .crates2.json Cargo.lock

fresh-all: clean-all all

fresh: clean all

lint:
	@cargo +nightly clippy --version
	@cargo +nightly clippy --all-targets --all-features -- --no-deps -D clippy::all

cicd-lint:
	@cargo clippy --version
	@cargo clippy --all-targets --all-features -- --no-deps -D clippy::all

check:
	@cargo deny check
	@cargo +nightly udeps

test:
	@RUST_BACKTRACE=1 cargo test

examples:
	@cargo run --example=demo

deps:
	@cargo update

publish:
	@cargo publish

nightly:
	@rustup toolchain install nightly

install-cargo-deny:
	@echo ">> Installing cargo deny ..."
	@cargo install --locked cargo-deny

setup-cargo-deny: install-cargo-deny
	@echo ">> Setting up cargo deny ..."
	@cargo deny init

install-udeps:
	@echo ">> Setting up cargo udeps ..."
	@cargo install cargo-udeps --locked
