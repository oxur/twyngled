BIN_DIR = ./bin
BIN = target/release/noise

default: all

all: deps build test demos

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

test:
	@RUST_BACKTRACE=1 cargo test

demos:
	@cargo run --example=demo

deps:
	@cargo update

publish:
	@cargo publish
