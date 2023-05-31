MOPS_PKGS=$(shell mops sources)

all: mops test

mops: 
	mops install

test:
	moc $(MOPS_PKGS) -wasi-system-api seiran128.mo && wasmtime seiran128.wasm
