MOPS_PKGS=$(shell mops sources)

all: mops seiran-test sfc-test

mops: 
	mops install

seiran-test:
	moc $(MOPS_PKGS) -wasi-system-api seiran128.mo && wasmtime seiran128.wasm

sfc-test:
	moc $(MOPS_PKGS) -wasi-system-api sfc.mo && wasmtime sfc.wasm
