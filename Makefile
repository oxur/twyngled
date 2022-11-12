default: all

all: deps build test demos

auth:
	@echo "Copy and paste the following in the terminal where you"
	@echo "will be executing cargo commands:"
	@echo
	@echo '    eval $$(ssh-agent -s) && ssh-add'
	@echo

build:
	@cargo build

test:
	@RUST_BACKTRACE=1 cargo test

demos:
	@cargo run --example=demo

deps:
	@cargo update

publish:
	@cargo publish
